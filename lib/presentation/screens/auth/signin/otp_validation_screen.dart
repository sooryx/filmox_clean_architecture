import 'package:filmox_clean_architecture/core/errors/app_exceptions.dart';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/presentation/providers/auth/auth_provdier.dart';
import 'package:filmox_clean_architecture/presentation/screens/entrypoint/entry_point.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OtpValidate extends StatelessWidget {
  final String phoneNumber;
  final bool fromreg;

  const OtpValidate(
      {super.key, required this.phoneNumber, required this.fromreg});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvdier>(context, listen: true);

    if (provider.status != DefaultPageStatus.success) {
      return Scaffold(
          appBar: _buildAppBar(context),
          body: provider.status == DefaultPageStatus.loading
              ? const Center(child: Loadingscreen())
              : _buildBody(context));
    }
    return Center(child: Text("Error"),);

  }

  Widget _buildBody(context) {
    return ListView(
      padding: EdgeInsets.all(20.dg),
      children: [
        SizedBox(
          height: 60.h,
        ),
        Text(
          'A verification code has been sent to $phoneNumber via text message',
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
        SizedBox(
          height: 100.h,
        ),
        _buildOtpField(context),
        SizedBox(
          height: 40.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              'Resend',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                height: 1.5.h,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Container(
              height: 30.h,
              width: 2.w,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(
              width: 20.w,
            ),
            Icon(
              Icons.phone_android,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(
              width: 6.w,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Edit your number',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  height: 1.5.h,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  OtpTextField _buildOtpField(context) {
    return OtpTextField(
        numberOfFields: 4,
        borderColor: Colors.grey,
        autoFocus: false,
        focusedBorderColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        fieldWidth: 50.w,
        textStyle: const TextStyle(color: Colors.white, fontSize: 20),
        showFieldAsBox: true,
        borderWidth: 1,
        clearText: true,
        borderRadius: BorderRadius.circular(12.r),
        keyboardType: TextInputType.phone,
        onCodeChanged: (String code) {},
        onSubmit: (String verificationCode) async {
          _handleSignIn(context);
        });
  }

  void _handleSignIn(BuildContext context) async {
    final provider = Provider.of<AuthProvdier>(context, listen: false);

    try {
      await provider.userSignin();
      Navigator.push(context, CupertinoPageRoute(builder: (context) => EntryPoint()));
    } on NoInternetException catch (e) {
      customErrorToast(context, e.message);
    } on PageNotFoundException {
      customErrorToast(context, 'Invalid token. Please log in again.');
    } on ServerException catch(e){
      customErrorToast(context, e.toString());

    }
    catch (e) {
      customErrorToast(context, 'An error occurred: $e');
    }
  }

}
