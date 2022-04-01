// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:senior_shoppers/database.dart';
import 'package:senior_shoppers/utils/cart_tools.dart';

class CurrentDeliveriesPage extends StatefulWidget {
  final String? user;
  CurrentDeliveriesPage({required this.user});

  @override
  State<CurrentDeliveriesPage> createState() => _CurrentDeliveriesPageState();
}

class _CurrentDeliveriesPageState extends State<CurrentDeliveriesPage> {
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
                    body: Center(child: Text("No Carts Found")));
              } else {
                return Scaffold(
                    appBar: AppBar(title: Text("Select Cart")),
                    body: Center(child: Text("Error. Please contact ")));
              }
            } else if (snapshot.hasData) {
              List<Cart> lst = [];
              for (Cart crt in snapshot.data as List<Cart>) {
                if (crt.deliverer == widget.user && crt.isFinished == false) {
                  lst.add(crt);
                }
              }
              return CartListDisplay(
                  cartList: lst,
                  callback: (Cart cart) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: RenderCart(
                                cart: cart,
                                user: widget.user,
                                voidCallback: () {
                                  changeCart(cart.getId(), 'isFinished', true);
                                  return AwesomeDialog(
                                    context: context,
                                    animType: AnimType.LEFTSLIDE,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.SUCCES,
                                    showCloseIcon: true,
                                    title: 'Success!',
                                    desc: "You've marked this cart as complete",
                                    btnOkIcon: Icons.check_circle,
                                  ).show();
                                })));
                  });
            } else {
              return Text("This should never be seen");
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
