import 'package:flutter/material.dart';

import '../../models/manager_squad.dart';
import '../../models/player.dart';
import '../../theme/app_theme.dart';
import 'player_chip.dart';

/// Renders the 4-row pitch (GK, DEF, MID, FWD) plus a bench strip beneath.
/// Responsive: scales chip size to available width.
class PitchView extends StatelessWidget {
  const PitchView({
    super.key,
    required this.squad,
    required this.playersById,
    this.pointsById = const {},
    this.onTapPlayer,
  });

  final ManagerSquad squad;
  final Map<String, Player> playersById;
  final Map<String, int> pointsById;
  final void Function(SquadSlot slot)? onTapPlayer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 480;
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF132010), // deep, muddy green
          border: Border.all(color: AppTheme.border),
          image: const DecorationImage(
            // Subtle distressed overlay — pure CSS-like noise via solid fallback.
            image: AssetImage('assets/images/pitch_noise.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
            onError: _onErrorImage,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _row(squad, PlayerPosition.forward, compact),
            _row(squad, PlayerPosition.midfielder, compact),
            _row(squad, PlayerPosition.defender, compact),
            _row(squad, PlayerPosition.goalkeeper, compact),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.bgPanel,
                border: Border.all(color: AppTheme.border),
              ),
              child: _benchRow(compact),
            ),
          ],
        ),
      );
    });
  }

  Widget _row(ManagerSquad squad, PlayerPosition pos, bool compact) {
    final slots = squad.slots
        .where((s) => s.isStarter && s.position == pos)
        .toList(growable: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final s in slots)
            Flexible(child: _chipFor(s, compact)),
        ],
      ),
    );
  }

  Widget _benchRow(bool compact) {
    final bench = squad.orderedBench;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final s in bench) Flexible(child: _chipFor(s, compact)),
      ],
    );
  }

  Widget _chipFor(SquadSlot slot, bool compact) {
    final player = playersById[slot.playerId];
    if (player == null) {
      return SizedBox(
        width: compact ? 76 : 96,
        child: const Center(child: Text('—')),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Center(
        child: PlayerChip(
          player: player,
          isCaptain: slot.isCaptain,
          isViceCaptain: slot.isViceCaptain,
          points: pointsById[player.id],
          compact: compact,
          onTap: onTapPlayer == null ? null : () => onTapPlayer!(slot),
        ),
      ),
    );
  }
}

void _onErrorImage(Object e, StackTrace? s) {
  // swallow — the noise overlay is optional eye-candy.
}
