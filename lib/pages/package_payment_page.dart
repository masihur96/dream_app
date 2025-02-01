import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/models/area_hub_model.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagePaymentPage extends StatefulWidget {
  String? id;
  String? packageId;
  String? packageName;
  String? packagePrice;
  String? discount, quantity, thumbnail;
  List<dynamic> size;
  List<dynamic> color;
  List<dynamic> images;

  PackagePaymentPage(
      this.id,
      this.packageId,
      this.packageName,
      this.packagePrice,
      this.discount,
      this.quantity,
      this.size,
      this.color,
      this.images,
      this.thumbnail);

  @override
  _PackagePaymentPageState createState() => _PackagePaymentPageState();
}

class _PackagePaymentPageState extends State<PackagePaymentPage> {
  final ProductController productController = Get.find<ProductController>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  int count = 0;
  String? districtsValue;
  String? hubValue;
  List<AreaHubModel> _list = [];
  List<AreaHubModel> _hubList = [];
  String? id;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
    });
  }

  Future<void> operate() async {
    districtsValue = productController.areaList[0].id;
    print("districtsValue: $districtsValue");
    print("districtsValue: ${productController.areaHubList}");
    hubValue = productController.areaHubList[0].hub[0];
    _list = productController.areaList;
    _hubList = productController.areaHubList;
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (count == 0) {
      operate();
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text(
              'Package Collection',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )),
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'collection details',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(0xFF19B52B),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userController.userModel.value.name!,
                                  style:
                                      Theme.of(context).textTheme.titleSmall!),
                              SizedBox(height: 5),
                              Text(userController.userModel.value.phone!,
                                  style:
                                      Theme.of(context).textTheme.titleSmall!),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Package Name: ${widget.packageName}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Package Quantity:  ${widget.quantity}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Discount:  ${widget.discount}\৳',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 15, bottom: 10),
                    child: Text(
                      'Select Hub',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(0xFF19B52B),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Division: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: districtsValue,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items: _list.map((items) {
                                        return DropdownMenuItem(
                                            value: items.id,
                                            child: Text(items.id!));
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await productController
                                            .getAreaHub(newValue.toString());
                                        setState(() {
                                          districtsValue = newValue.toString();
                                          _hubList =
                                              productController.areaHubList;
                                          hubValue = productController
                                              .areaHubList[0].hub[0];
                                          _isLoading = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : _hubList.isEmpty
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            Text('HUB: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!),
                                            DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                value: hubValue,
                                                icon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: _hubList[0]
                                                    .hub!
                                                    .map((items) {
                                                  return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items));
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    hubValue =
                                                        newValue.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 15, bottom: 10),
                    child: Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(0xFF19B52B),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Card(
                      shadowColor: Colors.grey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${widget.packagePrice}\৳',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                GradientButton(
                    child: Text('Collect',
                        style: Theme.of(context).textTheme.titleLarge!),
                    onPressed: () async {
                      await userController.requestForPackageCollection(
                          widget.id!,
                          widget.packageId!,
                          widget.packageName!,
                          widget.packagePrice,
                          widget.images,
                          widget.color,
                          widget.size,
                          widget.discount!,
                          widget.thumbnail!,
                          widget.quantity!);
                    },
                    borderRadius: 10,
                    height: size.width * .1,
                    width: size.width * .5,
                    gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
