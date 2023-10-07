import 'package:flutter/material.dart';
import 'package:llegaexpress/models/transfer/tigo_transfer_response.dart';

class TigoTransferResults extends StatefulWidget {
  final TigoTransferResponse tigoTransferResponse;
  const TigoTransferResults({Key? key, required this.tigoTransferResponse})
      : super(key: key);

  @override
  _TigoTransferResultsState createState() =>
      _TigoTransferResultsState(tigoTransferResponse: tigoTransferResponse);
}

class _TigoTransferResultsState extends State<TigoTransferResults> {
  final TigoTransferResponse tigoTransferResponse;
  _TigoTransferResultsState({Key? key, required this.tigoTransferResponse});
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
              SizedBox(
                height: screenHeight * 0.20,
                child: Image.asset('images/recarga_exitosa_200x300.png'),
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
                      child: Text(
                        'Comprobante de Transferencia: ${tigoTransferResponse.autNo}',
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
                        'Para',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${tigoTransferResponse.transferTo}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'Tasa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${tigoTransferResponse.exRate}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'Monto transferido',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${tigoTransferResponse.transferAmount}',
                        style: const TextStyle(color: Color(0xFF0387c4)),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const Text(
                        'Monto debitado',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${tigoTransferResponse.debitedAmount}',
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
