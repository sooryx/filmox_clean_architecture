
import 'package:filmox_clean_architecture/core/utils/urls.dart';

class OnboardingEntity{
  final String text;
  final String image;

  OnboardingEntity({required this.text,required String image
  }):this.image = "https://filmox.kods.app/uploads/$image";
}