import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/price_manager.dart';
import '../logic/sub_manager.dart';
import '../models/manager_squad.dart';
import '../models/match_stats.dart';
import '../models/player.dart';
import '../services/firestore_service.dart';
import '../services/scoring_engine.dart';

// === Service singletons ===
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final scoringEngineProvider = Provider<ScoringEngine>((_) => const ScoringEngine());
final subManagerProvider = Provider<SubManager>((_) => const SubManager());
final priceManagerProvider = Provider<PriceManager>((_) => const PriceManager());

// === Current manager session ===
final currentManagerIdProvider = StateProvider<String?>((_) => null);
final currentGameweekProvider = StateProvider<int>((_) => 1);

// === Player catalogue stream ===
final playersStreamProvider = StreamProvider<List<Player>>((ref) {
  return ref.watch(firestoreServiceProvider).watchPlayers();
});

// === Manager's squad for current GW ===
final squadStreamProvider = StreamProvider<ManagerSquad?>((ref) {
  final managerId = ref.watch(currentManagerIdProvider);
  final gw = ref.watch(currentGameweekProvider);
  if (managerId == null) return Stream<ManagerSquad?>.empty();
  return ref.watch(firestoreServiceProvider).watchSquad(managerId, gw);
});

// === Disaster feed (live) ===
final disasterFeedProvider = StreamProvider<List<DisasterFeedItem>>((ref) {
  final gw = ref.watch(currentGameweekProvider);
  return ref.watch(firestoreServiceProvider).watchDisasterFeed(gw);
});

// === Transfer market filters ===
class MarketFilter {
  const MarketFilter({this.position, this.maxPrice, this.search = ''});
  final PlayerPosition? position;
  final double? maxPrice;
  final String search;

  MarketFilter copyWith({PlayerPosition? position, double? maxPrice, String? search}) =>
      MarketFilter(
        position: position ?? this.position,
        maxPrice: maxPrice ?? this.maxPrice,
        search: search ?? this.search,
      );
}

final marketFilterProvider =
    StateProvider<MarketFilter>((_) => const MarketFilter());

final filteredMarketProvider = Provider<List<Player>>((ref) {
  final players = ref.watch(playersStreamProvider).maybeWhen(
        data: (p) => p,
        orElse: () => const <Player>[],
      );
  final f = ref.watch(marketFilterProvider);
  return players.where((p) {
    if (f.position != null && p.position != f.position) return false;
    if (f.maxPrice != null && p.price > f.maxPrice!) return false;
    if (f.search.isNotEmpty &&
        !p.name.toLowerCase().contains(f.search.toLowerCase()) &&
        !p.club.toLowerCase().contains(f.search.toLowerCase())) {
      return false;
    }
    return true;
  }).toList()
    ..sort((a, b) => b.price.compareTo(a.price));
});
