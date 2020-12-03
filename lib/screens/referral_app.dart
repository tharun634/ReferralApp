import 'package:ReferralAppNew/backend/dynamicLink.dart';
import 'package:ReferralAppNew/backend/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../backend/firestoreManagement.dart';
import '../backend/signIn.dart';

class ReferralApp extends StatefulWidget {
  final User user;

  ReferralApp(this.user);

  @override
  _ReferralAppState createState() => _ReferralAppState();
}

class _ReferralAppState extends State<ReferralApp> {
  User user;
  Uri dynamicLink;

  @override
  void initState() {
    user = widget.user;
    super.initState();

    fetchLinkData(
      user,
      (error) => Future.delayed(Duration.zero).then(
        (_) => showDialog(
          context: context,
          child: AlertDialog(
            title: Text(error),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get hasLink => dynamicLink?.toString()?.isNotEmpty ?? false;

  final textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Referral App',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: StreamBuilder(
                  stream: firestoreInstance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return Text(
                      snapshots.hasData
                          ? snapshots.data['referrals'].toString()
                          : '-',
                      style: TextStyle(
                        fontSize: 150,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: !hasLink
                  ? RaisedButton(
                      child: Text('Generate Link', style: textStyle),
                      onPressed: () async {
                        var link = await createDynamicLink(id: user.uid);
                        setState(() {
                          dynamicLink = link;
                        });
                        print(link);
                      },
                    )
                  : RaisedButton(
                      child: Text('Share', style: textStyle),
                      onPressed: () => share(context, dynamicLink)),
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
