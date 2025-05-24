import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:album/domain/repositories/photo_repository.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_event.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_state.dart';

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final AlbumRepository _albumRepository;
  final PhotoRepository _photoRepository;

  AlbumDetailBloc({
    required AlbumRepository albumRepository,
    required PhotoRepository photoRepository,
  })  : _albumRepository = albumRepository,
        _photoRepository = photoRepository,
        super(AlbumDetailInitial()) {
    on<LoadAlbumDetail>(_onLoadAlbumDetail);
  }

  Future<void> _onLoadAlbumDetail(
    LoadAlbumDetail event,
    Emitter<AlbumDetailState> emit,
  ) async {
    emit(AlbumDetailLoading());
    
    final albumResult = await _albumRepository.getAlbumById(event.albumId);
    final photosResult = await _photoRepository.getPhotosByAlbumId(event.albumId);

    albumResult.fold(
      (failure) => emit(AlbumDetailError(failure.message)),
      (album) {
        photosResult.fold(
          (failure) => emit(AlbumDetailError(failure.message)),
          (photos) => emit(AlbumDetailLoaded(album: album, photos: photos)),
        );
      },
    );
  }
} 