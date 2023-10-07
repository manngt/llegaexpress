import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/login_success_response.dart';
import 'package:llegaexpress/screens/recharge/paysafecash_load_form.dart';
import 'package:llegaexpress/screens/recharge/paysafecash_request_form.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({Key? key}) : super(key: key);

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen>
    with WidgetsBindingObserver {
  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String cHolderID = '';
  bool isGT = false;
  bool isUS = false;
  bool userDataLoaded = false;

  _showErrorResponse(String errorMessage) {
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

  _openURL() async {
    Uri url = Uri.parse(
        'https://test.bgpay.me/codigos/paysafe/${cHolderID}_codigo.pdf');
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });

      if (response.statusCode == 200) {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch $url';
        }
      } else {
        _showErrorResponse(response.statusCode.toString());
      }
    } catch (e) {
      _showErrorResponse(e.toString());
    }
  }

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
      cHolderID = loginSuccessResponse.cHolderID.toString();
    });
    userDataLoaded = true;
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
    var screenMiddleHeight = MediaQuery.of(context).size.height / 2;

    return WillPopScope(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/backgrounds/reload_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 350.0,
                  child: Image.asset('images/paysafe_banner500x400.png'),
                ),
                top: 100.0,
                left: (screenWidth - 350.0) / 2,
              ),
              Positioned(
                child: Column(
                  children: [
                    OptionButton(
                      label: 'Solicitar Código PaySafe',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaySafeCashLoadForm(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                top: 350,
                left: (screenWidth - 300) / 2,
              ),
              Positioned(
                child: Column(
                  children: [
                    OptionButton(
                      label: 'Mostrar codigo de barra',
                      onPress: () {
                        _openURL();
                      },
                    ),
                  ],
                ),
                top: 410.0,
                left: (screenWidth - 300) / 2,
              ),
              Positioned(
                child: Column(
                  children: [
                    OptionButton(
                      label: 'Solicitar Deposito',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PaySafeCashRequestForm(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                top: 470,
                left: (screenWidth - 300) / 2,
              ),
            ],
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
