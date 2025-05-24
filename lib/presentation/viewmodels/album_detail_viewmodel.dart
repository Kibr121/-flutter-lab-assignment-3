import 'package:flutter/foundation.dart';
import 'package:album/domain/entities/album.dart';
import 'package:album/domain/entities/photo.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:album/domain/repositories/photo_repository.dart';

class AlbumDetailViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  final PhotoRepository _photoRepository;
  final int albumId;

  Album? _album;
  List<Photo> _photos = [];
  bool _isLoading = false;
  String? _error;

  AlbumDetailViewModel({
    required this._albumRepository,
    required this._photoRepository,
    required this.albumId,
  });

  // Getters
  Album? get album => _album;
  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load album details
  Future<void> loadAlbumDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final albumResult = await _albumRepository.getAlbumById(albumId);
      final photosResult = await _photoRepository.getPhotosByAlbumId(albumId);

      albumResult.fold(
        (failure) {
          _error = failure.message;
          _album = null;
        },
        (album) {
          _album = album;
          _error = null;
        },
      );

      photosResult.fold(
        (failure) {
          _error = failure.message;
          _photos = [];
        },
        (photos) {
          _photos = photos;
        },
      );
    } catch (e) {
      _error = e.toString();
      _album = null;
      _photos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh album details
  Future<void> refreshAlbumDetails() async {
    await loadAlbumDetails();
  }
} 