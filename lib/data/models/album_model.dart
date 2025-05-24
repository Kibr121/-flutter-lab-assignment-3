import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:album/domain/entities/album.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required int id,
    required int userId,
    required String title,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  factory AlbumModel.fromEntity(Album album) => AlbumModel(
        id: album.id,
        userId: album.userId,
        title: album.title,
      );
}

extension AlbumModelX on AlbumModel {
  Album toEntity() => Album(
        id: id,
        userId: userId,
        title: title,
      );
} 