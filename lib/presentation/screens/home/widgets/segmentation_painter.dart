import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coco_dataset/features/domain/entities/instance_entity.dart';
import 'package:flutter_coco_dataset/utils/helper/random_color_helper.dart';

class SegmentationPainter extends CustomPainter {
  final ui.Image image;
  final List<InstanceEntity> segmentations;
  final Set<int> visibleIds; // 👈 Only show these IDs

  SegmentationPainter({
    required this.image,
    required this.segmentations,
    required this.visibleIds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
      size.width / image.width,
      size.height / image.height,
    );
    canvas
      ..scale(scale)
      ..drawImage(image, Offset.zero, Paint());

    for (final seg in segmentations) {
      if (!visibleIds.contains(seg.categoryId)) continue;

      for (final poly in seg.polygons) {
        if (poly.length < 2) continue;

        final path = Path()..moveTo(poly[0].dx, poly[0].dy);
        for (var j = 1; j < poly.length; j++) {
          path.lineTo(poly[j].dx, poly[j].dy);
        }
        path.close();

        // Fill inside with color
        final fillPaint = Paint()
          ..color = RandomColorHelper.getRandomColor()
          ..style = PaintingStyle.fill;

        // Draw border with black line
        final borderPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 / scale;

        canvas
          ..drawPath(path, fillPaint)
          ..drawPath(path, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SegmentationPainter oldDelegate) {
    return !setEquals(oldDelegate.visibleIds, visibleIds);
  }
}
