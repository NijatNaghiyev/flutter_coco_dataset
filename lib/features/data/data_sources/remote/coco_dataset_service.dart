import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_coco_dataset/features/data/data_sources/local/network_service.dart';
import 'package:flutter_coco_dataset/features/data/models/captions_model.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/data/models/instance_model.dart';
import 'package:flutter_coco_dataset/utils/app/app_const.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';
import 'package:flutter_coco_dataset/utils/enum/query_type_enum.dart';

class CocoDatasetService {
  List<dynamic> _parseDataIsolate(
    String rawJson,
  ) {
    final decoded = jsonDecode(rawJson);
    return decoded as List<dynamic>;
  }

  ///* Fetch images by category ID
  Future<List<int>> getImagesIDByCatsId(List<int> imageId) async {
    final data = {
      'category_ids[]': imageId,
      'querytype': QueryTypeEnum.getImagesByCats.name,
    };

    final response = await NetworkService().post(
      path: AppConst.url,
      postData: data,
      options: Options(
        responseType: ResponseType.plain,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      final rawJson = response.data as String?;
      if (rawJson == null) {
        return [];
      }

      final dataModel = await compute(_parseDataIsolate, rawJson);

      AppLogger.i('Images fetched successfully');
      return dataModel.cast<int>();
    } else {
      AppLogger.e('Failed to fetch images: ${response.statusCode}');
      return [];
    }
  }

  Future<List<ImagesModel>> getImages(List<int> imageIds) async {
    final response = await NetworkService().post(
      path: AppConst.url,
      postData: {
        'image_ids[]': imageIds,
        'querytype': QueryTypeEnum.getImages.name,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>?;

      final images =
          data
              ?.map((e) => ImagesModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      AppLogger.i('Images fetched successfully');
      return images;
    } else {
      AppLogger.e('Failed to fetch images: ${response.statusCode}');
      return [];
    }
  }

  Future<InstanceResponseModel?> getInstance(List<int> imageId) async {
    final response = await NetworkService().post(
      path: AppConst.url,
      postData: {
        'image_ids[]': imageId,
        'querytype': QueryTypeEnum.getInstances.name,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>?;

      final dataModel = InstanceResponseModel.fromJson(
        data?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      );

      AppLogger.i('Instances fetched successfully');
      return dataModel;
    } else {
      AppLogger.e('Failed to fetch instances: ${response.statusCode}');
      return null;
    }
  }

  Future<List<CaptionsModel>> getCaptions(List<int> imageIds) async {
    final response = await NetworkService().post(
      path: AppConst.url,
      postData: {
        'image_ids[]': imageIds,
        'querytype': QueryTypeEnum.getCaptions.name,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>?;

      final captions =
          data
              ?.map((e) => CaptionsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      AppLogger.i('Captions fetched successfully');
      return captions;
    } else {
      AppLogger.e('Failed to fetch captions: ${response.statusCode}');
      return [];
    }
  }
}
