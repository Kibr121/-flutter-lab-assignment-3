import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:album/presentation/bloc/album_list/album_list_event.dart';
import 'package:album/presentation/bloc/album_list/album_list_state.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final AlbumRepository _albumRepository;

  AlbumListBloc({required AlbumRepository albumRepository})
      : _albumRepository = albumRepository,
        super(AlbumListInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
  }

  Future<void> _onLoadAlbums(
    LoadAlbums event,
    Emitter<AlbumListState> emit,
  ) async {
    emit(AlbumListLoading());
    try {
      final result = await _albumRepository.getAlbums();
      result.fold(
        (failure) => emit(AlbumListError(failure.message)),
        (albums) => emit(AlbumListLoaded(albums)),
      );
    } catch (e) {
      emit(AlbumListError(e.toString()));
    }
  }
} 