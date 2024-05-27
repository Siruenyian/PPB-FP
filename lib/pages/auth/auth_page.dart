import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp/components/error_dialogue.dart';
import 'package:ppb_fp/pages/admin/home_page.dart';
import 'package:ppb_fp/pages/user/home_page.dart';
import 'package:ppb_fp/pages/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  void signUserOut() {
    // print("goodbye JOJOO");
    FirebaseAuth.instance.signOut();
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.get('role'); // Assumes 'role' field exists in the document
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
// User is signed in
            String uid = snapshot.data!.uid;
            return FutureBuilder<String?>(
              future: getUserRole(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Error state
                  ErrorMessageDialog.show(context, 'Error fetching user role');
                  return const LoginOrRegisterPage(); // Fall back to the login page
                } else if (snapshot.hasData) {
                  // Role fetched successfully
                  String? role = snapshot.data;
                  if (role == 'admin') {
                    return AdminHomePage();
                  } else if (role == 'user') {
                    return UserHomePage();
                  } else {
                    // Unknown role
                    ErrorMessageDialog.show(context, 'Unknown role');
                    return const LoginOrRegisterPage(); // Fall back to the login page
                  }
                } else {
                  // No role found
                  ErrorMessageDialog.show(context, 'No role found');
                  return const LoginOrRegisterPage(); // Fall back to the login page
                }
              },
            );
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
