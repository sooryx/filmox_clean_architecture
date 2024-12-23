import 'package:easy_stepper/easy_stepper.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStepperAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentStep;
  final Function(int) onStepChanged;
  final VoidCallback onDeletePressed;

  const CustomStepperAppBar({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading:SizedBox.shrink(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 30.sp,
                            color: Theme.of(context).colorScheme.surface),
                        onPressed: onDeletePressed
                      ),
              Expanded(
                child: EasyStepper(
                  activeStep: currentStep,
                  showLoadingAnimation: true,
                  showTitle: true,
                  stepAnimationCurve: Curves.easeInOut,
                  stepAnimationDuration: Duration(milliseconds: 300),
                  disableScroll: false,
                  stepShape: StepShape.circle,
                  stepRadius: 20,
                  stepBorderRadius: 20,
                  showScrollbar: true,
                  steppingEnabled: true,
                  borderThickness: 5,
                  dashPattern: [0.01, 0.0],
                  activeStepBackgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.4),
                  direction: Axis.horizontal,
                  showStepBorder: true,
                  textDirection: TextDirection.rtl,
                  enableStepTapping: true,
                  titlesAreLargerThanSteps: false,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  finishedStepBorderColor: Colors.white,
                  finishedStepTextColor: Colors.green,
                  finishedStepBackgroundColor: Colors.transparent,
                  activeStepIconColor: Theme.of(context).primaryColor,
                  finishedStepIconColor: Colors.green,
                  loadingAnimation: AppConstants.videoUploading,
                  lineStyle: LineStyle(lineType: LineType.normal,lineThickness: 2,lineLength: 80,activeLineColor: Theme.of(context).primaryColor,defaultLineColor: Colors.grey),

                  steps: const [
                    EasyStep(
                      title: 'Movie Details',
                      icon: Icon(Icons.movie_creation_outlined),

                      activeIcon: Icon(Icons.movie_creation),
                      finishIcon: Icon(Icons.check),
                    ),
                    EasyStep(
                      title: 'Trailer Info',
                      icon: Icon(Icons.video_library_outlined),
                      activeIcon: Icon(Icons.video_library),
                      finishIcon: Icon(Icons.check),
                    ),
                    EasyStep(
                      title: 'Additional\nDetails',
                      icon: Icon(Icons.info_outline),
                      activeIcon: Icon(Icons.info),
                      finishIcon: Icon(Icons.check),
                    ),
                    EasyStep(
                      title: 'Add Cast\nMembers',
                      icon: Icon(Icons.people_alt_outlined),
                      activeIcon: Icon(Icons.people_alt),
                      finishIcon: Icon(Icons.check),
                    ),
                    EasyStep(
                      title: 'Add Crew\nMembers',
                      icon: Icon(Icons.group_outlined),
                      activeIcon: Icon(Icons.group),
                      finishIcon: Icon(Icons.check),
                    ),
                  ],
                  onStepReached: onStepChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.h); // Adjust height as needed
}
