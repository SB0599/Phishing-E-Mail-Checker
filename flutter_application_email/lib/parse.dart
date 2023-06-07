import 'package:flutter/material.dart';
import 'mail.dart';
import 'notification.dart';

abstract class ParseMail {
  int parse(List<MailMessage> Messages);
  void checkURL(urlapi);
  void checkFile(data);
}

class ParseMailURL implements ParseMail {
  Map<String, String> URLs = new Map();
  //NotificationService note = new NotificationService();

  // insert all Links to List URLs
  int parse(List<MailMessage> Messages) {
    final links =
        RegExp(r'https?://[\w./%-:]+[\w/]+'); //TODO: richtiger Regex finden!

    for (MailMessage message in Messages) {
      print(message.sender);
      Iterable<Match> matches;
      if (message.header != null) {
        matches = links.allMatches(message.header);
        for (final Match m in matches) {
          String match = m[0]!;
          //URLs["sender"] = message.sender.toString();
          URLs[message.sender.toString()] = match;
          //URLs.add(message.sender, match);
          //print(match);
        }
      }
      if (message.body != null) {
        matches = links.allMatches(message.body);
        for (final Match m in matches) {
          String match = m[0]!;
          URLs[message.sender.toString()] = match;
          // URLs["sender"] = message.sender.toString();
          // URLs["url"] = match;
          //URLs.add(match);
          //print(match);
        }
      }
      if (message.htmlpart != null) {
        matches = links.allMatches(message.htmlpart);
        for (final Match m in matches) {
          String match = m[0]!;
          URLs[message.sender.toString()] = match;
          // URLs["sender"] = message.sender.toString();
          // URLs["url"] = match;
          //URLs.add(match);
          //print(match);
        }
      }
    }
    return 1;
  }

  @override
  void checkURL(urlapi) async {
    // TODO: insert switch case for chioce of user what api will use
    if (URLs.length != 0) {
      URLs.forEach((key, value) async {
        if (await urlapi.requestURL(value)) {
          var notifyString = "Link: " + value + "\nFrom: " + key;
          notificationService.showLocalNotification(
              id: 0,
              title: "Phishing Verdacht",
              body: notifyString,
              payload: "");
        }
      });
    }
    URLs.clear();
  }

  @override
  void checkFile(links) {
    //print(URLs.length);
    //print(links);
    if (URLs.length != 0) {
      URLs.forEach((key, value) async {
        for (var link in links) {
          if (link == value) {
            var notifyString = "Link: " + value + "\nFrom: " + key;
            notificationService.showLocalNotification(
                id: 0,
                title: "Phishing Verdacht",
                body: notifyString,
                payload: "");
          }
        }
      });
      URLs.clear();
    }
  }
}
