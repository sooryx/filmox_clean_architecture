import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class CricketDashboardWidget extends StatelessWidget {
  final String backgroundImageUrl;
  final String logoImageUrl;
  final String title;
  final String description;
  final bool isLive;
  final VoidCallback onWatchPressed;

  const CricketDashboardWidget({
    Key? key,
    required this.backgroundImageUrl,
    required this.logoImageUrl,
    required this.title,
    required this.description,
    required this.onWatchPressed,
    required this.isLive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(backgroundImageUrl),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          logoImageUrl,
                          height: 40,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 22,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        // Text(
                        //   description,
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        // ),
                        const Spacer(),
                        CommonWidgets.customButton(
                            context: context,
                            icon: Icons.play_arrow,
                            text: isLive ? "Watch" : "Preview",
                            onPressed: onWatchPressed),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
