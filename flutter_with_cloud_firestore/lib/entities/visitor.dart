import 'package:cloud_firestore/cloud_firestore.dart';

/// models a visitor.
class Visitor {
  String visitorName;
  String emailAddress;
  String mobileNumber;
  String whoToSee;
  String purposeOfVisit;
  String carPlateNumber;

  /// Using Timestamp -- Can be converted to DateTime using Timestamp.toDate()
  Timestamp signedInAt;
  Timestamp signedOutAt;

  Visitor(this.visitorName, this.emailAddress, this.mobileNumber, this.whoToSee,
      this.purposeOfVisit, {this.carPlateNumber});

  static Map<String, dynamic> toMap(final Visitor aVisitor, final bool signIn) {
    Map<String, dynamic> visitorData = new Map();
    if (aVisitor != null) {
      visitorData.putIfAbsent('visitorName', () => aVisitor.visitorName);
      visitorData.putIfAbsent('emailAddress', () => aVisitor.emailAddress);
      visitorData.putIfAbsent('mobileNumber', () => aVisitor.mobileNumber?? "");
      visitorData.putIfAbsent('whoToSee', () => aVisitor.whoToSee?? "");
      visitorData.putIfAbsent('purposeOfVisit', () => aVisitor.purposeOfVisit?? "");
      visitorData.putIfAbsent('carPlateNumber', () => aVisitor.carPlateNumber?? "");
      visitorData.putIfAbsent('signedInAt', () => aVisitor.signedInAt?? Timestamp.now());

      if (!signIn) {
        visitorData.putIfAbsent('signedOutAt', () => aVisitor.signedOutAt?? Timestamp.now());
      }
    }

    return visitorData;
  }
  
  static Visitor fromMap(final Map<String, dynamic> visitorData) {
    Visitor visitor;
    if (visitorData.isNotEmpty) {
       visitor = Visitor(visitorData['visitorName'], visitorData['emailAddress'],
          visitorData['mobileNumber'], visitorData['whoToSee'],
          visitorData['purposeOfVisit']);
      visitor.carPlateNumber = visitorData['carPlateNumber'];
    }

    return visitor;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Visitor &&
              runtimeType == other.runtimeType &&
              emailAddress == other.emailAddress &&
              mobileNumber == other.mobileNumber &&
              carPlateNumber == other.carPlateNumber;

  @override
  int get hashCode =>
      emailAddress.hashCode ^
      mobileNumber.hashCode ^
      carPlateNumber.hashCode;

  @override
  String toString() {
    return 'Visitor{emailAddress: $emailAddress, mobileNumber: $mobileNumber, '
        'whoToSee: $whoToSee, purposeOfVisit: $purposeOfVisit, carPlateNumber: $carPlateNumber, '
        'signedInAt: $signedInAt, signedOutAt: $signedOutAt}';
  }
}