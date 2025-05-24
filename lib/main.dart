import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:album/core/network/api_client.dart';
import 'package:album/core/router/app_router.dart';
import 'package:album/data/repositories/album_repository_impl.dart';
import 'package:album/data/repositories/photo_repository_impl.dart';
import 'package:album/domain/repositories/album_repository.dart';
import 'package:album/domain/repositories/photo_repository.dart';
import 'package:album/presentation/viewmodels/album_list_viewmodel.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(client: http.Client());
    final albumRepository = AlbumRepositoryImpl(apiClient);
    final photoRepository = PhotoRepositoryImpl(apiClient);

    return MultiProvider(
      providers: [
        Provider<AlbumRepository>(
          create: (_) => albumRepository,
        ),
        Provider<PhotoRepository>(
          create: (_) => photoRepository,
        ),
        ChangeNotifierProvider<AlbumListViewModel>(
          create: (context) => AlbumListViewModel(
            context.read<AlbumRepository>(),
          ),
        ),
        BlocProvider<AlbumDetailBloc>(
          create: (context) => AlbumDetailBloc(
            albumRepository: context.read<AlbumRepository>(),
            photoRepository: context.read<PhotoRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Album App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20), // Dark green
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF1B5E20),
            secondary: const Color(0xFF2E7D32),
            tertiary: const Color(0xFF388E3C),
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFF1B5E20),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
            titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B5E20),
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
        routerConfig: AppRouter(
          albumRepository: albumRepository,
          photoRepository: photoRepository,
        ).router,
      ),
    );
  }
}
