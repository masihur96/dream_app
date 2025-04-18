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
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        toolbarHeight: AppBar().preferredSize.height,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      height: getProportionateScreenWidth(context, 100),
                      width: getProportionateScreenWidth(context, 100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset("assets/icons/dream.png"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Join Dream App",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Create your account to get started",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(
                        context,
                        "Name(Same as Nid/BC/Passport)",
                        (value) {
                          if (value!.isEmpty) return 'Please enter a user name';
                          return null;
                        },
                        (value) => _name = value!,
                      ),
                      SizedBox(height: 15),
                      _buildAddressField(context),
                      SizedBox(height: 15),
                      _buildTextField(
                        context,
                        "Phone number",
                        (value) {
                          if (value!.isEmpty) return 'Please enter Phone Number';
                          if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                            return 'Please Enter a valid Phone Number';
                          }
                          return null;
                        },
                        (value) => _phone = value!,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        context,
                        "Password",
                        (value) {
                          if (value!.isEmpty) return 'Please enter Password';
                          if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?`\-=[\]\\;\./]).{6,}$')
                              .hasMatch(value)) {
                            return 'Uppercase, lowercase, digit, special, 6+ characters';
                          }
                          return null;
                        },
                        (value) => _password = value!,
                        obscureText: true,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        context,
                        "Nid/BirthCertificate/Passport",
                        (value) {
                          if (value!.isEmpty) return 'Please enter Valid NID';
                          return null;
                        },
                        (value) => _nbp = value!,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        context,
                        "Refer Code",
                        (value) {
                          if (value!.isEmpty) return 'Please enter Refer Code';
                          if (!RegExp(r'^MakB.{6}$').hasMatch(value)) {
                            return 'Please Enter valid Refer Code';
                          }
                          return null;
                        },
                        (value) => _referCode = value!,
                      ),
                      SizedBox(height: 30),
                      GradientButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            showLoadingDialog(Get.context!);
                            var newString = nanoid(6);
                            String myReferCode = 'MakB$newString';
                            
                            bool isReg = await authController.isRegistered(_phone);
                            if (!isReg) {
                              if (productController.cartList.length != 0) {
                                await userController.getReferUser(_referCode).then((value) {
                                  if (userController.referredList.length !=
                                      int.parse(userController.referUserModel.value.referLimit!)) {
                                    if (userController.isReferCodeCorrect.value) {
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
                                            myReferCode,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Get.back();
                                    showToast('Refer limit is over for this referCode!');
                                  }
                                });
                              } else {
                                Get.back();
                                showToast('Registration cannot be done with empty cart!');
                              }
                            } else {
                              Get.back();
                              showToast('Phone Number already exist');
                            }
                          }
                        },
                        borderRadius: 10.0,
                        height: size.width * .14,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)],
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String hintText,
    String? Function(String?)? validator,
    void Function(String?)? onSaved, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: validator,
        onSaved: onSaved,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => BounchingDialog(
            padding: screenSize(context, 0.1),
            height: screenSize(context, 1.7 ),

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Address Details",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: screenSize(context, .1)),
                  SingleChildScrollView(
                    child: Form(
                      key: _addressFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAddressTextField("Country", (value) => _country = value!),
                          _buildAddressTextField("District", (value) => _distric = value!),
                          _buildAddressTextField("Sub-District", (value) => _subDistric = value!),
                          _buildAddressTextField("Post", (value) => _post = value!),
                          _buildAddressTextField("Area", (value) => _area = value!),
                          _buildAddressTextField("Road Number", (value) => _road = value!),
                          _buildAddressTextField("House or Holding Number", (value) => _house = value!),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize(context, .1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDialogButton("Cancel", Colors.red, () => Navigator.pop(context)),
                      SizedBox(width: 20),
                      _buildDialogButton(
                        "Save",
                        Colors.green,
                        () {
                          if (_addressFormKey.currentState!.validate()) {
                            _addressFormKey.currentState!.save();
                            setState(() {
                              _address = "$_house $_road $_area $_post $_subDistric $_distric $_country";
                            });
                            Navigator.pop(context);
                          }
                        },
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          enabled: false,
          controller: TextEditingController(text: _address),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Address",
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: Icon(Icons.edit, color: Colors.grey[400]),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Please enter Address';
            return null;
          },
          onSaved: (value) => _address = value!,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }

  Widget _buildAddressTextField(String hint, void Function(String?)? onSaved) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'This field is Required !';
            return null;
          },
          onSaved: onSaved,
        ),
        SizedBox(height: screenSize(context, .03)),
      ],
    );
  }

  Widget _buildDialogButton(String text, Color color, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
