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
      appBar: AppBar(
        title: Text(context.l10n.loginTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                  width: 80,
                  child: OverflowBox(
                    maxHeight: 80,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FittedBox(
                        child: CircleAvatar(
                          backgroundColor: context.surfaceColor,
                          child: SvgPicture.asset(
                            'assets/brand.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap.v(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.l10n.loginSlogan),
                  ],
                ),
                const Gap.v(16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: context.l10n.hintUsername,
                    prefixIcon: const Icon(Icons.person_outline),
                    focusColor: Colors.red,
                    prefixIconColor: Colors.red,
                  ),
                ),
                const Gap.v(8),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: context.l10n.hintPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const Gap.v(8),
                ElevatedButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(context.l10n.buttonSignIn),
                  ),
                ),
                const Gap.v(8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(context.l10n.linkSignUp),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(context.l10n.linkRetrieve),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
