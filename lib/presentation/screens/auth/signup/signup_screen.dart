import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/presentation/providers/auth/auth_provdier.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../signin/otp_validation_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

String capitalizeFirstLetter(String text) {
  return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
}

class _SignUpScreenState extends State<SignUpScreen> {
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode industryFocusNode;
  late FocusNode stateFocusNode;
  late FocusNode professionFocusNode;
  late FocusNode nextButtonNode;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController proffessionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize focus nodes
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    industryFocusNode = FocusNode();
    stateFocusNode = FocusNode();
    professionFocusNode = FocusNode();
    nextButtonNode = FocusNode();
  }

  @override
  void dispose() {
    // Dispose of focus nodes
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    industryFocusNode.dispose();
    stateFocusNode.dispose();
    professionFocusNode.dispose();
    nextButtonNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '${capitalizeFirstLetter(provider.selectedUserType)} Register',
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 19.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 60.h),
                _buildTextField(nameController, 'Enter Your Name',
                    TextInputType.name, nameFocusNode, phoneFocusNode, null),
                SizedBox(height: 20.h),
                _buildTextField(
                    phoneController,
                    'Enter Your Number',
                    TextInputType.phone,
                    phoneFocusNode,
                    emailFocusNode,
                    LengthLimitingTextInputFormatter(10)),
                SizedBox(height: 20.h),
                _buildTextField(
                    emailController,
                    'Enter Your Email (Optional)',
                    TextInputType.emailAddress,
                    emailFocusNode,
                    industryFocusNode,
                    null),
                SizedBox(height: 20.h),
                _buildTextField(
                    industryController,
                    'Industry',
                    TextInputType.name,
                    industryFocusNode,
                    stateFocusNode,
                    null),
                SizedBox(height: 20.h),
                _buildTextField(stateController, 'State', TextInputType.name,
                    stateFocusNode, professionFocusNode, null),
                SizedBox(height: 20.h),
                _buildTextField(
                    proffessionController,
                    'Profession',
                    TextInputType.name,
                    professionFocusNode,
                    nextButtonNode,
                    null),
                SizedBox(height: 20.h),
                _buildCreateAccountButton(provider),
                _bottomPart(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginscreen');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF1CB5E0), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    TextInputType inputType,
    FocusNode currentFocusNode,
    FocusNode? nextFocusNode,
    LengthLimitingTextInputFormatter? length,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: CommonWidgets.gradientTextField(
        controller: controller,
        hintText: hintText,
        type: inputType,
        onChanged: (value) {
          setState(() {});
        },
        // sicon: _getSuffixIcon(controller.text.isNotEmpty &&
        //     (hintText != 'Enter Your Number' || controller.text.length == 10)),
        inputFormatter: [length ?? LengthLimitingTextInputFormatter(40)],
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  Container _buildCreateAccountButton(AuthProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        boxShadow: const [
          BoxShadow(color: Color(0xFF1CB5E0)),
          BoxShadow(
            color: Color(0xFF171717),
            spreadRadius: -3.0,
            blurRadius: 17.0,
          ),
        ],
      ),
      child: provider.status == DefaultPageStatus.loading
          ? SizedBox(height: 60.h, child: Center(child: Loadingscreen()))
          : ElevatedButton(
              focusNode: nextButtonNode,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side:
                        BorderSide(color: const Color(0xFF1CB5E0), width: 3.w),
                  ),
                ),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () async {
               try{
                 await provider.userSignup(
                     name: nameController.text,
                     phoneNumber: phoneController.text,
                     email: emailController.text,
                     industry: industryController.text,
                     proffession: proffessionController.text,
                     selectedUserType: provider.selectedUserType,
                     state: stateController.text);
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => OtpValidate(
                           fromreg: true, phoneNumber: phoneController.text),
                     ));
               }catch(e){
                 customErrorToast(context, e.toString());
               }
             ;
              },
              child: SizedBox(
                height: 60.h,
                child: Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _bottomPart() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.white, height: 1.5),
            children: <TextSpan>[
              const TextSpan(text: 'By clicking '),
              const TextSpan(
                text: 'Register',
                style: TextStyle(color: Color(0xFF1CB5E0)),
              ),
              const TextSpan(text: ', You agree to our '),
              TextSpan(
                text: 'Terms & Conditions',
                style: const TextStyle(color: Color(0xFF1CB5E0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // _openBottomSheet(context, 'Terms & Conditions',
                    //     'Content for Terms & Conditions...');
                  },
              ),
              const TextSpan(text: ', '),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(color: Color(0xFF1CB5E0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // _openBottomSheet(context, 'Privacy Policy',
                    //     'Content for Privacy Policy...');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
//
// Widget _getSuffixIcon(bool isValid) {
//   return isValid ? const Icon(Icons.check_circle, color: Colors.green) : null;
// }
}
