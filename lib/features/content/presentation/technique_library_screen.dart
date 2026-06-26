import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/models/technique.dart';
import 'providers/technique_provider.dart';

class TechniqueLibraryScreen extends ConsumerWidget {
  const TechniqueLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSystem = ref.watch(selectedSystemProvider);
    final selectedPosition = ref.watch(selectedPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Technique Library'),
        actions: [
          if (selectedPosition != null)
            TextButton(
              onPressed: () => ref.read(selectedPositionProvider.notifier).state = null,
              child: const Text('Systems'),
            ),
        ],
      ),
      body: Column(
        children: [
          // System picker
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: TechniqueSystems.all.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final sys = TechniqueSystems.all[i];
                final isActive = sys == selectedSystem;
                return FilterChip(
                  label: Text(sys, style: TextStyle(fontSize: 12, color: isActive ? Colors.white : null)),
                  selected: isActive,
                  onSelected: (_) {
                    ref.read(selectedSystemProvider.notifier).state = sys;
                    ref.read(selectedPositionProvider.notifier).state = null;
                  },
                  selectedColor: AppTheme.brandRed,
                  checkmarkColor: Colors.white,
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selectedPosition == null
                ? _PositionList(system: selectedSystem)
                : _TechniqueList(system: selectedSystem, position: selectedPosition),
          ),
        ],
      ),
    );
  }
}

class _PositionList extends ConsumerWidget {
  const _PositionList({required this.system});
  final String system;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = ref.watch(positionsForSystemProvider(system));
    final techAsync = ref.watch(techniquesBySystemProvider(system));

    if (techAsync.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.brandRed));
    }

    if (positions.isEmpty) {
      return Center(
        child: Text('No techniques yet for $system.', style: Theme.of(context).textTheme.bodySmall),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final position = positions[i];
        final count = techAsync.valueOrNull?.where((t) => t.position == position).length ?? 0;
        return Card(
          child: ListTile(
            title: Text(position),
            subtitle: Text('$count technique${count == 1 ? '' : 's'}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => ref.read(selectedPositionProvider.notifier).state = position,
          ),
        );
      },
    );
  }
}

class _TechniqueList extends ConsumerWidget {
  const _TechniqueList({required this.system, required this.position});
  final String system;
  final String position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techAsync = ref.watch(techniquesByPositionProvider((system: system, position: position)));

    return techAsync.when(
      data: (techniques) {
        if (techniques.isEmpty) {
          return Center(child: Text('No techniques in $position yet.', style: Theme.of(context).textTheme.bodySmall));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: techniques.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) => _TechniqueCard(technique: techniques[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandRed)),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _TechniqueCard extends StatelessWidget {
  const _TechniqueCard({required this.technique});
  final Technique technique;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/library/${technique.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (technique.thumbnailUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(technique.thumbnailUrl!, width: 72, height: 56, fit: BoxFit.cover),
                )
              else
                Container(
                  width: 72,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(technique.videoUrl != null ? Icons.play_circle_outline : Icons.sports_martial_arts, color: AppTheme.brandRed),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(technique.title, style: Theme.of(context).textTheme.titleMedium),
                    Text(technique.position, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(technique.beltLevel.name, style: const TextStyle(fontSize: 10)),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
