import '../../domain/entities/entities.dart';

class RemoteUserModel extends UserEntity {
  RemoteUserModel({
    String? uid,
    required String name,
  }) : super(
          uid: uid,
          name: name,
        );

  factory RemoteUserModel.fromEntity(UserEntity entity) => RemoteUserModel(
        uid: entity.uid ?? "",
        name: entity.name,
      );

  factory RemoteUserModel.fromJson(Map<dynamic, dynamic> json) =>
      RemoteUserModel(
        uid: json['uid'] ?? "",
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid ?? "",
        'name': name,
      };
}
