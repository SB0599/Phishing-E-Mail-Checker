import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

class FileIO {
  List<dynamic>? Links;
  var filename;

  Future<String> get _localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); //getApplicationSupportDirectory();

    return directory.path;
  }

  Future<String?> get _downloadPath async {
    final directory = await getDownloadPath();

    return directory;
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<File> get _localFile async {
    final path = await _downloadPath;
    return File('$path/$filename');
  }

  Future<List<dynamic>?> readFile(name) async {
    filename = name;
    try {
      var myFile = await _localFile;
      final content = await myFile.readAsStringSync();
      Links = const CsvToListConverter().convert(content);
      return Links;
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return null;
    }
  }

  Future<File> get _localConfFile async {
    final path = await _localPath;
    return File('$path/Config.json');
  }

  Future<dynamic> readConfigFile(key) async {
    try {
      var myFile = await _localConfFile;
      final content = await myFile.readAsString();
      Map<String, dynamic> settings = jsonDecode(content);
      return settings[key];
    } catch (e) {
      return null;
    }
  }

  Future<bool> writeConfigFile(key, value) async {
    try {
      var myFile = await _localConfFile;
      Map<String, dynamic> settings = {key: value};
      myFile.writeAsString(jsonEncode(settings));
      return true;
    } catch (e) {
      return false;
    }
  }

  // void creatConfFile(){
  //   var myFile = await _localConfFile;
  // }

  List<dynamic>? getLinks() {
    return Links;
  }
}
