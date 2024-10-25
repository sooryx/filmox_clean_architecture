import 'package:filmox_clean_architecture/presentation/screens/entrypoint/entry_point.dart';
import 'package:filmox_clean_architecture/providers/auth/auth_provdier.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_main_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/digital_theater_provider.dart';
import 'package:filmox_clean_architecture/providers/onboarding/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/utils/custom_theme.dart';
import 'core/utils/local_storage.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager().init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardingProvider(),),
        ChangeNotifierProvider(create: (context) => AuthProvdier(),),
        ChangeNotifierProvider(create: (context) => DigitalTheaterProvider(),),
        ChangeNotifierProvider(create: (context) => RcMainProvider()..fetchContests(),)
      ],
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
              home: EntryPoint(),

            );
          }),
    );
  }
}
