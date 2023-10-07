import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/authorization_response.dart';
import 'package:llegaexpress/services/general_services.dart';
import 'package:llegaexpress/services/system_errors.dart';

class PasswordRecoveryForm extends StatefulWidget {
  const PasswordRecoveryForm({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _identificationNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _birthDateController = TextEditingController();
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
      AuthorizationResponse authorizationResponse =
          AuthorizationResponse.fromJson(json);
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
      _accountNumberController.text = '';
      _mobileNumberController.text = '';
      _birthDateController.text = '';
      _identificationNumberController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getCustomerAccess(
      'DN',
      _identificationNumberController.text,
      _accountNumberController.text,
      _birthDateController.text,
    )
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

  bool isProcessing = false;
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
                              'Recuperar Acceso',
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
                                  hintText: 'DPI *',
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
                                  hintText: 'Numero de DPI o Pasaporte *',
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
                                  hintText: 'Numero de cuenta *',
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
                                  hintText: 'Fecha mm/dd/aaaa *',
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
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _executeTransaction(context);
                              }
                            },
                            child: SizedBox(
                              width: 75.0,
                              child: Image.asset(
                                  'images/icons/boton_forward_75x75.png'),
                            ),
                          )
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
