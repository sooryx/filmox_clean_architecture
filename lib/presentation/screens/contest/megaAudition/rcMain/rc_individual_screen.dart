import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Widgets/RightWidget.dart';
import 'Widgets/SideNavBar.dart';


class RCIndividualPage extends StatefulWidget {
  final List<ContestEntity>? data;

   RCIndividualPage({super.key, required this.data,});

  @override
  State<RCIndividualPage> createState() => _RCIndividualPageState();
}

class _RCIndividualPageState extends State<RCIndividualPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int checkIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.data!.length, vsync: this);
    _pageController = PageController();

    _tabController.addListener(_handleTabSelection);
  }


  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        checkIndex = _tabController.index;
        _pageController.animateToPage(
          checkIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null || widget.data!.isEmpty) {
      return _buildLoadingWidget();
    } else {
      return Row(
        children: [
          if (widget.data!.isNotEmpty)
            SideNav(
              data: widget.data!,
              checkIndex: checkIndex,
              onCategoryTapped: (category, index, khaleesh) {
                _tabController.animateTo(index);
              },
            ),
          Expanded(
            child: RightWidget(
              tabController: _tabController,
              data: widget.data!,
              pageController: _pageController,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: InkWell(
        onTap: () async {
          final provider =
          Provider.of<RcMainProvider>(context,
              listen: false);
         await provider.fetchContests();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("No Live contests available as of now "),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.surface,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Tap to refresh",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                      color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}






