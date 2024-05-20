import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:note_flutter/component/button_auth.dart';
import 'package:note_flutter/helper/helper_functions.dart';
import 'package:note_flutter/screens/home.dart';
import 'package:note_flutter/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  final void Function()? onTap;
  
  const SignInScreen({super.key, required this.onTap});
  
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
  

class _SignInScreenState extends State<SignInScreen> {
  // text controllers
  
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // login method
  Future<void> login() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );

      // pop loading circle
      if (!mounted) return; // Checks `this.mounted`, not `context.mounted`.
      Navigator.of(context).pop();
      navigateAfterSuccessSignin(context);

      // Navigate to the home screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomeScreen(notes: [])),
        // );
      }

    // display any errors
    on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
    }
    else {      
      // pop loading circle
      Navigator.pop(context);
      displayMessageToUser("Please fill the required field.", context);
    }
  }

  navigateAfterSuccessSignin(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () { 
          // Navigate to sign in screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(notes: []),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Success"),
      content: const Text("Login success."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a dummy XFile object
    final dummyPicture = XFile('path/to/dummy/image.jpg'); // Update this with a valid file path if necessary

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              obscureText: false, 
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            AuthButton(
              text: "Sign In", 
              onTap: login,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to the sign-up screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen(onTap: widget.onTap,)),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
