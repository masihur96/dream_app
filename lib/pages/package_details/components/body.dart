import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/models/package_model.dart';
import 'package:dream_app/pages/login_page.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../package_payment_page.dart';
import 'product_images.dart';
import 'top_rounded_container.dart';

class Body extends StatefulWidget {
  final PackageModel product;
  final bool sold;

  const Body({required this.product, required this.sold});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductController productController = Get.find<ProductController>();
  final UserController userController = Get.find<UserController>();
  List selectedColor = [];
  List selectedSize = [];
  String? _size;
  int indx = 0;
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
    if (productController.productIdList.contains(widget.product.id)) {
      setState(() {
        exist = true;
      });
    }
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
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * .065),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(context, 20),
                      right: getProportionateScreenWidth(context, 64),
                    ),
                    child: Text(
                      widget.product.description!,
                      maxLines: 3,
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
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(context, 20)),
                    child: Row(
                      children: [
                        Text(
                          'Discount: ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "${widget.product.discountAmount}%",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(context, 20)),
                    child: Row(
                      children: [
                        Text(
                          'Quantity: ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "${widget.product.quantity}",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(context, 20)),
                    child: Row(
                      children: [
                        Text(
                          'Size:  ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Container(
                          width: size.width * .7,
                          height: size.height * .04,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.product.size!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // if(selectedSize.contains(index)){
                                  //   setState(() {
                                  //     selectedSize.remove(index);
                                  //   });
                                  //
                                  // }else {
                                  //   setState(() {
                                  //     selectedSize.add(index);
                                  //   });
                                  // }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      widget.product.size![index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(context, 20)),
                    child: Row(
                      children: [
                        Text(
                          'Color: ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Container(
                          width: size.width * .7,
                          height: size.height * .04,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.product.colors!.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                    // onTap: (){
                                    //
                                    //   if(selectedColor.contains(index)){
                                    //     setState(() {
                                    //       selectedColor.remove(index);
                                    //     });
                                    //
                                    //   }else {
                                    //     setState(() {
                                    //       selectedColor.add(index);
                                    //     });
                                    //
                                    //
                                    //   }
                                    //
                                    // },
                                    child:
                                        // selectedColor.contains(index)? Icon(Icons.circle_outlined,color: Colors.pink,)
                                        //     :
                                        Icon(Icons.circle_outlined,
                                            color: Color(int.parse(widget
                                                .product.colors![index]))));
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  widget.sold == false
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(
                                        context, 20)),
                                child: Text(
                                  widget.product.status!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                )),
                          ],
                        ),
                  SizedBox(height: 5),
                ],
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: widget.sold == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: getProportionateScreenWidth(context, 15),
                              top: getProportionateScreenWidth(context, 10),
                            ),
                            child: GradientButton(
                                child: Text(
                                  'Add to MyStore',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  id == null
                                      ? Get.to(() => LoginPage())
                                      : userController.addStoreProduct(
                                          widget.product.id!,
                                          widget.product.title!,
                                          widget.product.price!,
                                          widget.product.image!,
                                          widget.product.colors!,
                                          widget.product.size!,
                                          widget.product.description!,
                                          widget.product.thumbNail!,
                                          widget.product.discountAmount!,
                                          widget.product.quantity!);
                                  // _paySSLCommerz(userController);
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
                      )
                    : widget.product.status == 'stored'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      getProportionateScreenWidth(context, 15),
                                  top: getProportionateScreenWidth(context, 10),
                                ),
                                child: GradientButton(
                                    child: Text(
                                      'Collect Package',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Get.to(() => PackagePaymentPage(
                                          widget.product.documentId,
                                          widget.product.id,
                                          widget.product.title!,
                                          widget.product.price!,
                                          widget.product.discountAmount,
                                          widget.product.quantity,
                                          widget.product.size!,
                                          widget.product.colors!,
                                          widget.product.image!,
                                          widget.product.thumbNail));
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
                          )
                        : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
