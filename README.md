# flutter_todo

Simple Todo app powered by Flutter, Firebase and Riverpod

## another change

## Main features
- sign in / sign up with email & password or Google
- setup custom Username
- add/edit/delete Todos
- watch an Ad to add more Todos
- don't worry about your data - it's saved in Firestore
 

## App structure
The app has a modular structure based on [Riverpod](https://github.com/rrousselGit/riverpod). Each functionality (like Authentication or Todos) has it's own:
- controller
- set of states
- set of screens

Controllers read input from UI, get necessary data from Services and modify States accordingly.

Thanks to this approach:
- UI and Logic are separate
- Code is clean, easy to read and very easy to test
- Widget rebuilds don't get out of control

Every State and Controller is disposed when no longer needed, thus not holding up resources.

## Technologies
- Dart: 2.18.4
- Flutter: 3.3.7
- flutter_riverpod: 2.1.1
- firebase_core: 2.3.0
- firebase_auth: 4.1.3
- google_sign_in: 5.4.2
- cloud_firestore: 4.1.0
- google_mobile_ads: 2.3.0
