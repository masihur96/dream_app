import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dream_app/bottom_navigation_bar/account_nav.dart';
import 'package:dream_app/bottom_navigation_bar/cart_page.dart';
import 'package:dream_app/bottom_navigation_bar/package_list.dart';
import 'package:dream_app/bottom_navigation_bar/product_page.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/pages/login_page.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> with TickerProviderStateMixin {
  DateTime? currentReferDate;
  DateTime? lastReferDate;
  int _counter = 0;
  int? newReferYear;
  int? newReferMonth;
  String watchDt = DateFormat('yyyy-MM-dd').format(DateTime.now());

  TabController? _tabController;
  // String _pageTitle = '';

  String? id;
  String? _deviceId;
  String? deviceId;
  Future<void> initDeviceId() async {

    String deviceid;

    deviceid = (await getDeviceId())!;

    if (!mounted) return;

    setState(() {
      _deviceId = '$deviceid';
    });

    print("_deviceId: $_deviceId");
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('deviceId', _deviceId!);
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique Android device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique iOS device ID
    }

    return null; // Return null for unsupported platforms
  }

  // subscribeTO() async {
  //   await FirebaseMessaging.instance.subscribeToTopic("sample");
  // }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      deviceId = preferences.get('deviceId') as String?;
    });

    print(id);
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    _checkPreferences();

    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  Future<void> updateUserDetails(UserController userController) async {
    // to convert from "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" to 'MM/dd/yyyy hh:mm a'
    //
    // date = '2021-01-26T03:17:00.000000Z';
    // DateTime parseDate =
    // new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    // var inputDate = DateTime.parse(parseDate.toString());
    // var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    // print(outputDate)
    print("SID: $id!");
    await FirebaseMessaging.instance.subscribeToTopic(id!);
    _counter++;
    await userController.getUser(id!);
    await userController.getUserCart();
    await userController.getWithDrawHistory(id!);
    await userController.getDepositHistory(id!);
    await userController.getReferUserReferList(id!);
    await userController.getWatchedHistory();
    await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshots) async {
      querySnapshots.docChanges.forEach((document) {
        if (watchDt != document.doc['watchDate']) {
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "videoWatched": '0',
          });
        }
        setState(() {
          currentReferDate = DateTime.parse(
              '${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

          var date = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(document.doc['referDate']) * 1000);
          lastReferDate =
              DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        });
        var days = currentReferDate!.difference(lastReferDate!).inDays;

        if (days > 180) {
          var date = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(document.doc['timeStamp']) * 1000);
          int referLimit = int.parse(document.doc['referLimit']) + 100;
          print(date.month);
          int newMonth = date.month + 6;
          if (newMonth > 12) {
            setState(() {
              newReferYear = date.year + 1;
              newReferMonth = newMonth - 12;
            });
          } else {
            setState(() {
              newReferYear = date.year;
            });
          }
          var newString =
              document.doc['phone'].substring(document.doc['phone'].length - 6);
          final String monthYear = DateFormat("MMyy").format(
              DateTime.parse("$newReferYear-$newReferMonth-${date.day}"));
          String myReferCode = 'MakB$monthYear$newString';
          //var newYear = '$newReferYear'.substring('$newReferYear'.length - 2);
          //var newString = document.doc['phone'].substring(document.doc['phone'].length - 6);
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            // 'id': id,
            // "name": name,
            // "address": address,
            // "phone":phone,
            // "password":password,
            // "nbp":nbp,
            // "email": '',
            // "zip": '',
            "referCode": myReferCode,
            "timeStamp": DateTime.now().millisecondsSinceEpoch,
            "referDate": '$newReferYear-$newReferMonth-${date.day}',
            // "imageUrl": '',
            // "referredList": '',
            // //"numberOfReferred": '0',
            // //"insuranceEndingDate": insuranceEndingDate,
            // "depositBalance": '0',
            // "depositHistory": '',
            // "withdrawHistory": '',
            // //"insuranceBalance": '0',
            // "lastInsurancePayment": '',
            // "level": '0',
            // //"mainBalance": '0',
            // "videoWatched": '0',
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            // "myStore": '',
            // "myOrder": '',
            // "cartList": '',
            "referLimit": '$referLimit',
          });
        } else {
          print(document.doc['referDate']);
        }
      });
    });
  }

  Future<void> fetchData(UserController userController,
      ProductController productController) async {
    await userController.getMyStore();
    await userController.getProductOrder();
    await userController.getRate();
    await userController.getContactInfo();
    await productController.getPackage();
  }

  Future<bool> _onBackPressed() async {
    _showDialog();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final ProductController productController = Get.find<ProductController>();
    final Size size = MediaQuery.of(context).size;
    if (_counter == 0) {
      if (id != null) {
        updateUserDetails(userController);
      }
      fetchData(userController, productController);
    }
    if (id != null) {
      userController.getUser(id!);
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                  color: Color(0xFF19B52B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide.none,
                  ),
                  labelColor: Color(0xFF19B52B),
                  unselectedLabelColor: Colors.grey.shade400,
                  tabs: [
                    Tab(
                      icon: Icon(FontAwesomeIcons.tshirt),
                      text: 'Product',
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.boxOpen),
                      text: 'Package',
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.cartPlus),
                      text: 'Cart',
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.userCircle),
                      text: 'Account',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            ProductPage(),
            PackageListPage(),
            CartPage(),
            id == null ? LoginPage() : AccountNav()
          ],
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Are you sure you want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
