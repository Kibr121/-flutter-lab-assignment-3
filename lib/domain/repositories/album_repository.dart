import 'package:album/core/error/failures.dart';
import 'package:album/domain/entities/album.dart';
import 'package:dartz/dartz.dart';

abstract class AlbumRepository {
  Future<Either<Failure, List<Album>>> getAlbums();
  Future<Either<Failure, Album>> getAlbumById(int id);
} 