import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants/gender.dart';

class EditAccountModel extends ChangeNotifier {

  EditAccountModel(){
    fetchUserData();
  }

  final userNameController = TextEditingController();

  String? userName;
  String? gender;
  DateTime? dob;

  Genders? radVal;
  DateTime? targetDay;
  List<User>? users;

  Future<void> fetchUserData() async {
    //uidの取得
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;

    final doc = FirebaseFirestore.instance.collection("users").doc(uid);

    await doc.get().then((DocumentSnapshot snapshot) {
      userName = snapshot.get("userName");
      gender = snapshot.get("gender");
      dob = snapshot.get("dob").toDate();
    });

    userNameController.text = userName!;
    if(gender == "male"){
      radVal = Genders.male;
    }else if(gender == "female"){
      radVal = Genders.female;
    }else {
      radVal = Genders.other;
    }

    targetDay = dob;


    notifyListeners();
  }

  void userNameOnChanged(String userName){
    this.userName = userName;
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

  Future<void> pushUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;

    // final doc = FirebaseFirestore.instance.collection("users").doc(uid);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'userName': userName,
      'gender': radVal!.name,
      'dob': targetDay,
    });
  }
}
