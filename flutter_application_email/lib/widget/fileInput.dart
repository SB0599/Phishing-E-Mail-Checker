import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import '../fileIO.dart';

class FileInput extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final FileName = TextEditingController();

  var Links = [];

  var filtermethode = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("File Input"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Android: File in Download folder\nIOS: ?'),
                TextFormField(
                  controller: FileName,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'File name',
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: _readFile,
                  child: Text('Insert File'),
                ),
                Visibility(
                  child: Text("File inserted"),
                  visible: false,
                )
              ],
            ),
          ),
        ));
  }

  // Future<String> get _localPath async {
  //   final directory =
  //       await getApplicationDocumentsDirectory(); //getApplicationSupportDirectory();

  //   return directory.path;
  // }

  // // ignore: unused_element
  // Future<File> get _localFile async {
  //   final path = await _localFile;
  //   return File('$path/Config.json');
  // }

  Future<void> _readFile() async {
    final file_name = FileName.text;
    FileIO IO = new FileIO();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
    }

    try {
      await IO.writeConfigFile("ReadFileName", file_name);
      await IO.writeConfigFile("Filtermethode", filtermethode);
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> getLinks() {
    return Links;
  }
}
