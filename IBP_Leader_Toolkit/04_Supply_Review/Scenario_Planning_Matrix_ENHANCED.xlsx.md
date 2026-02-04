# Supply Scenario Planning Matrix - Enhanced Excel Workbook Specification

## Overview

The Supply Scenario Planning Matrix is a comprehensive workbook designed to model, evaluate, and track multiple demand-supply scenarios across the IBP planning horizon. It enables supply chain leaders to proactively prepare response strategies for demand variability, quantify financial impacts, define trigger-based activation criteria, and maintain pre-approved action plans for rapid execution. This workbook serves as the central scenario management tool for the monthly Supply Review process.

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy `#1B2A4A` |
| Accent Color | Orange `#EA580C` |
| Light Background | `#FFF7ED` (Orange tint) |
| Success Green | `#059669` |
| Warning Yellow | `#D97706` |
| Danger Red | `#DC2626` |
| Neutral Gray | `#6B7280` |
| Header Font | Calibri, 12pt, Bold, White on Navy |
| Body Font | Calibri, 10pt, `#1B2A4A` |
| Number Format | `#,##0` for units; `$#,##0` for currency; `0.0%` for percentages |
| Grid Lines | Light gray `#E5E7EB`, thin borders |
| Tab Colors | Sheet tabs colored by section: Orange for input, Navy for analysis, Green for output |

---

## Sheet 1: Settings & Configuration

### Purpose
Central configuration sheet that stores all scenario parameters, cost rates, and assumptions used throughout the workbook.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:F1 | Header: "SCENARIO PLANNING - SETTINGS & CONFIGURATION" (merged, Navy bg, White text, 14pt) |
| A3:F3 | Section: "Scenario Parameters" (Orange bg, White text) |
| A4:B4 | Labels: "Parameter" / "Value" |
| A5 | Planning Horizon (months) |
| A6 | Base Case Growth Rate (%) |
| A7 | Upside Factor 1 (%) - default 10% |
| A8 | Upside Factor 2 (%) - default 20% |
| A9 | Downside Factor 1 (%) - default -10% |
| A10 | Downside Factor 2 (%) - default -20% |
| A11 | Default Probability - Base (%) - default 40% |
| A12 | Default Probability - Upside 1 (%) - default 15% |
| A13 | Default Probability - Upside 2 (%) - default 5% |
| A14 | Default Probability - Downside 1 (%) - default 25% |
| A15 | Default Probability - Downside 2 (%) - default 15% |
| A17:F17 | Section: "Capacity Parameters" (Orange bg) |
| A18 | Standard Hours per Month |
| A19 | Max Overtime Hours per Month |
| A20 | Number of Production Lines |
| A21 | Standard Shift Capacity (units/hr) |
| A22 | Demonstrated Capacity (% of theoretical) |
| A24:F24 | Section: "Cost Rates" (Orange bg) |
| A25 | Standard Labor Rate ($/hr) |
| A26 | Overtime Premium Rate ($/hr) |
| A27 | Temporary Labor Rate ($/hr) |
| A28 | Outsourcing Rate ($/unit) |
| A29 | Pre-build Holding Cost ($/unit/month) |
| A30 | Expediting Cost Premium (%) |
| A32:F32 | Section: "Financial Assumptions" (Orange bg) |
| A33 | Average Selling Price ($/unit) |
| A34 | Standard Unit Cost ($) |
| A35 | Material Cost % of COGS |
| A36 | Target Gross Margin (%) |

### Named Ranges

| Named Range | Cell Reference | Description |
|-------------|----------------|-------------|
| Base_Growth_Rate | B6 | Base case growth assumption |
| Upside_Factor_1 | B7 | +10% scenario factor |
| Upside_Factor_2 | B8 | +20% scenario factor |
| Downside_Factor_1 | B9 | -10% scenario factor |
| Downside_Factor_2 | B10 | -20% scenario factor |
| Prob_Base | B11 | Base probability weight |
| Prob_Upside1 | B12 | Upside 1 probability |
| Prob_Upside2 | B13 | Upside 2 probability |
| Prob_Downside1 | B14 | Downside 1 probability |
| Prob_Downside2 | B15 | Downside 2 probability |
| Std_Hours_Month | B18 | Monthly standard hours |
| Max_OT_Hours | B19 | Max overtime hours |
| OT_Rate | B26 | Overtime cost rate |
| Temp_Rate | B27 | Temp labor cost rate |
| Outsource_Rate | B28 | Outsourcing unit cost |
| Prebuild_Hold_Cost | B29 | Pre-build holding cost |
| Avg_Price | B33 | Average selling price |
| Std_Unit_Cost | B34 | Standard unit cost |
| Target_GM | B36 | Target gross margin |

### Data Validation

