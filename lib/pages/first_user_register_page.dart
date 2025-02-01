import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';

class FirstUserRegisterPage extends StatefulWidget {
  @override
  _FirstUserRegisterPageState createState() => _FirstUserRegisterPageState();
}

class _FirstUserRegisterPageState extends State<FirstUserRegisterPage> {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final ProductController productController = Get.find<ProductController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = "";
  String _address = "";
  String _phone = "";
  String _password = "";
  String _nbp = "";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Register As a First User\n Good luck for your business!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        toolbarHeight: AppBar().preferredSize.height,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(getProportionateScreenWidth(context,5)),
              height: getProportionateScreenWidth(context, 120),
              width: getProportionateScreenWidth(context, 120),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/logo.PNG"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(18, 142, 104, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                // border: Border(
                                //     bottom:
                                //         BorderSide(color: Colors.grey[100]!))
                                ),
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              onSaved: (value) {
                                setState(() {
                                  _name = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is required";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name(Same as Nid/BC/Passport)",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              onSaved: (value) {
                                setState(() {
                                  _address = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is required";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            // decoration: BoxDecoration(
                            //     border: Border(
                            //         bottom:
                            //             BorderSide(color: Colors.grey[100]!))),
                            child: TextFormField(
                              onSaved: (value) {
                                setState(() {
                                  _phone = value!;
                                });
                              },
                              style: Theme.of(context).textTheme.titleMedium,
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone number",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              onSaved: (value) {
                                setState(() {
                                  _password = value!;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?`\-=[\]\\;\./]).{6,}$')
                                    .hasMatch(value)) {
                                  return 'Uppercase, lowercase, digit, special, 6+ characters';
                                }
                                return null; // Return null if the input is valid.
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium,
                              onSaved: (value) {
                                setState(() {
                                  _nbp = value!;
                                });
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter NID Number';
                                }
                                return null; // Return null if the input is valid.
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nid/BirthCertificate/Passport",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: _isLoading
                        ? const Center(child: CupertinoActivityIndicator())
                        : GradientButton(
                            child: Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              showLoadingDialog(Get.context!);
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                setState(() {
                                  _isLoading = true;
                                });
                                print(_isLoading);

                                var newString = nanoid(6);

                                String myReferCode = 'MakB$newString';
                                int insuranceEndingYear =
                                    DateTime.now().year + 5;
                                String demoInsuranceEndingDate =
                                    '$insuranceEndingYear-${DateTime.now().month}-${DateTime.now().day}';
                                DateTime insuranceEndingDate =
                                    DateFormat("yyyy-MM-dd")
                                        .parse(demoInsuranceEndingDate);
                                String insuranceEndingDateInTimeStamp =
                                    insuranceEndingDate.millisecondsSinceEpoch
                                        .toString();

                                authController.createFirstUser(
                                    _name,
                                    _address,
                                    _phone,
                                    _password,
                                    _nbp,
                                    myReferCode,
                                    insuranceEndingDateInTimeStamp,
                                    '0');
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                              Navigator.pop(context);
                            },
                            borderRadius: 5.0,
                            height: size.width * .12,
                            width: size.width * .9,
                            gradientColors: [
                                Color(0xFF0198DD),
                                Color(0xFF19B52B)
                              ]),
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
