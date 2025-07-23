import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_coco_dataset/features/data/data_sources/local/cats_service.dart';
import 'package:flutter_coco_dataset/features/data/models/captions_model.dart';
import 'package:flutter_coco_dataset/features/data/models/cats_model.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/data/models/instance_model.dart';
import 'package:flutter_coco_dataset/features/domain/repositories/coco_dataset_repository.dart';
import 'package:flutter_coco_dataset/features/domain/repositories/cubit/base_cubit.dart';
import 'package:flutter_coco_dataset/utils/enum/cubit_state_enum.dart';
import 'package:collection/collection.dart';
import 'dart:ui' as ui;

part 'coco_state.dart';

class CocoCubit extends BaseCubit<CocoState> {
  CocoCubit(this._cocoDatasetRepository) : super(CocoState());

  final CocoDatasetRepository _cocoDatasetRepository;

  final CatsService _catsService = CatsService();

  final int _paginationValue = 5;

  int _currentPaginationCount = 0;

  ///*  * Fetches the list of cats from the local JSON file.
  Future<void> getCats() async {
    try {
      safeEmit(state.copyWith(catsState: CubitState.loading));
      final cats = await _catsService.getCatsFromJson();

      final catsBySupercat = cats.groupListsBy(
        (CatsModel cat) => cat.supercatId,
      );

      safeEmit(
        state.copyWith(
          cats: UnmodifiableListView(cats),
          catsBySupercat: catsBySupercat,
          catsState: CubitState.success,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(error: e.toString(), catsState: CubitState.error),
      );
    }
  }

  ///* Adds a new search category to the list of search categories.
  void addSeachCats(CatsModel searchCats) {
    final searchCatsList = Set<CatsModel>.from(state.searchCats);

    safeEmit(
      state.copyWith(
        searchCats: searchCatsList
          ..add(
            searchCats,
          ),
      ),
    );
  }

  ///* Toggles the selection of a category in the search categories list.
  void removeSearchCats(CatsModel searchCats) {
    final searchCatsList = Set<CatsModel>.from(state.searchCats)
      ..remove(searchCats);

    safeEmit(
      state.copyWith(
        searchCats: searchCatsList,
      ),
    );
  }

  ///* Clears the list of search categories.
  void clearSearchCats() {
    safeEmit(
      state.copyWith(
        searchCats: const {},
      ),
    );
  }

  ///* Get Images by category IDs
  Future<void> search() async {
    try {
      safeEmit(
        state.copyWith(
          imagesId: UnmodifiableListView<int>([]),
          searchState: CubitState.loading,
          hasPagination: true,
        ),
      );
      final imageIds = await _cocoDatasetRepository.getImagesIDByCatsId(
        state.searchCats.map((cat) => cat.id).toList(),
      );

      safeEmit(
        state.copyWith(
          imagesId: UnmodifiableListView<int>(imageIds),
        ),
      );

      if (imageIds.isNotEmpty) {
        await getDataSets();
      }

      safeEmit(
        state.copyWith(
          searchState: CubitState.success,
        ),
      );
    } on DioException catch (e) {
      safeEmit(
        state.copyWith(error: e.message, searchState: CubitState.error),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(error: e.toString(), searchState: CubitState.error),
      );
    }
  }

  ///* Fetches the instance data for a specific image ID.
  Future<void> getDataSets({bool isPagination = false}) async {
    try {
      if (state.datasetState == CubitState.loading) {
        return;
      }

      if (!isPagination) {
        _currentPaginationCount = 0;
        safeEmit(
          state.copyWith(
            instanceResponseModel: const InstanceResponseModel(data: []),
            imagesModelList: const [],
            captions: const [],
          ),
        );
      }

      safeEmit(state.copyWith(datasetState: CubitState.loading));

      ///* If pagination is enabled, increment the current pagination count.
      final itemsIndexs = state.imagesId
          .skip(_currentPaginationCount * _paginationValue)
          .take(
            _paginationValue,
          )
          .toList();

      final results = await Future.wait([
        _cocoDatasetRepository.getInstance(itemsIndexs),
        _cocoDatasetRepository.getImagesByIds(itemsIndexs),
        _cocoDatasetRepository.getCaptions(itemsIndexs),
      ]);

      final instanceResponseModel = results[0] as InstanceResponseModel?;
      final images = results[1] as List<ImagesModel>?;
      final captions = results[2] as List<CaptionsModel>?;

      final hasPagination = state.imagesId.length > _currentPaginationCount;

      safeEmit(
        state.copyWith(
          instanceResponseModel: instanceResponseModel?.copyWith(
            data: [
              ...state.instanceResponseModel.data,
              ...instanceResponseModel.data,
            ],
          ),
          imagesModelList: [
            ...state.imagesModelList,
            ...?images,
          ],
          captions: [
            ...state.captions,
            ...?captions,
          ],
          hasPagination: hasPagination,
          datasetState: CubitState.success,
        ),
      );

      _currentPaginationCount += _paginationValue;
    } on DioException catch (e) {
      safeEmit(
        state.copyWith(error: e.message, datasetState: CubitState.error),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(error: e.toString(), datasetState: CubitState.error),
      );
    }
  }

  ///* Add UI image to the state
  void addUIImage(int id, ui.Image image) {
    final uiImage = Map<int, ui.Image>.from(state.uiImage)..[id] = image;

    safeEmit(
      state.copyWith(
        uiImage: uiImage,
      ),
    );
  }
}
