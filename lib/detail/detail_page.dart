import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../domain/pin.dart';
import 'detail_model.dart';

class DetailPage extends StatelessWidget {
  Pin pin;
  DetailPage(this.pin);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailModel>(
      create: (_) => DetailModel(pin)..setIsLiked(),
      child: Consumer<DetailModel>(builder: (context, model, child) {
        // if(model.isLiked==null)model.setIsLiked();
        return Scaffold( // appBar: Header(headerTitle: screenName),
          appBar: AppBar(
            title: Text("詳細"),
          ),
          body: model.isLiked!=null? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: pin.imgURL==null ? Image.asset('image/no_img.png') : Image.network(pin.imgURL!),
              ),
              Expanded(
                  flex: 1,
                  child: Text(DateFormat('yyyy年M月d日 hh:mm').format(pin.time),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      )
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Row( // 1行目
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              model.onTapLike();
                            },
                            icon: model.isLiked! ? Icon(Icons.favorite, color: Colors.pink) : Icon(Icons.favorite_border_outlined),
                          ),
                          Text(NumberFormat("#,###").format(model.like))
                        ],
                      )
                  )
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: pin.comment==null ? null : Text(pin.comment!),
                ),
              )
            ],
          ) : const Center(child: CircularProgressIndicator()),
        );
      })
    );
  }
}
