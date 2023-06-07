import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../fileIO.dart';

class EmailSettings extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final EmailServer = TextEditingController();
  final EmailServerPort = TextEditingController();

  static final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("E-mail settings"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: EmailServer,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'email server',
                  ),
                ),
                TextFormField(
                  controller: EmailServerPort,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'email server port',
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: _useSettings,
                  child: Text('use settings'),
                )
              ],
            ),
          ),
        ));
  }

  void _useSettings() {
    FileIO IO = new FileIO();
    IO.writeConfigFile("server", EmailServer.text);
    IO.writeConfigFile("serverPort", EmailServerPort.text);
    // storage.write(key: "server", value: EmailServer.text);
    // storage.write(key: "serverPort", value: EmailServerPort.text);
  }
}
