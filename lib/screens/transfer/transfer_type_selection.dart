import 'package:flutter/material.dart';
import 'package:llegaexpress/models/transfer/tigo_transfer.dart';
import 'package:llegaexpress/models/transfer/tigo_transfer_response.dart';
import 'package:llegaexpress/screens/transfer/foreign_registration_form.dart';
import 'package:llegaexpress/screens/transfer/tigo_transfer_results.dart';
import 'package:llegaexpress/services/transfer_services.dart';

class TransferTypeSelection extends StatefulWidget {
  final TigoTransfer tigoTransfer;
  const TransferTypeSelection({Key? key, required this.tigoTransfer})
      : super(key: key);

  @override
  _TransferTypeSelectionState createState() =>
      _TransferTypeSelectionState(tigoTransfer: tigoTransfer);
}

class _TransferTypeSelectionState extends State<TransferTypeSelection> {
  final TigoTransfer tigoTransfer;
  _TransferTypeSelectionState({Key? key, required this.tigoTransfer});

  bool isProcessing = false;
  //Check response
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      TigoTransferResponse tigoTransferResponse =
          TigoTransferResponse.fromJson(json);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TigoTransferResults(tigoTransferResponse: tigoTransferResponse),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForeignRegistrationForm(),
        ),
      );
    }
  }

  //Reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    String? _password = tigoTransfer.password;
    String? _cardNumber = tigoTransfer.cardNumber;
    String? _amount = tigoTransfer.amount;
    String? _notes = tigoTransfer.notes;

    await TransferServices.getCardTransferInt(
            _password!, _cardNumber!, _amount!, _notes!)
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

  //Execute registration
  _executeTransactionRep(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    String? _password = tigoTransfer.password;
    String? _cardNumber = tigoTransfer.cardNumber;
    String? _amount = tigoTransfer.amount;
    String? _notes = tigoTransfer.notes;

    await TransferServices.getCardPolicyRep(
            _password!, _cardNumber!, _amount!, _notes!)
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
                child: Image.asset('images/logos/tigo_money_logo.png'),
              ),
              SizedBox(
                height: screenHeight * 0.20,
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
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      color: Colors.white,
                      height: 2.0,
                    ),
                    Container(
                      width: 450.0,
                      margin: EdgeInsets.only(top: 20.0, left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            width: 100.0,
                            height: 100.0,
                            child: TextButton(
                              onPressed: () {
                                _executeTransaction(context);
                              },
                              child: const Text(
                                'ENVIO SOLO TRANSFERENCIA',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(59.0))),
                            width: 100.0,
                            height: 100.0,
                            child: TextButton(
                              onPressed: () {
                                _executeTransaction(context);
                              },
                              child: const Text(
                                'ENVIO TRANSFERENCIA Y PAGO REPATRIACION',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
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
