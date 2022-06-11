import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

import '../domain/pin.dart';

class DetailModel extends ChangeNotifier{
  Pin pin;
  int? like;
  String? uid;
  bool? isLiked;
  DocumentReference? pinRef;
  DocumentReference? userRef;
  DetailModel(this.pin){
    like = pin.like;
    uid = FirebaseAuth.instance.currentUser!.uid;
    // データベースとの接続
    pinRef = FirebaseFirestore.instance.collection('pins').doc(pin.pinID);
    userRef = FirebaseFirestore.instance.collection('users').doc(uid);
  }


//  すでにLikeしているかの確認
  void setIsLiked()async{
    var mem = isLiked;
    print("start setIsLiked");
    DocumentSnapshot user = await userRef!.get();
    print("got user");
    List<String>? likedPin = user.get('likedPin').cast<String>();
    print("likedPin : " + likedPin.toString());
    isLiked = likedPin==null ? false : likedPin.contains(pin.pinID);
    print(isLiked);
    DocumentSnapshot snapshot = await pinRef!.get();
    like = snapshot.get('like');
    notifyListeners();
  }

  void onTapLike() async{
    // Like数をインクリメント、likedPinのリストを編集
    if(isLiked!){
      await pinRef!.update({'like': FieldValue.increment(-1)});
      await userRef!.update({'likedPin': FieldValue.arrayRemove([pin.pinID])});
    }else{
      await pinRef!.update({'like': FieldValue.increment(1)});
      await userRef!.update({'likedPin': FieldValue.arrayUnion([pin.pinID])});
    }
    isLiked = !isLiked!;
    // 表示されるLike数を更新
    DocumentSnapshot snapshot = await pinRef!.get();
    like = snapshot.get('like');
    notifyListeners();
  }
}