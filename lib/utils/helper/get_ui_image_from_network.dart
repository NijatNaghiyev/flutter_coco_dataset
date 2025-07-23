import 'package:dio/dio.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<ui.Image> loadNetworkImageFromNetwork(String url) async {
  final dio = Dio();
  final response = await dio.get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  final bytes = Uint8List.fromList(response.data!);
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}
