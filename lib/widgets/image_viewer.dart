import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/symbol.dart';

class MyImageViewer extends StatelessWidget {
  final ImageProvider image;

  const MyImageViewer({super.key, required this.image});

  Widget buildImageWidget() {
    return Image(
      image: image,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Placeholders.progress();
        }
      },
      errorBuilder: (ctx, error, stacktrace) {
        return Icon(
          Icons.broken_image_rounded,
          size: 180,
          color: ctx.darkSafeThemeColor,
        );
      },
/*
        int currentLength = loadingProgress.cumulativeBytesLoaded;
        int? totalLength = loadingProgress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator(value: totalLength != null ? currentLength / totalLength : null),
        );*/
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 10.0,
        child: buildImageWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: buildBody(context));
  }

  static Future<void> showNetworkImagePage(BuildContext context, String url) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: MyImageViewer(
          image: CachedNetworkImageProvider(url),
        ).hero(url),
      );
    }));
  }
}