| Cell | Validation | Error Message |
|------|------------|---------------|
| B7:B8 | Decimal 0.01 to 0.50 | "Enter upside factor between 1% and 50%" |
| B9:B10 | Decimal -0.50 to -0.01 | "Enter downside factor between -50% and -1%" |
| B11:B15 | Decimal 0.01 to 1.00 | "Enter probability between 1% and 100%" |
| B16 | Formula: `=SUM(B11:B15)` must equal 1.00 | "Probabilities must sum to 100%" |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| B16 | `=B16<>1` | Red fill `#FEE2E2`, Red text `#DC2626` |
| B16 | `=B16=1` | Green fill `#D1FAE5`, Green text `#059669` |

---

## Sheet 2: Scenario Dashboard

### Purpose
Executive-level summary showing all five scenarios side-by-side with probability-weighted expected values and feasibility indicators.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:H1 | Header: "SCENARIO PLANNING DASHBOARD" (merged, Navy bg, White text, 14pt) |
| A2:H2 | Subheader: Planning period and last updated date |
| A4:H4 | Column Headers: "Metric" / "Base Case" / "Upside +10%" / "Upside +20%" / "Downside -10%" / "Downside -20%" / "Expected Value" / "Variance to Base" |

### Columns (A4:H4)

| Column | Header | Width |
|--------|--------|-------|
| A | Metric | 30 |
| B | Base Case | 18 |
| C | Upside +10% | 18 |
| D | Upside +20% | 18 |
| E | Downside -10% | 18 |
| F | Downside -20% | 18 |
| G | Expected Value | 18 |
| H | Variance to Base | 18 |

### Row Data (Rows 5-20)

| Row | Metric | Formula Pattern |
|-----|--------|-----------------|
| 5 | Probability | `=Prob_Base`, `=Prob_Upside1`, etc. |
| 6 | Total Demand (Units) | Links to Sheet 3 totals |
| 7 | Revenue ($) | `=B6*Avg_Price` per scenario |
| 8 | COGS ($) | Links to Sheet 6 |
| 9 | Gross Margin ($) | `=B7-B8` |
| 10 | Gross Margin % | `=B9/B7` |
| 11 | Capacity Required (hrs) | Links to Sheet 4 |
| 12 | Capacity Available (hrs) | Links to Sheet 4 |
| 13 | Utilization % | `=B11/B12` |
| 14 | Capacity Gap (hrs) | `=B11-B12` |
| 15 | Additional Cost ($) | Links to Sheet 5 |
| 16 | Net Margin Impact ($) | `=B9-B15` |
| 17 | Working Capital Impact ($) | Links to Sheet 6 |
| 18 | Feasibility Status | Formula below |

### Key Formulas

```
Expected Value (Column G):
G6: =SUMPRODUCT(B6:F6,B5:F5)
G7: =SUMPRODUCT(B7:F7,B5:F5)
-- Pattern repeats for all metric rows --

Variance to Base (Column H):
H6: =G6-B6
H7: =G7-B7
-- Pattern repeats --

Feasibility Status (Row 18):
B18: =IF(B13>1.1,"NOT FEASIBLE",IF(B13>0.95,"CONSTRAINED",IF(B13>0.85,"FEASIBLE","UNDERUTILIZED")))
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| B13:F13 | `>1.0` (>100% utilization) | Red fill `#FEE2E2`, Bold Red `#DC2626` |
| B13:F13 | `>0.85` AND `<=1.0` | Yellow fill `#FEF3C7`, `#D97706` text |
| B13:F13 | `<=0.85` | Green fill `#D1FAE5`, `#059669` text |
| B18:F18 | `="NOT FEASIBLE"` | Red fill `#DC2626`, White text, Bold |
| B18:F18 | `="CONSTRAINED"` | Yellow fill `#D97706`, White text |
| B18:F18 | `="FEASIBLE"` | Green fill `#059669`, White text |
| B18:F18 | `="UNDERUTILIZED"` | Blue fill `#2563EB`, White text |
| H6:H17 | `<0` | Red text `#DC2626` |
| H6:H17 | `>0` | Green text `#059669` |
| G5:G5 | Always | Orange bg `#EA580C`, White text, Bold |

---

## Sheet 3: Scenario Demand Detail

### Purpose
Monthly and quarterly demand breakdown for each scenario, auto-calculated from base case using scenario factors.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:T1 | Header: "SCENARIO DEMAND DETAIL" (merged, Navy bg) |
| A3:A3 | "Product Family" label |
| B3:M3 | Month headers (Month 1 through Month 12) |
| N3:Q3 | Quarterly totals (Q1-Q4) |
| R3 | Annual Total |
| S3 | Revenue ($) |
| T3 | Growth vs PY |

### Section Blocks (repeated for each scenario)

