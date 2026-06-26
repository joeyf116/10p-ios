import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/technique.dart';
import '../domain/repositories/technique_library_repository.dart';

final _techniqueDetailProvider = FutureProvider.family<Technique?, String>(
  (ref, id) => serviceLocator<TechniqueLibraryRepository>().getTechnique(id),
);

class TechniqueDetailScreen extends ConsumerStatefulWidget {
  const TechniqueDetailScreen({required this.techniqueId, super.key});

  final String techniqueId;

  @override
  ConsumerState<TechniqueDetailScreen> createState() => _TechniqueDetailScreenState();
}

class _TechniqueDetailScreenState extends ConsumerState<TechniqueDetailScreen> {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;

  @override
  void dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    super.dispose();
  }

  void _initVideo(String url) {
    if (_videoCtrl != null) return;
    _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(url));
    _chewieCtrl = ChewieController(
      videoPlayerController: _videoCtrl!,
      autoInitialize: true,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final techAsync = ref.watch(_techniqueDetailProvider(widget.techniqueId));

    return Scaffold(
      appBar: AppBar(title: const Text('Technique')),
      body: techAsync.when(
        data: (technique) {
          if (technique == null) {
            return const Center(child: Text('Technique not found.'));
          }
          if (technique.videoUrl != null) _initVideo(technique.videoUrl!);
          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              if (_chewieCtrl != null)
                AspectRatio(aspectRatio: 16 / 9, child: Chewie(controller: _chewieCtrl!))
              else
                Container(
                  height: 200,
                  color: Colors.black,
                  child: const Center(child: Icon(Icons.sports_martial_arts, color: AppTheme.brandRed, size: 64)),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(technique.title, style: Theme.of(context).textTheme.titleLarge)),
                        Chip(
                          label: Text(technique.beltLevel.name, style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${technique.system} › ${technique.position}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.brandRed)),
                    const SizedBox(height: 16),
                    Text(technique.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                    if (technique.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: technique.tags.map((t) => Chip(label: Text(t, style: const TextStyle(fontSize: 11)), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact)).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandRed)),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
