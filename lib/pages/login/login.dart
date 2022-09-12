import 'package:flutter/material.dart';

import '../../exports.dart';

@FFRoute(name: 'login-page')
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _doLogin() async {
    if (_formKey.currentState!.validate()) {
      final result = await PassportAPI.login(_username!, _password!);
      if (result.isSucceed) {
        print(result);
      } else {
        showToast(result.msg);
      }
    }
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
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return context.l10n.needUsername;
                    }
                    if (!v.isMobile() && !v.isEmail()) {
                      return context.l10n.incorectUsername;
                    }
                    return null;
                  },
                  onChanged: (v) => _username = v,
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
                  validator: (v) {
                    if (v?.isEmpty ?? true) {
                      return context.l10n.needPassword;
                    }
                    return null;
                  },
                  onChanged: (v) => _password = v,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: context.l10n.hintPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const Gap.v(8),
                ElevatedButton(
                  onPressed: _doLogin,
                  child: Center(
                    child: Text(context.l10n.buttonSignIn),
                  ),
                ),
                const Gap.v(8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        showToast('Comming soon');
                      },
                      child: Text(context.l10n.linkSignUp),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        showToast('Comming soon');
                      },
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
