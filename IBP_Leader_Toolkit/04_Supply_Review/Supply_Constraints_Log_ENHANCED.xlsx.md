# Supply Constraints Log - Enhanced Excel Workbook Specification

## Overview

The Supply Constraints Log is a comprehensive workbook for identifying, tracking, assessing, and resolving supply-side constraints that impact the IBP plan. It covers capacity, material, quality, and logistics constraints with full impact assessment, customer order visibility, demand allocation logic, escalation management, and forward-looking risk monitoring. This workbook is the single source of truth for all supply constraints discussed in the monthly Supply Review.

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy `#1B2A4A` |
| Accent Color | Red `#DC2626` (urgency emphasis) |
| Warning Orange | `#EA580C` |
| Caution Yellow | `#D97706` |
| Success Green | `#059669` |
| Light Red Background | `#FEF2F2` |
| Light Green Background | `#F0FDF4` |
| Neutral Gray | `#6B7280` |
| Header Font | Calibri, 12pt, Bold, White on Navy |
| Body Font | Calibri, 10pt, `#1B2A4A` |
| Number Format | `#,##0` for units; `$#,##0` for currency; `0.0%` for percentages |
| Date Format | `yyyy-mm-dd` |
| Grid Lines | Light gray `#E5E7EB`, thin borders |
| Tab Colors | Red for active constraint sheets, Navy for analysis, Green for resolved |

---

## Sheet 1: Settings

### Purpose
Define constraint categories, priority levels, SLA definitions, escalation thresholds, and lookup values used throughout the workbook.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:F1 | Header: "SUPPLY CONSTRAINTS LOG - SETTINGS" (merged, Navy bg, White text, 14pt) |
| A3:B3 | Section: "Constraint Categories" (Red bg, White text) |
| A4:B10 | Categories: Capacity, Material/Supplier, Quality, Logistics, Regulatory, Labor, Equipment |
| A12:C12 | Section: "Priority Levels" (Red bg) |
| A13:C16 | Priority: Critical (>$1M impact, <48hr SLA), High ($500K-$1M, 5-day SLA), Medium ($100K-$500K, 10-day SLA), Low (<$100K, 20-day SLA) |
| A18:D18 | Section: "SLA Definitions" (Red bg) |
| A19:D22 | SLA by priority: response time, update frequency, escalation trigger, review level |
| A24:C24 | Section: "Status Definitions" (Red bg) |
| A25:C30 | Statuses: New, Open, In Progress, Escalated, Resolved, Closed |
| A32:B32 | Section: "Escalation Thresholds" (Red bg) |
| A33:B36 | Days before auto-escalation by priority level |
| A38:B38 | Section: "Impact Categories" (Red bg) |
| A39:B44 | Revenue impact, service level, inventory, cost, customer satisfaction, compliance |

### Named Ranges

| Named Range | Reference | Description |
|-------------|-----------|-------------|
| Constraint_Categories | A4:A10 | Valid constraint category list |
| Priority_Levels | A13:A16 | Priority level list |
| Status_List | A25:A30 | Valid status values |
| SLA_Critical | B33 | SLA days for Critical |
| SLA_High | B34 | SLA days for High |
| SLA_Medium | B35 | SLA days for Medium |
| SLA_Low | B36 | SLA days for Low |
| Impact_Threshold_Critical | C13 | Dollar threshold for Critical |
| Impact_Threshold_High | C14 | Dollar threshold for High |
| Impact_Threshold_Medium | C15 | Dollar threshold for Medium |

---

## Sheet 2: Constraints Dashboard

### Purpose
Executive-level summary of all active constraints with key metrics, category breakdown, aging analysis, and trend data.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:J1 | Header: "SUPPLY CONSTRAINTS DASHBOARD" (merged, Navy bg, 14pt) |
| A2:J2 | Subheader: Last updated date and refresh indicator |

### KPI Tiles (Row 4-7)

