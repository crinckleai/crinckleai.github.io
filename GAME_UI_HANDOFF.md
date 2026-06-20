# Supply Chain Sim — Native Game UI & Design Handoff
## Complete Screen Inventory · Design System · Component Specs · Interaction Model

---

## Contents

1. [Design System](#1-design-system)
2. [Screen Inventory](#2-screen-inventory)
3. [Screen Specs — Menus & Onboarding](#3-screen-specs--menus--onboarding)
4. [Screen Specs — Main Game HUD](#4-screen-specs--main-game-hud)
5. [Screen Specs — Decision Panels](#5-screen-specs--decision-panels)
6. [Screen Specs — AI Co-Pilot](#6-screen-specs--ai-co-pilot)
7. [Screen Specs — Analytics & Debrief](#7-screen-specs--analytics--debrief)
8. [Screen Specs — Multiplayer & Social](#8-screen-specs--multiplayer--social)
9. [Component Library](#9-component-library)
10. [Animation & Motion Spec](#10-animation--motion-spec)
11. [Asset Inventory](#11-asset-inventory)
12. [Platform Targets & Breakpoints](#12-platform-targets--breakpoints)
13. [User Flows](#13-user-flows)

---

## 1. Design System

### 1.1 Color Palette

```
PRIMARY PALETTE
───────────────────────────────────────────────────────────────────

  Brand Blue (primary action, links, progress)
    --blue-900   #0A1628   (darkest, backgrounds)
    --blue-800   #0D2044
    --blue-700   #122E6B
    --blue-600   #1740A0   (primary buttons)
    --blue-500   #2256CC   (hover states)
    --blue-400   #4A80E4
    --blue-300   #7FAEF0
    --blue-100   #D6E4FB   (tints, chips)

  Supply Green (positive KPIs, healthy states, fill)
    --green-700  #0A4223
    --green-600  #0D6B35
    --green-500  #12A050   (success badges)
    --green-400  #22C96A
    --green-200  #A3F0C4   (backgrounds)

  Warning Amber (alerts, at-risk thresholds)
    --amber-700  #7A3E00
    --amber-600  #C26700
    --amber-500  #F59B00   (alert badges)
    --amber-300  #FDD280
    --amber-100  #FFF3CC   (warning backgrounds)

  Danger Red (stockout, crisis, critical alerts)
    --red-700    #5C0A0A
    --red-600    #991010
    --red-500    #D42020   (danger badges)
    --red-300    #F78080
    --red-100    #FCEAEA   (error backgrounds)

  Neutral (backgrounds, text, borders)
    --gray-950   #0C0F14   (game background)
    --gray-900   #111520
    --gray-800   #1A2030
    --gray-700   #242C3D
    --gray-600   #313C52
    --gray-500   #4A5568
    --gray-400   #718096
    --gray-300   #A0AEC0
    --gray-200   #CBD5E0
    --gray-100   #EDF2F7
    --gray-50    #F7FAFC

SEMANTIC TOKENS
───────────────────────────────────────────────────────────────────

  Background surfaces:
    surface-base       --gray-950    (main game canvas)
    surface-panel      --gray-900    (side panels, modals)
    surface-card       --gray-800    (cards, list items)
    surface-overlay    rgba(0,0,0,0.72)  (modal backdrops)

  Text:
    text-primary       --gray-50
    text-secondary     --gray-300
    text-muted         --gray-500
    text-inverse       --gray-950

  Borders:
    border-subtle      rgba(255,255,255,0.06)
    border-default     rgba(255,255,255,0.12)
    border-strong      rgba(255,255,255,0.24)

  Status colors (apply consistently):
    status-healthy     --green-500
    status-warning     --amber-500
    status-critical    --red-500
    status-neutral     --gray-400
    status-inactive    --gray-600

KPI HEAT MAP (for inventory levels and fill rate gauges)
───────────────────────────────────────────────────────────────────

  0–60%   →  --red-500   (critical)
  60–80%  →  --amber-500 (warning)
  80–95%  →  --green-500 (healthy)
  95%+    →  --blue-400  (excellent / world class)
```

### 1.2 Typography

```
TYPEFACES
─────────────────────────────────────────────────────────────────

  Primary (UI + body):   Inter (variable)
  Monospace (numbers):   JetBrains Mono (variable)
  Display (titles):      Inter Display (700–900 weight)

TYPE SCALE
─────────────────────────────────────────────────────────────────

  Token         Size    Weight   Line-H   Use
  ─────────     ──────  ──────   ──────   ────────────────────────
  display-2xl   48px    800      1.1      Scenario title splash
  display-xl    36px    700      1.15     Screen headings
  display-lg    28px    700      1.2      Section titles
  heading-md    20px    600      1.3      Panel headers
  heading-sm    16px    600      1.4      Card titles, labels
  body-lg       16px    400      1.5      Body text
  body-md       14px    400      1.5      Secondary text
  body-sm       12px    400      1.6      Captions, metadata
  label-lg      14px    500      1.0      Button labels
  label-sm      12px    500      1.0      Tag / chip labels
  mono-xl       28px    600      1.0      Large KPI numbers
  mono-lg       20px    600      1.0      KPI values
  mono-md       14px    500      1.0      Table numbers
  mono-sm       12px    400      1.0      Period counters

NUMBER DISPLAY RULE:
  All financial values, units, percentages → JetBrains Mono
  Positive delta → --green-400 with ▲ prefix
  Negative delta → --red-400 with ▼ prefix
```

### 1.3 Spacing & Grid

```
SPACING SCALE (8pt base grid)
──────────────────────────────────────────────────────────────────

  space-1   4px
  space-2   8px
  space-3   12px
  space-4   16px
  space-5   20px
  space-6   24px
  space-8   32px
  space-10  40px
  space-12  48px
  space-16  64px
  space-20  80px
  space-24  96px

LAYOUT GRID (Desktop 1440px)
──────────────────────────────────────────────────────────────────

  Columns:   12
  Gutter:    24px
  Margin:    32px
  Max-width: 1440px

  Game HUD zones:
  ┌─────────────────────────────────────────────────┐
  │  TOP BAR            (full width, h: 56px)       │
  ├──────────┬─────────────────────────┬────────────┤
  │  LEFT    │   MAIN CANVAS           │  RIGHT     │
  │  PANEL   │   (network map /        │  PANEL     │
  │  240px   │    game board)          │  320px     │
  │          │                         │            │
  │          │   Cols 3–10             │            │
  │  Cols    │                         │  Cols      │
  │  1–2     │                         │  11–12     │
  ├──────────┴─────────────────────────┴────────────┤
  │  BOTTOM BAR / DECISION TRAY   (full width h:120)│
  └─────────────────────────────────────────────────┘

BORDER RADIUS
──────────────────────────────────────────────────────────────────

  radius-sm   4px    (tags, chips, small badges)
  radius-md   8px    (cards, inputs)
  radius-lg   12px   (panels, modals)
  radius-xl   16px   (large cards, sheets)
  radius-full 9999px (pills, avatar bubbles)
```

### 1.4 Elevation & Shadows

```
SHADOW TOKENS (dark-mode game surface)
──────────────────────────────────────────────────────────────────

  shadow-sm   0 1px 3px rgba(0,0,0,0.4)              (card default)
  shadow-md   0 4px 12px rgba(0,0,0,0.5)             (floating panel)
  shadow-lg   0 8px 32px rgba(0,0,0,0.6)             (modal)
  shadow-xl   0 16px 64px rgba(0,0,0,0.7)            (overlay sheet)
  shadow-glow-green  0 0 16px rgba(18,160,80,0.4)    (healthy pulse)
  shadow-glow-red    0 0 16px rgba(212,32,32,0.5)    (alert pulse)
  shadow-glow-blue   0 0 20px rgba(34,86,204,0.45)   (selected node)
```

### 1.5 Iconography

```
ICON LIBRARY: Lucide Icons (line weight 1.5px, 24px default grid)

  Navigation:     LayoutDashboard, Map, BarChart3, Users, Settings
  Supply Chain:   Package, Truck, Factory, Warehouse, Globe
  Inventory:      Archive, BoxSelect, Layers, TrendingDown, TrendingUp
  Finance:        DollarSign, CreditCard, PiggyBank, Receipt
  Alerts:         AlertTriangle, AlertCircle, BellRing, ShieldAlert
  Actions:        Plus, Minus, RefreshCw, Play, Pause, SkipForward
  AI:             Bot, Sparkles, Brain, Zap
  Status:         CheckCircle2, XCircle, Clock, Loader2

ICON SIZES:
  icon-sm   16px  (inline, compact tables)
  icon-md   20px  (buttons, list items — default)
  icon-lg   24px  (nav items, section headers)
  icon-xl   32px  (empty states, feature callouts)
  icon-2xl  48px  (splash / onboarding illustrations)
```

---

## 2. Screen Inventory

```
COMPLETE SCREEN LIST
══════════════════════════════════════════════════════════════════

  AUTH & ONBOARDING
  ─────────────────
  S-01  Splash / Loading Screen
  S-02  Sign In / Sign Up
  S-03  Onboarding — Profile Setup (role, experience level)
  S-04  Onboarding — Tutorial intro (interactive)
  S-05  Onboarding — First scenario briefing

  MAIN MENU & LOBBY
  ─────────────────
  S-06  Home Dashboard (career stats, streak, next session)
  S-07  Scenario Library (browse + filter scenarios)
  S-08  Scenario Detail / Briefing
  S-09  Multiplayer Lobby (create / join team)
  S-10  Team Role Selection
  S-11  Pre-Game Checklist (starting inventory review)

  CORE GAME — HUD
  ───────────────
  S-12  Main Game HUD (primary gameplay screen)
  S-13  Supply Chain Network Map (full-screen mode)
  S-14  Period Transition Screen (end-of-period summary)
  S-15  Event Notification Overlay (disruption alerts)
  S-16  Pause Menu

  DECISION PANELS (slide-over sheets from HUD)
  ─────────────────────────────────────────────
  S-17  Inventory Management Panel
  S-18  Purchase Order Panel (place/edit orders)
  S-19  Production Schedule Panel
  S-20  Distribution & Allocation Panel
  S-21  Supplier Management Panel
  S-22  Financial Overview Panel
  S-23  Capacity Planning Panel
  S-24  Strategic Investment Panel (advanced levels)
  S-25  Demand Forecast Panel

  AI CO-PILOT
  ───────────
  S-26  AI Advisor Chat Interface
  S-27  What-If Simulator
  S-28  Monte Carlo Results View
  S-29  Root Cause Analysis Drill-Down
  S-30  Risk Scanner Dashboard

  ANALYTICS & DEBRIEF
  ────────────────────
  S-31  Period History / Replay Player
  S-32  KPI Deep-Dive Dashboard
  S-33  Bullwhip Effect Visualizer
  S-34  Cost Waterfall Breakdown
  S-35  End-of-Game Summary & Score
  S-36  Comparative Leaderboard
  S-37  Learning Summary / Competency Report
  S-38  Debrief Mode (facilitator view)

  PROFILE & PROGRESSION
  ──────────────────────
  S-39  Player Profile & Career Stats
  S-40  Skill Tree / Achievement Map
  S-41  Certification Badges
  S-42  Settings

══════════════════════════════════════════════════════════════════
  TOTAL: 42 screens
══════════════════════════════════════════════════════════════════
```

---

## 3. Screen Specs — Menus & Onboarding

### S-01 · Splash / Loading Screen

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                                                                 │
│              [ANIMATED LOGO — Supply Chain Sim]                 │
│                                                                 │
│          Node network animation: nodes light up in             │
│          sequence along supply chain path                       │
│          (Supplier → Factory → DC → Customer)                   │
│                                                                 │
│                    ████████░░░░  Loading...                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

SPECS:
  Background:   Animated particle field — dark blue (#0A1628)
                Supply chain node network slowly pulses
  Logo:         Wordmark + icon (truck + network node hybrid)
                Entrance: fade in + scale 0.8→1.0, 600ms ease-out
  Progress bar: 240px wide, --blue-600 fill, radius-full
  Duration:     1.8–3.2s depending on asset load
```

---

### S-07 · Scenario Library

```
┌─TOP BAR──────────────────────────────────────────────────────────┐
│  ← Home          SCENARIO LIBRARY           [Profile avatar]    │
└──────────────────────────────────────────────────────────────────┘

┌─FILTER BAR───────────────────────────────────────────────────────┐
│  [All] [Beginner] [Intermediate] [Advanced] [Expert]             │
│  [Single] [Multiplayer]   Search: [_________________]            │
└──────────────────────────────────────────────────────────────────┘

┌─SCENARIO GRID (3 cols, 4px gap)─────────────────────────────────┐
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐  │
│  │ 🍺 THE BEER GAME │  │ 🚀 NPI LAUNCH   │  │ ⚡ PORT STRIKE│  │
│  │ ─────────────── │  │ ──────────────  │  │ ──────────── │  │
│  │ Bullwhip Effect │  │ New Product     │  │ Crisis Mode  │  │
│  │ 4-tier sim      │  │ Demand Ramp     │  │ Supply Risk  │  │
│  │                 │  │                 │  │              │  │
│  │ ●●●○○ 3/5      │  │ ●●●●○ 4/5      │  │ ●●●●● 5/5  │  │
│  │ 👥 2–4 players  │  │ 👤 Solo         │  │ 👥 Team     │  │
│  │ ⏱ 45 min       │  │ ⏱ 30 min       │  │ ⏱ 60 min   │  │
│  │                 │  │                 │  │              │  │
│  │ [START ▶]      │  │ [START ▶]      │  │ [START ▶]  │  │
│  └──────────────────┘  └──────────────────┘  └───────────────┘  │
│                                                                  │
│  [+ More scenarios...]                                           │
└──────────────────────────────────────────────────────────────────┘

SCENARIO CARD ANATOMY:
  Width:        Fills 1/3 col (min 280px)
  Height:       Auto (min 220px)
  Background:   surface-card with scenario color tint overlay (8% opacity)
  Header area:  Scenario emoji/icon (48px) + title + tagline
  Difficulty:   Filled dot system (5 dots), colored by level
  Meta row:     Player count icon + time estimate icon
  CTA:          Primary button [START ▶] full width
  Hover state:  border-strong, shadow-lg, scale 1.02, 200ms
  Completed:    Checkmark badge top-right, muted border
```

---

### S-11 · Pre-Game Checklist (Starting Inventory Review)

```
┌─────────────────────────────────────────────────────────────────┐
│              PRE-GAME BRIEFING — Port Strike Crisis             │
│              ─────────────────────────────────────              │
│              Difficulty: ●●●●● Expert  |  16 Rounds            │
├──────────────────────────┬──────────────────────────────────────┤
│  STARTING INVENTORY      │  SCENARIO CONTEXT                   │
│  ────────────────────    │  ─────────────────                   │
│                          │                                      │
│  Raw Materials           │  You are the Supply Chain           │
│  RM_A  [████████░░] 500u │  Director. A port strike has        │
│  RM_B  [██████░░░░] 300u │  just been announced. Your          │
│  RM_C  [██████████]1000u │  inbound freight is blocked.        │
│                          │                                      │
│  Finished Goods          │  Incoming POs: BLOCKED              │
│  Factory   [████░░] 200u │  PO-001: 300× RM_A → Period 2     │
│  DC North  [███░░░] 150u │  PO-002: 200× RM_B → Period 3     │
│  DC South  [███░░░] 125u │                                      │
│  DC West   [██░░░░] 100u │  Customer demand continues:         │
│                          │  400 units/week                      │
│  Cash: $500,000 ✓        │                                      │
│  Credit: $1,000,000      │  You have ~2 weeks of FG supply.    │
│                          │  What is your plan?                  │
├──────────────────────────┴──────────────────────────────────────┤
│  LEARNING OBJECTIVES                                            │
│  □ Manage supply disruption with limited inventory             │
│  □ Source alternative suppliers under time pressure            │
│  □ Prioritize customer allocations during shortage             │
│  □ Communicate and rebuild post-crisis                         │
├─────────────────────────────────────────────────────────────────┤
│            [← BACK TO LIBRARY]    [▶ START GAME]               │
└─────────────────────────────────────────────────────────────────┘

SPECS:
  Layout:       2-col (inventory left, context right), stacked on mobile
  Inventory bars: Mini progress bars colored by DOH level (red/amber/green)
  POs:          List with status badges (BLOCKED = red, IN-TRANSIT = amber)
  Start CTA:    --blue-600, full width on mobile, right-aligned desktop
  Animation:    Cards slide in from bottom, staggered 80ms each
```

---

## 4. Screen Specs — Main Game HUD

### S-12 · Main Game HUD ← MOST CRITICAL SCREEN

```
LAYOUT (1440px desktop, landscape tablet)
═══════════════════════════════════════════════════════════════════

┌─TOP BAR (56px, surface-panel, border-bottom)────────────────────┐
│ [≡] SC Sim   Period 6/16 ▐██████░░░░░░░░░░▌   ⏱ 2:34  [⏸][?]  │
│              ───────────  Progress bar         Timer           │
└─────────────────────────────────────────────────────────────────┘
│                                                                  │
├─LEFT NAV PANEL (240px, surface-panel)────────────────────────────
│                                                                  │
│  KPI SNAPSHOT                                                    │
│  ─────────────                                                   │
│  Fill Rate    [████████░░] 82%  ▼ -3%                           │
│  Inv Turns    [█████░░░░░] 6.2x ▲ +0.4                          │
│  Cash         $342K             ▼ -$28K                         │
│  Score        74/100            ─                               │
│                                                                  │
│  ─────────────────────────────                                   │
│  INVENTORY LEVELS                                                │
│  RM_A  [████░░░░░░]  180u  ⚠                                    │
│  RM_B  [██████░░░░]  220u  ✓                                    │
│  RM_C  [████████░░]  400u  ✓                                    │
│  FG     [███░░░░░░░] 150u  ⚠                                    │
│                                                                  │
│  ─────────────────────────────                                   │
│  ACTIVE ALERTS (2)                                               │
│  🔴 RM_A at reorder point                                       │
│  🟡 Supplier B OTIF 78%                                         │
│                                                                  │
│  ─────────────────────────────                                   │
│  [📦 INVENTORY]  active                                         │
│  [🏭 PRODUCTION]                                                │
│  [🚛 DISTRIBUTION]                                              │
│  [💰 FINANCIALS]                                                │
│  [🤖 AI ADVISOR]                                                │
│                                                                  │
├─MAIN CANVAS (fills remaining width)──────────────────────────────
│                                                                  │
│  SUPPLY CHAIN NETWORK MAP                                        │
│                                                                  │
│   [Supplier A]──────▶[Factory]──────▶[DC North]──▶[Customers]  │
│        │ 98%            │ 85% util         │ 150u              │
│        │ 2wk LT         │                  │                   │
│   [Supplier B]──────▶  │          ──▶[DC South]──▶[Customers]  │
│        │ 78% ⚠         │                  │ 125u              │
│                         │                  │                   │
│   [Supplier C]──────▶  │          ──▶[DC West]───▶[Customers]  │
│        │ 99%            │                  │ 100u              │
│                                                                  │
│  Each node shows:                                               │
│  • Inventory level (color-coded ring)                           │
│  • Flow arrows (thickness = volume, color = status)             │
│  • Click → opens node detail panel                              │
│                                                                  │
│  [+] [-] zoom controls (bottom-right corner)                    │
│  [📍] Re-center button                                          │
│  [🗺] Toggle: Network | Timeline | Flow View                    │
│                                                                  │
├─RIGHT DECISIONS PANEL (320px, surface-panel)─────────────────────
│                                                                  │
│  PERIOD 6 DECISIONS                                              │
│  ────────────────────                                            │
│                                                                  │
│  PLACE ORDERS                                                    │
│  RM_A  [___500___] units  [ORDER]                               │
│         Supplier A ▾  $12.50/u                                  │
│         LT: 2 wks  ETA: Period 8                                │
│                                                                  │
│  RM_B  [___300___] units  [ORDER]                               │
│         Supplier B ▾  $11.00/u  ⚠ LT unreliable               │
│         LT: 3 wks  ETA: Period 9                                │
│                                                                  │
│  PRODUCTION                                                      │
│  Run:  [____700___] units this period                           │
│  Shift: [1 shift ▾]  OT: [OFF]                                  │
│  Capacity: 700/700 ██████████ 100%                              │
│                                                                  │
│  DISTRIBUTION                                                    │
│  FG to DC North:  [___50___]                                    │
│  FG to DC South:  [___50___]                                    │
│  FG to DC West:   [___50___]                                    │
│  Available: 150u  Allocated: 150u ✓                             │
│                                                                  │
│  ──────────────────────────────                                  │
│  [💡 AI SUGGEST]  [✓ CONFIRM ALL]                               │
│                                                                  │
├─BOTTOM TRAY (120px, surface-panel, border-top)───────────────────
│                                                                  │
│  ◀ Period 5     DEMAND THIS PERIOD: 400 units                   │
│                 Forecasted: 385 ± 45 (90% CI)                   │
│                                                                  │
│  Recent events: ────────────────────────────────────────────    │
│  P5: Filled 380/400 (95%) | P4: Filled 400/400 (100%)          │
│                                    [ADVANCE TO PERIOD 7 ▶▶]     │
└─────────────────────────────────────────────────────────────────┘

NODE VISUAL DESIGN
──────────────────
  Each supply chain node:
  Shape:      Rounded rectangle, 120×72px (desktop)
  Background: surface-card
  Ring:       4px border, color = inventory health status
              (red < 30%, amber 30–60%, green > 60%, blue = excellent)
  Label:      heading-sm (node name), body-sm (key stat)
  Sub-label:  OTIF% or utilization% or DOH days
  Pulse:      Nodes with alerts pulse-glow in alert color, 2s loop
  Connection: SVG path, stroke-width = volume indicator
              color = green (flowing) / amber (slow) / red (blocked)
  Trucks:     Animated SVG icon slides along path during period advance

TOP BAR COMPONENTS
──────────────────
  Logo/menu:   32px icon + wordmark, hamburger on mobile
  Period indicator: "Period 6 / 16" + subtitle (scenario name)
  Progress bar: Linear, full-width section, --blue-600 fill
  Timer:       Countdown or elapsed (mm:ss), monospace
  Controls:    Pause [⏸], Help [?], Settings [⚙]
```

---

### S-14 · Period Transition Screen

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│              ✅  PERIOD 6 COMPLETE                              │
│                                                                 │
├──────────────┬────────────────────────────────────────────────  │
│  THIS PERIOD │  CUMULATIVE                                      │
│  ─────────── │  ──────────                                      │
│              │                                                  │
│  Demand:     │  Fill Rate (avg):   [████████░░] 88.4%  ▼-0.3% │
│  400 units   │                                                  │
│              │  Cash:              $342,000         ▼-$28K     │
│  Filled:     │                                                  │
│  380 / 400   │  Score:             74 / 100         ─ nc       │
│  = 95.0% ✓  │                                                  │
│              │  Rank:              #2 of 4 teams    ▲ +1       │
│  Revenue:    │                                                  │
│  $38,000     │  Inventory value:   $36,887                     │
│              │                                                  │
│  Holding $:  │  Open POs:         2 orders pending             │
│  $1,040/wk   │                                                  │
│              │  ⚠ RM_A below reorder point — action needed     │
├──────────────┴────────────────────────────────────────────────  │
│                                                                 │
│  💡 AI INSIGHT:  "Your DC West fill rate dropped to 82%.       │
│     FG allocation was insufficient — DC West received 50u      │
│     but demand was 68u. Consider reallocating next period."    │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  [◀ REVIEW DECISIONS]  [📊 FULL ANALYTICS]  [▶ NEXT PERIOD]   │
└─────────────────────────────────────────────────────────────────┘

SPECS:
  Animation:    Screen slides up from bottom over game canvas, 400ms
  Numbers:      Count-up animation on key KPIs (500ms, ease-out)
  Delta badges: ▲ green / ▼ red / ─ gray, shown next to each KPI
  AI Insight:   Highlighted block, --blue-100 bg, sparkle icon
  Auto-advance: Optional 8s countdown to next period (can disable)
```

---

### S-15 · Event Notification Overlay

```
DISRUPTION EVENT (top-center, slide down)
──────────────────────────────────────────

  ┌──────────────────────────────────────────────────────┐
  │  ⚡ SUPPLY DISRUPTION — PERIOD 1                     │
  │  ────────────────────────────────                    │
  │                                                      │
  │  PORT STRIKE DECLARED                                │
  │                                                      │
  │  Port workers' union has called an indefinite        │
  │  strike. All inbound ocean freight is suspended.     │
  │                                                      │
  │  Affected:  PO-001 (300× RM_A) ─ BLOCKED            │
  │             PO-002 (200× RM_B) ─ BLOCKED            │
  │                                                      │
  │  Estimated duration: Unknown                         │
  │  Your RM stock: ~1.5 weeks of production             │
  │                                                      │
  │  [🤖 ASK AI FOR OPTIONS]        [✕ ACKNOWLEDGE]     │
  └──────────────────────────────────────────────────────┘

SEVERITY VARIANTS:
  Critical (red):  Supply disruption, stockout, cash crisis
  Warning (amber): Supplier delay, demand spike, capacity near limit
  Info (blue):     Market update, competitor move, opportunity
  Success (green): PO received, target achieved, milestone

TOAST VARIANTS (non-blocking, bottom-right corner):
  Height: 64px, width: 360px
  Icon + title + dismiss [✕]
  Auto-dismiss: 5s (info), 10s (warning), persistent (critical)
```

---

## 5. Screen Specs — Decision Panels

### S-17 · Inventory Management Panel

```
SLIDE-OVER SHEET (right side, 480px wide, full height)
═══════════════════════════════════════════════════════

┌─HEADER──────────────────────────────────────────────────┐
│  [✕]    📦 INVENTORY MANAGEMENT    Period 6             │
└─────────────────────────────────────────────────────────┘

┌─TABS──────────────────────────────────────────────────── │
│  [Raw Materials]  [Work In Process]  [Finished Goods]    │
└───────────────────────────────────────────────────────── │

┌─RAW MATERIALS TAB──────────────────────────────────────── │
│                                                           │
│  ITEM           ON-HAND   REORDER PT  STATUS  COVERAGE   │
│  ──────────────────────────────────────────────────────   │
│  RM_A           180u      200u        🔴 LOW  1.8 wks    │
│  [████░░░░░░]   $12.50/u              ORDER NOW          │
│                                                           │
│  RM_B           220u      180u        🟢 OK   2.5 wks    │
│  [████████░░]   $8.75/u                                   │
│                                                           │
│  RM_C           400u      300u        🟢 OK   4.0 wks    │
│  [██████████]   $1.20/u                                   │
│                                                           │
│  ─────────────────────────────────────────────────────   │
│  Total RM Value:    $8,075                                │
│  Total Holding/wk:  $45.20                                │
│                                                           │
│  QUICK ACTIONS                                            │
│  [🧮 CALCULATE EOQ]  [⚡ AUTO-REORDER ALL]              │
│                                                           │
│  SAFETY STOCK CALCULATOR                                  │
│  Target Service Level: [95% ▾]                           │
│  Lead Time (RM_A):     [2 weeks]                         │
│  Demand σ:             [42 units/wk]                     │
│                                                           │
│  → Recommended SS: 97 units                              │
│  → Reorder Point:  (2×125) + 97 = 347 units ⚠           │
│    Current ROP setting is 200 — consider updating        │
│                                                           │
│  [UPDATE REORDER POINT TO 347]                           │
│                                                           │
└───────────────────────────────────────────────────────── │

SPECS:
  Sheet:        max-h: 100vh, overflow-y: auto
  Backdrop:     surface-overlay, click-outside to close
  Table rows:   48px height, hover: surface-card-hover
  Progress bar: 8px height, inline, colored by status
  Calculator:   Collapsible section, expands on click
```

---

### S-18 · Purchase Order Panel

```
SLIDE-OVER SHEET (480px)
═══════════════════════════════════════════════════════════

┌─HEADER────────────────────────────────────────────────────┐
│  [✕]    🛒 PLACE PURCHASE ORDER    Period 6               │
└───────────────────────────────────────────────────────────┘

  ITEM TO ORDER
  ─────────────
  Item:       [RM_A — Primary Material  ▾]
  Current stock: 180u  |  Reorder point: 200u  ⚠ BELOW ROP

  SUPPLIER SELECTION
  ──────────────────
  ┌──────────────────────────────────────────────────────┐
  │ ● SUPPLIER A            ○ SUPPLIER B   ○ SUPPLIER C  │
  │   $12.50/unit             $13.50/unit    $18.00/unit  │
  │   Lead time: 2 wks        LT: 3 wks      LT: 1 wk   │
  │   OTIF: 98% ✓             OTIF: 78% ⚠    OTIF: 99%  │
  │   Min order: 100u         Min: 50u        Min: 200u  │
  │   RECOMMENDED             Backup          Expedite    │
  └──────────────────────────────────────────────────────┘

  ORDER QUANTITY
  ──────────────
  [ − ]  [_____500_____]  [ + ]   units
          ──────────────
          EOQ suggestion: 487u  [USE EOQ]

  ORDER MODE
  ──────────
  ● Standard   $12.50/u  ·  2-week lead time
  ○ Expedite   $25.00/u  ·  3-day lead time   (+100% premium)
  ○ Blanket PO Setup [→ view contract panel]

  ORDER SUMMARY
  ─────────────
  Quantity:      500 units
  Unit cost:     $12.50
  Freight:       $250 (fixed) + $0.50/u = $500
  ─────────────────────────────
  TOTAL:         $6,750
  ETA:           Period 8 (2 weeks)
  Post-receipt:  680 units on-hand (6.8 weeks coverage) ✓

  CASH IMPACT
  ───────────
  Current cash:   $342,000
  PO cost:        -$6,750
  Remaining:      $335,250  ✓ sufficient

  [CANCEL]                             [PLACE ORDER →]

OPEN PURCHASE ORDERS
  ────────────────────────────────────────────────────────
  PO-003  RM_C  500u  Supplier A  ETA Period 7  IN-TRANSIT
  PO-004  RM_B  300u  Supplier B  ETA Period 9  ⚠ DELAYED
```

---

### S-19 · Production Schedule Panel

```
SLIDE-OVER (480px)
═══════════════════

  PRODUCTION CAPACITY
  ───────────────────
  Rated:      700 units/week
  Current:    1-shift operation
  OEE:        87%  ·  Yield: 96%

  [════════════════════════████] 700u / 700u — AT CAPACITY

  THIS PERIOD SCHEDULE
  ────────────────────
  Units to produce:   [___700___]  ← at capacity

  Shift option:
  ○ 1 Shift    700u/wk    $45,000/wk labor
  ● 2 Shifts   1,260u/wk  $76,500/wk labor  (+70%)
  ○ 3 Shifts   1,680u/wk  $99,000/wk labor  (+120%)

  Overtime (current shift):
  [OFF ●────────────────] +30% units, +50% cost

  MATERIAL REQUIREMENT CHECK
  ──────────────────────────
  To produce 700u:
  RM_A needed:  700u   On-hand: 180u   ⚠ SHORTFALL: 520u
  RM_B needed:  350u   On-hand: 220u   ⚠ SHORTFALL: 130u
  RM_C needed:  700u   On-hand: 400u   ✓ sufficient

  ⚠ Cannot produce full 700u — RM constrained to ~180u
  Projected actual output: ~180 units

  PRODUCT MIX (multi-SKU scenarios)
  ──────────────────────────────────
  SKU-A:  [___400___] units    Margin: $28.50/u
  SKU-B:  [___300___] units    Margin: $22.00/u
  Changeover: 0 hrs (same line)

  [APPLY SCHEDULE]
```

---

### S-25 · Demand Forecast Panel

```
SLIDE-OVER (560px — wider for chart)
═════════════════════════════════════

  DEMAND FORECAST — Next 8 Periods
  ─────────────────────────────────

  ┌─────────────────────────────────────────────────────┐
  │  500 ┤                      ╭───────╮              │
  │  450 ┤                ╭─────╯       ╰────╮         │
  │  400 ┤──────────────╮─╯   ← actual        ╰────    │
  │  350 ┤              ╰╮  [confidence band]           │
  │  300 ┤               ╰╮                             │
  │      └────────────────────────────────────────────  │
  │       P1  P2  P3  P4  P5  P6  P7  P8  P9  P10      │
  │                         ↑ now                       │
  │  ── Actual  ── Forecast  ░░ 90% CI band             │
  └─────────────────────────────────────────────────────┘

  PERIOD    FORECAST    CI LOW   CI HIGH   BIAS ADJ
  ───────────────────────────────────────────────────
  P7         420u       378u     462u       +5u
  P8         435u       387u     483u       +5u
  P9         458u       401u     515u       0u
  P10        472u       408u     536u       0u

  Forecast method: Ensemble ML (XGBoost + Prophet)
  WMAPE trailing 4P: 8.2%   Bias: +1.3% (slight over)

  ADJUST FORECAST
  ───────────────
  Market intelligence override: [+/- ___] units for P7
  Reason: [________________________]

  DEMAND SENSING SIGNALS
  ──────────────────────
  🌐 Web search index:   +12% (leading indicator)
  📦 POS data:           aligned with forecast
  🎉 Upcoming promotion: +80u uplift added for P9

  [LOCK FORECAST]  [SHARE WITH TEAM]
```

---

## 6. Screen Specs — AI Co-Pilot

### S-26 · AI Advisor Chat Interface

```
FULL PANEL OVERLAY (640px wide, right side)
════════════════════════════════════════════

┌─HEADER────────────────────────────────────────────────────┐
│  [✕]    🤖 AI SUPPLY CHAIN ADVISOR                       │
│         Powered by Claude                                  │
└───────────────────────────────────────────────────────────┘

┌─SUGGESTED PROMPTS (shown before first message)────────────┐
│  Quick ask:                                               │
│  [Why did my fill rate drop?]  [What should I order?]    │
│  [Am I running out of cash?]  [Optimize my safety stock] │
└───────────────────────────────────────────────────────────┘

┌─CHAT MESSAGES─────────────────────────────────────────────┐
│                                                           │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ 🤖 AI  ·  Period 6                                  │ │
│  │                                                     │ │
│  │ Your fill rate dropped from 97% to 82% this period. │ │
│  │ Here's the root cause chain:                        │ │
│  │                                                     │ │
│  │ 1. RM_A fell below reorder point (180u vs 200u ROP) │ │
│  │ 2. Production constrained to 180 units (vs 700 cap) │ │
│  │ 3. DC West allocation insufficient (50u, needed 68) │ │
│  │                                                     │ │
│  │ Recommendation: Order 600u RM_A from Supplier A     │ │
│  │ immediately. ETA Period 8 — you need to bridge 2wks.│ │
│  │                                                     │ │
│  │ [📦 Place order for 600u RM_A →]                   │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                           │
│  You:  What if I expedite instead?                       │
│  ─────────────────────────────────                       │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ 🤖 Expediting 600u RM_A from Supplier A:            │ │
│  │                                                     │ │
│  │ Standard: $6,750 total · 2-week lead · ETA Period 8 │ │
│  │ Expedite:  $13,500 total · 3-day lead · ETA Period 7│ │
│  │                                                     │ │
│  │ You save 9 days. The extra $6,750 cost translates   │ │
│  │ to ~270 units of lost revenue at current margins    │ │
│  │ if those 9 days cause stockouts.                    │ │
│  │                                                     │ │
│  │ Your current FG: 150u, weekly demand: 400u          │ │
│  │ → Stockout risk without expedite: HIGH (P7)         │ │
│  │ → Verdict: Expedite is justified this time.         │ │
│  │                                                     │ │
│  │ [⚡ Place expedited order]  [📊 Run what-if]        │ │
│  └─────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────┘

┌─INPUT───────────────────────────────────────────────────── │
│  [Ask anything about your supply chain...    ] [Send ▶]   │
│  Context: Period 6 · Crisis scenario · 4 periods remain   │
└───────────────────────────────────────────────────────────┘

SPECS:
  Message bubbles:  AI = surface-card left-aligned, User = --blue-700 right
  Action buttons:   Inline CTAs inside AI messages (primary style)
  Streaming:        Text streams in token-by-token with cursor
  Context bar:      Shows current game state fed to AI
  Suggested prompts: Pill chips, horizontally scrollable
```

---

### S-27 · What-If Simulator

```
FULL PANEL (720px wide)
════════════════════════

  WHAT-IF SCENARIO BUILDER
  ─────────────────────────

  VARIABLE           CURRENT        WHAT-IF
  ───────────────────────────────────────────
  RM_A order qty:    0 units      [___600___]  units
  Production:        180u/wk      auto-calc ▾
  DC West alloc:     50 units     [____68___]  units
  Overtime:          OFF          [ON]

  [▶ RUN SIMULATION]

  ─────────────────── RESULTS ──────────────────────────────

  CURRENT PATH          WHAT-IF PATH
  ─────────────         ────────────
  P7 Fill:   62% ⚠     P7 Fill:   95% ✓    +33 pts
  P8 Fill:   71% ⚠     P8 Fill:   97% ✓    +26 pts
  Net Cost:  +$0        Net Cost:  +$7,250   (order + OT)
  Score:     74/100     Score:     82/100    +8 pts

  Cash end of sim:
  Current: $289,000    What-if: $281,750   -$7,250

  Revenue impact:
  Filled orders at 97% → +$12,400 additional revenue vs 62%
  NET BENEFIT: +$5,150 vs current path ✓

  [📊 COMPARE MORE SCENARIOS]   [✓ APPLY THIS PLAN]
```

---

## 7. Screen Specs — Analytics & Debrief

### S-31 · Game Replay Player

```
FULL SCREEN
════════════

  ◀ BACK    GAME REPLAY — Port Strike Crisis    PERIOD [6▾] ▶

  ┌─────────────────────────────────────────────────────────────┐
  │  PLAYBACK TIMELINE                                          │
  │  ◀◀  ◀  [████████░░░░░░░░░░] ▶  ▶▶  speed: [1x ▾]       │
  │  P1  P2  P3  P4  P5  P6  P7  P8  P9  P10  P11  P12       │
  │   ●                                                        │
  │   Strike                                                   │
  └─────────────────────────────────────────────────────────────┘

  ┌─LEFT: INVENTORY HISTORY──────┐  ┌─RIGHT: KPI CHART──────────┐
  │                              │  │                            │
  │  [RM_A ─] [RM_B ─] [FG ─]   │  │  [Fill Rate ─]            │
  │                              │  │  [Cash ──]                 │
  │  400┤ ───────╮               │  │  100%┤ ──────╮            │
  │  300┤        │               │  │   80%┤       ╰──╮         │
  │  200┤        ╰──╮            │  │   60%┤          ╰──       │
  │  100┤           ╰──          │  │   40%┤                    │
  │     └───────────────────     │  │      └─────────────────    │
  │     P1  P3  P5  P7  P9      │  │      P1  P3  P5  P7  P9   │
  │                              │  │                            │
  └──────────────────────────────┘  └────────────────────────────┘

  EVENT LOG (period-by-period narration)
  ───────────────────────────────────────
  P1: ⚡ Port strike announced. PO-001 & PO-002 blocked.
  P2: Production ran at 180u (RM constrained). FG depleted.
  P3: 🔴 Stockout — DC West 0 units. 42 orders lost.
  P4: Alternative supplier (C) onboarded. 200u RM_A at 2× cost.
  P5: ✓ Production back to 400u. Fill rate recovering.
  P6: Strike resolved. PO-001 released. ETA Period 8.
```

---

### S-33 · Bullwhip Effect Visualizer

```
FULL SCREEN (debrief mode)
════════════════════════════

  BULLWHIP EFFECT ANALYSIS — THE BEER GAME

  ┌───────────────────────────────────────────────────────────┐
  │                    ORDERS PLACED PER TIER                 │
  │                                                           │
  │  80 ┤                              ████                   │
  │  70 ┤                          ████████                   │
  │  60 ┤                      ████████████  ← Supplier       │
  │  50 ┤                   ═══════════════  ← Factory        │
  │  40 ┤               ───────────────────  ← Distributor    │
  │  30 ┤          ·····················    ← Retailer        │
  │  20 ┤   ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬    ← Customer Demand  │
  │  10 ┤                                                     │
  │     └─────────────────────────────────────────────────── │
  │     W1  W3  W5  W7  W9  W11  W13  W15  W17  W19  W21    │
  └───────────────────────────────────────────────────────────┘

  AMPLIFICATION STATS
  ───────────────────
  Customer Demand σ:     4.2 units/wk      (base)
  Retailer Order σ:      8.7 units/wk      2.1× amplification
  Distributor Order σ:   14.3 units/wk     3.4× amplification
  Factory Order σ:       22.8 units/wk     5.4× amplification
  Supplier Order σ:      38.1 units/wk     9.1× amplification

  ⚠ Your team's bullwhip ratio: 9.1× (World class target: < 2×)

  ROOT CAUSES DETECTED IN YOUR GAME
  ────────────────────────────────────
  ✗ Order batching (your team ordered every 3 weeks in large batches)
  ✗ Shortage gaming (over-ordered during P9 shortage — got 140% of need)
  ✗ Demand forecast error (average 18% overestimate in P6–P12)
  ✓ No price fluctuation gaming (well done)

  WHAT SHARING INFORMATION WOULD HAVE DONE
  ──────────────────────────────────────────
  [Run Counterfactual: Full demand visibility ▶]
  → Simulated bullwhip ratio with shared POS data: 2.3×
  → Simulated inventory reduction:  -34%
  → Simulated cost reduction:  -$48,000 (-22%)
```

---

### S-35 · End-of-Game Summary & Score

```
FULL SCREEN — CINEMATIC REVEAL
════════════════════════════════

  [Game complete animation: confetti or dramatic red pulse depending on outcome]

  ╔════════════════════════════════════════════════════════╗
  ║          SIMULATION COMPLETE — PORT STRIKE             ║
  ║          ─────────────────────────────────            ║
  ║                TEAM ALPHA  ·  Score: 74/100           ║
  ║                RANK: #2 of 4 teams                    ║
  ╠════════════════════════════════════════════════════════╣
  ║                                                        ║
  ║  CUSTOMER SERVICE       FINANCIAL          EFFICIENCY  ║
  ║  ────────────────        ─────────          ──────────  ║
  ║  Fill Rate: 88.4%        Revenue: $612K     Turns: 6.2x ║
  ║  B- (below 95%)          Net P&L: +$42K     C+ (vs 8x)  ║
  ║  35/35 × 0.84 = 29.4    35/35 × 0.72=25.2 20/20×0.58=11.6║
  ║                                                        ║
  ║  RESILIENCE: 7.5/10                                   ║
  ║  Recovered from crisis in 4 periods ✓                 ║
  ║  Did not proactively dual-source ✗                    ║
  ║                                                        ║
  ║  ───────────────────── TOTAL ────────────────────────  ║
  ║                         74 / 100                      ║
  ╠════════════════════════════════════════════════════════╣
  ║  COMPETENCY BADGES EARNED                             ║
  ║  [🚨 Crisis Navigator]  [💰 Cash Manager]            ║
  ║  Locked: [🔒 Lean Master]  [🔒 Bullwhip Slayer]      ║
  ╠════════════════════════════════════════════════════════╣
  ║  [📊 FULL DEBRIEF]  [🔄 REPLAY]  [🏠 HOME]           ║
  ╚════════════════════════════════════════════════════════╝
```

---

## 8. Screen Specs — Multiplayer & Social

### S-09 · Multiplayer Lobby

```
┌──────────────────────────────────────────────────────────────┐
│  🌐 MULTIPLAYER LOBBY                                        │
│                                                              │
│  Room: ALPHA-7842                    [Copy Link] [Share QR]  │
│  Scenario: Beer Game (Classic)       4 players · 36 rounds   │
├──────────────────────────────────────────────────────────────┤
│  PLAYERS (3/4 joined)                                        │
│  ─────────────────────                                       │
│  [👤] Jordan K.   ⭐ Level 3   Role: Retailer    ✓ READY   │
│  [👤] Sam P.      ⭐ Level 2   Role: Wholesaler  ✓ READY   │
│  [👤] You         ⭐ Level 4   Role: [Distributor▾] ✓      │
│  [👤] ──────────  Waiting for Player 4...         ⏳         │
│                                                              │
│  CHAT                                                        │
│  Jordan: "No sharing demand info right? that's the rule?"   │
│  Sam: "correct, we play blind!"                             │
│  You: [_____________________________________________] [Send] │
│                                                              │
│  GAME SETTINGS (host only)                                   │
│  ○ No info sharing (classic)  ● Limited (weekly demand only) │
│  ○ Full transparency (learning mode)                         │
│                                                              │
│  [INVITE LINK: scgame.io/room/ALPHA-7842]                   │
│                        [LEAVE]    [▶ START GAME (host only)] │
└──────────────────────────────────────────────────────────────┘
```

---

### S-36 · Leaderboard

```
  🏆 LEADERBOARD — Port Strike Crisis — Session #12

  RANK  TEAM           SCORE   FILL RT  NET P&L  TURNS  BADGE
  ────────────────────────────────────────────────────────────
  🥇 1  Team Bravo      91/100   97.2%   +$89K    9.4x   ⚡
  🥈 2  Team Alpha      74/100   88.4%   +$42K    6.2x
  🥉 3  Team Delta      68/100   84.1%   +$18K    5.1x
     4  Team Gamma      52/100   71.3%   -$12K    3.8x   💀

  YOUR TEAM (Team Alpha): #2

  ─────────────────────────────────────────────────────
  ALL-TIME RECORDS — Port Strike Crisis
  Highest score:   94/100  ·  Team Bravo  ·  6 months ago
  Avg score:       71.2/100 (across 847 plays)
  Your best:       79/100  ·  Solo run  ·  3 weeks ago

  [VIEW TEAM BRAVO'S STRATEGY]    [CHALLENGE A FRIEND]
```

---

## 9. Component Library

### Core Components (alphabetical)

```
ALERT BANNER
  Props: severity (critical|warning|info|success), message, action?, onDismiss?
  Variants: full-width (top of screen), inline (within panel), toast (overlay)

BADGE / CHIP
  Props: label, variant (status|level|category), icon?, size (sm|md)
  Status colors: healthy=green, warning=amber, critical=red, neutral=gray

BUTTON
  Variants: primary (--blue-600 fill), secondary (outline), ghost (text only),
            danger (--red-600 fill)
  Sizes: sm (32px), md (40px), lg (48px)
  States: default, hover (+10% brightness), active (scale 0.98), loading (spinner),
          disabled (opacity 40%)
  Icon button: square aspect ratio, icon only + tooltip

DECISION INPUT
  A specialized numeric input for game decisions
  Props: value, min, max, step, unit, recommendation?, onChange
  Shows: current value, delta vs last period, color coded vs target
  Includes: decrement [−] button, input field, increment [+] button
  Smart: highlights in amber if value is outside recommended range

GAUGE / DONUT
  Props: value (0–100), target, thresholds (critical/warning/healthy)
  Sizes: sm (64px), md (96px), lg (128px)
  Shows: value in center, color band outer ring, target tick mark
  Animation: fill animates on mount, 800ms ease-out

INVENTORY BAR
  A horizontal progress bar for inventory visualization
  Props: onHand, safetyStock, reorderPoint, maxCapacity, unit
  Shows: stacked bar (on-hand in green, SS floor in amber, empty in red)
  Labels: on-hand qty, days-of-supply annotation

KPI CARD
  Props: label, value, unit, delta, deltaDirection, target, trend[]
  Layout: label top, large value center, delta + sparkline bottom
  Background: surface-card, colored left border by status

LINE CHART
  Built on Recharts
  Props: data[], series[], xKey, height, showGrid?, showTooltip?
  Series: each has color, label, dashed? (for forecast lines), fill? (for CI bands)
  Annotations: vertical reference lines for events, period markers

MODAL
  Sizes: sm (400px), md (560px), lg (720px), fullscreen
  Structure: header (title + close), scrollable body, sticky footer (actions)
  Backdrop: surface-overlay, click-outside closes (configurable)

NETWORK NODE
  Props: id, type, label, inventory, status, selected?, pulse?
  Shape: rounded-rect, 120×72px (desktop), 80×48px (mobile)
  Ring: 4px border, color = inventory health
  Hover: shadow-glow-blue, cursor pointer
  Selected: thick blue ring, shadow-xl
  Alert pulse: keyframe animation, 2s infinite

PERIOD INDICATOR
  Shows current period + progress in game
  Props: current, total, label?
  Visual: progress bar + "Period N / M" label + scenario name

PROGRESS BAR
  Props: value, max, color?, size (sm|md|lg), label?, showValue?
  Sizes: h-1 (4px), h-2 (8px), h-3 (12px)

SCORE RING
  Circular score display for end-game / leaderboard
  Props: score (0–100), label, rank?
  Shows: donut ring (colored by score range), score number center, grade letter

SLIDE-OVER SHEET
  Right-aligned panel that slides in over the main canvas
  Props: isOpen, onClose, title, width (360|480|560|720), children
  Animation: translateX 100%→0 on open, 300ms cubic-bezier ease

STATUS DOT
  Inline status indicator
  Props: status (healthy|warning|critical|neutral|inactive)
  Size: 8px circle, appropriate semantic color

SUPPLIER CARD
  Compact comparison card for supplier selection
  Props: name, unitCost, leadTime, otif, minOrder, reliability, selected
  Layout: header (name + reliability badge), stats grid, selected ring

TABLE
  Props: columns[], data[], sortable?, selectable?, onRowClick?
  Row height: 48px (default), 40px (compact)
  Hover: surface-card-hover background
  Number cells: right-aligned, monospace font

TIMELINE (game events)
  Horizontal scrollable event log
  Props: events[] (period, type, message)
  Each event: period badge + icon + truncated message + severity color
```

---

## 10. Animation & Motion Spec

```
TIMING FUNCTIONS
────────────────────────────────────────────────────────────────
  ease-default    cubic-bezier(0.4, 0, 0.2, 1)   (material standard)
  ease-in-out     cubic-bezier(0.4, 0, 0.6, 1)   (gentle)
  ease-spring     cubic-bezier(0.34, 1.56, 0.64, 1) (bouncy, use sparingly)
  ease-sharp      cubic-bezier(0.4, 0, 1, 1)     (quick exit)

DURATIONS
────────────────────────────────────────────────────────────────
  duration-fast   150ms   (hover, focus, small state changes)
  duration-base   250ms   (most UI transitions)
  duration-slow   400ms   (panels, sheets, modals)
  duration-story  600ms   (period transitions, score reveals)
  duration-cinematic 1000–2000ms (game intro, end screen)

KEY ANIMATIONS
────────────────────────────────────────────────────────────────

  Period Advance (S-14):
  1. Canvas fades to 50% opacity (200ms)
  2. Period complete banner slides down from top (400ms, ease-spring)
  3. KPI numbers count up to new values (600ms, ease-out)
  4. Truck icons animate along network paths (800ms)
  5. Banner auto-dismisses after 3s or on user action

  Event Notification:
  1. Alert banner drops from top (300ms, ease-spring)
  2. Affected node pulses red (infinite, 1.5s period)
  3. Dismiss: slides back up (200ms, ease-sharp)

  Inventory Level Change:
  Progress bars fill/drain animated (400ms, ease-default)
  Color transitions animate (200ms)

  Score Reveal (end of game):
  1. Score ring draws clockwise (1200ms, ease-out)
  2. Number counts up (1000ms, ease-out)
  3. Badge icons pop in with scale spring (staggered 100ms each)
  4. Rank reveal: number flies in from off-screen (600ms)

  AI Response Streaming:
  Text appears character by character
  Typing cursor blinks at 530ms interval
  Action buttons fade in after text complete (300ms)

  Network Node Pulse (alert state):
  @keyframes pulse-alert {
    0%, 100% { box-shadow: 0 0 0 0 rgba(212,32,32,0.7); }
    50% { box-shadow: 0 0 0 8px rgba(212,32,32,0); }
  }
  duration: 1.5s, iteration: infinite

  Panel Slide-Over:
  Open:  translateX(100%) → translateX(0), 300ms ease-default
  Close: translateX(0) → translateX(100%), 250ms ease-sharp
  Backdrop: opacity 0→0.72, 250ms

REDUCED MOTION:
  All animations respect prefers-reduced-motion media query
  → Substitute opacity fade for translate animations
  → Remove infinite pulse (show static indicator instead)
  → Count-up becomes instant display
```

---

## 11. Asset Inventory

### Illustrations Required

```
SCENE ILLUSTRATIONS (for scenario splash screens)
──────────────────────────────────────────────────
  il-beer-game        Warehouse with 4 tiers, cartoon style
  il-port-strike      Container port with strike banners
  il-npi-launch       Product rocket launching
  il-seasonal-peak    Holiday rush at a warehouse
  il-network-design   World map with network nodes
  il-supplier-risk    Factory with risk warning signs

ACHIEVEMENT BADGE ICONS (32 each)
──────────────────────────────────
  32 badge illustrations for competencies and achievements
  Style: Flat icon on hexagonal background, colored by tier
  Tiers: Bronze (brown), Silver (gray), Gold (yellow), Platinum (blue)
  Examples:
    Bullwhip Slayer, Lean Master, Crisis Navigator, Cash Manager,
    Forecast Guru, Safety Stock Pro, Network Optimizer, Perfect Fill...

CHARACTER AVATARS (for multiplayer)
────────────────────────────────────
  12 stylized supply chain professional avatars
  Roles: Planner, Analyst, Director, VP, Supplier, Customer
  Style: Flat design, diverse representation

EMPTY STATE ILLUSTRATIONS
───────────────────────────
  empty-orders    No open purchase orders
  empty-alerts    No active alerts (positive)
  empty-history   No game history yet
  no-results      Search returned nothing
```

### Icons (Custom to Game)

```
GAME-SPECIFIC CUSTOM ICONS (needed beyond Lucide set)
──────────────────────────────────────────────────────
  icon-sku          Product box with barcode
  icon-bom          Bill of materials tree
  icon-safety-stock  Buffer/shield over inventory stack
  icon-reorder-point Arrow pointing to trigger level
  icon-lead-time    Clock with supply chain path
  icon-bullwhip     Whip with demand waves
  icon-otif         Checkmark + clock + truck combo
  icon-wmape        Chart with accuracy bands
  icon-dc           Distribution center building
  icon-3pl          Truck with third-party logo
  icon-eoq          Formula symbol with graph
  icon-service-level Gauge dial
  icon-cashflow     Dollar with flow arrows
  icon-disruption   Lightning bolt on supply chain link
```

### Audio Assets

```
SOUND EFFECTS (optional, toggleable)
──────────────────────────────────────
  sfx-period-advance      Subtle swoosh + click
  sfx-order-placed        Cash register ding
  sfx-alert-critical      Low alarm tone (not jarring)
  sfx-alert-warning       Soft chime
  sfx-achievement         Ascending tone + sparkle
  sfx-stockout            Error buzz (short)
  sfx-score-reveal        Ascending chord progression
  sfx-ai-response         Soft keyboard typing

BACKGROUND MUSIC (ambient, very low volume)
────────────────────────────────────────────
  bgm-game-standard       Lo-fi electronic, focused
  bgm-game-crisis         Slightly tense, subtle urgency
  bgm-debrief             Calm, reflective
```

---

## 12. Platform Targets & Breakpoints

### Responsive Breakpoints

```
  xs:   < 480px    (phone portrait — limited functionality)
  sm:   480–767px  (phone landscape / small tablet)
  md:   768–1023px (tablet portrait — condensed HUD)
  lg:   1024–1279px (tablet landscape / small laptop)
  xl:   1280–1439px (laptop — full HUD)
  2xl:  ≥ 1440px   (desktop — optimal, full layout)
```

### Platform Priority

```
PRIORITY 1 — Desktop Web (1440px+)
  Full HUD with 3-panel layout
  Network map center canvas
  All panels and charts at full fidelity
  Keyboard shortcuts (see below)

PRIORITY 2 — Tablet (iPad Pro, 1024×1366)
  Condensed 2-panel layout (left panel collapses to icons)
  Touch-optimized tap targets (min 44×44px)
  Decision panels as full-screen sheets

PRIORITY 3 — Desktop Native (Electron / Tauri)
  Same as web with native window chrome
  Local save state
  Offline play support

FUTURE — Mobile (Phone)
  Simplified single-panel view
  One decision at a time
  Observer/spectator mode for multiplayer

KEYBOARD SHORTCUTS (desktop)
──────────────────────────────
  Space         Pause / Resume
  Enter         Confirm all decisions & advance period
  I             Open Inventory panel
  P             Open Production panel
  D             Open Distribution panel
  F             Open Financials panel
  A             Open AI Advisor
  Tab           Cycle through decision panels
  Escape        Close active panel
  Cmd+Z         Undo last decision (within period)
  1–9           Focus on network node by number
  Cmd+Enter     Quick advance to next period
```

---

## 13. User Flows

### Flow 1: First-Time Player

```
App open
  → S-01 Splash
  → S-02 Sign Up (email / Google)
  → S-03 Profile (role: Student, experience: Beginner)
  → S-04 Tutorial intro (interactive, 3-step)
  → S-05 First scenario briefing (Beer Game beginner mode)
  → S-11 Pre-game checklist (auto-passed for tutorial)
  → S-12 Main HUD (Tutorial overlay with tooltips)
  → S-14 Period transitions × 36
  → S-35 End-of-game summary
  → S-37 Competency report
  → S-06 Home dashboard (with streak started + badge earned)
```

### Flow 2: Placing an Order

```
S-12 HUD (alert: RM_A below ROP)
  → Click alert OR [📦 INVENTORY] nav
  → S-17 Inventory panel (slides in)
  → Click RM_A row → S-18 Purchase Order panel
  → Select supplier, enter quantity
  → Review summary (cost, ETA, cash impact)
  → [PLACE ORDER] → confirmation toast
  → Panel closes → HUD updates RM_A status
```

### Flow 3: AI-Assisted Decision

```
S-12 HUD (fill rate warning)
  → Click [🤖 AI ADVISOR] or press A
  → S-26 AI chat opens
  → AI proactively shows root cause (streamed)
  → AI suggests order + expedite option
  → Player clicks [⚡ Place expedited order] inside chat
  → Inline order form appears in chat
  → Player confirms → order placed
  → Chat continues with follow-up advice
```

### Flow 4: Multiplayer Game

```
Player A (host):
  → S-07 Scenario Library → S-08 Beer Game detail
  → [MULTIPLAYER] → S-09 Lobby created (room code: ALPHA-7842)
  → S-10 Role selection (Retailer)
  → Share code with team

Players B/C/D:
  → S-06 Home → [JOIN GAME] → enter ALPHA-7842
  → S-09 Lobby (join as Wholesaler/Distributor/Factory)
  → S-10 Role selection

All players in lobby:
  → Host starts → S-11 Pre-game (all players see simultaneously)
  → S-12 HUD (each player sees their own tier view)
  → Period decisions are synchronized
  → S-14 Period transitions with team comparison
  → S-35 End screen with all 4 players' scores
  → S-36 Leaderboard comparison
```

### Flow 5: Debrief (Facilitator)

```
Facilitator:
  → S-38 Debrief mode (facilitator login)
  → Select completed session
  → S-31 Replay player (controls all teams' data)
  → Project on shared screen
  → S-33 Bullwhip visualizer (all teams compared)
  → S-34 Cost waterfall (team vs team)
  → S-37 Learning summary per participant
  → Export PDF report for each team
```

---

## Handoff Checklist

```
FOR DESIGNERS
──────────────
  □ Apply design system tokens (colors, type, spacing) from Section 1
  □ Create component library in Figma from Section 9
  □ Design all 42 screens from Section 2 spec
  □ Prioritize: S-12 (HUD), S-14 (Period transition), S-26 (AI chat),
                S-35 (End screen), S-07 (Scenario library)
  □ Define all animation specs (Section 10) in Figma prototypes
  □ Source/create all assets from Section 11
  □ Create design tokens file for dev handoff

FOR DEVELOPERS
───────────────
  □ Implement design tokens as CSS custom properties / Tailwind config
  □ Build component library (Section 9) in Storybook
  □ Implement simulation engine (see CLAUDE.md Technical Architecture)
  □ Wire up WebSocket for multiplayer synchronization
  □ Integrate Claude API for AI Advisor (Section 6)
  □ Implement all 5 user flows (Section 13)
  □ Keyboard shortcut system (Section 12)
  □ Accessibility: WCAG 2.1 AA (color contrast, focus management, ARIA)
  □ Reduced motion support (Section 10)

FOR PRODUCT
────────────
  □ Write scenario content (narrative, events) for all 6 scenarios
  □ Define AI advisor prompt engineering (system prompt + context)
  □ Write achievement badge descriptions and unlock criteria
  □ Define facilitator guide content for debrief mode
  □ Set benchmark KPI targets by level (Section 7 of CLAUDE.md)
```

---

| Field | Value |
|-------|-------|
| Version | 1.0 |
| Created | 2026-06-20 |
| Screens | 42 |
| Components | 20+ |
| Status | Ready for design implementation |

*This document is the single source of truth for UI/UX implementation. Start with the 5 priority screens and work outward.*
