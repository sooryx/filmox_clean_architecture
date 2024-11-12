import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/onboarding/onboarding_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/onboarding/onboarding_entity.dart';
import 'package:flutter/cupertino.dart';



class OnBoardingProvider with ChangeNotifier {
  OnboardingRepository onboardingRepository = OnboardingRepository();

  List<OnboardingEntity> _onboardingEntity = [];
  DefaultPageStatus _status = DefaultPageStatus.initial;

  List<OnboardingEntity> get onboardingEntity => _onboardingEntity;

  DefaultPageStatus get status => _status;

  Future<void> fetchOnboardingData() async {
    _status = DefaultPageStatus.loading;
    notifyListeners();
    try {
      _onboardingEntity = await onboardingRepository.getOnboardingData();
      _status = DefaultPageStatus.success;
    } catch (e) {
      _status = DefaultPageStatus.failed;
      print("Error: $e");
    } finally {
      notifyListeners();
    }
  }
}

