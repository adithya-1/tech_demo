import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  List requestRec = [];
  List requestSent = [];
  List friends = [];
  Widget addFriend(String friendId) {
    return Column(
      children: [
        IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.add)),
        Text(
          'Tap to connect',
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget requestFriend(String friendId) {
    return Column(
      children: [
        IconButton(
            color: Colors.red,
            onPressed: () {},
            icon: Icon(CupertinoIcons.reply)),
        Text(
          'Undo Request',
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget acceptFriend(String name, String friendId) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                color: Colors.red,
                onPressed: () {},
                icon: Icon(CupertinoIcons.person_badge_minus)),
            IconButton(
                color: Colors.orange[400],
                onPressed: () {},
                icon: Icon(CupertinoIcons.person_badge_plus)),
          ],
        ),
        Text(
          name + ' has requested to connect',
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  Widget areFriends(String friendId) {
    return Column(
      children: [
        IconButton(
            color: Colors.orange[400],
            onPressed: () {},
            icon: Icon(CupertinoIcons.arrow_up_right)),
        Text(
          'Connected',
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            requestRec = snapshot.data!.get('req_rec');
            requestSent = snapshot.data!.get('req_sent');
            friends = snapshot.data!.get('friends');
            return Scaffold(
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                      padding: EdgeInsets.only(top: 50, left: 20),
                      child: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: "Welcome! ",
                                style: new TextStyle(
                                    fontWeight: FontWeight.normal)),
                            new TextSpan(
                                text: snapshot.data!.get('name'),
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text('Co-Passengers in your vicinity',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25))),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot1) {
                      if (snapshot1.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot1.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot userDoc =
                                  snapshot1.data!.docs[index];
                              if (userDoc.get('userId') == widget.userId) {
                                return Container();
                              } else {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 4),
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(CupertinoIcons.person)
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    userDoc.get('name'),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '     xxxxx' +
                                                        userDoc
                                                            .get('phone')
                                                            .toString()
                                                            .substring(4, 9),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                userDoc.get('position'),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                userDoc.get('company'),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.grey[400]),
                                              ),
                                            ],
                                          ),
                                          friends.contains(
                                                  userDoc.get('userId'))
                                              ? areFriends(
                                                  userDoc.get('userId'))
                                              : requestRec.contains(
                                                      userDoc.get('userId'))
                                                  ? acceptFriend(
                                                      userDoc.get('name'),
                                                      userDoc.get('userId'))
                                                  : requestSent.contains(
                                                          userDoc.get('userId'))
                                                      ? requestFriend(
                                                          userDoc.get('userId'))
                                                      : addFriend(
                                                          userDoc.get('userId'))
                                        ],
                                      ),
                                    ));
                              }
                            });
                      } else {
                        return Container(
                          color: Colors.blue,
                        );
                      }
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(100, 30)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () {
                                widget.auth.signOut();
                              },
                              child: Center(child: Text('LOG OUT')))))
                ]));
          } else {
            return Container(color: Colors.red);
          }
        });
  }
}
