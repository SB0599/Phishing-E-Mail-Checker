import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../fileIO.dart';

class APIURLSettings extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  final API = TextEditingController();
  final APIKey = TextEditingController();

  static final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("API URL"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: API,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'url',
                  ),
                ),
                TextFormField(
                  controller: APIKey,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'url key',
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: _setAPI,
                  child: Text('set URL'),
                ),
              ],
            ),
          ),
        ));
  }

  void _setAPI() {
    FileIO IO = new FileIO();
    if (APIKey.text == "") {
      IO.writeConfigFile("api", API.text);
      //storage.write(key: "api", value: API.text);
    } else {
      String result = API.text + APIKey.text;
      IO.writeConfigFile("api", result);
      //storage.write(key: "api", value: result);
    }
  }
}
