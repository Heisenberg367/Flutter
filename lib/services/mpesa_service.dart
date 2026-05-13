import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  static const String _consumerKey = 'YOUR_CONSUMER_KEY';
  static const String _consumerSecret = 'YOUR_CONSUMER_SECRET';
  static const String _shortCode = '174379';
  static const String _passkey =
      'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
  static const String _callbackUrl =
      'https://your-backend.com/api/mpesa/callback';
  static const String _baseUrl = 'https://sandbox.safaricom.co.ke';

  static Future<String> _getAccessToken() async {
    final credentials =
        base64Encode(utf8.encode('$_consumerKey:$_consumerSecret'));
    final response = await http.get(
      Uri.parse('$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
      headers: {'Authorization': 'Basic $credentials'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw MpesaException('Failed to get access token', response.body);
    }
  }

  static Future<MpesaStkResponse> initiateStkPush({
    required String phone,
    required int amount,
    required String orderId,
  }) async {
    final token = await _getAccessToken();
    final timestamp = _timestamp();
    final password =
        base64Encode(utf8.encode('$_shortCode$_passkey$timestamp'));
    final sanitisedPhone = _sanitisePhone(phone);

    final response = await http.post(
      Uri.parse('$_baseUrl/mpesa/stkpush/v1/processrequest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': _shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount,
        'PartyA': sanitisedPhone,
        'PartyB': _shortCode,
        'PhoneNumber': sanitisedPhone,
        'CallBackURL': _callbackUrl,
        'AccountReference': orderId,
        'TransactionDesc': 'Payment for order $orderId',
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['ResponseCode'] == '0') {
      return MpesaStkResponse(
        checkoutRequestId: data['CheckoutRequestID'],
        merchantRequestId: data['MerchantRequestID'],
        responseDescription: data['ResponseDescription'],
      );
    } else {
      throw MpesaException(
        data['errorMessage'] ?? 'STK Push failed',
        response.body,
      );
    }
  }

  static Future<MpesaQueryResponse> queryTransaction({
    required String checkoutRequestId,
  }) async {
    final token = await _getAccessToken();
    final timestamp = _timestamp();
    final password =
        base64Encode(utf8.encode('$_shortCode$_passkey$timestamp'));

    final response = await http.post(
      Uri.parse('$_baseUrl/mpesa/stkpushquery/v1/query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': _shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': checkoutRequestId,
      }),
    );

    final data = jsonDecode(response.body);
    return MpesaQueryResponse(
      resultCode: data['ResultCode']?.toString() ?? '-1',
      resultDesc: data['ResultDesc'] ?? 'Unknown',
      isSuccess: data['ResultCode']?.toString() == '0',
    );
  }

  static String _timestamp() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }

  static String _sanitisePhone(String phone) {
    phone = phone.trim().replaceAll(' ', '').replaceAll('-', '');
    if (phone.startsWith('+')) phone = phone.substring(1);
    if (phone.startsWith('0')) phone = '254${phone.substring(1)}';
    if (!phone.startsWith('254')) phone = '254$phone';
    return phone;
  }
}

class MpesaStkResponse {
  final String checkoutRequestId;
  final String merchantRequestId;
  final String responseDescription;

  MpesaStkResponse({
    required this.checkoutRequestId,
    required this.merchantRequestId,
    required this.responseDescription,
  });
}

class MpesaQueryResponse {
  final String resultCode;
  final String resultDesc;
  final bool isSuccess;

  MpesaQueryResponse({
    required this.resultCode,
    required this.resultDesc,
    required this.isSuccess,
  });
}

class MpesaException implements Exception {
  final String message;
  final String rawResponse;

  MpesaException(this.message, this.rawResponse);

  @override
  String toString() => 'MpesaException: $message';
}