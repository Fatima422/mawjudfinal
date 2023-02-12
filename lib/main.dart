import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

//FirebaseUse user = _auth.currentUser();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final  _auth = FirebaseAuth.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MAWJUD APP',
      debugShowCheckedModeBanner: false,
      //home: _auth.currentUser != null? SplashScreen() : DashbordScreen(),
      initialRoute: _auth.currentUser != null? '/' :'/',
      routes: {},
    );
  }
}
