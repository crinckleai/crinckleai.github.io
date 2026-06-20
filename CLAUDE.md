# World-Class Professional Business Simulation Game
## Supply Chain & Operations Management — Game Design & Development Framework

---

## Table of Contents

1. [Game Vision & Design Philosophy](#game-vision--design-philosophy)
2. [Core Simulation Engine](#core-simulation-engine)
3. [Supply Chain Operations Model](#supply-chain-operations-model)
4. [Starting Inventory & Initialization](#starting-inventory--initialization)
5. [Game Mechanics & Decision Framework](#game-mechanics--decision-framework)
6. [Scenario Library](#scenario-library)
7. [Scoring & Performance System](#scoring--performance-system)
8. [AI & Automation Integration](#ai--automation-integration)
9. [Player Progression & Learning Path](#player-progression--learning-path)
10. [Technical Architecture](#technical-architecture)
11. [Facilitator & Debrief Guide](#facilitator--debrief-guide)

---

## Game Vision & Design Philosophy

### Purpose

Build a world-class, commercially deployable business simulation game that teaches real-world supply chain and operations management skills through immersive, consequence-driven gameplay. Players make decisions under uncertainty, manage tradeoffs, and experience the systemic effects of supply chain choices — from raw material sourcing through customer delivery.

### Design Principles

| Principle | Description |
|-----------|-------------|
| Fidelity | Simulation behavior mirrors real supply chain dynamics (bullwhip effect, lead time variability, yield loss) |
| Consequence | Every decision ripples through the system with measurable financial and operational impact |
| Progression | Difficulty scales from operational to strategic; novice to expert tracks |
| Engagement | Narrative context, competitive leaderboards, time pressure, unexpected disruptions |
| Learning | Failure is instructive; debrief tools reveal cause-and-effect chains |
| Replayability | Randomized events, multiple scenario archetypes, role rotation |

### Target Audience

- Supply chain & operations professionals (practitioners)
- MBA / graduate students (academic)
- Corporate L&D programs (enterprise training)
- Executive teams (strategic alignment simulations)

---

## Core Simulation Engine

### Time Model

```
GAME TIME STRUCTURE
─────────────────────────────────────────────────────────
 Week ──▶ Period ──▶ Quarter ──▶ Year

 1 Period  = 1 game week = simulated decisions
 1 Round   = 4 periods (1 simulated month)
 1 Game    = 12–52 rounds (configurable by scenario)

 Time compression: 1 real minute = 1 simulated week
─────────────────────────────────────────────────────────
```

### Simulation Loop (Per Period)

```
┌─────────────────────────────────────────────────────────┐
│  1. DEMAND REALIZATION                                  │
│     Customer orders arrive (stochastic + seasonal)      │
├─────────────────────────────────────────────────────────┤
│  2. FULFILLMENT                                         │
│     Ship from available inventory; record fill rate     │
├─────────────────────────────────────────────────────────┤
│  3. BACKORDER / LOST SALES                              │
│     Unfilled demand → backorder cost or lost revenue    │
├─────────────────────────────────────────────────────────┤
│  4. INVENTORY UPDATE                                    │
│     On-hand − shipments + receipts − spoilage/yield     │
├─────────────────────────────────────────────────────────┤
│  5. SUPPLY RECEIPT                                      │
│     Orders placed L periods ago arrive (lead time)      │
├─────────────────────────────────────────────────────────┤
│  6. PLAYER DECISIONS                                    │
│     Place orders, set prices, hire, negotiate, invest   │
├─────────────────────────────────────────────────────────┤
│  7. COST CALCULATION                                    │
│     Holding + ordering + backorder + labor + overhead   │
├─────────────────────────────────────────────────────────┤
│  8. EVENT INJECTION                                     │
│     Disruptions, market news, competitor moves          │
└─────────────────────────────────────────────────────────┘
```

### Stochastic Demand Model

```
Demand(t) = Base_Demand × Trend(t) × Seasonality(t) × ε(t)

Where:
  Base_Demand     = scenario-defined average weekly demand
  Trend(t)        = linear or S-curve growth factor
  Seasonality(t)  = periodic multiplier (configurable peaks)
  ε(t)            = random noise ~ Normal(1, σ²)
  σ               = demand variability coefficient (0.05–0.35)
```

---

## Supply Chain Operations Model

### Network Topology

```
TIER 3 SUPPLIERS          TIER 2               TIER 1           DISTRIBUTION        CUSTOMERS
(Raw Materials)       (Components)          (Manufacturer)       (DC / 3PL)

  Supplier A  ──────▶  Component X  ──────▶               ──────▶  DC North  ──────▶  Retail
  Supplier B  ──────▶  Component Y  ──────▶   Factory     ──────▶  DC South  ──────▶  Online
  Supplier C  ──────▶  Component Z  ──────▶               ──────▶  DC West   ──────▶  B2B
                                                │
                                         Finished Goods
                                           Warehouse
```

### Material Flow Parameters

| Parameter | Range | Notes |
|-----------|-------|-------|
| Supplier Lead Time | 2–12 weeks | Tier, geography, mode dependent |
| Lead Time Variability | ±10–50% | Standard deviation as % of mean |
| Manufacturing Cycle Time | 1–4 weeks | Batch size and capacity dependent |
| Yield Rate | 85–99% | Scrap, rework, first-pass yield |
| Shelf Life / Perishability | 4–52 weeks | Scenario dependent |
| Transit Time DC→Customer | 1–5 days | Mode and geography |

### Inventory Types & Locations

```
ON-HAND INVENTORY
│
├── Raw Materials (RM)
│   ├── RM_A: quantity, unit cost, lead time, supplier reliability
│   ├── RM_B: quantity, unit cost, lead time, supplier reliability
│   └── RM_C: quantity, unit cost, lead time, supplier reliability
│
├── Work In Process (WIP)
│   ├── Stage 1 WIP (post-assembly)
│   └── Stage 2 WIP (post-finishing)
│
├── Finished Goods (FG)
│   ├── Factory Warehouse
│   ├── DC North
│   ├── DC South
│   └── DC West
│
└── In-Transit Inventory
    ├── Supplier → Factory
    └── Factory → DC
```

### Capacity Model

```
PRODUCTION CAPACITY
─────────────────────────────────────────────────────
  Rated Capacity         = max units/week at 100% OEE
  Available Capacity     = Rated × Uptime% × Yield%
  Effective Capacity     = Available − Changeover Loss

  Utilization            = Actual Output / Rated Capacity
  OEE                    = Availability × Performance × Quality

  Overtime Threshold     = 85% utilization (configurable)
  Overtime Cost Premium  = 1.5× standard labor rate
─────────────────────────────────────────────────────
```

---

## Starting Inventory & Initialization

### Default Starting State (Standard Scenario)

```
PERIOD 0 — GAME INITIALIZATION
═══════════════════════════════════════════════════════════════════

RAW MATERIAL INVENTORY
──────────────────────
  RM_A (Primary Material):
    On-hand:          500 units
    Unit cost:        $12.50
    Total value:      $6,250
    Days of supply:   4 weeks at average demand

  RM_B (Secondary Material):
    On-hand:          300 units
    Unit cost:        $8.75
    Total value:      $2,625
    Days of supply:   3 weeks at average demand

  RM_C (Packaging):
    On-hand:          1,000 units
    Unit cost:        $1.20
    Total value:      $1,200
    Days of supply:   5 weeks at average demand

WORK IN PROCESS
───────────────
  Stage 1 WIP:        150 units (valued at $22.50/unit)
  Stage 2 WIP:        75 units  (valued at $31.00/unit)

FINISHED GOODS INVENTORY
─────────────────────────
  Factory Warehouse:  200 units @ $45.00/unit  = $9,000
  DC North:           150 units @ $47.50/unit  = $7,125
  DC South:           125 units @ $47.50/unit  = $5,937
  DC West:            100 units @ $47.50/unit  = $4,750

TOTAL STARTING INVENTORY VALUE:   $36,887
STARTING CASH POSITION:           $500,000
STARTING CREDIT FACILITY:         $1,000,000

OPEN PURCHASE ORDERS (IN-TRANSIT)
──────────────────────────────────
  PO-001: 300 units RM_A → arriving Period 2
  PO-002: 200 units RM_B → arriving Period 3
  PO-003: 500 units RM_C → arriving Period 1

CUSTOMER BACKORDERS AT START:     0 units
SERVICE LEVEL (trailing 4 weeks): 94.2% (benchmark: 95%)
═══════════════════════════════════════════════════════════════════
```

### Starting Inventory by Scenario Archetype

| Scenario | RM Coverage | FG Coverage | Cash | Difficulty |
|----------|-------------|-------------|------|------------|
| Comfortable Start | 6 weeks | 4 weeks | $750K | Beginner |
| Standard Launch | 4 weeks | 2 weeks | $500K | Intermediate |
| Lean Start | 2 weeks | 1 week | $250K | Advanced |
| Crisis Mode | 0.5 weeks | 0 weeks | $100K | Expert |
| Post-Disruption | Mixed / depleted | Partial | $150K | Expert |
| Acquisition Day 1 | Unknown (discovery needed) | Excess | $200K | Expert |

### Inventory Initialization Formulas

```
Target Starting Inventory (per SKU):

  RM Coverage   = (Average Weekly Usage × Target Weeks Coverage)
  FG Coverage   = (Average Weekly Demand × Target Cycle Stock Weeks)
                  + Safety Stock

  Safety Stock  = Z × √(Review Period + Lead Time) × σ_demand

  Where:
    Z      = service level factor (1.65 for 95%, 2.05 for 98%)
    σ      = demand standard deviation (units/week)
    Review = order review frequency (weeks)

Starting WIP:
  WIP_Stage_n = (Throughput Rate × Cycle Time_n) × Utilization
```

### Inventory Cost Structure

```
HOLDING COST MODEL
──────────────────────────────────────────────────────
  Holding Cost Rate        = 25% of inventory value/year
                           = ~0.48% per week

  Components:
    Capital cost           = 15% (cost of money tied up)
    Storage & handling     = 5%
    Obsolescence/risk      = 3%
    Insurance & taxes      = 2%

  Backorder / Stockout Cost:
    Backorder penalty      = $15 per unit per week (default)
    Lost sale penalty      = $25 per unit (permanent revenue loss)
    Customer churn trigger = 2 consecutive stockouts

  Ordering Cost:
    Fixed cost per PO      = $250 (supplier setup, admin)
    Variable cost/unit     = $0.50 (receiving, QC)
──────────────────────────────────────────────────────
```

---

## Game Mechanics & Decision Framework

### Player Decision Categories

#### 1. Inventory & Replenishment Decisions

```
REPLENISHMENT CONTROLS (each period)
─────────────────────────────────────
  □ Order Quantity (each RM / FG item)
  □ Order Timing (when to place)
  □ Supplier Selection (cost vs. lead time vs. reliability)
  □ Order Mode (standard / expedite / bulk)
  □ Safety Stock Target (units or weeks-of-coverage)
  □ Reorder Point (trigger level)
```

#### 2. Production Decisions

```
PRODUCTION CONTROLS
─────────────────────
  □ Production Schedule (units to start each week)
  □ Product Mix (which SKUs to prioritize)
  □ Batch Size (economies of scale vs. flexibility)
  □ Overtime Authorization (cost premium acceptance)
  □ Shift Pattern (1/2/3 shifts at varying cost)
  □ Quality Control Intensity (yield vs. throughput)
```

#### 3. Distribution & Fulfillment Decisions

```
DISTRIBUTION CONTROLS
──────────────────────
  □ Inventory Allocation (units to each DC)
  □ Replenishment Policy per DC (push vs. pull)
  □ Shipping Mode (speed vs. cost)
  □ Customer Prioritization (allocation during shortage)
  □ Backorder vs. Cancellation Policy
```

#### 4. Strategic Decisions (Advanced Levels)

```
STRATEGIC CONTROLS
───────────────────
  □ Supplier Contracts (price, minimum, lead time negotiation)
  □ Capacity Investment (expand / automate / outsource)
  □ Network Design (add/remove DC nodes)
  □ Hedging (pre-buy inventory against price/supply risk)
  □ Demand Shaping (pricing, promotions, pre-orders)
  □ Technology Investment (ERP, forecasting tools, automation)
```

### Inventory Policy Decision Matrix

```
POLICY SELECTION GUIDE
─────────────────────────────────────────────────────────────────
  Policy Type        │ When to Use          │ Key Parameter
  ───────────────────┼──────────────────────┼──────────────────
  Fixed Order Qty    │ Stable demand        │ EOQ formula
  (Q,r) System       │ Continuous review    │ Reorder point r
                     │                      │
  Fixed Review (S,s) │ Periodic ordering    │ Review period T
  Min-Max System     │ Simple operations    │ Min s, Max S
                     │                      │
  Just-in-Time       │ Lean, reliable supply│ Pull signals
                     │                      │
  MRP/MPS Driven     │ Known future demand  │ BOM explosion
                     │                      │
  Vendor Managed     │ Partnership model    │ Supplier sets stock
  (VMI)              │                      │
─────────────────────────────────────────────────────────────────
```

### The Bullwhip Effect Mechanic

```
DEMAND AMPLIFICATION VISUALIZATION
─────────────────────────────────────────────────────────────
  Customer Demand:     ████████████ (σ = 10 units/week)
  Retailer Orders:     ██████████████████ (σ = 18 units/week)
  Wholesaler Orders:   ████████████████████████ (σ = 28)
  Manufacturer Orders: ████████████████████████████████ (σ = 45)
  Supplier Orders:     ████████████████████████████████████████ (σ = 65)

  Causes players must diagnose:
  → Demand forecast errors
  → Order batching behavior
  → Price fluctuation responses
  → Shortage gaming
─────────────────────────────────────────────────────────────
```

---

## Scenario Library

### Scenario 1: The Classic Beer Game

**Type:** Multi-player, 4-tier supply chain
**Duration:** 36 rounds (36 simulated weeks)
**Players per team:** 4 (retailer, wholesaler, distributor, factory)
**Learning objective:** Bullwhip effect, information sharing value, system thinking

```
Initial State:
  Each tier: 12 units on-hand, 4 units in each pipeline position
  Demand: Constant 4 units/week → steps up to 8 units at Week 5
  Lead time: 2 weeks upstream shipping + 1 week order processing
```

---

### Scenario 2: Product Launch — New SKU Introduction

**Type:** Single-player or team
**Duration:** 26 rounds
**Learning objective:** NPI demand ramp, inventory build strategy, lifecycle

```
Initial State:
  On-hand FG:      0 units (product not yet launched)
  Pre-built stock: Optional — player decides launch inventory
  Cash:            $300,000
  Supplier LT:     6 weeks (qualification period included)
  Launch date:     Round 4 (fixed)

Key decisions:
  → How much to pre-build before launch?
  → What safety stock to hold during ramp uncertainty?
  → When to adjust production up/down as actual demand reveals?
```

---

### Scenario 3: Supply Disruption — Port Strike

**Type:** Team / Crisis simulation
**Duration:** 16 rounds (crisis + recovery)
**Learning objective:** Supply risk management, dual-sourcing, expediting

```
Initial State:
  FG on-hand:      200 units (2 weeks of demand)
  RM on-hand:      150 units (1.5 weeks of production)
  Open POs:        500 units in transit — BLOCKED at port
  Crisis trigger:  Period 1 announcement: port strike, unknown duration

Player must:
  → Triage production with available RM
  → Source alternative suppliers (higher cost)
  → Prioritize customer allocations
  → Communicate proactively with customers
  → Rebuild inventory post-strike
```

---

### Scenario 4: Seasonal Peak Planning

**Type:** Single or team
**Duration:** 52 rounds (full year)
**Learning objective:** Seasonal build strategy, capacity planning, markdown risk

```
Demand Pattern:
  Weeks 1-36:   Base demand 500 units/week
  Weeks 37-48:  Peak demand 1,800 units/week (+260%)
  Weeks 49-52:  Post-peak demand 200 units/week

Capacity Constraint:
  Max production: 700 units/week (cannot meet peak alone)
  Build season: Weeks 20-36 (must pre-build)
  Storage cost: $2.50/unit/week

Challenge: Balance pre-build cost vs. stockout risk vs. markdown risk
```

---

### Scenario 5: Supplier Rationalization

**Type:** Strategic
**Duration:** 24 rounds
**Learning objective:** Total cost of ownership, supplier risk, single vs. multi-source

```
Current State (3 suppliers):
  Supplier A: $10/unit, 2-week LT, 98% reliability, single source
  Supplier B: $11/unit, 3-week LT, 95% reliability, backup
  Supplier C: $13/unit, 1-week LT, 99% reliability, expedite only

Decision: Reduce to 1 supplier for 15% volume discount
Risk event: Probability 20% that chosen supplier has a major disruption
Player must quantify risk vs. reward
```

---

### Scenario 6: Global Network Design

**Type:** Strategic / Executive
**Duration:** 12 rounds (quarterly decisions)
**Learning objective:** Network optimization, total landed cost, service tradeoffs

```
Current Network: 3 DCs (US-East, US-West, Europe)
Available Options:
  → Add Mexico near-shoring hub ($500K investment, -$2/unit, +5% faster)
  → Add Asia DC ($800K, access to new market)
  → Close underperforming DC ($200K savings, +3 day service time)
  → Nearshore manufacturing ($2M capex, -40% lead time)

Decision horizon: 3-year NPV analysis with uncertainty
```

---

## Scoring & Performance System

### KPI Dashboard

```
╔══════════════════════════════════════════════════════════════════╗
║              OPERATIONS PERFORMANCE SCORECARD                    ║
╠══════════════════════════════════════════════════════════════════╣
║  CUSTOMER SERVICE                    INVENTORY EFFICIENCY        ║
║  ─────────────────                   ──────────────────────      ║
║  Fill Rate:        [ __ %]           Inventory Turns:  [___x]   ║
║  On-Time Delivery: [ __ %]           Days on Hand:     [___d]   ║
║  Perfect Order:    [ __ %]           Inventory $:      [$___K]  ║
║  Backorder Units:  [___]             Write-offs:       [$___]   ║
╠══════════════════════════════════════════════════════════════════╣
║  FINANCIAL PERFORMANCE               SUPPLY CHAIN COST           ║
║  ──────────────────────              ──────────────────          ║
║  Revenue:          [$___K]           Holding Cost:     [$___K]  ║
║  Gross Margin:     [ __ %]           Ordering Cost:    [$___K]  ║
║  Net Operating $:  [$___K]           Backorder Cost:   [$___K]  ║
║  Cash Position:    [$___K]           Total SC Cost:    [$___K]  ║
╠══════════════════════════════════════════════════════════════════╣
║  SUPPLY CHAIN RELIABILITY            TOTAL SCORE                 ║
║  ────────────────────────            ───────────────             ║
║  Supplier OTIF:    [ __ %]                                       ║
║  Forecast Accuracy:[ __ %]           ████████░░  82/100         ║
║  Lead Time Actual: [___w]            RANK: #3 of 12 teams       ║
╚══════════════════════════════════════════════════════════════════╝
```

### Scoring Formula

```
COMPOSITE SCORE CALCULATION
─────────────────────────────────────────────────────────────

  Customer Score (35%):
    Fill Rate component    = Fill Rate% × 20
    Perfect Order         = Perfect Order% × 10
    CSAT proxy            = (1 - Churn Rate) × 5

  Financial Score (35%):
    Cumulative Net Profit = (Profit / Target_Profit) × 20
    Cash Management       = Cash Flow Stability Score × 15

  Efficiency Score (20%):
    Inventory Turns       = min(Actual/Target, 1.5) × 10
    SC Cost / Revenue     = Benchmark comparison × 10

  Resilience Score (10%):
    Recovery Speed        = Weeks to recover from disruption × 5
    Risk Actions Taken    = Proactive mitigation score × 5

─────────────────────────────────────────────────────────────
  BONUS POINTS:
    +5  Achieve 98%+ fill rate for 4 consecutive periods
    +5  Identify and neutralize a risk event proactively
    +3  Implement an optimization that beats the model
    -10 Cash out (game ends, team eliminated)
    -5  Per period in crisis mode (cash < $50K)
─────────────────────────────────────────────────────────────
```

### Benchmark Targets by Level

| KPI | Beginner Target | Intermediate | Advanced | World Class |
|-----|----------------|--------------|----------|-------------|
| Fill Rate | 90% | 95% | 97% | 99%+ |
| Inventory Turns | 4x | 8x | 12x | 18x+ |
| Forecast Accuracy (WMAPE) | 85% | 90% | 94% | 97%+ |
| SC Cost / Revenue | 18% | 14% | 11% | 8% |
| Supplier OTIF | 88% | 93% | 96% | 99% |
| Cash Conversion Cycle | 60 days | 45 days | 35 days | 25 days |

---

## AI & Automation Integration

### AI Co-Pilot Features (In-Game)

```
AI ASSISTANT CAPABILITIES
──────────────────────────────────────────────────────────────────

  1. FORECAST ADVISOR
     "Based on your history and external signals, demand next
      period is projected at 485 ± 42 units (90% confidence)"

  2. REORDER ALERT
     "RM_A will reach reorder point in 3 periods at current
      consumption. Recommended order: 600 units from Supplier A"

  3. RISK SCANNER
     "Supplier B has 72% on-time performance this quarter.
      Consider dual-source buffer: +150 units safety stock"

  4. WHAT-IF ENGINE
     "If you add 1 shift (cost: $18K/week), throughput increases
      from 700 → 980 units. Break-even at 92% demand realization"

  5. ROOT CAUSE ANALYSIS
     "Fill rate dropped from 97% to 81% in Period 14.
      Root cause: RM_C stockout → production halt → 3-week delay
      Recommendation: Increase RM_C safety stock to 6 weeks"

  6. SCENARIO GENERATOR
     "Running 1,000 Monte Carlo simulations on your current
      inventory policy...
      → P50 outcome: $42K profit
      → P10 outcome: -$18K (shortage event)
      → P90 outcome: $67K
      Suggested adjustment: +80 units safety stock"
──────────────────────────────────────────────────────────────────
```

### Automated Decisions (Learner Toggle)

Players can unlock and configure autopilot rules as they advance:

| Automation | Description | Unlock Level |
|------------|-------------|--------------|
| Auto-Reorder | Trigger PO when stock < reorder point | Level 2 |
| EOQ Calculator | Auto-calculate order quantities | Level 2 |
| Safety Stock Optimizer | Dynamic SS based on service target | Level 3 |
| Forecast Integration | Auto-update orders from forecast | Level 3 |
| Exception Alerts | Push alert on critical KPI breach | Level 1 |
| Supplier Risk Monitor | Flag supplier reliability drops | Level 4 |
| Allocation Optimizer | AI-assigns scarce supply to customers | Level 5 |

---

## Player Progression & Learning Path

### Level Structure

```
PROGRESSION FRAMEWORK
══════════════════════════════════════════════════════════════════

  LEVEL 1: OPERATIONS ASSOCIATE
  ──────────────────────────────
  Focus: Basic replenishment, fill rate, cost awareness
  Scenarios: Beer Game (simplified), Steady demand single-SKU
  Key concepts: Order cycle, lead time, safety stock basics
  Unlock: Period-by-period play, EOQ formula, basic dashboard

  LEVEL 2: INVENTORY ANALYST
  ────────────────────────────
  Focus: Reorder point, safety stock sizing, demand variability
  Scenarios: Seasonal demand, multi-SKU, supplier variability
  Key concepts: Service level, fill rate vs. cycle service level
  Unlock: Automated reorder, ABC analysis tool, trend forecasting

  LEVEL 3: SUPPLY CHAIN PLANNER
  ───────────────────────────────
  Focus: Multi-echelon, network, S&OP basics, capacity
  Scenarios: Supply disruption, NPI launch, multi-DC
  Key concepts: Bullwhip, MRP, capacity planning, BOM
  Unlock: Network map, MRP engine, what-if simulator

  LEVEL 4: SUPPLY CHAIN MANAGER
  ───────────────────────────────
  Focus: Supplier management, risk, financial integration
  Scenarios: Supplier negotiation, M&A, global network design
  Key concepts: TCO, supplier risk, working capital, IBP
  Unlock: Supplier negotiation module, P&L view, risk register

  LEVEL 5: VP SUPPLY CHAIN / CSO
  ────────────────────────────────
  Focus: Strategy, investment decisions, enterprise trade-offs
  Scenarios: Strategic competition, full IBP simulation
  Key concepts: Network optimization, make/buy, ESG, resilience
  Unlock: Board-level decisions, M&A, full autonomous AI copilot

══════════════════════════════════════════════════════════════════
```

### Competency Assessment

After each scenario, players are scored across dimensions:

| Competency | Assessment Method |
|------------|-------------------|
| Inventory Management | Turns, stockout frequency, SS sizing accuracy |
| Demand Planning | Forecast bias, WMAPE, exception response time |
| Supplier Management | OTIF achieved, dual-source utilization, lead time variance |
| Financial Acumen | Cash management, cost/revenue ratio, ROI on investments |
| Risk Management | Events mitigated proactively vs. reactively |
| Systems Thinking | Bullwhip detection, upstream/downstream cause-effect |
| Decision Speed | Time per decision round (for timed modes) |

---

## Technical Architecture

### Game Engine Stack

```
TECHNOLOGY STACK
──────────────────────────────────────────────────────────────────

  FRONTEND
  ────────
  Framework:        React 18 / TypeScript
  State Management: Zustand (game state) + React Query (server sync)
  Visualization:    Recharts (KPI charts) + D3.js (network maps)
  UI Components:    Tailwind CSS + Radix UI
  Real-time:        WebSocket (multiplayer sync)

  SIMULATION ENGINE
  ─────────────────
  Core Logic:       TypeScript (deterministic simulation kernel)
  ML Forecasting:   Python microservice (scikit-learn / Prophet)
  Optimization:     OR-Tools (inventory optimization solver)
  Monte Carlo:      Custom engine (10K+ scenario runs, <2s)

  BACKEND
  ───────
  API:              Node.js / Fastify (REST + WebSocket)
  Database:         PostgreSQL (game state, history)
  Cache:            Redis (session state, leaderboards)
  Queue:            Bull (async event processing)

  AI LAYER
  ────────
  LLM:              Claude claude-sonnet-4-6 (advisor natural language)
  Embeddings:       Voyage AI (scenario search, case matching)
  Inference:        Anthropic API (tool-use for game event analysis)

  INFRASTRUCTURE
  ──────────────
  Hosting:          Vercel (frontend) + Railway (backend)
  CDN:              Cloudflare
  Auth:             Clerk
  Analytics:        PostHog (player behavior analytics)

──────────────────────────────────────────────────────────────────
```

### Data Model (Core Entities)

```typescript
interface GameSession {
  id: string;
  scenarioId: string;
  currentPeriod: number;
  totalPeriods: number;
  teams: Team[];
  globalState: MarketState;
  eventQueue: GameEvent[];
  createdAt: Date;
}

interface InventoryPosition {
  itemId: string;
  onHand: number;
  onOrder: number;            // open PO quantities
  inTransit: number;          // shipped, not received
  allocated: number;          // reserved for open orders
  available: number;          // on-hand - allocated
  reorderPoint: number;
  orderUpToLevel: number;
  safetyStock: number;
  unitCost: number;
  holdingCostRate: number;    // annual % of value
}

interface PurchaseOrder {
  id: string;
  supplierId: string;
  itemId: string;
  quantity: number;
  unitCost: number;
  placedPeriod: number;
  expectedArrivalPeriod: number;
  status: 'open' | 'in-transit' | 'received' | 'partial' | 'cancelled';
  expedited: boolean;
  expediteCost: number;
}

interface SupplyChainNode {
  id: string;
  type: 'supplier' | 'factory' | 'dc' | 'customer';
  inventory: InventoryPosition[];
  capacity: CapacityProfile;
  leadTimeDistribution: Distribution;
  reliabilityScore: number;  // 0–1
  coordinates: [lat: number, lng: number];
}

interface Period {
  periodNumber: number;
  demand: DemandRecord[];
  shipments: Shipment[];
  receipts: Receipt[];
  costs: CostBreakdown;
  kpis: KPISnapshot;
  events: GameEvent[];
  decisions: PlayerDecision[];
}
```

### Simulation Configuration Schema

```yaml
scenario:
  id: "supply-disruption-v2"
  name: "Port Strike Crisis"
  difficulty: "advanced"
  duration_periods: 16
  time_compression: "1min_per_period"

demand:
  base_weekly: 400
  seasonality_pattern: flat
  variability_cv: 0.15          # coefficient of variation
  trend: 0.0                    # weekly growth rate

starting_inventory:
  finished_goods:
    factory_warehouse: 200
    dc_north: 150
    dc_south: 125
    dc_west: 100
  raw_materials:
    RM_A: { quantity: 500, unit_cost: 12.50 }
    RM_B: { quantity: 300, unit_cost: 8.75 }
    RM_C: { quantity: 1000, unit_cost: 1.20 }
  open_pos:
    - { item: RM_A, qty: 300, arrival_period: 2, blocked: true }
    - { item: RM_B, qty: 200, arrival_period: 3, blocked: true }

starting_financials:
  cash: 500000
  credit_limit: 1000000
  accounts_receivable: 125000

events:
  - period: 1
    type: supply_disruption
    severity: high
    message: "Port workers' union has called a strike. All inbound
              ocean freight is suspended until further notice."
    affected_pos: ["PO-001", "PO-002"]
    duration_range: [3, 8]     # random resolution 3-8 periods

costs:
  holding_rate_annual: 0.25
  backorder_penalty_per_unit_week: 15
  lost_sale_penalty_per_unit: 25
  po_fixed_cost: 250
  po_variable_cost_per_unit: 0.50
  expedite_premium: 2.0        # multiplier on standard cost
  overtime_premium: 1.5        # multiplier on labor cost
```

---

## Facilitator & Debrief Guide

### Pre-Game Setup (15 minutes)

```
FACILITATOR CHECKLIST
──────────────────────────────────────────────────────────────────
  □ Teams assigned (3-5 players per team recommended)
  □ Role cards distributed (if multi-role scenario)
  □ Learning objectives stated and visible
  □ Starting inventory state reviewed with all teams
  □ Rules and decision interface walkthrough complete
  □ Timer/pacing explained
  □ "No communication" rules set (if applicable)
  □ Scoring display shared
──────────────────────────────────────────────────────────────────
```

### Mid-Game Interventions

| Trigger | Facilitator Action |
|---------|-------------------|
| Team has consecutive stockouts | Probe: "What information are you missing?" |
| Team over-orders massively | Ask: "What's driving this decision?" |
| Bullwhip pattern developing | Allow it to continue; capture data for debrief |
| Team runs out of cash | Apply credit facility; discuss cash management |
| Team asks for hints | Redirect to AI advisor tool first |

### Debrief Framework (30 minutes)

```
STRUCTURED DEBRIEF — 4-PART CYCLE

  PART 1: DATA REVIEW (10 min)
  Show the game replay:
  → Plot all teams' inventory levels over time
  → Plot orders placed vs. demand at each tier
  → Show fill rates, costs, and profit by team
  → Highlight the divergence point where strategies differed

  PART 2: EXPERIENCE SHARE (8 min)
  Ask each team:
  "What was your inventory policy? How did it change over time?"
  "What surprised you most?"
  "What would you do differently?"

  PART 3: CONCEPT BRIDGE (7 min)
  Facilitator maps game experiences to real-world frameworks:
  → Beer Game → Bullwhip Effect (Hau Lee 1997)
  → Inventory decisions → EOQ / Safety Stock theory
  → Supply disruption → Supply risk management strategies
  → Collaboration → S&OP / IBP process value

  PART 4: ACTION COMMITMENT (5 min)
  Each participant writes:
  "One thing I will change in my real job based on today's simulation"
  Share with partner; accountability pairs formed.
```

### Key Debrief Questions by Scenario

**Supply Disruption:**
- What was your inventory level when the strike was announced?
- How quickly did you find an alternative source? What did it cost?
- What would adequate preparation have looked like? What's the cost of that preparedness?

**Beer Game / Bullwhip:**
- At what point did your orders diverge from actual demand?
- What information would have changed your decisions?
- How does this compare to your real supply chain?

**Seasonal Peak:**
- When did you start your pre-build? Too early, too late, or right?
- How did you decide how much to pre-build?
- What happened to the excess inventory post-peak?

---

## Quick Reference Cards

### For Players

```
╔══════════════════════════════════════════════════════╗
║         SUPPLY CHAIN DECISION QUICK GUIDE            ║
╠══════════════════════════════════════════════════════╣
║                                                      ║
║  WHEN TO ORDER MORE:                                 ║
║  → Inventory < Reorder Point                         ║
║  → Demand forecast exceeds current supply plan       ║
║  → Risk event threatens inbound supply               ║
║                                                      ║
║  HOW MUCH TO ORDER (EOQ):                            ║
║  EOQ = √(2 × D × S / H)                             ║
║    D = annual demand units                           ║
║    S = fixed cost per order                          ║
║    H = holding cost per unit per year                ║
║                                                      ║
║  SAFETY STOCK:                                       ║
║  SS = Z × √(LT) × σ_demand                          ║
║    Z = 1.65 (95%) | 2.05 (98%) | 2.33 (99%)        ║
║    LT = lead time in weeks                           ║
║    σ = demand std deviation per week                 ║
║                                                      ║
║  REORDER POINT:                                      ║
║  ROP = (Avg Demand × Lead Time) + Safety Stock       ║
║                                                      ║
║  RED FLAGS — ACT NOW:                                ║
║  ⚠ Fill rate < 90% for 2 periods                    ║
║  ⚠ Cash < $100K                                     ║
║  ⚠ RM coverage < 2 weeks                            ║
║  ⚠ Supplier OTIF < 85%                              ║
╚══════════════════════════════════════════════════════╝
```

---

| Field | Value |
|-------|-------|
| Version | 1.0 — Game Design Framework |
| Created | 2026-06-20 |
| Author | CrinckleAI Game Design Team |
| Domain | Supply Chain & Operations Management |

*World-class business simulation: where real decisions have real consequences — in a safe environment.*
