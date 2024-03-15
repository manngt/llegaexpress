import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enough_convert/enough_convert.dart';

import 'api_resources.dart';

class GeneralServices {
  static Future<dynamic> reqPromoCode() async {
    var promoCode = dotenv.env['PROMO_CODE_GT']!;

    return promoCode;
  }

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

  static Future<dynamic> reqMerchantIDGt() async {
    var merchantScope = dotenv.env['GT_MERCHANT_ID']!;

    return merchantScope;
  }

  static Future<dynamic> reqToken() async {
    var tokenScope = dotenv.env['US_MERCHANT_TOKEN']!;

    return tokenScope;
  }

  static Future<dynamic> reqTokenGT() async {
    var tokenScope = dotenv.env['GT_MERCHANT_TOKEN']!;

    return tokenScope;
  }

  static Future<dynamic> getBaseUrl() async {
    var baseUrlScope = dotenv.env['US_BASE_URL']!;

    return baseUrlScope;
  }

  static Future<dynamic> getBaseUrlGt() async {
    var baseUrlScope = dotenv.env['GT_BASE_URL']!;

    return baseUrlScope;
  }

  static Future<dynamic> getCustomerRegistration(
      String reqFirstName,
      String reqLastName,
      String reqMobileNo,
      String reqEmail,
      String reqCountryID,
      String reqSINTypeID,
      String reqSIN,
      String reqCardPIN1,
      String reqCardPIN2) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.registrationUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqPromotionCode=${dotenv.env['PROMO_CODE']}&ReqFirstName=$reqFirstName&ReqLastName=$reqLastName&ReqMobileNo=$reqMobileNo&ReqEmail=$reqEmail&ReqCountryID=$reqCountryID&ReqSINTypeID=$reqSINTypeID&ReqSIN=$reqSIN&ReqCardPIN1=$reqCardPIN1&ReqCardPIN2=$reqCardPIN2');
    //send get for registration with parameters ReqMerchantID, ReqToken, ReqFirstName, ReqLastName, ReqMobileNo, ReqEmail, ReqCountryID, ReqSINTypeID, ReqSIN
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
      );
    } catch (e) {
      return 'Error en el envio http ${e.toString()}';
    }

    //Validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);

      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getForeignCustomerRegistration(
      String reqFirstName,
      String reqLastName,
      String reqMobileNo,
      String reqEmail,
      String reqCountryID,
      String reqSINTypeID,
      String reqSIN) async {
    var merchantId = await reqMerchantIDGt();
    var token = await reqTokenGT();
    var baseUrl = await getBaseUrlGt();
    var promoCode = await reqPromoCode();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.registrationUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqPromotionCode=$promoCode&ReqFirstName=$reqFirstName&ReqLastName=$reqLastName&ReqMobileNo=$reqMobileNo&ReqEmail=$reqEmail&ReqCountryID=$reqCountryID&ReqSINTypeID=$reqSINTypeID&ReqSIN=$reqSIN');
    //send get for registration with parameters ReqMerchantID, ReqToken, ReqFirstName, ReqLastName, ReqMobileNo, ReqEmail, ReqCountryID, ReqSINTypeID, ReqSIN
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
      );
    } catch (e) {
      return 'Error en el envio http ${e.toString()}';
    }

    //Validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);

      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getLogin(String reqUserID, String reqPassword) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var urlString =
        '${baseUrl + ApiResources.loginUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqUserID=$reqUserID&ReqPassword=$reqPassword';
    var url = Uri.parse(urlString);
    //send get for registration with parameters ReqMerchantID, ReqToken, ReqUserID, ReqPassword
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
      );
    } catch (e) {
      return 'Error en el envio http ${e.toString()}';
    }

    //Validates that http response is ok code 200

    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getWebPinChange(
      String reqPassword, String reqPIN1, String reqPIN2) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.webPinChangeUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqPIN1=$reqPIN1&ReqPIN2=$reqPIN2');
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

  static Future<dynamic> getPasswordChange(
      String reqPIN1, String reqPIN2) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.passwordChangeUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPIN1=$reqPIN1&ReqPIN2=$reqPIN2');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCustomerAccess(
    String sINTypeID,
    String reqSIN,
    String reqCardNumber,
    String reqBirthDate,
  ) async {
    // Obtain Merchant Id, Token and Base Url
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //Prepare Url
    var url = Uri.parse(
        '${baseUrl + ApiResources.customerAccessUri}?ReqMerchantID=$merchantId&ReqToken=$token&SINTypeID=$sINTypeID&ReqSIN=$reqSIN&ReqCardNumber=$reqCardNumber&ReqBirthDate=$reqBirthDate');

    //Send http resquest
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
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaRequest(
      String reqPassword,
      String reqAddress,
      String reqCityID,
      String reqProvinceID,
      String reqZipCode,
      String reqPhone) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaRequestUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAddress=$reqAddress&ReqCityID=$reqCityID&ReqProvinceID=$reqProvinceID&ReqZipCode=$reqProvinceID&ReqPhone=$reqPhone');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaBalance(String reqVisaCardNo) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaBalanceUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVisaCardNo=$reqVisaCardNo');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaCards() async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.visaCardsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getCardTransactions(String reqPassword) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.cardTransactionsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword');
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
      const codec = Windows1252Codec(allowInvalid: true);
      final decoded = codec.decode(response.bodyBytes);

      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVirtualCardBalance(String reqVisaCardNo) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.virtualCardBalanceUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVirtualCardNo=$reqVisaCardNo');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVirtualCards() async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.virtualCardsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getBills() async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.billsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCardHolderID=$reqCHolderID');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getPayBill(
    String reqInvoiceNo,
    String reqCardNumber,
    String reqPassword,
    String reqAmount,
    String reqBillerID,
    String reqAccountNo,
    String reqRushPayment,
  ) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse(
        '${baseUrl + ApiResources.payBillUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqInvoiceNo=$reqInvoiceNo&ReqCardNumber=$reqCardNumber&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqBillerID=$reqBillerID&ReqAccountNo=$reqAccountNo&ReqRushPayment=$reqRushPayment');
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
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getAddAccounts(String setMethod, String reqUserID,
      String reqFirstName, String reqLastName) async {
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //Prepare Uri
    var methodUri = setMethod == 'US'
        ? ApiResources.addAccounts
        : ApiResources.addAccountsYPayMe;
    var url = Uri.parse(
        '${baseUrl + methodUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqUserID=$reqUserID&ReqFirstName=$reqFirstName&ReqLastName=$reqLastName');
    //Add account
    http.Response response;

    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
    } catch (e) {
      return 'Error: ${e.toString()}';
    }

    //Validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response returs the result of adding account
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try {
        return json.decode(decoded);
      } catch (e) {
        return 'Error json decode: ${e.toString()}';
      }
    }
  }
}
