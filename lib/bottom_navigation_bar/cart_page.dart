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

    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Obx(() => Scaffold(
        backgroundColor: Colors.grey[50], // Light background for better contrast
          appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
                    children: [
                      Text(
                "Shopping Cart",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
                      Text(
                id == null 
                  ? "${productController.cartList.length} items"
                  : "${userController.cartList.length} items",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                ),
                            ),
                    ],
                  ),
          centerTitle: true,
          ),
          body: id == null
            ? _buildCartList(context, size, productController.cartList)
            : _buildCartList(context, size, userController.cartList),
        bottomNavigationBar: _buildBottomBar(context, size),
      )),
    );
  }

  Widget _buildCartList(BuildContext context, Size size, List cartList) {
    if (cartList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
            Lottie.asset(
              'assets/images/empty_place_holder.json',
              width: size.width * 0.7,
            ),
            SizedBox(height: 20),
            Text(
              "Your cart is empty",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Add items to start shopping",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
      );
    }

    return ListView.builder(
                  padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(context, 20),
        vertical: 15,
      ),
      itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
                              child: Dismissible(
              key: Key(cartList[index].id.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                  color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 28,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Container(
                padding: EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                        imageUrl: cartList[index].thumbnail!,
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.error_outline),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    // Product Details
                                        Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                            cartList[index].productName!,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "৳${cartList[index].price}",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Quantity Controls
                                            Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                                              child: Row(
                              mainAxisSize: MainAxisSize.min,
                                                children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onTap: () => _updateQuantity(index, false),
                                ),
                                SizedBox(
                                  width: 40,
                                                    child: Text(
                                    '${cartList[index].quantity}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onTap: () => _updateQuantity(index, true),
                                ),
                              ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                    ),
                  ],
                                            ),
                                          ),
                                        ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          icon,
          size: 18,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, Size size) {
    final total = id == null ? productController.total : userController.total;
    final hasItems = id == null 
        ? productController.cartList.isNotEmpty
        : userController.cartList.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
            offset: Offset(0, -4),
                      blurRadius: 20,
            color: Colors.black.withOpacity(0.05),
          ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "৳$total",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                                      ),
                                    ],
                                  ),
            SizedBox(height: 20),
            if (hasItems)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                                        onPressed: () {
                                          id == null
                                              ? Get.to(() => LoginPage())
                                              : Get.to(() => PaymentPage(
                                                  '',
                            userController.userModel.value.name,
                            userController.userModel.value.phone,
                                                  '',
                                                  '',
                                                  '',
                                                  ''));
                                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                            ),
                    ],
                  ),
                ),
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

  void _updateQuantity(int index, bool increase) {
    if (id == null) {
      // Handle quantity update for non-logged in users
      if (increase) {
        int qnty = productController.cartList[index].quantity! + 1;
        productController.updateCart(
          productController.cartList[index].productId!,
          qnty,
        );
        setState(() {
          productController.total = productController.total +
              int.parse(productController.cartList[index].price!);
        });
      } else {
        if (productController.cartList[index].quantity! > 1) {
          int qnty = productController.cartList[index].quantity! - 1;
          productController.updateCart(
            productController.cartList[index].productId!,
            qnty,
          );
          setState(() {
            productController.total = productController.total -
                int.parse(productController.cartList[index].price!);
          });
        }
      }
    } else {
      // Handle quantity update for logged in users
      if (increase) {
        int qnty = userController.cartList[index].quantity! + 1;
        userController.updateUserCart(
          userController.cartList[index].productId!,
          qnty,
        );
        setState(() {
          userController.total = userController.total +
              int.parse(userController.cartList[index].price!);
        });
      } else {
        if (userController.cartList[index].quantity! > 1) {
          int qnty = userController.cartList[index].quantity! - 1;
          userController.updateUserCart(
            userController.cartList[index].productId!,
            qnty,
          );
          setState(() {
            userController.total = userController.total -
                int.parse(userController.cartList[index].price!);
          });
        }
      }
    }
  }

  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