**Base Case Block (Rows 4-15):**
| Row | Content |
|-----|---------|
| 4 | Section header: "BASE CASE (Probability: 40%)" - Orange bg |
| 5-12 | Product families 1-8, with monthly demand values |
| 13 | Total row: `=SUM(B5:B12)` pattern across months |
| 14 | Revenue: `=B13*Avg_Price` across months |
| 15 | Blank separator |

**Upside +10% Block (Rows 16-27):**
| Row | Content |
|-----|---------|
| 16 | Section header: "UPSIDE +10% (Probability: 15%)" |
| 17-24 | `=Base_Case_Cell*(1+Upside_Factor_1)` for each product family |
| 25 | Total: `=SUM(B17:B24)` |
| 26 | Revenue: `=B25*Avg_Price` |

**Pattern repeats for Upside +20%, Downside -10%, Downside -20%**

### Key Formulas

```
Scenario demand calculation:
B17 (Upside +10%, Family 1, Month 1): =B5*(1+Upside_Factor_1)
B29 (Upside +20%, Family 1, Month 1): =B5*(1+Upside_Factor_2)
B41 (Downside -10%, Family 1, Month 1): =B5*(1+Downside_Factor_1)
B53 (Downside -20%, Family 1, Month 1): =B5*(1+Downside_Factor_2)

Quarterly totals:
N5: =SUM(B5:D5)    (Q1)
O5: =SUM(E5:G5)    (Q2)
P5: =SUM(H5:J5)    (Q3)
Q5: =SUM(K5:M5)    (Q4)

Annual Total:
R5: =SUM(N5:Q5)

Revenue:
S5: =R5*Avg_Price

Growth vs PY:
T5: =(R5-PY_Volume)/PY_Volume
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| T5:T12 | `>0.1` (>10% growth) | Green text `#059669`, up arrow icon |
| T5:T12 | `<-0.1` (<-10% decline) | Red text `#DC2626`, down arrow icon |
| Scenario header rows | Static | Orange `#EA580C` bg, White text |

### Named Ranges

| Named Range | Reference | Description |
|-------------|-----------|-------------|
| Scenario_Base_Demand | Total row of base case | Base case total demand |
| Scenario_Up10_Demand | Total row of upside +10% | Upside 10% total demand |
| Scenario_Up20_Demand | Total row of upside +20% | Upside 20% total demand |
| Scenario_Dn10_Demand | Total row of downside -10% | Downside 10% total demand |
| Scenario_Dn20_Demand | Total row of downside -20% | Downside 20% total demand |

---

## Sheet 4: Capacity Requirements

### Purpose
Evaluate capacity needed versus available for each scenario, identify gaps, and calculate utilization rates.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:Q1 | Header: "CAPACITY REQUIREMENTS ANALYSIS" (Navy bg) |
| A3:Q3 | Column headers |

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Work Center / Resource | 25 | Text |
| B | Available Capacity (hrs) | 16 | `#,##0` |
| C | Base Demand (hrs) | 14 | `#,##0` |
| D | Base Utilization | 12 | `0.0%` |
| E | Base Gap | 12 | `#,##0` |
| F | Up+10 Demand (hrs) | 14 | `#,##0` |
| G | Up+10 Utilization | 12 | `0.0%` |
| H | Up+10 Gap | 12 | `#,##0` |
| I | Up+20 Demand (hrs) | 14 | `#,##0` |
| J | Up+20 Utilization | 12 | `0.0%` |
| K | Up+20 Gap | 12 | `#,##0` |
| L | Dn-10 Demand (hrs) | 14 | `#,##0` |
| M | Dn-10 Utilization | 12 | `0.0%` |
| N | Dn-10 Gap | 12 | `#,##0` |
| O | Dn-20 Demand (hrs) | 14 | `#,##0` |
| P | Dn-20 Utilization | 12 | `0.0%` |
| Q | Dn-20 Gap | 12 | `#,##0` |

### Key Formulas

```
Utilization:
D4: =C4/B4
G4: =F4/B4
-- Pattern repeats for all scenarios --

Gap (negative = surplus, positive = shortfall):
E4: =C4-B4
H4: =F4-B4
K4: =I4-B4
N4: =L4-B4
Q4: =O4-B4

Summary Row (bottom):
B_total: =SUM(B4:B_last)
C_total: =SUM(C4:C_last)
D_total: =C_total/B_total   (blended utilization)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| D4:D50, G4:G50, J4:J50, M4:M50, P4:P50 | `>1.0` (>100%) | Red fill `#FEE2E2`, Red text `#DC2626`, Bold |
| Same ranges | `>=0.85` AND `<=1.0` | Yellow fill `#FEF3C7`, `#D97706` text |
| Same ranges | `<0.85` | Green fill `#D1FAE5`, `#059669` text |
| E, H, K, N, Q columns | `>0` (gap/shortfall) | Red text `#DC2626` |
| E, H, K, N, Q columns | `<0` (surplus) | Green text `#059669` |
| E, H, K, N, Q columns | `=0` | Gray text `#6B7280` |

