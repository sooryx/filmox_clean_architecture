// ignore_for_file: must_be_immutable

import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideNav extends StatefulWidget {
  final List<ContestEntity> data;
  final Function(ContestEntity, int, int) onCategoryTapped;
  int checkIndex;

  SideNav({
    super.key,
    required this.data,
    required this.checkIndex,
    required this.onCategoryTapped,
  });

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(15.r),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h, left: 5.w),
        child: Container(
          width: 70.w,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> widgetList = [];

    var entries = widget.data;

    for (var i = 0; i < entries.length; i++) {
      var entry = entries[i];
      var category = entry;
      widgetList.add(
        GestureDetector(
          onTap: () {
            indexChecked(i);
            widget.onCategoryTapped(category, i, widget.checkIndex);
          },
          child: SizedBox(
            height: 145.h,
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalText(name:category.categoryName,checked: widget.checkIndex == i),
                    if (widget.checkIndex == i)
                      SizedBox(
                        width: 2.w,
                      ),
                    if (widget.checkIndex == i)
                      Container(
                        width: 3.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                      ),
                  ],
                )),
          ),
        ),
      );
    }
    return widgetList;
  }

  void indexChecked(int i) {
    if (widget.checkIndex == i) return;
    setState(() {
      widget.checkIndex = i;
    });
  }
  Widget VerticalText({
    required String name,
    required bool checked
}){
    return RotatedBox(
      quarterTurns: 3,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: checked ? Colors.white : Colors.white.withOpacity(0.3),
            fontSize: checked ? 20 : 16,
          ),
        ),
      ),
    );
  }
}




