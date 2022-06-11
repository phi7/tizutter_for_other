import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:informaiton_systems/login/login_page.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation/bottom_navigation_page.dart';
import '../edit_account/edit_account_page.dart';
import '../register/register_page.dart';
import 'account_model.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<AccountModel>(
      //このページを開いたときにまずmodelをつくる
      create: (_) => AccountModel(),
      child: Scaffold(
        // appBar: Header(headerTitle: screenName),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("アカウント"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
          ],
        ),

        body: Center(
          child: Consumer<AccountModel>(builder: (context, model, child) {
            model.fetchUser();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ユーザーネーム: "),
                    model.email != null ? Text("${model.userName}") : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Email: "),
                    model.email != null ? Text("${model.email}") : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Gender: "),
                    model.gender != null
                        ? Text("${model.gender}")
                        : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Birth: "),
                    model.dob != null ? Text("${model.dob!.year}年${model.dob!.month}月${model.dob!.day}日") : Container(),
                  ],
                ),

                SizedBox(
                  height: 80,
                ),
                OutlinedButton(
                  child: const Text('編集'),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAccountPage(),
                        )
                    );
                    await model.fetchUser();
                  },

                ),
                // ElevatedButton(onPressed: ()  {
                //
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => EditAccountPage(),
                //       ));
                // }, child: const Text("編集"))
              ],
            );
          }),
        ),
      ),
    );
  }
}
