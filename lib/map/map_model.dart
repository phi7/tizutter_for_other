import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';
import '../detail/detail_page.dart';
import '../domain/filterInfo.dart';
import '../domain/pin.dart';

class MapPageModel extends ChangeNotifier {
  Completer<GoogleMapController> controller = Completer();
  Location location = Location()..changeSettings(interval: 10000);
  Set<Marker> markers = {};
  bool isLoading = false;

  // 現在位置
  LocationData? yourLocation;

  // 現在位置の監視状況
  StreamSubscription? locationChangedListen;


  void locationListen()async{
    // 現在位置の変化を監視
    locationChangedListen = location.onLocationChanged.listen((LocationData result) {
      yourLocation = result;
      print('location chenged to ' + yourLocation.toString());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 監視を終了
    locationChangedListen?.cancel();
  }

  //現在地を取得
  Future getLocationForApp() async {
    yourLocation = await location.getLocation();
    print(yourLocation);
  }

  // pinListからMarkerSetを作成
  void addMarker(List<Pin> pinList,context){
    markers = {};
    print("recieve " + pinList.length.toString() + " pins");
    pinList.forEach((pin) {
      markers.add(
          Marker(
              markerId: MarkerId(pin.pinID),
              position: LatLng(pin.posLat, pin.posLng),
              icon: pin.imgURL!=null ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) :
              pin.comment!=null ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen) :
              BitmapDescriptor.defaultMarker,
              // onTap: null,
              onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(pin),
                        fullscreenDialog: true));}
          )
      );
    });
    print("set "+ markers.length.toString() + " markers");
    notifyListeners();
  }

  // データベースとの接続
  final pinCollection = FirebaseFirestore.instance.collection('pins');
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<List<Pin>> fetchPinList(FilterInfo filter, LatLngBounds bounds) async {
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
    // 表示範囲を定義
    double northLat = bounds.northeast.latitude;
    double southLat = bounds.southwest.latitude;
    double eastLng = bounds.northeast.longitude;
    double westLng = bounds.southwest.longitude;
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

      // 場所、年齢、性別でのフィルタリング
      var filtered = snapshot.docs.where((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String uid = data['userID'];
        print("dob of " +uid +" : "+ dobMap[uid].toString());
        return southLat <= data['posLat'] && data['posLat'] <= northLat &&
            westLng <= data['posLng'] && data['posLng'] <= eastLng &&
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

      // 場所でのフィルタリング
      var filtered = snapshot.docs.where((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String uid = data['userID'];
        return southLat <= data['posLat'] && data['posLat'] <= northLat &&
            westLng <= data['posLng'] && data['posLng'] <= eastLng;
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
    return pins;
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