/**
 * Flop Fantasy Cloud Functions.
 *
 * Mirrors the Dart ScoringEngine on the server so authoritative gameweek
 * totals are written by Firestore triggers, not by the client.
 */
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";

admin.initializeApp();
const db = admin.firestore();

const DISASTER_MATRIX = {
  ownGoal: 10,
  redCard: 7,
  secondYellow: 5,
  yellowCard: 2,
  missedPenalty: 8,
  penaltySaved: 5,
  giveawayPenalty: 6,
  goalConceded: 1,
  cleanSheetFailureGk: 3,
  cleanSheetFailureDef: 2,
  subbedOffEarly: 3,
  didNotPlay: 5,
  injuryOff: 4,
  bigChanceMissed: 2,
  errorLeadingToGoal: 4,
  hitWoodwork: 1,
  matchLost: 3,
  heavyDefeat: 4,
} as const;

type Position = "goalkeeper" | "defender" | "midfielder" | "forward";

interface MatchStatsDoc {
  playerId: string;
  matchId: string;
  minutesPlayed?: number;
  ownGoals?: number;
  redCards?: number;
  yellowCards?: number;
  secondYellows?: number;
  missedPenalties?: number;
  penaltiesHadSaved?: number;
  penaltiesGivenAway?: number;
  goalsConceded?: number;
  subbedOffBefore60?: boolean;
  injuredOff?: boolean;
  bigChancesMissed?: number;
  errorsLeadingToGoal?: number;
  hitWoodwork?: number;
  teamLost?: boolean;
  teamLostHeavily?: boolean;
  didNotAppear?: boolean;
}

function scoreStats(stats: MatchStatsDoc, position: Position): number {
  if (stats.didNotAppear || !stats.minutesPlayed) return DISASTER_MATRIX.didNotPlay;
  let total = 0;
  total += (stats.yellowCards ?? 0) * DISASTER_MATRIX.yellowCard;
  total += (stats.secondYellows ?? 0) * DISASTER_MATRIX.secondYellow;
  total += (stats.redCards ?? 0) * DISASTER_MATRIX.redCard;
  total += (stats.ownGoals ?? 0) * DISASTER_MATRIX.ownGoal;
  total += (stats.missedPenalties ?? 0) * DISASTER_MATRIX.missedPenalty;
  total += (stats.penaltiesHadSaved ?? 0) * DISASTER_MATRIX.penaltySaved;
  total += (stats.penaltiesGivenAway ?? 0) * DISASTER_MATRIX.giveawayPenalty;
  if (position === "goalkeeper" || position === "defender") {
    total += (stats.goalsConceded ?? 0) * DISASTER_MATRIX.goalConceded;
    if ((stats.goalsConceded ?? 0) >= 2) {
      total +=
        position === "goalkeeper"
          ? DISASTER_MATRIX.cleanSheetFailureGk
          : DISASTER_MATRIX.cleanSheetFailureDef;
    }
  }
  total += (stats.bigChancesMissed ?? 0) * DISASTER_MATRIX.bigChanceMissed;
  total += (stats.errorsLeadingToGoal ?? 0) * DISASTER_MATRIX.errorLeadingToGoal;
  total += (stats.hitWoodwork ?? 0) * DISASTER_MATRIX.hitWoodwork;
  if (stats.subbedOffBefore60) total += DISASTER_MATRIX.subbedOffEarly;
  if (stats.injuredOff) total += DISASTER_MATRIX.injuryOff;
  if (stats.teamLost) total += DISASTER_MATRIX.matchLost;
  if (stats.teamLostHeavily) total += DISASTER_MATRIX.heavyDefeat;
  return total;
}

/**
 * Whenever a match stat is written, recompute that player's match score
 * and append a disaster feed event for live tracking.
 */
export const onMatchStatWrite = functions.firestore.onDocumentWritten(
  "matches/{matchId}/stats/{playerId}",
  async (event) => {
    const after = event.data?.after.data() as MatchStatsDoc | undefined;
    if (!after) return;

    const playerSnap = await db.collection("players").doc(after.playerId).get();
    const position = (playerSnap.get("position") ?? "midfielder") as Position;
    const points = scoreStats(after, position);

    await db
      .collection("matches")
      .doc(after.matchId)
      .collection("scores")
      .doc(after.playerId)
      .set({ points, position, computedAt: admin.firestore.FieldValue.serverTimestamp() });
  },
);

/**
 * HTTPS callable to roll up gameweek prices based on net transfers.
 * Caps the move at ±0.3 per round.
 */
export const rollupPrices = functions.https.onCall(async (request) => {
  if (!request.auth?.token.admin) {
    throw new functions.https.HttpsError("permission-denied", "admin only");
  }
  const playersSnap = await db.collection("players").get();
  const totalManagers = (await db.collection("managers").count().get()).data().count || 1;
  const batch = db.batch();
  playersSnap.docs.forEach((doc) => {
    const data = doc.data();
    const inn = data.netTransfersIn ?? 0;
    const out = data.netTransfersOut ?? 0;
    const swing = (inn - out) / totalManagers;
    const mag = Math.abs(swing);
    let step = 0;
    if (mag >= 0.30) step = 0.3;
    else if (mag >= 0.15) step = 0.2;
    else if (mag >= 0.05) step = 0.1;
    const signed = swing >= 0 ? step : -step;
    const newPriceRaw = (data.price ?? 5.0) + signed;
    const newPrice = Math.min(14.5, Math.max(3.5, Math.round(newPriceRaw * 10) / 10));
    batch.update(doc.ref, { price: newPrice, netTransfersIn: 0, netTransfersOut: 0 });
  });
  await batch.commit();
  return { updated: playersSnap.size };
});
