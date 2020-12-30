import 'package:dailytimesheetchecker/database/database_helper.dart';
import 'package:dailytimesheetchecker/network/model/slack_user.dart';
import 'package:dailytimesheetchecker/network/model/tick_user.dart';

class User {
  int _id;
  String _email;
  String _name;
  String _slackId;
  bool _completed;
  bool _isDev;

  User(this._id, this._email, this._name, this._slackId, this._completed,
      this._isDev);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[DatabaseHelper.colId] = _id;
    map[DatabaseHelper.colEmail] = _email;
    map[DatabaseHelper.colName] = _name;
    map[DatabaseHelper.colSlackId] = _slackId;
    map[DatabaseHelper.colCompleted] = _completed == true ? 1 : 0;
    map[DatabaseHelper.colDev] = _isDev == true ? 1 : 0;

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._id = map[DatabaseHelper.colId];
    this._email = map[DatabaseHelper.colEmail];
    this._name = map[DatabaseHelper.colName];
    this._slackId = map[DatabaseHelper.colSlackId];
    this._completed = map[DatabaseHelper.colCompleted] == 1;
    this._isDev = map[DatabaseHelper.colDev] == 1;
  }

  User.fromSlackAndTickUser(SlackUser slackUser, TickUser tickUser) {
    String firstName = tickUser.firstName;
    String lastName = tickUser.lastName;

    String name = '$firstName $lastName';

    this._id = tickUser.id;
    this._email = tickUser.email;
    this._name = name;
    this._slackId = slackUser.id;
    this._completed = false;
    this._isDev = false;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get slackId => _slackId;

  set slackId(String value) {
    _slackId = value;
  }

  bool get completed => _completed;

  set completed(bool value) {
    _completed = value;
  }

  bool get isDev => _isDev;

  set isDev(bool value) {
    _isDev = value;
  }
}