---

## Sheet 5: Supply Response Matrix

### Purpose
Define and cost response levers for each scenario, including overtime, temporary labor, outsourcing, and pre-build strategies.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:L1 | Header: "SUPPLY RESPONSE MATRIX" (Navy bg) |
| A3:L3 | Column headers |

### Columns

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Response Lever | 22 | Text |
| B | Scenario | 16 | Text |
| C | Units / Hours | 14 | `#,##0` |
| D | Unit Rate ($) | 14 | `$#,##0.00` |
| E | Total Cost ($) | 16 | `$#,##0` |
| F | Lead Time (days) | 14 | `#,##0` |
| G | Quality Risk | 12 | Text |
| H | Capacity Limit | 14 | `#,##0` |
| I | % of Gap Covered | 14 | `0.0%` |
| J | Cumulative Coverage | 14 | `0.0%` |
| K | Feasibility | 14 | Text |
| L | Notes | 30 | Text |

### Response Lever Sections

**Overtime Block:**
```
Row 5: Overtime | Base Case | [Hours] | =OT_Rate | =C5*D5 | 0 | Low | =Max_OT_Hours | =C5/Gap_Hours | ...
Row 6: Overtime | Upside +10% | ... (same pattern)
Row 7: Overtime | Upside +20% | ...
Row 8: Overtime | Downside -10% | 0 | ... | $0 | n/a
Row 9: Overtime | Downside -20% | 0 | ... | $0 | n/a
```

**Temporary Labor Block (Rows 11-15):** Same structure
**Outsourcing Block (Rows 17-21):** Same structure
**Pre-Build Inventory Block (Rows 23-27):** Same structure
**Expedited Material Block (Rows 29-33):** Same structure

### Key Formulas

```
Total Cost per lever:
E5: =C5*D5

Cumulative cost by scenario:
Total_Response_Cost: =SUMIF(Scenario_Col,"Base Case",Cost_Col)

Gap coverage:
I5: =C5/ABS(Capacity_Gap_for_Scenario)

Cumulative coverage:
J5: =I5
J6 (if same scenario): =J5+I6

Total supply response cost (summary row):
=SUMIFS(E:E, B:B, "Upside +20%")

Combined cost formula:
=Overtime_Hours*OT_Rate + Temp_Units*Temp_Rate + Outsource_Units*Outsource_Rate + Prebuild_Units*Prebuild_Hold_Cost
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G column | `="High"` | Red fill `#FEE2E2`, Red text |
| G column | `="Medium"` | Yellow fill `#FEF3C7` |
| G column | `="Low"` | Green fill `#D1FAE5` |
| K column | `="Not Feasible"` | Red fill, White text |
| K column | `="Feasible"` | Green fill, White text |
| K column | `="Partial"` | Yellow fill |
| J column | `>=1.0` (100% coverage) | Green fill, Bold |
| J column | `<1.0` | Orange fill `#FED7AA` |

### Data Validation

| Column | Validation |
|--------|------------|
| B | List: "Base Case,Upside +10%,Upside +20%,Downside -10%,Downside -20%" |
| G | List: "Low,Medium,High" |
| K | List: "Feasible,Partial,Not Feasible" |

---

## Sheet 6: Financial Impact

### Purpose
Full P&L impact analysis by scenario with working capital implications.

### Layout

| Row Range | Content |
|-----------|---------|
| A1:G1 | Header: "FINANCIAL IMPACT BY SCENARIO" (Navy bg) |
| A3:G3 | Column Headers: "P&L Line Item" / "Base Case" / "Upside +10%" / "Upside +20%" / "Downside -10%" / "Downside -20%" / "Expected Value" |

### Row Data

| Row | Line Item | Formula Pattern |
|-----|-----------|-----------------|
| 5 | **Revenue** | |
| 6 | Volume (units) | Links to Sheet 3 totals |
| 7 | Average Price ($/unit) | `=Avg_Price` |
| 8 | Gross Revenue | `=B6*B7` |
| 9 | Discounts & Rebates | `=B8*Discount_Rate` |
| 10 | **Net Revenue** | `=B8-B9` |
| 12 | **Cost of Goods Sold** | |
| 13 | Standard COGS | `=B6*Std_Unit_Cost` |
| 14 | Additional Capacity Cost | Links to Sheet 5 totals |
| 15 | **Total COGS** | `=B13+B14` |
| 17 | **Gross Margin** | `=B10-B15` |
| 18 | Gross Margin % | `=B17/B10` |
| 20 | **Operating Expenses** | |
| 21 | Fixed OpEx | Same across scenarios |
| 22 | Variable OpEx | `=B10*Variable_OpEx_Rate` |
| 23 | **Total OpEx** | `=B21+B22` |
| 25 | **Operating Income** | `=B17-B23` |
| 26 | Operating Margin % | `=B25/B10` |
| 28 | **Working Capital Impact** | |
| 29 | Incremental Inventory | `=Additional_Prebuild*Std_Unit_Cost` |
| 30 | Incremental AR | `=(B10-Base_Revenue)*DSO/365` |
| 31 | **Net WC Change** | `=B29+B30` |
| 33 | **Cash Flow Impact** | `=B25-B31` |

