import 'package:flutter/material.dart';
import 'package:senior_shoppers/database.dart';
import 'package:senior_shoppers/selection_page.dart';
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
    print("hello");
    _googleSignIn.signIn().then((userData) {
      setState(() {
        loggedIn = true;
        user = userData as GoogleSignInAccount;
        print(user == null);
        if (user != null) {
          print(user?.id);
        }
        saveUser(user);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectionPage(user)));
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
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 2, color: Colors.green),
                    ),
                    onPressed: click,
                    child: Text('Login With Google'),
                  ),
                ),
        ));
  }
}
