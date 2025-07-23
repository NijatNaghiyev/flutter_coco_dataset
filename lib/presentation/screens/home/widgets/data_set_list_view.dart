import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/data_set_item.dart';
import 'package:flutter_coco_dataset/utils/enum/cubit_state_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataSetListView extends StatefulWidget {
  const DataSetListView({super.key});

  @override
  State<DataSetListView> createState() => _DataSetListViewState();
}

class _DataSetListViewState extends State<DataSetListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocoCubit, CocoState>(
      builder: (context, state) {
        if (state.searchState == CubitState.success &&
            state.imagesModelList.isNotEmpty) {
          return SliverList.builder(
            itemCount:
                state.imagesModelList.length + (state.hasPagination ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.imagesModelList.length &&
                  state.datasetState == CubitState.error) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: ${state.error}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CocoCubit>().getDataSets(
                              isPagination: true,
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (index == state.imagesModelList.length &&
                  state.hasPagination) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              // Replace with your item widget
              return DataSetItem(
                imagesModel: state.imagesModelList[index],
              );
            },
          );
        }

        ///? Success state with empty imagesModelList
        if (state.searchState == CubitState.success &&
            state.imagesModelList.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No datasets found')),
          );
        }

        ///? Error state
        if (state.searchState == CubitState.error) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${state.error}')),
          );
        }

        ///? Loading state
        if (state.searchState == CubitState.loading) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        ///? Default case
        return const SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      },
    );
  }
}
