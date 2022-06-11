import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../domain/filterInfo.dart';
import '../domain/pin.dart';

class TimeLineModel extends ChangeNotifier{
  // データベースとの接続
  final pinCollection = FirebaseFirestore.instance.collection('pins');
  final userCollection = FirebaseFirestore.instance.collection('users');

  List<Pin> pinList = [Pin("ja3tl8sX09E08tbd3j29","vHqfHV2ajnZFKtZcFqoMfBMaqlj2", 35.0138, -135.4701, DateTime(2022), 0, "HelloWorld!", null)];

  void fetchPinList(FilterInfo filter) async {
    print("start fetchPinList");
    DateTime start;
    DateTime end;
    QuerySnapshot snapshot;
    QuerySnapshot userSnapshot;
    Map<String, Timestamp> dobMap = {};
    Map<String, String> genderMap = {};
    Timestamp? startDob;
    Timestamp? endDob;
    List<Pin> pins = [];
    if(filter.detail) {  // 詳細フィルタがかかっているかどうかで分岐
      // 投稿時間フィルタの設定
      if(filter.allDay){
        start = DateTime(filter.startDate.year,filter.startDate.month,filter.startDate.day);
        DateTime d = filter.endDate.add(Duration(days: 1));
        end = DateTime(d.year, d.month, d.day);
      }else{
        start = filter.startDate;
        end = filter.endDate;
      }
      // 年齢フィルタの設定
      int nowYear = DateTime.now().year;
      startDob = Timestamp.fromDate(DateTime(nowYear - filter.maxAge));
      endDob = Timestamp.fromDate(DateTime(nowYear - filter.minAge + 1));
      // ピンの取得
      snapshot = await pinCollection
          .where("time", isGreaterThanOrEqualTo: Timestamp.fromDate(start), isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy("time",descending: true)
          .limit(100).get();

      print("fetch " + snapshot.docs.length.toString() + "data");

      // 投稿ユーザーの集合を作成
      Set uidSet = {};
      snapshot.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        uidSet.add(data["userID"]);
      });
      // ユーザー情報をあらかじめ辞書に保存
      userSnapshot = await userCollection.where("uid", whereIn: uidSet.toList()).get();
      userSnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        genderMap[data["uid"]] = data["gender"];
        dobMap[data["uid"]] = data["dob"];
      });

      // 写真コメントの有無、年齢、性別でのフィルタリング
      var filtered = snapshot.docs.where((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String uid = data['userID'];
        print("dob of " +uid +" : "+ dobMap[uid].toString());
        return (data['comment']!=null || data['imgURL']!=null) &&
            startDob!.compareTo(dobMap[uid]!) <= 0 &&
            endDob!.compareTo(dobMap[uid]!) >= 0 &&
            filter.genders.contains(genderMap[uid]);
      });

      // データをList<Pin>に変換
      pins = filtered.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String pinID = document.id;
        final String userID = data['userID'];
        final double posLat = data['posLat'];
        final double posLng = data['posLng'];
        final DateTime time = data['time'].toDate();
        final int like = data['like'];
        final String? comment = data['comment'];
        final String? imgURL = data['imgURL'];
        print("pin added");
        return Pin(pinID,userID,posLat,posLng,time,like,comment,imgURL);
      }).toList();
    }else{
      // 投稿時間フィルタの設定
      end = DateTime.now();
      start = end.add(Duration(hours: -filter.duration.hour, minutes: -filter.duration.minute));
      // ピンの取得
      snapshot = await pinCollection
          .where("time", isGreaterThanOrEqualTo: Timestamp.fromDate(start), isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy("time",descending: true)
          .limit(100).get();

      print("fetch " + snapshot.docs.length.toString() + "data");

      // 写真コメントの有無でのフィルタリング
      var filtered = snapshot.docs.where((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String uid = data['userID'];
        return data['comment']!=null || data['imgURL']!=null;
      });

      // データをList<Pin>に変換
      pins = filtered.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String pinID = document.id;
        final String userID = data['userID'];
        final double posLat = data['posLat'];
        final double posLng = data['posLng'];
        final DateTime time = data['time'].toDate();
        final int like = data['like'];
        final String? comment = data['comment'];
        final String? imgURL = data['imgURL'];
        print("pin added");
        return Pin(pinID,userID,posLat,posLng,time,like,comment,imgURL);
      }).toList();
    }

    print("made " + pins.length.toString() + " pins");
    pinList = pins;
    notifyListeners();
  }
}