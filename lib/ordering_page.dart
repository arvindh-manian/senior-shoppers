import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';
import 'utils/cart_tools.dart';
import 'text_input_widget.dart';

class OrderingPage extends StatefulWidget {
  final GoogleSignInAccount? user;
  late Cart cart;
  OrderingPage({required this.user}) {
    cart = Cart(user: user?.id, listItems: <CartItem>[]);
  }

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  void newItem(List<String> text) {
    setState(() {
      widget.cart.listItems.add(
          CartItem(name: text[0], quantity: int.parse(text[1]), unit: text[2]));
    });
  }

  void sendCart() {
    widget.cart.setId(saveCart(widget.cart));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Senior Shoppers")),
        body: Column(
          children: <Widget>[
            Expanded(child: CartDisplay(cart: widget.cart)),
            TextInputWidget(newItem, sendCart),
          ],
        ));
  }
}
