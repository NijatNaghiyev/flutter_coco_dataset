import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/mixins/data_set_item_mixin.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/data_set_cat_item.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/segmentation_painter.dart';
import 'package:flutter_coco_dataset/utils/helper/url_launcher_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataSetItem extends StatefulWidget {
  const DataSetItem({super.key, required this.imagesModel});

  final ImagesModel imagesModel;

  @override
  State<DataSetItem> createState() => _DataSetItemState();
}

class _DataSetItemState extends State<DataSetItem> with DataSetItemMixin {
  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  void dispose() {
    isLoadingNotifier.dispose();
    showImageUrl.dispose();
    showCaptions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<CocoCubit>().state;

    return ValueListenableBuilder<bool>(
      valueListenable: isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (image == null) {
          return const Center(child: Text('Image not available'));
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: Column(
            spacing: 8.h,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //? Image Buttons
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  _BasicDataSetItem(
                    () {
                      showImageUrl.value = !showImageUrl.value;
                    },
                    Icons.add_link_rounded,
                  ),
                  _BasicDataSetItem(
                    () {
                      showCaptions.value = !showCaptions.value;
                    },
                    Icons.format_color_text_sharp,
                  ),
                  ...getVisibleCats(state).map(
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

              //? Image URLs
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Column(
                  spacing: 8.h,
                  children: [
                    _ItemImageUrl(() {
                      throttler.call(
                        () {
                          UrlLauncherHelper.openInAppWebView(
                            widget.imagesModel.flickrUrl ?? '',
                          );
                        },
                      );
                    }, widget.imagesModel.flickrUrl ?? ''),

                    _ItemImageUrl(
                      () {
                        throttler.call(
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

              //? Image Captions
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder(
                  valueListenable: showCaptions,
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

              //? Segmentation Painter
              RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(
                    size: Size(400.w, 300.h),
                    painter: SegmentationPainter(
                      image: image!,
                      segmentations: getVisibleSegmentations(state),
                      visibleIds: getVisibleIds(state),
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
      valueListenable: showImageUrl,
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