| Position | KPI | Formula |
|----------|-----|---------|
| A4:B7 | Total Active Constraints | `=COUNTIFS(Status_Col,"<>Resolved",Status_Col,"<>Closed")` |
| C4:D7 | Total Financial Impact ($) | `=SUMIFS(Impact_Col,Status_Col,"Open")+SUMIFS(Impact_Col,Status_Col,"In Progress")+SUMIFS(Impact_Col,Status_Col,"Escalated")` |
| E4:F7 | Critical Constraints | `=COUNTIF(Priority_Col,"Critical")` |
| G4:H7 | Average Days Open | `=AVERAGE(IF((Status_Col<>"Resolved")*(Status_Col<>"Closed"),TODAY()-Date_Identified_Col))` (array formula, Ctrl+Shift+Enter) |
| I4:J7 | Overdue Items (past SLA) | `=COUNTIF(SLA_Status_Col,"OVERDUE")` |

### Category Breakdown (Row 9-16)

| Column | Header |
|--------|--------|
| A | Constraint Category |
| B | Open Count |
| C | In Progress Count |
| D | Escalated Count |
| E | Total Active |
| F | Financial Impact ($) |
| G | Avg Days Open |
| H | Resolved This Month |
| I | Trend (vs Prior Month) |

### Key Formulas

```
Open Count per Category:
B10: =COUNTIFS('Active Constraints Log'!C:C,A10,'Active Constraints Log'!G:G,"Open")

In Progress per Category:
C10: =COUNTIFS('Active Constraints Log'!C:C,A10,'Active Constraints Log'!G:G,"In Progress")

Financial Impact per Category:
F10: =SUMIFS('Active Constraints Log'!I:I,'Active Constraints Log'!C:C,A10,'Active Constraints Log'!G:G,"<>Resolved",'Active Constraints Log'!G:G,"<>Closed")

Average Days Open per Category:
G10: =AVERAGEIFS('Active Constraints Log'!K:K,'Active Constraints Log'!C:C,A10,'Active Constraints Log'!G:G,"<>Resolved",'Active Constraints Log'!G:G,"<>Closed")

Trend:
I10: =E10 - Prior_Month_Count   (manual or linked)
```

### Aging Summary (Row 18-24)

| Column A | Column B | Column C | Column D | Column E |
|----------|----------|----------|----------|----------|
| Aging Bucket | Count | % of Total | Avg Impact | Cumulative % |
| 0-7 days | `=COUNTIFS(...)` | `=B19/Total` | | |
| 8-14 days | | | | |
| 15-30 days | | | | |
| 31-60 days | | | | |
| 61-90 days | | | | |
| >90 days | | | | |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| KPI tile for Critical | `>0` | Red fill `#DC2626`, White text, 20pt Bold |
| KPI tile for Overdue | `>0` | Red fill `#FEE2E2`, Red text |
| I10:I16 (Trend) | `>0` (increasing = worse) | Red text with up arrow |
| I10:I16 (Trend) | `<0` (decreasing = better) | Green text with down arrow |
| Aging >60 days | `>0` | Red fill `#FEE2E2` |

---

## Sheet 3: Active Constraints Log

### Purpose
Complete register of all active constraints with full detail, auto-calculated aging, and priority scoring.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text (auto: "SC-" & ROW()) |
| B | Date Identified | 12 | `yyyy-mm-dd` |
| C | Category | 16 | Text (validated) |
| D | Sub-Category | 16 | Text |
| E | Description | 40 | Text, wrap |
| F | Affected Area | 18 | Text |
| G | Status | 12 | Text (validated) |
| H | Priority | 12 | Text (auto-calc or validated) |
| I | Financial Impact ($) | 16 | `$#,##0` |
| J | Service Impact (%) | 12 | `0.0%` |
| K | Days Open | 10 | `#,##0` (auto-calc) |
| L | SLA Days | 10 | `#,##0` (auto-calc) |
| M | SLA Status | 14 | Text (auto-calc) |
| N | Owner | 16 | Text |
| O | Root Cause | 30 | Text |
| P | Mitigation Plan | 35 | Text |
| Q | Target Resolution Date | 14 | `yyyy-mm-dd` |
| R | Last Updated | 12 | `yyyy-mm-dd` |
| S | Notes | 30 | Text |

### Key Formulas

```
Constraint ID:
A4: ="SC-"&TEXT(ROW()-3,"000")

Days Open:
K4: =TODAY()-B4

Priority Auto-Calculation:
H4: =IF(I4>Impact_Threshold_Critical,"Critical",IF(I4>Impact_Threshold_High,"High",IF(I4>Impact_Threshold_Medium,"Medium","Low")))

SLA Days (based on priority):
L4: =IF(H4="Critical",SLA_Critical,IF(H4="High",SLA_High,IF(H4="Medium",SLA_Medium,SLA_Low)))

SLA Status:
M4: =IF(G4="Resolved","N/A",IF(K4>L4,"OVERDUE",IF(K4>L4*0.8,"AT RISK","ON TRACK")))
```

