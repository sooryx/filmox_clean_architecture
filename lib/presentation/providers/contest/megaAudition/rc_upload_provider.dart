import 'dart:io';
import 'package:filmox_clean_architecture/data/repositories/contest/megaAudition/contest_main/contest_main_repo.dart';
import 'package:flutter/cupertino.dart';

enum ContestUploadStatus { initial, loading, success, failed }

class RcUploadProvider with ChangeNotifier {
  ContestMainRepo _contestRepo = ContestMainRepo();
  String _errorMessage = '';

  File? mediaFile;
  File? thumbnail;

  ContestUploadStatus _saveContestStatus = ContestUploadStatus.initial;

  void selectMediaFile(File file) {
    mediaFile = file;
    notifyListeners();
  }

  void selectThumbnailFile(File file) {
    thumbnail = file;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  ContestUploadStatus get saveContestStatus => _saveContestStatus;

  Future<void> saveContest({required int id}) async {
    _saveContestStatus = ContestUploadStatus.loading;
    notifyListeners();
    Map<String, File> _files = {'media': mediaFile!, 'thumbnail': thumbnail!};
    Map<String, String> _id = {
      'contest_id': id.toString(),
    };
    try {
      final response =
          await _contestRepo.saveContests(fields: _id, files: _files);
      return response;
    } on Exception catch (e) {
      _saveContestStatus = ContestUploadStatus.failed;
      _errorMessage = e.toString();
    } finally {
      _saveContestStatus = ContestUploadStatus.success;
      notifyListeners();
    }
  }

  Future<void> editContest({required int id}) async {
    _saveContestStatus = ContestUploadStatus.loading;
    notifyListeners();
    Map<String, File> _files = {'media': mediaFile!, 'thumbnail': thumbnail!};
    Map<String, String> _id = {
      'contest_id': id.toString(),
    };
    try {
      final response =
          await _contestRepo.saveContests(fields: _id, files: _files);
      return response;
    } on Exception catch (e) {
      _saveContestStatus = ContestUploadStatus.failed;
      _errorMessage = e.toString();
    } finally {
      _saveContestStatus = ContestUploadStatus.success;
      notifyListeners();
    }
  }
}
