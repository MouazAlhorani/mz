import 'package:flutter/material.dart';
import 'package:mz_tak_app/constant.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/models/userinfo_model.dart';
import 'package:mz_tak_app/pages/homepage.dart';
import 'package:mz_tak_app/widgets/logo.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';

class LogInPage extends StatefulWidget {
  LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  List<TextFieldModel> loginelements = [
    TextFieldModel(
      controller: TextEditingController(),
      label: "اسم المستخدم",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون اسم المستخدم فارغا";
        }
      },
    ),
    TextFieldModel(
      controller: TextEditingController(),
      label: "كلمة المرور",
      obscuretext: true,
      suffixIcon: Icons.visibility_off,
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان تكون كلمة المرور بدون تعيين";
        }
      },
      suffixFunction: () {},
    ),
  ];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    for (var i in loginelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginelements[1].suffixFunction = () {
      setState(() {
        loginelements[1].obscuretext = !loginelements[1].obscuretext;
        loginelements[1].suffixIcon =
            loginelements[1].suffixIcon == Icons.visibility_off
                ? Icons.visibility
                : Icons.visibility_off;
      });
    };
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            MzLogo(),
                            ...loginelements.map((e) => TextFieldCard(
                                  label: e.label,
                                  controller: e.controller,
                                  suffixIcon: e.suffixIcon,
                                  suffixFunction: e.suffixFunction,
                                  validate: e.validate,
                                  obscuretext: e.obscuretext,
                                )),
                            SizedBox(width: 150, child: Divider()),
                            TextButton.icon(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    var resp = await requestpost(
                                        endpoint: "auth",
                                        body: {
                                          "username":
                                              loginelements[0].controller.text,
                                          "password":
                                              loginelements[1].controller.text,
                                        });

                                    if (resp != null) {
                                      if (resp != "UNAuthorized") {
                                        userinfo =
                                            UserInfoModel.fromdata(data: resp);
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                HomePage.routename);
                                      }
                                    } else {}
                                  }
                                },
                                icon: Icon(Icons.arrow_back_ios),
                                label: Text("تسجيل الدخول"))
                          ],
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
