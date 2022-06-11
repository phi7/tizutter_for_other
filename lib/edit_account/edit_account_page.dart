import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:informaiton_systems/account/account_page.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation/bottom_navigation_page.dart';
import '../constants/gender.dart';
import '../register/register_page.dart';
import 'edit_account_model.dart';

class EditAccountPage extends StatelessWidget {
  EditAccountPage({Key? key}) : super(key: key);

  // DateTime? targetDay;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<EditAccountModel>(
      //このページを開いたときにまずmodelをつくる
      create: (_) => EditAccountModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("アカウント情報の変更"),
        ),
        body: Center(
          child: Consumer<EditAccountModel>(builder: (context, model, child) {
            // model.fetchUserData();
            // targetDay = model.targetDay;
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("User Name"),
                  TextField(
                    controller: model.userNameController,
                    decoration: const InputDecoration(hintText: 'UserName'),
                    onChanged: (text) {
                      model.userNameOnChanged(text);
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),

                  Text("Gender"),

                  Column(
                    children: <Widget>[
                      RadioListTile(
                        title: const Text('男'),
                        value: Genders.male,
                        groupValue: model.radVal,
                        onChanged: (val) {
                          model.genderOnChanged(val as Genders);
                        },
                      ),
                      RadioListTile(
                        title: Text('女'),
                        value: Genders.female,
                        groupValue: model.radVal,
                        onChanged: (val) {
                          model.genderOnChanged(val as Genders);
                        },
                      ),
                      RadioListTile(
                        title: Text('その他'),
                        value: Genders.other,
                        groupValue: model.radVal,
                        onChanged: (val) {
                          model.genderOnChanged(val as Genders);
                        },
                      ),
                    ],
                  ),

                  Text("Birth"),
                  model.targetDay != null ?
                  TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xFF000000)),
                              ),
                            ),
                            child: Text(
                                "${model.targetDay!.year}年${model.targetDay!.month}月${model.targetDay!.day}日"),
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                maxTime: DateTime(2049, 12, 31),
                                onConfirm: (date) {
                              model.dobOnChanged(date);
                            },
                                currentTime: model.targetDay,
                                locale: LocaleType.jp);
                          },
                        )
                      : Container(),
                  Spacer(),
                  OutlinedButton(
                    child: const Text('変更'),
                    onPressed: () {
                      model.pushUserData();
                      Navigator.of(context).pop();
                    },
                  ),
                  Spacer()

                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
