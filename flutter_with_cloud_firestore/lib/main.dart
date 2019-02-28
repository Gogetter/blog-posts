import 'package:flutter/material.dart';
import 'package:flutter_with_cloud_firestore/routes/visitor_logout.dart';
import 'package:flutter_with_cloud_firestore/routes/visitor_registration.dart';
import 'package:flutter_with_cloud_firestore/utils/strings.dart';

void main() => runApp(VisitorRegisterApp());

class VisitorRegisterApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appTitle,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: new Text(Constants.appTitle)),
        body: Center(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // sign in
              RaisedButton.icon(
                icon: new Icon(Icons.supervised_user_circle, color: Colors.lightBlue,),
                label: Text(Constants.signIn),
                color: Colors.blueGrey[50],
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorForm()));
                },
              ),

              // sign out
              RaisedButton.icon(
                icon: new Icon(Icons.directions_walk, color: Colors.red),
                label: Text(Constants.signOut),
                color: Colors.blueGrey[50],
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorSignOut()));
                },
              ),
            ],
          ),
        )
    );
  }
}
