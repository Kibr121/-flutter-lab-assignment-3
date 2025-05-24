import 'package:flutter/foundation.dart';
import 'package:album/domain/entities/album.dart';
import 'package:album/domain/repositories/album_repository.dart';

class AlbumListViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  
  List<Album> _albums = [];
  bool _isLoading = false;
  String? _error;

  AlbumListViewModel(this._albumRepository);

  // Getters
  List<Album> get albums => _albums;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load albums
  Future<void> loadAlbums() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _albumRepository.getAlbums();
      result.fold(
        (failure) {
          _error = failure.message;
          _albums = [];
        },
        (albums) {
          _albums = albums;
          _error = null;
        },
      );
    } catch (e) {
      _error = e.toString();
      _albums = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh albums
  Future<void> refreshAlbums() async {
    await loadAlbums();
  }
} 