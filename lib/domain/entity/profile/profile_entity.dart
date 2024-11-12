class ProfileEntity {
  String name;
  String profilePhoto;

  String type;
  String phone;
  String? email; // Made nullable
  String profession;
  String industry;
  String state;
  List<String> coverPictures;
  List<DigitalTheatreProfileEntity> digitalTheater;

  ProfileEntity({
    required this.name,
    required this.profilePhoto,
    required this.type,
    required this.phone,
    required this.email, // Made nullable
    required this.profession,
    required this.industry,
    required this.state,
    required this.coverPictures,
    required this.digitalTheater,
  });
}

class DigitalTheatreProfileEntity {
  int id;
  int uploadType;
  String title;
  String poster;
  int year;
  dynamic rating;
  int languageId;
  int status;
  String userType;
  int userId;
  int step;
  DateTime createdAt;
  DateTime updatedAt;

  DigitalTheatreProfileEntity({
    required this.id,
    required this.uploadType,
    required this.title,
    required this.poster,
    required this.year,
    required this.rating,
    required this.languageId,
    required this.status,
    required this.userType,
    required this.userId,
    required this.step,
    required this.createdAt,
    required this.updatedAt,
  });
}
