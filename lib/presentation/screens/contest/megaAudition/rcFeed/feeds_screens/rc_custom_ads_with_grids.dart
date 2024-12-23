// ignore: unused_import
// ignore_for_file: unnecessary_null_comparison, unused_import, duplicate_ignore

import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:filmox_clean_architecture/presentation/components/contest/feeds/ThumbnailGridItemContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RCCustomGridWithAds extends StatefulWidget {
  final List<String> listB;
  final ContestFeedEntity? contestInfo;

  RCCustomGridWithAds({
    super.key,
    required this.listB,
    this.contestInfo,
  });

  @override
  State<RCCustomGridWithAds> createState() => _RCCustomGridWithAdsState();
}

class _RCCustomGridWithAdsState extends State<RCCustomGridWithAds> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<ContestMediaitemsEntity> contestMediaList =
        widget.contestInfo?.contestMedias ?? [];
    if (contestMediaList == null || contestMediaList.isEmpty) {
      return const Center(child: Text('No items available'));
    }

    final int itemCount = contestMediaList.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Hero(
          tag: widget.contestInfo!.title,
          child: Text(
            widget.contestInfo!.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 18.sp),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "All contest media",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                interactive: true,
                thickness: 6,
                child: ListView.builder(
                  controller: _scrollController,
                  cacheExtent: 30,
                  dragStartBehavior: DragStartBehavior.down,
                  itemCount: _calculateListViewItemCount(itemCount),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      int end = itemCount >= 6 ? 6 : itemCount;
                      return _buildGridView(contestMediaList.sublist(0, end));
                    } else if (index == 1 && widget.listB.isNotEmpty) {
                      return _buildAd(widget.listB[0]);
                    } else if (index == 2 && itemCount > 6) {
                      int end = itemCount >= 15 ? 15 : itemCount;
                      return _buildGridView(contestMediaList.sublist(6, end));
                    } else if (index == 3 &&
                        widget.listB.length > 1 &&
                        itemCount > 6) {
                      return _buildAd(widget.listB[1]);
                    } else if (index == 4 && itemCount > 15) {
                      return _buildGridView(contestMediaList.sublist(15));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<ContestMediaitemsEntity> items) {
    return GridView.builder(
      padding: EdgeInsets.all(10.dg),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        String mediaUrl = items[index].file;

        return ThumbnailGridItemContainer(
          mediaUrl: mediaUrl,
          thumbnail:  items[index].thumbnail,
          height: 40.h,
          width: 40.w,
        );
      },
    );
  }

  Widget _buildAd(String adContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Center(
          child: Text(
            adContent,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  int _calculateListViewItemCount(int itemCount) {
    int count = 1;
    if (itemCount > 6) count++;
    if (itemCount > 6) count++;
    if (widget.listB.length > 1 && itemCount > 6) count++;
    if (itemCount > 15) count++;
    return count;
  }
}
