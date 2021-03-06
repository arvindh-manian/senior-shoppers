// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:senior_shoppers/database.dart';
import 'package:senior_shoppers/utils/cart_tools.dart';

class DeliveringPage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const DeliveringPage(this.user);

  @override
  State<DeliveringPage> createState() => _DeliveringPageState();
}

class _DeliveringPageState extends State<DeliveringPage> {
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
                if (crt.deliverer == "") {
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
                                user: widget.user?.id,
                                voidCallback: () {
                                  if (cart.user == widget.user?.id) {
                                    return AwesomeDialog(
                                      context: context,
                                      animType: AnimType.LEFTSLIDE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.ERROR,
                                      showCloseIcon: true,
                                      title: 'Error!',
                                      desc: "You cannot claim your own cart",
                                      btnOkIcon: Icons.error,
                                    ).show();
                                  } else {
                                    changeCart(cart.getId(), 'deliverer',
                                        widget.user?.id);
                                    cart.deliverer = widget.user?.id;
                                    return AwesomeDialog(
                                      context: context,
                                      animType: AnimType.LEFTSLIDE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      showCloseIcon: true,
                                      title: 'Success!',
                                      desc: "You've claimed this cart!",
                                      btnOkIcon: Icons.check_circle,
                                    ).show();
                                  }
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
