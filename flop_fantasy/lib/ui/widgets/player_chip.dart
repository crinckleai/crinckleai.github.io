import 'package:flutter/material.dart';

import '../../models/player.dart';
import '../../theme/app_theme.dart';

/// The football-shirt-style chip used on the pitch view and in lists.
class PlayerChip extends StatelessWidget {
  const PlayerChip({
    super.key,
    required this.player,
    this.isCaptain = false,
    this.isViceCaptain = false,
    this.points,
    this.onTap,
    this.compact = false,
  });

  final Player player;
  final bool isCaptain;
  final bool isViceCaptain;
  final int? points;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accentForPosition(player.position);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: compact ? 76 : 96,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.bgRaised,
          border: Border.all(color: AppTheme.border),
          borderRadius: const BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: compact ? 32 : 42,
                  height: compact ? 32 : 42,
                  decoration: BoxDecoration(
                    color: accent,
                    border: Border.all(color: AppTheme.border, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                    child: Text(
                      player.position.short,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isCaptain)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child: _CaptainBadge(letter: 'C'),
                  ),
                if (isViceCaptain)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child: _CaptainBadge(letter: 'V'),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _lastName(player.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: points == null ? AppTheme.bgPanel : DisasterPalette.forPoints(points!),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                points == null ? '£${player.price.toStringAsFixed(1)}' : '$points',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lastName(String full) {
    final parts = full.trim().split(RegExp(r'\s+'));
    return parts.length == 1 ? parts.first : parts.last;
  }

  Color _accentForPosition(PlayerPosition pos) {
    return switch (pos) {
      PlayerPosition.goalkeeper => AppTheme.accentMustard,
      PlayerPosition.defender => AppTheme.accentBruise,
      PlayerPosition.midfielder => AppTheme.accentRust,
      PlayerPosition.forward => AppTheme.accentBlood,
    };
  }
}

class _CaptainBadge extends StatelessWidget {
  const _CaptainBadge({required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: AppTheme.accentMustard,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppTheme.bgBase,
          ),
        ),
      ),
    );
  }
}
