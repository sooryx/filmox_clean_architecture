import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/presentation/providers/auth/auth_provdier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/urls.dart';
import 'signup_screen.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int selectedIndexForShowingArrowInUserTpe = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Select User Type',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp),
        ),
      ),
      body: Consumer<AuthProvdier>(
        builder: (context, provider, child) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.userTypeEntity.length,
                    itemBuilder: (context, index) {
                      final userType = provider.userTypeEntity[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(30.r),
                        onTap: () {
                          setState(() {

                            selectedIndexForShowingArrowInUserTpe = index;
                          });
                          provider.selectedUserType = index == 0
                              ? "vendor"
                              : index == 1
                              ? "artist"
                              : index == 2
                              ? "fan"
                              : "";
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              width: 6,
                              color:
                              selectedIndexForShowingArrowInUserTpe == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                            ),
                          ),
                          child: BannerWidget(
                            drawerContent: userType.description ,
                            imagePath:
                            '${UrlStrings.baseUrl}/uploads/${userType.image}',
                            fallbackImagePath: UrlStrings.errorImage,
                          ).animate().slideX(delay: 50.ms * (index + 1)),
                        )..animate().scaleX(duration: 2.seconds),
                      );
                    },
                  ),
                  if (selectedIndexForShowingArrowInUserTpe != -1)
                    roundArrowButton().animate().slideY(begin: .9),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget roundArrowButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupScreen(),
          ),
        );
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
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 35.sp,
          ),
        ),
      ),
    );
  }
}

class BannerWidget extends StatefulWidget {
  final String drawerContent;
  final String imagePath;
  final String fallbackImagePath;

  const BannerWidget({
    super.key,
    required this.drawerContent,
    required this.imagePath,
    required this.fallbackImagePath,
  });

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: _hasError
              ? CachedNetworkImage(
            imageUrl: widget.fallbackImagePath,
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : CachedNetworkImage(
            imageUrl: widget.imagePath,
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
            errorWidget: (context, url, error) {
              setState(() {
                _hasError = true;
              });
              return const Icon(Icons.error);
            },
          ),
        ),
        Positioned(
          bottom: 5.h,
          left: 5.h,
          child: TextButton(
            onPressed: () => showModalBottomSheet(
              backgroundColor: Colors.black54.withOpacity(0.5),
              context: context,
              builder: (context) =>
                  ScrollableBottomDrawer(info: widget.drawerContent),
            ),
            child: Container(
              padding: EdgeInsets.all(6.dg),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.contact_support,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollableBottomDrawer extends StatelessWidget {
  final String info;

  const ScrollableBottomDrawer({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 400.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.black54.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              const Text('Title'),
              SizedBox(
                height: 5.h,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.3,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                info,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
