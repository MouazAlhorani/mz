import "package:shared_preferences/shared_preferences.dart";

SharedPreferences? userinfosharedpref;

setuserinfo({required List<String> data}) async {
  userinfosharedpref = await SharedPreferences.getInstance();
  await userinfosharedpref!.setStringList("userinfo", data);
}
