import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class TopFeatureMovieCard extends StatelessWidget {
  final String imgPath;
  final Function onTap;

  TopFeatureMovieCard({
    this.imgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: wp(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage(
                    imgPath ?? 'images/card.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
