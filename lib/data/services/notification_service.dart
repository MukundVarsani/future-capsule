import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final UserController _userController = Get.put(UserController());
  FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  void init() {
    initializeLocalNotifications();
    requestPermission();
    setupForegroundNotificationHandler();
  }

  void initializeLocalNotifications() {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    localNotifications.initialize(initSettings);

    // Ensure notification channel exists for Android 8+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // ID
      'channel_name', // Name
      description: 'Description of your channel',
      importance: Importance.high,
    );

    localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Vx.log("Notification initialize");
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setFcmToken();
    } else {
      Vx.log("User declined permission");
    }
  }

  void setFcmToken() async {
    String? currentUserId = _userController.getUser?.uid;
    Vx.log(currentUserId);
    if (currentUserId == null) return;

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(currentUserId)
          .update({"fcmToken": token});
    } catch (e) {
      Vx.log("Error getting FCM Token: $e");
      return;
    }
  }

  Future<void> removeFcmToken() async {
    String? currentUserId = _userController.getUser?.uid;

    if (currentUserId == null) return;

    try {
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(currentUserId)
          .update({"fcmToken": ""});
    } catch (e) {
      Vx.log("Error getting FCM Token: $e");
      return;
    }
  }

  void setupForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
            body: message.notification?.body,
            title: message.notification?.title);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void showLocalNotification({
    String? title,
    String? body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotifications.show(
      0, // Notification ID
      title ?? "No Title",
      body ?? "No Body",
      platformChannelSpecifics,
    );
  }

  static void sendNotification(
      {required String userId,
      required String userName,
      required String capsuleTitle}) async {
    var url = Uri.http('192.168.0.128:3001', '/notify-recipients');

    try {
      var response = await http.post(url, body: {
        'userId': userId,
        'userName': userName,
        'capsuleTitle': capsuleTitle
      });
      Vx.log('Response status: ${response.statusCode}');
    } catch (e) {
      Vx.log('Error in response $e');
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Vx.log("Handling a background message");
}
