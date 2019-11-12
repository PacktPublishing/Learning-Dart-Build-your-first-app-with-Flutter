/*
 * -----
 * \ChatMessages.dart
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
 * SHOWS THE LIST OF CHAT MESSAGES
 * -----
 */
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  @override
  _ChatMessagesState createState() => _ChatMessagesState();

  /// Whether the message comes the friend
  final bool isFriend;

  /// The friend's initial to show in the avatar
  final String friendInitial;

  /// Whether the message is last or not
  final bool isNotPrevious;

  /// the actual message
  final String message;

  final String avatarUrl;

  final String friendId;

  ChatMessages({
    Key key,
    this.isFriend: false,
    this.isNotPrevious: false,
    this.message: "",
    this.friendInitial: "",
    this.avatarUrl: "",
    this.friendId,
  }) : super(key: key);
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.0),
      // height: 100.0,
      width: double.infinity,
      // color: Colors.grey[300],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 40.0,
            child: widget.isFriend // && widget.isNotPrevious
                ? CircleAvatar(
                    backgroundImage: Image.network(widget.avatarUrl).image,
                    radius: 20.0,
                    backgroundColor: Colors.white,
                    // child: Text(widget.friendInitial),
                  )
                : Container(),
          ),
          Expanded(
            child: Container(
                height: 40.0,
                color: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(widget.message,
                    textAlign:
                        widget.isFriend ? TextAlign.start : TextAlign.end)),
          ),
          SizedBox(
            width: 40.0,
            child: !widget.isFriend // && widget.isNotPrevious
                ? CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.white,
                    child: Text("Me"),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
