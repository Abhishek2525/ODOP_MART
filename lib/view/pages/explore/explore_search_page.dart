import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/search/search_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../widgets/app_autocomplete_text_field.dart';
import 'view/actore_result_view.dart';
import 'view/genre_result_view.dart';
import 'view/top_result_view.dart';

class ExploreSearchPage extends StatefulWidget {
  final int nestedId;

  ExploreSearchPage({this.nestedId});

  @override
  _ExploreSearchPageState createState() => _ExploreSearchPageState();
}

class _ExploreSearchPageState extends State<ExploreSearchPage> {
  TextEditingController _searchController = TextEditingController();

  var autoKey = GlobalKey<AppAutoCompleteTextFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: GetBuilder<ThemeController>(
          builder: (controller) => Container(
            decoration: BoxDecoration(
                color: controller.themeMode?.index == 2
                    ? AppColors.fillBorderColor
                    : AppColors.dividerColor,
                border: Border.all(color: AppColors.searchBorderColor),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              children: [
                Expanded(
                  child: GetBuilder<SearchViewModel>(
                    builder: (c) {
                      Widget autoComplete = Theme(
                        data: Theme.of(context),
                        child: SimpleAutoCompleteTextField(
                          key: autoKey,
                          controller: _searchController,
                          suggestions: c?.searchSuggestion,
                          textSubmitted: (s) {
                            c?.searchQuery(value: s);
                            c?.addToSuggestionList(s);
                          },
                          clearOnSubmit: false,
                          style: TextStyle(
                            fontSize: 9,
                            color: ThemeController.currentThemeIsDark
                                ? AppColors.white
                                : AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.only(left: 10, top: 8, bottom: 8),
                            hintText: "Search by names",
                            hintStyle: TextStyle(
                              fontSize: 9,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                      return autoComplete;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 17,
                      color: AppColors.borderColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              color: AppColors.deepRed,
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(10.0)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 30.0),
            child: GetBuilder<SearchViewModel>(
              builder: (c) => ClipOval(
                child: GestureDetector(
                  onTap: () {
                    if (_searchController?.text == null) return;
                    c?.searchQuery(value: _searchController?.text);
                  },
                  child: ImageIcon(
                    AssetImage('images/searchIcon.png'),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<SearchViewModel>(
        builder: (searchViewModel) {
          bool actorsEmpty = false;
          bool videosEmpty = false;
          bool genresEmpty = false;

          try {
            actorsEmpty = searchViewModel
                    ?.searchResultModel?.data?.results?.actors?.isEmpty ??
                false;
            videosEmpty = searchViewModel
                    ?.searchResultModel?.data?.results?.videos?.isEmpty ??
                false;
            genresEmpty = searchViewModel
                    ?.searchResultModel?.data?.results?.genres?.isEmpty ??
                false;
          } catch (error) {
            actorsEmpty = false;
            videosEmpty = false;
            genresEmpty = false;
          }

          if (searchViewModel?.searching?.value == true) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                ],
              ),
            );
          } else if (searchViewModel?.searching?.value == false &&
              (actorsEmpty == true &&
                  videosEmpty == true &&
                  genresEmpty == true)) {
            bool isDarkTheme = ThemeController.currentThemeIsDark;
            String noDataImagePath = ImageNames.noDataForDarkTheme;
            if (isDarkTheme == false) {
              noDataImagePath = ImageNames.noDataForLightTheme;
            }

            return Center(
              child: Container(
                height: wp(50),
                width: wp(50),
                child: Image.asset(noDataImagePath),
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopResultSearchView(
                    model: searchViewModel
                        ?.searchResultModel?.data?.results?.videos,
                  ),
                  ActorsResultView(
                    model: searchViewModel
                        ?.searchResultModel?.data?.results?.actors,
                  ),
                  GenreResultView(
                    model: searchViewModel
                        ?.searchResultModel?.data?.results?.genres,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
