import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation/bottom_navigation_page.dart';
import '../register/register_page.dart';
import 'login_model.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      //このページを開いたときにまずmodelをつくる
      create: (_) => LoginModel(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("ログイン"),automaticallyImplyLeading: false,),
          body: Center(
            child: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.titleController,
                          decoration: const InputDecoration(hintText: 'Email'),
                          onChanged: (text) {
                            model.setEmail(text);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: model.authorController,
                          decoration: const InputDecoration(hintText: 'Password'),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        OutlinedButton(
                            onPressed: () async {
                              model.startLoading();
                              try {
                                await model.login();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomNavigationPage(),
                                        ));
                              } catch (e) {
                                final snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } finally {
                                model.endLoading();
                              }
                            },
                            child: const Text("ログインする")),
                        TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                      fullscreenDialog: true));
                            },
                            child: const Text("新規登録の方はこちら")),
                      ],
                    ),
                  ),
                  if(model.isLoading)
                    Container(
                        color: Colors.black54,
                        child: const Center(child: CircularProgressIndicator())),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
