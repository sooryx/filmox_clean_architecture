import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/components/digitaltheater/individual_video_player.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:filmox_clean_architecture/widgets/youtube_video_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'episode_widget_individual.dart';

class IndividualEpisodePage extends StatefulWidget {
  final EpisodeEntity selectedEpisode;
  final List<EpisodeEntity> episodesList;
  final SeasonEntity currentSeason;

  const IndividualEpisodePage({
    super.key,
    required this.selectedEpisode,
    required this.episodesList,
    required this.currentSeason,
  });

  @override
  State<IndividualEpisodePage> createState() => _IndividualEpisodePageState();
}

class _IndividualEpisodePageState extends State<IndividualEpisodePage> {
  EpisodeEntity? _currentEpisode;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.selectedEpisode;
  }

  void _updateEpisode(EpisodeEntity episode) {
    setState(() {
      _currentEpisode = episode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: orientation == Orientation.landscape
              ? null
              : AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text(
                    _currentEpisode?.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: [
                    const Icon(
                      Icons.share,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                ),
          body: orientation == Orientation.landscape
              ? _currentEpisode!.isYoutubeUrl
                  ? YouTubePlayerWidget(
                      key: ValueKey(_currentEpisode?.mediaLink),
                      height: 240.h,
                      width: MediaQuery.of(context).size.width,
                      videoUrl: _currentEpisode?.mediaLink ?? "",
                      showControls: true)
                  : VideoPlayerWidget(
                      key: ValueKey(_currentEpisode?.mediaLink),
                      height: 240.h,
                      width: MediaQuery.of(context).size.width,
                      url: UrlStrings.videoUrl +
                          (_currentEpisode?.mediaLink ?? ""),
                      loadingWidget: Loadingscreen())
              : ListView(
                  children: [
                    header(),
                    episodes(),
                  ],
                ),
        );
      },
    );
  }

  Widget episodes() {
    return ListView.builder(
        itemCount: widget.episodesList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final episode = widget.episodesList[index];

          return InkWell(
            onTap: () {
              _updateEpisode(episode);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: EpisodeWidgetIndividualPage(
                videoUrl: widget.episodesList[index].mediaLink,
                title: widget.episodesList[index].name,
                episodenumber: index + 1,
                // currentPlaying: '1',
                index: index.toString(),
              ),
            ),
          );
        });
  }

  Widget header() {
    return Column(
      children: [
        _currentEpisode!.isYoutubeUrl
            ? YouTubePlayerWidget(
                key: ValueKey(_currentEpisode?.mediaLink),
                height: 240.h,
                width: MediaQuery.of(context).size.width,
                videoUrl: _currentEpisode?.mediaLink ?? "",
                showControls: true)
            : VideoPlayerWidget(
                key: ValueKey(_currentEpisode?.mediaLink),
                height: 240.h,
                width: MediaQuery.of(context).size.width,
                url:
                    "${UrlStrings.videoUrl}${_currentEpisode?.mediaLink ?? ""}",
                loadingWidget: Loadingscreen(),
              ),
        SizedBox(height: 20.h),
        Text(
          widget.currentSeason.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          _currentEpisode?.name ?? "Episode",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Text(
          'Film Series · 2023 · 2 hrs 37 min',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => IndividualVideoPlayer(
                              title: widget.currentSeason.name,
                              isYoutube: widget.currentSeason.isYoutubeurl,
                              videoUrl: widget.currentSeason.trailer,
                            )));
              },
              child: Container(
                padding: EdgeInsets.all(8.dg),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 4.w),
                    const Text(
                      "Watch Trailer",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 330.w,
          child: Text(
            "Season ${widget.currentSeason.name}, Episode ${_currentEpisode?.name ?? ""}: ${_currentEpisode?.descritption ?? "No description available"}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(Icons.four_k,
                  color: Colors.white.withOpacity(0.5), size: 22.sp),
              Icon(Icons.closed_caption,
                  color: Colors.white.withOpacity(0.5), size: 22.sp),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 16.sp),
              Text(
                ' 4.0',
                style: TextStyle(fontSize: 11.sp),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        CommonWidgets.CustomDivider(
          start: 10,
          end: 10,
          thickness: 0.5,
          color: Colors.white,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
