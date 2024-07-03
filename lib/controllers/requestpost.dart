import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mz_tak_app/constant.dart';

Future? requestpost({endpoint, params, body}) async {
  try {
    http.Response resp = await http.post(
      Uri.http(kmainapipath, "/mz/api/$endpoint/", params),
      body: body,
    );
    return jsonDecode(utf8.decode(resp.bodyBytes))['result'];
  } catch (e) {
    print(e);
  }
}

Future? requestupdate({endpoint, params, body}) async {
  try {
    http.Response resp = await http.patch(
      Uri.http(kmainapipath, "/mz/api/$endpoint/", params),
      body: body,
    );

    if (resp.statusCode == 200) {
      return jsonDecode(utf8.decode(resp.bodyBytes))['result'];
    } else {
      return null;
    }
  } catch (e) {
    print(e);
  }
}

Future? requestdelete({endpoint, params, body}) async {
  try {
    http.Response resp = await http.delete(
        Uri.http(kmainapipath, "/mz/api/$endpoint/", params),
        body: body);

    if (resp.statusCode == 200) {
      return jsonDecode(utf8.decode(resp.bodyBytes))['result'];
    } else {
      return null;
    }
  } catch (e) {
    print(e);
  }
}
