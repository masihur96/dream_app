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
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade50,
                  Colors.white,
                ],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: size.height * .08),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: getProportionateScreenWidth(context, 150),
                    width: getProportionateScreenWidth(context, 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/icons/dream.png"),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone, color: Color(0xFF0198DD)),
                            hintText: "Phone number",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a phone number';
                            } else if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (value) => _phone = value!,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          obscureText: _isVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF19B52B)),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isVisible ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(() => _isVisible = !_isVisible),
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?`\-=[\]\\;\./]).{6,}$').hasMatch(value)) {
                              return 'Password must contain: uppercase, lowercase, number, special char';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF0198DD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GradientButton(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            showLoadingDialog(context);
                            
                            try {
                              QuerySnapshot snapshot = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('id', isEqualTo: _phone)
                                  .get();
                              
                              final List<QueryDocumentSnapshot> user = snapshot.docs;
                              
                              if (user.isNotEmpty) {
                                if (user[0].get('password') == _password) {
                                  SharedPreferences pref = await SharedPreferences.getInstance();
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
                                showToast("No user registered with this phone number");
                              }
                            } catch (e) {
                              closeLoadingDialog(context);
                              showToast("An error occurred. Please try again.");
                            }
                          }
                        },
                        borderRadius: 12.0,
                        height: 55,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFF0198DD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
  }

  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
