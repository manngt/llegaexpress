import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/issue/account_screen.dart';
import 'package:llegaexpress/screens/recharge_screen.dart';
import 'package:llegaexpress/screens/startup_screen.dart';
import 'package:llegaexpress/screens/transfer/transfer_advice.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/general/login_success_response.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({Key? key}) : super(key: key);

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen>
    with WidgetsBindingObserver {
  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String userID = '';
  bool userDataLoaded = false;

  _saveCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('merchantId', 'US_MERCHANT_ID');
    await prefs.setString('token', 'US_MERCHANT_TOKEN');
    await prefs.setString('baseUrl', 'US_BASE_URL');
    await prefs.setString('countryScope', 'US');
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
      userID = prefs.getString('userID').toString();
    });

    userDataLoaded = true;
  }

  _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    Object? nowScanning = prefs.get('isScanning');
    if (nowScanning == false) {
      _cleanPreferences();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const StartupScreen()));
    }
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        _logOut();
        break;

      case AppLifecycleState.resumed:
        _logOut();
        break;

      case AppLifecycleState.inactive:
        _logOut();
        break;

      case AppLifecycleState.detached:
        _logOut();
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _saveCountryScope();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenMiddleHeight = MediaQuery.of(context).size.height / 2;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('images/backgrounds/white_with_log_background.png'),
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
                  child: Column(
                    children: [
                      Text(
                        clientName.toString().toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      userDataLoaded
                          ? Text(
                              '${cardNo[0]} ' +
                                  '${cardNo[1]} ' +
                                  '${cardNo[2]} ' +
                                  '${cardNo[3]}   ' +
                                  '${cardNo[4]} ' +
                                  '${cardNo[5]} ' +
                                  '${cardNo[6]} ' +
                                  '${cardNo[7]}   ' +
                                  '${cardNo[8]} ' +
                                  '${cardNo[9]} ' +
                                  '${cardNo[10]} ' +
                                  '${cardNo[11]}   ' +
                                  '${cardNo[12]} ' +
                                  '${cardNo[13]} ' +
                                  '${cardNo[14]} ' +
                                  '${cardNo[15]}',
                            )
                          : const Text(''),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        margin: const EdgeInsets.only(bottom: 10.0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tu saldo',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '$currency  $balance',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                        child: OptionButton(
                          label: 'Perfil',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                top: 175.0,
                left: (screenWidth - 350.0) / 2,
              ),
              Positioned(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Ink(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                    'images/icons/recharge_icon.png'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RechargeScreen()));
                                },
                                iconSize: 70,
                              ),
                              const Text(
                                'Recargar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          decoration: const ShapeDecoration(
                            color: Color(0xFF0E325F),
                            shape: CircleBorder(),
                          ),
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        height: 130,
                        width: 115,
                      ),
                      Container(
                        child: Ink(
                          child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                    'images/icons/transfer_icon.png'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TransferAdvice(),
                                    ),
                                  );
                                },
                                iconSize: 70,
                              ),
                              const Text(
                                'Transferir',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          decoration: const ShapeDecoration(
                            color: Color(0xFF0E325F),
                            shape: CircleBorder(),
                          ),
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        height: 130,
                        width: 115,
                      ),
                    ],
                  ),
                  height: 150,
                  width: 300,
                ),
                top: screenMiddleHeight + 30.0,
                left: (screenWidth - 300) / 2,
              ),
            ],
          ),
          floatingActionButton: ExitFloatingActionButton(
            context: context,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
