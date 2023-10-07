import 'package:flutter/material.dart';
import 'package:llegaexpress/models/recharge/load_pay_safe_response.dart';
import 'package:llegaexpress/screens/recharge/paysafecash_results.dart';
import 'package:llegaexpress/services/recharge_services.dart';
import 'package:llegaexpress/services/system_errors.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySafeCashLoadForm extends StatefulWidget {
  const PaySafeCashLoadForm({Key? key}) : super(key: key);

  @override
  _PaySafeCashLoadFormState createState() => _PaySafeCashLoadFormState();
}

class _PaySafeCashLoadFormState extends State<PaySafeCashLoadForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  String amount = '0';
  bool isProcessing = false;

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
    final prefs = await SharedPreferences.getInstance();
    if (json['ErrorCode'] == 0) {
      LoadPaySafeResponse loadPaySafeResponse =
          LoadPaySafeResponse.fromJson(json);
      prefs.setString('paySafeAmount', amount);
      prefs.setString('paySafeToken', loadPaySafeResponse!.Token.toString());
      setState(() {
        isProcessing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaySafeCashResults(loadPaySafeResponse: loadPaySafeResponse),
        ),
      );
    } else {
      String errorMessage = await SystemErrors.getSystemError(0);
      _showErrorResponse(context, errorMessage);
      _resetForm();
    }
  }

  //Reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _amountController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    amount = _amountController.text;
    await RechargeServices.getLoadPaySafeCodeRequest(_amountController.text)
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgrounds/reload_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Monto *'),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _amountController,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 15.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Visibility(
                            child: OptionButton(
                                label: 'Solicitar Codigo',
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _executeTransaction(context);
                                  }
                                }),
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
                        top: screenHeight - 220.0,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 150.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                ),
              ),
              height: screenHeight,
              width: screenWidth,
            ),
          ),
        ),
      ),
    );
  }
}
