/*
 * -----
 * \ChatView.dart
 * Created on: Sep 7 2018
 * -----
 * Project: Chat App Flutter Tutorial
 * 
 * Made with love by Third Degree Apps
 * Authors: [
 *   Tim Anthony Manuel (timanth@gmail.com),
 * ]
 * Contributors:[
 *   Tim Anthony Manuel (timanth@gmail.com),
 * ]
 * 
 * Copyright 2018 - 2019 Third Degree Apps, All Rights Reserved
 * 
 * License:
 * The codes contained are owned by Third Degree Apps
 * See the whole license in <project root>/LICENSE
 * -----
 * File overview:
 * SHOWS THE CHAT MESSAGES AND PROVIDES A TEXT FIELD FOR NEW CHAT MESSAGES
 * -----
 */

import 'dart:convert';

import 'package:chat_app/ChatMessages.dart';
import 'package:chat_app/Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  ChatView({
    Key key,
    this.friendName: "",
    this.lastMessage: "",
    this.avatarUrl: "",
    this.friendId,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();

  final String friendName;
  final String lastMessage;
  final String avatarUrl;
  final String friendId;
}

class _ChatViewState extends State<ChatView> {
  String _friendInitial;

  TextEditingController _controller = TextEditingController();

  List<dynamic> _listOfMessages;

  String avatarUrl = "";

  FocusNode focusChatMessage;

  @override
  void initState() {
    // TODO: implement initState
    _listOfMessages = List();
    focusChatMessage = FocusNode();
    setState(() {
      _friendInitial = widget.friendName.substring(0, 1);
    });
    conversationId().then((_id) {
      setState(() {
        _conversationId = _id;
      });
    });
    super.initState();

    // LOAD THE MESSAGES
    // loadMessages(context);
  }

  @override
  void dispose() {
    focusChatMessage.dispose();
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void loadMessages(BuildContext context) async {
    Map<String, dynamic> tempObject =
        await loadJsonFileAsMap(context, 'assets/messageDetails.json');

    setState(() {
      _listOfMessages = tempObject[widget.friendId]['messages'];
      avatarUrl = tempObject[widget.friendId]['avatar'];
    });

    print('_listOfMessages $_listOfMessages');
  }

  String _conversationId;
  String _userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName),
        actions: <Widget>[
          widget.avatarUrl == null
              ? Container()
              : CircleAvatar(
                  backgroundImage: Image.network(avatarUrl).image,
                )
        ],
      ),
      body: _conversationId == null
          ? Container()
          : Column(
              children: <Widget>[
                Flexible(
                    child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('/message_data/$_conversationId/messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return Text(
                          'An error occured ${snapshot.error.toString()}');
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length > 0) {
                          return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot _document =
                                  snapshot.data.documents[index];
                              print('_document > ${_document['fromA']}');

                              return ChatMessages(
                                isFriend:
                                    _document['senderId'] == widget.friendId,
                                // _document['fromA'],
                                // FIXME: MAKE ME BETTER
                                isNotPrevious:
                                    snapshot.data.documents.length - 1 == index,
                                message: _document['content'],
                                friendId: widget.friendId,
                                friendInitial: 'T',
                                avatarUrl:
                                    'https://avatarfiles.alphacoders.com/132/132399.jpg',
                              );
                            },
                          );
                        } else {
                          return Text('No messages found. Send one now.');
                        }
                      } else {
                        return Text('No messages found. Send one now.');
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // submitText();
                              FocusScope.of(context)
                                  .requestFocus(focusChatMessage);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _controller,
                        // autofocus: true,
                        focusNode: focusChatMessage,
                        onFieldSubmitted: (String _message) {
                          submitText();
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: "Type your message here",
                          // labelText: "Your message",
                          // helperText: "Here's where the message goes"
                        ),
                      )),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              submitText();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Submits the text in the text field and then clear it
  void submitText() async {
    print("on field submitted >> " + _controller.text);
    if (_controller.text.length > 0) {
      // CREATE A NEW MESSAGE OBJECT CONTAINING THE TEXT FROM THE FIELD
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      Map<String, dynamic> newMessage = {
        "type": 1,
        "content": _controller.value.text,
        // "fromA": false,
        "senderId": _user.uid,
        "timestamp": DateTime.now().toUtc(),
      };

      final _conversationId = await conversationId();

      try {
        // ADD THE NEW MESSAGE OBJECT TO THE LIST
        Firestore.instance
            .collection('/message_data/$_conversationId/messages')
            .add(newMessage);

        Firestore.instance.document('/message_data/$_conversationId').setData({
          "last_message": newMessage,
          "participants": [_user.uid, widget.friendId],
          "participants_names": [
            {
              // FRIEND'S DATA
              "uid": widget.friendId,
              "avatar": widget.avatarUrl,
              "display_name": widget.friendName,
            },
            {
              // USER'S DATA
              "uid": _user.uid,
              "avatar": _user.photoUrl,
              "display_name": _user.displayName,
            }
          ]
        }, merge: true);

        // CLEAR THE TEXT
        _controller.clear();
      } catch (e) {
        print('CHAT VIEW > ERR > ${e.toString()}');
      }
    }
  }

  Future<String> conversationId() async {
    // GET USER'S DATA
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    setState(() {
      _userId = _user.uid;
    });

    List<String> _friends = [_user.uid, widget.friendId];

    // SORT THE UIDS ALPHABETICALLY
    _friends.sort((a, b) {
      return a.compareTo(b);
    });

    _friends.insert(1, "___");

    final String _conversationId = _friends.reduce((a, b) {
      return a.toString() + b.toString();
    });
    return Future.value(_conversationId);
  }

  /// Creates a future list of messages
  Future<List> loadMessageDetails() async {
    String messageDetailsString = await DefaultAssetBundle.of(context)
        .loadString('assets/messageDetails.json');
    // print('message detail : $messageDetailsString');
    Map<String, dynamic> mappedMessages = json.decode(messageDetailsString);
    // print('mappedMessages $mappedMessages');
    List<dynamic> messages = mappedMessages['12345']['messages'];
    print('list $messages');
    // messages.forEach((_value) {
    //   print('value is $_value');
    // });
    return messages;
  }

  List<Widget> getMessages() {
    List<Widget> tempList = List();
    tempList.add(Text('No messages found'));

    loadMessageDetails().then((_value) {
      if (_value != null) {
      } else {}
    });
    return tempList;
  }
}
