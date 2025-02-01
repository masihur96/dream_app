import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/home_nav.dart';
import 'package:dream_app/models/advertisement_model.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertisementController extends GetxController {
  RxList<AdvertisementModel> videoList = <AdvertisementModel>[].obs;
  @override // called when you use Get.put before running app
  void onInit() async {
    super.onInit();
    await getVideo();
  }

  Future<void> getVideo() async {
    print('Initialize');
    try {
      await FirebaseFirestore.instance
          .collection('Advertisement')
          .get()
          .then((snapShot) async {
        videoList.clear();
        //  showLoadingDialog(Get.context!);
        snapShot.docChanges.forEach((element) {
          AdvertisementModel advertisementModel = AdvertisementModel(
            id: element.doc['id'],
            title: element.doc['title'],
            videoUrl: element.doc['videoUrl'],
            date: element.doc['date'],
          );
          videoList.add(advertisementModel);
        });
        //    Get.back();
        print('Video Length: ${videoList.length}');
      });
      update();
    } catch (error) {
      print('Error from Video:$error');
    }
  }

  String userMainBalance = '';
  String watchDate = '';
  String videoWatched = '';

  Future<void> getSingleUserData(String id) async {
    try {
      var document =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();

      // ignore: unnecessary_statements
      userMainBalance = document['mainBalance'];
      watchDate = document['watchDate'];
      videoWatched = document['videoWatched'];
      print('get Single User Name: $watchDate');
    } catch (error) {
      print('get Single User Name: $error');
    }
  }

  Future<void> updateAddAmount(
      UserController userController, int videoCount) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('Submit Data Into Firebase');
    //   print(currentDate);
    var id = preferences.get('id');

    print("ID: $id");
    print("videoCount: $videoCount");

    try {
      getSingleUserData(id.toString()).then((value) async {
        String currentDate =
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(id.toString())
            .update({
          "videoWatched": videoCount.toString(),
          "watchDate": currentDate,
          "mainBalance": '${double.parse(userMainBalance) + videoCount}',
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(id.toString())
              .collection('VideoHistory')
              .doc(currentDate)
              .set({
            "videoWatched": videoCount.toString(),
            "watchDate": currentDate,
          });
        }).then((value) async {
          await getSingleUserData(id.toString());
          await userController.getWatchedHistory();
          if (videoCount == 5) {
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * .030,
                          ),
                          Text(
                            'Congratulations!',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 30, color: kPrimaryColor),
                          ),
                          Text(
                            'You have watched 5 videos and limit is over for today.\n'
                            'Please wait for the next day.\nThank you!',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * .050,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences preference =
                                      await SharedPreferences.getInstance();
                                  String currentDate = '${DateTime.now().year}-'
                                      '${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-'
                                      '${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}';
                                  preference.setString(
                                      "advertisementDate", currentDate);
                                  Get.offAll(() => const HomeNav());
                                },
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
        });
      });
    } catch (err) {
      print(err);
    }
  }
}
