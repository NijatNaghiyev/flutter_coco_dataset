import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/features/data/models/cats_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedCategoriesList extends StatelessWidget {
  const SelectedCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CocoCubit, CocoState, Set<CatsModel>>(
      selector: (state) => state.searchCats,
      builder: (context, selectedCats) {
        if (selectedCats.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'No categories selected',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              Row(
                children: [
                  Text(
                    'Selected Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  ElevatedButton(
                    onPressed: () {
                      context.read<CocoCubit>().search();
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  ...selectedCats.map(
                    (cat) => GestureDetector(
                      onTap: () {
                        context.read<CocoCubit>().removeSearchCats(cat);
                      },
                      child: Chip(
                        label: Text(cat.name),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          context.read<CocoCubit>().removeSearchCats(cat);
                        },
                      ),
                    ),
                  ),
                  if (selectedCats.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        context.read<CocoCubit>().clearSearchCats();
                      },
                      child: const Text('Clear All'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
