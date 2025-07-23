import 'package:equatable/equatable.dart';

class CatsModel extends Equatable {
  const CatsModel({
    required this.id,
    required this.name,
    required this.supercatId,
  });

  final int id;
  final String name;
  final int supercatId;

  String get imageUrl {
    return 'https://cocodataset.org/images/cocoicons/$id.jpg';
  }

  factory CatsModel.fromMap(Map<String, dynamic> json) {
    return CatsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      supercatId: json['supercatId'] as int,
    );
  }

  @override
  List<Object> get props => [id, name, supercatId];
}
