import 'dart:io';
import 'package:enough_mail/enough_mail.dart';

/*String userName = 'test.for.fh.phishing@gmx.de';
String password = 'StarkesPasswortPhishing';
String imapServerHost = 'imap.gmx.net';
int imapServerPort = 993;*/
bool isImapServerSecure = true;

class EMail {
  ImapClient client = ImapClient(isLogEnabled: false);
  String userName = "";
  String password = "";
  String imapServerHost = "imap.gmx.de";
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  bool signUp = false;
  static var status;
  MailMessage lastMessage = new MailMessage();
  List<MimeMessage> allMessageList = [];

  // input ServerHost and Port mapping
  Email() {}

  //TODO: Password und Email verschlüsselt speichern in extra file?
  Future<bool> MailLogin(userName, password) async {
    this.userName = userName;
    this.password = password;
    try {
      await this.client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await this.client.login(userName, password);
      signUp = true;
      return true;
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return false;
    }
  }

  Future<List<MailMessage>> ReceiveMail() async {
    List<MailMessage> MessageList = [];
    await this.client.selectInbox();
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 10, criteria: 'BODY.PEEK[]');
    for (final message in fetchResult.messages) {
      MailMessage Message = new MailMessage();
      Message.sender = message.from;
      Message.header = message.decodeSubject();
      Message.body = message.decodeTextPlainPart();
      Message.htmlpart = message.decodeTextHtmlPart();
      lastMessage = Message;
      MessageList.add(Message);
      allMessageList.add(message);
      //printMessage(message);
    }
    return MessageList;
  }

//TODO: wie können nur neue mails empfangen werden?
  Future<List<MailMessage>> ReceiveNewMail() async {
    List<MailMessage> MessageList = [];
    await this.client.selectInbox();
    var fetchResult = await client.fetchRecentMessages(
        messageCount: 10, criteria: 'BODY.PEEK[]');
    if (allMessageList != [] && fetchResult.messages != []) {
      if (allMessageList.last.allPartsFlat.toString() !=
          fetchResult.messages.last.allPartsFlat.toString()) {
        //fetchResult.replaceMatchingMessages(allMessageList);
        List<MimeMessage> allMessageListVar = allMessageList;
        final result = deletDouble(allMessageListVar, fetchResult.messages);
        print(result.length);
        //fetchResult.replaceMatchingMessages(allMessageListVar);
        for (final message in result) {
          //fetchResult.messages) {
          MailMessage Message = new MailMessage();
          Message.sender = message.from;
          Message.header = message.decodeSubject();
          Message.body = message.decodeTextPlainPart();
          Message.htmlpart = message.decodeTextHtmlPart();
          lastMessage = Message;
          MessageList.add(Message);
          allMessageList.add(message);
          // print("New mail");
          // print(Message.sender);
        }
        //printMessage(message);
      }
    }
    return MessageList;
  }

  List<MimeMessage> deletDouble(List<MimeMessage> l1, List<MimeMessage> l2) {
    List<MimeMessage> result = [];
    for (var message in l1) {
      final uid = message.allPartsFlat.toString();
      for (var message2 in l2) {
        final uid2 = message2.allPartsFlat.toString();
        if (uid == uid2) {
          result.add(message2);
        }
      }
    }
    for (var msg in result) {
      l2.remove(msg);
    }
    return l2;
  }

  Future<void> MailLogout() async {
    await client.logout();
    signUp = false;
  }
}

class MailMessage {
  var sender;
  var header;
  var body;
  var htmlpart;

  var timestamp;
  var hash;
}

class EMailPop {
  PopClient popClient = PopClient(isLogEnabled: false);
  String userName = "";
  String password = "";
  String popServerHost =
      'pop.gmx.net'; //TODO Mappen und mit radio butten auswahl einstellbar machen
  int popServerPort = 995; //TODO Mappen
  bool isPopServerSecure = true;
  var signUp;
  static var status;

  static int messageCount = 0;

  // input ServerHost and Port mapping
  EmailPop() {}

  //TODO: Password und Email verschlüsselt speichern in extra file?
  Future<bool> MailLogin(userName, password) async {
    this.userName = userName;
    this.password = password;
    try {
      await popClient.connectToServer(popServerHost, popServerPort,
          isSecure: isPopServerSecure);
      await popClient.login(userName, password);
      status = await popClient.status();

      final messageList = await popClient.list(status.numberOfMessages);
      var messages = await popClient.retrieve(status.numberOfMessages);
      print(messageCount);
      return true;
    } on PopException catch (e) {
      print('POP connection failed with $e');
      return false;
    }
  }

  Future<List<MailMessage>> ReceiveMail() async {
    List<MailMessage> MessageList = [];
    print(status.numberOfMessages);
    final messageList = await popClient.list(status.numberOfMessages);
    var messages = await popClient.retrieve(status.numberOfMessages);
    messages = await popClient.retrieve(status.numberOfMessages + 1);
    MailMessage Message = new MailMessage();
    Message.sender = messages.from;
    Message.header = messages.decodeSubject();
    Message.body = messages.decodeTextPlainPart();
    Message.htmlpart = messages.decodeTextHtmlPart();
    Message.timestamp = messages.decodeDate();
    Message.hash = messages.hashCode;
    MessageList.add(Message);

    //printMessage(message);

    return MessageList;
  }

//TODO: wie können nur neue mails empfangen werden?
  Future<List<MailMessage>> ReceiveNewMail() async {
    List<MailMessage> MessageList = [];
    final status = await popClient.status();
    final messageList = await popClient.list(status.numberOfMessages);
    var messages = await popClient.retrieve(status.numberOfMessages);
    //print(messages);
    messages = await popClient.retrieve(status.numberOfMessages + 1);
    MailMessage Message = new MailMessage();
    Message.sender = messages.from;
    Message.header = messages.decodeSubject();
    Message.body = messages.decodeTextPlainPart();
    Message.htmlpart = messages.decodeTextHtmlPart();
    Message.timestamp = messages.decodeDate();
    Message.hash = messages.hashCode;
    MessageList.add(Message);
    //printMessage(message);

    return MessageList;
  }

  Future<void> MailLogout() async {
    await popClient.quit();
  }
}
