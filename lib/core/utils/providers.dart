import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/multiplefileupload/multiple_file_upload_main.dart';
import 'package:filmox_clean_architecture/providers/auth/auth_provdier.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_feed_provider.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_main_provider.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_main_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_1_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_2_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_3_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_4_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_5_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_main_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_1_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_2.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_3.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_4.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_5.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/add/traler_booster/trailer_booster_provider.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/dt_main/digital_theater_provider.dart';
import 'package:filmox_clean_architecture/providers/home/home_provider.dart';
import 'package:filmox_clean_architecture/providers/onboarding/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => OnBoardingProvider(),),
  ChangeNotifierProvider(create: (context) => AuthProvdier(),),
  ChangeNotifierProvider(create: (context) => DigitalTheaterProvider()..fetchApi(),),
  ChangeNotifierProvider(create: (context) => RcMainProvider()..fetchContests(),),
  ChangeNotifierProvider(create: (context) => HomeProvider()),
  ChangeNotifierProvider(create: (context) => RcUploadProvider()),
  ChangeNotifierProvider(create: (context) => RcUploadProvider()),
  ChangeNotifierProvider(create: (context) => RcFeedProvider()),
  ChangeNotifierProvider(create: (context) => TrailerBoosterProvider()),
  ChangeNotifierProvider(create: (context) => SingleFileUploadMainProvider()),
  ChangeNotifierProvider(create: (context) => SingleFileUploadStep1Provider()),
  ChangeNotifierProvider(create: (context) => Step2SFUploadProvider()),
  ChangeNotifierProvider(create: (context) => Step3DTSFUploadProvider()),
  ChangeNotifierProvider(create: (context) => Step4SFUploadProvider()),
  ChangeNotifierProvider(create: (context) => Step5SFUploadProvider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadMainProvider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadStep1Provider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadStep2Provider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadStep3Provider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadStep4Provider()),
  ChangeNotifierProvider(create: (context) => MultipleFileUploadStep5Provider()),
];
