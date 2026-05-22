import 'package:flutter/material.dart';

import '../../models/match_stats.dart';
import '../../theme/app_theme.dart';

class DisasterFeedTile extends StatelessWidget {
  const DisasterFeedTile({super.key, required this.item});
  final DisasterFeedItem item;

  @override
  Widget build(BuildContext context) {
    final color = DisasterPalette.forPoints(item.points);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.bgPanel,
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: const BorderSide(color: AppTheme.border),
          right: const BorderSide(color: AppTheme.border),
          bottom: const BorderSide(color: AppTheme.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              "${item.minute}'",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.textMuted),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.playerName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  _label(item.event),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: color,
            child: Text(
              '+${item.points}',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _label(DisasterEvent e) => switch (e) {
        DisasterEvent.ownGoal => 'OWN GOAL',
        DisasterEvent.redCard => 'RED CARD',
        DisasterEvent.yellowCard => 'YELLOW CARD',
        DisasterEvent.secondYellow => 'SECOND YELLOW',
        DisasterEvent.missedPenalty => 'MISSED PENALTY',
        DisasterEvent.penaltySaved => 'PENALTY SAVED AGAINST',
        DisasterEvent.giveawayPenalty => 'CONCEDED PENALTY',
        DisasterEvent.goalConceded => 'GOAL CONCEDED',
        DisasterEvent.cleanSheetFailureGk => 'GK SHIPPED 2+',
        DisasterEvent.cleanSheetFailureDef => 'DEF SHIPPED 2+',
        DisasterEvent.subbedOffEarly => 'HOOKED BEFORE 60’',
        DisasterEvent.didNotPlay => 'DID NOT PLAY',
        DisasterEvent.injuryOff => 'INJURED OFF',
        DisasterEvent.bigChanceMissed => 'BIG CHANCE MISSED',
        DisasterEvent.errorLeadingToGoal => 'ERROR LED TO GOAL',
        DisasterEvent.hitWoodwork => 'HIT WOODWORK',
        DisasterEvent.matchLost => 'MATCH LOST',
        DisasterEvent.heavyDefeat => 'HEAVY DEFEAT (3+)',
      };
}
