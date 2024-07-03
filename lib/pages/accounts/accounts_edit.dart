import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/accountsitemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/account_model.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';
import 'package:provider/provider.dart';

class AccountsEdit extends StatefulWidget {
  AccountsEdit({super.key, this.editmode = false, this.data});
  static const String routename = "/homepage/accounts/edit";
  bool editmode;
  AccountsModel? data;
  int x = 0;
  @override
  State<AccountsEdit> createState() => _AccountsEditState();
}

class _AccountsEditState extends State<AccountsEdit> {
  List<TextFieldModel> editelements = [
    TextFieldModel(
      controller: TextEditingController(),
      label: "اسم المستخدم",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون الاسم فارغا";
        }
      },
    ),
    TextFieldModel(
      controller: TextEditingController(),
      label: "الاسم الكامل",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون الاسم فارغا";
        }
      },
    ),
    TextFieldModel(
      controller: TextEditingController(),
      label: "كلمة المرور",
      obscuretext: true,
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون حقل كلمة المرور فارغا";
        }
      },
    ),
    TextFieldModel(
      controller: TextEditingController(),
      label: "تأكيد كلمة المرور",
      obscuretext: true,
    ),
    TextFieldModel(
      inputtype: TextInputType.emailAddress,
      controller: TextEditingController(),
      label: "البريد الالكتروني",
    ),
  ];
  List<String> admin = ['user', 'admin', 'superadmin'];
  @override
  void dispose() {
    for (var i in editelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    String selectedadmin = admin[0];
    editelements[3].validate = ((x) {
      if (x != editelements[2].controller.text) {
        return "كلمة المرور غير متطابقة";
      }
    });
    widget.data = ModalRoute.of(context)!.settings.arguments as AccountsModel?;
    if (widget.data != null) {
      widget.editmode = true;
      if (widget.x == 0) {
        editelements[0].controller.text = widget.data!.username!;
        editelements[1].controller.text = widget.data!.fullname!;
        editelements[4].controller.text = widget.data!.email!;
      }
    }
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editmode ? "تعديل" : "إضافة حساب جديد"),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      ...editelements
                          .where((element) => element.visible)
                          .map((e) => TextFieldCard(
                                label: e.label,
                                controller: e.controller,
                                inputType: e.inputtype,
                                maxlines: e.lines,
                                validate: e.validate,
                                direction: e.direction,
                              )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("صلاحيات الحساب"),
                          SizedBox(
                            width: 20,
                          ),
                          DropdownButton(
                              value: selectedadmin,
                              items: admin
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (x) {
                                widget.x = 1;
                                setState(() {
                                  selectedadmin = x!;
                                });
                              })
                        ],
                      ),
                      SizedBox(width: 500, child: Divider()),
                      TextButton.icon(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              if (widget.editmode) {
                                var resp = await requestupdate(
                                    endpoint: "accounts/update",
                                    body: {
                                      "id": widget.data!.id.toString(),
                                      "username":
                                          editelements[0].controller.text,
                                      "fullname":
                                          editelements[1].controller.text,
                                      "password": editelements[2]
                                              .controller
                                              .text
                                              .trim()
                                              .isEmpty
                                          ? editelements[2].controller.text
                                          : "",
                                      "email": editelements[4].controller.text
                                    });
                                if (resp != null) {
                                  context
                                      .read<AccountsListProvider>()
                                      .updatelist(
                                          id: widget.data!.id,
                                          newdata: AccountsModel.fromdata(
                                              data: resp));
                                }
                              } else {
                                var resp = await requestpost(
                                    endpoint: "accounts/add",
                                    body: {
                                      "username":
                                          editelements[0].controller.text,
                                      "fullname":
                                          editelements[1].controller.text,
                                      "password":
                                          editelements[2].controller.text,
                                      "email": editelements[4].controller.text
                                    });

                                if (resp != null) {
                                  context.read<AccountsListProvider>().additem(
                                      newdata:
                                          AccountsModel.fromdata(data: resp));
                                }
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("حفظ"))
                    ],
                  )),
            ),
          ),
        ));
  }
}
