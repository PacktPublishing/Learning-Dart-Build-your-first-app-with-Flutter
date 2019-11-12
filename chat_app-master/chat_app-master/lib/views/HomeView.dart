/*
 * -----
 * \HomeView.dart
 * Created on: Nov 19 2018
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
 * SHOWS A BASE SCREEN FOR THE USER
 * -----
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// The logged in user
  FirebaseUser firebaseUser;

  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser _user) {
      setState(() {
        firebaseUser = _user; // SET THE STATE OF THE FIREBASEUSER
      });
    });
  }

  /// Gets the user's document. Returns a <future> DocumentSnapshot
  Future<DocumentSnapshot> getDocument() async {
    return Firestore.instance.document('/user_data/${firebaseUser.uid}').get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Column(
        children: <Widget>[
          // USE A FUTURE BUILDER TO LISTEN TO A FUTURE OBJECT, THEN PERFORM
          // NECESSARY PROCEDURES WHEN THE FUTURE IS RESOLVED.
          FutureBuilder(
            future: getDocument(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // CHECK FOR ERRORS FIRST
              if (snapshot.hasError) return Text('An error occured');

              if (snapshot.connectionState == ConnectionState.waiting) {
                // IF CONNECTION IS STILL WAITING, SHOW A PROGRESS INDICATOR
                return CircularProgressIndicator();
              } else {
                // IF CONNECTION IS NOT WAITING ANYMORE, CHECK IF THERE IS DATA
                if (snapshot.hasData && snapshot.data.data != null) {
                  print(snapshot.data.toString());
                  // NOW THAT THERE IS DATA, SHOW THE DISPLAY NAME
                  return Text('Hello, ${snapshot.data['display_name']}',
                      style: Theme.of(context).textTheme.headline);
                } else {
                  // IF THE USER'S DETAIL CANNOT BE RETRIEVED
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('* Cannot retrieve user details *'),
                  );
                }
              }
            },
          ),
          SizedBox(height: 50.0),
          FutureBuilder(
            // USE A FUTURE BUILDER TO LISTEN TO A FUTURE OBJECT, THEN PERFORM
            // NECESSARY PROCEDURES WHEN THE FUTURE IS RESOLVED.
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) return Text('An error occured');
              if (snapshot.hasData) {
                print('CURRENT USER > ${snapshot.data}');
                final FirebaseUser _temp = snapshot.data;
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("UID > ${_temp.uid}"),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _temp.uid));
                      },
                    ),
                    RaisedButton(
                      child: Text("Display name > ${_temp.displayName}"),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _temp.displayName));
                      },
                    ),
                    RaisedButton(
                      child: Text("Avatar > ${_temp.photoUrl}"),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _temp.photoUrl));
                      },
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      )),
    );
  }
}
