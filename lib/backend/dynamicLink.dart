import 'package:ReferralAppNew/backend/firestoreManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

void fetchLinkData(User user) async {
  // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
  var link = await FirebaseDynamicLinks.instance.getInitialLink();

  // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
  handleLinkData(link, user);

  // This will handle incoming links if the application is already opened
  FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
    handleLinkData(dynamicLink, user);
  });
}

void handleLinkData(PendingDynamicLinkData data, User user) {
  final Uri uri = data?.link;
  if (uri != null) {
    final queryParams = uri.queryParameters;
    if (queryParams.length > 0) {
      String id = queryParams["id"];
      // verify the username is parsed correctly
      print("My id is: $id");

      if (user.uid == id) {
        print('Cannot refer yourself');
      } else {
        checkReferralStatus(user.uid).then(
          (value) {
            if (value) {
              print('You have already used a referral link');
            }
            
            else {
              updateReferral(id, user.uid);
              hasUsedReferral(user.uid);
            }
          },
        );
      }
    }
  }
}

Future<Uri> createDynamicLink({@required String id}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    // This should match firebase but without the username query param
    uriPrefix: 'https://referralappnew.page.link',
    // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
    link: Uri.parse('https://referralappnew.page.link/groupinvite?id=$id'),
    androidParameters: AndroidParameters(
      packageName: 'com.testing.referralApp',
      minimumVersion: 1,
    ),
    iosParameters: IosParameters(
      bundleId: 'com.testing.referralApp',
      minimumVersion: '1',
      appStoreId: '',
    ),
  );
  final link = await parameters.buildUrl();
  final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    link,
    DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  );
  return shortenedLink.shortUrl;
}
