import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:informaiton_systems/domain/PinInfoForTimeline.dart';
import 'package:informaiton_systems/domain/filterInfo.dart';
import 'package:informaiton_systems/domain/pinInfo.dart';
import 'package:latlng/latlng.dart';

import '../constants/gender.dart';
import '../domain/pin.dart';

class FilterModel extends ChangeNotifier{
  List<Pin>? pins;
  List<PinInfo>? pinInfos;
  FilterInfo filterInfo;
  bool detailSetting = false;
  DateTime displayDuration = DateTime(0,0,0,3);
  bool allDay = false;
  bool isLoading = false;
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now();
  int nowYear = DateTime.now().year;
  DateTime searchEndDate = DateTime.now();
  DateTime searchStartDate = DateTime.now();
  bool getMale = true;
  bool getFemale = true;
  bool getOther = true;
  int minAge = 0;
  int maxAge = 100;

  FilterModel(this.filterInfo){
    detailSetting = filterInfo.detail;
    displayDuration = filterInfo.duration;
    allDay = filterInfo.allDay;
    endDate = filterInfo.endDate;
    startDate = filterInfo.startDate;
    minAge = filterInfo.minAge;
    maxAge = filterInfo.maxAge;
    getMale = filterInfo.genders.contains("male");
    getFemale = filterInfo.genders.contains("female");
    getOther = filterInfo.genders.contains("other");
  }

  void displayDurationOnChanged(DateTime d){
    displayDuration = d;
    endDate = DateTime.now();
    startDate = endDate.add(Duration(hours: -displayDuration.hour, minutes: -displayDuration.minute));
    print(startDate);
    print(endDate);
    notifyListeners();
  }
  void detailSettingOnChange(){
    detailSetting = !detailSetting;
    print(startDate);
    print(endDate);
    notifyListeners();
  }
  void alldayOnChange(bool e){
    allDay = e;
    if (allDay){
      searchStartDate = DateTime(endDate.year, endDate.month, endDate.day);
      searchEndDate = DateTime(endDate.year, endDate.month, endDate.day);
      searchEndDate.add(Duration(days: 1));
    }else{
      searchStartDate = startDate;
      searchEndDate = endDate;
    }
    notifyListeners();
  }

  void startDateOnChanged(DateTime d){
    startDate = setDate(startDate, d);
    notifyListeners();
  }
  void startTimeOnChanged(TimeOfDay t){
    startDate = setTime(startDate, t);
    notifyListeners();
  }
  void endDateOnChanged(DateTime d){
    endDate = setDate(endDate, d);
    notifyListeners();
  }
  void endTimeOnChanged(TimeOfDay t){
    endDate = setTime(endDate, t);
    notifyListeners();
  }
  void maleOnChange(bool? e){
    if(e!=null){
      getMale = e;
      notifyListeners();
    }
  }
  void femaleOnChange(bool? e){
    if(e!=null){
      getFemale = e;
      notifyListeners();
    }
  }
  void otherOnChange(bool? e){
    if(e!=null){
      getOther = e;
      notifyListeners();
    }
  }
  void minAgeOnChanged(int num){
    minAge = num;
    if(minAge>maxAge){
      maxAge = minAge;
    }
    notifyListeners();
  }
  void maxAgeOnChanged(int num){
    maxAge = num;
    if(maxAge<minAge){
      minAge = maxAge;
    }
    notifyListeners();
  }

  DateTime setDate(DateTime origin, DateTime t){
    return DateTime(t.year, t.month, t.day, origin.hour, origin.minute);
  }
  DateTime setTime(DateTime origin, TimeOfDay t){
    return DateTime(origin.year, origin.month, origin.day, t.hour, t.minute);
  }

  FilterInfo makeFilter() {
    FilterInfo filter = FilterInfo();
    List<String> genders = [];
    if(getMale)genders.add('male');
    if(getFemale)genders.add('female');
    if(getOther)genders.add('other');
    filter.setFilter(detailSetting, displayDuration, allDay, endDate, startDate, genders, minAge, maxAge);
    return filter;
  }

//   void idsToPins(List<String> pids){
//     pids.forEach((String pid) async {
//       List<PinInfo> pinInfos = [];
//       final pin = await pinCollection.doc(pid).get();
//       final String userName = pin.get('userName');
//       final String comment = pin.get('comment');
//       final int like = pin.get('like');
//       final Timestamp time = pin.get('time');
//       final String imgURL = pin.get('imgURL');
//     });
// // userName, comment, picture, like, time
//   }
}
