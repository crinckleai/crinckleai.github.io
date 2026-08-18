import 'package:equatable/equatable.dart';

import 'player.dart';

/// The "starting XI + bench" structure for a manager's gameweek squad.
///
/// Flop Fantasy uses the same 15-man shape as FPL: 2 GK + 5 DEF + 5 MID + 3 FWD.
/// Starting XI must satisfy: 1 GK, 3-5 DEF, 2-5 MID, 1-3 FWD, total 11.
class SquadSlot extends Equatable {
  const SquadSlot({
    required this.playerId,
    required this.position,
    required this.isStarter,
    this.benchOrder,
    this.isCaptain = false,
    this.isViceCaptain = false,
  });

  final String playerId;
  final PlayerPosition position;
  final bool isStarter;

  /// 1..4 for bench order (1 is first sub on). Null for starters.
  final int? benchOrder;

  /// Captain points are doubled (in Flop Fantasy: double-the-flop).
  final bool isCaptain;
  final bool isViceCaptain;

  SquadSlot copyWith({
    String? playerId,
    PlayerPosition? position,
    bool? isStarter,
    int? benchOrder,
    bool? isCaptain,
    bool? isViceCaptain,
  }) {
    return SquadSlot(
      playerId: playerId ?? this.playerId,
      position: position ?? this.position,
      isStarter: isStarter ?? this.isStarter,
      benchOrder: benchOrder ?? this.benchOrder,
      isCaptain: isCaptain ?? this.isCaptain,
      isViceCaptain: isViceCaptain ?? this.isViceCaptain,
    );
  }

  Map<String, dynamic> toMap() => {
        'playerId': playerId,
        'position': position.name,
        'isStarter': isStarter,
        'benchOrder': benchOrder,
        'isCaptain': isCaptain,
        'isViceCaptain': isViceCaptain,
      };

  factory SquadSlot.fromMap(Map<String, dynamic> map) => SquadSlot(
        playerId: map['playerId'] as String,
        position: PlayerPositionX.fromString(map['position'] as String),
        isStarter: map['isStarter'] as bool? ?? false,
        benchOrder: (map['benchOrder'] as num?)?.toInt(),
        isCaptain: map['isCaptain'] as bool? ?? false,
        isViceCaptain: map['isViceCaptain'] as bool? ?? false,
      );

  @override
  List<Object?> get props =>
      [playerId, position, isStarter, benchOrder, isCaptain, isViceCaptain];
}

class ManagerSquad extends Equatable {
  const ManagerSquad({
    required this.managerId,
    required this.gameweek,
    required this.slots,
    this.budgetRemaining = 0.0,
    this.freeTransfers = 1,
    this.transfersMade = 0,
    this.tripleCaptainUsed = false,
    this.benchBoostUsed = false,
    this.wildcardUsed = false,
  });

  final String managerId;
  final int gameweek;
  final List<SquadSlot> slots; // exactly 15
  final double budgetRemaining;
  final int freeTransfers;
  final int transfersMade;
  final bool tripleCaptainUsed;
  final bool benchBoostUsed;
  final bool wildcardUsed;

  Iterable<SquadSlot> get starters => slots.where((s) => s.isStarter);

  List<SquadSlot> get orderedBench {
    final b = slots.where((s) => !s.isStarter).toList();
    b.sort((x, y) => (x.benchOrder ?? 99).compareTo(y.benchOrder ?? 99));
    return b;
  }

  SquadSlot? get captain {
    for (final s in slots) {
      if (s.isCaptain) return s;
    }
    return null;
  }

  SquadSlot? get viceCaptain {
    for (final s in slots) {
      if (s.isViceCaptain) return s;
    }
    return null;
  }

  /// Validates basic squad shape. Returns null if valid, else a reason string.
  String? validate() {
    if (slots.length != 15) return 'Squad must have exactly 15 players.';
    final ids = slots.map((s) => s.playerId).toSet();
    if (ids.length != slots.length) return 'Duplicate players in squad.';
    final starters = slots.where((s) => s.isStarter).toList();
    if (starters.length != 11) return 'Starting XI must have exactly 11 players.';
    final gk = starters.where((s) => s.position == PlayerPosition.goalkeeper).length;
    final def = starters.where((s) => s.position == PlayerPosition.defender).length;
    final mid = starters.where((s) => s.position == PlayerPosition.midfielder).length;
    final fwd = starters.where((s) => s.position == PlayerPosition.forward).length;
    if (gk != 1) return 'Exactly 1 goalkeeper must start.';
    if (def < 3 || def > 5) return 'Starting defenders must be 3-5.';
    if (mid < 2 || mid > 5) return 'Starting midfielders must be 2-5.';
    if (fwd < 1 || fwd > 3) return 'Starting forwards must be 1-3.';
    final captains = slots.where((s) => s.isCaptain).length;
    if (captains != 1) return 'Exactly one captain required.';
    return null;
  }

  ManagerSquad copyWith({
    String? managerId,
    int? gameweek,
    List<SquadSlot>? slots,
    double? budgetRemaining,
    int? freeTransfers,
    int? transfersMade,
    bool? tripleCaptainUsed,
    bool? benchBoostUsed,
    bool? wildcardUsed,
  }) {
    return ManagerSquad(
      managerId: managerId ?? this.managerId,
      gameweek: gameweek ?? this.gameweek,
      slots: slots ?? this.slots,
      budgetRemaining: budgetRemaining ?? this.budgetRemaining,
      freeTransfers: freeTransfers ?? this.freeTransfers,
      transfersMade: transfersMade ?? this.transfersMade,
      tripleCaptainUsed: tripleCaptainUsed ?? this.tripleCaptainUsed,
      benchBoostUsed: benchBoostUsed ?? this.benchBoostUsed,
      wildcardUsed: wildcardUsed ?? this.wildcardUsed,
    );
  }

  Map<String, dynamic> toMap() => {
        'managerId': managerId,
        'gameweek': gameweek,
        'slots': slots.map((s) => s.toMap()).toList(),
        'budgetRemaining': budgetRemaining,
        'freeTransfers': freeTransfers,
        'transfersMade': transfersMade,
        'tripleCaptainUsed': tripleCaptainUsed,
        'benchBoostUsed': benchBoostUsed,
        'wildcardUsed': wildcardUsed,
      };

  factory ManagerSquad.fromMap(Map<String, dynamic> map) => ManagerSquad(
        managerId: map['managerId'] as String,
        gameweek: (map['gameweek'] as num).toInt(),
        slots: (map['slots'] as List)
            .map((s) => SquadSlot.fromMap(s as Map<String, dynamic>))
            .toList(),
        budgetRemaining: (map['budgetRemaining'] as num?)?.toDouble() ?? 0.0,
        freeTransfers: (map['freeTransfers'] as num?)?.toInt() ?? 1,
        transfersMade: (map['transfersMade'] as num?)?.toInt() ?? 0,
        tripleCaptainUsed: map['tripleCaptainUsed'] as bool? ?? false,
        benchBoostUsed: map['benchBoostUsed'] as bool? ?? false,
        wildcardUsed: map['wildcardUsed'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        managerId,
        gameweek,
        slots,
        budgetRemaining,
        freeTransfers,
        transfersMade,
        tripleCaptainUsed,
        benchBoostUsed,
        wildcardUsed,
      ];
}
