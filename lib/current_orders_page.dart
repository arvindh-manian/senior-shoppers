// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:senior_shoppers/database.dart';
import 'package:senior_shoppers/utils/cart_tools.dart';

class CurrentOrdersPage extends StatefulWidget {
  final String? user;
  const CurrentOrdersPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CurrentOrdersPage> createState() => _CurrentOrdersPageState();
}

class _CurrentOrdersPageState extends State<CurrentOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllCarts(),
        builder: ((BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              if (snapshot.error.toString() ==
                  "type 'Null' is not a subtype of type 'Map<dynamic, dynamic>' in type cast") {
                return Scaffold(
                    appBar: AppBar(title: Text("Select Cart")),
                    body: Center(child: Text("No Orders Found")));
              } else {
                return Scaffold(
                    appBar: AppBar(title: Text("Select Cart")),
                    body: Center(child: Text("Error. Please contact ")));
              }
            } else if (snapshot.hasData) {
              List<Cart> lst = [];
              for (Cart crt in snapshot.data as List<Cart>) {
                if (crt.user == widget.user && crt.isFinished == false) {
                  lst.add(crt);
                }
              }
              return lst.isEmpty
                  ? Scaffold(
                      appBar: AppBar(title: Text("Select Cart")),
                      body: Center(child: Text("No Carts Found")))
                  : Scaffold(
                      appBar: AppBar(title: Text("Select Cart")),
                      body: ListView.builder(
                          itemCount: lst.length,
                          itemBuilder: ((context, index) {
                            var item = lst[index];
                            return Card(
                                child: InkWell(
                                    onTap: () {
                                      var cart = item;
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              child: Scaffold(
                                                appBar: AppBar(
                                                    title:
                                                        Text("Confirm Choice")),
                                                body: ListView.builder(
                                                    itemCount:
                                                        cart.listItems.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var item =
                                                          cart.listItems[index];
                                                      return Card(
                                                          child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                              child: ListTile(
                                                            title:
                                                                Text(item.name),
                                                          )),
                                                          Row(children: <
                                                              Widget>[
                                                            Container(
                                                                child: Text(
                                                                  item.quantity
                                                                          .toString() +
                                                                      " " +
                                                                      item.unit,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0)),
                                                          ])
                                                        ],
                                                      ));
                                                    },
                                                    shrinkWrap: true),
                                              )));
                                    },
                                    child: Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(children: [
                                            Text(
                                                item.listItems.length
                                                    .toString(),
                                                style: TextStyle(fontSize: 30)),
                                            const Text("item(s)")
                                          ])),
                                      Expanded(
                                          flex: 3,
                                          child: Column(children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: item.deliverer == ""
                                                    ? Text("Unclaimed")
                                                    : Text("In Progress")),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    item.address.toString()))
                                          ])),
                                    ])));
                          })));
            } else {
              return Scaffold(
                  appBar: AppBar(title: Text("Error code 1")),
                  body: Text("Contact Arvindh Manian"));
            }
          } else {
            return Scaffold(
              appBar: AppBar(title: Text("Select Cart")),
              body: Center(child: CircularProgressIndicator()),
            );
          }
        }));
  }
}
