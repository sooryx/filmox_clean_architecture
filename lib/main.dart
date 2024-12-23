// ignore_for_file: unused_import

import 'package:filmox_clean_architecture/presentation/screens/entrypoint/entry_point.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/CricketDetailedScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/utils/custom_theme.dart';
import 'core/utils/local_storage.dart';
import 'core/utils/providers.dart';
import 'presentation/screens/games/Cricket/CricketDashboard2.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager().init();
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: ScreenUtilInit(
          designSize: const Size(411.42857142857144, 843.4285714285714),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Filmox',
              theme: CustomTheme.theme,
              home: OnBoardingScreen(),
            );
          }),
    );
  }
}