### Data Validation

| Column | Validation |
|--------|------------|
| C | List: =Constraint_Categories |
| G | List: =Status_List |
| H | List: =Priority_Levels (if manual override) |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H column | `="Critical"` | Red fill `#DC2626`, White text, Bold |
| H column | `="High"` | Orange fill `#EA580C`, White text |
| H column | `="Medium"` | Yellow fill `#D97706`, White text |
| H column | `="Low"` | Green fill `#059669`, White text |
| M column | `="OVERDUE"` | Red fill `#FEE2E2`, Red text `#DC2626`, Bold |
| M column | `="AT RISK"` | Yellow fill `#FEF3C7`, `#D97706` text |
| M column | `="ON TRACK"` | Green fill `#D1FAE5`, `#059669` text |
| K column | `>60` | Red text, Bold |
| K column | `>30` AND `<=60` | Orange text |
| Entire row | If H="Critical" | Light red row fill `#FEF2F2` |

---

## Sheet 4: Constraint Impact Assessment

### Purpose
Detailed assessment of each constraint's impact on products, customers, and financials.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text (linked to Sheet 3) |
| B | Affected Product(s) | 20 | Text |
| C | Affected Customer(s) | 20 | Text |
| D | Month 1 Impact ($) | 14 | `$#,##0` |
| E | Month 2 Impact ($) | 14 | `$#,##0` |
| F | Month 3 Impact ($) | 14 | `$#,##0` |
| G | Rolling 3-Month Impact ($) | 16 | `$#,##0` |
| H | Units Affected | 14 | `#,##0` |
| I | Service Level Impact (%) | 14 | `0.0%` |
| J | Revenue at Risk ($) | 16 | `$#,##0` |
| K | Customer Relationship Risk | 16 | Text |
| L | Mitigation Effectiveness (%) | 14 | `0.0%` |
| M | Residual Impact ($) | 16 | `$#,##0` |

### Key Formulas

```
Rolling 3-Month Impact:
G4: =SUM(D4:F4)

Revenue at Risk:
J4: =H4*Avg_Price

Residual Impact (after mitigation):
M4: =G4*(1-L4)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `>500000` | Red fill, Bold |
| G column | `>100000` | Orange fill |
| K column | `="High"` | Red text |
| L column | `<0.5` | Red text (mitigation less than 50% effective) |
| L column | `>=0.8` | Green text (80%+ effective) |

---

## Sheet 5: Capacity Constraints

### Purpose
Work center and production line specific capacity constraints with gap analysis.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Work Center | 20 | Text |
| B | Constraint ID | 12 | Text |
| C | Constraint Description | 30 | Text |
| D | Required Capacity (hrs) | 16 | `#,##0` |
| E | Available Capacity (hrs) | 16 | `#,##0` |
| F | Gap (hrs) | 14 | `#,##0` |
| G | Utilization (%) | 12 | `0.0%` |
| H | Impact Period (Start) | 14 | `yyyy-mm-dd` |
| I | Impact Period (End) | 14 | `yyyy-mm-dd` |
| J | Duration (weeks) | 10 | `#,##0` |
| K | Units Affected | 14 | `#,##0` |
| L | Mitigation Action | 30 | Text |
| M | Status | 12 | Text |

### Key Formulas

```
Gap:
F4: =D4-E4

Utilization:
G4: =D4/E4

Duration:
J4: =(I4-H4)/7
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `>1.0` (>100%) | Red fill `#FEE2E2`, Red text, Bold |
| G column | `>=0.85` AND `<=1.0` | Yellow fill `#FEF3C7` |
| G column | `<0.85` | Green fill `#D1FAE5` |
| F column | `>0` (gap) | Red text |
| F column | `<=0` (surplus) | Green text |

---

## Sheet 6: Material / Supplier Constraints

