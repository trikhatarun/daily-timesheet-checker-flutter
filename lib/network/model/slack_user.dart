import 'package:flutter/cupertino.dart';

class SlackUser {
  final String _id;
  final String _email;

  SlackUser(this._id, this._email);

  factory SlackUser.fromJson(Map<String, dynamic> json) {
    return SlackUser(json['id'], json['profile']['email']);
  }

  String get email => _email;

  String get id => _id;
}