import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return CartListDisplay(cartList: snapshot.data as List<Cart>);
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
