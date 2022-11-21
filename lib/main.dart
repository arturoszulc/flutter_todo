import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo/screens/auth_checker.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

//  This is a FutureProvider that will be used to check whether the firebase has been initialized or not
// final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
//   return await Firebase.initializeApp();
// });

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final initialize = ref.watch(firebaseinitializerProvider);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      //  We will use the initialize to check if the firebase has been initialized
      //  .when function can only be used with AsysncValue. If you hover over intialize
      //  you can see what type of variable it is. I have left it dynamic here for your better understanding
      //  Though it's always recommended to not to use dynamic variables.

      // Now here if the Firebase is initialized we will be redirected to AuthChecker
      // which checks if the user is logged in or not.

      //  the other Two functions speaks for themselves.
      home: AuthChecker(),

      // loading: () => const LoadingScreen(),
      // error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
    );
  }
}
