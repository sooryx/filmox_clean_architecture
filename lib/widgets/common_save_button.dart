import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rclive/rcupload/components/rc_custom_upload_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final EdgeInsetsGeometry? margin;

  const CommonSaveButton({
    Key? key,
    this.onPressed,
    this.label = 'Save',
    this.icon = Icons.save, this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: margin ?? EdgeInsets.only(left: 5.w, right: 10.w),

        child: RCCustomUploadButton(
          borderRadius: 15,
          strokeWidth: 2,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF003780),
              Color(0xFF003780),
              Color(0xFF1CB5E0),
              Color(0xFF1CB5E0),
              Color(0xFF003780),
              Color(0xFF003780),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF003780).withOpacity(0.3),
                  const Color(0xFF1CB5E0).withOpacity(0.3),
                  const Color(0xFF1CB5E0).withOpacity(0.3),
                  const Color(0xFF003780).withOpacity(0.3),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  icon,
                  color: Theme.of(context).colorScheme.surface,
                  size: 25.sp,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.milliseconds).shimmer(duration: 600.ms,delay: 1200.ms).scale(
      begin: Offset(0.9, 0.9),
      end: Offset(1.0, 1.0),
      duration: 800.ms,
      curve: Curves.easeOutBack,
    );
  }
}
