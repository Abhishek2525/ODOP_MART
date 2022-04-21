import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../pages/video_details/video_details_page.dart';

/// A [Widget] for containing the view mode option in [VideoDetailsPage]
class ReadMoreText extends StatefulWidget {
  final String text;
  final Color expandingButtonColor;
  final TextStyle textStyle;

  ReadMoreText(
    this.text, {
    this.expandingButtonColor,
    this.textStyle,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText>
    with TickerProviderStateMixin<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String txt = widget.text;
    txt = txt.replaceAll('color: rgb(0, 0, 0);', ' ');

    bool darkMode = ThemeController.currentThemeIsDark;

    print('dark mode true = $darkMode');

    final expandingButtonColor = widget.expandingButtonColor != null
        ? widget.expandingButtonColor
        : Color(0xffE15050);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          vsync: this,
          child: ConstrainedBox(
            constraints: isExpanded
                ? BoxConstraints()
                : BoxConstraints(maxHeight: 55.0 + 12.0),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                child: Html(
                  data: widget.text,
                  style: {
                    "body": Style(
                      textAlign: TextAlign.start,
                      color: darkMode ? Colors.white : Colors.black,
                      backgroundColor: darkMode
                          ? AppColors.darkScaffoldBackgroundColor
                          : AppColors.lightScaffoldBackgroundColor,
                    ),
                  },
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text('${isExpanded ? 'Show less' : 'See more'}',
                  style: TextStyle(color: expandingButtonColor)),
              onPressed: () => setState(() => isExpanded = !isExpanded),
            ),
          ],
        ),
      ],
    );
  }
}
