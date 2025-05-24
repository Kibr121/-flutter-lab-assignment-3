import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:album/domain/entities/photo.dart';

part 'photo_model.freezed.dart';
part 'photo_model.g.dart';

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required int id,
    required int albumId,
    required String title,
    required String url,
    required String thumbnailUrl,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  factory PhotoModel.fromEntity(Photo photo) => PhotoModel(
        id: photo.id,
        albumId: photo.albumId,
        title: photo.title,
        url: photo.url,
        thumbnailUrl: photo.thumbnailUrl,
      );
}

extension PhotoModelX on PhotoModel {
  Photo toEntity() => Photo(
        id: id,
        albumId: albumId,
        title: title,
        url: url,
        thumbnailUrl: thumbnailUrl,
      );
} 