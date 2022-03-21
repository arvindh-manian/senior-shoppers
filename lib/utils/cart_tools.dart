import 'package:flutter/material.dart';

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
}

class CartList extends StatefulWidget {
  final List<CartItem> listItems;

  CartList(this.listItems);

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
      widget.listItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listItems.length,
        itemBuilder: (context, index) {
          var item = widget.listItems[index];
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
                    icon: Icon(Icons.edit),
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
