import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///* A widget that displays a cached network image with a placeholder and error widget.
///* It uses the [CachedNetworkImage] package to handle image caching and loading.
///* The image URL, height, and width can be specified.
///* If the image URL is empty, it shows an error icon.
///* If the image fails to load, it shows an error icon.
///* The image is displayed with a high filter quality and box fit cover.
class GlobalCachedNetworkImage extends StatelessWidget {
  const GlobalCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  final String? imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      height: height,
      width: width,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) {
        if (url.isEmpty) {
          return Icon(
            Icons.image_not_supported,
            color: Theme.of(context).colorScheme.error,
          );
        }
        return Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
        );
      },
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}
