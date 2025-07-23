import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class InstanceEntity extends Equatable {
  final int imageId;
  final int categoryId;
  final List<List<Offset>> polygons;

  const InstanceEntity({
    required this.imageId,
    required this.categoryId,
    required this.polygons,
  });

  factory InstanceEntity.fromJson(Map<String, dynamic> json) {
    final segmentationData = json['segmentation'];
    List<List<Offset>> parsedPolygons = [];

    if (segmentationData is String) {
      // Parse the string as JSON first
      final decoded = jsonDecode(segmentationData);

      if (decoded is List<dynamic>) {
        final data = decoded.map<List<Offset>>((p) {
          final coords = List<num>.from(p as List<dynamic>);

          return [
            for (int i = 0; i < coords.length; i += 2)
              Offset(coords[i].toDouble(), coords[i + 1].toDouble()),
          ];
        }).toList();

        parsedPolygons = data;
      } else if (decoded is Map<String, dynamic>) {
        final decodedData = [decoded['counts'] as List<dynamic>];

        final data = decodedData.map<List<Offset>>((p) {
          final coords = List<num>.from(p);

          return [
            for (int i = 0; i < coords.length - 1; i += 2)
              Offset(coords[i].toDouble(), coords[i + 1].toDouble()),
          ];
        }).toList();

        parsedPolygons = data;
      }
    }

    return InstanceEntity(
      imageId: json['image_id'] as int,
      categoryId: json['category_id'] as int,
      polygons: parsedPolygons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
      'category_id': categoryId,
      'segmentation': polygons
          .map(
            (polygon) =>
                polygon.expand((offset) => [offset.dx, offset.dy]).toList(),
          )
          .toList(),
    };
  }

  @override
  List<Object?> get props => [imageId, categoryId, polygons];
}
