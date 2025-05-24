import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_bloc.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_event.dart';
import 'package:album/presentation/bloc/album_detail/album_detail_state.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumDetailPage extends StatefulWidget {
  final int albumId;

  const AlbumDetailPage({
    super.key,
    required this.albumId,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadAlbumDetails();
  }

  @override
  void didUpdateWidget(AlbumDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.albumId != widget.albumId) {
      _loadAlbumDetails();
    }
  }

  void _loadAlbumDetails() {
    context.read<AlbumDetailBloc>().add(LoadAlbumDetail(widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Album ${widget.albumId}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
        builder: (context, state) {
          if (state is AlbumDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumDetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            );
          } else if (state is AlbumDetailLoaded) {
            return _buildAlbumDetails(context, state);
          } else if (state is AlbumDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getErrorMessage(state.message),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadAlbumDetails,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAlbumDetails(BuildContext context, AlbumDetailLoaded state) {
    final colorScheme = Theme.of(context).colorScheme;
    final String imageUrl = 'https://picsum.photos/800/600?random=${state.album.id}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Album Image
          Container(
            height: 400,
            color: colorScheme.surfaceContainerHighest,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Album Details Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: colorScheme.surfaceContainerLowest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album Title Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Album Title',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.album.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Album Information Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Album Information',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        'Album ID',
                        state.album.id.toString(),
                        Icons.photo_album_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        'User ID',
                        state.album.userId.toString(),
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        'Total Photos',
                        state.photos.length.toString(),
                        Icons.photo_library_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('SocketException') || error.contains('NetworkError')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.contains('TimeoutException')) {
      return 'The request timed out. Please try again.';
    } else if (error.contains('404')) {
      return 'The requested resource was not found.';
    } else if (error.contains('500')) {
      return 'Server error occurred. Please try again later.';
    }
    return 'An error occurred: $error';
  }
} 