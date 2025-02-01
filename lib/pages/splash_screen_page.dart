import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dream_app/controller/advertisement_controller.dart';
import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

import '../home_nav.dart';
import 'first_user_register_page.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController userController = Get.put(UserController());
  int count = 0;

  Future<void> fetch() async {
    final AdvertisementController advertisementController =
        Get.put(AdvertisementController());
    final AuthController authController = Get.put(AuthController());
    final ProductController productController = Get.put(ProductController());

    await userController.getFirstUser();
    await productController.getProducts(100);
    await productController.getArea();
    await productController.getCart();
    await userController.getRate();
    await productController.getCategory();

    if (productController.categoryList.isNotEmpty) {
      await productController
          .getSubCategory(productController.categoryList[0].category);
    }
    if (productController.subCategoryList.isNotEmpty) {
      await productController.getSubCategoryProducts(
          productController.subCategoryList[0].subCategory);
    }
    await productController.getCart();
    if (productController.areaList.isNotEmpty) {
      await productController.getAreaHub(productController.areaList[0].id);
    }

    if (userController.checkUserModel.value.count != '0') {
      Timer(Duration(seconds: 1), () => Get.offAll(() => HomeNav()));
    } else {
      Timer(Duration(seconds: 1),
          () => Get.offAll(() => FirstUserRegisterPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    if (count == 0) {
      fetch();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                sendFCMMessage();
                print("Tap");
              },
              child: Container(
                height: size.height * .4,
                width: size.width * .8,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("assets/icons/dream.png"),
                        fit: BoxFit.contain),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Powered by Mak B',
                  textStyle: Theme.of(context).textTheme.titleSmall,
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 20,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "deub-e-commerce-ee9bb",
      "private_key_id": "0a68e9881e7555cb243791689442bc2dd1615b98",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC/QbIbm8w4hB49\nbWL1bZzais8ENMZMpL+JR3PR0My5tqlJaVKNlu5sUTi0sULbsc1KZ02GT/6tgmWh\nFrre8uRoRtbGlvaCpKx0hzhyrxdHcVuBbIdDYWJ/O4DVtRE97thGrQR92PJcKWoM\n3vWCrOxZ3Wn/229K2k0DyF4zQzWE7MMT3ci5Y3WaI3yIVVD+p/Vi1zMUCmqoV0w5\n4f+reHOnKHd29BrVq68og6+YYD2+liCLRwFi4kiCj9jTz24usTjUlySImyQ2S8Vf\npG5pekPgS9S4FazdQU4driN9x93uJh0rBs/jJip2zG1NSyymuzdJWApZYeCf5JQQ\ngAqWZrR5AgMBAAECggEACkS+CfrEwt61EO89OkLMV8okG0G0yTX/N/ZSIu28UCxH\nzTKOcB5ZEWUQT63vZ67q1W0pHbulx4MSGc1dSHhvXaSQBibiIq7cuNTvFEPk/Wek\nq2o8SO3YRU8t4kt6cCzRXS9k56zXi63djRtbayIFqT2DYhf8qF7YIQqHpDueNVNj\nzqJPjey9muWnObFM/q9dTM4DPe3IXAdmZJgfWkRsM77JWj7kPISgbgu2jbnmWzwF\n46L40tyiPb5IL3JN0WIMdFymaB3cHtj83qCx+BV5Yn6FlVFWKzvWVR8gLFlFfJk0\nt4U4iVVB4Ar6TFnaWxIcwklFj1P33KgZBK289yC7EQKBgQDmBnZba/UFtm9+5V4+\nUPl2Wed7woemMMPYWhnoG2Pfc8OKX+wh9GqNHOMY/CINyp1EO6kPN0/v9v/HagGE\nItXP1Ajid/c11UPK+Y1gGiEDAdL4AaYmpnv9jTl75m+osJ4GERZrXa2FYtZxhIVO\nOpyRhRdAmDNulGQ0q5ezokpInwKBgQDU2oP7TYHGiuYuxPnid592GRbnPmxKG2/3\nUXvyI3MT2VlNcHQNANDT25lE7FZV/ng+zBxP144YJ2n/iQ2nCaK4wpXRMNO884b6\n6WuBTYvIrityBGkP6+4KW9590dTTILgDQljEeA0GeY/DLmy3jXS0YrX7q1c/Q915\nVd1zzGiz5wKBgDpqG7Z9xPyNZuUf1H4YzDEtBacdMJuYuLOBtiCGjCdb26WRVIMO\n8dwiIN3gcbl04dlJGVa+4jL7U9tNZVMsEYY0v4jblFD8drneA/QKzqVX2j6XFJ2u\nG8C5E4cObv6003yQ7FOZt44vGmw7jireoZIm7U+/FxiW4Jerl9vLc/fbAoGADc2l\n5XQfSFrVlo7bjZ4oTyZNX+2iZCPnXOiB2zAFVHIx4l26iOVWpYaGJ/wTlTwNXDUs\nWNkns9VKgHHI2t47GTQ1Nv2tnYFFbZwZhqcau4bf9mLm1Ut9glp20T38STzD8iIp\nU4Rdg9/6PLQUBMs9mD0WhB2WaNnj0OyKkendmF0CgYAaSpp6CrU73eboQu6Xlhlu\n2rGn2NYVo9bDIru8aAvxKakbF46tOD2hVgJwa2BwDkGGnKh9eiC6BTCTrbZOfZic\nrNeQlt70ERI1Ymyr8xoUNhpgom1PmEybdhEjLfqJ2/qjW/wV3fXG+FJEoDgQn7+i\nR/VgotrzzLDiZthsew5itg==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-9p3ra@deub-e-commerce-ee9bb.iam.gserviceaccount.com",
      "client_id": "103596619093984860901",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9p3ra%40deub-e-commerce-ee9bb.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }

  Future<void> sendFCMMessage() async {
    final String serverKey = await getAccessToken(); // Your FCM server key
    await Clipboard.setData(ClipboardData(text: serverKey));
    log("Authorization:$serverKey");
    const String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/dream-app-f6265/messages:send';
    final currentFCMToken = await FirebaseMessaging.instance.getToken();
    print("fcmkey : $currentFCMToken");
    final Map<String, dynamic> message = {
      'message': {
        'token':
            currentFCMToken, // Token of the device you want to send the message to
        'notification': {
          'body': 'This is an FCM notification message!',
          'title': 'FCM Message'
        },
        'data': {
          'current_user_fcm_token':
              currentFCMToken, // Include the current user's FCM token in data payload
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
