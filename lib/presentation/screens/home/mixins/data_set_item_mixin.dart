import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/domain/entities/instance_entity.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/data_set_item.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';
import 'package:flutter_coco_dataset/utils/helper/get_ui_image_from_network.dart';
import 'package:flutter_coco_dataset/utils/helper/throttler.dart';

mixin DataSetItemMixin on State<DataSetItem> {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showImageUrl = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showCaptions = ValueNotifier<bool>(false);

  ui.Image? image;

  int? filterCatId;

  final Throttler throttler = Throttler(
    milliseconds: 500,
  );

  Future<void> loadImage() async {
    final state = context.read<CocoCubit>().state;
    if (state.uiImage.containsKey(widget.imagesModel.id)) {
      image = state.uiImage[widget.imagesModel.id];
      isLoadingNotifier.value = false;
      return;
    }

    isLoadingNotifier.value = true;
    try {
      // Simulate image loading
      image = await loadNetworkImageFromNetwork(
        widget.imagesModel.flickrUrl ?? '',
      );

      AppLogger.i('Image loaded for index: ${widget.imagesModel.flickrUrl}');

      context.read<CocoCubit>().addUIImage(
        widget.imagesModel.id ?? 0,
        image!,
      );
    } catch (e) {
      AppLogger.e('Error loading image: $e');
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  List<InstanceEntity> getVisibleSegmentations(CocoState state) {
    final data = state.instanceResponseModel.data
        .where((e) => e.imageId == widget.imagesModel.id)
        .toList();

    return data;
  }

  Set<int> getVisibleIds(CocoState state) {
    final data = state.instanceResponseModel.data
        .where(
          (e) =>
              e.imageId == widget.imagesModel.id &&
              (filterCatId == null || e.categoryId == filterCatId),
        )
        .map((e) => e.categoryId)
        .toSet();

    return data;
  }

  Set<int> getVisibleCats(CocoState state) {
    final data = state.instanceResponseModel.data
        .where((e) => e.imageId == widget.imagesModel.id)
        .map((e) => e.categoryId)
        .toSet();

    return data;
  }
}
