import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/app_theme.dart';
import '../widgets/disaster_feed_item.dart';
import '../widgets/distressed_panel.dart';

class LiveTrackerScreen extends ConsumerWidget {
  const LiveTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(disasterFeedProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.bgBase,
          title: Text('LIVE DISASTER FEED'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              feedAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => DistressedPanel(
                  title: 'ERROR',
                  accent: AppTheme.accentBlood,
                  child: Text('$e'),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const DistressedPanel(
                      title: 'AWAITING DISASTERS',
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No flops yet this gameweek.\nGet comfortable.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [for (final item in items) DisasterFeedTile(item: item)],
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
