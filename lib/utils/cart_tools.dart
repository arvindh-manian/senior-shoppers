// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:senior_shoppers/database.dart';

class CartItem {
  int quantity;
  String name;
  String unit;

  CartItem(
      {required this.name, required this.quantity, this.unit = "package(s)"});

  void changeNumber(int delta) {
    quantity += delta;
  }

  void changeUnit(String newUnit) {
    unit = newUnit;
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'unit': unit,
    };
  }
}

class Cart {
  late String? user;
  late String? address;
  late List<CartItem> listItems;
  late DatabaseReference _id;
  late String? deliverer = "";
  late bool isFinished;
  Cart(
      {required this.user,
      required this.listItems,
      this.deliverer = "",
      required this.address,
      this.isFinished = false});

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'address': address,
      'deliverer': deliverer,
      'isFinished': isFinished,
      'listItems':
          List.generate(listItems.length, (index) => listItems[index].toJson()),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      user: json['user'],
      address: json['address'],
      isFinished: json['isFinished'],
      listItems: List.generate(
          json['listItems'].length,
          ((index) => CartItem(
              name: json['listItems'][index]['name'],
              quantity: json['listItems'][index]['quantity'],
              unit: json['listItems'][index]['unit']))),
      deliverer: json['deliverer']);

  DatabaseReference getId() {
    return _id;
  }
}

class RenderCart extends StatefulWidget {
  final Cart cart;
  final String? user;
  final Function voidCallback;
  const RenderCart(
      {required this.cart, required this.user, required this.voidCallback});

  @override
  State<RenderCart> createState() => _RenderCartState();
}

class _RenderCartState extends State<RenderCart> {
  void vallback() {
    widget.voidCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Confirm Choice")),
        body: ListView.builder(
            itemCount: widget.cart.listItems.length,
            itemBuilder: (context, index) {
              var item = widget.cart.listItems[index];
              return Card(
                  child: Row(
                children: <Widget>[
                  Expanded(
                      child: ListTile(
                    title: Text(item.name),
                  )),
                  Row(children: <Widget>[
                    Container(
                        child: Text(
                          item.quantity.toString() + " " + item.unit,
                          style: TextStyle(fontSize: 15),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  ])
                ],
              ));
            },
            shrinkWrap: true),
        floatingActionButton: FloatingActionButton(
            onPressed: vallback,
            child: Icon(Icons.check),
            backgroundColor: Colors.white,
            foregroundColor: Colors.green));
  }
}

class CartDisplay extends StatefulWidget {
  final Cart cart;

  const CartDisplay({required this.cart});

  @override
  _CartDisplayState createState() => _CartDisplayState();
}

class _CartDisplayState extends State<CartDisplay> {
  void changeNumber(Function callback) {
    // placeholder
    setState(() {
      callback(1);
    });
  }

  void deleteItem(CartItem item) {
    setState(() {
      widget.cart.listItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.cart.listItems.length,
        itemBuilder: (context, index) {
          var item = widget.cart.listItems[index];
          return Card(
              child: Row(
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(item.name),
              )),
              Row(children: <Widget>[
                Container(
                    child: Text(
                      item.quantity.toString() + " " + item.unit,
                      style: TextStyle(fontSize: 15),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                IconButton(
                    icon: Icon(Icons.plus_one),
                    onPressed: () =>
                        changeNumber(item.changeNumber), // update this later
                    color: Colors.green,
                    tooltip: "Edit this item"),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: "Remove this item",
                  color: Colors.red,
                  onPressed: () => {deleteItem(item)},
                )
              ])
            ],
          ));
        });
  }
}

class CartListDisplay extends StatefulWidget {
  final List<Cart> cartList;
  final Function callback;

  const CartListDisplay({required this.cartList, required this.callback});

  @override
  State<CartListDisplay> createState() => _CartListDisplayState();
}

class _CartListDisplayState extends State<CartListDisplay> {
  void cartHandler({required Cart cart}) {
    widget.callback(cart);
  }

// TODO: Handle empty list
  @override
  Widget build(BuildContext context) {
    return widget.cartList.isEmpty
        ? Scaffold(
            appBar: AppBar(title: Text("Select Cart")),
            body: Center(child: Text("No Carts Found")))
        : FutureBuilder(
            future: getAllUsers(widget.cartList),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String?, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    appBar: AppBar(title: Text("Select Cart")),
                    body: ListView.builder(
                        itemCount: widget.cartList.length,
                        itemBuilder: ((context, index) {
                          var usersById = {};
                          snapshot.data?.forEach((element) {
                            usersById[element['id']] = element;
                          });
                          var item = widget.cartList[index];
                          var user = usersById[item.user];
                          return Card(
                              child: InkWell(
                                  onTap: () => cartHandler(cart: item),
                                  child: Row(children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(children: [
                                          Text(item.listItems.length.toString(),
                                              style: TextStyle(fontSize: 30)),
                                          const Text("item(s)")
                                        ])),
                                    Expanded(
                                        flex: 3,
                                        child: Column(children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(user['displayName'])),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child:
                                                  Text(item.address.toString()))
                                        ])),
                                    Expanded(
                                        child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                        user!['photoUrl'],
                                      ),
                                    ))
                                  ])));
                        })));
              } else {
                return Scaffold(
                  appBar: AppBar(title: Text("Select Cart")),
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            });
  }
}
