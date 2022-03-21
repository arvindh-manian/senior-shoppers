import 'package:flutter/material.dart';
import 'utils/cart_tools.dart';
import 'text_input_widget.dart';

class OrderingPage extends StatefulWidget {
  final String name;

  OrderingPage(this.name);

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  List<CartItem> cart = [];

  void newItem(List<String> text) {
    setState(() {
      cart.add(
          CartItem(name: text[0], quantity: int.parse(text[1]), unit: text[2]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Senior Shoppers")),
        body: Column(
          children: <Widget>[
            Expanded(child: CartList(cart)),
            TextInputWidget(newItem),
          ],
        ));
  }
}
