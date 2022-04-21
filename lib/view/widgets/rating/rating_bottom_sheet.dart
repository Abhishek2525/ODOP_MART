import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import 'rating_bar.dart';

double _rating = 3.0;
bool _isVertical = false;
String rateText = 'good';

/// This [Widget] designed for performing in app ratting system
class BottomSheetRating {
  static bottomSheetPro(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
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
  @override
  void dispose() {
    // TODO: implement dispose
    rateText = 'good';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -.5),
              color: AppColors.shadowRed,
            )
          ]),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Rate This App",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              direction: _isVertical ? Axis.vertical : Axis.horizontal,
              itemCount: 5,
              text: rateText,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Container(
                      child: Image.asset(
                        'images/rate1.png',
                      ),
                    );
                  case 1:
                    return Container(
                      child: Image.asset(
                        'images/rate2.png',
                      ),
                    );
                  case 2:
                    return Container(
                      child: Image.asset(
                        'images/rate6.png',
                      ),
                    );
                  case 3:
                    return Container(
                      child: Image.asset(
                        'images/rate4.png',
                      ),
                    );
                  case 4:
                    return Container(
                      child: Image.asset(
                        'images/rate5.png',
                      ),
                    );
                  default:
                    return Container();
                }
              },
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                  if (_rating == 1) {
                    rateText = 'bad';
                  } else if (_rating == 2) {
                    rateText = 'not good';
                  } else if (_rating == 3) {
                    rateText = 'good';
                  } else if (_rating == 4) {
                    rateText = 'very good';
                  } else if (_rating == 5) {
                    rateText = 'excellent';
                  }
                });
              },
              updateOnDrag: true,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Do Later',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.deepRed,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    ' Rate It ',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.greenButton,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
