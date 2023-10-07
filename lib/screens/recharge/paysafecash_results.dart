import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/authorization_response.dart';
import 'package:llegaexpress/models/recharge/load_pay_safe_response.dart';

class PaySafeCashResults extends StatefulWidget {
  final LoadPaySafeResponse loadPaySafeResponse;
  const PaySafeCashResults({Key? key, required this.loadPaySafeResponse})
      : super(key: key);

  @override
  _PaySafeCashResultsState createState() =>
      _PaySafeCashResultsState(loadPaySafeResponse: loadPaySafeResponse);
}

class _PaySafeCashResultsState extends State<PaySafeCashResults> {
  final LoadPaySafeResponse loadPaySafeResponse;
  _PaySafeCashResultsState({Key? key, required this.loadPaySafeResponse});
  @override
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
                        'Comprobante de recarga: ',
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
                      child: Text(
                        '${DateTime.now().toLocal()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'Token',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${loadPaySafeResponse.Token}',
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
      ),
    );
  }
}
