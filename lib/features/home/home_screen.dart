import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:parents/core/common/custom_button.dart';

import '../../core/common/drawer.dart';
import 'widgets/button_hundred.dart';

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


class HomeScreen extends StatefulWidget {
  final String? sessionId;
  const HomeScreen({super.key, this.sessionId});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController dateinput = TextEditingController();
  static bool isZero = false;
  static bool isOnce = true;
  static String someText = "10:00";
  var data, data_length, data_children_length;
  List<String> items = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? initialMessage;
  String? mtoken = " ";
  bool isChecked = false;

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }


  @override
  void initState() {
    dateinput.text = "";
    super.initState();

    // getHpDataKindergarden().then((value) {
    //   var someData = json.decode(value.body) as Map<String, dynamic>;
    //   var someDataLength = (data["data"]["children"]) as List;
    //   someDataLength.toList();
    //
    //   Timer(Duration(seconds: 7), (){
    //     for(int i = 0; i < 364; i++){
    //         deleteAllChildren(someData["data"]["children"][i]["child_id"]).then((value) {
    //           print("This is body: ${value.body}");
    //         });
    //     }
    //   });
    // });
    // GetHPDATA kindergarden deleter
    Timer(
      const Duration(seconds: 3),
      (){
        setState(() {
          isZero = true;
        });
      }
    );
    requestPermission();
    getToken();
    initInfo();

  }

  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: false,
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
          saveToAPI(token).then((value){
            // print("Here we go again: saveToAPI${value.statusCode}");
            // print(json.decode(value.body));
          });
            getHpData(widget.sessionId.toString()).then((value){
            // print("Here we go again getHpData: ${value.statusCode}");
            setState(() {
              data = json.decode(value.body) as Map<String, dynamic>;
              data_length = json.decode(value.body) as Map<String, dynamic>;
              data_children_length = json.decode(value.body) as Map<String, dynamic>;

              data_length = (data["data"]["popup_data"]) as List;
              data_children_length = (data["data"]["children"]) as List;
              data_length.toList();
              data_children_length.toList();

            });
            print("this is data: ${(data["data"]["popup_data"][data_length.length - 1])}");
            // print("this is data list lenth: ${data_children_length.length}");
            // print();
            if(isOnce == true && isZero == false){
              isOnce = false;
              // isZero = true;
              // print("This is what I need?: ${data_length.length}");
              setState(() {
                for(int i = 0; i < data_length.length; i++){
                  showChildApprove(data["data"]["popup_data"][i]["full_name"], data["data"]["popup_data"][i]["id"]);
                }


              });


            }


          });


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
        "session_id" : widget.sessionId.toString(),
        "token" : token,
        "system" : "android"
      }),
    );
  }

  Future<http.Response> deleteAllChildren(int id) {
    return http.post(
      Uri.parse('https://hegati-app.com/Api/service/kindergarten/delete_child'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "session_id" : "1795c2cdd2d10214f315512443ac5066",
        "id" : id.toString(),
      }),
    );
  }

  Future<http.Response> getHpDataKindergarden() {
    return http.post(
      Uri.parse('https://hegati-app.com/Api/service/kindergarten/get_hp_data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "session_id" : "1795c2cdd2d10214f315512443ac5066",
      }),
    );
  }

  Future<http.Response> saveChildApprove(int id, bool isApproved) {
    return http.post(
      Uri.parse('https://hegati-app.com/Api/service/enduser/save_child'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "session_id" : widget.sessionId.toString(),
        "id" : id.toString(),
        "is_approved" : isApproved.toString()
      }),
    );
  }

  Future<http.Response> getHpData(String sessionId) {
    return http.post(
      Uri.parse('https://hegati-app.com/Api/service/enduser/get_hp_data'),
      headers:
      {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "session_id" : widget.sessionId.toString(),
      }),
    );
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokes").doc("User3").set({
      "token" : token,
    });
  }

  void initInfo() {
    var androidInitialize = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iosInitialize);
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
      await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecies,
        payload: message.data["title"]
      );

    });

  }
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  void _showTimePicker(){
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
      setState(() {
        _timeOfDay = value!;
        someText = _timeOfDay.format(context).toString();
      });
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return false; //<-- SEE HERE
    }


    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
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
                          Container(
                            height: MediaQuery.of(context).size.height / 1.55,
                            child: ListView.builder(
                              itemCount: isZero == false ? 1 : data_children_length.length,
                              itemBuilder: (BuildContext context, int index) {
                                if(isZero == false) {
                                  // print("this is index: $index");
                                  return Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      "Before we start, the kindergarten/parent needs to associate a child with you.",
                                      style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  );
                                }
                                else{
                                  // print("This is second: ${data_children_length.length}");

                                  return Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                                              border: Border.all(
                                                width: 1
                                              )
                                              // color: Colors.greenAccent
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(top: 16, right: 15, left: 17.42, bottom: 13),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                          border: Border.all(width: 1)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Dialing\n Kinderganden",
                                                            style: GoogleFonts.rubik(
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                          const Icon(Icons.call, color: Colors.grey,),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "${data["data"]["children"][data_children_length.length - 1 - index]["full_name"].toString().length >= 19 ? data["data"]["children"][data_children_length.length - 1 - index]["full_name"].toString().substring(0,15) + "..." : data["data"]["children"][data_children_length.length - 1 - index]["full_name"]}",
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w500
                                                          ),
                                                        ),
                                                        Text(
                                                          "Some Text",
                                                          style: GoogleFonts.rubik(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        )
                                                      ],)
                                                  ],
                                                ),
                                              ),
                                              Image.asset("assets/images/svg/Rectangle_548.png"),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 19.16, vertical: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ButtonWontCome(index: index, ontap: () { wontComeDialogShow(); },),
                                                    ButtonLate(index: index, ontap: () { lateDialogShow();},),
                                                    ButtonArrived(index: index, ontap: () { arrivalDialogShow();},)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 15,)
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
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
                          children: const [
                            HundredButton("100"),
                            HundredButton("101"),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
            ),),
        ),
      ),
    );

  }



  Widget buildPopupDialog(BuildContext context, String? title, String? body) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.only(
            top: 12,
            right: 28.24,
            bottom: 19.3,
            left: 29
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFEAFFEA),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite Parent",
              style: GoogleFonts.rubik(
                  fontSize: 30,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(width: 22.87,),
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.cancel, size: 31,)
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 53,
            ),
            child: Text(
              "Hi ${title}\nRainbow Kindergarten invited you to be the responsible parent in Roni Almog's \"Hegati\" app. \n"
                  "This is body: ${body}",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 23
            ),
            child: CustomButton(text: "Accept", onTap: () {
              // setState(() {
                getToken();
              // });
              getHpData(widget.sessionId.toString());
              setState(() {
                Timer(const Duration(seconds: 3), () {
                  int temp = data["data"]["popup_data"][data_length.length - 1]["id"];
                  saveChildApprove(temp, true).then((value) {
                    print("This is Notification: ${value.body}");
                    print("This is id2: ${data["data"]["popup_data"][data_length.length - 1]["id"]} = $temp");
                  });
                  getToken();

                });

                Timer(const Duration(seconds: 3), () {
                  getToken();
                });
              });

              Navigator.of(context).pop();
            }),
          ),
          const SizedBox(height: 24,),
          Container(
            padding: const EdgeInsets.only(
                left: 24,
                right: 23
            ),
            child: CustomButton(text: "Ignore", onTap: () {
              // setState(() {
              getToken();
              // });
              getHpData(widget.sessionId.toString());
              setState(() {
                Timer(const Duration(seconds: 3), () {
                  int temp = data["data"]["popup_data"][data_length.length - 1]["id"];
                  saveChildApprove(temp, false).then((value) {
                    print("This is Notification: ${value.body}");
                    print("This is id2: ${data["data"]["popup_data"][data_length.length - 1]["id"]} = $temp");
                  });
                  getToken();

                });

                Timer(const Duration(seconds: 3), () {
                  getToken();
                });
              });

              Navigator.of(context).pop();
            }, color: Colors.white, shadowColor: Colors.grey,),
          ),
          const SizedBox(height: 23,)

        ],
      ),
    );
  }

  Widget buildPopupDialogApprove(BuildContext context, String? title, int id) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.only(
            top: 12,
            right: 28.24,
            bottom: 19.3,
            left: 29
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFEAFFEA),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Information - Roni\n Almog",
              style: GoogleFonts.rubik(
                  fontSize: 30,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(width: 22.87,),
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.cancel, size: 31,)
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hi ${title}\nRainbow Kindergarten invited you to be the responsible parent in Roni Almog's \"Hegati\" app. \n",
            style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w400
            ),
          ),
          const SizedBox(height: 16,),
          CustomButton(text: "Accept", onTap: () {
            setState(() {
              Timer(
                  const Duration(seconds: 1),
                      () {
                    getToken();
                    setState(() {
                      saveChildApprove(id, true).then((value) {
                        print("This is accept: \n${value.body}");
                      });
                    });
                  }
              );
              Navigator.of(context).pop();
            });

          }),
          const SizedBox(height: 24,),
          CustomButton(text: "Ignore", onTap: () {
            setState(() {
              Timer(
                  const Duration(seconds: 1),
                      () {
                    getToken();
                    setState(() {
                      saveChildApprove(id, false).then((value) {
                        print("This is accept: \n${value.body}");
                      });
                    });
                  }
              );
              Timer(
                  const Duration(seconds: 1),
                      (){

                  }
              );
              Navigator.of(context).pop();
            });
          }, color: Colors.white, shadowColor: Colors.grey,)
        ],
      ),
    );
  }

  Widget wontComeDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFFFF0DE),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 53
              ),
              child: Center(
                child: Text(
                  "Absence Report",
                  style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel, size: 24  ,)
                )
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 19,
              right: 10,
              left: 17
            ),
            child: Text(
              "Are you sure about marking - Won't be arriving today",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(height: 16,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: -3,
                              blurRadius: 7,
                              offset: Offset(3, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white
                      ),

                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -3,
                            blurRadius: 7,
                            offset: Offset(3, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            stops: [0.1, 0.9],
                            colors: [
                              Color(0xffFFDCBB),
                              Color(0xffF9A23C),
                            ]),
                      ),

                      child: Center(
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),


              ],
            ),
          ),
          const SizedBox(height: 24,)

        ],
      ),
    );
  }


  Widget arrivalDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFEAFFEA),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 53
              ),
              child: Center(
                child: Text(
                  "Arrival Confirmation",
                  style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel, size: 24  ,)
                )
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 19,
                right: 10,
                left: 17
            ),
            child: Text(
              "Marking \"I have arrived\" only be possible when you physically arrive at the kindergarden",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(height: 25,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: -3,
                              blurRadius: 7,
                              offset: Offset(3, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white
                      ),

                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        showDialog(
                          barrierLabel: "HEllo",
                          // barrierColor: Colors.lightGreen,
                          context: context, builder: (BuildContext context) => arrivalApproveDialog(context),
                        );
                      });
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -3,
                            blurRadius: 7,
                            offset: Offset(3, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Color(0xffA9F9B1),
                              Color(0xff37F9A7),
                            ]),
                      ),

                      child: Center(
                        child: Text(
                          "Yes. I'm\nsure",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),


              ],
            ),
          ),
          const SizedBox(height: 24,)

        ],
      ),
    );
  }

  Widget lateDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFFDFFDC),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 53
              ),
              child: Center(
                child: Text(
                  "Late Attendance",
                  style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel, size: 24,)
                )
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 14,),
          Container(
            padding: const EdgeInsets.only(
                left: 23
            ),
            child: Text(
              "New arrival time",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: (){
                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                    setState(() {
                      _timeOfDay = value!;
                      someText = _timeOfDay.format(context).toString();
                    });
                  }).then((value) {
                    Navigator.pop(context);
                    lateDialogShow();
                  });
              },
              child: Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    width: 1,
                    color: Colors.black12
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(
                        someText,
                        style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Stack(
                          children: [
                            const Positioned(child: Icon(Icons.circle, size: 20, color: Colors.grey,)),
                            const Positioned(child: Icon(Icons.access_time, size: 20, color: Colors.white,)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 3,)
                  ],
                )
              ),
            ),
          ),
          const SizedBox(height: 18,),
          Container(padding: EdgeInsets.only(left: 19, right: 24),
              child: Text(
                "Please mark Arrived at the Kindergarden",
                style: GoogleFonts.rubik(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              )
          ),
          const SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: -3,
                              blurRadius: 7,
                              offset: Offset(3, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white
                      ),

                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),
                // const SizedBox(width: 24,),
                GestureDetector(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Color(0xffFFF7B1),
                              Color(0xffFFE70D),
                            ]),
                      ),

                      child: Center(
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                )


              ],
            ),
          ),
          const SizedBox(height: 24,)

        ],
      ),
    );
  }

  Widget arrivalApproveDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(19.95))
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(19.95),
              topLeft: Radius.circular(19.95)
          ),
          color: Color(0xFFEAFFEA),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40
              ),
              child: Center(
                child: Text(
                  "Entering Kindergarden",
                  style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel, size: 24  ,)
                )
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 19,
                right: 10,
                left: 17
            ),
            child: Text(
              "Are you sure about marking Arrival",
              style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(height: 25,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: -3,
                              blurRadius: 7,
                              offset: Offset(3, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white
                      ),

                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Container(
                      width: 128,
                      height: 48,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: -3,
                            blurRadius: 7,
                            offset: Offset(3, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            stops: [0.1, 0.9],
                            colors: [
                              Color(0xffA9F9B1),
                              Color(0xff37F9A7),
                            ]),
                      ),

                      child: Center(
                        child: Text(
                          "Mark\nanyway",
                          style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),

                        ),
                      ),
                    )
                ),


              ],
            ),
          ),
          const SizedBox(height: 24,)

        ],
      ),
    );
  }
  void saveNotification(String? title, String? body) {
    showDialog(
      barrierLabel: "HEllo",
      // barrierColor: Colors.lightGreen,
      context: context, builder: (BuildContext context) => buildPopupDialog(context, title, body),
    );
  }

  void wontComeDialogShow() {
    showDialog(
      context: context, builder: (BuildContext context) => wontComeDialog(context),
    );
  }

  void lateDialogShow() {
    showDialog(
      context: context, builder: (BuildContext context) => lateDialog(context),
    );
  }

  void arrivalDialogShow() {
    showDialog(
      context: context, builder: (BuildContext context) => arrivalDialog(context),
    );
  }

  // void wontComeDialogShow() {
  //   showDialog(
  //     context: context, builder: (BuildContext context) => wontComeDialog(context),
  //   );
  // }

  void showChildApprove(String? title, int id) {
    showDialog(
      barrierLabel: "HEllo",
      context: context, builder: (BuildContext context) => buildPopupDialogApprove(context, title, id),
    );
  }


}


class ButtonWontCome extends StatelessWidget {
  final int? index;
  final Function() ontap;
  const ButtonWontCome({
  super.key, required this.index, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orangeAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Won't\n come\n today",
            style: GoogleFonts.rubik(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonLate extends StatelessWidget {
  final int? index;
  final Function() ontap;
  const ButtonLate({
  super.key, this.index, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: const BoxDecoration(
            color: Colors.yellowAccent,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Late",
            style: GoogleFonts.rubik(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonArrived extends StatelessWidget {
  final int? index;
  final Function() ontap;
  const ButtonArrived({
  super.key, this.index, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.greenAccent
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Arrived",
            style: GoogleFonts.rubik(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}




