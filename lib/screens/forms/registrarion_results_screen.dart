import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/registration_success_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';

class RegistrationResultsScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const RegistrationResultsScreen(
      {Key? key, @required this.registrationSuccessResponse})
      : super(key: key);

  @override
  _RegistrationResultsScreenState createState() =>
      _RegistrationResultsScreenState(
          registrationSuccessResponse: this.registrationSuccessResponse);
}

class _RegistrationResultsScreenState extends State<RegistrationResultsScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _RegistrationResultsScreenState(
      {Key? key, @required this.registrationSuccessResponse});

  bool isGT = false;
  bool isUS = false;

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

  @override
  void initState() {
    _getCountryScope();
    super.initState();
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/backgrounds/white_background.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: screenWidth * 0.45,
                child: Image.asset('images/logos/llega_logo_azul_300x100.png'),
              ),
              Container(
                width: screenWidth * 0.90,
                height: 250,
                decoration: const BoxDecoration(
                    color: Color(0xFF0d2438),
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                margin: EdgeInsets.only(
                    left: screenWidth * 0.10,
                    right: screenWidth * 0.10,
                    top: 10.0),
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'Datos de la cuenta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      color: Colors.white,
                      height: 2.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
                      child: const Text(
                        'GUARDA ESTOS DATOS, SON PARA TU USO EXCLUSIVAMENTE',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'ID Usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${registrationSuccessResponse!.cHolderId}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'No. Cuenta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${registrationSuccessResponse!.cardNo}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'No. Celular',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${registrationSuccessResponse!.userId}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'PIN de Acceso',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${registrationSuccessResponse!.password}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
            ],
          ),
        ),
        floatingActionButton: ExitFloatingActionButton(
          context: context,
        ),
      ),
    );
  }
}
