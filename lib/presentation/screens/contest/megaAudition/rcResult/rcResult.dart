import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_main_result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'widgets/error_info.dart';
import 'widgets/result_cards.dart';

class RCResultMainScreen extends StatefulWidget {
  final int contestId;
  final String imageUrl;
  final String contestName;
  final bool isPublished;

  const RCResultMainScreen(
      {super.key,
      required this.contestId,
      required this.imageUrl,
      required this.contestName,
      required this.isPublished});

  @override
  State<RCResultMainScreen> createState() => _RCResultMainScreenState();
}

enum FilterType { all, topVoted, judgeSelected }

class _RCResultMainScreenState extends State<RCResultMainScreen> {
  FilterType _selectedFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _builAppbar(),
      body: Consumer<RcMainResultProvider>(
        builder: (context, provider, child) {
          return widget.isPublished
              ? provider.status == DefaultPageStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        _buildAdvertisment(),
                        _buildIndicators(),
                        _buildCards(),
                      ],
                    )
              : _noResults();
        },
      ),
    );
  }

  getData() async {
    final provider = Provider.of<RcMainResultProvider>(context, listen: false);

    await provider.fetchResults(contestID: widget.contestId.toString());
  }

  AppBar _builAppbar() {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Hero(
          tag: 'bg',
          child: Row(
            children: [
              SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Text(
                widget.contestName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18.sp),
              ),
            ],
          ),
        ));
  }

  Widget _noResults() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Spacer(flex: 1),
          SizedBox(
            height: 250.h,
            width: 250.w,
            child: Lottie.asset(AppConstants.noResult, fit: BoxFit.cover),
          ),
          const Spacer(flex: 1),
          ErrorInfo(
            title: "Results Pending !",
            description:
                "The Judges Have Not Published the Outcomes Yet. Please Stay Tuned Until the Official Announcement is Released.",
            // button: you can pass your custom button,
            btnText: "Search again",
            press: () {},
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildAdvertisment() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              "https://www.digitaltrends.com/wp-content/uploads/2023/04/Gwen-Stacy-2.jpg?fit=500%2C210&p=1"),
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = _selectedFilter == FilterType.topVoted
                        ? FilterType.all
                        : FilterType.topVoted;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    children: [
                      Container(
                        width: _selectedFilter == FilterType.topVoted
                            ? 13.w
                            : 10.h,
                        height: _selectedFilter == FilterType.topVoted
                            ? 13.h
                            : 10.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF63FD88),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF63FD88).withOpacity(0.7),
                              spreadRadius:
                                  _selectedFilter == FilterType.topVoted
                                      ? 4
                                      : 1,
                              blurRadius: 6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Top voted",
                        style: TextStyle(
                            color: _selectedFilter == FilterType.topVoted
                                ? Colors.green
                                : Colors.white,
                            fontSize: _selectedFilter == FilterType.topVoted
                                ? 18.sp
                                : 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter =
                        _selectedFilter == FilterType.judgeSelected
                            ? FilterType.all
                            : FilterType.judgeSelected;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    children: [
                      Container(
                        width: _selectedFilter == FilterType.judgeSelected
                            ? 13.w
                            : 10.h,
                        height: _selectedFilter == FilterType.judgeSelected
                            ? 13.h
                            : 10.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCCF3A),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFCCF3A).withOpacity(0.7),
                              spreadRadius:
                                  _selectedFilter == FilterType.judgeSelected
                                      ? 4
                                      : 1,
                              blurRadius: 6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Judge Selected",
                        style: TextStyle(
                            color: _selectedFilter == FilterType.judgeSelected
                                ? Colors.yellow
                                : Colors.white,
                            fontSize:
                                _selectedFilter == FilterType.judgeSelected
                                    ? 18.sp
                                    : 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            textAlign: TextAlign.center,
            "Tap the play button to see the judge's review",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }

  Widget _buildCards() {
    final provider = Provider.of<RcMainResultProvider>(context, listen: false);

    final filteredData = provider.resultsList.where((item) {
      if (_selectedFilter == FilterType.topVoted) {
        return item.isTopVoted;
      } else if (_selectedFilter == FilterType.judgeSelected) {
        return item.isSelectedByJudge;
      }
      return true;
    }).toList();

    if (filteredData.isEmpty) {
      // Display a message when there are no contestants
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              width: 200.w,
              child: Lottie.asset(AppConstants.noResult, fit: BoxFit.cover),
            ),
            SizedBox(height: 40.h,),
            Text(
              "No contestants available.",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];
          return ResultCards(
            name: item.userName,
            vote: item.totalVotes,
            image: item.userPicture,
            selectedByJudge: item.isSelectedByJudge,
            judgeReview: item.judgeReview ?? "",
          );
        },
      ),
    );
  }


}
