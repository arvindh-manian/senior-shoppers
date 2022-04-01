// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';
import 'utils/cart_tools.dart';
import 'text_input_widget.dart';

class OrderingPage extends StatefulWidget {
  final GoogleSignInAccount? user;
  final String? address;
  late Cart cart;
  OrderingPage({required this.user, required this.address}) {
    cart = Cart(user: user?.id, listItems: <CartItem>[], address: address);
  }

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  newItem(List<String> text) {
    if (text[1] == '') {
      return AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Error',
              desc: 'Enter valid quantity',
              btnOkIcon: Icons.error)
          .show();
    } else if (int.parse(text[1]) <= 0) {
      return AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Error',
              desc: 'Quantity must be non-zero',
              btnOkIcon: Icons.error)
          .show();
    } else if (text[0] == '') {
      return AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Error',
              desc: 'Enter valid name',
              btnOkIcon: Icons.error)
          .show();
    } else {
      setState(() {
        widget.cart.listItems.add(CartItem(
            name: text[0], quantity: int.parse(text[1]), unit: text[2]));
      });
    }
  }

  sendCart() {
    if (widget.cart.listItems.isEmpty) {
      return AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Error!',
              desc: 'Cart cannot be empty',
              btnOkIcon: Icons.error)
          .show();
    } else {
      widget.cart.setId(saveCart(widget.cart));
      return AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        showCloseIcon: true,
        title: 'Success!',
        desc: 'Your cart has been added to the current queue',
        btnOkIcon: Icons.check_circle,
      ).show();
    }
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
