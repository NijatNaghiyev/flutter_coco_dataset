import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/domain/entities/instance_entity.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/segmentation_painter.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';
import 'dart:ui' as ui;

import 'package:flutter_coco_dataset/utils/helper/get_ui_image_from_network.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataSetItem extends StatefulWidget {
  const DataSetItem({super.key, required this.imagesModel});

  final ImagesModel imagesModel;

  @override
  State<DataSetItem> createState() => _DataSetItemState();
}

class _DataSetItemState extends State<DataSetItem> {
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final state = context.read<CocoCubit>().state;
    if (state.uiImage.containsKey(widget.imagesModel.id)) {
      _image = state.uiImage[widget.imagesModel.id];
      _isLoadingNotifier.value = false;
      return;
    }

    _isLoadingNotifier.value = true;
    try {
      // Simulate image loading
      _image = await loadNetworkImageFromNetwork(
        widget.imagesModel.flickrUrl ?? '',
      );

      AppLogger.i('Image loaded for index: ${widget.imagesModel.flickrUrl}');

      context.read<CocoCubit>().addUIImage(
        widget.imagesModel.id ?? 0,
        _image!,
      );
    } catch (e) {
      AppLogger.e('Error loading image: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  List<InstanceEntity> _getVisibleSegmentations(CocoState state) {
    final data = state.instanceResponseModel.data
        .where((e) => e.imageId == widget.imagesModel.id)
        .toList();

    return data;
  }

  Set<int> _getVisibleIds(CocoState state) {
    final data = state.instanceResponseModel.data
        .where((e) => e.imageId == widget.imagesModel.id)
        .map((e) => e.categoryId)
        .toSet();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<CocoCubit>().state;

    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_image == null) {
          return const Center(child: Text('Image not available'));
        }

        return RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomPaint(
              size: Size(400.w, 400.h),
              painter: SegmentationPainter(
                image: _image!,
                segmentations: _getVisibleSegmentations(state),
                visibleIds: _getVisibleIds(state),
              ),
            ),
          ),
        );
      },
    );
  }
}
