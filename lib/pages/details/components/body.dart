import 'package:dream_app/bottom_navigation_bar/cart_page.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/theme_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/models/product_model.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product_images.dart';
import 'top_rounded_container.dart';

class Body extends StatefulWidget {
  final ProductModel product;

  const Body({required this.product});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductController productController = Get.find<ProductController>();
  final UserController userController = Get.find<UserController>();
  String? _size;
  int indx = 0;
  int count = 0;
  String? id;
  bool exist = false;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ThemeController _themeController = Get.find<ThemeController>();
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(context, 20)),
                    child: Text(
                      widget.product.title!,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(context, 20),
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Price:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: size.width * 0.04,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '৳${widget.product.price}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.055,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(context, 20),
                    ),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product.size!.isNotEmpty) ...[
                          Text(
                            'Select Size',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _size,
                                hint: Text('Choose Size'),
                                items: widget.product.size!.map((sizes) {
                                  return DropdownMenuItem(
                                    child: Text(sizes),
                                    value: sizes.toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    _size = newVal as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                        if (widget.product.colors!.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Text(
                            'Available Colors',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: size.height * 0.06,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.colors!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      indx = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: indx == index 
                                            ? kPrimaryColor 
                                            : Colors.transparent,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.parse(widget.product.colors![index])
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(context, 20),
                    ),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.product.description!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(context, 20),
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -3),
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Add To Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (widget.product.size!.isNotEmpty &&
                              _size == null) {
                            showToast('Please select product size');
                          } else {
                            if (id == null) {
                              if (productController.productIdList
                                  .contains(widget.product.id)) {
                                setState(() {
                                  exist = true;
                                });
                                print('product $exist');
                              }
                            } else {
                              if (userController.productIds
                                  .contains(widget.product.id)) {
                                setState(() {
                                  exist = true;
                                });
                                print('user $exist');
                              }
                            }
                            if (exist == false) {
                              setState(() {
                                exist = true;
                              });
                              String? size =
                                  _size == null ? 'No Size' : _size;
                              String? color = widget.product.colors!.isEmpty
                                  ? 'No Color'
                                  : widget.product.colors![indx];
                              id == null
                                  ? productController.addToCart(
                                      widget.product.title!,
                                      widget.product.thumbNail!,
                                      widget.product.id!,
                                      widget.product.price!,
                                      1,
                                      color!,
                                      size!,
                                      widget.product.image![0],
                                      widget.product.profitAmount!)
                                  : userController.addToUserCart(
                                      widget.product.title!,
                                      widget.product.thumbNail!,
                                      widget.product.id!,
                                      widget.product.price!,
                                      1,
                                      color!,
                                      size!,
                                      widget.product.image![0],
                                      widget.product.profitAmount!);
                            } else {
                              showToast(
                                  'This product already exist in your cart');
                            }
                          }
                        },
                        borderRadius: 8.0,
                        height: size.width * 0.13,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)], width:  size.width * 0.5,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: GradientButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (widget.product.size!.isNotEmpty &&
                              _size == null) {
                            showToast('Please select product size');
                          } else {
                            if (id == null) {
                              if (productController.productIdList
                                  .contains(widget.product.id)) {
                                setState(() {
                                  exist = true;
                                });
                                print('product $exist');
                              }
                            } else {
                              if (userController.productIds
                                  .contains(widget.product.id)) {
                                setState(() {
                                  exist = true;
                                });
                                print('user $exist');
                              }
                            }
                            if (exist == false) {
                              setState(() {
                                exist = true;
                              });
                              String? size =
                                  _size == null ? 'No Size' : _size;
                              String? color = widget.product.colors!.isEmpty
                                  ? 'No Color'
                                  : widget.product.colors![indx];
                              id == null
                                  ? productController
                                      .addToCart(
                                          widget.product.title!,
                                          widget.product.thumbNail!,
                                          widget.product.id!,
                                          widget.product.price!,
                                          1,
                                          color!,
                                          size!,
                                          widget.product.image![0],
                                          widget.product.profitAmount!)
                                      .then((value) {
                                      Get.to(() => CartPage());
                                    })
                                  : userController
                                      .addToUserCart(
                                          widget.product.title!,
                                          widget.product.thumbNail!,
                                          widget.product.id!,
                                          widget.product.price!,
                                          1,
                                          color!,
                                          size!,
                                          widget.product.image![0],
                                          widget.product.profitAmount!)
                                      .then((value) {
                                      Get.to(() => CartPage());
                                    });
                            } else {
                              Get.to(() => CartPage());
                            }
                          }
                        },
                        borderRadius: 8.0,
                        height: size.width * 0.13,
                        gradientColors: [Color(0xFF19B52B), Color(0xFF0198DD)], width: size.width * 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
