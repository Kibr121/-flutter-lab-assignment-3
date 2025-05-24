import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:album/presentation/viewmodels/album_list_viewmodel.dart';
import 'package:album/presentation/widgets/album_list_item.dart';
import 'package:go_router/go_router.dart';

class AlbumListPage extends StatefulWidget {
  const AlbumListPage({super.key});

  @override
  State<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  @override
  void initState() {
    super.initState();
    // Load albums when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlbumListViewModel>().loadAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: Consumer<AlbumListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.refreshAlbums(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.albums.isEmpty) {
            return const Center(
              child: Text('No albums found'),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refreshAlbums,
            child: ListView.builder(
              itemCount: viewModel.albums.length,
              itemBuilder: (context, index) {
                final album = viewModel.albums[index];
                return AlbumListItem(
                  album: album,
                  onTap: () => context.go('/album/${album.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 