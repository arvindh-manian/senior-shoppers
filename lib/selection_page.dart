import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'delivering_page.dart';
import 'ordering_page.dart';

class SelectionPage extends StatefulWidget {
  late GoogleSignInAccount? user;
  SelectionPage(this.user) {
    user = this.user;
  }

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void deliver() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DeliveringPage(widget.user)));
    });
  }

  void order() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderingPage(widget.user)));
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
                          onPressed: order,
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
