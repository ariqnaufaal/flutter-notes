import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_flutter/auth/auth.dart';
import 'package:note_flutter/auth/login_or_register.dart';
import 'package:note_flutter/firebase_options.dart';
import 'package:note_flutter/screens/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page':(context) => HomeScreen(notes: [],),
        // '/profile_page':(context) => ProfilePage(),
        // '/users_page':(context) => const UsersPage(),
      }
      // debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
    );
  }
}
