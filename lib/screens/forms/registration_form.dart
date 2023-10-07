import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:llegaexpress/models/country.dart';
import 'package:llegaexpress/models/document_type.dart';
import 'package:llegaexpress/models/general/registration_success_response.dart';
import 'package:llegaexpress/screens/forms/registrarion_results_screen.dart';
import 'package:llegaexpress/services/general_services.dart';
import 'package:llegaexpress/services/system_errors.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

_openURL() async {
  Uri url = Uri.parse('https://gpspay.io/spa/xcmo/securew/TERMINOS_Y_CONDICIONES_GENERALES_DEL_SISTEMA_GPS.PDF');
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _identificationNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _cardPIN1Controller = TextEditingController();
  final _cardPIN2Controller = TextEditingController();

  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;
  bool termsConditionAccepted = false;
  bool registrationDone = false;

  List<Country> countries = <Country>[];
  List<DocumentType> documentTypes = <DocumentType>[];
  Country? selectedCountry;
  DocumentType? selectedDocumentType;

  RegistrationSuccessResponse registrationSuccessResponse =
      RegistrationSuccessResponse();

  _showErrorResponse(BuildContext context, String errorMessage) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  margin: const EdgeInsets.only(left: 40.0),
                ),
                ElevatedButton(
                  child: const Text('Cerrar'),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0XFF0E325F),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //Check response
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      RegistrationSuccessResponse registrationSuccessResponse =
          RegistrationSuccessResponse.fromJson(json);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationResultsScreen(
                  registrationSuccessResponse: registrationSuccessResponse)));
    } else {
      String errorMessage =
          await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _emailController.text = '';
      _mobileNumberController.text = '';
      _lastNameController.text = '';
      _firstNameController.text = '';
      _cardPIN1Controller.text = '';
      _cardPIN2Controller.text = '';
      termsConditionAccepted = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getCustomerRegistration(
            _firstNameController.text,
            _lastNameController.text,
            _mobileNumberController.text,
            _emailController.text,
            selectedCountry!.alpha3.toString(),
            selectedDocumentType!.ID.toString(),
            _identificationNumberController.text,
            _cardPIN1Controller.text,
            _cardPIN2Controller.text)
        .then((response) => {
              if (response['ErrorCode'] != null)
                {
                  _checkResponse(context, response),
                }
            })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      _resetForm();
    });
    _resetForm();
  }

  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
      });
    }
  }

  //functions for data pickers
  _loadCountries() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/countries.json');
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        Country country = Country.fromJson(jsonResult[i]);
        countries.add(country);
      }
    });
  }

  _loadDocumentTypes() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/document_types.json");
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        DocumentType documentType = DocumentType.fromJson(jsonResult[i]);
        documentTypes.add(documentType);
      }
    });
  }

  @override
  void initState() {
    _loadCountries();
    _loadDocumentTypes();
    _getCountryScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'images/backgrounds/white_without_logo_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: scaffoldStateKey,
          body: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      child: ListView(
                        children: [
                          const Center(
                            child: Text(
                              'Nueva Cuenta',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color(0xFF0e2338),
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nombres *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _firstNameController,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Apellidos *',
                                errorStyle: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _lastNameController,
                            ),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Teléfono *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _mobileNumberController,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Correo Electrónico *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _emailController,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 5.0),
                          ),
                          Container(
                            child: DropdownButton<Country>(
                              hint: const Text('¿En qué país te encuentras?'),
                              value: selectedCountry,
                              onChanged: (Country? value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                              items: countries.map((Country country) {
                                return DropdownMenuItem<Country>(
                                  value: country,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    width: 250,
                                    child: Text(
                                      country.name.toString(),
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "NanumGothic Bold",
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                            width: 250,
                          ),
                          Container(
                            child: DropdownButton<DocumentType>(
                              hint: const Text('Tipo de documento'),
                              value: selectedDocumentType,
                              onChanged: (DocumentType? value) {
                                setState(() {
                                  selectedDocumentType = value;
                                });
                              },
                              items: documentTypes
                                  .map((DocumentType documentType) {
                                return DropdownMenuItem<DocumentType>(
                                  value: documentType,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    width: 250,
                                    child: Text(
                                      '${documentType.ID} ${documentType.description}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "NanumGothic Bold",
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                            width: 250,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Número de DPI o Pasaporte *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _identificationNumberController,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Crea tu PIN de ingreso de 4 digitos *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.phone,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                if (value.length < 4) {
                                  return 'Mínimo 4 caracteres';
                                }
                                if (value.length > 4) {
                                  return 'Máximo 4 caracteres';
                                }
                              },
                              controller: _cardPIN1Controller,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Repetir tu PIN de ingreso *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.phone,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                if (value.length < 4) {
                                  return 'Mínimo 4 caracteres';
                                }
                                if (value.length > 4) {
                                  return 'Máximo 4 caracteres';
                                }
                                if (_cardPIN1Controller.text !=
                                    _cardPIN2Controller.text) {
                                  return 'PIN de Acceso no coincide';
                                }
                              },
                              controller: _cardPIN2Controller,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: termsConditionAccepted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      termsConditionAccepted = value!;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: _openURL, // Define your _openURL function for handling the tap event
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(
                                      'Yo acepto los Terminos y \n Condicones del Titular de la Cuenta',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 90.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),

                          Visibility(
                            child: OptionButton(
                                label: 'Registrarse',
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _executeTransaction(context);
                                  }
                                }),
                            visible: !isProcessing && termsConditionAccepted,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      height: screenHeight,
                      width: screenWidth,
                    ),
                    top: 50.0,
                  ),
                  Positioned(
                    child: Visibility(
                      child: Container(
                        child: const Text(
                          'Procesando...',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        decoration: const BoxDecoration(color: Colors.grey),
                        height: 50.0,
                        width: screenWidth,
                        padding: const EdgeInsets.all(10.0),
                      ),
                      visible: isProcessing,
                    ),
                    top: screenHeight - 130.0,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