### Purpose
Track material shortages and supplier-related constraints with stock-out risk assessment.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text |
| B | Material / Part Number | 18 | Text |
| C | Material Description | 25 | Text |
| D | Supplier Name | 20 | Text |
| E | Current Inventory (units) | 16 | `#,##0` |
| F | Daily Usage Rate (units) | 14 | `#,##0` |
| G | Days Until Stock-Out | 12 | `#,##0` |
| H | Next Receipt Date | 14 | `yyyy-mm-dd` |
| I | Next Receipt Qty (units) | 14 | `#,##0` |
| J | Coverage After Receipt (days) | 14 | `#,##0` |
| K | Alternative Source | 18 | Text |
| L | Alt Source Lead Time (days) | 14 | `#,##0` |
| M | Risk Level | 12 | Text |
| N | Mitigation Action | 30 | Text |
| O | Status | 12 | Text |

### Key Formulas

```
Days Until Stock-Out:
G4: =IF(F4>0,E4/F4,"N/A")

Coverage After Receipt:
J4: =(E4+I4)/F4

Risk Level:
M4: =IF(G4<7,"Critical",IF(G4<14,"High",IF(G4<30,"Medium","Low")))
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `<7` | Red fill `#DC2626`, White text, Bold |
| G column | `>=7` AND `<14` | Orange fill `#EA580C`, White text |
| G column | `>=14` AND `<30` | Yellow fill `#FEF3C7` |
| G column | `>=30` | Green fill `#D1FAE5` |
| M column | Same pattern as G column by text value |
| K column | `=""` or "None" | Red fill (no alternative) |

---

## Sheet 7: Quality Constraints

### Purpose
Quality issues affecting production capacity and output.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text |
| B | Quality Issue Description | 30 | Text |
| C | Affected Product | 20 | Text |
| D | Affected Work Center | 18 | Text |
| E | Standard Yield (%) | 12 | `0.0%` |
| F | Actual Yield (%) | 12 | `0.0%` |
| G | Yield Loss (%) | 12 | `0.0%` |
| H | Volume Affected (units) | 14 | `#,##0` |
| I | Yield Impact (units) | 14 | `#,##0` |
| J | Financial Impact ($) | 16 | `$#,##0` |
| K | Root Cause | 25 | Text |
| L | Corrective Action | 30 | Text |
| M | Target Resolution Date | 14 | `yyyy-mm-dd` |
| N | Status | 12 | Text |

### Key Formulas

```
Yield Loss:
G4: =E4-F4

Yield Impact (units lost):
I4: =(E4-F4)*H4

Financial Impact:
J4: =I4*Std_Unit_Cost
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `>0.1` (>10% yield loss) | Red fill, Bold |
| G column | `>0.05` AND `<=0.1` | Yellow fill |
| G column | `<=0.05` | Green fill |

---

## Sheet 8: Logistics Constraints

### Purpose
Transportation, warehousing, and distribution constraints.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text |
| B | Logistics Issue | 30 | Text |
| C | Mode (Road/Rail/Sea/Air) | 14 | Text |
| D | Origin | 18 | Text |
| E | Destination | 18 | Text |
| F | Impact Type | 16 | Text |
| G | Delay (days) | 10 | `#,##0` |
| H | Volume Affected (units) | 14 | `#,##0` |
| I | Cost Impact ($) | 16 | `$#,##0` |
| J | Customer Impact | 20 | Text |
| K | Alternative Mode | 14 | Text |
| L | Alternative Cost ($) | 16 | `$#,##0` |
| M | Cost Premium ($) | 14 | `$#,##0` |
| N | Status | 12 | Text |

### Key Formulas

```
Cost Premium:
M4: =L4-I4   (if comparing alternative cost vs. impact cost)
-- Or: =L4 (if alternative is incremental cost)
```

### Data Validation

| Column | Validation |
|--------|------------|
| C | List: "Road,Rail,Sea,Air,Intermodal" |
| F | List: "Delay,Capacity Shortage,Cost Increase,Route Disruption,Port Congestion" |

---

## Sheet 9: Resolution Tracker

### Purpose
Track resolved constraints with timing metrics and lessons learned.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text |
| B | Category | 14 | Text |
| C | Description | 30 | Text |
| D | Priority | 12 | Text |
| E | Date Identified | 12 | `yyyy-mm-dd` |
| F | Resolution Date | 12 | `yyyy-mm-dd` |
| G | Resolution Time (days) | 14 | `#,##0` |
| H | SLA Target (days) | 10 | `#,##0` |
| I | Met SLA? | 10 | Text |
| J | Financial Impact (Actual) | 16 | `$#,##0` |
| K | Resolution Action | 30 | Text |
| L | Lessons Learned | 35 | Text |
| M | Preventive Action | 30 | Text |
| N | Resolved By | 16 | Text |

