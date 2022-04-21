import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/constant/dev/movie_constant.dart';
import '../../../router/app_router.dart';
import '../cards/top_feature_movie_card.dart';

class TopFeatureView extends StatefulWidget {
  @override
  _TopFeatureViewState createState() => _TopFeatureViewState();
}

class _TopFeatureViewState extends State<TopFeatureView> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 5),
                child: Text(
                  'Top Feature',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 15, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    AppRouter.navToActionCategoryPage(nestedId: 1);
                  },
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
            height: wp(50) * (2 / 3),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TopFeatureMovieCard(
                  imgPath: MovieConstant.getMovie(index + 8),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
