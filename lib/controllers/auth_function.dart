import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';

authFunction({username, password}) async {
  var resp = await requestpost(endpoint: "auth", body: {
    "username": username,
    "password": password,
  });
  if (resp != null) {
    await setuserinfo(data: [
      resp['id'].toString(),
      resp['username'],
      resp['password'],
      resp['fullname']
    ]);
    return {"result": resp};
  } else {
    return {"result": "server_error"};
  }
}
