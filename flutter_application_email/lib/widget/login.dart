import 'package:flutter/material.dart';
import 'package:flutter_application_email/background_task.dart';

import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../mail.dart';
import '../start_background_task.dart';

//import '../parse.dart';

//import 'Routine.dart';

class Login extends StatelessWidget {
  final PasswordField = TextEditingController();
  final EmailField = TextEditingController();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  static EMail mail = new EMail();
  //static ParseMail parser = new ParseMail();
  static final storage = new FlutterSecureStorage();

  bool visibleflag = false;
  bool visibleflag2 = false;

  var context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: visibleflag,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:
                        'Wrong e-mail or passwort. Maybe wrong server.\nCheck in settings.',
                  ),
                ),
              ),
              Visibility(
                visible: visibleflag2,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:
                        'No autostart permisson pleas open app after every reboot.',
                  ),
                ),
              ),
              TextFormField(
                controller: EmailField,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'email address',
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: PasswordField,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'password',
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: _signIn,
                child: Text('sign in'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    var email;
    var pwd;
    const simplePeriodicTask =
        "be.tramckrijte.workmanagerExample.simplePeriodicTask";
    const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
    String urlapi = "default";

    if ("true" == await storage.read(key: "isSignIn")) {
      startTask();
      print("start task over registry credential");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _mySignUpPage()),
      );
    } else {
      if (await mail.MailLogin(EmailField.text, PasswordField.text)) {
        print("Sign Up");
        String emailServer = "imap." + EmailField.text.split("@").last;
        print(emailServer);
        await storage.write(key: "isSignIn", value: "true");
        await storage.write(key: "email", value: EmailField.text);
        await storage.write(key: "pw", value: PasswordField.text);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => _mySignUpPage()),
        // );
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => _mySignUpPage(),
        ));

        startTask();
      } else {
        visibleflag = true;
        // notification something is wrong couldnt sign in
      }
    }
  }
}

class _mySignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signed in"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Signed In"),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  //_signOut();
                  Navigator.pop(context);
                  Workmanager().cancelAll();
                  // TODO: credential aus registy löschen
                },
                child: Text('sign out'),
              )
            ]),
      ),
    );
  }
}
