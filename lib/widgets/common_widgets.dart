import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'custom_popups.dart';

class CommonWidgets {
  static Widget roundArrowButton(
      {required BuildContext context,
      required Function onTap,
      required TextEditingController phoneController}) {
    return ElevatedButton(
      onPressed: () {
        if (phoneController.text.length == 10) {
          onTap();
        } else if (phoneController.text.isEmpty) {
          customErrorToast(context, 'Enter your mobile number');
        } else if (phoneController.text.length < 10) {
          customErrorToast(context, 'Number entered is not valid');
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          CircleBorder(
            side: BorderSide(
              color: const Color(0xFF1CB5E0),
              width: 2.w,
            ),
          ),
        ),
        shadowColor: WidgetStateProperty.all(const Color(0xFF1CB5E0)),
        elevation: WidgetStateProperty.all(0.5),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.dg),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 35.sp,
          ),
        ),
      ),
    );
  }

  static Widget gradientButton(
      {required double radius,
      required double padding,
      required VoidCallback? onPress,
      required String text,
      required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000046),
                    Color(0xFF1CB5E0),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(padding),
              backgroundColor: Colors.transparent,
            ),
            onPressed: onPress,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.surface),
            ),
          )
        ],
      ),
    );
  }

  static Widget gradientBorderPainter({
    required Widget child,
    double strokeWidth = 2.0,
    required Gradient gradient,
  }) {
    return CustomPaint(
      painter:
          _GradientBorderPainter(strokeWidth: strokeWidth, gradient: gradient),
      child: child,
    );
  }

  static Widget gradientTextField({
    String? labelText,
    String? hintText,
    required TextEditingController controller,
    IconButton? sicon,
    IconButton? picon,
    List<TextInputFormatter>? inputFormatter,
    TextInputType? type,
    Validator? validator,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
  }) {
    return _GradientTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      sicon: sicon,
      picon: picon,
      inputFormatter: inputFormatter,
      type: type,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmiitted: onFieldSubmitted,
    );
  }

  static Widget CustomDropDown({
    required BuildContext context,
    required String hintText,
    required double buttonWidth,
    required double buttonHeight,
    required List<String> items,
    TextStyle? textStyle,
    String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: textStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).hintColor,
              ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight,
          width: buttonWidth,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white.withOpacity(0.05),
          ),
          elevation: 1,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: 22.sp,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Colors.black54,
          ),
          scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(40.r),
              thickness: WidgetStateProperty.all(1),
              thumbVisibility: WidgetStateProperty.all(true),
              interactive: true),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
        ),
      ),
    );
  }

  static Widget CustomDivider({
    required double start,
    required double end,
    required double thickness,
    required Color color,
  }) {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0), // Transparent color at end
          ],
        ),
      ),
      child: Divider(
        thickness: thickness,
        color: Colors.transparent, // Set transparent color
        indent: start.w,
        endIndent: end.w,
// Define gradient for fading effect
      ),
    );
  }

  static WidgetcustomDropdown({
    required BuildContext context,
    required String hintText,
    required double buttonWidth,
    required double buttonHeight,
    required List<String> items,
    String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight,
          width: buttonWidth,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white.withOpacity(0.05),
          ),
          elevation: 1,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: 22.sp,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: Colors.black54,
          ),
          scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(40.r),
              thickness: WidgetStateProperty.all(1),
              thumbVisibility: WidgetStateProperty.all(true),
              interactive: true),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
        ),
      ),
    );
  }

  static CustomGlassButton({
    required BuildContext context,
    required String buttonText,
    required Function() onTap,
    double? buttonHeight,
    List<Color>? borderColor,
    List<Color>? buttonColor,
    Widget? child,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: CustomPaint(
            painter: RoundedRectangleBorderPainter(
              borderRadius: 20,
              strokeWidth: 2,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: borderColor ??
                    const [
                      Color(0xFF1CB5E0),
                      Color(0xFF003780),
                      Color(0xFF1CB5E0),
                      Color(0xFF003780),
                      Color(0xFF1CB5E0),
                      Color(0xFF003780),
                    ],
              ),
            ),
            child: Container(
              height: buttonHeight ?? 60.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Material(
                elevation: 10,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: buttonColor ??
                                    [
                                      const Color(0xFF1CB5E0).withOpacity(0.35),
                                      const Color(0xFF1CB5E0).withOpacity(0.15),
                                    ],
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Center(
                              child: child ??
                                  Text(buttonText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 24.sp)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 800.milliseconds),
          ),
        ),
      ),
    );
  }

  static Widget CustomNeumorphism({
    required Widget child,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? color,
  }) {
    return Container(
        padding: padding ?? null,
        decoration: BoxDecoration(
            color: color ?? Colors.black54,
            borderRadius: borderRadius ?? BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  color: Colors.grey[900]!,
                  blurRadius: 8,
                  offset: const Offset(5, 5)),
              BoxShadow(
                  spreadRadius: 1,
                  color: Colors.grey[800]!,
                  blurRadius: 8,
                  offset: const Offset(-5, -5))
            ]),
        child: child);
  }

  static Widget CustomTextField({
    int? maxLength,
    int? maxLines,
    required String hintText,
    required bool obscureText,
    TextStyle? hintstyle,
    Icon? icon,
    TextEditingController? controller,
    FocusNode? focusNode,
    BorderRadius? borderRadius,
  }) {
    return TextField(
      textAlign: TextAlign.start,
      style: hintstyle ?? const TextStyle(color: Colors.white),
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintstyle ?? const TextStyle(color: Colors.white),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        suffixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0.5,
          ),
        ),
      ),
      obscureText: obscureText,
    );
  }

  static Widget roundButton(
      {required Function onTap, required Icon icon, Color? color}) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          CircleBorder(
            side: BorderSide(
              color: color ?? const Color(0xFF1CB5E0),
              width: 2.w,
            ),
          ),
        ),
        shadowColor: WidgetStateProperty.all(color ?? const Color(0xFF1CB5E0)),
        elevation: WidgetStateProperty.all(0.5),
      ),
      child: Center(
        child: Padding(padding: EdgeInsets.all(8.dg), child: icon),
      ),
    );
  }

  static void CustomBottomSheetComments(
          BuildContext context, String megaAuditionDescription) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 6,
                margin: const EdgeInsets.only(top: 16, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: const Border(
                        top: BorderSide(color: Colors.white, width: 0.3)),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mega Audition info",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(),
                        SizedBox(height: 5.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Text(
                                megaAuditionDescription,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  static Widget CustomNeumorphicTimer({
    required BuildContext context,
    required Duration duration,
    void Function()? onDone,
    double? height,
    double? width,
    bool? isDay,
    bool? isHour,
    bool? isMinute,
    bool? isSecond,
  }) {
    String title(bool Duration) {
      if (isDay != null) {
        return "Day";
      } else if (isHour != null) {
        return "Hour";
      } else if (isMinute != null) {
        return "Minute";
      } else if (isSecond != null) {
        return "Second";
      }
      return '';
    }

    return SizedBox(
      height: height ??80.h,
      width:width ?? 80.w,
      child: CommonWidgets.CustomNeumorphism(
        borderRadius: BorderRadius.circular(100.r),
        padding: EdgeInsets.all(5.dg),
        color: Colors.black54.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SlideCountdownSeparated(
                duration: duration,
                slideDirection: SlideDirection.up,
                onDone:onDone ,
                shouldShowDays: (p0) {
                  return isDay ?? false;
                },
                shouldShowHours: (p0) {
                  return isHour ?? false;
                },
                shouldShowMinutes: (p0) {
                  return isMinute ?? false;
                },
                shouldShowSeconds: (p0) {
                  return isSecond ?? false;
                },
                separatorStyle: const TextStyle(color: Colors.white),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18.sp),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Text(
              title(isDay ?? isHour ?? isMinute ?? isSecond ?? false),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
  static Widget customButton({
    required BuildContext context,
    required String text,
    IconData? icon, // Optional icon
    required VoidCallback onPressed,
    Color backgroundColor = Colors.transparent, // Default background color
    Color textColor = Colors.white, // Default text color
    Color? iconColor, // Optional icon color
    EdgeInsetsGeometry padding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: iconColor ?? textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          if (icon != null) SizedBox(width: 2),
          if (icon != null)
            Icon(
              icon,
              color: iconColor ?? textColor,
            ),
        ],
      ),
    );
  }
}

class _GradientTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final IconButton? sicon;
  final IconButton? picon;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? type;
  final Validator? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmiitted;

  const _GradientTextField({
    this.labelText,
    this.hintText,
    required this.controller,
    this.sicon,
    this.picon,
    this.inputFormatter,
    this.type,
    this.validator,
    this.onChanged,
    this.onFieldSubmiitted,
  });

  @override
  _GradientTextFieldState createState() => _GradientTextFieldState();
}

class _GradientTextFieldState extends State<_GradientTextField> {
  late FocusNode _focusNode;
  double _strokeWidth = 2.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _strokeWidth = _focusNode.hasFocus ? 3.0 : 2.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonWidgets.gradientBorderPainter(
      strokeWidth: _strokeWidth,
      gradient: const LinearGradient(
        colors: [
          Color(0xFF1CB5E0),
          Color.fromARGB(255, 44, 44, 81),
          Color(0xFF1CB5E0),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        validator: widget.validator,
        inputFormatters: widget.inputFormatter,
        keyboardType: widget.type,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmiitted,
        decoration: InputDecoration(
          labelText: widget.labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: widget.sicon,
          prefixIcon: widget.picon != null
              ? IconButton(
                  icon: widget.picon!.icon,
                  color: _focusNode.hasFocus ? Colors.white : Colors.grey,
                  onPressed: widget.picon!.onPressed,
                )
              : null,
          labelStyle: const TextStyle(
            color: Colors.white,
            backgroundColor: Colors.transparent,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        obscureText: false,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  _GradientBorderPainter({required this.strokeWidth, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10.0)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

typedef Validator = String? Function(String? value);

// class MyDropdown extends StatelessWidget {
//   final String hintText;
//   final double buttonWidth;
//   final double buttonHeight;
//   final List<String> items;
//   final String? selectedValue;
//   final void Function(String?) onChanged;
//
//   const MyDropdown({
//     required this.hintText,
//     required this.items,
//     required this.selectedValue,
//     required this.onChanged,
//     Key? key, required this.buttonWidth, required this.buttonHeight,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
class RoundedRectangleBorderPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;

  RoundedRectangleBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedBorderPainterWidget extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;
  final double dashLength;
  final double gapLength;
  final bool roundedCorners;

  const DottedBorderPainterWidget({
    Key? key,
    required this.child,
    this.strokeWidth = 2.0,
    required this.gradient,
    this.customShape,
    this.borderRadius,
    this.dashLength = 5.0,
    this.gapLength = 3.0,
    this.roundedCorners = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        customShape: customShape,
        borderRadius: borderRadius,
        dashLength: dashLength,
        gapLength: gapLength,
        roundedCorners: roundedCorners,
      ),
      child: ClipPath(
        clipper: _RoundedRectangleBorderClipper(
          customShape: customShape,
          strokeWidth: strokeWidth,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;
  final double dashLength;
  final double gapLength;
  final bool roundedCorners;

  _DottedBorderPainter({
    required this.strokeWidth,
    required this.gradient,
    this.customShape,
    this.borderRadius,
    required this.dashLength,
    required this.gapLength,
    required this.roundedCorners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = roundedCorners ? StrokeCap.round : StrokeCap.butt;

    final path = customShape ?? getDefaultShape(size);
    final dashedPath = dashPath(
      path,
      dashArray: CircularIntervalList<double>([dashLength, gapLength]),
    );
    canvas.drawPath(dashedPath, paint);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16.0);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundedRectangleBorderClipper extends CustomClipper<Path> {
  final double strokeWidth;
  final Path? customShape;
  final double? borderRadius;

  _RoundedRectangleBorderClipper({
    required this.strokeWidth,
    this.customShape,
    this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    return customShape ?? getDefaultShape(size);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
