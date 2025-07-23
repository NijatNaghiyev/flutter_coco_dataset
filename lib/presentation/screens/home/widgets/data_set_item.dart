import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/domain/entities/instance_entity.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/data_set_cat_item.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/segmentation_painter.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';
import 'dart:ui' as ui;

import 'package:flutter_coco_dataset/utils/helper/get_ui_image_from_network.dart';
import 'package:flutter_coco_dataset/utils/helper/throttler.dart';
import 'package:flutter_coco_dataset/utils/helper/url_launcher_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataSetItem extends StatefulWidget {
  const DataSetItem({super.key, required this.imagesModel});

  final ImagesModel imagesModel;

  @override
  State<DataSetItem> createState() => _DataSetItemState();
}

class _DataSetItemState extends State<DataSetItem> {
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showImageUrl = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showCaptions = ValueNotifier<bool>(false);

  ui.Image? _image;

  int? filterCatId;

  final Throttler _throttler = Throttler(
    milliseconds: 500,
  );

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _isLoadingNotifier.dispose();
    _showImageUrl.dispose();
    _showCaptions.dispose();
    super.dispose();
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
        .where(
          (e) =>
              e.imageId == widget.imagesModel.id &&
              (filterCatId == null || e.categoryId == filterCatId),
        )
        .map((e) => e.categoryId)
        .toSet();

    return data;
  }

  Set<int> _getVisibleCats(CocoState state) {
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

        return Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: Column(
            spacing: 8.h,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  _BasicDataSetItem(
                    () {
                      _showImageUrl.value = !_showImageUrl.value;
                    },
                    Icons.add_link_rounded,
                  ),
                  _BasicDataSetItem(
                    () {
                      _showCaptions.value = !_showCaptions.value;
                    },
                    Icons.format_color_text_sharp,
                  ),
                  ..._getVisibleCats(state).map(
                    (e) => DataSetCatItem(
                      isSelected: filterCatId == e,
                      id: e,
                      onTap: () {
                        if (filterCatId != e) {
                          setState(() {
                            filterCatId = e;
                          });
                        }
                      },
                    ),
                  ),

                  _EmptyDataSetItem(),
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Column(
                  spacing: 8.h,
                  children: [
                    _ItemImageUrl(() {
                      _throttler.call(
                        () {
                          UrlLauncherHelper.openInAppWebView(
                            widget.imagesModel.flickrUrl ?? '',
                          );
                        },
                      );
                    }, widget.imagesModel.flickrUrl ?? ''),

                    _ItemImageUrl(
                      () {
                        _throttler.call(
                          () {
                            UrlLauncherHelper.openInAppWebView(
                              widget.imagesModel.cocoUrl ?? '',
                            );
                          },
                        );
                      },
                      widget.imagesModel.cocoUrl ?? '',
                    ),
                  ],
                ),
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder(
                  valueListenable: _showCaptions,
                  builder: (context, value, child) {
                    if (!value) {
                      return const SizedBox.shrink();
                    }
                    return child!;
                  },
                  child: Text(
                    state.captions
                        .where(
                          (e) => e.imageId == widget.imagesModel.id,
                        )
                        .map((e) => e.caption)
                        .join('\n'),
                  ),
                ),
              ),

              RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(
                    size: Size(400.w, 300.h),
                    painter: SegmentationPainter(
                      image: _image!,
                      segmentations: _getVisibleSegmentations(state),
                      visibleIds: _getVisibleIds(state),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _ItemImageUrl(VoidCallback onTap, String imageUrl) {
    return ValueListenableBuilder(
      valueListenable: _showImageUrl,
      builder: (context, value, child) {
        if (!value) {
          return const SizedBox.shrink();
        }

        return child!;
      },
      child: InkWell(
        onTap: onTap,
        child: Text(
          imageUrl,
          style: TextStyle(fontSize: 16.sp, color: Colors.blue),
        ),
      ),
    );
  }

  InkWell _EmptyDataSetItem() {
    return InkWell(
      onTap: () {
        setState(() {
          filterCatId = null;
        });
      },
      child: Container(
        width: 70.dg,
        height: 70.dg,
        decoration: BoxDecoration(
          border: Border.all(
            width: 4,
          ),
        ),
      ),
    );
  }

  InkWell _BasicDataSetItem(VoidCallback onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70.dg,
        height: 70.dg,
        decoration: BoxDecoration(
          border: Border.all(
            width: 4,
          ),
        ),
        child: Center(
          child: Icon(icon, size: 32.sp, color: Colors.black),
        ),
      ),
    );
  }
}