### Expected Value Column (G)

```
G6: =SUMPRODUCT(B6:F6,$B$5:$F$5)    -- where row 5 has probabilities
G8: =SUMPRODUCT(B8:F8,$B$5:$F$5)
-- Pattern repeats for all financial rows --
```

### Named Ranges

| Named Range | Reference | Description |
|-------------|-----------|-------------|
| Expected_Value_Revenue | G10 | Probability-weighted net revenue |
| Expected_Value_GM | G17 | Probability-weighted gross margin |
| Expected_Value_OpIncome | G25 | Probability-weighted operating income |
| Scenario_Financial_Summary | A5:G33 | Full financial impact table |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| B18:G18 | `>=Target_GM` | Green text `#059669` |
| B18:G18 | `<Target_GM` | Red text `#DC2626` |
| B25:G25 | `<0` | Red fill `#FEE2E2`, Bold Red |
| B33:G33 | `<0` | Red text, parentheses format |
| Row 17 (GM) | Data bars | Orange `#EA580C` gradient |
| Row 25 (OI) | Data bars | Navy `#1B2A4A` gradient |

---

## Sheet 7: Trigger Monitoring

### Purpose
Track leading indicators that determine which scenario is materializing and when to activate pre-defined responses.

### Layout

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Indicator Name | 28 | Text |
| B | Category | 16 | Text |
| C | Scenario Mapped | 16 | Text |
| D | Threshold Value | 14 | `#,##0.00` |
| E | Current Value | 14 | `#,##0.00` |
| F | Prior Period Value | 14 | `#,##0.00` |
| G | Trend Direction | 12 | Text |
| H | Status | 14 | Text |
| I | Days at Threshold | 10 | `#,##0` |
| J | Activation Criteria | 28 | Text |
| K | Last Updated | 14 | `yyyy-mm-dd` |
| L | Owner | 16 | Text |

### Key Formulas

```
Trend Direction:
G4: =IF(E4>F4,"Increasing",IF(E4<F4,"Decreasing","Stable"))

Status:
H4: =IF(E4>D4,"TRIGGERED",IF(E4>D4*0.9,"WARNING","MONITORING"))

-- For downside indicators (where lower = trigger):
H10: =IF(E10<D10,"TRIGGERED",IF(E10<D10*1.1,"WARNING","MONITORING"))
```

### Sample Indicators

| Row | Indicator | Category | Mapped Scenario |
|-----|-----------|----------|-----------------|
| 4 | Order Intake Rate (units/week) | Demand | Upside +10% |
| 5 | Pipeline Value ($) | Demand | Upside +20% |
| 6 | Customer Forecast Revision (%) | Demand | Various |
| 7 | Market Index Movement | External | Various |
| 8 | Raw Material Price Index | Cost | Downside -10% |
| 9 | Customer Inventory Levels | Demand | Downside -10% |
| 10 | Order Cancellation Rate (%) | Demand | Downside -20% |
| 11 | Supplier On-Time Delivery (%) | Supply | Constrained |
| 12 | Lead Time Trend (days) | Supply | Constrained |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H4:H20 | `="TRIGGERED"` | Red fill `#DC2626`, White text, Bold |
| H4:H20 | `="WARNING"` | Yellow fill `#D97706`, White text |
| H4:H20 | `="MONITORING"` | Green fill `#059669`, White text |
| G4:G20 | `="Increasing"` | Green text with up arrow |
| G4:G20 | `="Decreasing"` | Red text with down arrow |
| G4:G20 | `="Stable"` | Gray text with right arrow |
| I4:I20 | `>14` (>2 weeks at threshold) | Red fill, Bold |
| I4:I20 | `>7` | Yellow fill |

---

## Sheet 8: Decision Matrix

### Purpose
Pre-defined decision framework mapping scenarios to actions, with color-coded severity and authority levels.

### Layout

| Column | Header | Width |
|--------|--------|-------|
| A | Decision Category | 22 |
| B | Base Case Action | 24 |
| C | Upside +10% Action | 24 |
| D | Upside +20% Action | 24 |
| E | Downside -10% Action | 24 |
| F | Downside -20% Action | 24 |
| G | Decision Authority | 18 |
| H | Lead Time to Execute | 14 |
| I | Reversibility | 14 |

