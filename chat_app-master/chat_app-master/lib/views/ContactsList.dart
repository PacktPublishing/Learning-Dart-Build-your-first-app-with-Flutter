/*
 * -----
 * \ContactsList.dart
 * Created on: Nov 24 2018
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
 * SHOWS THE USER'S CONTACTS
 * -----
 */
import 'package:chat_app/ChatHead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  FirebaseUser _firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.currentUser().then((_user) {
      setState(() {
        _firebaseUser = _user; // SET THE STATE OF THE FIREBASEUSER
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start a new conversation'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: _firebaseUser == null
            // SHOW INDICATOR WHEN THERE IS NO USER YET
            ? Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : StreamBuilder(
                // WHEN THE FIREBASE USER STATE IS NOT NULL, THEN QUERY
                // FIRESTORE FOR THE CONTACTS
                stream: Firestore.instance
                    // THE COLLECTION NAME TO QUERY
                    .collection('/user_data/${_firebaseUser.uid}/friends_list')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // CATCH THE ERROR FIRST
                  if (snapshot.hasError)
                    return Text(
                        'An error occured ${snapshot.error.toString()}');

                  // CHECK THE STREAM'S CONNECTION STATE
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      // ALWAYS CHECK IF THERE IS DATA
                      if (snapshot.data.documents.length > 0) {
                        // WHEN THE DOCUMENTS ARE MORE THAN 0, PROCEED TO
                        // BUILDING THE LIST
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot _document =
                                snapshot.data.documents[index];
                            print('_document > ${_document['']}');

                            // RETURNS A CHATHEAD WIDGET TO SHOW THE CHAT
                            // DETAIL
                            return ChatHead(
                              friendName: _document['display_name'],
                              avatar: _document['avatar'],
                              isForContactOnly: true,
                              friendId: _document['uid'],
                            );
                          },
                        );
                      } else {
                        // THERE ARE NO DOCUMENTS FOUND
                        //
                        // IT WOULD BE A GOOD IDEA TO SHOW SOME TEXTS
                        // EXPLAINING WHY THERE IS NOTHING TO SEE
                        return Center(
                            child: Text('No messages found. Send one now.'));
                      }
                    } else {
                      // SNAPSHOT HAS DATA, MEANING THAT THE COLLECTION WAS
                      // FOUND, ALTHOUGH IT DOES NOT NECESSARILY MEAN THAT
                      // THERE ARE DATA INSIDE
                      //
                      // IT WOULD BE A GOOD IDEA TO SHOW SOME TEXTS
                      // EXPLAINING WHY THERE IS NOTHING TO SEE
                      return Text('No messages found. Send one now.');
                    }
                  } else {
                    // IF FIRESTORE CONNECTION STATE IS NOT ACTIVE, SHOW
                    // AN INDICATOR SO THAT USERS WILL NOT BE SHOWN EMPTY
                    // VIEWS. IT WOULD BE A GOOD IDEA TO ALSO SHOW SOME TEXTS
                    // EXPLAINING WHY THERE IS NOTHING TO SEE
                    return Center(
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }

  /// Creates a "unique" conversation id that will be used to query firestore
  String conversationId(String _friendId) {
    List<String> _friends = [_firebaseUser.uid, _friendId];

    // SORT THE FRIENDS' UID
    _friends.sort((a, b) {
      return a.compareTo(b);
    });

    // ADD A DELIMITER BETWEEN THE FRIENDS' UIDS
    _friends.insert(1, "___");

    // COMBINE (REDUCE) THE LIST TO A SINGLE STRING
    final String _conversationId = _friends.reduce((a, b) {
      return a.toString() + b.toString();
    });

    // RETURN FORMED STRING
    return _conversationId;
  }
}
