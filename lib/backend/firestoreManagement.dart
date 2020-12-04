import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

void creatingUser(String uid) async {
  firestoreInstance.collection("users").doc(uid).set(
    {
      'referrals': 0,
      'usedReferral': false,
      'referredBy': '',
    },
  );
}

void updateReferral(String uid_1, String uid_2, Function onError) async {
  DocumentSnapshot refereeDeets =
      await firestoreInstance.collection("users").doc(uid_1).get();

  if (refereeDeets['referredBy'] == uid_2) {
    // alert "you cannot use the referral link of your referral"
    print("Cannot use referral link of your referral");
    onError("Cannot use referral link of your referral");
    return;
  }
  int currentReferrals = refereeDeets['referrals'];
  currentReferrals++;

  firestoreInstance.collection("users").doc(uid_1).update(
    {
      'referrals': currentReferrals,
    },
  );
  firestoreInstance.collection("users").doc(uid_2).update(
    {
      'referredBy': uid_1,
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
