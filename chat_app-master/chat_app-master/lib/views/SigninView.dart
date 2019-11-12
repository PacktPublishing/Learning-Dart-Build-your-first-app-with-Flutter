/*
 * -----
 * \SigninView.dart
 * Created on: Nov 23 2018
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
 * PROVIDES A VIEW WHERE THE USER CAN SIGN IN
 * -----
 */
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninView extends StatefulWidget {
  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Card(
                color: Colors.blue[200],
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Sign in to Chat Apps',
                        style: Theme.of(context).textTheme.title,
                      ),
                      // SOME SPACER
                      SizedBox(height: 40.0),
                      RaisedButton.icon(
                        icon: Icon(Icons.person),
                        label: Text('Sign in with Google'),
                        onPressed: () async {
                          // SHOWS SIGN IN UI
                          GoogleSignInAccount googleUser = await GoogleSignIn()
                              .signIn()
                              .timeout(Duration(seconds: 180));

                          // AUTHENTICATE USER
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          // ADD THE GOOGLE SIGNED IN USER TO FIREBASE INSTANCE
                          await FirebaseAuth.instance.signInWithGoogle(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );
                        },
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        // TODO: ADD THE TERMS OF USE AND PRIVACY POLICY DOCS
                        'By signing in, you agree to the Terms of Use and Privacy Policy',
                        style: Theme.of(context).textTheme.body2,
                        textAlign: TextAlign.center,
                        // IN REAL WORLD USE, MAKE SURE THE USER KNOWS AND CAN
                        // ACCESS THE TERMS OF USE AND PRIVACY POLICIES. THEY
                        // SHOULD HAVE A BUTTON THAT CAN OPEN A BROWSER OR
                        // ADD A TEXT WIDGET OR DIALOG THAT SHOWS THE DOCS
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
