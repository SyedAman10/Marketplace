import 'package:flutter/material.dart';
import 'package:market_place/backend/authenticate.dart';
import 'package:market_place/backend/database.dart';
import 'package:market_place/pages/profile_page.dart';
import 'package:market_place/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), actions: [
        TextButton(
          child: Text(
            "Sign up",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) {
              return SignupPage();
            })));
          },
        )
      ]),
      body: Center(
        child: Column(children: [
          TextField(controller: _emailController),
          TextField(
            controller: _passwordController,
          ),
          TextButton(
              onPressed: () async {
                await Authenticate()
                    .login(_emailController.text, _passwordController.text);
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: ((context) {
                  return ProfilePage(Authenticate().getCurrentUserUid);
                })));
              },
              child: Text("Login"))
        ]),
      ),
    );
  }
}
