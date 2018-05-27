import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_with_twitter/util/strings.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

void main() => runApp(new MyApp());

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Auth With Twitter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

    _currentUser = await _firebaseAuth.signInWithTwitter(
        authToken: _currentUserTwitterSession?.token ?? '',
        authTokenSecret: _currentUserTwitterSession?.secret ?? ''
    );

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: buildHome(context),
    );
  }
}
