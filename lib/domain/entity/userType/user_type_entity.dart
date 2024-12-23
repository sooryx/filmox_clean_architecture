import 'package:filmox_clean_architecture/core/utils/urls.dart';

class UserInfoEntity {
  String userName;
  String userType;
  String userImage;

  UserInfoEntity(
      {required this.userName,
      required this.userType,
      required String userImage
      }): userImage = '${UrlStrings.imageUrl}$userImage';
}

class UserTypeEntity {
  String image;
  String description;

  UserTypeEntity({required this.image, required this.description});
}
