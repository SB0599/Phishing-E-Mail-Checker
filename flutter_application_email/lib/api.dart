import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';

// http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
abstract class API {
  Future<bool> requestURL(url);
}

class APIURLhaus implements API {
  var client = new http.Client();

  @override
  Future<bool> requestURL(url) async {
    Map<String, String> body = {
      'url': url,
   };
    print(body);
    try {
      var res = await client
          .post(Uri.parse('https://urlhaus-api.abuse.ch/v1/url/'), body: body);
      var resJson = jsonDecode(res.body);
      if (resJson["query_status"] == "no_results") {
        print(resJson);
        return false;
      } else if (resJson["query_status"] == "ok") {
        print(url);
        return true;
      }
    } catch (e) {
      throw e;
    }

    return true; // throw error
  }
}

class APIMISP implements API {
  @override
  Future<bool> requestURL(url) async {
    var client = new http.Client();
    Map<String, String> header = {
      "Authorization": "API-KEY",
      'Accept': 'application/json',
      'Content-type': 'application/json'
    };
    Map<String, String> body = {
      "returnFormat": "json",
      "type": "url",
      "value": url
    };
    // Code Just for Testing without server certification
    HttpClient httpclient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(httpclient);
    http.Response resp = await ioClient.post(
        Uri.parse('https://domainname/attributes/restSearch'),
        body: utf8.encode(json.encode(body)),
        headers: header);

    var jsonresp = jsonDecode(resp.body);
    var res = jsonresp["response"];
    print(res["Attribute"]);
    if (res["Attribute"].isEmpty) {
      return false;
    } else {
      return true;
    }
    return false;
  }
}
