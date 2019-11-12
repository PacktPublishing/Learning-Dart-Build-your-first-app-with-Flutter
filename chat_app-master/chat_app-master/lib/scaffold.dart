/*
 * -----
 * \scaffold.dart
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
 * THE MAIN SCAFFOLD OF THE APP
 * -----
 */

import 'package:chat_app/views/ChatHistory.dart';
import 'package:chat_app/views/ContactsList.dart';
import 'package:chat_app/views/HomeView.dart';
import 'package:chat_app/views/SettingsView.dart';
import 'package:chat_app/views/SigninView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyChatApp extends StatefulWidget {
  @override
  _MyChatAppState createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  int _currentIndex = 0;
  bool isSignedIn = false;
  String photoUrl;
  FirebaseAuth _auth;

  @override
  void initState() {
    // TODO: implement initState
    _auth = FirebaseAuth.instance;

    // LISTEN TO AUTH CHANGES
    _auth.onAuthStateChanged.listen((_user) async {
      print('AUTH STATE CHANGED > $_user');
      if (_user != null) {
        // A USER HAS SIGNED IN
        setState(() {
          isSignedIn = true;
          photoUrl = _user.photoUrl;
        });

        // SAVE USER'S DETAIL TO FIRESTORE
        await Firestore.instance.document('/user_data/${_user.uid}').setData(
          {
            'display_name': _user.displayName,
            'last_signin': DateTime.now().toUtc(),
            'avatar': _user.photoUrl,
          },
          merge: true, // THIS MEANS CHANGES WILL OVERWRITE EXISTING FIELDS
        );
      } else {
        // A USER HAS SIGNED OUT
        setState(() {
          isSignedIn = false; // THE USER IS NULL
        });
      }
    });
  }

  /// Handles the text input for the displayname
  TextEditingController _displayNameController = TextEditingController();

  /// Handles the text input for the avatar
  TextEditingController _avatarController = TextEditingController();

  /// Handles the text input for the uid
  TextEditingController _uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
          builder: (BuildContext buildContext) => !isSignedIn
              ? SigninView()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("My Chat app"), // TODO: CHANGE ACCORDINGLY
                    centerTitle: true,
                    leading: CircleAvatar(
                      backgroundImage: FadeInImage.assetNetwork(
                        image: photoUrl ??
                            'https://img.icons8.com/material-rounded/48/user.png', // CHANGE THIS TO ANOTHER IF YOU HAVE TO
                        placeholder: 'assets/images/icons8-user-48.png',
                      ).image,
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () async {
                          print("button was pressed");
                          // OPEN THE DIALOG FOR THE FRIEND'S CREDS
                          await showDialog(
                              context: buildContext,
                              builder: (context) {
                                // SHOW AN ALERT DIALOG FOR ADDING FRIEND
                                return AlertDialog(
                                  title: Text('Add friend'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Display name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      TextFormField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'Display name'),
                                        controller: _displayNameController,
                                      ),
                                      SizedBox(height: 32.0),
                                      Text('Avatar URL',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      TextFormField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'Avatar URL'),
                                        controller: _avatarController,
                                      ),
                                      SizedBox(height: 32.0),
                                      Text('UID',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      TextFormField(
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'UID'),
                                        controller: _uidController,
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Add friend'),
                                      onPressed: () async {
                                        FirebaseUser _user = await FirebaseAuth
                                            .instance
                                            .currentUser();
                                        // SAVE THE DATA TO THE DATABASE
                                        await Firestore.instance
                                            .collection(
                                                '/user_data/${_user.uid}/friends_list')
                                            .document(_uidController.text)
                                            .setData({
                                          "display_name":
                                              _displayNameController.text,
                                          "uid": _uidController.text,
                                          "avatar": _avatarController.text,
                                        });
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.help),
                        onPressed: () async {
                          // TODO: SHOW MAYBE A HELP DIALOG OR SHOW/HIDE TEXT
                          // WIDGET FOR EXPLAINING THINGS TO THE USER
                          print("button was pressed");
                        },
                      )
                    ],
                  ),
                  body: selectedScreen(_currentIndex),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), title: Text("Home")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.mail_outline), title: Text("Chats")),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), title: Text("Settings")),
                    ],
                    onTap: (int index) {
                      print("index is " + index.toString());
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      print("FAB was pressed");
                      await Navigator.of(buildContext)
                          .push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return ContactsList(
                                    // friendName: widget.friendName,
                                    // lastMessage: "Snap",
                                    // friendId: widget.friendId,
                                    );
                              },
                              fullscreenDialog: true));
                    },
                    child: Icon(Icons.add),
                  ),
                )),
      // home: ChatView(),
    );
  }

  Widget selectedScreen(int _index) {
    switch (_index) {
      case 0:
        return HomeView();
        break;
      case 1:
        return ChatHistory();
        break;
      case 2:
        return SettingsView();
        break;
      default:
        return HomeView();
    }
  }
}
