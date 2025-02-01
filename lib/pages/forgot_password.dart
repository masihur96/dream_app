import 'package:dream_app/pages/recover_password.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                "Forgot Password",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Please enter your Phone Number and we will send \nyou an otp to return to your account",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: size.height * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _codeController = TextEditingController();
  String phone = "";
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  hintText: "Enter your Phone Number",
                  hintStyle: Theme.of(context).textTheme.titleSmall,
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a user name';
                  } else if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                    return 'Please Entered a valid Phone Number';
                  }
                  return null; // Return null if the input is valid.
                },
                onSaved: (value) {
                  phone = value!;
                },
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
        GradientButton(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                showLoadingDialog(Get.context!);
                FirebaseAuth _auth = FirebaseAuth.instance;
                _auth.verifyPhoneNumber(
                    phoneNumber: '+88' + phone,
                    timeout: Duration(seconds: 60),
                    verificationFailed: (FirebaseAuthException exception) {
                      print("FE$exception");
                    },
                    codeSent: (String verificationId,
                        [int? forceResendingToken]) {
                      closeLoadingDialog(Get.context!);
                      showOtp(verificationId);
                    },
                    codeAutoRetrievalTimeout: (String verificationId) async {
                      //_verificationId=verificationId;
                      Get.back();
                      //showOtp(name,address,phone,password,nbp,verificationId);
                      //showToast('OTP resent');
                    },
                    verificationCompleted:
                        (PhoneAuthCredential phoneAuthCredential) {});
              }

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => LoginPage()));
            },
            borderRadius: 5.0,
            height: size.width * .12,
            width: size.width * .9,
            gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
        SizedBox(height: size.height * 0.1),
      ],
    );
  }

  void showOtp(String verificationId) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Phone Verification",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "We've sent OTP verification code on your given number.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Enter OTP here",
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.security)),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text("Confirm"),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue),
                    onPressed: () async {
                      //_loading(true);
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);

                      UserCredential result =
                          await _auth.signInWithCredential(credential);

                      User? user = result.user;

                      if (user != null) {
                        try {
                          String id = phone;
                        } finally {
                          //loading(false);
                          Get.to(RecoverPassword(
                            phone: phone,
                          ));
                        }
                      } else {
                        print("Error");
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    'OTP will expired after 1 minute ',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
            ),
          );
        });
  }
}
