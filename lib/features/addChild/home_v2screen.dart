import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:parents/core/common/custom_button.dart';
import 'package:parents/main.dart';

import '../../core/common/drawer.dart';

const String navigationActionId = 'id_3';
final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}


class Homev2Screen extends StatefulWidget {
  const Homev2Screen({super.key});

  @override
  State<Homev2Screen> createState() => _Homev2ScreenState();
}


class _Homev2ScreenState extends State<Homev2Screen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? _token;
  String? initialMessage;
  bool _resolved = false;
  String? mtoken = " ";
  bool isChecked = false;
  TextEditingController phoneController = TextEditingController();

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();

  }

  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }
    else {
      print("User declined or has not accepted permission");
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("There is some message");
      if(message.notification != null){
        print("Message contains: ${message.notification}");
      }
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
              setState(() {
                mtoken = token;
                print("My token is $mtoken");
              });
              saveToken(token!);
              saveToAPI(token);
              print("succesfully sent");

            }
    );

  }

  Future<http.Response> saveToAPI(String token) {
    return http.post(
      Uri.parse('https://hegati-app.com/Api/service/enduser/save_push_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "session_id" : "f6f86f326e24b6c83393930198388c273832080f",
        "token" : token,
        "system" : "android"
      }),
    );
    print("succesfully sent");
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokes").doc("User3").set({
          "token" : token,
        });
  }

  void initInfo() {
    var androidInitialize = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialize = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage ${message.notification?.title}/${message.notification?.body}");
      saveNotification(message.notification?.title, message.notification?.body);

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true
      );

      AndroidNotificationDetails androidPlatformChannelSpecies = AndroidNotificationDetails(
        "dbFood",
        "dbFood ",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation, priority: Priority.high,
        playSound: false
      );

      NotificationDetails platformChannelSpecies = NotificationDetails(android: androidPlatformChannelSpecies, iOS: const DarwinNotificationDetails());
      // await flutterLocalNotificationsPlugin.show(
      //     0,
      //     message.notification?.title,
      //     message.notification?.body,
      //     platformChannelSpecies,
      //   payload: message.data["title"]
      // );
      //
    });

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [
                0.1,
                0.2,
                0.9
              ],
              colors: [
                Color(0xFFE7FFE9),
                Color(0xFFF4FFF5),
                Color(0xFFFFFFFF),
              ])),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
          ),
          endDrawer: CustomNavigationDrawer(),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 105,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Good Morning",
                              style: GoogleFonts.rubik(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500
                              ),

                            ),
                            Image.asset("assets/images/svg/sun.png")
                          ],
                        ),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "Before we start, the kindergarten/parent needs to associate a child with you.",
                              style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    // top: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(36), bottomRight: Radius.circular(36)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -3,
                            blurRadius: 7,
                            offset: Offset(3, 3),
                          )
                        ],
                        color: Colors.white,
                      ),
                      height: 88,
                      width: 165,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.call, size: 16, color: Colors.white),
                                Text(
                                  "101",
                                  style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 56,
                            width: 56,
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.call, size: 16, color: Colors.white),
                                Text(
                                  "101",
                                  style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),),
      ),
    );

}



  Widget buildPopupDialog(BuildContext context, String? title, String? body) {
    String tmp = "Ronan Almog";
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      title: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          color: Colors.transparent,
          child: Text(
            "Invite Parent",
            style: GoogleFonts.rubik(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hi ${title}\n Rainbow Kindergarten invited you to be the responsible parent in Roni Almog's \"Hegati\" app. \n"
                "This is body: ${body}",
            style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w400
            ),
          ),
          SizedBox(height: 16,),
          CustomButton(text: "Accept", onTap: () { }),
          SizedBox(height: 24,),
          CustomButton(text: "Ignore", onTap: () { }, color: Colors.white, shadowColor: Colors.grey,)
        ],
      ),
    );
  }

  void saveNotification(String? title, String? body) {
    showDialog(
      barrierDismissible: true,
      barrierLabel: "Hello",
      context: context, builder: (BuildContext context) => buildPopupDialog(context, title, body),
    );
  }
}
