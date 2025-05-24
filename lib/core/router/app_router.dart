import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:album/domain/repositories/photo_repository.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_bloc.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_event.dart';
import 'package:album/presentation/pages/album_detail_page.dart';
import 'package:album/presentation/pages/album_list_page.dart';

class AppRouter {
  final AlbumRepository albumRepository;
  final PhotoRepository photoRepository;

  AppRouter({
    required this.albumRepository,
    required this.photoRepository,
  });

  late final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListPage(),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['id']!);
          context.read<AlbumDetailBloc>().add(LoadAlbumDetail(albumId));
          return AlbumDetailPage(albumId: albumId);
        },
      ),
    ],
  );
} 