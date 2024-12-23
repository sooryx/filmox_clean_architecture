import 'package:filmox_clean_architecture/presentation/components/digitaltheater/digital_theater_main_layout.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/digitalTheater/dt_main/digital_theater_provider.dart';

class DigitalTheaterMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigitalTheaterProvider>(context, listen: true);

    if (provider.status == DTMainPageStatus.loading ||
        provider.status == DTMainPageStatus.bannerloading) {
      return const Center(child: Loadingscreen());
    }

    if (provider.status == DTMainPageStatus.failed) {
      return Center(child: Text(provider.errorMessage));
    }

    return ReusableDigitalTheaterPage(
      allTheaters: provider.allDT,
      banners: provider.banners,
      categories: provider.tabs,
    );
  }
}
