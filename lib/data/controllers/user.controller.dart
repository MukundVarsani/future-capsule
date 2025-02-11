import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var currentUser = Rxn<User>();

  set setUser(User? user) {
    currentUser.value = user;
  }

  User? get getUser => currentUser.value;
}
