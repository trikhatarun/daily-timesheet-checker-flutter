import 'dart:convert';

import 'package:http/http.dart' as http;

class SlackWebhookApi {
  String _baseUrl = 'hooks.slack.com';

  Future<void> notifyDefaulters(Map<String, String> map) async {
    //todo(add chat message web hook where defaulters need to be notified)
    Uri url = Uri.https(_baseUrl, '');
    /*Uri url = Uri.https(_baseUrl, '');
*/
    final response = await http.post(url, body: json.encode(map));
    print(response.body);
    return null;
  }

  Future<void> notifySuccess(Map<String, String> map) async {
  //todo(add chat message web hook where success is to be notified)
    Uri url = Uri.https(_baseUrl, '');
    /*Uri url = Uri.https(_baseUrl, '');*/
    final response = await http.post(url, body: json.encode(map));
    print(response.body);
    return null;
  }
}