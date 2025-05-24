import 'package:equatable/equatable.dart';
import 'package:album/domain/entities/album.dart';
import 'package:album/domain/entities/photo.dart';

abstract class AlbumDetailState extends Equatable {
  const AlbumDetailState();

  @override
  List<Object> get props => [];
}

class AlbumDetailInitial extends AlbumDetailState {}

class AlbumDetailLoading extends AlbumDetailState {}

class AlbumDetailError extends AlbumDetailState {
  final String message;

  const AlbumDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class AlbumDetailLoaded extends AlbumDetailState {
  final Album album;
  final List<Photo> photos;

  const AlbumDetailLoaded({required this.album, required this.photos});

  @override
  List<Object> get props => [album, photos];
} 