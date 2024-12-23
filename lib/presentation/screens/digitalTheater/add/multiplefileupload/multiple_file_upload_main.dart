
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_1_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_2_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_3_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_4_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_5_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/components/custom_stepper_appbar.dart';
import 'package:filmox_clean_architecture/presentation/screens/entrypoint/entry_point.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'steps/MultipleFileStep1Screen.dart';
import 'steps/MultipleFileStep2Screen.dart';
import 'steps/MultipleFileStep3Screen.dart';
import 'steps/MultipleFileStep4Screen.dart';
import 'steps/MultipleFileStep5Screen.dart';


class MultipleFileUploadMainScreen extends StatefulWidget {
  const MultipleFileUploadMainScreen({super.key});

  @override
  _MultipleFileUploadMainScreenState createState() =>
      _MultipleFileUploadMainScreenState();
}

class _MultipleFileUploadMainScreenState
    extends State<MultipleFileUploadMainScreen> {
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
    final dtProvider =
        Provider.of<MultipleFileUploadMainProvider>(context, listen: false);
    await dtProvider.fetchCategories();
    final step = dtProvider.dtInfoFormEntity?.step ;
    // final step = 2;
    print("Step :$step");
    setState(() {
      if (step == 5) {
        _currentStep = 0;
      } else {
        _currentStep = step ?? 0;
      }
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultipleFileUploadMainProvider>(
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(AppConstants.videoUploading, height: 150.h),
                        Hero(
                            tag: 'multiplefileupload',
                            child: Text(
                              "Configuring Your Series Upload Experience...",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                      ],
                    ),
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
        return const MultipleFileStep1Screen();
      case 1:
        return const MultipleFileStep2Screen();
      case 2:
        return const MultipleFileStep3Screen();
      case 3:
        return const MultipleFileStep4Screen();
      case 4:
        return const MultipleFileStep5Screen();
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
              ? Container(color:Theme.of(context).scaffoldBackgroundColor,child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Loadingscreen(),
              Hero(
                  tag: 'singlefileupload',
                  child: Text("Getting Ready for Your Movie Upload...",style: Theme.of(context).textTheme.bodyMedium,)),
            ],
          ))
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
        Provider.of<MultipleFileUploadStep1Provider>(context, listen: false);
    final step2provider =
        Provider.of<MultipleFileUploadStep2Provider>(context, listen: false);
    final step3provider =
        Provider.of<MultipleFileUploadStep3Provider>(context, listen: false);
    final step4provider =
        Provider.of<MultipleFileUploadStep4Provider>(context, listen: false);
    final step5provider =
        Provider.of<MultipleFileUploadStep5Provider>(context, listen: false);

    try {
      bool isSuccess = false;

      switch (_currentStep) {
        case 0:
          isSuccess = await step1provider.Step1API();
          break;
        case 1:
          isSuccess = await step2provider.step2API();
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
          isSuccess = true;
          break;
      }

      if (isSuccess) {
        setState(() async {
          if (_currentStep == 4) {
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => const EntryPoint()));
            await SharedPreferencesManager().clearFileIDs();
          } else {
            _currentStep++;
          }
          isLoading = false;
        });
      } else {
        customErrorToast(context, "API call failed. Please try again.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      customErrorToast(context, "$e");
      setState(() => isLoading = false);
    }
  }

  void _showDeleteProgressDialog() {
    showCustomDialog(
      context: context,
      title: "Delete progress",
      contentText1: 'Do you want to delete the progress as well ?',
      okbutton: "Yes",
      cancelbutton: "No",
      onCancel: () async {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      onConfirm: () async {
        try {
          await SharedPreferencesManager().clearFileIDs();
          customRandomToast(context, "Progress removed");
          Navigator.pop(context);
          Navigator.pop(context);
        } on Exception {
          customErrorToast(context, "Error deleting progress");
        }
      },
    );
  }
}
