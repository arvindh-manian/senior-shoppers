import 'package:flutter/material.dart';
import 'package:senior_shoppers/database.dart';
import 'package:senior_shoppers/selection_page.dart';
import 'package:page_transition/page_transition.dart';
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
        saveUser(user);
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: SelectionPage(user: user)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Senior Shoppers")),
        body: Center(
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
              : Padding(
                  padding: EdgeInsets.all(50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Sign In With Google",
                                style: TextStyle(color: Colors.white))
                          ],
                        )),
                    onPressed: click,
                  )),
        ));
  }
}
