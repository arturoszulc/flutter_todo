import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/auth_controller.dart';
import 'package:flutter_todo/models/auth_model.dart';
import 'package:flutter_todo/utils/consts/assets.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: const [
              AppLogo(),
              AuthForm(),
              AuthError(),
              AuthButtons(),
              FormSwitchButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
          decoration:
              const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          width: 300,
          height: 150,
          child: Center(
            child: Text(
              'APP LOGO',
              style: Theme.of(context).textTheme.headline5,
            ),
          )),
    );
  }
}

class AuthForm extends ConsumerWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(AuthState.provider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            child: Column(
              children: [
                //EMAIL field
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: ref.watch(emailController),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black54),
                        icon: Icon(Icons.email_outlined,
                            color: Colors.blue.shade700, size: 24),
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5)),
                        helperText: ' ',
                        labelText: MyString.emailTextFieldLabel,
                        errorText: loginState.email.error,
                        errorMaxLines: 2),
                    onChanged: (String val) {
                      ref.read(LoginController.provider).validateEmail();
                    },
                    onTap: () =>
                        ref.read(LoginController.provider).clearAuthError(),
                  ),
                ),

                //PASSWORD field
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: ref.watch(passwordController),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black54),
                      icon: Icon(Icons.lock,
                          color: Colors.blue.shade700, size: 24),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5)),
                      helperText: ' ',
                      labelText: MyString.passwordTextFieldLabel,
                      errorText: loginState.password.error,
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
        ],
      ),
    );
  }
}

class AuthError extends ConsumerWidget {
  const AuthError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        ref.watch(AuthState.provider.select((value) => value.authError)),
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AuthButtons extends ConsumerWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                )),
            onPressed: ref.watch(AuthState.provider.notifier).areInputsValid
                ? () => ref.read(LoginController.provider).authenticateEmail()
                : null,
            child: ref.watch(AuthState.provider).isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(ref.watch(AuthState.provider).type == AuthType.signIn
                    ? MyString.loginSingIn
                    : MyString.loginSingUp)),
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
            minimumSize:
                MaterialStateProperty.all<Size>(const Size.fromHeight(50)),
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
      ],
    );
  }
}

class FormSwitchButton extends ConsumerWidget {
  const FormSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginType = ref.watch(AuthState.provider).type;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: loginType == AuthType.signIn
              ? MyString.loginDontHaveAccount
              : MyString.loginAlreadyHaveAccount,
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: loginType == AuthType.signIn
                    ? MyString.loginSingUpNow
                    : MyString.loginSingIn,
                style: TextStyle(color: Colors.blue.shade700),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ref.read(LoginController.provider).switchForm();
                  })
          ],
        ),
      ),
    );
  }
}
