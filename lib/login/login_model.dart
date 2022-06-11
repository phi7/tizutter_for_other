import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier{

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? email;
  String? password;

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


  Future login()async{
    //片方しか編集しなかった場合，もう片方がnullになって更新できなくなるのでこの処理がいる
    email = titleController.text;
    password = authorController.text;

    //ログインする
    if(email != null && password != null){
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;

    }

  }
}
