import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/player.dart';
import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../widgets/distressed_panel.dart';

class TransferMarketScreen extends ConsumerWidget {
  const TransferMarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(marketFilterProvider);
    final players = ref.watch(filteredMarketProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.bgBase,
          title: Text('LIABILITY MARKET'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              DistressedPanel(
                title: 'FILTERS',
                child: _Filters(filter: filter, ref: ref),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList.builder(
            itemCount: players.length,
            itemBuilder: (context, i) => _LiabilityRow(player: players[i]),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.filter, required this.ref});
  final MarketFilter filter;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search name or club',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => ref.read(marketFilterProvider.notifier).state =
              filter.copyWith(search: v),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: [
            _PositionToggle(current: filter.position, position: null, label: 'ALL'),
            for (final p in PlayerPosition.values)
              _PositionToggle(current: filter.position, position: p, label: p.short),
          ],
        ),
      ],
    );
  }
}

class _PositionToggle extends ConsumerWidget {
  const _PositionToggle({
    required this.current,
    required this.position,
    required this.label,
  });
  final PlayerPosition? current;
  final PlayerPosition? position;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = current == position;
    return InkWell(
      onTap: () {
        final f = ref.read(marketFilterProvider);
        ref.read(marketFilterProvider.notifier).state =
            f.copyWith(position: position);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentRust : AppTheme.bgRaised,
          border: Border.all(color: AppTheme.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
      ),
    );
  }
}

class _LiabilityRow extends StatelessWidget {
  const _LiabilityRow({required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.bgPanel,
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.bgRaised,
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(player.position.short,
                style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('${player.club} · ${player.country}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('£${player.price.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text('Flop ${(player.cardProneness * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
