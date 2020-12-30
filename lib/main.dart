import 'package:dailytimesheetchecker/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

SharedPreferences _pref;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((pref) {
    _pref = pref;
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      title: 'Timesheet Checker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.indigo[900],
      ),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        {
          var page;
          if (_pref.get('authToken') != null &&
              _pref.get('subscriptionId') != null &&
              _pref.get('oauthtoken') != null)
            page = MaterialPageRoute(builder: (context) => HomeScreen());
          else
            page = MaterialPageRoute(builder: (context) => LoginScreen());
          return page;
        }
      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}
