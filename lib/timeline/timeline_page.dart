import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import '../domain/filterInfo.dart';
import '../domain/pin.dart';
import '../filter/filter_page.dart';
import 'timeline_model.dart';


const kTileHeight = 50.0;


class TimeLinePage extends StatelessWidget {
  Function onCardTap;
  FilterInfo filter;
  TimeLinePage(this.onCardTap, this.filter);
  void setFilter(FilterInfo filterInfo){
    filter = filterInfo;
  }
  Function? rewrite;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimeLineModel>(
        create: (_) => TimeLineModel()..fetchPinList(filter),
        child: Consumer<TimeLineModel>(builder: (context, model, child) {
          rewrite ??= (){
            model.fetchPinList(filter);
            print("rewrite timeline");
          };
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('写真・コメントつきの投稿'),
                actions: [
                  // 再読み込み
                  IconButton(
                    onPressed: () async{
                      model.fetchPinList(filter);
                    },
                    icon: Icon(Icons.autorenew),
                  ),
                  // 検索
                  IconButton(
                      onPressed: () async{
                        print("search start");
                        filter = await Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => FilterPage(filter),
                            )
                        );
                        setFilter(filter);
                        model.fetchPinList(filter);
                        print("get pinList");
                      },
                      icon: Icon(Icons.search)
                  )
                ],
              ),
              body: Center(
                child: ListView(
                  children: model.pinList.map((pin) =>
                      InkWell(
                        onTap: (){onCardTap(pin, filter);},
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                pin.comment==null?SizedBox():
                                Text(pin.comment!,
                                  textAlign: TextAlign.left,
                                ),
                                pin.comment!=null&&pin.imgURL!=null?SizedBox(height: 5):SizedBox(),
                                pin.imgURL==null?SizedBox():Image.network(pin.imgURL!),
                                Divider(height: 5, thickness: 3,),
                                Row(
                                  children: [
                                    Icon(Icons.favorite_border_outlined),
                                    SizedBox(width: 5,),
                                    Text(NumberFormat("#,###").format(pin.like)),
                                    Spacer(),
                                    Text(DateFormat('yyyy年M月d日 hh:mm').format(pin.time)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ).toList(),
                ),
              )
          );
        })
    );
  }
}


