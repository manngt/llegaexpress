import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/issue/cancel_account_web_view.dart';
import 'package:llegaexpress/screens/select_country_screen.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';
import 'package:llegaexpress/widgets/global_options_widget.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'issue/card_transactions_form.dart';
import '../models/general/login_success_response.dart';

class ProcedureScreen extends StatefulWidget {
  const ProcedureScreen({Key? key}) : super(key: key);

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen>
    with WidgetsBindingObserver {
  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
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
  }

  _cleanPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cHolderID', 0);
    await prefs.setString('userID', '');
    await prefs.setString('userName', '');
    await prefs.setString('cardNo', '');
    await prefs.setString('currency', '');
    await prefs.setString('balance', '');
    await prefs.setBool('isScanning', false);
  }

  _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    Object? nowScanning = prefs.get('isScanning');
    if (nowScanning == false) {
      _cleanPreferences();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SelectCountryScreen()));
    }
  }

  @override
  void initState() {
    _getUserData();
    _getCountryScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenMiddleHeight = MediaQuery.of(context).size.height / 2;
    var cardLeftDistance = (screenWidth - 325.0) / 2;

    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF0E2238),
        body: SizedBox(
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Text(
                            clientName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          left: 15.0,
                          top: 25.0,
                        ),
                        Positioned(
                            child: Text(
                              cardNo,
                              style: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 5,
                              ),
                            ),
                            left: 25.0,
                            top: 75.0),
                        Positioned(
                            child: Text(
                              '$currency $balance',
                              style: const TextStyle(color: Colors.white),
                            ),
                            left: 15.0,
                            top: 140.0),
                        Positioned(
                          child: SizedBox(
                            child: Image.asset(
                                'images/llegelogoblanco154x154.png'),
                            height: 100.0,
                            width: 100.0,
                          ),
                          left: 200.0,
                          top: 100.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFF0E325F),
                    ),
                    height: 180.0,
                    width: 325.0,
                  ),
                  top: 20.0,
                  left: cardLeftDistance,
                ),
                GlobalOptionsWidget(
                  screenMiddleHeight: screenMiddleHeight,
                  screenWidth: screenWidth,
                  activeGlobalOption: 'procedure',
                ),
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        color: Colors.white,
                      ),
                    ),
                    height: screenMiddleHeight + 50,
                    width: screenWidth,
                  ),
                  top: screenMiddleHeight - 50,
                ),
                Positioned(
                  child: SizedBox(
                    child: Column(
                      children: [
                        OptionButton(
                          label: 'Ver Transacciones',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CardTransactionsForm(),
                              ),
                            );
                          },
                        ),
                        OptionButton(
                          label: 'Cancelar Cuenta',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CancelAccountWebView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    width: 325.0,
                  ),
                  top: screenMiddleHeight - 45,
                  left: cardLeftDistance,
                ),
              ],
            ),
          ),
          height: screenHeight,
          width: screenWidth,
        ),
        floatingActionButton: ExitFloatingActionButton(
          context: context,
        ),
      ),
      onWillPop: () async => true,
    );
  }
}
