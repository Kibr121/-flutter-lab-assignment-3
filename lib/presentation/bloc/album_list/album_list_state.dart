import 'package:equatable/equatable.dart';
import 'package:album/domain/entities/album.dart';

abstract class AlbumListState extends Equatable {
  const AlbumListState();

  @override
  List<Object> get props => [];
}

class AlbumListInitial extends AlbumListState {}

class AlbumListLoading extends AlbumListState {}

class AlbumListLoaded extends AlbumListState {
  final List<Album> albums;

  const AlbumListLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class AlbumListError extends AlbumListState {
  final String message;

  const AlbumListError(this.message);

  @override
  List<Object> get props => [message];
} 