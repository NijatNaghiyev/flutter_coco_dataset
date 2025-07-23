import 'package:equatable/equatable.dart';

class CaptionsModel extends Equatable {
  final String? caption;
  final int? imageId;

  const CaptionsModel({
    this.caption,
    this.imageId,
  });

  factory CaptionsModel.fromJson(Map<String, dynamic> json) {
    return CaptionsModel(
      caption: json['caption'] as String?,
      imageId: json['image_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'image_id': imageId,
    };
  }

  @override
  List<Object?> get props => [caption, imageId];
}