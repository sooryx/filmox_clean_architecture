import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedAppBarWidget extends StatefulWidget {
  final Duration avatarWaitingDuration;

  final Duration avatarPlayDuration;

  final Duration nameDelayDuration;

  final Duration namePlayDuration;

  final String? image;

  final String name;
  final bool isLoading; // Add loading state

  const AnimatedAppBarWidget({
    super.key,
    required this.avatarWaitingDuration,
    required this.avatarPlayDuration,
    required this.nameDelayDuration,
    required this.namePlayDuration,
    this.image,
    required this.name, required this.isLoading,
  });

  @override
  State<AnimatedAppBarWidget> createState() => _AnimatedAppBarWidgetState();
}

class _AnimatedAppBarWidgetState extends State<AnimatedAppBarWidget> {
  bool isshow = true;

  void show() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isshow = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    show();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        AnimatedNameWidget(
          namePlayDuration: widget.namePlayDuration,
          nameDelayDuration: widget.nameDelayDuration,
          name: widget.name,
        ),
        const Spacer(),
        AnimatedContainer(
          height: 35.h,
          width: 35.w,
          duration: 700.milliseconds,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.surface),
          ),
          child:widget.isLoading ? const CircularProgressIndicator(
            strokeCap:  StrokeCap.round,strokeWidth: 3,

          ):ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: CachedNetworkImage(
              imageUrl: "${UrlStrings.imageUrl}${widget.image}",
              errorWidget: (context, url, error) {
                return Image.asset(
                  "assets/images/profile_image.png",
                );
              },
              placeholder: (context, url) {
                return Image.asset(
                  "assets/images/profile_image.png",
                );
              },
            ),
          ),
        )
            .animate()
            .scaleXY(
          begin: 0,
          end: 2,
          duration: widget.avatarPlayDuration,
          curve: Curves.easeInOutSine,
        )
            .then(delay: widget.avatarWaitingDuration)
            .scaleXY(begin: 3, end: 1)
            .slide(begin: const Offset(-4, 6), end: Offset.zero),
        const SizedBox(width: 25),
      ],
    );
  }
}

class AnimatedNameWidget extends StatelessWidget {
  final Duration namePlayDuration;
  final Duration nameDelayDuration;
  final String name;

  const AnimatedNameWidget({
    super.key,
    required this.namePlayDuration,
    required this.nameDelayDuration,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 220.w,
      child: Text(
        "Hello, $name 👋 ",
        maxLines: 2,
        style: Theme.of(context).textTheme.headlineMedium,
      )
          .animate()
          .slideX(
          begin: 0.2,
          end: 0,
          duration: namePlayDuration,
          delay: nameDelayDuration,
          curve: Curves.fastOutSlowIn)
          .fadeIn(),
    );
  }
}
