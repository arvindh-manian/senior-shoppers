import 'package:google_sign_in/google_sign_in.dart';

Map<String, dynamic> userToJson(GoogleSignInAccount user) {
  return {
    'displayName': user.displayName,
    'email': user.email,
    'photoUrl': user.photoUrl,
    'serverAuthCode': user.serverAuthCode,
    'id': user.id
  };
}