### Key Formulas

```
Resolution Time:
G4: =F4-E4

Met SLA:
I4: =IF(G4<=H4,"Yes","No")

Average Resolution by Category (summary section):
=AVERAGEIFS(G:G,B:B,"Capacity")
=AVERAGEIFS(G:G,B:B,"Material/Supplier")
-- etc. --

% Met SLA:
=COUNTIFS(I:I,"Yes",B:B,"Capacity")/COUNTIF(B:B,"Capacity")
```

### Summary Section (below data)

| Metric | Formula |
|--------|---------|
| Total Resolved (MTD) | `=COUNTIFS(F:F,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1))` |
| Average Resolution Time | `=AVERAGE(G:G)` |
| SLA Achievement Rate | `=COUNTIF(I:I,"Yes")/COUNTA(I:I)` |
| Top Resolution Category | `=INDEX(B:B,MATCH(MAX(COUNTIF(B:B,B:B)),COUNTIF(B:B,B:B),0))` |

---

## Sheet 10: Customer Order Impact

### Purpose
Track specific customer orders affected by supply constraints and delay assessment.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Customer Name | 20 | Text |
| B | Order Number | 14 | Text |
| C | Order Line | 8 | Text |
| D | Product | 18 | Text |
| E | Order Qty (units) | 14 | `#,##0` |
| F | Original Promise Date | 14 | `yyyy-mm-dd` |
| G | Revised Promise Date | 14 | `yyyy-mm-dd` |
| H | Delay (days) | 10 | `#,##0` |
| I | Revenue Impact ($) | 16 | `$#,##0` |
| J | Constraint ID | 12 | Text |
| K | Customer Tier | 10 | Text |
| L | Communication Status | 16 | Text |
| M | Customer Response | 20 | Text |
| N | Risk of Loss | 12 | Text |

### Key Formulas

```
Delay:
H4: =G4-F4

Revenue Impact:
I4: =E4*Avg_Price

-- Summary by Customer Tier --
Total Delayed Orders (Tier 1): =COUNTIF(K:K,"Tier 1")
Total Revenue Impact (Tier 1): =SUMIF(K:K,"Tier 1",I:I)
Average Delay (Tier 1): =AVERAGEIF(K:K,"Tier 1",H:H)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H column | `>14` | Red fill, Bold |
| H column | `>7` AND `<=14` | Orange fill |
| H column | `>0` AND `<=7` | Yellow fill |
| K column | `="Tier 1"` | Navy bg, White text |
| L column | `="Not Communicated"` | Red fill |
| N column | `="High"` | Red text, Bold |

### Data Validation

| Column | Validation |
|--------|------------|
| K | List: "Tier 1,Tier 2,Tier 3" |
| L | List: "Not Communicated,Communication Scheduled,Communicated,Acknowledged" |
| N | List: "Low,Medium,High,Critical" |

---

## Sheet 11: Demand Allocation

### Purpose
Allocation logic and tracking when supply is constrained and demand exceeds available supply.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Product | 18 | Text |
| B | Customer | 20 | Text |
| C | Customer Priority | 12 | Text |
| D | Priority Share (%) | 12 | `0.0%` |
| E | Original Demand (units) | 16 | `#,##0` |
| F | Available Supply (units) | 16 | `#,##0` |
| G | Allocated Qty (units) | 16 | `#,##0` |
| H | Shortfall (units) | 14 | `#,##0` |
| I | Fill Rate (%) | 12 | `0.0%` |
| J | Revenue Impact ($) | 16 | `$#,##0` |
| K | Allocation Method | 16 | Text |
| L | Override Approved By | 16 | Text |
| M | Notes | 25 | Text |

### Key Formulas

