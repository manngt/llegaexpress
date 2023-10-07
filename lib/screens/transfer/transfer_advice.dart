import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/transfer/customer_verify_form.dart';
import 'package:llegaexpress/screens/transfer/transfer_screen.dart';
import 'package:llegaexpress/widgets/icon_option.dart';
import 'package:url_launcher/url_launcher.dart';

_openURL() async {
  Uri url = Uri.parse('https://www.llega.com/_files/ugd/0e7b55_3d6496ef21fe4c5a99be4e94f1c11242.pdf');
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

_openURL2() async {
  Uri url = Uri.parse('https://www.llega.com/_files/ugd/0e7b55_f9c0b139c90a452f842c04e41f33c059.pdf');
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

class TransferAdvice extends StatefulWidget {
  const TransferAdvice({Key? key}) : super(key: key);

  @override
  _TransferAdviceState createState() => _TransferAdviceState();
}

class _TransferAdviceState extends State<TransferAdvice> {
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
                          'Bienvenido a',
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                        ),
                      ),
                      top: 50.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 75.0,
                        child:
                            Image.asset('images/logos/llega_blanco_100x40.png'),
                      ),
                      top: 50.0,
                      left: 220.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          'Permitenos ofrecerte nuestro servicio de ',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 100.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'REPATRIACIÓN',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 115.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          'Cuando tu vas a enviar la transferencia a',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 130.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 50.0,
                        child: Image.asset('images/logos/tigo_money_logo.png'),
                      ),
                      top: 145.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'para que tu familiar la retire',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 145.0,
                      left: 130.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          'en cualquier comercio o en cajero automático',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 160.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          '5B, También puedes enviar tu pago',
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
                          'por la compra del servicio de REPATRIACIÓN',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 190.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          'Estamos respaldados por la RED de',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 230.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 20.0,
                        child:
                            Image.asset('images/logos/cooperatives_logo.png'),
                      ),
                      top: 225.0,
                      left: 275.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 240,
                        child: Text(
                          'Cooperativas Independientes de Guatemala',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 245.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'y por',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      top: 260.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 50.0,
                        child: Image.asset('images/logos/tigo_money_logo.png'),
                      ),
                      top: 260.0,
                      left: 110.0,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: _openURL,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            '1 CARTA BIENVENIDA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      top: 300.0,
                      left: 75.0,
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: _openURL2,
                        child: SizedBox(
                          width: 180,
                          child: Text(
                            '2 CONTRATO DE REPATRIACIÓN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      top: 325.0,
                      left: 75.0,
                    ),
                    const Positioned(
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          'TU DECIDES',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      top: 360.0,
                      left: 175.0,
                    ),
                  ],
                ),
              ),
              top: 200.0,
              left: -70,
            ),
            Positioned(
              child: SizedBox(
                width: 250,
                child: Image.asset('images/icons/bolsa_de_dinero.png'),
              ),
              top: 25.0,
              left: (screenWidth - 250) / 2,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerVerifyForm(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 50,
                  child: Image.asset('images/icons/boton_forward_75x75.png'),
                ),
              ),
              top: 540.0,
              left: 250.0,
            ),
          ],
        ),
      ),
    );
  }
}
