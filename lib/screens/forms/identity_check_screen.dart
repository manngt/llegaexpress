import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llegaexpress/models/general/registration_success_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IdentityCheckScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const IdentityCheckScreen(
      {Key? key, @required this.registrationSuccessResponse})
      : super(key: key);

  @override
  _IdentityCheckScreenState createState() {
    return _IdentityCheckScreenState(
        registrationSuccessResponse: this.registrationSuccessResponse);
  }
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _IdentityCheckScreenState(
      {Key? key, @required this.registrationSuccessResponse});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    var url =
        'https://bgipay.me/spa/xcmo/securew/mati_cproof.asp?CHolderID=${registrationSuccessResponse!.cHolderId}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación de datos'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
