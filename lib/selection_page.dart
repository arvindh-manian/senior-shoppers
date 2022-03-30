import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:senior_shoppers/ordering_page.dart';
import 'delivering_page.dart';

class SelectionPage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const SelectionPage({required this.user});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void deliver() {
    setState(() {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child: DeliveringPage(widget.user)));
    });
  }

  final controller = TextEditingController();

  Future<dynamic> order(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter delivery address"),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Choose Role")),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/volunteers_filtered.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(75, 212, 75, 38),
                      child: ElevatedButton(
                        onPressed: deliver,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange[200]),
                        child: Row(children: [
                          Text("I want to deliver"),
                          Spacer(),
                          Icon(Icons.drive_eta)
                        ]),
                      ))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(75, 38, 75, 212),
                      child: ElevatedButton(
                          onPressed: () => order(context).then((onValue) {
                                Navigator.push(
                                    (context),
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: OrderingPage(
                                            user: widget.user,
                                            address: onValue)));
                              }),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange[200]),
                          child: Row(children: [
                            Text("I want to order"),
                            Spacer(),
                            Icon(Icons.shopping_cart_rounded)
                          ]))))
            ])));
  }
}
