import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier{

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? email;
  String? password;
  String? uid;

  bool isLoading = false;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

  //リアルタイムにtextfieldの変化を反映して更新ボタンを活性・非活性にしたいが，pageで
  //notifylistenerをするのはよくないので，こちらでnotifylistenerするための関数を用意する
  void setEmail(String email){
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password){
    this.password = password;
    notifyListeners();
  }


  // Future signUp() async{
  //   //片方しか編集しなかった場合，もう片方がnullになって更新できなくなるのでこの処理がいる
  //   email = titleController.text;
  //   password = authorController.text;
  //
  //   if(email != null && password != null) {
  //     //firebase authでユーザー作成
  //     final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email!,
  //       password: password!,
  //     );
  //     final user = userCredential.user;
  //     if(user != null) {
  //       uid = user.uid;
  //       //firestoreに追加
  //       //uidをドキュメントidに設定し，さらにフィールドにもuidを設定しておく
  //       final doc = FirebaseFirestore.instance.collection('users').doc(uid);
  //       await doc.set({
  //         'uid' : uid,
  //         'email': email, // John Doe
  //       });
  //     }
  //   }
  // }
}
