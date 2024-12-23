import 'dart:io';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/dtDashboard/dtDashboard_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';
import 'package:flutter/cupertino.dart';

class DTDashboardProvider with ChangeNotifier {
  final DtdashboardRepo _dtdashboardRepo = DtdashboardRepo();

  DtDashboardEntity? _digitalTheaterDashBoardEntity;

  DtDashboardEntity? get digitalTheaterDashBoardEntity =>
      _digitalTheaterDashBoardEntity;

  DTInfoFormEntity? _dtInfoFormEntity;

  DTInfoFormEntity? get dtInfoFormEntity => _dtInfoFormEntity;

  DefaultPageStatus _status = DefaultPageStatus.initial;

  DefaultPageStatus get status => _status;

  /*Fetching the existing results to the dashboard*/
  Future<void> fetchDashboardDetails({required String digitalTheaterID}) async {
    _status = DefaultPageStatus.loading;
    try {
      _digitalTheaterDashBoardEntity = await _dtdashboardRepo.fetchdtDetails(
          digitalTheaterID: digitalTheaterID);
    } catch (e) {
      _status = DefaultPageStatus.failed;
      rethrow;
    } finally {
      _status = DefaultPageStatus.success;
      notifyListeners();
    }
  }

  /*fetching all the categories, languages, genres required upon editing the DTdata*/
  Future<void> fetchCategories() async {
    _status = DefaultPageStatus.loading;
    notifyListeners();
    try {
      _dtInfoFormEntity = await _dtdashboardRepo.fetchCategories();
    } catch (e) {
      _status = DefaultPageStatus.failed;
      rethrow;
    } finally {
      _status = DefaultPageStatus.success;
      notifyListeners();
    }
  }

  /*Editing the basic details*/
  Future<void> editBasicDTDetails() async {}

  /*Adding the cast data*/
  Future<void> addNewCastData({
    required String dtID,
    required String name,
    required String role,
    required File imageFile,
  }) async {}

  /*Adding the crew data*/
  Future<void> addNewCrewData({
  required  String dtID,
  required  String name,
  required  String role,
  required  File imageFile
  }) async {}

  /*Delete cast data*/
  Future<void> deleteCastData(
  {
  required BuildContext context,
  required String id ,
  required String name,
  required String role,
}
      ) async {}

  /*Delete crew data*/
  Future<void> deleteCrewData({
    required BuildContext context,
    required String id ,
    required String name,
    required String role,
}) async {}

  /*To publish and unpublish the seasons*/
  Future<void> publishSeason({required String seasonID}) async {}

  /*Delete season data*/
  Future<void> deleteSeason({required String digiID,required String seasonID}) async {}

  Future<void>editDigitalTheaterDetails({required BuildContext context, required int id, required String category, required String title, File? poster, required String year, required String certificate, required String genre, required String language, required String storyLine, required int uploadType, required hours, required minutes})async {}

  Future<void>deleteDtEpisode(int digiID, int seasonID, int episodeID)async {}

  Future<void>sendEpisodeData(BuildContext context, String string, String seasonID, String text, String text2, File? videoFilesEpisode, String text3) async{}

  addNewSeason({required String dt_id, required String title, File? trailerMediaFile, required String trailerMediaLink, required String year}) {}

  editDtSeason(String seasonId, String text, String showYear, String text2, File? videoFilesSeason) {}

  editCrewData({required String id, required String name, required String role, File? image}) {}

  editCastData({required String id, required String name, required String role, File? image}) {}

}
