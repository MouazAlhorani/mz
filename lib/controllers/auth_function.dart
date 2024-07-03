import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';

authFunction({username, password}) async {
  var resp = await requestpost(endpoint: "auth", body: {
    "username": username,
    "password": password,
  });
  if (resp != null && resp != "UNAUTHORIZED") {
    await setuserinfo(data: [
      resp['id'].toString(),
      resp['username'],
      resp['password'],
      resp['fullname'],
      resp['admin']
    ]);
    return {"result": resp};
  } else if (resp == "UNAUTHORIZED") {
    return {"result": resp};
  } else {
    return {"result": "server_error"};
  }
}
