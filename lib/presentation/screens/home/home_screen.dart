import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coco_dataset/cubits/coco/coco_cubit.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/categories_list_view.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/data_set_list_view.dart';
import 'package:flutter_coco_dataset/presentation/screens/home/widgets/selected_categories_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocBuilder<CocoCubit, CocoState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Screen'),
            ),
            body: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 100.h) {
                  context.read<CocoCubit>().getDataSets(isPagination: true);
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: ListenableBuilder(
                        listenable: searchController,
                        builder: (context, child) {
                          return SearchAnchor.bar(
                            searchController: searchController,
                            isFullScreen: false,
                            viewConstraints: BoxConstraints(
                              maxHeight: 300.h,
                            ),
                            onClose: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            barTrailing: [
                              if (searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    searchController
                                      ..clear()
                                      ..closeView(null);
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                ),
                            ],
                            suggestionsBuilder: (_, controller) {
                              return state.cats
                                  .map(
                                    (cat) => ListTile(
                                      title: Text(cat.name),
                                      onTap: () {
                                        context.read<CocoCubit>().addSeachCats(
                                          cat,
                                        );
                                      },
                                    ),
                                  )
                                  .toList();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: CategoriesListView(),
                  ),
                  const SliverToBoxAdapter(
                    child: SelectedCategoriesList(),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    sliver: const DataSetListView(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
