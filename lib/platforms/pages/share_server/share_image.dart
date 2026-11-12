import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

class ShareImage extends StatelessWidget {
  const new({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
