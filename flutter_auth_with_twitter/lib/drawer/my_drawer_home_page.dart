import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_with_twitter/main.dart';
import 'package:flutter_auth_with_twitter/util/strings.dart';

class MyDrawerHomePage extends StatefulWidget {
  final FirebaseUser currentUser;

  MyDrawerHomePage(this.currentUser);

  @override
  _MyDrawerHomePageState createState() => new _MyDrawerHomePageState(currentUser);
}

class _MyDrawerHomePageState extends State<MyDrawerHomePage> {
  final FirebaseUser currentUser;

  String _displayMessage;

  _MyDrawerHomePageState(this.currentUser);

  @override
  void initState() {
    super.initState();
    _displayMessage = 'Welcome, ${currentUser.displayName}';
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _drawerItemTxtStyle = new TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.normal
    );

    final TextStyle _userInfoTxtStyle = new TextStyle(
      color: Colors.black
    );

    return new Scaffold(

      appBar: new AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(61, 167, 219, 0.85),
          title: new Text(
            Strings.appName,
            style: new TextStyle(color: Colors.white),
          )
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[

            //display current user info
            new UserAccountsDrawerHeader(
                decoration: new BoxDecoration(color: Colors.white),
                currentAccountPicture:  new CircleAvatar(
                    backgroundImage: currentUser.photoUrl.isNotEmpty ? 
                    new NetworkImage(currentUser.photoUrl) : currentUser.displayName.substring(0)),
                accountName: new Text('Welcome, ${currentUser.displayName}', style: _userInfoTxtStyle),
                accountEmail: new Text(currentUser.email?? '', style:  _userInfoTxtStyle)
            ),

            //Drawer items
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text(Strings.home, style: _drawerItemTxtStyle),
              onTap: () {
                //update state
                setState(() {
                  _displayMessage = 'You are home ${currentUser.displayName}';
                });

                // close Drawer window
                Navigator.pop(context);
              },
            ),

            new Divider(color: Colors.blueGrey[200]),

            new ListTile(
              leading: new Icon(Icons.info),
              title: new Text(Strings.aboutUs, style: _drawerItemTxtStyle),
              onTap: () {
                //update state
                setState(() {
                  _displayMessage = 'About Us --- Coming Soon...';
                });

                // close Drawer window
                Navigator.pop(context);
              },
            ),

            new Divider(color: Colors.blueGrey[200]),

            new ListTile(
              leading: new Icon(Icons.close),
              title: new Text(Strings.logOut, style: _drawerItemTxtStyle),
              onTap: () {
                Navigator.pop(context);
                // sign out
                FirebaseAuth.instance.signOut();

                // navigate to Welcome page
                Navigator.push(context, new MaterialPageRoute(
                  builder: (_) => new MyApp(),
                ));
              },
            )
          ],
        ),
      ),

      body: new Center(
        child: new Text(_displayMessage, style: new TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic
        )),
      )

    );
  }
}