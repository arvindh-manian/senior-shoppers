import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_shoppers/utils/cart_tools.dart';
import 'package:senior_shoppers/utils/google_tools.dart';

final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference saveCart(Cart cart) {
  DatabaseReference id = databaseReference.child('carts/').push();
  id.set(cart.toJson());
  return id;
}

void saveUser(GoogleSignInAccount? user) {
  if (user != null) {
    databaseReference.child('/users/' + user.id).set(userToJson(user));
  }
}
