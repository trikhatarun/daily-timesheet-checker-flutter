import 'package:dailytimesheetchecker/database/database_helper.dart';
import 'package:dailytimesheetchecker/database/model/user.dart';
import 'package:dailytimesheetchecker/network/api/slack_webhook_api.dart';

import 'fetch_single_day_entries_use_case.dart';

class ScanUseCase {
  List<User> _userList;
  String slackMessage = '';
  int defaultedUser = 0;

  Future<int> scan(DateTime dateTime) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.getDevsList().then((users) {
      _userList = users;
    });

    for(User user in _userList) {
      await FetchSingleDayEntriesUseCase().fetchTotalEntriesForDay(user.id, dateTime).then((totalHours) {
        if(totalHours < 7) {
          defaultedUser++;
          String slackId = user.slackId;
          if(slackMessage.isNotEmpty) {
            slackMessage = slackMessage + ', ' + '<@$slackId|cal>';
          } else {
            slackMessage += '<@$slackId|cal>';
          }
        }
      });
    }

    SlackWebhookApi slackWebhookApi = SlackWebhookApi();

    if(defaultedUser > 0) {
      var map = {
        'text' : slackMessage
      };
      slackWebhookApi.notifyDefaulters(map);
    } else {
      String date = FetchSingleDayEntriesUseCase().getFormattedDate(dateTime);
      slackMessage = 'Timesheet complete for $date';
      var map = {
        'text' : slackMessage
      };
      slackWebhookApi.notifySuccess(map);
    }

    return defaultedUser;
  }
}