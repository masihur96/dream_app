import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/package_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';

import '../home_nav.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({Key? key}) : super(key: key);

  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Obx(() => Scaffold(
              appBar: AppBar(
                title: Text(
                  "All Packages",
                ),
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await productController.getPackage();
                    print('Refresh');
                  },
                  child: ListView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      SizedBox(
                          height: getProportionateScreenWidth(context, 10)),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.width * .02,
                            left: size.width * .02,
                            right: size.width * .02,
                            bottom: size.width * .02),
                        child: Text('Regular Package',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      productController.packageList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 48.0),
                              child: Lottie.asset(
                                  'assets/images/empty_place_holder.json'),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: new ClampingScrollPhysics(),
                                itemCount: productController.packageList.length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 2,
                                        childAspectRatio: 5 / 9),
                                itemBuilder: (BuildContext context, int index) {
                                  // if (demoProducts[index].isPopular)
                                  return PackageCard(
                                    product:
                                        productController.packageList[index],
                                    sold: false,
                                  );
                                  // return SizedBox
                                  //     .shrink(); // here by default width and height is 0
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
