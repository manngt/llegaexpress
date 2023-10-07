import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/registration_success_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IdentityCheckScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const IdentityCheckScreen({Key? key, this.registrationSuccessResponse})
      : super(key: key);

  @override
  _IdentityCheckScreenState createState() =>
      _IdentityCheckScreenState(registrationSuccessResponse: registrationSuccessResponse);
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _IdentityCheckScreenState({this.registrationSuccessResponse});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    // Dispose of the WebView to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var url = 'https://test.bgpay.me/spa/xpay/securew/naserpagos.html';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación de datos'),
        backgroundColor: const Color(0xFF0E325F), // Updated color code
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
