import 'package:flutter/material.dart';
import 'package:llegaexpress/models/transfer/tigo_transfer.dart';
import 'package:llegaexpress/models/transfer/tigo_transfer_response.dart';
import 'package:llegaexpress/screens/transfer/foreign_registration_form.dart';
import 'package:llegaexpress/screens/transfer/tigo_transfer_results.dart';
import 'package:llegaexpress/screens/transfer/transfer_type_selection.dart';
import 'package:llegaexpress/services/transfer_services.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:llegaexpress/models/general/login_success_response.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _pinWebController = TextEditingController();

  bool isProcessing = false;

  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  bool isGT = false;
  bool isUS = false;
  bool userDataLoaded = false;

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

  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse(
        errorCode: 0,
        cHolderID: prefs.getInt('cHolderID'),
        userName: prefs.getString('userName'),
        cardNo: prefs.getString('cardNo'),
        currency: prefs.getString('currency'),
        balance: prefs.getString('balance'));
    setState(() {
      clientName = loginSuccessResponse.userName.toString();
      cardNo = loginSuccessResponse.cardNo.toString();
      currency = loginSuccessResponse.currency.toString();
      balance = loginSuccessResponse.balance.toString();
    });
    userDataLoaded = true;
  }

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
      _noteController.text = '';
      _phoneController.text = '';
      _amountController.text = '';
      _pinWebController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await TransferServices.getCardTransferInt(_pinWebController.text,
            _phoneController.text, _amountController.text, _noteController.text)
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

  //Send to transfer advice
  _sendToTransferadvice() {
    TigoTransfer tigoTransfer = TigoTransfer(
        password: _pinWebController.text,
        cardNumber: _phoneController.text,
        amount: _amountController.text,
        notes: _noteController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferTypeSelection(tigoTransfer: tigoTransfer),
      ),
    );
  }

  @override
  void initState() {
    _getUserData();
    _getCountryScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/backgrounds/transfer_background.jpg'),
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
                width: screenHeight,
                height: screenHeight,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        height: screenHeight,
                        width: 350,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 75.0,
                              width: 50.0,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    child: Text(
                                      'Recuerda que para mandar dinero la cuenta \n Guatemala debe estar registrada en: ',
                                      style: TextStyle(
                                          color: Color(0xFF0e2338),
                                          fontWeight: FontWeight.w900),
                                    ),
                                    top: 5.0,
                                    left: 10.0,
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: 75,
                                      child: Image.asset(
                                          'images/logos/tigo_money_logo.png'),
                                    ),
                                    top: 40,
                                    left: 125.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              width: 350.0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    width: 350,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF3b6da8),
                                          Color(0xFF224c96),
                                        ],
                                        stops: [
                                          0.1,
                                          0.9,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'TU SALDO',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0, // Change the text size here
                                            fontFamily: 'Roboto', // Change the font family here
                                            fontWeight: FontWeight.bold, // You can also change the font weight
                                            fontStyle: FontStyle.italic, // You can specify italic style
                                          ),
                                        ),
                                        Text(
                                          '$currency  $balance',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0, // Change the text size here
                                            fontFamily: 'Roboto', // Change the font family here
                                            fontWeight: FontWeight.bold, // You can also change the font weight
                                            fontStyle: FontStyle.italic, // You can specify italic style
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Número teléfono Guatemala Validado *',
                                    errorStyle: TextStyle(
                                      fontSize: 8,
                                    )),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  if (value.length < 8) {
                                    return 'Mínimo 8 caracteres';
                                  }
                                  if (value.length > 8) {
                                    return 'Máximo 8 caracteres';
                                  }
                                },
                                controller: _phoneController,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Monto en dólares (Mínimo USD 5.00) *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  // Convert the entered value to a double
                                  double? amount = double.tryParse(value);
                                  if (amount == null) {
                                    return 'Ingrese un número válido';
                                  }
                                  // Check if the entered amount is less than 5
                                  if (amount < 5) {
                                    return 'El monto debe ser al menos USD 5.00';
                                  }
                                  // Validation passed
                                  return null;
                                },
                                controller: _amountController,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nota *',
                                    errorStyle: TextStyle(
                                      fontSize: 8,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                },
                                controller: _noteController,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'PIN WEB *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  if (value.length < 4) {
                                    return 'Mínimo 4 caracteres';
                                  }
                                  if (value.length > 4) {
                                    return 'Máximo 4 caracteres';
                                  }
                                },
                                controller: _pinWebController,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            OptionButton(
                              label: 'Enviar transferencia',
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  _sendToTransferadvice();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      top: 125.0,
                      left: (screenWidth - 370) / 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: ExitFloatingActionButton(
            context: context,
          ),
        ),
      ),
      onWillPop: () async => true,
    );
  }
}
