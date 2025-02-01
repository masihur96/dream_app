import 'package:dream_app/controller/auth_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  String? password;
  String? newPass, renewPass;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
        ),
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
                    "Reset Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Please enter your current password & new password to reset your password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: size.height * 0.05),
                  buildPasswordFormField1(),
                  SizedBox(height: getProportionateScreenHeight(context, 30)),
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
                              if (password ==
                                  userController.userModel.value.password) {
                                userController.changePassword(newPass!);
                              } else {
                                showToast('Current password is wrong');
                              }
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

  TextFormField buildPasswordFormField1() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            password = value;
          });
        }

        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your current password";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter current password",
        hintStyle: Theme.of(context).textTheme.titleSmall,
        labelStyle: Theme.of(context).textTheme.titleSmall,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline),
      ),
      style: Theme.of(context).textTheme.titleSmall,
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
          hintStyle: Theme.of(context).textTheme.titleSmall,
          labelStyle: Theme.of(context).textTheme.titleSmall,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.lock_outline)),
      style: Theme.of(context).textTheme.titleSmall,
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
          hintStyle: Theme.of(context).textTheme.titleSmall,
          labelStyle: Theme.of(context).textTheme.titleSmall,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.lock_outline)),
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
