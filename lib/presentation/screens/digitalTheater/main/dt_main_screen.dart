import 'package:filmox_clean_architecture/presentation/components/digitaltheater/digital_theater_main_layout.dart';
import 'package:filmox_clean_architecture/providers/digitalTheater/digital_theater_provider.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DigitalTheaterMainScreen extends StatefulWidget {
  @override
  _DigitalTheaterMainScreenState createState() => _DigitalTheaterMainScreenState();
}

class _DigitalTheaterMainScreenState extends State<DigitalTheaterMainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider =
            Provider.of<DigitalTheaterProvider>(context, listen: false);
        Future.wait([
          provider.fetchApi(),
          // provider.fetchTabs(),
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DigitalTheaterProvider>(context,listen: true);

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
