import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_feed_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class VoteWidget extends StatelessWidget {
  final ContestMediaitemsEntity currentContest;

  VoteWidget({
    super.key,
    required this.currentContest,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RcFeedProvider>(
      builder: (context, provider, child) {
        final bool isVoted = currentContest.isVoted;

        return InkWell(
          onTap: () async {
            try {
              final voteMessage = await provider.castVotes(
                mediaId: currentContest.mediaID.toString(),
                contestId: currentContest.contestID.toString(),
              );
              await provider.fetchContestFeedItems(
                contestID: currentContest.contestID.toString(),
              );
              print("voteMessage : $voteMessage");
              customSuccessToast(context, voteMessage);
            } catch (e) {
              if (e
                  .toString()
                  .contains("You have already voted for another media")) {
                showCustomDialog(
                  context: context,
                  title: "Already voted !",
                  contentText1:
                      "You have already voted for another media. Please remove your previous vote before voting again.",
                  onCancel: () {},
                  onConfirm: () {
                    Navigator.pop(context);
                  },
                );
              } else {
                print(e.toString());
                customErrorToast(context, e.toString());
              }
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.center,
            width: 120.w,
            height: 50.h,
            child: provider.voteLoading == DefaultPageStatus.loading
                ? Lottie.asset(
                    AppConstants.votedLottie,
                    fit: BoxFit.cover,
                  )
                : CustomPaint(
                    painter: RoundedRectangleBorderPainter(
                      borderRadius: 20,
                      strokeWidth: 2,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1CB5E0),
                          Color(0xFF003780),
                          Color(0xFF1CB5E0),
                          Color(0xFF003780),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 25.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isVoted ? 'Unvote' : 'Vote',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              isVoted
                                  ? Icons.thumb_down_sharp
                                  : Icons.thumb_up_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 15.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
