import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/screens/auth/signin/signin_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/add_digital_theater.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/gamesmainscreen/games_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatefulWidget {
  final String? name;
  final String? userType;

  const CustomDrawer({super.key, this.name, this.userType});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: AnimatedContainer(
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 500),
          padding: EdgeInsets.all(10.dg),
          width: _isCollapsed ? 300 : 110,
          margin: const EdgeInsets.only(bottom: 80, top: 80, left: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(60),
              topRight: Radius.circular(60),
              bottomLeft: Radius.circular(60),
              topLeft: Radius.circular(60),
            ),
            color: Color.fromRGBO(20, 20, 20, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(isColapsed: _isCollapsed),
                const Divider(
                  color: Colors.grey,
                ),
                CustomListTile(
                    isCollapsed: _isCollapsed,
                    icon: AppConstants.digitalTheaterDrawerIcon,
                    title: 'Digital Theater',
                    infoCount: 0,
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AddDigitalTheater()));
                    }),
                CustomListTile(
                    isCollapsed: _isCollapsed,
                    icon: AppConstants.jobsDrawerIcon,
                    title: 'Events',
                    infoCount: 0,
                    onTap: () {}),
                CustomListTile(
                    isCollapsed: _isCollapsed,
                    icon: AppConstants.mediaDrawerIcon,
                    title: 'Media',
                    infoCount: 0,
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     PageTransition(
                      //         child: const AddDigitalTheater(),
                      //         type: PageTransitionType.rightToLeft));
                    }),
                CustomListTile(
                    isCollapsed: _isCollapsed,
                    icon: AppConstants.gamesDrawerIcon,
                    title: 'Games',
                    infoCount: 0,
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => GamesMainScreen()));
                    }),
                const Divider(color: Colors.grey),
                const Spacer(),
                const SizedBox(height: 10),
                BottomUserInfo(
                  isCollapsed: _isCollapsed,
                  name: widget.name,
                  userType: widget.userType,
                ),
                Align(
                  alignment: _isCollapsed
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(
                      _isCollapsed
                          ? Icons.arrow_back_ios
                          : Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      print('object');
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BottomUserInfo({
    required bool isCollapsed,
    required String? name,
    required String? userType,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              name ?? "User",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            userType ?? "Type",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          // AuthServices.logout(context);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Signinscreen()));
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget Header({
    required bool isColapsed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppConstants.filmoxLogo,
            height: 60.h,
            fit: BoxFit.cover,
          ),
          if (isColapsed) const SizedBox(width: 10),
          if (isColapsed)
            const Expanded(
              flex: 3,
              child: Text(
                'Filmox',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          if (isColapsed) const Spacer(),
          if (isColapsed)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget CustomListTile({
    required bool isCollapsed,
    required String icon,
    required String title,
    IconData? doHaveMoreOptions,
    required int infoCount,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        duration: const Duration(milliseconds: 500),
        width: isCollapsed ? 300 : 80,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(icon),
                    // Icon(
                    //   icon,
                    //   color: Colors.white,
                    // ),
                    if (infoCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isCollapsed) const SizedBox(width: 10),
            if (isCollapsed)
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    if (infoCount > 0)
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.purple[200],
                          ),
                          child: Center(
                            child: Text(infoCount.toString(),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (isCollapsed) const Spacer(),
            if (isCollapsed)
              Expanded(
                flex: 1,
                child: doHaveMoreOptions != null
                    ? IconButton(
                        icon: Icon(
                          doHaveMoreOptions,
                          color: Colors.white,
                          size: 12,
                        ),
                        onPressed: () {},
                      )
                    : const Center(),
              ),
          ],
        ),
      ),
    );
  }
}
