import 'package:equatable/equatable.dart';

abstract class AlbumDetailEvent extends Equatable {
  const AlbumDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAlbumDetail extends AlbumDetailEvent {
  final int albumId;

  const LoadAlbumDetail(this.albumId);

  @override
  List<Object> get props => [albumId];
} 