import 'package:flutter/material.dart';

import '../../exports.dart';

@FFRoute(name: 'login-page')
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Center(
                child: Text('登录体验更多精彩'),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '手机号/邮箱',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '密码',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
