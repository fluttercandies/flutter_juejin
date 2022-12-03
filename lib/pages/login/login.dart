import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exports.dart';

@FFRoute(name: 'login-page')
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _doLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await PassportAPI.login(_username!, _password!);
        if (result.isSucceed) {
          showToast(context.l10n.loginSuccess);
          ref.read(tokenProvider.notifier).update(result.data!.sessionKey);
        } else {
          showToast(result.msg);
        }
      } on ModelMakeError catch (e) {
        showToast(e.json['description'] ?? '${e.json}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  context.l10n.loginSlogan,
                  style: context.textTheme.headline6,
                ),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: math.max(16, context.bottomViewInsets),
          ),
          child: Row(
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
        ),
      ),
    );
  }
}
