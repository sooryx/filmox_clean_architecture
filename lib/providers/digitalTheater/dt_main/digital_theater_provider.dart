import 'package:filmox_clean_architecture/data/models/digitalTheater/dt_main/digital_theater_main_model.dart';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/dt_main/digitalTheater_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';
import 'package:flutter/material.dart';

enum DTMainPageStatus {
  initial,
  loading,
  success,
  failed,
  bannerinitial,
  bannerloading,
  bannersuccess,
  bannerfailed,
}
class DigitalTheaterProvider with ChangeNotifier {

  final DigitaltheaterRepo _repository = DigitaltheaterRepo();
  DTMainPageStatus _status = DTMainPageStatus.initial;
  String _errorMessage = '';

  DTMainPageStatus get status => _status;
  String get errorMessage => _errorMessage;

  List<TabsEntity> _tabs = [];
  List<AllDTEntity>_allDT =[];
  List<BannersEntity> _banners = [];

  List<TabsEntity> get tabs => _tabs;
  List<AllDTEntity> get allDT => _allDT;
  List<BannersEntity> get banners => _banners;

  Future<void> fetchTabs(DigitalTheaterMainPageModel dataModel) async {
    try {
      _tabs = await _repository.fetchtabEntity(dataModel);
      _allDT = await _repository.fetchAllDt(dataModel);
      _status = DTMainPageStatus.success;
    } catch (e) {
      _errorMessage = 'Failed to fetch tabs: $e';
      _status = DTMainPageStatus.failed;
    }
    notifyListeners();
  }

  Future<void>fetchBanners(DigitalTheaterMainPageModel dataModel) async {
    try {
      _banners = await _repository.fetchBanner(dataModel);
      _status = DTMainPageStatus.bannersuccess;
    } catch (e) {
      _errorMessage = 'Failed to fetch banners: $e';
      _status = DTMainPageStatus.bannerfailed;
    }
    notifyListeners();
  }


  Future<void>fetchApi()async{
    final dataModel = await _repository.fetchDTMainData();
    await fetchBanners(dataModel);
    await fetchTabs(dataModel);
  }
}
