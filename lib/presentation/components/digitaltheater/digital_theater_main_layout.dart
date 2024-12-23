import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_main/digital_theater_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/individual/individual_dt_main_screen.dart';
import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class ReusableDigitalTheaterPage extends StatefulWidget {
  final List<TabsEntity> categories;
  final List<AllDTEntity> allTheaters;
  final List<BannersEntity> banners;
   ReusableDigitalTheaterPage({
    Key? key,
    required this.categories,
    required this.allTheaters,
    required this.banners,
  }) : super(key: key);

  @override
  _ReusableDigitalTheaterPageState createState() => _ReusableDigitalTheaterPageState();
}

class _ReusableDigitalTheaterPageState extends State<ReusableDigitalTheaterPage> {
  int current = 0;
  int currentBannerIndex = 0;
  PageController pageController = PageController();
  PageController bannerPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          if (mounted) {
            final provider =
            Provider.of<DigitalTheaterProvider>(context, listen: false);
            // provider.fetchTabs();
            provider.fetchApi();
          }
        },
        child: CustomScrollView(
          slivers: [
    SliverAppBar(
                pinned: false,
                expandedHeight: 220.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView.builder(
                    controller: bannerPageController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentBannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final pageScale = currentBannerIndex == index ? 1.0 : 0.9;
                      if (widget.banners[index].type == '1') {
                        return AnimatedScale(
                          scale: pageScale,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Center(
                            child: Container(
                              height: 220.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    "${UrlStrings.imageUrl}${widget.banners[index].banner}",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (widget.banners[index].type == '2') {
                        return AnimatedScale(
                          scale: pageScale,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Center(
                            child: SizedBox(
                              height: 220.h,
                              child: BannerVideoPlayerWithControls(
                                videoUrl: UrlStrings.videoUrl +
                                    widget.banners[index].banner,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("Unsupported banner type"),
                        );
                      }
                    },
                  ),
                ),
              ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _CategorySelectorDelegate(
                minHeight: 70.h,
                maxHeight: 70.h,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.categories.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    bool isSelected = current == index;

                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                          pageController.jumpToPage(index);
                        },
                        child: _buildCategoryItem("All", isSelected, 100.w),
                      );
                    } else {
                      var categoryIndex = index - 1;
                      var category = widget.categories[categoryIndex];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                          pageController.jumpToPage(index);
                        },
                        child: _buildCategoryItem(category.tabName, isSelected, 120.w),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 1200.h,
                child: PageView.builder(
                  itemCount: widget.categories.length + 1,
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      current = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return allCategoryContent(widget.allTheaters);
                    } else {
                      var categoryIndex = index - 1;
                      var category = widget.categories[categoryIndex];
                      return categoryContent(category);
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


  Widget allCategoryContent(List<AllDTEntity> all) {
    List<AllDTEntity> filteredSections =
    all.where((section) => section.digitalTheaterEntity.isNotEmpty).toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filteredSections.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, sectionIndex) {
        final section = filteredSections[sectionIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.sectionName[0].toUpperCase() + section.sectionName.substring(1),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                itemCount: section.digitalTheaterEntity.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, digitalTheaterIndex) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => IndividualDigitalTheaterScreen(
                            digitalTheaterData: section.digitalTheaterEntity[digitalTheaterIndex],
                            fromProfile: false,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: section.digitalTheaterEntity[digitalTheaterIndex].name,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          height: 80.h,
                          width: 140.w,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                "${UrlStrings.imageUrl}${section.digitalTheaterEntity[digitalTheaterIndex].poster}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget categoryContent(TabsEntity category) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: category.digitalTheaterEntity.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.65),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          IndividualDigitalTheaterScreen(
                            digitalTheaterData:
                            category.digitalTheaterEntity[index],
                            fromProfile: false,
                          )));
            },
            child: Hero(
              tag: category.digitalTheaterEntity[index].name,
              child: ClipRRect(
                child: Container(
                  height: 80.h,
                  width: 140.w,
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        "${UrlStrings.imageUrl}${category.digitalTheaterEntity[index].poster}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ).animate().fadeIn(),
            ),
          );
                });
  }


  Widget _buildCategoryItem(String title, bool isSelected, double width) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 800),
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      height: 40.h,
      width: width,
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1CB5E0).withOpacity(0.35),
            const Color(0xFF1CB5E0).withOpacity(0.15),
          ],
        )
            : null,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            title,
            key: ValueKey<bool>(isSelected),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isSelected ? Theme.of(context).colorScheme.surface : Colors.grey.shade500,
              fontSize: isSelected ? 18.sp : 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
class _CategorySelectorDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _CategorySelectorDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_CategorySelectorDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