### Sample Decision Categories (Rows)

| Row | Category |
|-----|----------|
| 5 | Production Scheduling |
| 6 | Overtime Authorization |
| 7 | Temporary Labor Hire |
| 8 | Outsourcing Activation |
| 9 | Inventory Pre-Build |
| 10 | Raw Material Ordering |
| 11 | Capital Investment |
| 12 | Customer Allocation |
| 13 | Pricing Strategy |
| 14 | Supplier Engagement |
| 15 | Logistics Mode |

### Conditional Formatting (Action Severity)

| Color Code | Meaning | Format |
|------------|---------|--------|
| Green `#D1FAE5` | Normal operations, no change | Cell fill |
| Light Orange `#FED7AA` | Minor adjustment required | Cell fill |
| Orange `#FB923C` | Significant action needed | Cell fill |
| Red `#FEE2E2` | Critical/emergency action | Cell fill |
| Dark Red `#DC2626` bg, White text | Escalation required | Cell fill + text |

### Data Validation

| Column | Validation |
|--------|------------|
| G | List: "Plant Manager,VP Supply Chain,COO,CEO,Board" |
| I | List: "Easily Reversible,Partially Reversible,Irreversible" |

---

## Sheet 9: Action Plans

### Purpose
Detailed action plan for each scenario phase, with owners, lead times, and tracking.

### Layout

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Scenario | 16 | Text |
| B | Phase | 14 | Text |
| C | Action Item | 35 | Text |
| D | Owner | 16 | Text |
| E | Lead Time (days) | 12 | `#,##0` |
| F | Trigger Date | 12 | `yyyy-mm-dd` |
| G | Due Date | 12 | `yyyy-mm-dd` |
| H | Status | 12 | Text |
| I | Completion Date | 12 | `yyyy-mm-dd` |
| J | Dependencies | 25 | Text |
| K | Cost Estimate ($) | 14 | `$#,##0` |
| L | Notes | 30 | Text |

### Key Formulas

```
Due Date (auto-calculated from trigger):
G4: =F4+E4

Days Remaining:
-- (helper column or in Notes)
=IF(H4="Complete",0,MAX(0,G4-TODAY()))

Status auto-update suggestion:
=IF(I4<>"","Complete",IF(TODAY()>G4,"OVERDUE",IF(TODAY()>G4-7,"DUE SOON","ON TRACK")))
```

### Data Validation

| Column | Validation |
|--------|------------|
| A | List: "Base Case,Upside +10%,Upside +20%,Downside -10%,Downside -20%" |
| B | List: "Pre-Trigger,Activation,Execution,Sustained,De-escalation" |
| H | List: "Not Started,In Progress,Complete,Overdue,Cancelled" |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H column | `="Overdue"` | Red fill `#DC2626`, White text |
| H column | `="In Progress"` | Yellow fill `#FEF3C7` |
| H column | `="Complete"` | Green fill `#D1FAE5` |
| H column | `="Not Started"` | Gray fill `#F3F4F6` |
| G column | `<TODAY()` AND H<>"Complete" | Red text, Bold |

---

## Sheet 10: Sensitivity Analysis

### Purpose
Analyze variable impact on key metrics to identify highest-leverage factors.

### Layout

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Variable | 25 | Text |
| B | Base Value | 16 | `#,##0.00` |
| C | Change -20% | 14 | `$#,##0` |
| D | Change -10% | 14 | `$#,##0` |
| E | Change -5% | 14 | `$#,##0` |
| F | Base Result | 14 | `$#,##0` |
| G | Change +5% | 14 | `$#,##0` |
| H | Change +10% | 14 | `$#,##0` |
| I | Change +20% | 14 | `$#,##0` |
| J | Range (Max-Min) | 14 | `$#,##0` |
| K | Sensitivity Rank | 10 | `#,##0` |

### Key Formulas

```
Sensitivity calculation:
C4: =Base_Revenue_Formula_with(B4*(1-0.2))   -- conceptual; actual depends on variable
D4: =Base_Revenue_Formula_with(B4*(1-0.1))
E4: =Base_Revenue_Formula_with(B4*(1-0.05))
F4: =Base_Revenue_Formula_with(B4)
G4: =Base_Revenue_Formula_with(B4*(1+0.05))
H4: =Base_Revenue_Formula_with(B4*(1+0.1))
I4: =Base_Revenue_Formula_with(B4*(1+0.2))

Generic pattern:
=Base_Value * (1 + Change_Pct)

Range:
J4: =MAX(C4:I4)-MIN(C4:I4)

Rank:
K4: =RANK(J4,$J$4:$J$15,0)

Tornado chart data (for horizontal bar chart):
Low_Side: =F4-C4   (negative direction impact)
High_Side: =I4-F4  (positive direction impact)
```

