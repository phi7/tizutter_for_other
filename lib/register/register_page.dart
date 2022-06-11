import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../form/form_page.dart';
import 'register_model.dart';

class RegisterPage extends StatelessWidget {
  // String? uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      //このページを開いたときにまずmodelをつくる
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("新規登録")),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
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
                              // await model.signUp();
                              // Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormPage(model.email,model.password),
                                  ));
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: const Text("次へ")),
                    ],
                  ),
                ),
                if(model.isLoading)
                  Container(
                      color: Colors.black54,
                      child: const Center(child: const CircularProgressIndicator())),
              ],
            );
          }),
        ),
      ),
    );
  }
}
