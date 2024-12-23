import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThumbnailGridItemContainer extends StatelessWidget {
  final String mediaUrl;
  final String thumbnail;
  final double width;
  final double height;
  final double borderRadius;

  const ThumbnailGridItemContainer({
    super.key,
    required this.mediaUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.borderRadius = 8.0, required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(7.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: CachedNetworkImage(
          fadeInCurve: Curves.easeInOut,
          fadeInDuration: Duration(milliseconds: 800),
          imageUrl:thumbnail,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
