import 'dart:convert';

import 'package:dailytimesheetchecker/domain/init_data_use_case.dart';
import 'package:dailytimesheetchecker/network/api/tickspot_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'network/model/Role.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _oauthToken;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  onSaved: (value) => _email = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  onSaved: (value) => _password = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  onSaved: (value) => _oauthToken = value,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Slack OAuth Token'),
                ),
                SizedBox(
                  height: 32,
                ),
                Builder(builder: (BuildContext context) {
                  return _buildLoginButton(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext c) {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else {
      return RaisedButton(
          color: Colors.blue[900],
          textColor: Colors.white,
          child: Container(
              width: 150,
              height: 40,
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )),
          onPressed: () async {
            FocusScope.of(c).requestFocus(FocusNode());
            final form = _formKey.currentState;
            form.save();

            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            setState(() {
              _isLoading = true;
            });

            var login = TickspotApi().login(_email, _password);

            login.then((response) {
              if (response.statusCode == 200) {
                var role = _parseRoles(response.body)[0];
                preferences.setString('authToken', role.apiToken);
                preferences.setInt('subscriptionId', role.subscriptionId);
                preferences.setString('oauthtoken', _oauthToken);

                InitDataUseCase().init().then((void v) {
                  setState(() {
                    _isLoading = false;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route)=>false);
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
                final snackBar = SnackBar(content: Text(response.body));
                Scaffold.of(c).showSnackBar(snackBar);
              }
            });
          });
    }
  }
}

List<Role> _parseRoles(String responseBody) {
  final parsed = json.decode(responseBody) as List;
  return parsed.map<Role>((json) => Role.fromJson(json)).toList();
}
