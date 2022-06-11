import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostModel extends ChangeNotifier{
  String? comment;
  File? imageFile;
  int like = 0;
  double? posLat;
  double? posLng;
  Timestamp? time;
  String? userID;
  bool isLoading = false;

  final picker = ImagePicker();

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = false;
    notifyListeners();
  }

  Future addPost()async{
    // if(title == null || title == ""){
    //   throw "本のタイトルがありません";
    // }

    if(comment == null || comment == ""){
      throw "投稿内容がありません";
    }

    final doc = FirebaseFirestore.instance.collection("pins").doc();

    //画像のアップロード
    String? imgURL;
    //storageにアップロード
    if(imageFile != null){
      final task = await FirebaseStorage.instance.ref("pins/${doc.id}").putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    //現在時間の取得
    time = Timestamp.fromDate(DateTime.now());

    //userIDの取得
    final currentUser = FirebaseAuth.instance.currentUser;
    final userID = currentUser!.uid;

    //firestoreに追加
    await doc.set({
      'comment': comment,
      'imgURL': imgURL,
      'like' : like,
      'posLat' : posLat,
      'posLng' : posLng,
      'time' : time,
      'userID': userID,
    });

  }

  Future pickBookImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
