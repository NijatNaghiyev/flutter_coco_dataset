import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_coco_dataset/features/data/models/cats_model.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';

class CatsService {
  Future<List<CatsModel>> getCatsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/cats_data.json',
      );
      final jsonList = json.decode(jsonString) as List<dynamic>?;
      final data = jsonList
          ?.map(
            (e) => CatsModel.fromMap(e as Map<String, dynamic>),
          )
          .toList();

      AppLogger.i(
        'Cats data loaded successfully: ${data?.length ?? 0} items',
      );

      return data ?? [];
    } catch (e) {
      AppLogger.e(
        'Error loading cats data: $e',
        error: e,
      );

      return [];
    }
  }
}
