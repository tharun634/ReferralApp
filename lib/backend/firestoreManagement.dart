import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

void creatingUser(String uid) async {
  firestoreInstance.collection("users").doc(uid).set(
    {
      'referrals': 0,
      'usedReferral': false,
    },
  );
}

void updateReferral(String uid) async {
  DocumentSnapshot refereeDeets =
      await firestoreInstance.collection("users").doc(uid).get();

  int currentReferrals = refereeDeets['referrals'];
  currentReferrals++;

  firestoreInstance.collection("users").doc(uid).update(
    {
      'referrals': currentReferrals,
    },
  );
}

void hasUsedReferral(String uid) async {
  firestoreInstance.collection("users").doc(uid).update(
    {
      'usedReferral': true,
    },
  );
}

Future<bool> checkReferralStatus(String uid) async {
  DocumentSnapshot refereeDeets =
      await firestoreInstance.collection("users").doc(uid).get();

  bool referralStatus = refereeDeets['usedReferral'];
  return referralStatus;
}

Future<int> checkNoOfReferrals(String uid) async {
  DocumentSnapshot refereeDeets =
      await firestoreInstance.collection("users").doc(uid).get();

  int currentReferrals = refereeDeets['referrals'];
  return currentReferrals;
}
