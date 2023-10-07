import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/authorization_response.dart';
import 'package:llegaexpress/models/recharge/load_pay_safe_response.dart';
import 'package:llegaexpress/screens/recharge/paysafe_request_results.dart';
import 'package:llegaexpress/screens/recharge/paysafecash_results.dart';
import 'package:llegaexpress/services/recharge_services.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:llegaexpress/services/system_errors.dart';

class PaySafeCashRequestForm extends StatefulWidget {
  const PaySafeCashRequestForm({Key? key}) : super(key: key);

  @override
  _PaySafeCashRequestFormState createState() => _PaySafeCashRequestFormState();
}

class _PaySafeCashRequestFormState extends State<PaySafeCashRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  final _depositTokenController = TextEditingController();
  bool isProcessing = false;

  bool _amountTextFieldEnabled = false;
  bool _tokenFieldEnabled = false;
  bool _sendButtonEnabled = false;
  AuthorizationResponse? authorizationResponse;

  //Load token and amount values
  _loadFormValues() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('paySafeAmount') != null) {
      setState(() {
        _amountController.text = prefs.getString('paySafeAmount').toString();
        _amountTextFieldEnabled = true;
      });
    }

    if (prefs.getString('paySafeToken') != null) {
      setState(() {
        _depositTokenController.text =
            prefs.getString('paySafeToken').toString();
        _tokenFieldEnabled = true;
      });
    }
    if (_amountTextFieldEnabled && _tokenFieldEnabled) {
      setState(() {
        _sendButtonEnabled = true;
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
    if (json['ErrorCode'] == 0) {
      AuthorizationResponse authorizationResponse =
          AuthorizationResponse.fromJson(json);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaySafeRequestResults(
              authorizationResponse: authorizationResponse),
        ),
      );
    } else {
      String errorMessage =
          await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('paySafeAmount') != null) {
      prefs.remove('paySafeAmount');
      _amountTextFieldEnabled = false;
    }
    if (prefs.getString('paySafeToken') != null) {
      prefs.remove('paySafeToken');
      _tokenFieldEnabled = false;
    }
    setState(() {
      isProcessing = false;
      _depositTokenController.text = '';
      _amountController.text = '';
      _amountTextFieldEnabled = false;
      _tokenFieldEnabled = false;
      _sendButtonEnabled = false;
      isProcessing = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
      _sendButtonEnabled = false;
    });
    await RechargeServices.getLoadPaySafeDepositRequest(
            _amountController.text, _depositTokenController.text)
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
  }

  @override
  void initState() {
    _loadFormValues();
    super.initState();
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
                          Visibility(
                            child: Container(
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
                            visible: _amountTextFieldEnabled,
                          ),
                          Visibility(
                            child: Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Token *'),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                },
                                controller: _depositTokenController,
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
                            visible: _tokenFieldEnabled,
                          ),
                          Visibility(
                            child: OptionButton(
                                label: 'Recargar',
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _executeTransaction(context);
                                  }
                                }),
                            visible: _sendButtonEnabled,
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
