import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;

  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                :  BoxConstraints(maxHeight: 60.h), // Adjust this value to fit 3 lines
            child: Text(
              widget.text,
              style:  Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Read Less" : "Read More",
            style:  Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
