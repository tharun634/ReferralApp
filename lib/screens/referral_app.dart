import 'package:ReferralAppNew/backend/dynamicLink.dart';
import 'package:ReferralAppNew/backend/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReferralApp extends StatefulWidget {
  @override
  _ReferralAppState createState() => _ReferralAppState();
}

class _ReferralAppState extends State<ReferralApp> {
  User user;
  Uri dynamicLink;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) async {
      user = await signInWithGoogle();
      fetchLinkData(user);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Referral App',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Text(dynamicLink.toString().isEmpty
                    ? 'Please press the button to get your link'
                    : dynamicLink.toString()),
              ),
              onTap: () {
                if (dynamicLink.toString().isNotEmpty)
                  share(context, dynamicLink);
                else
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please generate a link first'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    ),
                  );
              },
            ),
            FlatButton(
              onPressed: () async {
                var link = await createDynamicLink(id: user.uid);
                setState(() {
                  dynamicLink = link;
                });
                print(link);
              },
              child: Card(
                child: Text('Generate Link!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

share(BuildContext context, Uri link) {
  final RenderBox box = context.findRenderObject();

  Share.share(
      "Please click on this link to get referred to the app for bonuses: ${link}",
      subject: link.toString(),
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
