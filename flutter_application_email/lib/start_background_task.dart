import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void startTask() async {
  final storage = new FlutterSecureStorage();
  final simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";

  String? email = await storage.read(key: "email");
  String? pwd = await storage.read(key: "pw");
  String? api = await storage.read(key: "api");
  String? server = await storage.read(key: "server");

  if (server == null) {
    email = email as String;
    server = "imap." + email.split("@").last as String;
    print(server);
  }
  if (api == null) {
    api = "";
  }
  Workmanager().registerOneOffTask(simpleTaskKey, simpleTaskKey, inputData: {
    "email": email as String,
    "pwd": pwd as String,
    "api": api as String,
    "server": server as String
  });
}
