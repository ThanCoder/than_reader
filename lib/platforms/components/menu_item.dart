import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    this.subTitle,
    required this.leadingIcon,
    this.trailingWidget,
  });

  final String title;
  final String? subTitle;
  final IconData leadingIcon;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return Container(
      padding: .symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: .circular(15),
        color: col.surfaceContainer,
      ),
      child: Row(
        children: [
          Container(
            padding: .all(5),
            decoration: BoxDecoration(
              borderRadius: .circular(15),
              color: col.tertiaryContainer,
            ),
            child: Icon(leadingIcon, color: col.onTertiaryContainer),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  overflow: .ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontWeight: .w600),
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    overflow: .ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: .w400),
                  ),
              ],
            ),
          ),
          if (trailingWidget != null) Spacer(),
          ?trailingWidget,
        ],
      ),
    );
  }
}
