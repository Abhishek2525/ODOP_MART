import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/view_models/filter_videos_view_model.dart';
import '../../../../core/view_models/theme_view_model.dart';
import '../../../constant/app_colors.dart';

class BottomSheetFilter {
  static bottomSheetPro(BuildContext context) async {
    bool isDarkTheme = ThemeController.currentThemeIsDark;
    var backgroundColor = isDarkTheme
        ? AppColors.darkScaffoldBackgroundColor
        : AppColors.lightScaffoldBackgroundColor;
    showModalBottomSheet(
      elevation: 16,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BottomSheetWidget();
      },
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  BottomSheetController _controller = Get.put(BottomSheetController());

  var whiteOrBlackColor;

  @override
  Widget build(BuildContext context) {
    whiteOrBlackColor =
        ThemeController.currentThemeIsDark ? AppColors.white : AppColors.black;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _topWidget(),

            /// categories widget
            Obx(() {
              if (_controller.selectedCategory != null) {
                return _categoryWidget();
              } else {
                return Container();
              }
            }),

            /// sub-category widget
            Obx(() {
              if (_controller.subCategoryMapList.isNotEmpty &&
                  _controller.selectedSubcategoryIdList != null) {
                return _subCategoryWidget();
              } else {
                return Container();
              }
            }),

            /// video quality wodget
            Obx(() {
              if (_controller.selectedQualityList != null) {
                return _videoQualityWidget();
              } else {
                return Container();
              }
            }),

            /// video upload time widget
            Obx(() {
              if (_controller.selectedUploadTime.value != null) {
                return _uploadTimeWidget();
              } else {
                return Container();
              }
            }),

            /// like seekbar
            Obx(() {
              if (_controller.currentSeekBarValue.value != null) {
                return _seekBarWidget();
              } else {
                return Container();
              }
            }),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _topWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                splashColor: AppColors.deepRed,
                icon: Icon(
                  Icons.cancel_outlined,
                  color: whiteOrBlackColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 16),
              Text(
                'Filter',
                style: TextStyle(
                  color: whiteOrBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  _controller.resetButtonOnTap();
                },
                child: Text(
                  'RESET',
                  style: TextStyle(color: whiteOrBlackColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controller.applyButtonOnTap();
                },
                child: Text(
                  'APPLY',
                  style: TextStyle(color: AppColors.deepRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8 / 3,
            crossAxisCount: 4,
            crossAxisSpacing: 1,
            mainAxisSpacing: 2,
          ),
          itemCount: _controller.categoryList.length,
          itemBuilder: (context, index) {
            var itemBackgroundColor;
            var itemTextColor;

            if (_controller.selectedCategory
                .contains(_controller.categoryList[index])) {
              if (ThemeController.currentThemeIsDark) {
                itemBackgroundColor = AppColors.white;
                itemTextColor = AppColors.black;
              } else {
                itemBackgroundColor = AppColors.black;
                itemTextColor = AppColors.white;
              }
            } else {
              itemBackgroundColor = AppColors.deepRed;
              itemTextColor = AppColors.white;
            }
            return GestureDetector(
              onTap: () {
                String newSelected = _controller.categoryList[index];
                int newSelectedId = _controller.categoryIdList[index];
                if (_controller.selectedCategory.contains(newSelected)) {
                  _controller.selectedCategory.remove(newSelected);
                  _controller.selectedCategoryIdList.remove(newSelectedId);
                } else {
                  _controller.selectedCategory.add(newSelected);
                  _controller.selectedCategoryIdList.add(newSelectedId);
                }

                /// call the get subcategory list api
                _controller.getSubCategoryList();
              },
              child: Card(
                color: itemBackgroundColor,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      getFirstUpper(_controller.categoryList[index]),
                      style: TextStyle(fontSize: 11, color: itemTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _videoQualityWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Text(
            'Quality Type',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8 / 3,
            crossAxisCount: 4,
            crossAxisSpacing: 1,
            mainAxisSpacing: 2,
          ),
          itemCount: _controller.qualityList.length,
          itemBuilder: (context, index) {
            var itemBackgroundColor;
            var itemTextColor;

            int currentQuality = _controller.qualityList[index];

            if (_controller.selectedQualityList.contains(currentQuality)) {
              if (ThemeController.currentThemeIsDark) {
                itemBackgroundColor = AppColors.white;
                itemTextColor = AppColors.black;
              } else {
                itemBackgroundColor = AppColors.black;
                itemTextColor = AppColors.white;
              }
            } else {
              itemBackgroundColor = AppColors.deepRed;
              itemTextColor = AppColors.white;
            }
            return GestureDetector(
              onTap: () {
                int newSelected = _controller.qualityList[index];
                int newSelectedId = _controller.qualityIdList[index];
                if (_controller.selectedQualityList.contains(newSelected)) {
                  _controller.selectedQualityList.remove(newSelected);
                  _controller.selectedQualityIdList.remove(newSelectedId);
                } else {
                  _controller.selectedQualityList.add(newSelected);
                  _controller.selectedQualityIdList.add(newSelectedId);
                }
              },
              child: Card(
                color: itemBackgroundColor,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${_controller.qualityList[index]}' + 'p',
                      style: TextStyle(fontSize: 11, color: itemTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _uploadTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Text(
            'Upload time',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8 / 3,
            crossAxisCount: 4,
            crossAxisSpacing: 1,
            mainAxisSpacing: 2,
          ),
          itemCount: _controller.timeList.length,
          itemBuilder: (context, index) {
            var itemBackgroundColor;
            var itemTextColor;

            if (_controller.timeList[index] ==
                _controller.selectedUploadTime.value) {
              if (ThemeController.currentThemeIsDark) {
                itemBackgroundColor = AppColors.white;
                itemTextColor = AppColors.black;
              } else {
                itemBackgroundColor = AppColors.black;
                itemTextColor = AppColors.white;
              }
            } else {
              itemBackgroundColor = AppColors.deepRed;
              itemTextColor = AppColors.white;
            }

            return GestureDetector(
              onTap: () {
                String prevSelected = _controller.selectedUploadTime.value;
                String newSelected = _controller.timeList[index];

                if (prevSelected == newSelected) {
                  _controller.selectedUploadTime.value = '';
                } else {
                  _controller.selectedUploadTime.value = newSelected;
                }
              },
              child: Card(
                color: itemBackgroundColor,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      getFirstUpper(_controller.timeList[index]),
                      style: TextStyle(fontSize: 11, color: itemTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _seekBarWidget() {
    bool isDarkMode = ThemeController.currentThemeIsDark;
    var inactiveTrackColor = isDarkMode ? AppColors.white : Colors.blueGrey;
    var activeTrackColor = isDarkMode ? AppColors.deepRed : AppColors.deepRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Text(
            'All Time Like',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            thumbColor: AppColors.deepRed,
            activeTrackColor: activeTrackColor,
            inactiveTrackColor: inactiveTrackColor,
            trackHeight: 2,
            valueIndicatorTextStyle: TextStyle(color: Colors.white),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 8,
            ),
          ),
          child: Slider(
            value: _controller.currentSeekBarValue.value,
            min: _controller.minSeekBarValue,
            max: _controller.maxSeekbarValue,
            divisions: 5000,
            label: _controller.currentSeekBarValue.value.round().toString(),
            onChanged: (val) {
              _controller.currentSeekBarValue.value = val;
            },
          ),
        ),
      ],
    );
  }

  String getFirstUpper(String value) {
    String res = '';
    for (int i = 0; i < value.length; i++) {
      String c = value[i];
      if (i == 0) {
        c = c.toUpperCase();
      }
      res += c;
    }
    return res;
  }

  Widget _subCategoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Sub-Categories',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8 / 1.8,
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 2,
          ),
          itemCount: _controller.subCategoryMapList.length,
          itemBuilder: (context, index) {
            var itemBackgroundColor = AppColors.deepRed;
            var itemTextColor = AppColors.white;

            if (_controller.selectedSubcategoryIdList
                .contains(_controller.subCategoryMapList[index]['id'])) {
              if (ThemeController.currentThemeIsDark) {
                itemBackgroundColor = AppColors.white;
                itemTextColor = AppColors.black;
              } else {
                itemBackgroundColor = AppColors.black;
                itemTextColor = AppColors.white;
              }
            } else {
              itemBackgroundColor = AppColors.deepRed;
              itemTextColor = AppColors.white;
            }
            return GestureDetector(
              onTap: () {
                String newSelected =
                    _controller.subCategoryMapList[index]['id'];
                if (_controller.selectedSubcategoryIdList
                    .contains(newSelected)) {
                  _controller.selectedSubcategoryIdList.remove(newSelected);
                } else {
                  _controller.selectedSubcategoryIdList.add(newSelected);
                }
                _controller.subCategoryMapList.refresh();
              },
              child: Card(
                color: itemBackgroundColor,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      getFirstUpper(
                          _controller.subCategoryMapList[index]['name']),
                      style: TextStyle(fontSize: 10, color: itemTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
