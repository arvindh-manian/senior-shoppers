// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:senior_shoppers/current_deliveries_page.dart';
import 'package:senior_shoppers/current_orders_page.dart';
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
    // TODO: add validation
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
                      padding: EdgeInsets.fromLTRB(75, 90, 75, 0),
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
                      padding: EdgeInsets.fromLTRB(75, 30, 75, 60),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              (context),
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: CurrentDeliveriesPage(
                                      user: widget.user?.id)));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange[200],
                        ),
                        child: Row(children: [
                          Text("See my current deliveries"),
                          Spacer(),
                          Icon(Icons.pending_actions)
                        ]),
                      ))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(75, 60, 75, 30),
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
                              primary: Colors.green[200]),
                          child: Row(children: [
                            Text("I want to order"),
                            Spacer(),
                            Icon(Icons.shopping_cart_rounded)
                          ])))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(75, 0, 75, 90),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              (context),
                              PageTransition(
                                  child:
                                      CurrentOrdersPage(user: widget.user?.id),
                                  type: PageTransitionType.bottomToTop));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[200]),
                        child: Row(children: [
                          Text("View my current orders"),
                          Spacer(),
                          Icon(Icons.pending_actions)
                        ]),
                      )))
            ])));
  }
}
