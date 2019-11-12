/*
 * -----
 * \Helper.dart
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
 * GENERAL FUNCTIONS FOR THE APP
 * -----
 */

import 'dart:convert';

import 'package:flutter/material.dart';

/// Loads the json file contents and returns a MAP
Future<Map<String, dynamic>> loadJsonFileAsMap(
    BuildContext context, String assetPath) async {
  // GET THE CONTENTS OF THE ASSET AS STRING
  String messageDetailsString =
      await DefaultAssetBundle.of(context).loadString(assetPath);

  // MAP THE CONTENT OF THE ASSET AS JSON OBJECT
  Map<String, dynamic> mappedMessages = json.decode(messageDetailsString);
  print('MAP $mappedMessages');

  // RETURN THE MAP
  return mappedMessages;
}
