import 'package:flutter_coco_dataset/features/data/data_sources/remote/coco_dataset_service.dart';
import 'package:flutter_coco_dataset/features/data/models/captions_model.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/data/models/instance_model.dart';
import 'package:flutter_coco_dataset/features/domain/repositories/coco_dataset_repository.dart';
import 'package:flutter_coco_dataset/utils/app/app_logger.dart';

class CocoDatasetRepositoryImple implements CocoDatasetRepository {
  CocoDatasetRepositoryImple({required CocoDatasetService cocoDatasetService})
    : _cocoDatasetService = cocoDatasetService;

  final CocoDatasetService _cocoDatasetService;

  @override
  Future<List<CaptionsModel>> getCaptions(List<int> imageIds) async {
    try {
      return await _cocoDatasetService.getCaptions(imageIds);
    } catch (e) {
      // Handle error appropriately
      AppLogger.e('Error fetching captions: $e');
      return Future.error(e);
    }
  }

  @override
  Future<List<ImagesModel>> getImagesByIds(List<int> imageIds) {
    try {
      return _cocoDatasetService.getImages(imageIds);
    } catch (e) {
      // Handle error appropriately
      AppLogger.e('Error fetching images: $e');
      return Future.error(e);
    }
  }

  @override
  Future<List<int>> getImagesIDByCatsId(List<int> imageId) {
    try {
      return _cocoDatasetService.getImagesIDByCatsId(imageId);
    } catch (e) {
      // Handle error appropriately
      AppLogger.e('Error fetching image IDs by category: $e');
      return Future.error(e);
    }
  }

  @override
  Future<InstanceResponseModel?> getInstance(List<int> imageId) {
    try {
      return _cocoDatasetService.getInstance(imageId);
    } catch (e) {
      // Handle error appropriately
      AppLogger.e('Error fetching instance: $e');
      return Future.error(e);
    }
  }
}
