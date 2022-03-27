import 'package:flutter/material.dart';
import 'ordering_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loggedIn = false;
  GoogleSignInAccount? user;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController controller = TextEditingController();

  void click() async {
    _googleSignIn.signIn().then((userData) {
      setState(() {
        loggedIn = true;
        user = userData as GoogleSignInAccount;
        print(user?.displayName);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderingPage(user)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Senior Shoppers")),
      body: Container(
        child: loggedIn
            ? Column(
                children: [
                  Image.network(user?.photoUrl as String),
                  Text(user?.displayName as String),
                  Text(user?.email as String),
                  TextButton(
                      onPressed: () {
                        _googleSignIn.signOut().then((value) {
                          setState(() {
                            loggedIn = false;
                          });
                        });
                      },
                      child: Text("Logout"))
                ],
              )
            : Center(
                child: ElevatedButton(
                    child: Text("Login with Google"), onPressed: click)),
      ),
    );
  }
}
