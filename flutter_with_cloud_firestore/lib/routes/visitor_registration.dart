import 'package:flutter/material.dart';
import 'package:flutter_with_cloud_firestore/entities/visitor.dart';
import 'package:flutter_with_cloud_firestore/utils/cloud_firestore_utils.dart';
import 'package:flutter_with_cloud_firestore/utils/strings.dart';
import 'package:validators/validators.dart';

/// defines the Visitor registration form
class VisitorForm extends StatefulWidget {
  final String title;

  VisitorForm({Key key, this.title}) : super(key: key);

  @override
  VisitorFormState createState() => VisitorFormState();
}

/// Define the VistorFormState class.
/// This class will hold the data related to the Visitor registration form
class VisitorFormState extends State<VisitorForm> {
  final _formKey = GlobalKey<FormState>();
  static const double padding = 8.0;

  // Create a text controllers to retrieve the inputted values
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailAddressCtrl = TextEditingController();
  final TextEditingController mobileNumberCtrl = TextEditingController();
  final TextEditingController whoToSeeCtrl = TextEditingController();
  final TextEditingController purposeOfVisitCtrl = TextEditingController();
  final TextEditingController carPlateNumberCtrl = TextEditingController();


  /// using each TextEditingController build a  Visitor
  Visitor _buildVisitor() {
    return Visitor(
        nameCtrl.text, emailAddressCtrl.text, mobileNumberCtrl.text, whoToSeeCtrl.text,
        purposeOfVisitCtrl.text, carPlateNumber: carPlateNumberCtrl.text ?? ''
    );
  }

  @override
  void dispose() {
    // clean up the edit controllers when the Widget is disposed
    nameCtrl.dispose();
    emailAddressCtrl.dispose();
    mobileNumberCtrl.dispose();
    whoToSeeCtrl.dispose();
    purposeOfVisitCtrl.dispose();
    carPlateNumberCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: new Text(Constants.appTitle)),
        body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(padding),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //name of visitor
                      new TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                            labelText: Constants.name
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.noNameError;
                          }
                        },
                      ),

                      // email
                      new TextFormField(
                        controller: emailAddressCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: Constants.emailAddress
                        ),
                        validator: (value) {
                          // check that a value is inputted and value is valid
                          if (value.isEmpty && !isEmail(value)) {
                            return Constants.noEmailError;
                          }
                        },
                      ),

                      // mobile number
                      new TextFormField(
                        controller: mobileNumberCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: Constants.contactNumber
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.noContactNumberError;
                          }
                        },
                      ),

                      // whoToSee
                      new TextFormField(
                        controller: whoToSeeCtrl,
                        decoration: InputDecoration(
                            labelText: Constants.whomToSee
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.noWhomToSeeError;
                          }
                        },
                      ),

                      // purposeOfVisit
                      new TextFormField(
                        controller: purposeOfVisitCtrl,
                        decoration: InputDecoration(
                            labelText: Constants.purposeOfVisit
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return Constants.noPurposeOfVisitError;
                          }
                        },
                      ),

                      // carPlateNumber
                      new TextFormField(
                        controller: carPlateNumberCtrl,
                        decoration: InputDecoration(
                            labelText: Constants.carPlateNumber
                        ),
                      ),

                      new Builder(
                        // Create an inner BuildContext so that the onPressed methods
                        // can refer to the Scaffold with Scaffold.of().
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(padding),
                              child: RaisedButton.icon(
                                icon: new Icon(Icons.save, color: Colors.blue),
                                  label: Text(Constants.register),
                                  color: Colors.blueGrey[50],
                                  onPressed: () {
                                    //perform validation before persisting registration info
                                    if (_formKey.currentState.validate()) {
                                      // if all is good - save visitor registration and show success
                                      CloudFirestoreUtils.saveOrUpdateVisitor(_buildVisitor(), true);
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text(Constants.thanks))
                                      );
                                      Navigator.pop(context);
                                    }
                                  }),
                            );
                          }
                      )

                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}