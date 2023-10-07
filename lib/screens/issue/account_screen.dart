import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/login_success_response.dart';
import 'package:llegaexpress/screens/issue/cancel_account_web_view.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  var screenWidth, screenHeight;

  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String userID = '';

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
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _getUserData();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgrounds/white_with_log_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        clientName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black26,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 30.0),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.credit_card,
                            color: Colors.black26,
                          ),
                          Container(
                            child: Text(
                              cardNo,
                              style: const TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0),
                            ),
                            margin: const EdgeInsets.only(left: 30),
                          ),
                        ],
                      ),
                      width: 250,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.black26,
                          ),
                          Container(
                            child: Text(
                              '$currency $balance',
                              style: const TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0),
                            ),
                            margin: const EdgeInsets.only(left: 30),
                          ),
                        ],
                      ),
                      width: 250,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.black26,
                          ),
                          Container(
                            child: Text(
                              userID,
                              style: const TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0),
                            ),
                            margin: const EdgeInsets.only(left: 30),
                          ),
                        ],
                      ),
                      width: 250,
                      margin: const EdgeInsets.only(bottom: 50),
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
                        })
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                width: 325.0,
              ),
              top: screenHeight - 500,
              left: (screenWidth - 325.0) / 2,
            ),
          ],
        ),
      ),
    );
  }
}
