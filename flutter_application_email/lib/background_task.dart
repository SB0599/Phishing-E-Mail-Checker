import 'dart:ffi';

import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import 'notification.dart';
// import 'main.dart';
import 'mail.dart';
import 'parse.dart';
import 'fileIO.dart';
import 'api.dart';

Future<void> Routine() async {
  print("background check");
  await notificationService.showLocalNotification(
      id: 0,
      title: "Backround works",
      body: "Background",
      payload: "Background");
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void checkNewMail() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: "); //simpleTask will be emitted here.
    EMail mail = new EMail();
    ParseMail parser = new ParseMailURL();
    FileIO IO = new FileIO();
    String email;
    String pwd;
    String? urlapi;
    String? emailserver;
    String? file;
    int checkType;
    List<dynamic>? Links;

    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();

    email = await inputData!["email"];
    pwd = await inputData["pwd"];
    urlapi = await IO.readConfigFile("api"); // inputData["api"];
    //checkType = int.parse(await IO.readConfigFile("checkType").toString());

    emailserver =
        await IO.readConfigFile("server"); //await inputData["server"];
    file = await IO.readConfigFile("ReadFileName");
    var filtermethode = int.tryParse(await IO.readConfigFile("Filtermethode"));
    if (filtermethode == null) {
      filtermethode = 2;
    }
    await mail.MailLogin(email, pwd);
    mail.ReceiveMail();

    // notificationService.showLocalNotification(
    //     id: 0, title: "Email Scanner", body: "signIn", payload: "");

    while (true) {
      await Future.delayed(Duration(seconds: 10));

      if (mail.signUp) {
        List<MailMessage> Messages = await mail.ReceiveNewMail();
        await parser.parse(Messages);
        switch (filtermethode) {
          case 1:
            parser.checkFile(Links);
            break;
          case 2:
            API api = new APIURLhaus();
            parser.checkURL(api);
            break;
          case 3:
            API api = new APIMISP();
            parser.checkURL(api);
            break;
          default:
            break;
        }
      }
    }
    //return Future.value(true);
  });
}
