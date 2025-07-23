import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/models/cats_model.dart';
import 'package:flutter_coco_dataset/presentation/widgets/gloval_cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});

  final CatsModel category;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CocoCubit, CocoState, Set<CatsModel>>(
      selector: (state) => state.searchCats,
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<CocoCubit>().addSeachCats(category);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: state.contains(category)
                    ? Colors.green
                    : Colors.transparent,
              ),
            ),
            child: GlobalCachedNetworkImage(
              imageUrl: category.imageUrl,
            ),
          ),
        );
      },
    );
  }
}
