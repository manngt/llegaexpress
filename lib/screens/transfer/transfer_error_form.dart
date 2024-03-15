import 'package:flutter/material.dart';

class TransferErrorForm extends StatelessWidget {
  final int errorCode;

  TransferErrorForm({
    required this.errorCode,
  });

  // Define a map of error codes to error messages
  static Map<int, String> errorMessages = {
    0: 'No error',
    14: 'No. de Tarjeta no válido.',
    13: 'Monto Invalido',
    16: 'Seleccion Invalida Contrato ya Registrado',
    15: 'Emisor NO existe/Denegada',
    20: 'Solicitud excede limite diario de cargas',
    24: 'El receptor debe terminar afiliacion a TigoMoney',
    25: 'NO esta autorizado para realizar esta transaccion',
    51: 'Fondos Insuficientes  / Declinada',
    // Add more error codes and messages as needed
  };

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    String errorMessage = errorMessages.containsKey(errorCode)
        ? errorMessages[errorCode]!
        : 'Unknown error';

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
                      child: Text(
                        'Error Code: $errorCode',
                        style: TextStyle(color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      color: Colors.white,
                      height: 2.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Error Message: $errorMessage',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
                      child: Text(
                        '${DateTime.now().toLocal()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add any action you want to perform when the user clicks a button.
                  // For example, you can navigate back to a previous screen.
                  Navigator.pop(context);
                },
                child: Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

