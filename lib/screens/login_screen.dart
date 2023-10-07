import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/forms/password_recovery_form.dart';
import 'package:llegaexpress/screens/principal_screen.dart';
import 'package:llegaexpress/services/general_services.dart';
import 'package:llegaexpress/services/system_errors.dart';
import 'package:llegaexpress/widgets/icon_option.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:llegaexpress/widgets/power_by_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/general/login_success_response.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Variables
  var screenSize,
      screenHeight,
      screenWidth,
      logoLeftDistance,
      startSesionText,
      startSesionTextLeftDistance,
      powerByBottomDistance,
      startSesionLabelLeftDistance;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String userID = '';
  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _openEmail() async {
    final emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'info@llegagt.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Ayuda Email',
        }));
    launchUrl(emailLaunchUri);
  }

  _openURL() async {
    Uri url = Uri.parse('https://wa.me/50236074219');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  _call() async {
    Uri url = Uri.parse('tel:17864754440');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //Load Country Scope
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

  //functions for dialogs
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
      LoginSuccessResponse loginSuccessResponse =
          LoginSuccessResponse.fromJson(json);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('cHolderID', loginSuccessResponse.cHolderID!);
      await prefs.setString('userID', userID);
      await prefs.setString('userName', loginSuccessResponse.userName!);
      await prefs.setString('cardNo', loginSuccessResponse.cardNo!);
      await prefs.setString('currency', loginSuccessResponse.currency!);
      await prefs.setString('balance', loginSuccessResponse.balance!);
      await prefs.setBool('isScanning', false);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PrincipalScreen()));
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
      _userController.text = '';
      _passwordController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
      userID = _userController.text;
    });
    await GeneralServices.getLogin(
            _userController.text, _passwordController.text)
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
  void initState() {
    _getCountryScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getting the size of the device windows
    screenSize = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    logoLeftDistance = (screenWidth - 300) / 2;
    startSesionTextLeftDistance = (screenWidth - 300) / 2;
    powerByBottomDistance = screenHeight - 80;
    startSesionLabelLeftDistance = (screenWidth - 120) / 2;

    return WillPopScope(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'images/backgrounds/blue_triangle_left_background.png'),
                fit: BoxFit.cover),
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
                      child: Image.asset(
                        'images/llega_logo_blanco_1024x1024.png',
                        height: 300,
                        width: 300,
                      ),
                      left: logoLeftDistance,
                    ),
                    Positioned(
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Usuario *',
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 24.0,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _userController,
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Contraseña *',
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 24.0),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _passwordController,
                            ),
                            padding: const EdgeInsets.only(left: 10.0),
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 15.0,
                            ),
                          ),
                          Visibility(
                            visible: !isProcessing,
                            child: OptionButton(
                              label: 'INICIAR SESIÓN',
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  _executeTransaction(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      top: 300,
                      left: startSesionTextLeftDistance,
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
                    Positioned(
                      child: Row(
                        children: [
                          IconOption(
                            img: 'images/icons/help_icon.png',
                            onPress: _call,
                          ),
                          IconOption(
                            img: 'images/icons/whatsapp_icon.png',
                            onPress: _openURL,
                          ),
                          IconOption(
                            img: 'images/icons/email_icon.png',
                            onPress: _openEmail,
                          ),
                        ],
                      ),
                      top: screenHeight - 200,
                      left: (screenWidth - 160) / 2,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordRecoveryForm(),
                            ),
                          );
                        },
                        child: Column(
                          children: const [
                            Text(
                              '¿Olvidaste tu contraseña',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Recuperar tu contraseña aquí.',
                              style: TextStyle(
                                color: Color(0XFF224c96),
                              ),
                            )
                          ],
                        ),
                      ),
                      top: screenHeight - 140,
                      left: (screenWidth - 190) / 2,
                    ),
                    Positioned(
                      child: const PowerByContainer(),
                      top: powerByBottomDistance - 10,
                      left: startSesionTextLeftDistance,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => true);
  }
}
