import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/contest/megaAudition/rc_main_model/rc_contest_model.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';

class ContestMainRepo {
  final ApiService _apiService = ApiService();

  Future<RcMainDataModel> fetchContests() async {
    final response = await _apiService.post('/rc_fetch_contests', {});
    final dataModel = RcMainDataModel.fromJson(response);
    return dataModel;
  }

  Future<List<ContestEntity>> liveContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.liveCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    categoryName: category.title ?? '',
                    contestID: contest.id ?? 0,
                    mediaType: contest.mediaType ?? 1,
                    isPublished: contest.is_published,
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    banners: contest.banners!
                        .map((banner) => BannerEntity(
                            id: banner.id,
                            status: banner.status,
                            banner: banner.banner ?? '',
                            bpId: banner.bpId,
                            type: banner.type))
                        .toList(),
                    userMedia: contest.userMedia!
                        .map((usermedia) => UserMediaEntity(
                            id: usermedia.id,
                            media: usermedia.media,
                            mediaType: usermedia.mediaType,
                            thumbnail: usermedia.thumbnail,
                            status: usermedia.status))
                        .toList(),
                    guests: contest.guests!
                        .map((guest) => GuestEntity(
                            id: guest.id,
                            image: guest.image ?? '',
                            name: guest.name))
                        .toList(),
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }

  Future<List<ContestEntity>> upcomingContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.upcomingCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    categoryName: category.title ?? '',
                    mediaType: contest.mediaType ?? 1,
                    contestID: contest.id ?? 0,
                    isPublished: contest.is_published,
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    banners: contest.banners!
                        .map((banner) => BannerEntity(
                            id: banner.id,
                            status: banner.status,
                            banner: banner.banner ?? '',
                            bpId: banner.bpId,
                            type: banner.type))
                        .toList(),
                    userMedia: contest.userMedia!
                        .map((usermedia) => UserMediaEntity(
                            id: usermedia.id,
                            media: usermedia.media,
                            mediaType: usermedia.mediaType,
                            thumbnail: usermedia.thumbnail,
                            status: usermedia.status))
                        .toList(),
                    guests: contest.guests!
                        .map((guest) => GuestEntity(
                            id: guest.id,
                            image: guest.image ?? '',
                            name: guest.name))
                        .toList(),
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }

  Future<List<ContestEntity>> finishedContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.finishedCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    contestID: contest.id ?? 0,
                    mediaType: contest.mediaType ?? 1,
                    isPublished: contest.is_published,
                    banners: contest.banners!
                        .map((banner) => BannerEntity(
                            id: banner.id,
                            status: banner.status,
                            banner: banner.banner ?? '',
                            bpId: banner.bpId,
                            type: banner.type))
                        .toList(),
                    userMedia: contest.userMedia!
                        .map((usermedia) => UserMediaEntity(
                            id: usermedia.id,
                            media: usermedia.media,
                            mediaType: usermedia.mediaType,
                            thumbnail: usermedia.thumbnail,
                            status: usermedia.status))
                        .toList(),
                    guests: contest.guests!
                        .map((guest) => GuestEntity(
                            id: guest.id,
                            image: guest.image ?? '',
                            name: guest.name))
                        .toList(),
                    categoryName: category.title ?? '',
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }

  Future<void> saveContests({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    final response = await _apiService.sendMultipartRequest(
        endpoint: '/add_contest_media', fields: fields, files: files);
    return response;
  }

  Future<void> editContest({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    final response = await _apiService.sendMultipartRequest(
        endpoint: '/edit_contest_media', fields: fields, files: files);
    return response;
  }
}
