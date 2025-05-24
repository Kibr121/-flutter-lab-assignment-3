import 'package:album/core/error/failures.dart';
import 'package:album/core/network/api_client.dart';
import 'package:album/data/models/album_model.dart';
import 'package:album/domain/entities/album.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:dartz/dartz.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final ApiClient apiClient;

  AlbumRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<Album>>> getAlbums() async {
    try {
      final response = await apiClient.get('/albums');
      if (response is List) {
        final albums = response
            .map((json) => AlbumModel.fromJson(json as Map<String, dynamic>).toEntity())
            .toList();
        return Right(albums);
      } else {
        return Left(ServerFailure('Invalid response format'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Album>> getAlbumById(int id) async {
    try {
      final response = await apiClient.get('/albums/$id');
      if (response is Map<String, dynamic>) {
        final album = AlbumModel.fromJson(response).toEntity();
        return Right(album);
      } else {
        return Left(ServerFailure('Invalid response format'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 