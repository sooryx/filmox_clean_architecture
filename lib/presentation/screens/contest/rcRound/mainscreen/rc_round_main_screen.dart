
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/rounds/rounds_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rounds/rc_rounds_main_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../components/contest/rounds/rounds_cards.dart';
import '../widgets/rounds_header_page_view.dart';


class RcRoundMainScreen extends StatefulWidget {
  final String id;

  const RcRoundMainScreen({
    super.key,
    required this.id,
  });

  @override
  State<RcRoundMainScreen> createState() => _RcRoundMainScreenState();
}

class _RcRoundMainScreenState extends State<RcRoundMainScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        getData();
      },
    );
  }

  getData() async {
    try{
      final provider =
      Provider.of<RcRoundsMainProvider>(context, listen: false);
      await provider.fetchRounds(contestID: widget.id);
    }catch(e){
      print("Error:${e.toString()}");
    }
  }

  RoundsEntity? activeRounds ;
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<RcRoundsMainProvider>(context, listen: true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: provider.status == DefaultPageStatus.loading ?const Loadingscreen():Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  UrlStrings.imageUrl + provider.activeRound!.poster),
              opacity: 0.1,
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              physics: const PageScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 20.h,
                    expandedHeight:
                    MediaQuery.of(context).size.height - 80.h,
                    collapsedHeight: 250.h,
                    leading: const SizedBox.shrink(),
                    flexibleSpace: FlexibleSpaceBar(
                      background: RoundsHeaderPageView(
                        dataKey: dataKey,
                        activeRounds: provider.activeRound!,
                        allRounds: provider.roundsEntity,
                        scrollController: _scrollController,
                        isVideo:  provider.activeRound!.isVideo,
                      )
                          .animate()
                          .scaleXY(
                          duration: 800.ms,
                          end: 1,
                          begin: 0.98,
                          alignment: Alignment.center)
                          .fadeIn(delay: 300.ms, duration: 800.ms),
                      centerTitle: true,
                    ),
                  ),
                ];
              },
              body: _buildContent(context),
            ),
          ],
        ),

      ),
    );
  }


  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonWidgets.CustomDivider(
              start: 10, end: 10, thickness: 5, color: Colors.white),
          _buildRounds(context),
        ],
      ),
    );
  }

  Widget _buildRounds(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(10.dg),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.black54.withOpacity(0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rounds",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.h),
            _buildRoundsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundsList(BuildContext context) {
    final provider =
    Provider.of<RcRoundsMainProvider>(context, listen: true);
    List<RoundsEntity> roundsList = List.from(provider.roundsEntity);
    final active = provider.activeRound;

    // Move active round to the top of the list if it exists
    if (active != null) {
      roundsList.removeWhere((round) => round.roundNumber == active.roundNumber);
      roundsList.insert(0, active);
    }

    return ListView.builder(
      key: dataKey,
      itemCount: roundsList.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final offset = index % 4 == 0
            ? const Offset(-1, 0)
            : index % 4 == 1
            ? const Offset(1, 0)
            : index % 4 == 2
            ? const Offset(0, -1)
            : const Offset(0, 1);
        return Animate(
          effects: [
            SlideEffect(
              begin: offset,
              end: Offset.zero,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
            FadeEffect(
              duration: 600.ms,
              curve: Curves.easeIn,
            ),
          ],
          child: RoundsBanner(
            title: roundsList[index].title,
            image: roundsList[index].poster,
            voteDate: roundsList[index].voteDate,
            endDate: roundsList[index].endDate,
            description: roundsList[index].megaRoundDescription,
            color: Colors.white.withOpacity(0.1),
            index: roundsList[index].roundNumber,
            isCompleted: roundsList[index].voteDate.isBefore(DateTime.now()),
            isVideo: roundsList[index].isVideo
          ),
        );
      },
    );
  }
}
