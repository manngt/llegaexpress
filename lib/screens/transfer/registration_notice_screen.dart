import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/transfer/foreign_registration_form.dart';

class RegistrationNotice extends StatefulWidget {
  const RegistrationNotice({Key? key}) : super(key: key);

  @override
  _RegistrationNoticeState createState() => _RegistrationNoticeState();
}

class _RegistrationNoticeState extends State<RegistrationNotice> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: 250,
                child: Image.asset('images/logos/tigo_money_logo.png'),
              ),
              top: 100.0,
              left: (screenWidth - 250) / 2,
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(left: 70.0),
                decoration: const BoxDecoration(
                    color: Color(0xfff0d2438),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                width: 400,
                height: 400,
                child: Stack(
                  children: [
                    const Positioned(
                      child: SizedBox(
                        child: Text(
                          '¡Transfier Dinero!',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      top: 20.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'Para mandar dinero la cuenta en Guatemala debe estar registrada en Tigo Money.',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 75.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'La transferenica será inmediata y llegará a la aplicación Tigo Money',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 125.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'Se podrá retirar el dinero en cualquier cajero 5B',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 175.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'Se podrá retirar el dinero en cualquier cajero 5B',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 175.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForeignRegistrationForm(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          width: 180,
                          child: Text(
                            'Puedes ayudar a alguien en Guatemala a crear su cuenta\n haciendo click aqui.',
                            style:
                                TextStyle(color: Colors.amber, fontSize: 12.0),
                          ),
                        ),
                      ),
                      top: 215.0,
                      left: 75.0,
                    ),
                  ],
                ),
              ),
              top: 200.0,
              left: -70,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForeignRegistrationForm(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 50,
                  child: Image.asset('images/icons/boton_forward_75x75.png'),
                ),
              ),
              top: 500.0,
              left: 250.0,
            ),
          ],
        ),
      ),
    );
  }
}
