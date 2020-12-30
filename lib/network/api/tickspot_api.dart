import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TickspotApi {
  final _baseUrl = 'www.tickspot.com';

  Future<http.Response> login(String email, String password) async {
    final uri = Uri.https(_baseUrl, 'api/v2/roles.json');

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final authBase = '$email:$password';
    String encodedAuthBase = stringToBase64.encode(authBase);
    //todo(add user agent: AppName (email))
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Basic $encodedAuthBase',
        'User-Agent': ''
      },
    );

    return response;
  }

  Future<http.Response> fetchTickUsers() async {
    var prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('authToken');
    int subscriptionId = prefs.getInt('subscriptionId');

    final uri = Uri.https(_baseUrl, '$subscriptionId/api/v2/users.json');
    //todo(add user agent: AppName (email))
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Token token=$authToken',
      'User-Agent': ''
    });

    return response;
  }

  Future<http.Response> fetchEntriesForUser(
      Map<String, String> queryMap) async {
    var prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('authToken');
    int subscriptionId = prefs.getInt('subscriptionId');

    final uri =
        Uri.https(_baseUrl, '$subscriptionId/api/v2/entries.json', queryMap);
    //todo(add user agent: AppName (email))
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Token token=$authToken',
      'User-Agent': ''
    });

    return response;
  }
}
