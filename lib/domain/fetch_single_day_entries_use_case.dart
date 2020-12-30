import 'dart:convert';

import 'package:dailytimesheetchecker/network/api/tickspot_api.dart';
import 'package:dailytimesheetchecker/network/model/entry.dart';
import 'package:intl/intl.dart';

class FetchSingleDayEntriesUseCase {
  Future<double> fetchTotalEntriesForDay(int userId, DateTime date) async {
    String formattedDate = getFormattedDate(date);
    Map<String, String> queryMap = {
      'start_date': formattedDate,
      'end_date': formattedDate,
      'user_id': '$userId'
    };

    var response = await TickspotApi().fetchEntriesForUser(queryMap);

    if (response.statusCode == 200) {
      var entries = _getEntryListFromJson(response.body);
      return _getEntriesSum(entries);
    } else {
      return -1;
    }
  }

  String getFormattedDate(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  List<Entry> _getEntryListFromJson(String jsonResponse) {
    var jsonArray = json.decode(jsonResponse) as List;
    return jsonArray.map<Entry>((json) => Entry.fromJson(json)).toList();
  }

  double _getEntriesSum(List<Entry> entries) {
    double sum = 0;
    entries.forEach((entry) {
      sum += entry.hours;
    });

    return sum;
  }
}