### Sample Variables

| Row | Variable |
|-----|----------|
| 4 | Average Selling Price |
| 5 | Demand Volume |
| 6 | Raw Material Cost |
| 7 | Labor Cost |
| 8 | Overtime Premium |
| 9 | Outsourcing Cost |
| 10 | Capacity Utilization |
| 11 | Yield Rate |
| 12 | Exchange Rate |
| 13 | Lead Time |
| 14 | Quality Reject Rate |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| K4:K15 | `=1` (top sensitivity) | Red fill `#FEE2E2`, Bold |
| K4:K15 | `=2` | Orange fill `#FED7AA` |
| K4:K15 | `=3` | Yellow fill `#FEF3C7` |
| J column | Data bars | Orange `#EA580C` gradient |

---

## Sheet 11: Approval & Communication

### Purpose
Track scenario plan reviews, sign-offs, and communication actions.

### Layout

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Approval Step | 25 | Text |
| B | Approver Name | 18 | Text |
| C | Role / Title | 18 | Text |
| D | Required By | 14 | `yyyy-mm-dd` |
| E | Approved Date | 14 | `yyyy-mm-dd` |
| F | Status | 14 | Text |
| G | Comments | 35 | Text |

### Key Formulas

```
Status auto-calculation:
F4: =IF(E4<>"","Approved",IF(TODAY()>D4,"OVERDUE","Pending"))

Overall approval status:
=IF(COUNTIF(F:F,"Pending")>0,"Not Complete",IF(COUNTIF(F:F,"OVERDUE")>0,"Overdue","Fully Approved"))
```

### Communication Log Section (Row 15+)

| Column | Header |
|--------|--------|
| A | Communication Item |
| B | Audience |
| C | Channel |
| D | Scheduled Date |
| E | Sent Date |
| F | Status |
| G | Key Messages |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| F column | `="Approved"` | Green fill `#D1FAE5`, check icon |
| F column | `="Pending"` | Yellow fill `#FEF3C7` |
| F column | `="OVERDUE"` | Red fill `#FEE2E2`, Bold |

---

## Named Ranges Summary

| Named Range | Sheet | Reference | Purpose |
|-------------|-------|-----------|---------|
| Scenario_Base_Demand | Sheet 3 | Base case total row | Base demand linkage |
| Scenario_Probabilities | Sheet 2 | B5:F5 | Probability weights |
| Expected_Value_Revenue | Sheet 6 | G10 | Weighted revenue |
| Expected_Value_GM | Sheet 6 | G17 | Weighted gross margin |
| Expected_Value_OpIncome | Sheet 6 | G25 | Weighted operating income |
| Capacity_Available | Sheet 4 | Available column | Total available hours |
| Capacity_Gap | Sheet 4 | Gap columns | Capacity shortfall |
| Trigger_Status | Sheet 7 | H column | Current trigger states |
| Response_Cost_Total | Sheet 5 | Cost summary | Total response cost |
| Scenario_Factors | Sheet 1 | B7:B10 | Adjustment factors |
| All_Probabilities | Sheet 1 | B11:B15 | All probability values |
| Avg_Price | Sheet 1 | B33 | Average selling price |
| Std_Unit_Cost | Sheet 1 | B34 | Standard unit cost |
| OT_Rate | Sheet 1 | B26 | Overtime rate |
| Temp_Rate | Sheet 1 | B27 | Temp labor rate |
| Outsource_Rate | Sheet 1 | B28 | Outsourcing rate |

---

## Integration Points

### Inputs From Other Workbooks

| Source Workbook | Data Element | Link Method |
|----------------|--------------|-------------|
| Capacity_Planning_Template_ENHANCED | Available capacity by work center | Named range reference |
| Demand_Consensus_Tracker_ENHANCED | Consensus demand (base case) | Named range reference |
| Supply_Constraints_Log_ENHANCED | Active constraints affecting capacity | Manual reference / copy |
| Supplier_Capacity_Tracker_ENHANCED | Supplier capacity limits for outsourcing | Named range reference |

### Outputs To Other Workbooks

| Target Workbook | Data Element | Link Method |
|----------------|--------------|-------------|
| Gap_Closure_Tracker_ENHANCED | Financial gap by scenario | Named range reference |
| Plan_vs_Actual_Analysis_ENHANCED | Scenario financial projections | Named range reference |
| Executive_IBP_Pack_ENHANCED | Scenario dashboard summary | Copy/paste or link |
| IBP_Master_Integration_Workbook | Expected value metrics | Named range link |

---

## VBA / Automation

### Macro 1: Refresh Scenario Calculations

