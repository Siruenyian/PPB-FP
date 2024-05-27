import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        ),
      ]),
      body: Center(
        child: Text(
          'Logged In as Admin: ${user?.email}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
