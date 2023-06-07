import 'mail.dart';
import 'parse.dart';

void mainRoutine(email, parser) async {
  while (true) {
    await Future.delayed(Duration(seconds: 2));
    List<MailMessage> Messages = await email.ReceiveNewMail();
    parser.parse(Messages);
    parser.checkLinks();
    print("check");
  }
}
