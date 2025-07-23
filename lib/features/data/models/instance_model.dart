import 'package:equatable/equatable.dart';
import 'package:flutter_coco_dataset/features/domain/entities/instance_entity.dart';

class InstanceResponseModel extends Equatable {
  final List<InstanceEntity> data;

  const InstanceResponseModel({
    required this.data,
  });

  factory InstanceResponseModel.fromJson(List<dynamic>? json) {
    return InstanceResponseModel(
      data:
          json
              ?.map(
                (instance) =>
                    InstanceEntity.fromJson(instance as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((instance) => instance.toJson()).toList(),
    };
  }

  InstanceResponseModel copyWith({
    List<InstanceEntity>? data,
  }) {
    return InstanceResponseModel(
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [data];
}
