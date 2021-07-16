import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Chat extends StatelessWidget {
  final String userId;
  final String peerId;
  final String peerName;
  final String peerNumber;
  final String peerPosition;
  final String peerCompany;
  const Chat({
    Key? key,
    required this.userId,
    required this.peerId,
    required this.peerName,
    required this.peerNumber,
    required this.peerPosition,
    required this.peerCompany,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.xmark))
        ],
        backgroundColor: Colors.white,
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Icon(CupertinoIcons.person)],
            ),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          this.peerName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '     xxxxx' +
                              this.peerNumber.toString().substring(4, 9),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Text(
                      this.peerPosition,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey),
                    ),
                    Text(
                      this.peerCompany,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey[400]),
                    ),
                  ],
                )),
          ],
        ),
      ),
      body: ChatPage(
        userId: this.userId,
        peerId: this.peerId,
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.peerId, required this.userId})
      : super(key: key);
  final String peerId;
  final String userId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var listMessage;
  String groupChatId = '';
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  bool isLoading = false;
  @override
  void initState() {
    groupChatId = '';
    readLocal();
    super.initState();
  }

  readLocal() async {
    if (widget.userId.hashCode <= widget.peerId.hashCode) {
      groupChatId = widget.userId + '-' + widget.peerId;
    } else {
      groupChatId = widget.peerId + '-' + widget.userId;
    }
    setState(() {});
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.userId,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == widget.userId) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.orange[400]),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange[400]!),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  CupertinoIcons.person,
                  color: Colors.blueGrey[400],
                ),
                Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.blueGrey[400]),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey[400]!),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Color(0xffaeaeae),
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            buildListMessage(),
            buildSuggestions(),
            buildInput(),
          ],
        ),
        buildLoading()
      ],
    );
  }

  Widget suggestedText(String text) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
            onTap: () => onSendMessage(text, 0),
            child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.orange[400]),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  //width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange[400]!),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                ))));
  }

  Widget buildSuggestions() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              suggestedText('Hello'),
              suggestedText('Thanks for connecting'),
              suggestedText('How are you?'),
              suggestedText('Would you like to have a business chat?'),
            ],
          ),
        ));
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Tap to type',
                  hintStyle: TextStyle(color: Color(0xffaeaeae)),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepOrange)));
                } else {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.length == 0)
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  else
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(index, listMessage[index]),
                      itemCount: listMessage.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                }
              },
            ),
    );
  }
}
