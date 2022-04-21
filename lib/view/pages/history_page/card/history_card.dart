import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../core/api/app_urls.dart';
import '../../../../core/constant/app_constant.dart';
import '../../../../core/models/history/history_data_model.dart';
import '../../../../core/view_models/video_view_view_model.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class HistoryItemCard extends StatelessWidget {
  HistoryItemCard({
    this.index,
    this.imgPath,
    this.onTap,
    this.model,
    this.onDelete,
  });

  final int index;
  final String imgPath;
  final Function onTap;
  final Function onDelete;
  final HistoryUnitData model;

  Future<Uint8List> getImage() async {
    final ByteData bytes =
        await rootBundle.load(imgPath ?? "assets/images/genre/72563.jpg");
    final Uint8List list = bytes.buffer.asUint8List();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slidable(
        key: ValueKey(index),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: AppColors.shadowRed,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
            ),
            child: GetBuilder<VideoViewViewModel>(
              builder: (c) => IconSlideAction(
                caption: "Remove",
                color: Colors.transparent,
                icon: Icons.delete,
                closeOnTap: true,
                onTap: () async {
                  onDelete?.call();
                  int res =
                      await c?.deleteSingleHistory?.call(model?.id?.toString());
                  if (res == 200) {}
                },
              ),
            ),
          )
        ],
        child: Container(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 100.0,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    margin: EdgeInsets.only(
                        left: 8.0, top: 8.0, bottom: 8.0, right: 30),
                    height: 100.0,
                    // width: wp(100),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 100.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FadeInImage(
                                width: 100,
                                height: 86,
                                fit: BoxFit.cover,
                                image: ExtendedNetworkImageProvider(
                                  AppUrls.imageBaseUrl +
                                      "${model?.video?.thumbnail}",
                                  cache: true,
                                  cacheRawData: true,
                                  imageCacheName: AppUrls.imageBaseUrl +
                                      "${model?.video?.thumbnail}",
                                ),
                                fadeInDuration: Duration(milliseconds: 300),
                                placeholder: AssetImage(
                                  ImageNames.thumbPlaceHolder,
                                ),
                                placeholderErrorBuilder:
                                    (context, obj, stacktrace) {
                                  return getImageShimmer(
                                      width: 100, height: 86);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    model?.video?.title ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                        fontFamily: 'poppins_medium',
                                        fontSize: 16.0),
                                  ),
                                  Container(
                                    child: Text(
                                      model?.video?.duration ?? "",
                                      style:
                                          TextStyle(color: AppColors.colorGray),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 10,
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(),
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: CircleAvatar(
                            backgroundColor:
                                AppColors.shadowRed.withOpacity(.9),
                            radius: 20,
                            child: Align(
                              alignment: Alignment(0.15, 0),
                              child: ImageIcon(
                                  AssetImage("images/playIcon.png"),
                                  size: 20,
                                  color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
