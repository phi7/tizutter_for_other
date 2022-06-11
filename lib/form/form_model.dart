import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:informaiton_systems/constants/gender.dart';

class FormModel extends ChangeNotifier{
  String? uid;
  String? email;
  String? password;

  bool isLoading = false;

  var radVal = Genders.male;
  DateTime targetDay = DateTime(2000, 1, 1);

  final userNameController = TextEditingController();
  String userName = "";

  void userNameOnChanged(String text){
    userName = text;
    notifyListeners();
  }

  void dobOnChanged(DateTime date){
    targetDay = date;
    notifyListeners();
  }

  void genderOnChanged(Genders value) {
    radVal = value;
    notifyListeners();
  }

  Future signUp() async{
    //片方しか編集しなかった場合，もう片方がnullになって更新できなくなるのでこの処理がいる
    // email = titleController.text;
    // password = authorController.text;

    if(email != null && password != null) {
      //firebase authでユーザー作成
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final user = userCredential.user;
      if(user != null) {
        uid = user.uid;
        //firestoreに追加
        //uidをドキュメントidに設定し，さらにフィールドにもuidを設定しておく
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid' : uid,
          'email': email, // John Doe
        });
      }
    }
  }

  Future personalDataSubmit()async{
    // if(targetDay == null){
    //   throw "生年月日が指定されておりません";
    // }
    //
    // if(radVal == null){
    //   throw "性別が指定されておりません";
    // }

    final doc = FirebaseFirestore.instance.collection("users").doc(uid);
    await doc.set({
      'dob' : targetDay,
      'gender': radVal.name,
      'userName': userName,
      'likedPin': [],
    },SetOptions(merge: true)
    );

  }

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

}
