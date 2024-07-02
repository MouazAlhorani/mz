import 'dart:convert';

import 'package:http/http.dart' as http;

Future pbxRequestpost(
    {endpoint, resultkey, Map<String, dynamic>? params, Map? body}) async {
  try {
    http.Response resp = await http.post(
      Uri.http("192.168.30.20", "/mz/api/pbx/$endpoint/", params),
      body: body,
      //headers: {"Content-Type": "application/json"}
    );
    if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body)[resultkey];

      return result;
    }
  } catch (e) {
    print(e);
  }
  return null;
}
