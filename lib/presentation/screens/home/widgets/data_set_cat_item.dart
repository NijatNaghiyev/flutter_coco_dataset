import 'package:flutter/material.dart';
import 'package:flutter_coco_dataset/presentation/widgets/gloval_cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataSetCatItem extends StatelessWidget {
  const DataSetCatItem({
    super.key,
    required this.id,
    required this.onTap,
    required this.isSelected,
  });

  final int id;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70.dg,
        height: 70.dg,
        decoration: BoxDecoration(
          border: Border.all(
            width: 4,
            color: isSelected ? Colors.green : Colors.transparent,
          ),
        ),
        child: GlobalCachedNetworkImage(
          imageUrl: 'https://cocodataset.org/images/cocoicons/$id.jpg',
        ),
      ),
    );
  }
}
