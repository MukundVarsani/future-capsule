import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/data/models/settings_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class UserController extends GetxController {
  static final UserController _instance = UserController._internal();
  UserController._internal();

  factory UserController() => _instance;

  // Initailization
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //Observable Current User

  final _currentUser = Rxn<User>();

  set setUser(User? user) {
    _currentUser.value = user;
  }

  User? get getUser => _currentUser.value;

  @override
  void onInit() {
    _currentUser(_firebaseAuth.currentUser);
    // Vx.log("User controller Initialize");
    super.onInit();
  }

  Future<void> createNewUser(Map<String, dynamic> newUser) async {
    User? user = _currentUser.value;
    if (user == null) return;

    DateTime now = DateTime.now();

    UserModel userData = UserModel(
      userId: user.uid,
      bio: newUser['bio'],
      email: user.email.toString(),
      name: newUser['name'],
      profilePicture: "",
      settings: SettingsModel(
        language: "en",
        notificationsEnabled: false,
        theme: "Dark",
      ),
      fcmToken: null,
      updatedAt: now,
      createdAt: now,
    );

    try {
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(user.uid)
          .set(userData.toJson());
    } catch (e) {
      Vx.log("Failed to add user profile: $e");
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firebaseFirestore
        .collection("Future_Capsule_Users")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data() != null) {
          return UserModel.fromJson(
              snapshot.data()!); // Return the user data as a map
        }
      } else {
        return null; // Return null if the document doesn't exist
      }
      return null;
    });
  }

  void updateUserData(Map<String, dynamic> updatedData) async {
    if (_currentUser.value?.uid == null) return;
    DateTime now = DateTime.now();

    updatedData['updatedAt'] = now.toIso8601String();

    try {
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(_currentUser.value?.uid)
          .update(updatedData)
          .then((value) => Vx.log("User data updated successfully."));
    } catch (e) {
      Vx.log("Failed to update user data: $e");

      if (e.toString().contains('NOT_FOUND')) {
        Vx.log("Document not found, creating a new one.");
        await _firebaseFirestore
            .collection("Future_Capsule_Users")
            .doc(_currentUser.value?.uid)
            .set(updatedData);
      }
    }
  }

  Future<UserModel?> getUserById({required String userId}) async {
    try {
      DocumentSnapshot doc = await _firebaseFirestore
          .collection('Future_Capsule_Users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        Vx.log("User not found by Id : $userId");
        return null;
      }
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      Vx.log('Error while getting user By id : $e');
      return null;
    }
  }
}



// /* 
  
// {
//      "foodName": [
//         "iced tea",
//         "iced tea",
//         "beer"
//     ],
//  "nutritional_info": {
//      "calories": 142.0,
//          "dailyIntakeReference": {
//             "CHOCDF": {
//                 "label": "Carbs",
//                 "level": "LOW",
//                 "percent": 5.0721738701363766
//             },
//             "ENERC_KCAL": {
//                 "label": "Energy",
//                 "level": "NONE",
//                 "percent": 6.898933808039899
//             },
           
       
//             "PROCNT": {
//                 "label": "Protein",
//                 "level": "LOW",
//                 "percent": 1.475011481775291
//             },
//             "SUGAR": {
//                 "label": "Sugars",
//                 "level": "NONE",
//                 "percent": 0.0
//             },
//            "totalNutrients": {
//              "ALC": {
//                 "label": "Alcohol",
//                 "quantity": 15.839999999999998,
//                 "unit": "g"
//             },
//             "CA": {
//                 "label": "Calcium",
//                 "quantity": 27.3,
//                 "unit": "mg"
//             },
//             "CAFFN": {
//                 "label": "Caffeine",
//                 "quantity": 2.0,
//                 "unit": "mg"
//             },
//             "CHOCDF": {
//                 "label": "Carbs",
//                 "quantity": 11.744999999999997,
//                 "unit": "g"
//             },
//          },
//  },
//      "nutritional_info_per_item": [
//         {
//             "food_item_position": 1,
//             "hasNutritionalInfo": true,
//                "id": 1937,
//             "nutritional_info": {
//                    "calories": 0.05,
//                 "dailyIntakeReference": {
                  
//                       "CHOCDF": {
//                         "label": "Carbs",
//                         "level": "LOW",
//                         "percent": 0.006477872120225258
//                     },
//                     "ENERC_KCAL": {
//                         "label": "Energy",
//                         "level": "NONE",
//                         "percent": 0.002429202045084472
//                     },
//                 },
//                 "totalNutrients": {
//                       "ALC": {
//                         "label": "Alcohol",
//                         "quantity": 0.0,
//                         "unit": "g"
//                     },
//                     "CA": {
//                         "label": "Calcium",
//                         "quantity": 7.050000000000001,
//                         "unit": "mg"
//                     },
//                     "CAFFN": {
//                         "label": "Caffeine",
//                         "quantity": 1.0,
//                         "unit": "mg"
//                     },
//                 }
//               },
//                    "serving_size": 240.0
//         },
//      ]
//    "serving_size": 810.0
//   }

//   // */ 