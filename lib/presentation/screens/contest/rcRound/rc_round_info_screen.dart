import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RoundInfoScreen extends StatelessWidget {
  final Round round;

  const RoundInfoScreen({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.5)),
                child: Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10.sp,
                )),
            SizedBox(
              width: 5.w,
            ),
            Text(round.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 25.sp)),
          ],
        ),
      ),

      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('https://c1.wallpaperflare.com/preview/695/338/530/artist-entertainment-facial-expression-lights.jpg'),fit: BoxFit.cover,opacity: 0.2)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text("Other Rounds",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: round.otherRounds?.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final otherRound = round.otherRounds?[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: otherRound?.status == RoundStatus.upcoming
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.grey[900],
                          ),
                          child: Theme(
                            data:
                            ThemeData().copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              enableFeedback: true,
                              title: Text(otherRound?.title ?? "",
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                "${otherRound?.status == RoundStatus.finished ? "Finished" : "Upcoming"} ${otherRound?.date}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              backgroundColor:
                              otherRound?.status == RoundStatus.upcoming
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.grey[900],
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CachedNetworkImage(
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    'https://i.pinimg.com/736x/48/f6/43/48f6438452fa253674472472fb6165cc.jpg'),
                              ),
                              trailing: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: otherRound?.status == RoundStatus.finished
                                          ? Colors.red.withOpacity(0.5)
                                          : Colors.blue.withOpacity(0.5)),
                                  child: Icon(
                                    Icons.circle,
                                    color: otherRound?.status == RoundStatus.finished
                                        ? Colors.red
                                        : Colors.blue,
                                    size: 10.sp,
                                  )),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    otherRound?.description ??
                                        "No description available",
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Text(round.title,
                        style: const TextStyle(fontSize: 24, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(round.description,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[700]),
                    _buildGuestList(context),

                  ],
                ),
              ),
              _buildBottomNavbar(context),

            ],
          ),
        ),
      ),
    );
  }

  _buildBottomNavbar(context) {
    return CommonWidgets.CustomGlassButton(
      buttonHeight: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Edit Your Uploaded Media",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            "Ends in  45 Seconds",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5)),
          ),
        ],
      ),
      onTap: () {},
      context: context,
      buttonText: '',
    );
  }

  Widget _buildGuestList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Guests", style: Theme.of(context).textTheme.headlineMedium),
            Expanded(
              child: CommonWidgets.CustomDivider(
                  start: 1, end: 1, thickness: 1, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Guest guest = Guest(
                  name: "Bobby Deol",
                  image:
                  'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRECoj4Z_A5iT-11NlrtzHyO1sW5CdDUNRAcEeY7RAK8SwMwhRE');
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 120.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(guest.image),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    guest.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 16.sp),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class Round {
  final String title;
  final String date;
  final RoundStatus status;
  final String description;
  final List<Round>? otherRounds;

  Round(
      {required this.title,
        required this.date,
        required this.status,
        required this.description,
        this.otherRounds});
}

class Guest {
  final String name;
  final String image;

  Guest({required this.name, required this.image});
}

enum RoundStatus { active, finished, upcoming }
