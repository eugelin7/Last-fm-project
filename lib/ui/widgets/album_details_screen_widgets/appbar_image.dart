import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../=models=/image.dart' as img_model;

class AppBarImage extends StatelessWidget {
  final String artistName;
  final String albumName;
  final List<img_model.Image> albImages;
  final ScrollController controller;

  const AppBarImage({
    Key? key,
    required this.artistName,
    required this.albumName,
    required this.albImages,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgUrl;
    try {
      imgUrl = albImages.firstWhere((img) => img.size == img_model.ImageSize.large).text;
    } catch (e) {
      imgUrl = '';
    }

    const placeholder = Icon(
      Icons.library_music,
      size: 128,
      color: Color(0xFFBDBDBD),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double imgSideSize = 200 - controller.offset / 1.1;
        if (imgSideSize < 10) {
          imgSideSize = 10;
        }
        return FlexibleSpaceBar(
          title: Visibility(
            visible: controller.offset > 170,
            child: Text(
              // Non-breaking string
              '$albumName  by $artistName'.replaceAll(' ', String.fromCharCode(0x00A0)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          centerTitle: false,
          titlePadding: const EdgeInsetsDirectional.only(start: 60, bottom: 17, end: 50),
          background: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imgUrl,
                placeholder: (_, __) => placeholder,
                errorWidget: (_, __, ___) => placeholder,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: (controller.offset > 0) ? (54 + controller.offset / 5) : 54,
                      width: 100,
                    ),
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: imgSideSize,
                      width: imgSideSize,
                      imageUrl: imgUrl,
                      placeholder: (_, __) => placeholder,
                      errorWidget: (_, __, ___) => placeholder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
