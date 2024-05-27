import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/components/base_textfield.dart';
import 'package:ppb_fp/components/base_button.dart';
import 'package:ppb_fp/components/base_tile_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppb_fp/components/error_dialogue.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then(
                (value) => postDetailsToFirestore(emailController.text, 'user'))
            .catchError((e) => {ErrorMessageDialog.show(context, e.code)});
      } else {
        ErrorMessageDialog.show(context, 'Unknown role');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ErrorMessageDialog.show(context, e.code);
      }

      // showErrorMessage(e.code);
    }
  }

  postDetailsToFirestore(String email, String role) async {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'id': user.uid, 'email': email, 'role': role});
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Icon(
                Icons.book,
                size: 100,
                color: Colors.blue.shade300,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Let's create new memories!",
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              BaseTextField(
                controller: emailController,
                hintText: 'username',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              BaseTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              BaseTextField(
                controller: confirmpasswordController,
                hintText: 'confirm password',
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              BaseButton(
                onTap: signUp,
                text: 'Sign Up',
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey.shade500,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.blueGrey.shade700),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey.shade500,
                    ))
                  ],
                ),
              ),
              const SizedBox(
                width: 50.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseTileButton(imagePath: "imagePath"),
                  SizedBox(
                    width: 10.0,
                  ),
                  BaseTileButton(imagePath: "imagePath")
                ],
              ),
              const SizedBox(
                width: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.blueGrey.shade700),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
