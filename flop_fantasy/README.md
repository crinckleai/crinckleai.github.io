# Flop Fantasy

A reverse-logic fantasy football app for the 2026 World Cup. Draft the worst, cash in on chaos.

## Stack

- **Frontend:** Flutter + Riverpod (state) + GoRouter (nav)
- **Backend:** Firebase — Firestore (data) + Cloud Functions (scoring engine in TypeScript mirrors Dart)
- **Theme:** Dark-mode, distressed/typewriter aesthetic

## Project layout

```
lib/
  models/         Player, MatchStats, ManagerSquad
  services/       Firestore + ScoringEngine (pure Dart, UI-free)
  logic/          SubManager, PriceManager (pure Dart, UI-free)
  ui/
    widgets/      PlayerChip, PitchView, DistressedPanel, AppShell, DisasterFeedTile
    screens/      HomeScreen (pitch), TransferMarketScreen, LiveTrackerScreen
  theme/          Distressed dark theme
  router/         GoRouter config
  state/          Riverpod providers
functions/        Cloud Functions (TypeScript) — server-side ScoringEngine + PriceManager
test/             Pure-Dart unit tests for ScoringEngine, SubManager, PriceManager
```

## Scoring matrix (excerpt)

| Disaster | Points |
|---|---|
| Own Goal | +10 |
| Missed Penalty | +8 |
| Red Card | +7 |
| Conceded Penalty | +6 |
| Penalty Saved Against | +5 |
| Second Yellow | +5 |
| Did Not Play | +5 |
| Heavy Defeat (3+) | +4 |
| Error → Goal | +4 |
| Injury Off | +4 |
| Subbed Off < 60’ | +3 |
| Match Lost | +3 |
| GK Clean Sheet Failure | +3 |
| DEF Clean Sheet Failure | +2 |
| Yellow Card | +2 |
| Big Chance Missed | +2 |
| Goal Conceded (GK/DEF only) | +1 |
| Hit Woodwork | +1 |

All values are centralised in `lib/services/scoring_engine.dart` (`DisasterMatrix`) and mirrored in `functions/src/index.ts`.

## Running tests

```bash
cd flop_fantasy
flutter pub get
flutter test
```

`test/` covers the `ScoringEngine`, `SubManager`, and `PriceManager` — all pure Dart, so the math is verified before UI assembly.

## Running the app

```bash
flutter pub get
flutter run
```

If Firebase is not yet configured, the app still boots with empty data (the `Firebase.initializeApp()` call is wrapped). Configure with `flutterfire configure` when ready.
