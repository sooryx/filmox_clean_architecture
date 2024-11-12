
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/data/models/profile/user_profile_model.dart';
import 'package:filmox_clean_architecture/domain/entity/profile/profile_entity.dart';

class ProfileRepo {
  final ApiService _apiService = ApiService();

  String getProfileData = '/get_profile_data';

  Future<ProfileEntity> fetchProfileData() async {
    final response = await _apiService.post(getProfileData, {});
    UserProfileModel userProfileModel = response;
    return ProfileEntity(
        name: userProfileModel.data.name,
        profilePhoto: userProfileModel.data.profilePhoto ?? AppConstants.filmoxLogo,
        type: userProfileModel.data.type,
        phone: userProfileModel.data.phone,
        email: userProfileModel.data.email,
        profession: userProfileModel.data.profession,
        industry: userProfileModel.data.industry,
        state: userProfileModel.data.state,
        coverPictures: [
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage1 ?? '')),
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage2 ?? '')),
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage3 ?? '')),
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage4 ?? '')),
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage5 ?? '')),
          (UrlStrings.imageUrl + (userProfileModel.data.coverImage6 ?? '')),
        ],
        digitalTheater: userProfileModel.data.digitalTheatre.map((theater) =>
            DigitalTheatreProfileEntity(
                id: theater.id,
                uploadType: theater.uploadType,
                title: theater.title,
                poster: theater.poster,
                year: theater.year,
                rating: theater.rating,
                languageId: theater.languageId,
                status: theater.status,
                userType: theater.userType,
                userId: theater.userId,
                step: theater.step,
                createdAt: theater.createdAt,
                updatedAt: theater.updatedAt)).toList());
  }
}

