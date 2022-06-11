import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:informaiton_systems/bottom_navigation/bottom_navigation_page.dart';
import 'package:informaiton_systems/constants/gender.dart';
import 'package:provider/provider.dart';

import 'form_model.dart';


class FormPage extends StatelessWidget {
  FormPage(this.email,this.password);

  DateTime targetDay = DateTime(2000, 1, 1);
  // String uid;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<FormModel>(
      //このページを開いたときにまずmodelをつくる
      create: (_) => FormModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("個人情報入力")),
        body: Center(
          child: Consumer<FormModel>(builder: (context, model, child) {
            // model.uid = uid;
            model.email = email;
            model.password = password;
            print(model.email);
            print(model.password);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: size.height / 64,),
                      TextField(
                        controller: model.userNameController,
                        decoration: const InputDecoration(hintText: 'ユーザーネーム'),
                        onChanged: (text) {
                          model.userNameOnChanged(text);
                        },
                      ),
                      SizedBox(height: size.height / 64,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("生年月日"),
                          Consumer<FormModel>(builder: (context, model, child) {
                            targetDay = model.targetDay;
                              return TextButton(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xFF000000)),
                                    ),
                                  ),
                                  child: Text(
                                      "${targetDay.year}年${targetDay.month}月${targetDay.day}日"),
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(1900, 1, 1),
                                      maxTime: DateTime(2049, 12, 31),
                                      onConfirm: (date) {
                                    model.dobOnChanged(date);
                                  }, currentTime: targetDay, locale: LocaleType.jp);
                                },
                              );
                            }
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Consumer<FormModel>(builder: (context, model, child) {
                        return Column(
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
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            model.startLoading();

                            try {
                              await model.signUp();
                              await model.personalDataSubmit();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavigationPage(),
                                  ));

                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: Text("登録する")),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator())),
              ],
            );
          }),
        ),
      ),
    );
  }
}
