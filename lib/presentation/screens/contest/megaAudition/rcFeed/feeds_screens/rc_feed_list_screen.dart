import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:filmox_clean_architecture/presentation/components/contest/feeds/thumbnail_list_item_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegularContestFeedListScreen extends StatefulWidget {
  final int index;
  final List<ContestMediaitemsEntity> items;
  final Widget? headerWidget;

  const RegularContestFeedListScreen(
      {super.key, required this.index, required this.items, this.headerWidget});

  @override
  _RegularContestFeedListScreenState createState() =>
      _RegularContestFeedListScreenState();
}

class _RegularContestFeedListScreenState
    extends State<RegularContestFeedListScreen> {
  late PageController _pageController;

  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.index;
    _pageController = PageController(
      viewportFraction: 1,
    );
  }

  // Helper function to calculate item count including ads
  int _calculatePageCount(int originalItemCount) {
    // Calculate total pages needed
    int adCount = (originalItemCount ~/ 6) + (originalItemCount ~/ 9);
    return originalItemCount + adCount;
  }

  // Function to determine if the current page is an ad page
  bool _isAdPage(int pageIndex) {
    // Ad pages appear after 6 and 9 items, then repeat
    int itemsBeforePage = _getItemCountBeforePage(pageIndex);
    return (itemsBeforePage + 1) % 15 == 7 || (itemsBeforePage + 1) % 15 == 0;
  }

  // Helper function to get the number of items before a specific page
  int _getItemCountBeforePage(int pageIndex) {
    // Calculate the total number of items up to the previous page
    int items = pageIndex * 6; // Assuming each page shows 6 items
    // Add space for ads before the current page
    int adsBefore = (items ~/ 6) + (items ~/ 9);
    return items + adsBefore;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _calculatePageCount(widget.items.length),
        onPageChanged: (pageIndex) {
          setState(() {
            _activeIndex = pageIndex;
          });
        },
        itemBuilder: (context, pageIndex) {
          if (_isAdPage(pageIndex)) {
            return _buildAd(pageIndex);
          } else {
            int adjustedIndex = _getItemIndexForPage(pageIndex);
            if (adjustedIndex < widget.items.length) {
              final item = widget.items[adjustedIndex];
              bool isActive = adjustedIndex == _activeIndex;
              print(
                  "Index $adjustedIndex is ${isActive ? 'active' : 'inactive'}");

              if (pageIndex == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.headerWidget!,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          "All Contest",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.sp,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.dg),
                      child: Container(
                        padding: EdgeInsets.all(5.dg),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.white.withOpacity(0.1)),
                        child: ThumbnailListItemContainer(
                          isActive: isActive,
                          isVideo: item.mediaType == 1,
                          mediaUrl:  item.file,
                          currentContest: item,
                          thumbnailUrl: item.thumbnail,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return ThumbnailListItemContainer(
                  isActive: isActive,
                  isVideo: item.mediaType == 1,
                  mediaUrl: item.file
                      ,
                  currentContest: item,
                  thumbnailUrl: UrlStrings.imageUrl + item.thumbnail,
                );
              }
            } else {
              return _buildNoMoreItems();
            }
          }
        });
  }

  // Helper function to get the item index for the page
  int _getItemIndexForPage(int pageIndex) {
    // Calculate the starting item index for the given page
    int itemsBeforePage = _getItemCountBeforePage(pageIndex);
    return itemsBeforePage ~/ 6; // Assuming each page shows 6 items
  }

  // Function to build ad widget
  Widget _buildAd(int pageIndex) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text('Ad for page $pageIndex',
            style: const TextStyle(fontSize: 24, color: Colors.grey)),
      ),
    );
  }

  // Function to build 'No more items' widget
  Widget _buildNoMoreItems() {
    return const Center(
      child: Text('No more items',
          style: TextStyle(fontSize: 24, color: Colors.grey)),
    );
  }
}
