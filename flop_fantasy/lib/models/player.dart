import 'package:equatable/equatable.dart';

/// Position on the pitch. Used by lineup constraints and scoring multipliers.
enum PlayerPosition { goalkeeper, defender, midfielder, forward }

extension PlayerPositionX on PlayerPosition {
  String get short => switch (this) {
        PlayerPosition.goalkeeper => 'GK',
        PlayerPosition.defender => 'DEF',
        PlayerPosition.midfielder => 'MID',
        PlayerPosition.forward => 'FWD',
      };

  static PlayerPosition fromString(String value) {
    return PlayerPosition.values.firstWhere(
      (p) => p.name == value || p.short == value,
      orElse: () => PlayerPosition.midfielder,
    );
  }
}

/// A flop-able footballer. The price is a "liability index": higher means
/// historically more flop-prone, so they cost more to draft in Flop Fantasy.
class Player extends Equatable {
  const Player({
    required this.id,
    required this.name,
    required this.club,
    required this.country,
    required this.position,
    required this.price,
    this.injuryRisk = 0.0,
    this.cardProneness = 0.0,
    this.ownGoalIndex = 0.0,
    this.netTransfersIn = 0,
    this.netTransfersOut = 0,
    this.totalOwnership = 0.0,
    this.available = true,
  });

  final String id;
  final String name;
  final String club;
  final String country;
  final PlayerPosition position;

  /// "Liability" price in app currency (e.g. 4.0 to 12.5).
  final double price;

  /// 0..1 historical likelihood of an injury in a gameweek.
  final double injuryRisk;

  /// 0..1 historical likelihood of receiving a card.
  final double cardProneness;

  /// 0..1 historical likelihood of scoring an own goal in a gameweek.
  final double ownGoalIndex;

  /// Aggregates used by [PriceManager].
  final int netTransfersIn;
  final int netTransfersOut;
  final double totalOwnership; // 0..1

  /// Whether the player is currently selectable.
  final bool available;

  int get netTransfers => netTransfersIn - netTransfersOut;

  Player copyWith({
    String? id,
    String? name,
    String? club,
    String? country,
    PlayerPosition? position,
    double? price,
    double? injuryRisk,
    double? cardProneness,
    double? ownGoalIndex,
    int? netTransfersIn,
    int? netTransfersOut,
    double? totalOwnership,
    bool? available,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      club: club ?? this.club,
      country: country ?? this.country,
      position: position ?? this.position,
      price: price ?? this.price,
      injuryRisk: injuryRisk ?? this.injuryRisk,
      cardProneness: cardProneness ?? this.cardProneness,
      ownGoalIndex: ownGoalIndex ?? this.ownGoalIndex,
      netTransfersIn: netTransfersIn ?? this.netTransfersIn,
      netTransfersOut: netTransfersOut ?? this.netTransfersOut,
      totalOwnership: totalOwnership ?? this.totalOwnership,
      available: available ?? this.available,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'club': club,
        'country': country,
        'position': position.name,
        'price': price,
        'injuryRisk': injuryRisk,
        'cardProneness': cardProneness,
        'ownGoalIndex': ownGoalIndex,
        'netTransfersIn': netTransfersIn,
        'netTransfersOut': netTransfersOut,
        'totalOwnership': totalOwnership,
        'available': available,
      };

  factory Player.fromMap(Map<String, dynamic> map) => Player(
        id: map['id'] as String,
        name: map['name'] as String,
        club: map['club'] as String? ?? '',
        country: map['country'] as String? ?? '',
        position: PlayerPositionX.fromString(map['position'] as String? ?? 'midfielder'),
        price: (map['price'] as num?)?.toDouble() ?? 4.0,
        injuryRisk: (map['injuryRisk'] as num?)?.toDouble() ?? 0.0,
        cardProneness: (map['cardProneness'] as num?)?.toDouble() ?? 0.0,
        ownGoalIndex: (map['ownGoalIndex'] as num?)?.toDouble() ?? 0.0,
        netTransfersIn: (map['netTransfersIn'] as num?)?.toInt() ?? 0,
        netTransfersOut: (map['netTransfersOut'] as num?)?.toInt() ?? 0,
        totalOwnership: (map['totalOwnership'] as num?)?.toDouble() ?? 0.0,
        available: map['available'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        club,
        country,
        position,
        price,
        injuryRisk,
        cardProneness,
        ownGoalIndex,
        netTransfersIn,
        netTransfersOut,
        totalOwnership,
        available,
      ];
}
