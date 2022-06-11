import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'post_model.dart';

class PostPage extends StatelessWidget {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('books').snapshots();
  PostPage(this.yourLocation);
  LocationData? yourLocation;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostModel>(
      create: (_) => PostModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("投稿画面")),
        body: Center(
          child: Consumer<PostModel>(builder: (context, model, child) {
            if(yourLocation != null){
              model.posLat = yourLocation!.latitude;
              model.posLng = yourLocation!.longitude;
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: SizedBox(
                            width: 100,
                            height: 160,
                            child: model.imageFile != null
                                ? Image.file(model.imageFile!)
                                : Container(
                              color: Colors.grey,
                            )),
                        onTap: () async {
                          await model.pickBookImage();
                        },
                      ),
                      // TextField(
                      //   decoration: InputDecoration(hintText: '本のタイトル'),
                      //   onChanged: (text) {
                      //     model.title = text;
                      //   },
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'つぶやく内容'),
                        onChanged: (text) {
                          model.comment = text;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            try {
                              model.startLoading();
                              await model.addPost();
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: Text("投稿する")),
                    ],
                  ),
                ),
                if(model.isLoading)
                  Container(
                      color: Colors.black54,
                      child: Center(child: CircularProgressIndicator())),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Future postPageDialog(BuildContext context) {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('投稿画面'),
//         actions: <Widget>[
//           TextField(),
//           ElevatedButton(
//               child: const Text('投稿する'),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ],
//       );
//     },
//   );
// }
