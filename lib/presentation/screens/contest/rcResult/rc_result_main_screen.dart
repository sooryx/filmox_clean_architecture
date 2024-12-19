


import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/components/contest/result/rc_result_cards.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rc_result_main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<RegularContestMainResultScreenProvider>(
        builder: (context, provider, child) {
          return widget.isPublished
              ? provider.isResultsLoading
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
    final provider = Provider.of<RegularContestMainResultScreenProvider>(
        context,
        listen: false);
    // if (provider.contestFeedModel?.data.id != widget.contestID) {
    // await provider.fetchContest(contestId: widget.contestID);
    await provider.fetchMainScreenResults(widget.contestId);
    // _checkIfDialogShown();
    // }
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
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width:
                      _selectedFilter == FilterType.topVoted ? 13.w : 10.h,
                      height:
                      _selectedFilter == FilterType.topVoted ? 13.h : 10.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF63FD88),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF63FD88).withOpacity(0.7),
                            spreadRadius:
                            _selectedFilter == FilterType.topVoted ? 4 : 1,
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("Top voted"),
                  ],
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
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
                    const Text("Judge selected"),
                  ],
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
    final provider = Provider.of<RegularContestMainResultScreenProvider>(
        context,
        listen: false);

    // Filter the results based on the selected filter state
    final filteredData = provider.rcMainResultsModel?.data?.where((item) {
      if (_selectedFilter == FilterType.topVoted) {
        return item.selectedBy != 'judge';
      } else if (_selectedFilter == FilterType.judgeSelected) {
        return item.selectedBy == 'judge';
      }
      return true; // Show all results if no filter is applied
    }).toList();

    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredData?.length ?? 0,
        itemBuilder: (context, index) {
          String defaultProPic =
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnSA1zygA3rubv-VK0DrVcQ02Po79kJhXo_A&s';
          String? userImage = filteredData?[index]
              .user
              ?.profile
              ?.profilePhoto !=
              null
              ? '${UrlStrings.imageUrl}${filteredData?[index].user?.profile?.profilePhoto}'
              : defaultProPic;
          String userName = filteredData?[index].user?.name ?? "";
          String selectedBy = filteredData?[index].selectedBy ?? "votes";
          int totalVotes = filteredData?[index].totalVotes ?? 0;
          String judgeReview = filteredData?[index].judgeReview ?? "";

          return ResultCards(
            name: userName,
            vote: totalVotes,
            image: userImage,
            selectedByJudge: selectedBy == 'judge',
            judgeReview: judgeReview,
          );
        },
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16 * 2.5),
        ],
      ),
    );
  }
}
