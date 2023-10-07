import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:llegaexpress/models/general/login_success_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CancelAccountWebView extends StatefulWidget {
  const CancelAccountWebView({Key? key}) : super(key: key);

  @override
  _CancelAccountWebViewState createState() => _CancelAccountWebViewState();
}

class _CancelAccountWebViewState extends State<CancelAccountWebView> {
  String cancelUrl = '';
  bool initialGet = false;
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
      var reqCHolderID = prefs.get('cHolderID').toString();
      cancelUrl =
          '${dotenv.env['US_HOST']!}spa/xcmo/securew/customer_cancel_request.asp?CHolderID=$reqCHolderID';
      initialGet = true;
    });
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cancelar Cuenta"),
          backgroundColor: const Color(0XFF0E325F),
          elevation: 1),
      body: initialGet
          ? WebView(
              initialUrl: cancelUrl,
            )
          : const Text('Cargando...'),
    );
  }
}
