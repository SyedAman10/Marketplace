import 'package:flutter/material.dart';
import 'package:market_place/backend/authenticate.dart';
import 'package:market_place/backend/database.dart';
import 'package:market_place/pages/login_page.dart';
import 'package:market_place/pages/profile_page.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup Page"), actions: [
        TextButton(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) {
              return LoginPage();
            })));
          },
        )
      ]),
      body: Center(
          child: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController),
          TextField(controller: _nameController),
          TextField(
            controller: _typeController,
          ),
          TextButton(
              onPressed: () async {
                var uid = await Authenticate()
                    .signup(_emailController.text, _passwordController.text);
                if (_typeController.text.toLowerCase() == "user") {
                  await Database().addUser(
                      uid, _emailController.text, _nameController.text);
                } else {
                  await Database().addServiceProvider(
                      uid, _emailController.text, _nameController.text);
                }

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) {
                  return ProfilePage(uid as String);
                })));
              },
              child: Text("Sign up")),
        ],
      )),
    );
  }
}
