import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/registration_success_response.dart';
import 'package:llegaexpress/screens/forms/registrarion_results_screen.dart';
import 'package:llegaexpress/services/general_services.dart';
import 'package:llegaexpress/services/system_errors.dart';
import 'package:llegaexpress/widgets/option_button.dart';

class ForeignRegistrationForm extends StatefulWidget {
  const ForeignRegistrationForm({Key? key}) : super(key: key);

  @override
  _ForeignRegistrationFormState createState() =>
      _ForeignRegistrationFormState();
}

class _ForeignRegistrationFormState extends State<ForeignRegistrationForm>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _identificationNumberController = TextEditingController();
  final _emailController = TextEditingController();
  bool isProcessing = false;
  bool termsConditionAccepted = false;
  bool registrationDone = false;
  final String countryAlpha3 = 'GTM';
  final String documentType = 'DN';

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
      termsConditionAccepted = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getForeignCustomerRegistration(
            _firstNameController.text,
            _lastNameController.text,
            _mobileNumberController.text,
            _emailController.text,
            countryAlpha3,
            documentType,
            _identificationNumberController.text)
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
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
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
                              height: 30.0,
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
                              child: Text("Guatemala"),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 15.0),
                              width: 250,
                            ),
                            Container(
                              child: Text("DPI"),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 15.0),
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
                            OptionButton(
                                label: 'Registrar',
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _executeTransaction(context);
                                  }
                                }),
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        height: screenHeight,
                        width: screenWidth * 0.95,
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
                      top: screenHeight - 150.0,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
