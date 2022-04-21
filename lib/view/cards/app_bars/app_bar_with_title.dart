import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';
import '../../pages/history_page/history_page.dart';
import '../../router/app_router.dart';

/// This class provides some customized [AppBar] widgets
class IotaAppBar {
  /// This method provide an [AppBar] widget with a title and a back button only
  static Widget appBarWithTitle({
    Function backButtonOnTap,
    String title,
    Color borderColor,
  }) =>
      AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'poppins_medium',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: InkResponse(
          splashColor: AppColors.deepRed,
          onTap: backButtonOnTap,
          child: Container(
            alignment: Alignment.center,
            child: ImageIcon(
              AssetImage('images/backIcon.png'),
            ),
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: borderColor ?? Colors.transparent,
            height: .5,
          ),
          preferredSize: Size.fromHeight(1.5),
        ),
      );

  /// This method return an [AppBar] widget with a search option
  static Widget basicAppBarWithSearchIcon() => AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                AppRouter.navToExploreSearchPage();
              },
              child: ImageIcon(
                AssetImage('images/searchIcon.png'),
                size: 18,
              ),
            ),
          ),
        ],
      );

  /// This method provides an appbar which is only used in [HistoryPage]
  static Widget historyPageAppbar({
    Function backButtonOnTap,
    Function actionOnTap,
    String title,
    Color borderColor,
  }) =>
      AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'poppins_medium',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: backButtonOnTap,
          child: Container(
            alignment: Alignment.center,
            child: ImageIcon(
              AssetImage('images/backIcon.png'),
            ),
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: borderColor ?? Colors.transparent,
            height: .5,
          ),
          preferredSize: Size.fromHeight(1.5),
        ),
        actions: [
          TextButton(
            onPressed: actionOnTap,
            child: Text(
              'Clear All',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      );
}
