import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AccountModel extends ChangeNotifier {
  String? userName;
  String? email;
  String? gender;
  DateTime? dob;

  void getUserName() {
    userName = "";
    notifyListeners();
  }

  void getEmail() {
    email = "";
    notifyListeners();
  }

  void getGender() {
    gender = "";
    notifyListeners();
  }

  void getBirth() {
    // dob =
    notifyListeners();
  }
  // final  _userCollection = FirebaseFirestore.instance.collection('users');

  List<User>? users;

  Future<void> fetchUser() async {
    //uidの取得
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;

    final doc = FirebaseFirestore.instance.collection("users").doc(uid);
    // final doc_email = FirebaseFirestore.instance.collection("users").doc(email);

    // print(doc.id);
    // doc.get().then((DocumentSnapshot snapshot) {
    //   print(snapshot.get("email"));
    // });

    await doc.get().then((DocumentSnapshot snapshot) {
      userName = snapshot.get("userName");
      email = snapshot.get("email");
      gender = snapshot.get("gender");
      dob = snapshot.get("dob").toDate();
    });

    // final QuerySnapshot snapshot = await _userCollection.get();
    // final List<User> users = snapshot.docs.map((DocumentSnapshot document) {
    //   //snapshotからドキュメントを取り出し，ドキュメントからデータを取り出して，さらにフィールドをとりだす
    //   //その後Bookインスタンスをリターンする．
    // Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    //   final String id = document.id;
    //   final String title = data["title"];
    //   final String author = data["author"];
    //   final String? imgURL = data["imgURL"];
    //   return Book( id, title, author, imgURL);
    // }).toList();
    // //モデルのbooksに代入し，それを伝える
    // this.books = books;
    notifyListeners();
  }
}