```vba
Sub RefreshScenarios()
    ' Recalculates all scenario sheets from current base case and factors
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    Dim wsSettings As Worksheet
    Set wsSettings = ThisWorkbook.Sheets("Settings & Configuration")

    Dim factors(1 To 4) As Double
    factors(1) = wsSettings.Range("Upside_Factor_1").Value
    factors(2) = wsSettings.Range("Upside_Factor_2").Value
    factors(3) = wsSettings.Range("Downside_Factor_1").Value
    factors(4) = wsSettings.Range("Downside_Factor_2").Value

    ' Validate probabilities sum to 100%
    Dim probSum As Double
    probSum = wsSettings.Range("Prob_Base").Value + _
              wsSettings.Range("Prob_Upside1").Value + _
              wsSettings.Range("Prob_Upside2").Value + _
              wsSettings.Range("Prob_Downside1").Value + _
              wsSettings.Range("Prob_Downside2").Value

    If Abs(probSum - 1) > 0.001 Then
        MsgBox "Probabilities do not sum to 100%. Current sum: " & Format(probSum, "0.0%"), vbExclamation
        Exit Sub
    End If

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Scenario calculations refreshed successfully.", vbInformation
End Sub
```

### Macro 2: Check Trigger Status

```vba
Sub CheckTriggers()
    ' Scans trigger monitoring sheet and alerts on triggered items
    Dim wsTrigger As Worksheet
    Set wsTrigger = ThisWorkbook.Sheets("Trigger Monitoring")

    Dim lastRow As Long
    lastRow = wsTrigger.Cells(wsTrigger.Rows.Count, "A").End(xlUp).Row

    Dim triggeredCount As Long
    Dim warningCount As Long
    Dim msg As String

    For i = 4 To lastRow
        Select Case wsTrigger.Cells(i, 8).Value  ' Column H = Status
            Case "TRIGGERED"
                triggeredCount = triggeredCount + 1
                msg = msg & vbCrLf & "TRIGGERED: " & wsTrigger.Cells(i, 1).Value
            Case "WARNING"
                warningCount = warningCount + 1
        End Select
    Next i

    If triggeredCount > 0 Then
        MsgBox "ALERT: " & triggeredCount & " indicators TRIGGERED, " & warningCount & " at WARNING level." & vbCrLf & msg, vbCritical
    ElseIf warningCount > 0 Then
        MsgBox warningCount & " indicators at WARNING level. No triggers activated.", vbExclamation
    Else
        MsgBox "All indicators within normal monitoring range.", vbInformation
    End If
End Sub
```

### Macro 3: Generate Scenario Report

```vba
Sub GenerateScenarioReport()
    ' Creates a formatted summary report on a new sheet
    Dim wsReport As Worksheet

    On Error Resume Next
    Application.DisplayAlerts = False
    ThisWorkbook.Sheets("Scenario Report").Delete
    Application.DisplayAlerts = True
    On Error GoTo 0

    Set wsReport = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
    wsReport.Name = "Scenario Report"

    ' Header
    With wsReport.Range("A1:G1")
        .Merge
        .Value = "SCENARIO PLANNING REPORT - " & Format(Date, "MMMM YYYY")
        .Font.Size = 14
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(27, 42, 74)  ' Navy
    End With

    ' Copy dashboard summary
    ThisWorkbook.Sheets("Scenario Dashboard").Range("A4:H20").Copy
    wsReport.Range("A3").PasteSpecial xlPasteValues
    wsReport.Range("A3").PasteSpecial xlPasteFormats

    ' Copy trigger status
    wsReport.Range("A22").Value = "TRIGGER STATUS"
    wsReport.Range("A22").Font.Bold = True
    ThisWorkbook.Sheets("Trigger Monitoring").Range("A3:H20").Copy
    wsReport.Range("A23").PasteSpecial xlPasteValues

    wsReport.Columns.AutoFit
    Application.CutCopyMode = False

    MsgBox "Scenario report generated successfully.", vbInformation
End Sub
```

---

## Print Settings

| Setting | Value |
|---------|-------|
| Orientation | Landscape |
| Paper Size | A3 for dashboard, A4 for detail sheets |
| Margins | Narrow (0.5" all sides) |
| Header | "&L&B&10Supply Scenario Planning&R&D" |
| Footer | "&L&8Confidential&C&P of &N&R&8IBP Supply Review" |
| Print Area | Set per sheet, excluding helper columns |
| Scaling | Fit to 1 page wide |
| Gridlines | Print gridlines OFF |
| Row/Col Headers | OFF |

---

## File Properties

| Property | Value |
|----------|-------|
| Workbook Name | Scenario_Planning_Matrix_ENHANCED.xlsx |
| Author | IBP Center of Excellence |
| Category | Supply Review |
| Version | 2.0 Enhanced |
| Classification | Internal Use |
| Last Updated | 2026-02-04 |
