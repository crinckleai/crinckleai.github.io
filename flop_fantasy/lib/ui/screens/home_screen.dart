import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/player.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../widgets/distressed_panel.dart';
import '../widgets/pitch_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squadAsync = ref.watch(squadStreamProvider);
    final playersAsync = ref.watch(playersStreamProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          backgroundColor: AppTheme.bgBase,
          title: const Text('FLOP FANTASY'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: () {},
              tooltip: 'Save squad',
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              const _HeaderStrip(),
              const SizedBox(height: 8),
              squadAsync.when(
                loading: () => const _Loading('Loading squad…'),
                error: (e, _) => _ErrorBox('Failed to load squad: $e'),
                data: (squad) {
                  if (squad == null) {
                    return const DistressedPanel(
                      title: 'YOUR PITCH',
                      child: _EmptySquadHint(),
                    );
                  }
                  final players = playersAsync.maybeWhen(
                    data: (p) => {for (final pl in p) pl.id: pl},
                    orElse: () => <String, Player>{},
                  );
                  return DistressedPanel(
                    title: 'YOUR PITCH — GW${squad.gameweek}',
                    trailing: Text(
                      '£${squad.budgetRemaining.toStringAsFixed(1)} BANK',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    padding: EdgeInsets.zero,
                    child: PitchView(squad: squad, playersById: players),
                  );
                },
              ),
              const SizedBox(height: 16),
              const DistressedPanel(
                title: 'CHIPS',
                child: _ChipRow(),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }
}

class _HeaderStrip extends StatelessWidget {
  const _HeaderStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgPanel,
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DRAFT THE WORST. CASH IN ON CHAOS.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Points come from disasters — own goals, red cards, missed pens.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.warning_amber, color: AppTheme.accentRust, size: 36),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _Chip(label: 'TRIPLE CAPTAIN'),
        _Chip(label: 'BENCH BOOST'),
        _Chip(label: 'WILDCARD'),
        _Chip(label: 'FREE HIT'),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.bgRaised,
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading(this.msg);
  final String msg;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(msg),
          ],
        ),
      );
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.msg);
  final String msg;
  @override
  Widget build(BuildContext context) => DistressedPanel(
        title: 'ERROR',
        accent: AppTheme.accentBlood,
        child: Text(msg),
      );
}

class _EmptySquadHint extends StatelessWidget {
  const _EmptySquadHint();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.sports_soccer, size: 48, color: AppTheme.textMuted),
          const SizedBox(height: 8),
          Text(
            'No squad yet. Head to the Market to draft your flops.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
