import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/forms/password_recovery_form.dart';
import 'package:llegaexpress/widgets/icon_option.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:llegaexpress/widgets/power_by_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'forms/registration_form.dart';
import 'login_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with WidgetsBindingObserver {
  //Variables to store Screen dimensions
  var screenSize,
      screenHeight,
      screenWidth,
      logoLeftDistance,
      startSesionText,
      startSesionTextLeftDistance,
      powerByBottomDistance;
  bool isGT = false;
  bool isUS = false;
  double showOptionHeight = 200.0;

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

  _showHelpOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: showOptionHeight,
          color: Colors.greenAccent,
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  '¿Cómo quiere contactarnos?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _openEmail();
                    },
                    icon: const Icon(Icons.attach_email)),
                IconButton(
                    onPressed: () {
                      _openURL();
                    },
                    icon: SizedBox(
                      child: Image.asset('images/icons/whatsapp_logo.png'),
                      height: 75.0,
                      width: 75.0,
                    )),
                isUS
                    ? IconButton(
                        onPressed: () {
                          _call();
                        },
                        icon: const Icon(Icons.phone))
                    : const SizedBox(
                        height: 1.0,
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

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
        showOptionHeight = 200.0;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
        showOptionHeight = 250.0;
      });
    }
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
    powerByBottomDistance = screenHeight - (screenHeight - 10);

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
          body: Stack(
            children: [
              Positioned(
                child: Image.asset(
                  'images/llega_logo_blanco_1024x1024.png',
                  height: 300,
                  width: 300,
                ),
                top: 25,
                left: logoLeftDistance,
              ),
              Positioned(
                child: OptionButton(
                  label: 'Inicio Sesión',
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
                top: 300,
                left: startSesionTextLeftDistance,
              ),
              Positioned(
                child: OptionButton(
                  label: 'Crear Cuenta',
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationForm()));
                  },
                ),
                top: 360,
                left: startSesionTextLeftDistance,
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
                        builder: (context) => const PasswordRecoveryForm(),
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
                bottom: powerByBottomDistance,
                left: startSesionTextLeftDistance,
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
