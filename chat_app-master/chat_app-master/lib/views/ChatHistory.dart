/*
 * -----
 * \ChatHistory.dart
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
 * SHOWS THE USER'S CHAT HISTORY WITH OTHER FRIENDS
 * -----
 */

import 'package:chat_app/ChatHead.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  FirebaseUser firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser _user) {
      setState(() {
        firebaseUser = _user; // SET THE STATE OF THE FIREBASEUSER
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: firebaseUser == null
              // SHOW INDICATOR WHEN THERE IS NO USER YET
              ? CircularProgressIndicator()
              : StreamBuilder(
                  // WHEN THE FIREBASE USER STATE IS NOT NULL, THEN QUERY
                  // FIRESTORE FOR THE MESSAGE DATA
                  stream: Firestore.instance
                      .collection('/message_data') // THE FIRESTORE COLLECTION
                      .where('participants', arrayContains: firebaseUser.uid)
                      .snapshots(), // RETURNS SNAPSHOTS OF THE DOCUMENTS
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // CATCH THE ERROR FIRST
                    if (snapshot.hasError)
                      return Text(
                          'An error occured: ${snapshot.error.toString()}');

                    // CHECK THE STREAM'S CONNECTION STATE
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        // ALWAYS CHECK IF THERE IS DATA
                        if (snapshot.data.documents.length > 0) {
                          // WHEN THE DOCUMENTS ARE MORE THAN 0, PROCEED TO
                          // BUILDING THE LIST
                          return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot _document =
                                  snapshot.data.documents[index];
                              print(
                                  '_document > ${_document['participants'][0]}');

                              List<dynamic> participants_names =
                                  _document['participants_names'];

                              int friendIndex =
                                  participants_names.indexWhere((data) {
                                return data['uid'] != firebaseUser.uid;
                              });

                              Map<String, dynamic> last_message =
                                  Map<String, dynamic>.from(
                                      _document.data['last_message']);

                              // RETURNS A CHATHEAD WIDGET TO SHOW THE CHAT
                              // DETAIL
                              return ChatHead(
                                friendName: participants_names[friendIndex < 0
                                    ? 0
                                    : friendIndex]['display_name'],
                                messageTime: last_message['timestamp'],
                                lastMessage: last_message['content'],
                                friendId: participants_names[friendIndex]
                                    ['uid'],
                                avatar: participants_names[friendIndex]
                                    ['avatar'],
                              );
                            },
                          );
                        } else {
                          // THERE ARE NO DOCUMENTS FOUND
                          //
                          // IT WOULD BE A GOOD IDEA TO SHOW SOME TEXTS
                          // EXPLAINING WHY THERE IS NOTHING TO SEE
                          return Text('You don\'t have any conversations yet');
                        }
                      } else {
                        // SNAPSHOT HAS DATA, MEANING THAT THE COLLECTION WAS
                        // FOUND, ALTHOUGH IT DOES NOT NECESSARILY MEAN THAT
                        // THERE ARE DATA INSIDE
                        //
                        // IT WOULD BE A GOOD IDEA TO SHOW SOME TEXTS
                        // EXPLAINING WHY THERE IS NOTHING TO SEE
                        return Text('No chats found');
                      }
                    } else {
                      // IF FIRESTORE CONNECTION STATE IS NOT ACTIVE, SHOW
                      // AN INDICATOR SO THAT USERS WILL NOT BE SHOWN EMPTY
                      // VIEWS. IT WOULD BE A GOOD IDEA TO ALSO SHOW SOME TEXTS
                      // EXPLAINING WHY THERE IS NOTHING TO SEE
                      return CircularProgressIndicator();
                    }
                  },
                )),
    );
  }
}
