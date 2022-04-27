import 'package:flutter/material.dart';
import 'package:market_place/backend/authenticate.dart';
import 'package:market_place/models/service_provider.dart';
import 'package:market_place/models/user.dart';
import 'package:market_place/pages/login_page.dart';

import '../backend/database.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.accountUid, {Key? key}) : super(key: key);

  String accountUid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var accountData;

  @override
  void initState() {
    super.initState();
    accountData = Database().getAccountDataStream(widget.accountUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), actions: [
        TextButton(
          child: Text(
            "Log out",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await Authenticate().logout();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) {
              return LoginPage();
            })));
          },
        )
      ]),
      body: FutureBuilder(
        future: accountData,
        builder: (context, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.done &&
              snapshot1.hasData) {
            return StreamBuilder(
              stream: snapshot1.data as Stream<Object>?,
              builder: (context, snapshot) {
                var data = snapshot.data;

                if (data == null) {
                  return Text("Data is null");
                } else {
                  try {
                    Client client = data as Client;
                    List<Widget> children = [];
                    client.toMap().forEach(
                      (key, value) {
                        children.add(Text("${key} : ${value}"));
                      },
                    );
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: children,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                      ),
                    );
                  } catch (e) {
                    ServiceProvider serviceProvider = data as ServiceProvider;
                    List<Widget> children = [];
                    serviceProvider.toMap().forEach(
                      (key, value) {
                        children.add(Text("${key} : ${value}"));
                      },
                    );
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: children,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                      ),
                    );
                  }
                }
              },
            );
          } else if (snapshot1.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(child: Text("Send help ASAP"));
          }
        },
      ),
    );
  }
}
