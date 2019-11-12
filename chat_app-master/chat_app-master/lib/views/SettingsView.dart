/*
 * -----
 * \SettingsView.dart
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
 * PROVIDES A VIEW WHERE THE USER CAN CHANGE THE SETTINGS
 * -----
 */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Sign out'),
            onPressed: () async {
              try {
                // SIGNOUT THE USER FROM FIREBASE AUTH AND GOOGLE
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              } on PlatformException catch (pe) {
                // PLATFORM EXCEPTION CATCHER
                print('SIGNOUT PLERR > ${pe.message}');
              } catch (e) {
                print('SIGNOUT EXC > ${e.toString()}');
              }
            },
          )
        ],
      )),
    );
  }
}
