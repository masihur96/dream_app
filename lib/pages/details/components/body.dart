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
          //_themeController.isDarkMode.value ? Colors.black : Colors.white,
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(context, 20)),
                        child: Text(
                          'Price: ' + '\৳${widget.product.price}',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * .045),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Text(
                      //   "\৳${widget.product.price}",
                      //   style: TextStyle(
                      //     decoration: TextDecoration.lineThrough,
                      //     fontSize: size.width*.036,
                      //     fontWeight: FontWeight.w300,
                      //     color: Colors.grey[600],
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 5),

                  ///product size, color
                  Row(
                    children: [
                      widget.product.size!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenWidth(context, 20)),
                              child: Container(
                                width: size.width * .25,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: size.height * .01),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kPrimaryColor, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    isExpanded: true,
                                    value: _size,
                                    hint: Text(
                                      'Size',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    items: widget.product.size!.map((sizes) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          sizes,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        value: sizes.toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        _size = newVal as String;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.product.colors!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenWidth(context, 20)),
                              child: Row(
                                children: [
                                  Text(
                                    'Color: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Container(
                                    width: size.width * .4,
                                    height: size.height * .05,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.product.colors!.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  indx = index;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: kPrimaryColor),
                                                    color: index == indx
                                                        ? Colors.green
                                                            .withOpacity(0.5)
                                                        : Colors.white,
                                                    shape: BoxShape.rectangle),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        color: widget.product
                                                                .colors!.isEmpty
                                                            ? Colors.white70
                                                            : Color(int.parse(
                                                                widget.product
                                                                        .colors![
                                                                    index])),
                                                        shape:
                                                            BoxShape.rectangle),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 5),

                  Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(context, 20),
                      right: getProportionateScreenWidth(context, 64),
                    ),
                    child: Text(
                      widget.product.description!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context, 15),
                        top: getProportionateScreenWidth(context, 15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Add To Cart',
                            style: TextStyle(color: Colors.white),
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
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [
                            Color(0xFF0198DD),
                            Color(0xFF19B52B)
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context, 15),
                        top: getProportionateScreenWidth(context, 15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
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
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [
                            Color(0xFF0198DD),
                            Color(0xFF19B52B)
                          ]),
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
