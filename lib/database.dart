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
    databaseReference.child('users/' + user.id).set(userToJson(user));
  }
}

Future<Cart> getCart(DatabaseReference id) async {
  await id.once().then((response) {
    return Cart.fromJson(response.snapshot.value as Map<String, dynamic>);
  });
  throw Exception("id not found");
}

Future<List<Cart>> getAllCarts() async {
  var response = await databaseReference.child('carts/').once();
  final val = response.snapshot.value as Map;
  List<Cart> carts = [];
  val.forEach((key, value) {
    var cart = value as Map;
    Map<String, dynamic> _ = {};
    _['listItems'] = cart['listItems'];
    _['inProgress'] = cart['inProgress'];
    _['user'] = cart['user'];
    carts.add(Cart.fromJson(_));
  });
  return carts;
}

Future<List<Map<String, dynamic>>> getAllUsers(List<Cart> cartList) async {
  List<Map<String, dynamic>> ret = [];
  for (Cart cart in cartList) {
    ret.add(await getUser(cart.user));
  }
  return ret;
}

Future<Map<String, dynamic>> getUser(String? id) async {
  if (id != null) {
    var response = await databaseReference.child('users/' + id).once();
    var ret = response.snapshot.value as Map;
    Map<String, dynamic> _ = {};
    _['photoUrl'] = ret['photoUrl'];
    _['displayName'] = ret['displayName'];
    _['email'] = ret['email'];
    _['serverAuthCode'] = ret['serverAuthCode'];
    _['id'] = ret['id'] as String;
    return _;
  }
  throw Exception("No user found");
}
