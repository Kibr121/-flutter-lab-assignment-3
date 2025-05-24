import 'package:album/core/error/failures.dart';
import 'package:album/core/network/api_client.dart';
import 'package:album/data/models/photo_model.dart';
import 'package:album/domain/entities/photo.dart';
import 'package:album/domain/repositories/photo_repository.dart';
import 'package:dartz/dartz.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final ApiClient apiClient;

  PhotoRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<Photo>>> getPhotosByAlbumId(int albumId) async {
    try {
      final response = await apiClient.get('/albums/$albumId/photos');
      final List<dynamic> jsonList = response as List<dynamic>;
      final photos = jsonList
          .map((json) => PhotoModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
          
      return Right(photos);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 