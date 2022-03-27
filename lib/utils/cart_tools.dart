import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final String? user;
  final List<CartItem> listItems;
  late DatabaseReference _id;
  bool inProgress = false;
  Cart(this.user, this.listItems);

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
}

class CartList extends StatefulWidget {
  final Cart cart;

  CartList(this.cart);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
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
