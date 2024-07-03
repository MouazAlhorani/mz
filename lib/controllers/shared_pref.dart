import "package:shared_preferences/shared_preferences.dart";

late SharedPreferences userinfosharedpref;

setuserinfo({required List<String> data}) async {
  await userinfosharedpref.setStringList("userinfo", data);
}