```
Allocated Quantity (priority-based):
G4: =MIN(E4, F4*D4)
-- More sophisticated: =MIN(E4, SUMPRODUCT(Available_for_Product * Priority_Share_for_Customer))

Shortfall:
H4: =MAX(0, E4-G4)

Fill Rate:
I4: =G4/E4

Revenue Impact of Shortfall:
J4: =H4*Avg_Price

Total Allocation Check:
-- Summary row should verify: SUM(Allocated) <= Available Supply
=IF(SUM(G_range)>F4,"OVER-ALLOCATED","OK")
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| I column | `<0.8` (<80% fill) | Red fill |
| I column | `>=0.8` AND `<0.95` | Yellow fill |
| I column | `>=0.95` | Green fill |
| H column | `>0` | Red text |
| C column | `="Tier 1"` | Navy bg, White text |

### Data Validation

| Column | Validation |
|--------|------------|
| C | List: "Tier 1,Tier 2,Tier 3" |
| K | List: "Pro-Rata,Priority-Based,Revenue-Based,First-Come,Manual Override" |

---

## Sheet 12: Escalation Matrix

### Purpose
Automatic escalation rules based on SLA tracking and constraint severity.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Constraint ID | 12 | Text |
| B | Priority | 12 | Text |
| C | Date Identified | 12 | `yyyy-mm-dd` |
| D | Days Open | 10 | `#,##0` |
| E | SLA Days | 10 | `#,##0` |
| F | SLA Status | 14 | Text |
| G | Escalation Level | 14 | Text |
| H | Escalated To | 18 | Text |
| I | Escalation Date | 12 | `yyyy-mm-dd` |
| J | Response Deadline | 12 | `yyyy-mm-dd` |
| K | Response Status | 14 | Text |
| L | Resolution ETA | 12 | `yyyy-mm-dd` |
| M | Notes | 30 | Text |

### Key Formulas

```
Days Open:
D4: =TODAY()-C4

SLA Status:
F4: =IF(D4>E4,"OVERDUE",IF(D4>E4*0.8,"AT RISK","ON TRACK"))

Escalation Level:
G4: =IF(D4>E4*2,"Level 3 - Executive",IF(D4>E4*1.5,"Level 2 - VP",IF(D4>E4,"Level 1 - Director","No Escalation")))

Escalated To (based on level):
H4: =IF(G4="Level 3 - Executive","COO/CEO",IF(G4="Level 2 - VP","VP Supply Chain",IF(G4="Level 1 - Director","Supply Chain Director","N/A")))

Response Deadline:
J4: =I4+2   (48 hours for escalated items)
```

### Escalation Rules Table (Reference)

| Priority | SLA | Level 1 Trigger | Level 2 Trigger | Level 3 Trigger |
|----------|-----|-----------------|-----------------|-----------------|
| Critical | 2 days | At SLA | 1.5x SLA | 2x SLA |
| High | 5 days | At SLA | 1.5x SLA | 2x SLA |
| Medium | 10 days | At SLA | 1.5x SLA | 2x SLA |
| Low | 20 days | At SLA | 1.5x SLA | 2x SLA |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| F column | `="OVERDUE"` | Red fill `#DC2626`, White text, Bold |
| F column | `="AT RISK"` | Yellow fill `#D97706`, White text |
| F column | `="ON TRACK"` | Green fill `#059669`, White text |
| G column | Contains "Level 3" | Red fill, Bold |
| G column | Contains "Level 2" | Orange fill |
| G column | Contains "Level 1" | Yellow fill |
| K column | `="No Response"` | Red fill |
| Entire row | If F="OVERDUE" | Light red row fill `#FEF2F2` |

---

## Sheet 13: Risk Watch

### Purpose
Forward-looking register of potential constraints not yet materialized, with probability and impact scoring.

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Risk ID | 10 | Text |
| B | Risk Description | 35 | Text |
| C | Category | 14 | Text |
| D | Potential Trigger | 25 | Text |
| E | Probability Score (1-5) | 12 | `#,##0` |
| F | Impact Score (1-5) | 12 | `#,##0` |
| G | Risk Score | 10 | `#,##0` |
| H | Risk Level | 12 | Text |
| I | Estimated Financial Impact ($) | 16 | `$#,##0` |
| J | Monitoring Indicator | 25 | Text |
| K | Current Indicator Value | 14 | Text |
| L | Threshold for Escalation | 14 | Text |
| M | Mitigation Strategy | 30 | Text |
| N | Owner | 16 | Text |
| O | Review Date | 12 | `yyyy-mm-dd` |
| P | Status | 14 | Text |

### Key Formulas

