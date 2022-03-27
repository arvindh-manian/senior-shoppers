import 'package:firebase_database/firebase_database.dart';
import 'package:senior_shoppers/utils/cart_tools.dart';

final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference saveCart(Cart cart) {
  DatabaseReference id = databaseReference.child('carts/').push();
  id.set(cart.toJson());
  return id;
}
