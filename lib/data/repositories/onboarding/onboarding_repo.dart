import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/onboarding/onBoardingDataModel.dart';
import 'package:filmox_clean_architecture/domain/entity/onboarding/onboarding_entity.dart';

class OnboardingRepository {
  ApiService apiService = ApiService();

  Future<List<OnboardingEntity>> getOnboardingData() async {
    final response = await apiService.get('/onboardingScreens');
    final dataModel = OnBoardingDataModel.fromJson(response);
    return dataModel.data
        .map((i) => OnboardingEntity(
              text: i.description,
              image: i.media,
            ))
        .toList();
  }
}
