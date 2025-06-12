// Login UI for EzzyBill
import 'package:ezzybill/Controller/AuthController.dart';
import 'package:ezzybill/Screens/Home.dart';
import 'package:ezzybill/consts/list.dart';
import 'package:ezzybill/widgetsCommon/AppLogo.dart';
import 'package:ezzybill/widgetsCommon/ButtonComm.dart';
import 'package:ezzybill/widgetsCommon/CustomTextFieldAuth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ezzybill/consts/consts.dart';
import 'package:ezzybill/widgetsCommon/BgWidget.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    final screenHeight = MediaQuery.of(context).size.height - 300;
    final screenWidth = MediaQuery.of(context).size.width;

    return BgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              AppLogo(),
              SizedBox(height: 10),
              Text(
                "Login to $appname",
                style: TextStyle(
                    fontFamily: bold, fontSize: 18, color: primaryColor),
              ),
              SizedBox(height: 15),
              Obx(() => Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth - 70,
                    decoration: BoxDecoration(
                      color: secondaryColor2,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        customTextFieldAuth(
                          title: email,
                          hint: emailHints,
                          isPass: false,
                          controller: controller.emailController,
                        ),
                        customTextFieldAuth(
                          title: Password,
                          hint: passwordHint,
                          isPass: true,
                          controller: controller.passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Add forgot password flow
                            },
                            child: Text(forgetpPass,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(height: 5),
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(primaryColor2),
                              )
                            : SizedBox(
                                width: screenWidth - 50,
                                child: ButtonComm(
                                  color: primaryColor2,
                                  title: logIn,
                                  textColor: whiteColor,
                                  onPress: () async {
                                    controller.isLoading(true);
                                    print(
                                        "Email: ${controller.emailController.text}, Passworddddddddddddddddddd: ${controller.passwordController.text}");
                                    await controller
                                        .loginMethod(context: context)
                                        .then((value) {
                                      if (value != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(loggedIn),
                                        ));
                                        Get.offAll(() => Home());
                                      } else {
                                        controller.isLoading(false);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Login failed"),
                                        ));
                                      }
                                    });
                                  },
                                ),
                              ),
                        SizedBox(height: 5),
                        Text(createNewAcc, style: TextStyle(color: fontGrey)),
                        SizedBox(height: 5),
                        SizedBox(
                          width: screenWidth - 50,
                          child: ButtonComm(
                            color: lightopaque,
                            title: signUp,
                            textColor: primaryColor2,
                            onPress: () => Get.to(() => SignupScreen()),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(logInWith, style: TextStyle(color: fontGrey)),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: lightGrey,
                                child: Image.asset(SocialIconList[index],
                                    width: 30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
