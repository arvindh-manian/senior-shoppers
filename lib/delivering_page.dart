import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeliveringPage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const DeliveringPage(this.user);

  @override
  State<DeliveringPage> createState() => _DeliveringPageState();
}

class _DeliveringPageState extends State<DeliveringPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
