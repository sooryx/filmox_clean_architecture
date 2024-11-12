import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'episode_widget.dart';
import 'individual_episode_page.dart';


class SelectSeasonAndEpisodes extends StatefulWidget {
  final List<SeasonEntity> seasons;

  const SelectSeasonAndEpisodes({super.key, required this.seasons});

  @override
  State<SelectSeasonAndEpisodes> createState() =>
      _SelectSeasonAndEpisodesState();
}

class _SelectSeasonAndEpisodesState extends State<SelectSeasonAndEpisodes> {
  int? selectedSeasonIndex;
  late List<SeasonEntity> filteredSeasons;

  @override
  void initState() {
    super.initState();

    // Filter out seasons with no episodes
    filteredSeasons = widget.seasons.where((season) => season.episodes.isNotEmpty).toList();

    // Set the selected season index to the first season with episodes, if available
    selectedSeasonIndex = filteredSeasons.isNotEmpty ? 0 : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets.CustomDropDown(
          context: context,
          hintText: 'Select season',
          items: List.generate(
            filteredSeasons.length,
                (index) => "Season ${index + 1}",
          ),
          selectedValue: selectedSeasonIndex != null
              ? "Season ${selectedSeasonIndex! + 1}"
              : null,
          onChanged: (value) {
            setState(() {
              selectedSeasonIndex = int.parse(value!.split(' ')[1]) - 1;
            });
          },
          buttonWidth: 150.w,
          buttonHeight: 40.h,
        ),
        const SizedBox(
          height: 20,
        ),
        selectedSeasonIndex != null
            ? filteredSeasons[selectedSeasonIndex!].episodes.isNotEmpty
            ? SizedBox(
          height: 300.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: filteredSeasons[selectedSeasonIndex!].episodes.length,
            itemBuilder: (context, index) {
              final selectedSeason = filteredSeasons[selectedSeasonIndex!];
              final episode = selectedSeason.episodes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualEpisodePage(
                          currentSeason: selectedSeason,
                          selectedEpisode: episode,
                          episodesList: selectedSeason.episodes,
                        ),
                      ),
                    );
                  },
                  child: EpisodeWidget(
                    title: episode.name ,
                    videoUrl:episode.isYoutubeUrl ?  episode.mediaLink : (UrlStrings.videoUrl+episode.mediaLink),
                    description: episode.descritption ,
                    episodenumber: (index + 1).toString(),
                  ),
                ),
              );
            },
          ),
        )
            : Center(
          child: SizedBox(
            height: 150.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset(AppConstants.noEpisodes, height: 120.h, fit: BoxFit.fill),
                Text(
                  "No episodes available!",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        )
            : const Center(
          child: Text("Select a season"),
        ),
      ],
    );
  }
}

