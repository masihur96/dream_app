import 'package:dream_app/variables/size_config.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0861AF); //(0xFF19B52B);
BuildContext? context;
const kPrimaryLightColor = Color(0xFF19B56B);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF0861AF), Color(0xFF19B52B), Color(0xFF0198DD)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(context!, 28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords doesn't matched";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kShortPhoneNumberError = "Phone Number must be of 11 digits";
const String kAddressNullError = "Please Enter your address";

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(getProportionateScreenWidth(context!, 15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

const FormDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
  fillColor: Colors.white,
  // hintText: "Enter Mobile Number",
  // prefixIcon: Icon(Icons.phone_iphone),
  border: InputBorder.none,
  filled: true,
);

class AamarPayKey {
  String signature = "c6c948e1b319fddacd52c6e61fe3928a";
  String storeId = "makb";
  String merchantID = "makb";
}
