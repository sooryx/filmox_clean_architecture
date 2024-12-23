import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_1_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_2.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_3.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_4.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_5.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/components/custom_stepper_appbar.dart';
import 'package:filmox_clean_architecture/presentation/screens/entrypoint/entry_point.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'steps/SingleFileStep1Screen.dart';
import 'steps/SingleFileStep2Screen.dart';
import 'steps/SingleFileStep3Screen.dart';
import 'steps/SingleFileStep4Screen.dart';
import 'steps/SingleFileStep5Screen.dart';

class SingleFileUploadMainScreen extends StatefulWidget {
  const SingleFileUploadMainScreen({super.key});

  @override
  _SingleFileUploadMainScreenState createState() =>
      _SingleFileUploadMainScreenState();
}

class _SingleFileUploadMainScreenState
    extends State<SingleFileUploadMainScreen> {
  int _currentStep = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    try {
      final dtProvider =
          Provider.of<SingleFileUploadMainProvider>(context, listen: false);

      await dtProvider.fetchCategories();
      final step = dtProvider.dtInfoFormEntity?.step;
      print("Step :$step");
      setState(() {
        if (step == 5) {
          _currentStep = 0;
        } else {
          _currentStep = dtProvider.dtInfoFormEntity?.step ?? 0;
        }
        isLoading = !isLoading;
      });
    } on Exception catch (e) {
      customErrorToast(context, e.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleFileUploadMainProvider>(
      builder: (context, dtProvider, _) {
        return Scaffold(
          appBar: _buildAppBar(
            currentStep: _currentStep,
            onDeletePressed: () => _showDeleteProgressDialog(),
            onStepChanged: (index) => setState(() => _currentStep = index),
          ),
          body: isLoading
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loadingscreen(),
                      SizedBox(
                        height: 20.h,
                      ),
                      Hero(
                          tag: 'singlefileupload',
                          child: Text(
                            "Getting Ready for Your Movie Upload...",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ],
                  ))
              : ListView(
                  children: [
                    _buildStepContent(step: _currentStep),
                    SizedBox(height: 20.h),
                    nextButton(),
                    SizedBox(height: 20.h),
                    Text(
                      "Changes can be made in the future from your profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
        );
      },
    );
  }

  CustomStepperAppBar _buildAppBar({
    required int currentStep,
    required dynamic Function(int) onStepChanged,
    required void Function() onDeletePressed,
  }) {
    return CustomStepperAppBar(
      currentStep: currentStep,
      onStepChanged: onStepChanged,
      onDeletePressed: onDeletePressed,
    );
  }

  Widget _buildStepContent({required int? step}) {
    switch (step) {
      case 0:
        return const SingleFileUploadStep1Screen();
      case 1:
        return const SingleFileUploadStep2Screen();
      case 2:
        return const SingleFileUploadStep3Screen();
      case 3:
        return const SingleFileUploadStep4Screen();
      case 4:
        return const SingleFileUploadStep5Screen();
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget nextButton() {
    return GestureDetector(
      onTap: () => _handleNextStep(),
      child: Container(
        padding: EdgeInsets.all(8.dg),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        child: Container(
          padding: EdgeInsets.all(7.dg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Icon(_currentStep == 4
                  ? Icons.check
                  : Icons.arrow_forward_ios_rounded),
        ),
      ),
    );
  }

  Future<void> _handleNextStep() async {
    setState(() => isLoading = true);
    final step1provider =
        Provider.of<SingleFileUploadStep1Provider>(context, listen: false);
    final step2provider =
        Provider.of<Step2SFUploadProvider>(context, listen: false);
    final step3provider =
        Provider.of<Step3DTSFUploadProvider>(context, listen: false);
    final step4provider =
        Provider.of<Step4SFUploadProvider>(context, listen: false);
    final step5provider =
        Provider.of<Step5SFUploadProvider>(context, listen: false);

    try {
      bool isSuccess = false;

      switch (_currentStep) {
        case 0:
          isSuccess = await step1provider.Step1API();
          break;
        case 1:
          isSuccess = await step2provider.step2API();
          print("Step 2 success: $isSuccess");

          break;
        case 2:
          isSuccess = await step3provider.Step3API();
          break;
        case 3:
          if (step4provider.castList.isEmpty) {
            customErrorToast(context, "Please add at least one cast member.");
            setState(() => isLoading = false);
            return;
          }
          isSuccess = true;
          break;
        case 4:
          if (step5provider.crewList.isEmpty) {
            customErrorToast(context, "Please add at least one crew member.");
            setState(() => isLoading = false);
            return;
          }
          // Navigate to the new page
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => const EntryPoint()));

          setState(() => isLoading = false);
          return;
      }

      if (isSuccess) {
        setState(() {
          _currentStep++;
          isLoading = false;
        });
      } else {
        customErrorToast(context, "API call failed. Please try again.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      customErrorToast(context, "An error occurred: $e");
      print(e);
      setState(() => isLoading = false);
    }
  }

  void _showDeleteProgressDialog() {
    showCustomDialog(
      context: context,
      title: "Delete progress",
      contentText1: 'Do you want to delete the current progress as well?',
      okbutton: "Yes",
      cancelbutton: "No",
      onCancel: () async {
        try {
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          customErrorToast(context, "Error deleting progress");
        }
      },
      onConfirm: () async {
        await SharedPreferencesManager().clearFileIDs();
        customRandomToast(context, "Progress deleted");
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}
