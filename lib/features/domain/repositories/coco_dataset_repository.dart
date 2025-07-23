import 'package:flutter_coco_dataset/features/data/models/captions_model.dart';
import 'package:flutter_coco_dataset/features/data/models/images_model.dart';
import 'package:flutter_coco_dataset/features/data/models/instance_model.dart';

abstract class CocoDatasetRepository {
  ///* Fetch images by category ID
  Future<List<int>> getImagesIDByCatsId(List<int> imageId);

  ///* Fetch images by image IDs
  Future<List<ImagesModel>> getImagesByIds(List<int> imageIds);

  ///* Fetch instance by image ID
  Future<InstanceResponseModel?> getInstance(List<int> imageId);

  ///* Fetch captions by image IDs
  Future<List<CaptionsModel>> getCaptions(List<int> imageIds);
}