import 'dart:convert';

import 'package:dailytimesheetchecker/database/database_helper.dart';
import 'package:dailytimesheetchecker/database/model/user.dart';
import 'package:dailytimesheetchecker/network/api/slack_api.dart';
import 'package:dailytimesheetchecker/network/api/tickspot_api.dart';
import 'package:dailytimesheetchecker/network/model/slack_user.dart';
import 'package:dailytimesheetchecker/network/model/tick_user.dart';

class InitDataUseCase {
  List<TickUser> _tickUsers;
  List<SlackUser> _slackUsers;
  List<User> _mergedUsers;

  Future<void> init() async {
    await TickspotApi().fetchTickUsers().then((response) {
      if (response.statusCode == 200) {
        _tickUsers = _parseTickUsers(response.body);
      }
    });

    await SlackApi().fetchSlackUsers().then((response) {
      if (response.statusCode == 200) {
        _slackUsers = _parseSlackUser(response.body);
      }
    });

    _mergeUsers();

    await _updateDatabase();

    return null;
  }

  List<TickUser> _parseTickUsers(String responseBody) {
    final parsed = json.decode(responseBody) as List;
    return parsed.map<TickUser>((json) => TickUser.fromJson(json)).toList();
  }

  List<SlackUser> _parseSlackUser(String responseBody) {
    final parsed = json.decode(responseBody);
    final parsedList = parsed['members'] as List;
    return parsedList
        .map<SlackUser>((json) => SlackUser.fromJson(json))
        .toList();
  }

  void _mergeUsers() {
    _mergedUsers = List<User>();
    _tickUsers.forEach((tickUser) {
      SlackUser matchingSlackUser;
      _slackUsers.forEach((slackUser) {
        if (slackUser.email == tickUser.email) {
          matchingSlackUser = slackUser;
        }
      });
      if (matchingSlackUser != null) {
        _mergedUsers
            .add(User.fromSlackAndTickUser(matchingSlackUser, tickUser));
      }
    });
  }

  _updateDatabase() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.getUsersList().then((localUsers) {
      localUsers.forEach((userDb) {
        User matchedUser;
        for (User userNetwork in _mergedUsers) {
          if (userDb.id == userNetwork.id) {
            matchedUser = userNetwork;
            break;
          }
        }
        _mergedUsers.remove(matchedUser);
      });

      if (_mergedUsers.length != 0) {
        databaseHelper.insertUsers(_mergedUsers);
      }
    });
  }
}
