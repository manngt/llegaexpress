import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enough_convert/enough_convert.dart';

import 'api_resources.dart';

class PurchaseService {
  static Future<dynamic> getCHolderID() async {
    String reqCHolderID = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('cHolderID') != null) {
      reqCHolderID = prefs.get('cHolderID').toString();
    }
    return reqCHolderID;
  }

  static Future<dynamic> reqMerchantID() async {
    var merchantScope = dotenv.env['US_MERCHANT_ID']!;
    return merchantScope;
  }

  static Future<dynamic> reqToken() async {
    var tokenScope = dotenv.env['US_MERCHANT_TOKEN']!;
    return tokenScope;
  }

  static Future<dynamic> getBaseUrl() async {
    var baseUrlScope = dotenv.env['US_BASE_URL']!;
    return baseUrlScope;
  }

  //Pago con QR
  static Future<dynamic> getQrPay(
      String reqMMerchantID, reqMEmployeeID, reqCPwd, reqStrTotal) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.qrPayUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqMMerchantID=$reqMMerchantID&ReqMEmployeeID=$reqMEmployeeID&ReqCHolderID=$reqCHolderID&ReqCPwd=$reqCPwd&ReqStrTotal=$reqStrTotal');

    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVirtualTransactions(
      String reqVirtualCardNo, String reqEndDate) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.virtualCardTransactionsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVirtualCardNo=$reqVirtualCardNo&ReqEndDate=$reqEndDate');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      final fixJson = decoded.replaceAll('},]', '}]');
      try {
        return json.decode(fixJson);
      } catch (e) {
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaTransactions(
      String reqVisaCardNo, String reqEndDate) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaCardTransactionsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVisaCardNo=$reqVisaCardNo&ReqEndDate=$reqEndDate');
    //Send card transfer
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      final fixJson = decoded.replaceAll('},]', '}]');
      try {
        return json.decode(fixJson);
      } catch (e) {
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }
}
