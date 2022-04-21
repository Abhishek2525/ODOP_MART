import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../../core/models/home_categories_model.dart';
import '../../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../router/app_router.dart';
import '../../home/homepage.dart';
import '../cards/just_added_movie_card.dart';

/// This widget returns a widget list of movies by their categories
/// Example: JustAdded, Don't Miss, Featured etc

class VideoCardView extends StatefulWidget {
  final String titleName;
  final Function onMoreTap;
  final List<HomeData> listModel;

  VideoCardView({
    this.titleName,
    this.onMoreTap,
    this.listModel,
  });

  @override
  _VideoCardViewState createState() => _VideoCardViewState();
}

class _VideoCardViewState extends State<VideoCardView> {

  @override
  void initState() {

    log('\n\nvideo list => => ${jsonEncode(widget.listModel)}\n\n');

    widget.listModel.removeWhere((element) => element == null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Container(
      child: Visibility(
        visible: (widget?.listModel?.length ?? 0) != 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 5),
                  child: Text(
                    '${widget?.titleName ?? ""}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.headline1.color,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 15, bottom: 5),
                  child: GestureDetector(
                    onTap: widget?.onMoreTap,
                    child: Text(
                      'More',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: Color(0xffE15050)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: wp(29) * (13 / 10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget?.listModel?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: JustAddedMovieCard(
                      imgPath: '${widget?.listModel[index]?.thumbnail}',
                      onTap: () {
                        var videoDetailsController = Get.put(
                            VideoDetailsViewModel(widget?.listModel[index]));
                        videoDetailsController.initialData.value =
                            widget?.listModel[index];
                        videoDetailsController.getVideoDetailsMethod(
                            widget?.listModel[index].id.toString(),
                            widget?.listModel[index].categoryId);
                        AppRouter.navToVideoDetailsPage(
                          widget?.listModel[index],
                          HomePageFragment.dashboardNavId,
                          widget?.listModel[index].categoryId,
                        );
                        //print('\n\nis premium = ${widget.listModel[index].isPremium}\n\n');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
