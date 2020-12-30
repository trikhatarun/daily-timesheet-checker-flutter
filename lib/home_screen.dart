import 'package:dailytimesheetchecker/database/database_helper.dart';
import 'package:dailytimesheetchecker/database/model/user.dart';
import 'package:dailytimesheetchecker/domain/init_data_use_case.dart';
import 'package:dailytimesheetchecker/domain/scan_use_case.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Timesheet Checker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              InitDataUseCase().init();
            },
            tooltip: 'Refresh database',
          )
        ],
      ),
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Member\'s list',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )),
                MemberList()
              ])),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ScanButton extends StatefulWidget {
  @override
  _ScanButtonState createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  bool _scanning = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (!_scanning) {
          DateTime dateToday = DateTime.now();
          Future<DateTime> selectedDate = showDatePicker(
            context: context,
            initialDate: dateToday,
            firstDate: DateTime(dateToday.year),
            lastDate: dateToday,
          );

          selectedDate.then((date) {
            setState(() {
              _scanning = true;
            });

            ScanUseCase().scan(date).then((int count) {
              setState(() {
                _scanning = false;
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Scan complete. $count devs haven\'t filled their timesheet.'),
              ));
            });
          });
        }
      },
      label: !_scanning ? Text('Start Scan') : Text('Scanning entries'),
      backgroundColor: Colors.indigo[900],
      icon: !_scanning ? Icon(Icons.play_arrow) : Icon(Icons.scanner),
    );
  }
}

class MemberList extends StatefulWidget {
  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.getUsersList(),
      builder: (BuildContext buildContext, AsyncSnapshot<List<User>> users) {
        if (users.connectionState == ConnectionState.done) {
          return Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext buildContext, int position) {
                return MemberListItem(user: users.data[position]);
              },
              itemCount: users.data.length,
              separatorBuilder: (BuildContext buildContext, int position) =>
                  Divider(
                    color: Colors.grey,
                    height: 0.0,
                  ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class MemberListItem extends StatefulWidget {
  final User user;

  MemberListItem({Key key, this.user}) : super(key: key);

  @override
  _MemberListItemState createState() => _MemberListItemState();
}

class _MemberListItemState extends State<MemberListItem> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.user.name),
            IconButton(
              icon: widget.user.isDev
                  ? Icon(
                Icons.laptop_mac,
                color: Colors.indigo[900],
              )
                  : Icon(
                Icons.laptop_mac,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  widget.user.isDev = !widget.user.isDev;
                  databaseHelper.updateUser(widget.user);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}


