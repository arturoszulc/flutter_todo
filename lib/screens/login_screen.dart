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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
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
          ],
        ),
      ),
    );
  }
}

class MyForm extends ConsumerStatefulWidget {
  const MyForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyFormState();
}

class _MyFormState extends ConsumerState<MyForm> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(LoginState.provider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _loginForm,
            child: Column(
              children: [
                //pole EMAIL
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: TextFormField(
                    controller: _emailController,
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
                      errorText: loginState.email.error,
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
                    controller: _passwordController,
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
                      labelText: 'Password',
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
                    // side: BorderSide(color: Colors.blue.shade700)
                  )),
              onPressed: ref.watch(LoginState.provider.notifier).areInputsValid
                  ? () => ref.read(LoginController.provider).authenticateEmail(
                      email: _emailController.text,
                      password: _passwordController.text)
                  : null,
              child: ref.read(LoginState.provider).isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(loginState.type == LoginType.signIn
                      ? 'Sign In'
                      : 'Sign Up')),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: loginState.type == LoginType.signIn
                    ? MyString.loginDontHaveAccount
                    : MyString.loginAlreadyHaveAccount,
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: loginState.type == LoginType.signIn
                          ? MyString.loginSingUpNow
                          : MyString.loginSingIn,
                      style: TextStyle(color: Colors.blue.shade700),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ref
                              .read(LoginController.provider)
                              .switchForm(loginState.type);
                          _emailController.clear();
                          _passwordController.clear();
                        })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MyForm extends ConsumerWidget {
//   const MyForm({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final loginState = ref.watch(LoginState.provider);
//     debugPrint('EMail val: ${loginState.email.value}');
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Form(
//             child: Column(
//               children: [
//                 //pole EMAIL
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//                   child: TextFormField(
//                     initialValue: loginState.email.value ?? '',
//                     textInputAction: TextInputAction.next,
//                     decoration: InputDecoration(
//                       hintStyle: const TextStyle(color: Colors.black54),
//                       icon: Icon(Icons.email_outlined,
//                           color: Colors.blue.shade700, size: 24),
//                       alignLabelWithHint: true,
//                       border: const OutlineInputBorder(),
//                       errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red, width: 5)),
//                       helperText: ' ',
//                       labelText: 'Email address',
//                       errorText: loginState.email.error,
//                     ),
//                     onChanged: (String val) {
//                       ref.read(LoginController.provider).validateEmail(val);
//                     },
//                     onTap: () =>
//                         ref.read(LoginController.provider).clearAuthError(),
//                   ),
//                 ),

//                 //pole PASSWORD
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//                   child: TextFormField(
//                     initialValue: loginState.password.value,
//                     obscureText: true,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       hintStyle: const TextStyle(color: Colors.black54),
//                       icon: Icon(Icons.lock,
//                           color: Colors.blue.shade700, size: 24),
//                       alignLabelWithHint: true,
//                       border: const OutlineInputBorder(),
//                       errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red, width: 5)),
//                       helperText: ' ',
//                       labelText: 'Password',
//                       errorText: loginState.password.error,
//                       errorMaxLines: 2,
//                     ),
//                     onChanged: (String val) {
//                       ref.read(LoginController.provider).validatePassword(val);
//                     },
//                     onTap: () =>
//                         ref.read(LoginController.provider).clearAuthError(),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           //Auth error display
//           Padding(
//             padding: const EdgeInsets.only(top: 0, bottom: 5.0),
//             child: Text(
//               loginState.authError ?? '',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     // side: BorderSide(color: Colors.blue.shade700)
//                   )),
//               onPressed: ref.watch(LoginState.provider.notifier).areInputsValid
//                   ? () => ref.read(LoginController.provider).authenticateEmail()
//                   : null,
//               child: Text(
//                   loginState.type == LoginType.signIn ? 'Sign In' : 'Sign Up')),
//           const SizedBox(
//             height: 30,
//           ),
//           ElevatedButton.icon(
//             style: ButtonStyle(
//               shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
//                 return RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25));
//               }),
//               backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//               minimumSize: MaterialStateProperty.all<Size>(
//                   const Size.fromHeight(50)), //const Size.fromHeight(50),
//             ),
//             onPressed: () {
//               ref.read(LoginController.provider).authenticateGoogle();
//             },
//             icon: Image.asset(
//               MyAsset.loginGoogleImage,
//               height: 22,
//               width: 22,
//             ),
//             label: const Text(
//               MyString.loginWithGoogle,
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class FormSwitchButton extends ConsumerWidget {
//   const FormSwitchButton({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final type = ref.watch(LoginState.provider).type;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24.0),
//       child: RichText(
//         text: TextSpan(
//           text: type == LoginType.signIn
//               ? MyString.loginDontHaveAccount
//               : MyString.loginAlreadyHaveAccount,
//           style: const TextStyle(color: Colors.black),
//           children: [
//             TextSpan(
//                 text: type == LoginType.signIn
//                     ? MyString.loginSingUpNow
//                     : MyString.loginSingIn,
//                 style: TextStyle(color: Colors.blue.shade700),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     ref.read(LoginController.provider).switchForm(type);
//                   })
//           ],
//         ),
//       ),
//     );
//   }
// }
