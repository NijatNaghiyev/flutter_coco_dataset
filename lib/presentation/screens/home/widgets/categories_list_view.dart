import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/category_item.dart';
import 'package:flutter_coco_dataset/utils/enum/cubit_state_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  void initState() {
    super.initState();
    context.read<CocoCubit>().getCats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocoCubit, CocoState>(
      buildWhen: (previous, current) => previous.catsState != current.catsState,
      builder: (context, state) {
        return switch (state.catsState) {
          CubitState.loading => SizedBox(
            height: 200.h,
            width: double.infinity,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          CubitState.error => Center(child: Text('Error: ${state.error}')),
          CubitState.success when state.cats.isNotEmpty => Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    spacing: 8.w,
                    children: [
                      for (final categoryList in state.catsBySupercat.values)
                        SizedBox(
                          height: 250.h,
                          width: 50.w,
                          child: ListView.separated(
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              final cat = categoryList[index];

                              return CategoryItem(
                                category: cat,
                              );
                            },
                            separatorBuilder: (_, _) => SizedBox(height: 8.h),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
