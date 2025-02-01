import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/widgets/form_decoration.dart';
import 'package:dream_app/widgets/gradient_button.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';

class WithDrawPage extends StatefulWidget {
  @override
  _WithDrawPageState createState() => _WithDrawPageState();
}

enum WithdrawSystems { Bkash, Nogod, Rocket }

class _WithDrawPageState extends State<WithDrawPage> {
  WithdrawSystems? _operator = WithdrawSystems.Bkash;
  var amountController = TextEditingController(text: '');
  var mobileNoController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  int counter = 0;
  dynamic due = 0.0;
  dynamic availableBalance = 0.0;
  DateTime? currentDate;
  DateTime? lastInsuranceDate;
  var months;
  bool _isVisible = false;

  void count(UserController userController) async {
    userController.getRate().then((value) {
      setState(() {
        counter++;
        currentDate = DateTime.now();
        lastInsuranceDate = DateTime.fromMillisecondsSinceEpoch(int.parse(
            userController.userModel.value.lastInsurancePaymentDate!));
        print("last insurance date : $lastInsuranceDate");
        months = currentDate!.difference(lastInsuranceDate!).inDays ~/ 30;
        due = months * 250 -
            double.parse(userController.userModel.value.insuranceBalance!);
        availableBalance = double.parse(
                        userController.userModel.value.mainBalance!) -
                    due -
                    int.parse(userController.rateData.value.serviceCharge!) <
                0
            ? 0.0
            : double.parse(userController.userModel.value.mainBalance!) -
                due -
                int.parse(userController.rateData.value.serviceCharge!);
        mobileNoController.text = userController.userModel.value.phone!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final size = MediaQuery.of(context).size;
    if (counter == 0) count(userController);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: const Text(
              'Withdraw',
            ),
          )),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await userController.getWithDrawHistory(userController.id!);
            print('Refresh');
          },
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: EdgeInsets.all(size.width * .04),
              child: Column(
                children: [
                  Card(
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(color:Color(0xFF19B52B), width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 2,
                    child: Container(
                      width: size.width,
                      height: size.width * .4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Current Balance: ${userController.userModel.value.mainBalance ?? ''}',
                            style: TextStyle(
                                color: Color(0xFF19B52B),
                                fontSize: size.width * .05,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Insurance Due : $due',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .04,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Govt. Vat + Tax : ${userController.rateData.value.serviceCharge!}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .04,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Available Balance : $availableBalance',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .04,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.width * .03,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * .02,
                                    top: size.width * .03,
                                    bottom: size.width * .02),
                                child: Text(
                                  'A/C Name: ${userController.userModel.value.name ?? ''}',
                                  style: TextStyle(
                                      color: Color(0xFF19B52B),
                                      fontSize: size.width * .05,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),

                          /// withdraw system
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<WithdrawSystems>(
                                value: WithdrawSystems.Bkash,
                                groupValue: _operator,
                                onChanged: (WithdrawSystems? value) {
                                  setState(() {
                                    _operator = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(
                                'Bkash',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Radio<WithdrawSystems>(
                                value: WithdrawSystems.Nogod,
                                groupValue: _operator,
                                onChanged: (WithdrawSystems? value) {
                                  setState(() {
                                    _operator = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(
                                'Nogod',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Radio<WithdrawSystems>(
                                value: WithdrawSystems.Rocket,
                                groupValue: _operator,
                                onChanged: (WithdrawSystems? value) {
                                  setState(() {
                                    _operator = value;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(
                                'Rocket',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.width * .02,
                          ),
                          TextFormField(
                            controller: mobileNoController,
                            decoration: textFieldFormDecoration(size).copyWith(
                              labelText: _operator == WithdrawSystems.Bkash
                                  ? "Bkash Number"
                                  : _operator == WithdrawSystems.Nogod
                                      ? "Nogod Number"
                                      : "Rocket Number",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * .04),
                              labelStyle:
                                  Theme.of(context).textTheme.titleSmall,
                            ),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: size.width * .05,
                          ),
                          TextField(
                            controller: amountController,
                            decoration: textFieldFormDecoration(size).copyWith(
                              labelText: 'Amount',
                              hintText: 'Write Amount',
                              labelStyle:
                                  Theme.of(context).textTheme.titleSmall,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * .04),

                              //hintStyle: TextStyle(color: Colors.grey,fontSize: size.width*.04),
                              suffixText: 'TK',
                              suffixStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * .04),
                            ),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            height: size.width * .05,
                          ),
                          TextField(
                            obscureText: _isVisible,
                            controller: passwordController,
                            decoration: textFieldFormDecoration(size).copyWith(
                                labelText: 'Password',
                                hintText: '*******',
                                hintStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                labelStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isVisible = !_isVisible;
                                    });
                                  },
                                  child: Icon(_isVisible == false
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                )),
                          ),
                          SizedBox(
                            height: size.width * .05,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.width * .03,
                  ),
                  GradientButton(
                      child: Text(
                        'Withdraw',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      onPressed: () {
                        if (int.parse(amountController.text) < 500) {
                          showToast("Amount less than 500 cannot be withdrawn");
                          return;
                        }
                        if (mobileNoController.text.length != 11) {
                          showToast("Invalid mobile number");
                          return;
                        }
                        if (amountController.text != '' &&
                            passwordController.text != '') {
                          dynamic balance = availableBalance -
                              int.parse(amountController.text);
                          if (availableBalance < 500) {
                            showToast('Not enough balance!');
                          } else {
                            if (balance < 0) {
                              showToast('Not enough balance!');
                            } else {
                              if (passwordController.text ==
                                  userController.userModel.value.password) {
                                userController
                                    .withdraw(
                                        _operator == WithdrawSystems.Bkash
                                            ? "Bkash"
                                            : _operator == WithdrawSystems.Nogod
                                                ? "Nogod"
                                                : "Rocket",
                                        mobileNoController.text,
                                        amountController.text,
                                        userController.userModel.value.name!,
                                        due,
                                        userController
                                            .userModel.value.imageUrl!)
                                    .then((value) {
                                  setState(() {
                                    availableBalance = availableBalance -
                                        int.parse(amountController.text);
                                    mobileNoController.clear();
                                    amountController.clear();
                                    passwordController.clear();
                                  });
                                });
                              } else {
                                showToast('Wrong Password!');
                              }
                            }
                          }
                        } else {
                          showToast('Fill up the required fields');
                        }
                      },
                      borderRadius: 10,
                      height: size.width * .1,
                      width: size.width * .5,
                      gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 15),
                      child: Text(
                        'WithDraw History',
                        style: TextStyle(
                            color: Color(0xFF19B52B),
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                          color: Colors.green,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: userController.withdrawHistory.length,
                            itemBuilder: (context, index) {
                              /// millisecond date is converting to date format
                              DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      userController
                                          .withdrawHistory[index].date!));
                              var format = new DateFormat("yMMMd").add_jm();
                              String withdrawDate = format.format(date);

                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: size.width * .02),
                                child: Card(
                                  elevation: 1,
                                  child: ListTile(
                                    /// converted date
                                    leading: Text(withdrawDate),
                                    title: Center(
                                      /// withdraw amount
                                      child: Text(
                                        userController
                                            .withdrawHistory[index].amount!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),

                                    /// status
                                    trailing: Text(
                                      userController
                                          .withdrawHistory[index].status!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
