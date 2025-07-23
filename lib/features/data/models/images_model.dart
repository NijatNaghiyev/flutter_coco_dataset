import 'package:equatable/equatable.dart';

class ImagesModel extends Equatable {
  final int? id;
  final String? cocoUrl;
  final String? flickrUrl;

  const ImagesModel({
    this.id,
    this.cocoUrl,
    this.flickrUrl,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      id: json['id'] as int?,
      cocoUrl: json['coco_url'] as String?,
      flickrUrl: json['flickr_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coco_url': cocoUrl,
      'flickr_url': flickrUrl,
    };
  }

  @override
  List<Object?> get props => [id, cocoUrl, flickrUrl];
}
