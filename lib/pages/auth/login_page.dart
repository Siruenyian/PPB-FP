import 'package:ppb_fp/components/base_textfield.dart';
import 'package:ppb_fp/components/base_button.dart';
import 'package:ppb_fp/components/base_tile_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppb_fp/components/error_dialogue.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ErrorMessageDialog.show(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Icon(
                Icons.book_rounded,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Welcome back!",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 20),
              ),
              const SizedBox(
                height: 25,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgor Password?',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              BaseButton(
                onTap: signIn,
                text: 'Sign In',
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
                      color: Colors.grey.shade500,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey.shade500,
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
                    'Not a member?',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
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
