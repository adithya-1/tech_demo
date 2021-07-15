import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_demo/services/authservice.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.auth, required this.userId})
      : super(key: key);
  final AuthService auth;
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(),
                drawer: Drawer(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        ListTile(
                          title: Text("Welcome " + snapshot.data!.get('name')),
                        ),
                        ListTile(
                          title: Text('Log Out'),
                          onTap: () {
                            widget.auth.signOut();
                          },
                        )
                      ]),
                )
                // body: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //   Text('You are logged in'),
                //   ElevatedButton(
                //       onPressed: () {
                //         print(widget.auth.getCurrentUser());

                //         widget.auth.signOut();
                //       },
                //       child: Center(child: Text('LOG OUT')))
                // ])
                );
          } else {
            return Container();
          }
        });

    //     body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //   Text('You are logged in'),
    //   ElevatedButton(
    //       onPressed: () {
    //         print(widget.auth.getCurrentUser());

    //         widget.auth.signOut();
    //       },
    //       child: Center(child: Text('LOG OUT')))
    // ])
  }
}
