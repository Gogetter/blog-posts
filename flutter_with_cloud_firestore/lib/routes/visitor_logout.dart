import 'package:flutter/material.dart';
import 'package:flutter_with_cloud_firestore/entities/visitor.dart';
import 'package:flutter_with_cloud_firestore/utils/cloud_firestore_utils.dart';
import 'package:flutter_with_cloud_firestore/utils/strings.dart';

/// Visitor logout UI
class VisitorSignOut extends StatefulWidget {
  @override
  VisitorSignOutState createState() => VisitorSignOutState();
}

class VisitorSignOutState extends State<VisitorSignOut>{
  final _formKey = GlobalKey<FormState>();

  // text controller
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    // clean up the edit controllers when the Widget is disposed
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: new Text(Constants.appTitle)),
      body: Center(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    controller: searchCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return Constants.visitorSearchEmptyStrError;
                      }
                    },
                    decoration: new InputDecoration(
                        labelText: Constants.searchByEmailOrCarPlate
                    ),
                  ),

                  new Builder(
                    builder: (BuildContext context) {
                      // notice dart allows us to ignore or use 'new'
                      return new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton.icon(
                          icon: new Icon(Icons.directions_walk, color: Colors.red),
                          label: Text(Constants.signOut),
                          color: Colors.blueGrey[50],
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              final Future<Map<String, dynamic>> visitorData = CloudFirestoreUtils.findVisitor(searchCtrl.text);
                              visitorData.then((value) {
                                // save signed out Visitor
                                if (value == null || value.isEmpty) {
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('${Constants.unableToFindVisitorPrefix} ${searchCtrl.text} ${Constants.unableToFindVisitorSuffix}'))
                                  );
                                  return;
                                }

                                setState(() {
                                  Visitor foundVisitor = Visitor.fromMap(value);
                                  CloudFirestoreUtils.saveOrUpdateVisitor(foundVisitor, false);
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(milliseconds: 10000),
                                          content: Text('${foundVisitor.visitorName} signed out successfully')
                                      )
                                  );
                                  Navigator.pop(context);
                                });

                              });
                            }
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
      )
    );
  }
}