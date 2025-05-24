import 'package:album/core/error/failures.dart';
import 'package:album/domain/entities/photo.dart';
import 'package:dartz/dartz.dart';

abstract class PhotoRepository {
  Future<Either<Failure, List<Photo>>> getPhotosByAlbumId(int albumId);
} 