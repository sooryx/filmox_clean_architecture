import 'package:filmox_clean_architecture/presentation/providers/auth/auth_provdier.dart';
import 'package:filmox_clean_architecture/presentation/screens/auth/signup/select_user_type.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'otp_validation_screen.dart';

class Signinscreen extends StatelessWidget {
  const Signinscreen({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvdier>(context, listen: true);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Hero(
            tag: "login screen",
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Login Screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          leading: const SizedBox.shrink(),
        ),
        body: GestureDetector(
          onTap: () {

          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(flex: 2),
                CommonWidgets.gradientTextField(

                  controller: provider.phoneNumberController,
                  type: TextInputType.phone,
                  inputFormatter: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hintText: 'Enter your mobile number',
                  picon: IconButton(
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                    'We\'ll send you an OTP by SMS to confirm your mobile number',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey, fontSize: 14.sp)),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    const Text(
                      "New to Filmox?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SelectUserType(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: const Color(0xFF1CB5E0),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text(
                      'Having trouble logging in?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Get help',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    CommonWidgets.roundArrowButton(
                        context: context,
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => OtpValidate(
                                      fromreg: false,
                                      phoneNumber: provider.phoneNumberController.text)));
                        },
                        phoneController: provider.phoneNumberController),
                  ],
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ));
  }
}
