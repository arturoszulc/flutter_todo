import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/login_controller.dart';
import 'package:flutter_todo/models/login_state_model.dart';
import 'package:flutter_todo/utils/consts/assets.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Container(
                  // color: Colors.amberAccent,
                  decoration: const BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  width: 300,
                  height: 150,
                  child: Center(
                    child: Text(
                      'APP LOGO',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )),
            ),
            const MyForm(),
            const FormSwitchButton(),
          ],
        )),
      ),
    );
  }
}

class MyForm extends ConsumerWidget {
  const MyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(LoginState.provider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            child: Column(
              children: [
                //pole EMAIL
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: TextFormField(
                    // initialValue: _email.value,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black54),
                      icon: Icon(Icons.email_outlined,
                          color: Colors.blue.shade700, size: 24),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5)),
                      helperText: ' ',
                      labelText: 'Email address',
                      errorText: loginState.emailError,
                    ),
                    onChanged: (String val) {
                      ref.read(LoginController.provider).validateEmail(val);
                    },
                    onTap: () =>
                        ref.read(LoginController.provider).clearAuthError(),
                  ),
                ),

                //pole PASSWORD
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: TextFormField(
                    // initialValue: _password.value,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black54),
                      icon: Icon(Icons.email_outlined,
                          color: Colors.blue.shade700, size: 24),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5)),
                      helperText: ' ',
                      labelText: 'Password',
                      errorText: loginState.passwordError,
                      errorMaxLines: 2,
                    ),
                    onChanged: (String val) {
                      ref.read(LoginController.provider).validatePassword(val);
                    },
                    onTap: () =>
                        ref.read(LoginController.provider).clearAuthError(),
                  ),
                ),
              ],
            ),
          ),

          //Auth error display
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 5.0),
            child: Text(
              loginState.authError ?? '',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.blue.shade700))),
              onPressed:
                  // (_email.value == null ||
                  // _password.value == null)
                  // ? null
                  // :
                  () => ref
                      .read(LoginController.provider)
                      .authenticateEmail(email: '', password: ''),
              child: Text(
                  loginState.type == LoginType.signIn ? 'Sign In' : 'Sign Up')),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 30.0),
          //   child: Text(
          //     'or',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25));
              }),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(50)), //const Size.fromHeight(50),
            ),
            onPressed: () {
              ref.read(LoginController.provider).authenticateGoogle();
            },
            icon: Image.asset(
              MyAsset.loginGoogleImage,
              height: 22,
              width: 22,
            ),
            label: const Text(
              MyString.loginWithGoogle,
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FormSwitchButton extends ConsumerWidget {
  const FormSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(LoginState.provider).type;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: RichText(
        text: TextSpan(
          text: type == LoginType.signIn
              ? MyString.loginDontHaveAccount
              : MyString.loginAlreadyHaveAccount,
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: type == LoginType.signIn
                    ? MyString.loginSingUpNow
                    : MyString.loginSingIn,
                style: TextStyle(color: Colors.blue.shade700),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ref.read(LoginController.provider).switchForm(type);
                  })
          ],
        ),
      ),
    );
  }
}
