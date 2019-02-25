import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_with_cloud_firestore/entities/visitor.dart';
import 'package:flutter_with_cloud_firestore/utils/strings.dart';

class CloudFirestoreUtils {

  static Firestore _firestore = Firestore.instance;

  static void saveOrUpdateVisitor(final Visitor visitor, final bool signIn) async {
    if (visitor != null) {
      await _firestore.collection(Constants.visitors)/// create the collection where Visitors will be saved
          .document(visitor.emailAddress)/// construct a path (more like reference)
          .setData(Visitor.toMap(visitor, signIn));/// save data
    }
  }

  /// find a Visitor by email or the car plate number
  static Future<Map<String, dynamic>> findVisitor(final String emailOrCarPLateNumber) async {
    Map<String, dynamic> visitorData;
    if (emailOrCarPLateNumber.isNotEmpty) {
      // wait for result to be returned
      await _firestore.collection(Constants.visitors)
          .document(emailOrCarPLateNumber)
          .get().then((visitorSnapshot) {
        visitorData = visitorSnapshot.data;
      }).catchError((error) {
        visitorData = new Map();
      });
    }
    return visitorData;
  }
}