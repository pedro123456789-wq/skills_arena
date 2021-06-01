import 'package:http/http.dart' as http;

class RequestHandler {
  static Future sendPost(Map<String, String> headers, String url, {String body = ''}) async {
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future sendGet(Map<String, String> headers, String url) async {
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    return response;
  }
}

