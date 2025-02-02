import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_app/home_nav.dart';
import 'package:dream_app/pages/register_page.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _phone = "";
  String _password = "";
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Log In',
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(height: size.height * .05),
              Container(
                padding:
                    EdgeInsets.all(getProportionateScreenWidth(context, 5)),
                height: getProportionateScreenWidth(context, 120),
                width: getProportionateScreenWidth(context, 120),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/icons/dream.png"),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone number",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                style: Theme.of(context).textTheme.titleSmall,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a user name';
                                  } else if (!RegExp(r'^[0-9]{11}$')
                                      .hasMatch(value)) {
                                    return 'Please Entered a valid Phone Number';
                                  }
                                  return null; // Return null if the input is valid.
                                },
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  _phone = value!;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: _isVisible,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isVisible = !_isVisible;
                                          });
                                        },
                                        child: Icon(_isVisible == false
                                            ? Icons.visibility
                                            : Icons.visibility_off))),
                                style: Theme.of(context).textTheme.titleSmall,
                                onSaved: (value) {
                                  _password = value!;
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GradientButton(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              showLoadingDialog(context);
                              QuerySnapshot snapshot = await FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .where('id', isEqualTo: _phone)
                                  .get();
                              final List<QueryDocumentSnapshot> user =
                                  snapshot.docs;
                              if (user.isNotEmpty) {
                                if (user[0].get('password') == _password) {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString('id', _phone);
                                  closeLoadingDialog(context);
                                  showToast("Successfully logged in");
                                  Get.offAll(() => HomeNav());
                                } else {
                                  closeLoadingDialog(context);
                                  showToast("Incorrect password");
                                }
                              } else {
                                closeLoadingDialog(context);
                                showToast(
                                    "No User is registered with this phone");
                              }
                            }
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
                    Padding(
                      padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                "Create New Account?",
                                style: Theme.of(context).textTheme.titleSmall,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