```
Risk Score:
G4: =E4*F4

Risk Level:
H4: =IF(G4>=20,"Critical",IF(G4>=12,"High",IF(G4>=6,"Medium","Low")))
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `>=20` | Red fill `#DC2626`, White text |
| G column | `>=12` AND `<20` | Orange fill `#EA580C`, White text |
| G column | `>=6` AND `<12` | Yellow fill `#FEF3C7` |
| G column | `<6` | Green fill `#D1FAE5` |
| H column | Same pattern as G by text value |
| O column | `<TODAY()` (overdue review) | Red text, Bold |
| P column | `="Escalated to Active"` | Red fill |

### Risk Heat Map Data (for chart)

```
Probability (Y-axis): 1-5
Impact (X-axis): 1-5
Cell value: Count of risks in each intersection
=COUNTIFS(E:E,Row_Prob,F:F,Col_Impact)
```

---

## Named Ranges Summary

| Named Range | Sheet | Reference | Purpose |
|-------------|-------|-----------|---------|
| Constraint_Categories | Settings | A4:A10 | Category validation list |
| Priority_Levels | Settings | A13:A16 | Priority validation list |
| Status_List | Settings | A25:A30 | Status validation list |
| SLA_Critical | Settings | B33 | Critical SLA days |
| SLA_High | Settings | B34 | High SLA days |
| SLA_Medium | Settings | B35 | Medium SLA days |
| SLA_Low | Settings | B36 | Low SLA days |
| Active_Constraints | Sheet 3 | Full data range | All active constraints |
| Impact_Total | Sheet 2 | KPI cell | Total financial impact |
| Overdue_Count | Sheet 2 | KPI cell | Overdue constraint count |
| Allocation_Table | Sheet 11 | Full data range | Demand allocation data |
| Risk_Watch_Items | Sheet 13 | Full data range | Forward-looking risks |

---

## Integration Points

### Inputs From Other Workbooks

| Source Workbook | Data Element | Link Method |
|----------------|--------------|-------------|
| Capacity_Planning_Template_ENHANCED | Work center capacity data | Named range reference |
| Supplier_Capacity_Tracker_ENHANCED | Supplier capacity and risk data | Named range reference |
| Scenario_Planning_Matrix_ENHANCED | Capacity gap data by scenario | Named range reference |
| Demand_Consensus_Tracker_ENHANCED | Demand requiring supply response | Named range reference |

### Outputs To Other Workbooks

| Target Workbook | Data Element | Link Method |
|----------------|--------------|-------------|
| Scenario_Planning_Matrix_ENHANCED | Active constraints affecting capacity | Manual / link |
| Inventory_Analysis_Dashboard_ENHANCED | Constraints affecting inventory | Named range reference |
| Executive_IBP_Pack_ENHANCED | Constraint summary for executive review | Copy / link |
| IBP_Master_Integration_Workbook | Total constraint impact metrics | Named range link |

---

## VBA / Automation

### Macro 1: Auto-Escalation Check

```vba
Sub CheckEscalations()
    ' Checks all active constraints against SLA and flags escalations
    Dim wsLog As Worksheet
    Dim wsEsc As Worksheet
    Set wsLog = ThisWorkbook.Sheets("Active Constraints Log")
    Set wsEsc = ThisWorkbook.Sheets("Escalation Matrix")

    Dim lastRow As Long
    lastRow = wsLog.Cells(wsLog.Rows.Count, "A").End(xlUp).Row
    Dim escRow As Long
    escRow = wsEsc.Cells(wsEsc.Rows.Count, "A").End(xlUp).Row + 1

    Dim newEscalations As Long

    For i = 4 To lastRow
        Dim daysOpen As Long
        Dim slaDays As Long
        Dim status As String

        status = wsLog.Cells(i, 7).Value  ' Column G = Status
        If status <> "Resolved" And status <> "Closed" Then
            daysOpen = Date - wsLog.Cells(i, 2).Value
            slaDays = wsLog.Cells(i, 12).Value  ' Column L

            If daysOpen > slaDays Then
                ' Check if already escalated
                Dim constraintID As String
                constraintID = wsLog.Cells(i, 1).Value

                If Application.CountIf(wsEsc.Range("A:A"), constraintID) = 0 Then
                    ' Add to escalation matrix
                    wsEsc.Cells(escRow, 1).Value = constraintID
                    wsEsc.Cells(escRow, 2).Value = wsLog.Cells(i, 8).Value  ' Priority
                    wsEsc.Cells(escRow, 3).Value = wsLog.Cells(i, 2).Value  ' Date identified
                    wsEsc.Cells(escRow, 4).Value = daysOpen
                    wsEsc.Cells(escRow, 5).Value = slaDays
                    wsEsc.Cells(escRow, 6).Value = "OVERDUE"
                    wsEsc.Cells(escRow, 9).Value = Date  ' Escalation date
                    wsEsc.Cells(escRow, 10).Value = Date + 2  ' Response deadline

                    escRow = escRow + 1
                    newEscalations = newEscalations + 1
                End If
            End If
        End If
    Next i

    If newEscalations > 0 Then
        MsgBox newEscalations & " new escalation(s) added to the Escalation Matrix.", vbExclamation
    Else
        MsgBox "No new escalations required.", vbInformation
    End If
End Sub
```

