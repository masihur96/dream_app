import 'package:aamarpay/aamarpay.dart';
import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/models/area_hub_model.dart';
import 'package:dream_app/widgets/custom_size.dart';
import 'package:dream_app/widgets/form_decoration.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_nav.dart';

class PaymentPage extends StatefulWidget {
  String? referenceCode;
  //String? referMobileNo;
  String? customerName;
  String? customerPhone;
  String? address;
  String? password;
  String? nbp;
  String? myReferCode;
  //String? insuranceEndingDate;

  PaymentPage(this.referenceCode, this.customerName, this.customerPhone,
      this.address, this.password, this.nbp, this.myReferCode);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ProductController productController = Get.find<ProductController>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  dynamic userProfitAmount;
  dynamic referUserProfitAmount;
  dynamic referBalance;
  int count = 0;
  String? referredBy;
  String? districtsValue;
  String? selectedPaymentSystem = "Aamar Pay";
  String? hubValue;
  List<AreaHubModel> _list = [];
  List<AreaHubModel> _hubList = [];
  List cartItemList = [];
  bool _isLoading = false;

  var tempList = [];
  TextEditingController _nameTextFieldController = TextEditingController();
  TextEditingController _addressFieldController = TextEditingController();
  TextEditingController _phoneFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();

  var _key = GlobalKey<FormState>();
  dynamic formData = {};
  void getData() {
    for (int i = 0; i < productController.cartList.length; i++) {
      cartItemList.add({
        "productId": productController.cartList[i].productId,
        "productName": productController.cartList[i].productName,
        "quantity": productController.cartList[i].quantity,
        "productImage": productController.cartList[i].productImage,
        "price": productController.cartList[i].price,
        "color": productController.cartList[i].color,
        "size": productController.cartList[i].size,
        "profitAmount": productController.cartList[i].profitAmount
      });
    }
    print(cartItemList[0]['productName']);
  }

  void getUserData() {
    for (int i = 0; i < userController.cartList.length; i++) {
      cartItemList.add({
        "productId": userController.cartList[i].productId,
        "productName": userController.cartList[i].productName,
        "quantity": userController.cartList[i].quantity,
        "productImage": userController.cartList[i].productImage,
        "price": userController.cartList[i].price,
        "color": userController.cartList[i].color,
        "size": userController.cartList[i].size,
        "profitAmount": userController.cartList[i].profitAmount
      });
    }
    print(cartItemList[0]['productName']);
  }

  String? id;
  @override
  void initState() {
    super.initState();
    _checkPreferences();
  }

