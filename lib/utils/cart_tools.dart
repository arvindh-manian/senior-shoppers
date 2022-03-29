import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  late List<CartItem> listItems;
  late DatabaseReference _id;
  late bool inProgress = false;
  Cart({required this.user, required this.listItems, this.inProgress = false});

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'inProgress': inProgress,
      'listItems':
          List.generate(listItems.length, (index) => listItems[index].toJson()),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      user: json['user'],
      listItems: List.generate(
          json['listItems'].length,
          ((index) => CartItem(
              name: json['listItems'][index]['name'],
              quantity: json['listItems'][index]['quantity'],
              unit: json['listItems'][index]['unit']))),
      inProgress: json['inProgress']);

  DatabaseReference getId() {
    return _id;
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

  const CartListDisplay({required this.cartList});

  @override
  State<CartListDisplay> createState() => _CartListDisplayState();
}

class _CartListDisplayState extends State<CartListDisplay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllUsers(widget.cartList),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String?, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(title: Text("Select Cart")),
                body: ListView.builder(
                    itemCount: widget.cartList.length,
                    itemBuilder: ((context, index) {
                      var users_by_id = {};
                      snapshot.data?.forEach((element) {
                        users_by_id[element['id']] = element;
                      });
                      var item = widget.cartList[index];
                      var user = users_by_id[item.user];
                      return Card(
                          child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Column(children: [
                              Text(item.listItems.length.toString(),
                                  style: TextStyle(fontSize: 30)),
                              const Text("item(s)")
                            ])),
                        Expanded(flex: 3, child: Text(user['displayName'])),
                        Expanded(
                            child: Image.network(
                          user!['photoUrl'],
                          scale: 3,
                        ))
                      ]));
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