### Macro 2: Move Resolved to Tracker

```vba
Sub MoveResolvedConstraints()
    ' Moves resolved constraints from Active Log to Resolution Tracker
    Dim wsLog As Worksheet
    Dim wsResolved As Worksheet
    Set wsLog = ThisWorkbook.Sheets("Active Constraints Log")
    Set wsResolved = ThisWorkbook.Sheets("Resolution Tracker")

    Dim lastRow As Long
    lastRow = wsLog.Cells(wsLog.Rows.Count, "A").End(xlUp).Row
    Dim movedCount As Long

    For i = lastRow To 4 Step -1
        If wsLog.Cells(i, 7).Value = "Resolved" Then
            Dim destRow As Long
            destRow = wsResolved.Cells(wsResolved.Rows.Count, "A").End(xlUp).Row + 1

            ' Copy key fields
            wsResolved.Cells(destRow, 1).Value = wsLog.Cells(i, 1).Value  ' ID
            wsResolved.Cells(destRow, 2).Value = wsLog.Cells(i, 3).Value  ' Category
            wsResolved.Cells(destRow, 3).Value = wsLog.Cells(i, 5).Value  ' Description
            wsResolved.Cells(destRow, 4).Value = wsLog.Cells(i, 8).Value  ' Priority
            wsResolved.Cells(destRow, 5).Value = wsLog.Cells(i, 2).Value  ' Date Identified
            wsResolved.Cells(destRow, 6).Value = Date                       ' Resolution Date
            wsResolved.Cells(destRow, 7).Value = Date - wsLog.Cells(i, 2).Value  ' Resolution Time
            wsResolved.Cells(destRow, 10).Value = wsLog.Cells(i, 9).Value  ' Financial Impact

            ' Delete from active log
            wsLog.Rows(i).Delete
            movedCount = movedCount + 1
        End If
    Next i

    MsgBox movedCount & " constraint(s) moved to Resolution Tracker.", vbInformation
End Sub
```

### Macro 3: Dashboard Refresh

```vba
Sub RefreshDashboard()
    ' Refreshes all dashboard calculations
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' Force recalculation of all sheets
    ThisWorkbook.Sheets("Constraints Dashboard").Calculate
    ThisWorkbook.Sheets("Active Constraints Log").Calculate
    ThisWorkbook.Sheets("Escalation Matrix").Calculate

    ' Update last refreshed timestamp
    ThisWorkbook.Sheets("Constraints Dashboard").Range("J2").Value = "Last Refreshed: " & Format(Now, "yyyy-mm-dd hh:mm")

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Dashboard refreshed successfully.", vbInformation
End Sub
```

---

## Print Settings

| Setting | Value |
|---------|-------|
| Orientation | Landscape |
| Paper Size | A4 for detail sheets, A3 for dashboard |
| Margins | Narrow (0.5" all sides) |
| Header | "&L&B&10Supply Constraints Log&R&D" |
| Footer | "&L&8Confidential&C&P of &N&R&8IBP Supply Review" |
| Print Area | Set per sheet, excluding helper columns |
| Scaling | Fit to 1 page wide |
| Repeat Rows | Row 3 (headers) on all pages |
| Gridlines | Print gridlines OFF |

---

## File Properties

| Property | Value |
|----------|-------|
| Workbook Name | Supply_Constraints_Log_ENHANCED.xlsx |
| Author | IBP Center of Excellence |
| Category | Supply Review |
| Version | 2.0 Enhanced |
| Classification | Internal Use |
| Last Updated | 2026-02-04 |
