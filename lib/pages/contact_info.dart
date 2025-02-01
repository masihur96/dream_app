import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: size.height * .08,
        title: Text(
          'Contact Info',
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: userController.infoList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      '${userController.infoList[0].email}',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Phone No:',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      '${userController.infoList[0].phone}',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Address: ',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      '${userController.infoList[0].address}',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              String url =
                                  '${userController.infoList[0].fbLink}';
                              _launchURL(url);
                            },
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                            )),
                        InkWell(
                            onTap: () {
                              _launchURL(
                                  '${userController.infoList[0].instagram}');
                            },
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.redAccent,
                            )),
                        InkWell(
                            onTap: () {
                              _launchURL(
                                  '${userController.infoList[0].linkedIn}');
                            },
                            child: Icon(
                              FontAwesomeIcons.linkedin,
                              color: Colors.blue,
                            )),
                        InkWell(
                            onTap: () {
                              _launchURL(
                                  '${userController.infoList[0].twitterLink}');
                            },
                            child: Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.lightBlue,
                            )),
                        InkWell(
                            onTap: () {
                              _launchURL(
                                  '${userController.infoList[0].youtubeLink}');
                            },
                            child: Icon(
                              FontAwesomeIcons.youtube,
                              color: Colors.red,
                            )),
                      ],
                    )
                  ],
                ),
              )
            : Center(
                child: Text(
                "Yo Have No Contact Info Yet",
                style: Theme.of(context).textTheme.titleSmall,
              )),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
