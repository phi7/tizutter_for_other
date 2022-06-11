import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:informaiton_systems/domain/filterInfo.dart';

// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../account/account_page.dart';
import '../domain/pin.dart';
import '../map/map_page.dart';
import '../timeline/timeline_page.dart';
// import 'bottom_navigation_model.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  var _currentIndex = 0;
  FilterInfo _filter = FilterInfo();
  MapPage? map;
  TimeLinePage? timeline;
  AccountPage? account;

  @override
  Widget build(BuildContext context) {
    Function onCardTap = (Pin pin, FilterInfo filterInfo){
      setState(() {
        _currentIndex = 0;
      });
      _filter = timeline!.filter;
      map!.filter = _filter;
      map!.lookAt!(pin, filterInfo);
    };

    map = MapPage(_filter);
    timeline = TimeLinePage(onCardTap!, _filter);
    account = AccountPage();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            map!,
            timeline!,
            account!,
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'マップ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'タイムライン',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'アカウント',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      if(_currentIndex==0){
        _filter = map!.filter;
      }else if(_currentIndex==1){
        _filter = timeline!.filter;
      }
      if(index==0){
        map!.filter = _filter;
        map!.rewrite!();
      }else if(index==1){
        timeline!.filter = _filter;
        timeline!.rewrite!();
      }
      _currentIndex = index;
    });
  }
}

//下はproviderバージョン 下バーで遷移するたびに各ページを読み込み直して重いため，
//Statefulwidgetに書き直した
// class BottomNavigationPage extends StatelessWidget {
//   //フッターのページ一覧．右から．
//   final List _pageList = [
//     MapPage(),
//     TimeLinePage(),
//     AccountPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<BottomNavigationModel>(
//         create: (_) => BottomNavigationModel(),
//         child:
//             Consumer<BottomNavigationModel>(builder: (context, model, child) {
//               return Scaffold(
//             // appBar: Header(), //各ファイルでHeader()を実行するのでいらない
//             body: _pageList[model.currentIndex], //中身を描画
//             //footer部分
//             bottomNavigationBar: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.map),
//                   label: 'マップ',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.timeline),
//                   label: 'タイムライン',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: 'アカウント',
//                 ),
//               ],
//               currentIndex: model.currentIndex,
//               onTap: (index) {
//                 model.currentIndex = index;
//               },
//               selectedItemColor: Colors.pinkAccent,
//               //選んだ物の色
//               unselectedItemColor: Colors.black45, //選んでない物の色
//             ),
//           );
//         }));
//   }
// }
