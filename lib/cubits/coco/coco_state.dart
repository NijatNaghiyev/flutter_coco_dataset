part of 'coco_cubit.dart';

class CocoState extends Equatable {
  CocoState({
    List<CatsModel> cats = const [],
    this.error = '',
    this.catsState = CubitState.initial,
    this.searchState = CubitState.initial,
    this.datasetState = CubitState.initial,
    this.catsBySupercat = const {},
    this.searchCats = const {},
    this.instanceResponseModel = const InstanceResponseModel(data: []),
    List<int> imagesId = const [],
    this.hasPagination = true,
    this.imagesModelList = const [],
    this.captions = const [],
    this.uiImage = const {},
  }) : cats = UnmodifiableListView(cats),
       imagesId = UnmodifiableListView(imagesId);

  final UnmodifiableListView<CatsModel> cats;
  final Map<int, List<CatsModel>> catsBySupercat;
  final String error;
  final CubitState catsState;
  final CubitState searchState;
  final CubitState datasetState;
  final Set<CatsModel> searchCats;
  final InstanceResponseModel instanceResponseModel;
  final UnmodifiableListView<int> imagesId;
  final bool hasPagination;
  final List<ImagesModel> imagesModelList;
  final List<CaptionsModel> captions;
  final Map<int, ui.Image> uiImage;

  CocoState copyWith({
    UnmodifiableListView<CatsModel>? cats,
    String? error,
    CubitState? catsState,
    CubitState? searchState,
    CubitState? datasetState,
    Map<int, List<CatsModel>>? catsBySupercat,
    Set<CatsModel>? searchCats,
    InstanceResponseModel? instanceResponseModel,
    UnmodifiableListView<int>? imagesId,
    bool? hasPagination,
    List<ImagesModel>? imagesModelList,
    List<CaptionsModel>? captions,
    Map<int, ui.Image>? uiImage,
  }) {
    return CocoState(
      cats: cats ?? this.cats,
      error: error ?? this.error,
      catsState: catsState ?? this.catsState,
      searchState: searchState ?? this.searchState,
      datasetState: datasetState ?? this.datasetState,
      catsBySupercat: catsBySupercat ?? this.catsBySupercat,
      searchCats: searchCats ?? this.searchCats,
      instanceResponseModel:
          instanceResponseModel ?? this.instanceResponseModel,
      imagesId: imagesId ?? this.imagesId,
      hasPagination: hasPagination ?? this.hasPagination,
      imagesModelList: imagesModelList ?? this.imagesModelList,
      captions: captions ?? this.captions,
      uiImage: uiImage ?? this.uiImage,
    );
  }

  @override
  List<Object> get props => [
    cats,
    error,
    catsState,
    searchState,
    datasetState,
    catsBySupercat,
    searchCats,
    instanceResponseModel,
    imagesId,
    hasPagination,
    imagesModelList,
    captions,
    uiImage,
  ];
}
