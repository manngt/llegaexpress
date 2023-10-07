import 'package:llegaexpress/services/general_services.dart';
import 'package:llegaexpress/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordForm extends StatefulWidget with WidgetsBindingObserver {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  var screenWidth, screenHeight;
  bool isProcessing = false;

  //functions for dialogs
  _showSuccessResponse(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.greenAccent,
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            SizedBox(
                              child: Text(
                                'Resultado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text('Procesado correctamente'),
                              width: 150,
                            ),
                          ],
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 40),
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
          ),
        );
      },
    );
  }

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
      _showSuccessResponse(context);
    } else {
      String errorMessage =
          await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset fomr
  _resetForm() {
    setState(() {
      isProcessing = false;
      _pin2Controller.text = '';
      _pin1Controller.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getPasswordChange(
            _pin1Controller.text, _pin2Controller.text)
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

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _setLastPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar PIN de Acceso'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      key: scaffoldStateKey,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: SizedBox(
            child: SafeArea(
              child: Container(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          child: const Text(
                            'SOLO 4 dígitos',
                            style: TextStyle(
                              fontSize: 24.0, // Adjust the font size as needed
                              color: Colors.red, // Use Colors.red for red color
                              fontWeight: FontWeight.bold, // Add this line to make the text bold
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nuevo PIN de Acceso'),
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
                            controller: _pin1Controller,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Repetir nuevo PIN'),
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
                              if (_pin1Controller.text !=
                                  _pin2Controller.text) {
                                return 'PIN de Acceso no coincide';
                              }
                            },
                            controller: _pin2Controller,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Visibility(
                          child: Container(
                            child: TextButton(
                              child: const Text(
                                'Cambiar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _executeTransaction(context);
                                }
                              },
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0XFF0E325F),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            width: screenWidth,
                          ),
                          visible: !isProcessing,
                        ),
                      ],
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
                margin: const EdgeInsets.only(top: 50.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              ),
            ),
            height: screenHeight,
            width: screenWidth,
          ),
        ),
      ),
    );
  }
}
