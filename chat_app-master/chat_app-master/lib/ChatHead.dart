/*
 * -----
 * \ChatHead.dart
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
 * 
 * -----
 */
import 'package:chat_app/ChatView.dart';
import 'package:flutter/material.dart';

class ChatHead extends StatefulWidget {
  @override
  _ChatHeadState createState() => _ChatHeadState();

  /// This is the name of the friend
  final String friendName;

  /// This is the text that will appear below the name
  final String lastMessage;

  /// This is the time when the message was sent
  final DateTime messageTime;

  final String friendId;

  final String avatar;

  final bool isForContactOnly;

  ChatHead({
    Key key,
    this.friendName: "",
    this.lastMessage: "",
    this.messageTime,
    this.friendId,
    this.avatar: "",
    this.isForContactOnly: false,
  }) : super(key: key);
}

class _ChatHeadState extends State<ChatHead> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(widget.friendName + " has been tapped");
        await Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return ChatView(
                friendName: widget.friendName,
                lastMessage: "Snap",
                friendId: widget.friendId,
              );
            },
            fullscreenDialog: true));
      },
      highlightColor: Colors.blue,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        width: double.infinity,
        height: 100.0,
        color: Theme.of(context).cardColor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: widget.isForContactOnly
                  ? Text(
                      widget.friendName,
                      style: Theme.of(context).textTheme.title,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.friendName,
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(
                          widget.lastMessage,
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(widget.messageTime.toString()),
                      ],
                    ),
            ),
            CircleAvatar(
              radius: widget.isForContactOnly ? 24.0 : 32.0,
              backgroundImage: Image.network(widget.avatar).image,
              child: widget.avatar == ""
                  ? Text(widget.friendName.substring(0, 1),
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .apply(color: Colors.white, fontWeightDelta: 3))
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
