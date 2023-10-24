import 'package:flutter/material.dart';

import '../../exports.dart';

@FFRoute(name: 'user-profile')
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(context.l10n.notSupported),
      ),
    );
  }
}
