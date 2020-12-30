import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SlackApi {
  final _baseUrl = 'slack.com';

  Future<http.Response> fetchSlackUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String slackOAuthToken = prefs.getString('oauthtoken');
    
    final uri = Uri.https(_baseUrl, '/api/users.list/', {
      'token' : slackOAuthToken
    });

    final response = await http.get(uri);

    return response;
  }
}