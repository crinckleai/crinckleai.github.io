import 'package:equatable/equatable.dart';

/// Atomic disaster event types — these directly drive [ScoringEngine] output.
enum DisasterEvent {
  ownGoal,
  redCard,
  yellowCard,
  secondYellow,
  missedPenalty,
  penaltySaved, // had a penalty saved against them
  giveawayPenalty, // conceded a penalty
  goalConceded, // each goal conceded while on pitch (GK/DEF)
  cleanSheetFailureGk, // GK conceded 2+
  cleanSheetFailureDef, // DEF conceded 2+
  subbedOffEarly, // hauled off before 60'
  didNotPlay, // 0 minutes
  injuryOff, // came off injured
  bigChanceMissed, // expected goal flopped
  errorLeadingToGoal,
  hitWoodwork, // (irony bonus — "so close to glory")
  matchLost,
  heavyDefeat, // lost by 3+
}

/// Per-match performance of a single player, used by [ScoringEngine].
///
/// Numeric counters can be > 0 for events that may repeat in a match
/// (yellows max 1, goals conceded 0..N, etc.). The model is intentionally
/// dumb — all scoring rules live in `ScoringEngine`.
class MatchStats extends Equatable {
  const MatchStats({
    required this.playerId,
    required this.matchId,
    this.minutesPlayed = 0,
    this.ownGoals = 0,
    this.redCards = 0,
    this.yellowCards = 0,
    this.secondYellows = 0,
    this.missedPenalties = 0,
    this.penaltiesHadSaved = 0,
    this.penaltiesGivenAway = 0,
    this.goalsConceded = 0,
    this.subbedOffBefore60 = false,
    this.injuredOff = false,
    this.bigChancesMissed = 0,
    this.errorsLeadingToGoal = 0,
    this.hitWoodwork = 0,
    this.teamLost = false,
    this.teamLostHeavily = false,
    this.didNotAppear = false,
  });

  final String playerId;
  final String matchId;

  final int minutesPlayed;

  // Disasters
  final int ownGoals;
  final int redCards;
  final int yellowCards;
  final int secondYellows;
  final int missedPenalties;
  final int penaltiesHadSaved;
  final int penaltiesGivenAway;
  final int goalsConceded;
  final bool subbedOffBefore60;
  final bool injuredOff;
  final int bigChancesMissed;
  final int errorsLeadingToGoal;
  final int hitWoodwork;
  final bool teamLost;
  final bool teamLostHeavily;
  final bool didNotAppear;

  bool get appeared => !didNotAppear && minutesPlayed > 0;

  Map<String, dynamic> toMap() => {
        'playerId': playerId,
        'matchId': matchId,
        'minutesPlayed': minutesPlayed,
        'ownGoals': ownGoals,
        'redCards': redCards,
        'yellowCards': yellowCards,
        'secondYellows': secondYellows,
        'missedPenalties': missedPenalties,
        'penaltiesHadSaved': penaltiesHadSaved,
        'penaltiesGivenAway': penaltiesGivenAway,
        'goalsConceded': goalsConceded,
        'subbedOffBefore60': subbedOffBefore60,
        'injuredOff': injuredOff,
        'bigChancesMissed': bigChancesMissed,
        'errorsLeadingToGoal': errorsLeadingToGoal,
        'hitWoodwork': hitWoodwork,
        'teamLost': teamLost,
        'teamLostHeavily': teamLostHeavily,
        'didNotAppear': didNotAppear,
      };

  factory MatchStats.fromMap(Map<String, dynamic> map) => MatchStats(
        playerId: map['playerId'] as String,
        matchId: map['matchId'] as String,
        minutesPlayed: (map['minutesPlayed'] as num?)?.toInt() ?? 0,
        ownGoals: (map['ownGoals'] as num?)?.toInt() ?? 0,
        redCards: (map['redCards'] as num?)?.toInt() ?? 0,
        yellowCards: (map['yellowCards'] as num?)?.toInt() ?? 0,
        secondYellows: (map['secondYellows'] as num?)?.toInt() ?? 0,
        missedPenalties: (map['missedPenalties'] as num?)?.toInt() ?? 0,
        penaltiesHadSaved: (map['penaltiesHadSaved'] as num?)?.toInt() ?? 0,
        penaltiesGivenAway: (map['penaltiesGivenAway'] as num?)?.toInt() ?? 0,
        goalsConceded: (map['goalsConceded'] as num?)?.toInt() ?? 0,
        subbedOffBefore60: map['subbedOffBefore60'] as bool? ?? false,
        injuredOff: map['injuredOff'] as bool? ?? false,
        bigChancesMissed: (map['bigChancesMissed'] as num?)?.toInt() ?? 0,
        errorsLeadingToGoal: (map['errorsLeadingToGoal'] as num?)?.toInt() ?? 0,
        hitWoodwork: (map['hitWoodwork'] as num?)?.toInt() ?? 0,
        teamLost: map['teamLost'] as bool? ?? false,
        teamLostHeavily: map['teamLostHeavily'] as bool? ?? false,
        didNotAppear: map['didNotAppear'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        playerId,
        matchId,
        minutesPlayed,
        ownGoals,
        redCards,
        yellowCards,
        secondYellows,
        missedPenalties,
        penaltiesHadSaved,
        penaltiesGivenAway,
        goalsConceded,
        subbedOffBefore60,
        injuredOff,
        bigChancesMissed,
        errorsLeadingToGoal,
        hitWoodwork,
        teamLost,
        teamLostHeavily,
        didNotAppear,
      ];
}

/// A single line on the live "disaster feed".
class DisasterFeedItem extends Equatable {
  const DisasterFeedItem({
    required this.matchId,
    required this.playerId,
    required this.playerName,
    required this.event,
    required this.points,
    required this.minute,
    required this.timestamp,
  });

  final String matchId;
  final String playerId;
  final String playerName;
  final DisasterEvent event;
  final int points;
  final int minute;
  final DateTime timestamp;

  @override
  List<Object?> get props => [matchId, playerId, event, points, minute, timestamp];
}
