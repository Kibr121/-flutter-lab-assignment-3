import 'package:equatable/equatable.dart';

abstract class AlbumListEvent extends Equatable {
  const AlbumListEvent();

  @override
  List<Object> get props => [];
}

class LoadAlbums extends AlbumListEvent {} 