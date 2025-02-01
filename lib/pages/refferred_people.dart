import 'package:dream_app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:lottie/lottie.dart';

class RefferredPeople extends StatefulWidget {
  const RefferredPeople({Key? key}) : super(key: key);

  @override
  _RefferredPeopleState createState() => _RefferredPeopleState();
}

class _RefferredPeopleState extends State<RefferredPeople> {
  final UserController userController = Get.find<UserController>();

  int counter = 0;
  customInit(UserController userController) {
    counter++;

    if (userController.id == null) {
      userController.checkPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (counter == 0) {
      customInit(userController);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Refferred People',
        ),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * .04),
      child: RefreshIndicator(
        onRefresh: () async {
          await userController.getReferUserReferList(userController.id!);
          print('Refresh');
        },
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
                width: size.width,
                child: Text(
                  'You reffered ${userController.referredList.length} people',
                  style: Theme.of(context).textTheme.titleMedium!,
                )),
            SizedBox(
              height: size.width * .04,
            ),
            userController.referredList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child:
                        Lottie.asset('assets/images/empty_place_holder.json'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: userController.referredList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.width * .02),
                        child: Card(
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundColor: Colors.grey.shade200,
                            //   backgroundImage: NetworkImage(
                            //       userController.referredList[index].),
                            // ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name:  ${userController.referredList[index].name!}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium!,
                                ),
                                Text(
                                  'Contact No:  ${userController.referredList[index].phone!}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                                Text(
                                  'ReferCode:  ${userController.referredList[index].referCode!}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profit:  ${userController.referredList[index].profit!}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                                Text(
                                  'Date:  ${userController.referredList[index].date!}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
