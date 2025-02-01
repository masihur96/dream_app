import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/pages/payment_page.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/bounching_dialog.dart';
import 'package:dream_app/widgets/custom_size.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final ProductController productController = Get.find<ProductController>();

  String _name = "";
  String _address = "";
  String _country = "";
  String _distric = "";
  String _subDistric = "";
  String _post = "";
  String _area = "";
  String _road = "";
  String _house = "";
  String _phone = "";
  String _password = "";
  String _nbp = "";
  String _referCode = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register'),
        toolbarHeight: AppBar().preferredSize.height,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(getProportionateScreenWidth(context,5)),
              height: getProportionateScreenWidth(context, 120),
              width: getProportionateScreenWidth(context, 120),
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/deub.png"),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name(Same as Nid/BC/Passport)",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a user name';
                              }
                              return null; // Return null if the input is valid.
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => BounchingDialog(
                                  padding: screenSize(context, 0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Address Must be correct",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: screenSize(context, 1.4),
                                          child: SingleChildScrollView(
                                            child: Form(
                                              key: _addressFormKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .06),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Country",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return ' This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _country = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "District",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return ' This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _distric = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Sub-District",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return ' This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _subDistric = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Post",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _post = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Area",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _area = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Road Number",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _road = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    height: screenSize(
                                                        context, .03),
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "House or Holding Number",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'This field is Required !';
                                                      }
                                                      return null; // Return null if the input is valid.
                                                    },
                                                    onSaved: (value) {
                                                      _house = value!;
                                                    },
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenSize(context, .1),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: screenSize(context, 0.02),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Colors.red),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                if (_addressFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  _addressFormKey.currentState!
                                                      .save();

                                                  setState(() {
                                                    _address =
                                                        "$_house $_road $_area $_post $_subDistric $_distric $_country";
                                                  });

                                                  Navigator.pop(context);
                                                  print("object");
                                                }
                                              },
                                              child: Text(
                                                "Ok",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: TextFormField(
                                enabled: false,
                                controller:
                                    TextEditingController(text: _address),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Address",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Address';
                                  }
                                  return null; // Return null if the input is valid.
                                },
                                onSaved: (value) {
                                  _address = value!;
                                },
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone number",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Phone Number';
                              } else if (!RegExp(r'^[0-9]{11}$')
                                  .hasMatch(value)) {
                                return 'Please Entered a valid Phone Number';
                              }
                              return null; // Return null if the input is valid.
                            },
                            onSaved: (value) {
                              _phone = value!;
                            },
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Phone Number';
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?`\-=[\]\\;\./]).{6,}$')
                                  .hasMatch(value)) {
                                return 'Uppercase, lowercase, digit, special, 6+ characters';
                              }
                              return null; // Return null if the input is valid.
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nid/BirthCertificate/Passport",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Valid NID';
                              }
                              return null; // Return null if the input is valid.
                            },
                            onSaved: (value) {
                              _nbp = value!;
                            },
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Refer Code",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Refer Code';
                              } else if (!RegExp(r'^MakB.{6}$')
                                  .hasMatch(value)) {
                                return 'Please Entered valid Refer Code';
                              }
                              return null; // Return null if the input is valid.
                            },
                            onSaved: (value) {
                              _referCode = value!;
                            },
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GradientButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            showLoadingDialog(Get.context!);
                            var newString = nanoid(6);

                            String myReferCode = 'MakB$newString';
                            print(myReferCode);
                            bool isReg =
                                await authController.isRegistered(_phone);
                            if (!isReg) {
                              if (productController.cartList.length != 0) {
                                await userController
                                    .getReferUser(_referCode)
                                    .then((value) {
                                  if (userController.referredList.length !=
                                      int.parse(userController
                                          .referUserModel.value.referLimit!)) {
                                    if (userController
                                        .isReferCodeCorrect.value) {
                                      Get.back();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PaymentPage(
                                                  _referCode,
                                                  _name,
                                                  _phone,
                                                  _address,
                                                  _password,
                                                  _nbp,
                                                  myReferCode)));
                                    }
                                    // authController.createUser(
                                    //   _name,
                                    //   _address,
                                    //   _phone,
                                    //   _password,
                                    //   _nbp,
                                    //   _referCode,
                                    // );
                                  } else {
                                    Get.back();
                                    showToast(
                                        'Refer limit is over for this referCode!');
                                  }
                                });
                              } else {
                                Get.back();
                                showToast(
                                    'Registration cannot be done with empty cart!');
                              }
                            } else {
                              Get.back();
                              showToast('Phone Number already exist');
                            }
                          }
                        },
                        borderRadius: 5.0,
                        height: size.width * .12,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
