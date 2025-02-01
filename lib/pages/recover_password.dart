import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class RecoverPassword extends StatefulWidget {
  String? phone;

  RecoverPassword({this.phone});

  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  String? newPass, renewPass;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //title: Text('Change Password',style: TextStyle(color: Colors.black)),
        toolbarHeight: AppBar().preferredSize.height,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 20)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04),
                  Text(
                    "Recover Password",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(context, 28),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Please enter your new password to get back to your account",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.05),
                  buildPasswordFormField2(),
                  SizedBox(height: getProportionateScreenHeight(context, 30)),
                  buildPasswordFormField3(),
                  SizedBox(height: getProportionateScreenHeight(context, 30)),
                  Center(
                    child: GradientButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (newPass!.endsWith(renewPass!)) {
                              userController.recoverPassword(
                                  newPass!, widget.phone!);
                            } else {
                              showToast('Passwords doesn\'t matched');
                            }
                          } else {
                            showToast('Please fill up the fields');
                          }
                        },
                        borderRadius: 5.0,
                        height: size.width * .12,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField2() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => newPass = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            newPass = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your new password";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your new password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  TextFormField buildPasswordFormField3() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => renewPass = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            renewPass = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Confirm your new password";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Confirm your new password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.lock_outline)),
    );
  }
}