  Future<void> _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
      print("id: $id");
    });
  }

  Future<void> operate() async {
    districtsValue = productController.areaList[0].id;
    print("districtsValue: $districtsValue");
    // print("hubValue: ${productController.areaHubList[0]}");
    referredBy = widget.referenceCode == '' ? 'None' : widget.referenceCode;

    ;
    print("GGGGGG: ${productController.totalProfitAmount}");
    print(
        "GGGGGG: ${int.parse('${productController.totalProfitAmount}') * .3}");

    setState(() {
      userProfitAmount = (id == null
              ? productController.totalProfitAmount
              : userController.totalProfitAmount) *
          0.3;
    });
    print("GGGGGG: $userProfitAmount");
    _list = productController.areaList;
    print("_list: $_list");
    await productController.getAreaHub(_list.first.id!);
    _hubList = productController.areaHubList;
    print("_hubList: $_hubList");
    setState(() {
      hubValue = productController.areaHubList[0].hub[0];
    });

    await _checkPreferences();

    count++;
    print(id);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(id);
    if (count == 0) {
      operate();

      count++;
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text(
              'Payment',
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
                      'Buying details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.customerName == null
                              ? SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.customerName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      widget.customerPhone!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Referred By:  $referredBy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
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
                              id == null
                                  ? Text(
                                      'Total Items: ${productController.cartList.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  : Text(
                                      'Total Items: ${userController.cartList.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'My Profit:  $userProfitAmount\৳',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Card(
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
                                  Text(
                                    'Division: ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: districtsValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      dropdownColor: Colors.grey,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: _list.map((items) {
                                        return DropdownMenuItem(
                                            value: items.id,
                                            child: Text(
                                              items.id!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ));
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
                                  : Row(
                                      children: [
                                        Text(
                                          'HUB: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        DropdownButtonHideUnderline(
                                          child: _hubList.isEmpty
                                              ? SizedBox()
                                              : DropdownButton(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  dropdownColor: Colors.grey,
                                                  value: hubValue,
                                                  icon: Icon(Icons
                                                      .keyboard_arrow_down),
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
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment System: ',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: selectedPaymentSystem,
                              style: Theme.of(context).textTheme.titleSmall,
                              dropdownColor: Colors.grey,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: ["Aamar Pay", "Cash on Delivery"]
                                  .map((items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ));
                              }).toList(),
                              onChanged: (newValue) async {
                                setState(() {
                                  selectedPaymentSystem = newValue.toString();
                                });
                              },
                            ),
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
                      style: Theme.of(context).textTheme.titleMedium,
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
                      child: Column(
                        children: [
                          // Padding(
                          //   padding:
                          //   const EdgeInsets.only(left: 10, top: 10, right: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Total Product',
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontStyle: FontStyle.normal,
                          //               fontSize: size.width * .04)),
                          //       Row(
                          //         children: [
                          //
                          //           Text('20',
                          //               style: TextStyle(
                          //
                          //                   color: Colors.black,
                          //                   fontStyle: FontStyle.normal,
                          //                   fontSize: size.width * .04)),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   //child:
                          //   // Row(
                          //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   //   children: [
                          //   //     Text('Per Product',
                          //   //         style: TextStyle(
                          //   //
                          //   //             color: Colors.black,
                          //   //             fontStyle: FontStyle.normal,
                          //   //             fontSize: size.width * .04)),
                          //   //     Row(
                          //   //       children: [
                          //   //         Icon(Icons.attach_money_outlined),
                          //   //         Text('79.95',
                          //   //             style: TextStyle(
                          //   //
                          //   //                 color: Colors.black,
                          //   //                 fontStyle: FontStyle.normal,
                          //   //                 fontSize: size.width * .04)),
                          //   //       ],
                          //   //     ),
                          //   //   ],
                          //   // ),
                          // ),
                          // Divider(
                          //   height: 1,
                          //   color: Color(0xFF19B52B),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                id == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${productController.total}\৳',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${userController.total}\৳',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                selectedPaymentSystem == "Aamar Pay"
                    ? Aamarpay(
                        // This will return a payment url based on failUrl,cancelUrl,successUrl
                        returnUrl: (String url) {
                          print(url);
                        },
                        // This will return the payment loading status
                        isLoading: (bool loading) {
                          setState(() {
                            isLoading = loading;
                          });
                        },
                        // This will return the payment event with a message
                        status: (EventState event, String message) {
                          if (event == EventState.error) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        // When you use your own url, you must have the keywords:cancel,confirm,fail otherwise the callback function will not work properly
                        cancelUrl: "example.com/payment/cancel",
                        successUrl: "example.com/payment/confirm",
                        failUrl: "example.com/payment/fail",
                        customerEmail: "",
                        customerMobile: widget.customerPhone!,
                        customerName: widget.customerName,
                        // That is the test signature key. But when you go to the production you must use your own signature key
                        signature: "dbb74894e82415a2f7ff0ec3a97e4183",
                        // That is the test storeID. But when you go to the production you must use your own storeID
                        storeID: "aamarpaytest",
                        // Use transactionAmountFromTextField when you pass amount with TextEditingController
                        // transactionAmountFromTextField: amountTextEditingController,
                        transactionAmount: productController.total.toString(),
                        //The transactionID must be unique for every payment
                        transactionID:
                            "${DateTime.now().millisecondsSinceEpoch}",
                        //The transactionID must be unique for every payment

                        description: "MakB is a Wonderful product",
                        // When the application goes to the producation the isSandbox must be false
                        isSandBox: true,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: screenSize(context, .1),
                                width: screenSize(context, .5),
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: const Center(
                                  child: Text(
                                    "AamarPay",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                      )
                    : GradientButton(
                        onPressed: () async {
                          String unique =
                              '${DateTime.now().millisecondsSinceEpoch}';
                          if (id == null) {
                            showLoadingDialog(Get.context!);
                            String profit1 =
                                '${productController.totalProfitAmount}';
                            setState(() {
                              referUserProfitAmount = int.parse(profit1) * .2;
                              referBalance = double.parse(userController
                                      .referUserModel.value.mainBalance!) +
                                  referUserProfitAmount;
                            });
                            getData();
                            productController
                                .createOrder(
                                    widget.customerName!,
                                    widget.customerPhone!,
                                    unique,
                                    districtsValue!,
                                    hubValue!,
                                    '${productController.cartList.length}',
                                    '${productController.total}',
                                    cartItemList,
                                    userController)
                                .then((value) {
                              authController
                                  .createUser(
                                      widget.customerName!,
                                      widget.address!,
                                      widget.customerPhone!,
                                      widget.password!,
                                      widget.nbp!,
                                      widget.referenceCode!,
                                      '$userProfitAmount',
                                      widget.myReferCode!)
                                  .then((value) {
                                userController
                                    .updateReferUser(
                                        userController
                                            .referUserModel.value.phone!,
                                        '$referBalance')
                                    .then((value) {
                                  userController.addReferUserReferList(
                                      userController
                                          .referUserModel.value.phone!,
                                      widget.myReferCode!,
                                      widget.customerName!,
                                      '$referUserProfitAmount',
                                      widget.customerPhone!);
                                });
                              });
                            });
                          } else {
                            showLoadingDialog(Get.context!);
                            getUserData();
                            productController
                                .createOrder(
                                    widget.customerName!,
                                    widget.customerPhone!,
                                    unique,
                                    districtsValue == null
                                        ? ""
                                        : districtsValue!,
                                    hubValue == null ? "" : hubValue!,
                                    '${productController.cartList.length}',
                                    '${productController.total}',
                                    cartItemList,
                                    userController)
                                .then((value) async {
                              await userController
                                  .updateBalance('$userProfitAmount')
                                  .then((value) {
                                Get.back();
                                Get.back();
                                Get.to(() => HomeNav());
                                showToast('Order Placed');
                              });
                            });
                          }

                          //_paySSLCommerz();
                        },
                        borderRadius: 10,
                        height: size.width * .1,
                        width: size.width * .5,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)],
                        child: Text(
                          'Payment',
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Update Data',
              style: TextStyle(color: Color(0xFF19B52B)),
            ),
            content: Container(
              height: size.width * .8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameTextFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(
                      labelText: 'Name',
                      hintText: 'Mak-B',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextField(
                      controller: _addressFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Address',
                        hintText: 'House-16, Sonargaon, Dhaka',
                      ),
                    ),
                  ),
                  TextField(
                    controller: _phoneFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(
                      labelText: 'Phone',
                      hintText: '0147582369',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextField(
                      controller: _descriptionFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Description',
                        hintText: 'I Need this Product Urgently',
                      ),
                    ),
                  ),
                  GradientButton(
                      child: Text('Update'),
                      onPressed: () {},
                      borderRadius: 10,
                      height: size.width * .1,
                      width: size.width * .3,
                      gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)])
                ],
              ),
            ),
          );
        });
  }
}
