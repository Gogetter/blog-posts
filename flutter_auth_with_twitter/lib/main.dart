import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_with_twitter/util/strings.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

void main() => runApp(new MyApp());

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Auth With Twitter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<FirebaseUser> _listener;

  FirebaseUser _currentUser;

  TwitterLoginResult _twitterLoginResult;
  TwitterLoginStatus _twitterLoginStatus;
  TwitterSession _currentUserTwitterSession;

  String _loggedInMessage;

  void _handleTwitterSignIn() async {
    String snackBarMessage = '';

    final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: Strings.twitterApiKey,
        consumerSecret: Strings.twitterApiSecret
    );

    _twitterLoginResult = await twitterLogin.authorize();
    _currentUserTwitterSession = _twitterLoginResult.session;
    _twitterLoginStatus = _twitterLoginResult.status;

    switch (_twitterLoginStatus) {
      case TwitterLoginStatus.loggedIn:
        _currentUserTwitterSession = _twitterLoginResult.session;
        snackBarMessage = 'Successfully signed in as';
        break;

      case TwitterLoginStatus.cancelledByUser:
        snackBarMessage = 'Sign in cancelled by user.';
        break;

      case TwitterLoginStatus.error:
        snackBarMessage = 'An error occurred signing with Twitter.';
        break;
    }

    AuthCredential _authCredential = TwitterAuthProvider.getCredential(
        authToken: _currentUserTwitterSession?.token ?? '',
        authTokenSecret: _currentUserTwitterSession?.secret ?? ''
    );
    _currentUser = await _firebaseAuth.signInWithCredential(
        _authCredential
    );

    setState(() {





      if (_twitterLoginStatus == TwitterLoginStatus.loggedIn && _currentUser != null) {
        _loggedInMessage = '$snackBarMessage ${_currentUser.displayName}';

      } else {

        _loggedInMessage = _loggedInMessage = '$snackBarMessage';
      }
    });
  }

  Widget buildHome(BuildContext context) {
    return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(
                  top: 64.0, bottom: 64.0, left: 16.0, right: 16.0),
              child: new RaisedButton(
                  color: const Color.fromRGBO(29, 161, 242, 1.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 16.0, right: 32.0),
                          child: new Image.asset('assets/images/twitter.png', height: 25.0, width: 25.0,)),
                      new Expanded(
                        child: new Text(
                          Strings.twitterText,
                          style: new TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  onPressed: _handleTwitterSignIn
              ),
            ),
            new Expanded(
              child: new Text(
                _loggedInMessage?? 'Not logged In...',
                style: new TextStyle(color: Colors.black),
              ),
            )
          ],
        )
    );
  }

  void _checkCurrentUser() async {
    _currentUser = await _firebaseAuth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {






    return new Scaffold(
      appBar: new AppBar(


        title: new Text(widget.title),
      ),
      body: buildHome(context),
    );
  }
}
