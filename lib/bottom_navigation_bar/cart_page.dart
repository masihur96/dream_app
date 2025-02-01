import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/pages/login_page.dart';
import 'package:dream_app/pages/payment_page.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_nav.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ProductController productController = Get.find<ProductController>();
  final UserController userController = Get.find<UserController>();
  int count = 0;
  String? id;

  @override
  void initState() {
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;

      print("ID: $id");
      //pass = preferences.get('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      userController.cartList.isEmpty ? userController.getUserCart() : null;
    } else {
      productController.cartList.isEmpty ? productController.getCart() : null;
    }

    print(
        " productController.cartList.length   ${productController.cartList.length}");

    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Obx(() => Scaffold(
          appBar: AppBar(
            title: id == null
                ? Column(
                    children: [
                      Text(
                        "Your Cart",
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                      productController.cartList == null
                          ? Text(
                              "0 items",
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          : Text(
                              "${productController.cartList.length} items",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        "Your Cart",
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                      userController.cartList == null
                          ? Text(
                              "0 items",
                              style: Theme.of(context).textTheme.titleSmall!,
                            )
                          : Text(
                              "${userController.cartList.length} items",
                              style: Theme.of(context).textTheme.titleSmall!,
                            ),
                    ],
                  ),
          ),
          body: id == null
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(context, 20)),
                  child: productController.cartList.length != 0
                      ? ListView.builder(
                          itemCount: productController.cartList == null
                              ? 0
                              : productController.cartList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                  key: Key(productController.cartList[index].id
                                      .toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      productController.cartList
                                          .removeAt(index);
                                    });
                                  },
                                  background: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFE6E6),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Icon(
                                          FontAwesomeIcons.textSlash,
                                          size: 10,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    //Color(0xFF19B52B).withOpacity(0.1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: productController
                                                  .cartList[index].thumbnail!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: size.width * .25,
                                                height: size.width * .2,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey.shade200,
                                                      radius: size.width * .08,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/placeholder.png')),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                            // Image.network(
                                            //   productController.cartList[index].productImage!,
                                            //   width: 80,
                                            // ),
                                            ),
                                        Expanded(
                                            child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 14),
                                                child: Text(
                                                  productController
                                                      .cartList[index]
                                                      .productName!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color: Colors.black),
                                                )),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 14),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (productController
                                                              .cartList[index]
                                                              .quantity !=
                                                          1) {
                                                        int qnty =
                                                            productController
                                                                    .cartList[
                                                                        index]
                                                                    .quantity! -
                                                                1;
                                                        productController
                                                            .updateCart(
                                                                productController
                                                                    .cartList[
                                                                        index]
                                                                    .productId!,
                                                                qnty);
                                                        setState(() {
                                                          productController
                                                              .total = productController
                                                                  .total -
                                                              int.parse(
                                                                  productController
                                                                      .cartList[
                                                                          index]
                                                                      .price!);
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      FontAwesomeIcons.minus,
                                                      size: 20,
                                                      color: Colors.black,
                                                      // color: Colors.black
                                                      //     .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${productController.cartList[index].quantity}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      int qnty =
                                                          productController
                                                                  .cartList[
                                                                      index]
                                                                  .quantity! +
                                                              1;
                                                      productController
                                                          .updateCart(
                                                              productController
                                                                  .cartList[
                                                                      index]
                                                                  .productId!,
                                                              qnty);
                                                      setState(() {
                                                        productController
                                                            .total = productController
                                                                .total +
                                                            int.parse(
                                                                productController
                                                                    .cartList[
                                                                        index]
                                                                    .price!);
                                                      });
                                                    },
                                                    child: Icon(
                                                      FontAwesomeIcons.plus,
                                                      size: 20,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Text(
                                            "\৳${productController.cartList[index].price}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              _showProductDialog(index);
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.trash,
                                              size: 20,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          })
                      : Center(
                          child: Lottie.asset(
                              'assets/images/empty_place_holder.json')),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(context, 20)),
                  child: userController.cartList.length != 0
                      ? ListView.builder(
                          itemCount: userController.cartList == null
                              ? 0
                              : userController.cartList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                  key: Key(userController.cartList[index].id
                                      .toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      userController.cartList.removeAt(index);
                                    });
                                  },
                                  background: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Icon(
                                          FontAwesomeIcons.textSlash,
                                          size: 10,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: userController
                                                  .cartList[index].thumbnail!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: size.width * .25,
                                                height: size.width * .2,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey.shade200,
                                                      radius: size.width * .08,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/placeholder.png')),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                            // Image.network(
                                            //   productController.cartList[index].productImage!,
                                            //   width: 80,
                                            // ),
                                            ),
                                        Expanded(
                                            child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              userController
                                                  .cartList[index].productName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 14),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (userController
                                                              .cartList[index]
                                                              .quantity !=
                                                          1) {
                                                        int qnty =
                                                            userController
                                                                    .cartList[
                                                                        index]
                                                                    .quantity! -
                                                                1;
                                                        userController
                                                            .updateUserCart(
                                                                userController
                                                                    .cartList[
                                                                        index]
                                                                    .productId!,
                                                                qnty);
                                                        setState(() {
                                                          userController
                                                              .total = userController
                                                                  .total -
                                                              int.parse(
                                                                  userController
                                                                      .cartList[
                                                                          index]
                                                                      .price!);
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      FontAwesomeIcons.minus,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${userController.cartList[index].quantity}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      int qnty = userController
                                                              .cartList[index]
                                                              .quantity! +
                                                          1;
                                                      userController
                                                          .updateUserCart(
                                                              userController
                                                                  .cartList[
                                                                      index]
                                                                  .productId!,
                                                              qnty);
                                                      setState(() {
                                                        userController
                                                            .total = userController
                                                                .total +
                                                            int.parse(
                                                                userController
                                                                    .cartList[
                                                                        index]
                                                                    .price!);
                                                      });
                                                    },
                                                    child: Icon(
                                                      FontAwesomeIcons.plus,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Text(
                                            "\৳${userController.cartList[index].price}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              _showUserDialog(index);
                                            },
                                            child: Icon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          })
                      : Center(
                          child: Lottie.asset(
                              'assets/images/empty_place_holder.json')),
                ),
          bottomNavigationBar: Obx(() => Container(
                padding: EdgeInsets.symmetric(
                  //vertical: getProportionateScreenWidth(context,15),
                  horizontal: getProportionateScreenWidth(context, 30),
                ),
                height: size.height * .11,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -15),
                      blurRadius: 20,
                      color: Color(0xFFDADADA).withOpacity(0.15),
                    )
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: getProportionateScreenHeight(context, 20)),
                      id == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Total:\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: '\৳${productController.total}',
                                      ),
                                    ],
                                  ),
                                ),
                                productController.cartList.length != 0
                                    ? GradientButton(
                                        child: Text(
                                          'Buy Now',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          id == null
                                              ? Get.to(() => LoginPage())
                                              : Get.to(() => PaymentPage(
                                                  '',
                                                  userController
                                                      .userModel.value.name,
                                                  userController
                                                      .userModel.value.phone,
                                                  '',
                                                  '',
                                                  '',
                                                  ''));
                                        },
                                        borderRadius: 5.0,
                                        height: size.width * .1,
                                        width: size.width * .25,
                                        gradientColors: [
                                            Color(0xFF0198DD),
                                            Color(0xFF19B52B)
                                          ])
                                    : Container()
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Total:\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: '\৳${userController.total}',
                                      ),
                                    ],
                                  ),
                                ),
                                userController.cartList.length != 0
                                    ? GradientButton(
                                        child: Text(
                                          'Buy Now',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          id == null
                                              ? Get.to(() => LoginPage())
                                              : Get.to(() => PaymentPage(
                                                  '',
                                                  userController
                                                      .userModel.value.name,
                                                  userController
                                                      .userModel.value.phone,
                                                  '',
                                                  '',
                                                  '',
                                                  ''));
                                        },
                                        borderRadius: 5.0,
                                        height: size.width * .1,
                                        width: size.width * .25,
                                        gradientColors: [
                                            Color(0xFF0198DD),
                                            Color(0xFF19B52B)
                                          ])
                                    : Container()
                              ],
                            ),
                    ],
                  ),
                ),
              )))),
    );
  }

  _showUserDialog(int index) {
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
                    'Do you really want to remove this item?',
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          userController.deleteUserCartItem(
                              userController.cartList[index].productId!);
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

  _showProductDialog(int index) {
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
                    'Do you really want to remove this item?',
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          productController.deleteCartItem(
                              productController.cartList[index].productId!);
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

  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
