# Inventory Optimization Model - Enhanced Excel Workbook
## Automated Stock Level Optimization for 50 SKUs

---

## Overview
Complete inventory optimization workbook with automatic safety stock, reorder point, and EOQ calculations. Input demand history, lead times, and service targets - all other parameters are auto-calculated using statistical methods and industry best practices.

---

## Design Theme: "Optimization Engine"

| Element | Specification |
|---------|---------------|
| Primary Color | Deep Blue (#1E3A5F) |
| Secondary Color | Teal (#0D9488) |
| Input Cells | Light Yellow (#FEF9C3) with border |
| Calculated Cells | Light Gray (#F3F4F6) |
| Optimal | Green (#10B981) |
| Warning | Amber (#F59E0B) |
| Critical | Red (#EF4444) |
| Headers | Navy (#1E3A5F) white text |

---

# SHEET 1: DASHBOARD

## Layout: Executive Summary with Key Metrics

### Row 1-2: Title Bar
```
INVENTORY OPTIMIZATION MODEL - EXECUTIVE DASHBOARD
Last Refreshed: [Auto-timestamp]    Items Analyzed: 50    Data Period: 36 Months
```

### Row 4-8: KPI Tiles (5 columns)

| Tile | Formula | Format |
|------|---------|--------|
| **Total Recommended Safety Stock (Units)** | `=SUM(Optimization!J3:J52)` | #,##0 |
| **Total Recommended Safety Stock ($)** | `=SUMPRODUCT(Optimization!J3:J52,Item_Master!D3:D52)` | $#,##0 |
| **Average Service Level Target** | `=AVERAGE(Service_Targets!C3:C52)` | 0.0% |
| **Items Requiring Attention** | `=COUNTIF(Optimization!Q3:Q52,"Review")` | #,##0 |
| **Total Reorder Point Value ($)** | `=SUMPRODUCT(Optimization!L3:L52,Item_Master!D3:D52)` | $#,##0 |

### Row 10-12: Secondary Metrics

| Metric | Formula |
|--------|---------|
| Avg Days of Supply (Safety Stock) | `=AVERAGE(Optimization!K3:K52)` |
| Items with High Variability (CV>1) | `=COUNTIF(Demand_Statistics!G3:G52,">1")` |
| Items with Intermittent Demand | `=COUNTIF(Demand_Statistics!J3:J52,"Intermittent")+COUNTIF(Demand_Statistics!J3:J52,"Lumpy")` |
| Avg Lead Time (Days) | `=AVERAGE(Lead_Times!C3:C52)` |
| Recommended Total Cycle Stock ($) | `=SUMPRODUCT(Optimization!N3:N52,Item_Master!D3:D52)/2` |

### Row 14-30: ABC-XYZ Distribution Chart

| Class | Count Formula | % of Items | % of Value |
|-------|---------------|------------|------------|
| AX | `=COUNTIFS(ABC_XYZ!D3:D52,"A",ABC_XYZ!G3:G52,"X")` | Auto | Auto |
| AY | `=COUNTIFS(ABC_XYZ!D3:D52,"A",ABC_XYZ!G3:G52,"Y")` | Auto | Auto |
| AZ | `=COUNTIFS(ABC_XYZ!D3:D52,"A",ABC_XYZ!G3:G52,"Z")` | Auto | Auto |
| BX | `=COUNTIFS(ABC_XYZ!D3:D52,"B",ABC_XYZ!G3:G52,"X")` | Auto | Auto |
| BY | `=COUNTIFS(ABC_XYZ!D3:D52,"B",ABC_XYZ!G3:G52,"Y")` | Auto | Auto |
| BZ | `=COUNTIFS(ABC_XYZ!D3:D52,"B",ABC_XYZ!G3:G52,"Z")` | Auto | Auto |
| CX | `=COUNTIFS(ABC_XYZ!D3:D52,"C",ABC_XYZ!G3:G52,"X")` | Auto | Auto |
| CY | `=COUNTIFS(ABC_XYZ!D3:D52,"C",ABC_XYZ!G3:G52,"Y")` | Auto | Auto |
| CZ | `=COUNTIFS(ABC_XYZ!D3:D52,"C",ABC_XYZ!G3:G52,"Z")` | Auto | Auto |

### Row 32-50: Top 10 Items by Safety Stock Value

| Col | Header | Formula |
|-----|--------|---------|
| A | Rank | 1-10 |
| B | Item Code | `=INDEX(Item_Master!A:A,MATCH(LARGE(SS_Value_Range,A3),SS_Value_Range,0))` |
| C | Description | `=VLOOKUP(B3,Item_Master!A:B,2,FALSE)` |
| D | Safety Stock Units | `=VLOOKUP(B3,Optimization!A:J,10,FALSE)` |
| E | Safety Stock Value | `=D3*VLOOKUP(B3,Item_Master!A:D,4,FALSE)` |
| F | Days of Supply | `=VLOOKUP(B3,Optimization!A:K,11,FALSE)` |
| G | Classification | `=VLOOKUP(B3,ABC_XYZ!A:H,8,FALSE)` |

---

# SHEET 2: SETTINGS

## Global Parameters (Auto-Calculated Defaults with Override Option)

| Row | Parameter | Default Value | Override | Active Value | Formula |
|-----|-----------|---------------|----------|--------------|---------|
| 3 | Working Days per Month | 22 | [Input] | `=IF(C3="",B3,C3)` | D3 |
| 4 | Working Days per Year | 264 | [Input] | `=IF(C4="",B4,C4)` | D4 |
| 5 | Holding Cost % (Annual) | 25% | [Input] | `=IF(C5="",B5,C5)` | D5 |
| 6 | Default Order Cost ($) | 50 | [Input] | `=IF(C6="",B6,C6)` | D6 |
| 7 | Review Period (Days) | 7 | [Input] | `=IF(C7="",B7,C7)` | D7 |
| 8 | Lead Time Variability Factor | 0.2 | [Input] | `=IF(C8="",B8,C8)` | D8 |
| 9 | Minimum Safety Stock Days | 3 | [Input] | `=IF(C9="",B9,C9)` | D9 |
| 10 | Maximum Safety Stock Days | 60 | [Input] | `=IF(C10="",B10,C10)` | D10 |

### Service Level to Z-Score Lookup Table

| Service Level | Z-Score | Formula Reference |
|---------------|---------|-------------------|
| 90.0% | 1.28 | `=NORM.S.INV(A13)` |
| 92.0% | 1.41 | `=NORM.S.INV(A14)` |
| 95.0% | 1.65 | `=NORM.S.INV(A15)` |
| 97.0% | 1.88 | `=NORM.S.INV(A16)` |
| 98.0% | 2.05 | `=NORM.S.INV(A17)` |
| 99.0% | 2.33 | `=NORM.S.INV(A18)` |
| 99.5% | 2.58 | `=NORM.S.INV(A19)` |
| 99.9% | 3.09 | `=NORM.S.INV(A20)` |

---

# SHEET 3: ITEM_MASTER

## Item Configuration (50 Items)

### INPUT COLUMNS (Yellow Background)

| Col | Header | Validation | Example |
|-----|--------|------------|---------|
| A | **Item_Code** | Text, Required | SKU001 |
| B | **Description** | Text | Widget Assembly A |
| C | **Unit of Measure** | Dropdown: EA/CS/PL/KG/LB | EA |
| D | **Unit Cost ($)** | Number >0 | 25.50 |
| E | **Category** | Text | Raw Material |
| F | **Supplier** | Text | Supplier ABC |

### AUTO-CALCULATED COLUMNS (Gray Background)

| Col | Header | Formula |
|-----|--------|---------|
| G | Annual Demand (Units) | `=VLOOKUP(A3,Demand_Statistics!A:D,4,FALSE)` |
| H | Annual Demand ($) | `=G3*D3` |
| I | ABC Class | `=VLOOKUP(A3,ABC_XYZ!A:D,4,FALSE)` |
| J | XYZ Class | `=VLOOKUP(A3,ABC_XYZ!A:G,7,FALSE)` |
| K | Combined Class | `=I3&J3` |
| L | Demand Pattern | `=VLOOKUP(A3,Demand_Statistics!A:J,10,FALSE)` |

### Data Validation
- Unit Cost: Must be > 0
- Item_Code: Must be unique (use COUNTIF validation)

---

# SHEET 4: DEMAND_HISTORY

## 36-Month Demand History Input (50 Items × 36 Months)

### Structure

| Col | Header | Type |
|-----|--------|------|
| A | Item_Code | Link to Item_Master |
| B | Description | `=VLOOKUP(A3,Item_Master!A:B,2,FALSE)` |
| C | M-36 | **INPUT** (Yellow) |
| D | M-35 | **INPUT** (Yellow) |
| E | M-34 | **INPUT** (Yellow) |
| ... | ... | ... |
| AL | M-1 | **INPUT** (Yellow) |
| AM | Current Month | **INPUT** (Yellow) |

### Row Layout (Rows 3-52 for 50 items)
```
Row 1: Headers
Row 2: Month Labels (actual dates)
Rows 3-52: Item demand data (50 items)
Row 53: Column Totals
```

### Month Header Formula (Row 2)
```excel
C2 = DATE(YEAR(TODAY()),MONTH(TODAY())-36,1)
D2 = EDATE(C2,1)
... continues for 36 months
```

### Column Totals (Row 53)
```excel
C53 = SUM(C3:C52)
```

### Conditional Formatting
- Zero demand cells: Light orange (#FED7AA)
- Unusually high demand (>3× average): Bold red text
- Formula: `=C3>AVERAGE($C3:$AM3)*3`

---

# SHEET 5: LEAD_TIMES

## Lead Time Input (50 Items)

### INPUT COLUMNS (Yellow Background)

| Col | Header | Validation | Description |
|-----|--------|------------|-------------|
| A | Item_Code | Link | Item reference |
| B | Description | Auto | `=VLOOKUP(A3,Item_Master!A:B,2,FALSE)` |
| C | **Avg Lead Time (Days)** | Number 1-365 | Average supplier lead time |
| D | **Lead Time Variability** | Optional override | If blank, uses Settings default |

### AUTO-CALCULATED COLUMNS (Gray Background)

| Col | Header | Formula |
|-----|--------|---------|
| E | LT Std Dev (Days) | `=IF(D3="",C3*Settings!$D$8,D3*C3)` |
| F | LT in Months | `=C3/Settings!$D$3` |
| G | Min LT (Days) | `=MAX(1,C3-2*E3)` |
| H | Max LT (Days) | `=C3+2*E3` |
| I | LT Category | `=IF(C3<=7,"Short",IF(C3<=30,"Medium",IF(C3<=90,"Long","Very Long")))` |

### Lead Time Categories Reference
| Category | Days | Planning Implications |
|----------|------|----------------------|
| Short | ≤7 | Low safety stock needed |
| Medium | 8-30 | Moderate safety stock |
| Long | 31-90 | Higher safety stock, forecast accuracy critical |
| Very Long | >90 | Strategic stock, supplier collaboration required |

---

# SHEET 6: SERVICE_TARGETS

## Service Level Targets Input (50 Items)

### INPUT COLUMNS (Yellow Background)

| Col | Header | Validation | Description |
|-----|--------|------------|-------------|
| A | Item_Code | Link | Item reference |
| B | Description | Auto | `=VLOOKUP(A3,Item_Master!A:B,2,FALSE)` |
| C | **Target Service Level %** | 85%-99.9% | Fill rate target |

### AUTO-CALCULATED COLUMNS (Gray Background)

| Col | Header | Formula |
|-----|--------|---------|
| D | ABC Class | `=VLOOKUP(A3,ABC_XYZ!A:D,4,FALSE)` |
| E | Recommended SL | `=IF(D3="A",0.98,IF(D3="B",0.95,0.90))` |
| F | SL vs Recommended | `=C3-E3` |
| G | **Z-Score** | `=NORM.S.INV(C3)` |
| H | SL Category | `=IF(C3>=0.99,"Premium",IF(C3>=0.95,"High",IF(C3>=0.90,"Standard","Economy")))` |
| I | SS Impact | `=IF(C3>=0.99,"Very High",IF(C3>=0.97,"High",IF(C3>=0.95,"Moderate","Low")))` |

### Default Service Level Logic (if not specified)
```excel
Default_SL = IF(ABC_Class="A", 98%, IF(ABC_Class="B", 95%, 90%))
```

### Conditional Formatting
- SL below recommended: Orange background
- SL = 99%+: Blue background (premium)

---

# SHEET 7: DEMAND_STATISTICS

## Auto-Calculated Demand Analysis (All Formulas)

| Col | Header | Formula | Description |
|-----|--------|---------|-------------|
| A | Item_Code | `=Item_Master!A3` | Reference |
| B | Description | `=Item_Master!B3` | Reference |
| C | **Avg Monthly Demand** | `=AVERAGE(Demand_History!C3:AM3)` | Mean demand |
| D | **Annual Demand** | `=C3*12` | Annualized |
| E | **Std Dev (Monthly)** | `=STDEV.S(Demand_History!C3:AM3)` | Demand variability |
| F | **Variance** | `=VAR.S(Demand_History!C3:AM3)` | Variance |
| G | **CV (Coefficient of Variation)** | `=IF(C3>0,E3/C3,0)` | Relative variability |
| H | **Non-Zero Periods** | `=COUNTIF(Demand_History!C3:AM3,">0")` | Active months |
| I | **ADI (Avg Demand Interval)** | `=36/H3` | Intermittency measure |
| J | **Demand Pattern** | See formula below | Classification |
| K | **Avg Daily Demand** | `=C3/Settings!$D$3` | Daily rate |
| L | **Daily Std Dev** | `=E3/SQRT(Settings!$D$3)` | Daily variability |
| M | **Min Monthly** | `=MIN(Demand_History!C3:AM3)` | Lowest month |
| N | **Max Monthly** | `=MAX(Demand_History!C3:AM3)` | Highest month |
| O | **Range** | `=N3-M3` | Demand range |
| P | **Trend** | See formula below | Direction |
| Q | **Seasonality Index** | See formula below | Seasonal strength |

### Demand Pattern Classification Formula (Column J)
```excel
=IF(AND(G3<=0.5,I3<=1.32),"Smooth",
 IF(AND(G3>0.5,I3<=1.32),"Erratic",
 IF(AND(G3<=0.5,I3>1.32),"Intermittent",
 "Lumpy")))
```

### Trend Calculation (Column P)
```excel
=IF(SLOPE(Demand_History!C3:AM3,ROW(INDIRECT("1:36")))>0.05*C3,"Increasing",
 IF(SLOPE(Demand_History!C3:AM3,ROW(INDIRECT("1:36")))<-0.05*C3,"Decreasing",
 "Stable"))
```

### Seasonality Index (Column Q)
```excel
=STDEV.S(SUMPRODUCT((MOD(COLUMN(Demand_History!C3:AM3)-3,12)=0)*Demand_History!C3:AM3),
         SUMPRODUCT((MOD(COLUMN(Demand_History!C3:AM3)-3,12)=1)*Demand_History!C3:AM3),
         ...for all 12 months) / C3
```

Simplified version:
```excel
=MAX(Demand_History!C3:AM3)/AVERAGE(Demand_History!C3:AM3)-1
```

---

# SHEET 8: ABC_XYZ

## ABC-XYZ Classification (Auto-Calculated)

| Col | Header | Formula |
|-----|--------|---------|
| A | Item_Code | `=Item_Master!A3` |
| B | Description | `=Item_Master!B3` |
| C | Annual Value ($) | `=Demand_Statistics!D3*Item_Master!D3` |
| D | **ABC Class** | See formula below |
| E | Cumulative Value % | `=SUM($C$3:C3)/SUM($C$3:$C$52)` |
| F | CV | `=Demand_Statistics!G3` |
| G | **XYZ Class** | See formula below |
| H | **Combined Class** | `=D3&G3` |
| I | Planning Priority | See formula below |
| J | Review Frequency | See formula below |
| K | Forecast Method | See formula below |

### ABC Classification Formula (Column D)
```excel
=IF(E3<=0.8,"A",IF(E3<=0.95,"B","C"))
```
*Note: Data must be sorted by Annual Value descending for cumulative % to work*

### Alternative ABC Formula (works without sorting)
```excel
=IF(C3>=PERCENTILE(C$3:C$52,0.8),"A",
 IF(C3>=PERCENTILE(C$3:C$52,0.5),"B","C"))
```

### XYZ Classification Formula (Column G)
```excel
=IF(F3<=0.5,"X",IF(F3<=1,"Y","Z"))
```

### Planning Priority (Column I)
```excel
=IF(OR(H3="AX",H3="AY",H3="BX"),"High",
 IF(OR(H3="AZ",H3="BY",H3="CX"),"Medium","Low"))
```

### Review Frequency (Column J)
```excel
=IF(I3="High","Weekly",IF(I3="Medium","Bi-Weekly","Monthly"))
```

### Forecast Method Recommendation (Column K)
```excel
=IF(Demand_Statistics!J3="Smooth","Moving Average/Exponential Smoothing",
 IF(Demand_Statistics!J3="Erratic","Weighted Average with Dampening",
 IF(Demand_Statistics!J3="Intermittent","Croston's Method",
 "Croston's or Manual Review")))
```

---

# SHEET 9: OPTIMIZATION

## Core Optimization Calculations (All Auto-Calculated)

| Col | Header | Formula | Description |
|-----|--------|---------|-------------|
| A | Item_Code | `=Item_Master!A3` | Reference |
| B | Description | `=Item_Master!B3` | Reference |
| C | Avg Daily Demand | `=Demand_Statistics!K3` | Units/day |
| D | Daily Demand Std Dev | `=Demand_Statistics!L3` | Variability |
| E | Lead Time (Days) | `=Lead_Times!C3` | Avg LT |
| F | Lead Time Std Dev | `=Lead_Times!E3` | LT variability |
| G | Z-Score | `=Service_Targets!G3` | Service factor |
| H | Demand During LT | `=C3*E3` | Expected demand in LT |
| I | **Combined Std Dev** | See formula below | Total variability |
| J | **Safety Stock (Units)** | `=ROUND(G3*I3,0)` | Recommended SS |
| K | **Safety Stock (Days)** | `=IF(C3>0,J3/C3,0)` | Days of supply |
| L | **Reorder Point (Units)** | `=ROUND(H3+J3,0)` | When to order |
| M | **EOQ (Units)** | See formula below | Economic order qty |
| N | **Order Quantity (Rounded)** | See formula below | Practical EOQ |
| O | Cycle Stock (Units) | `=N3/2` | Avg cycle inventory |
| P | Total Avg Inventory | `=J3+O3` | SS + Cycle |
| Q | **Inventory Status** | See formula below | Review flag |
| R | Annual Turns | `=IF(P3>0,Demand_Statistics!D3/P3,0)` | Inventory velocity |
| S | Days of Supply | `=IF(C3>0,P3/C3,0)` | Total DOS |

### Combined Standard Deviation Formula (Column I)
```excel
=SQRT((E3*D3^2)+(C3^2*F3^2))
```
*This is the standard formula combining demand and lead time variability*

### EOQ Formula (Column M)
```excel
=SQRT((2*Demand_Statistics!D3*Settings!$D$6)/(Item_Master!D3*Settings!$D$5))
```

### Rounded Order Quantity (Column N)
```excel
=MAX(1,MROUND(M3,CHOOSE(MATCH(M3,{0,10,100,1000},1),1,5,10,50)))
```
*Rounds to practical increments: 1s for <10, 5s for 10-99, 10s for 100-999, 50s for 1000+*

### Inventory Status Formula (Column Q)
```excel
=IF(K3>Settings!$D$10,"Review - SS Too High",
 IF(K3<Settings!$D$9,"Review - SS Too Low",
 IF(Demand_Statistics!J3="Lumpy","Review - Lumpy Demand",
 "OK")))
```

---

# SHEET 10: POLICY_RECOMMENDATIONS

## Inventory Policy Summary (Auto-Generated)

| Col | Header | Formula |
|-----|--------|---------|
| A | Item_Code | `=Item_Master!A3` |
| B | Description | `=Item_Master!B3` |
| C | Combined Class | `=ABC_XYZ!H3` |
| D | Demand Pattern | `=Demand_Statistics!J3` |
| E | **Recommended Policy** | See formula below |
| F | **Review Period** | See formula below |
| G | **Min Stock (Units)** | `=Optimization!L3` |
| H | **Max Stock (Units)** | `=G3+Optimization!N3` |
| I | **Safety Stock** | `=Optimization!J3` |
| J | **Order Quantity** | `=Optimization!N3` |
| K | **Reorder Point** | `=Optimization!L3` |
| L | Annual Inventory Cost ($) | `=Optimization!P3*Item_Master!D3*Settings!$D$5` |
| M | Annual Order Cost ($) | `=(Demand_Statistics!D3/Optimization!N3)*Settings!$D$6` |
| N | **Total Annual Cost ($)** | `=L3+M3` |
| O | Supplier Strategy | See formula below |
| P | Special Handling | See formula below |

### Recommended Policy Formula (Column E)
```excel
=IF(OR(C3="AX",C3="BX"),"Continuous Review (s,Q)",
 IF(OR(C3="AY",C3="BY",C3="CX"),"Periodic Review (R,S)",
 IF(OR(C3="AZ",C3="BZ"),"Min-Max with Safety",
 "Periodic Review - Simple")))
```

### Review Period Formula (Column F)
```excel
=IF(OR(C3="AX",C3="AY",C3="BX"),"Weekly",
 IF(OR(C3="AZ",C3="BY",C3="CX"),"Bi-Weekly",
 "Monthly"))
```

### Supplier Strategy Formula (Column O)
```excel
=IF(Lead_Times!I3="Very Long","Strategic Partnership - VMI",
 IF(Lead_Times!I3="Long","Blanket Order with Releases",
 IF(ABC_XYZ!D3="A","Preferred Supplier Agreement",
 "Standard Ordering")))
```

### Special Handling Formula (Column P)
```excel
=IF(Demand_Statistics!J3="Lumpy","Manual Review Required",
 IF(Demand_Statistics!J3="Intermittent","Consider Min/Max Policy",
 IF(AND(ABC_XYZ!D3="C",Demand_Statistics!P3="Decreasing"),"Phase-Out Candidate",
 "Standard Management")))
```

---

# SHEET 11: SIMULATION

## What-If Analysis for Service Level Trade-offs

### Simulation Table (One row per item)

| Col | Header | Formula |
|-----|--------|---------|
| A | Item_Code | `=Item_Master!A3` |
| B | Current SL | `=Service_Targets!C3` |
| C | Current SS (Units) | `=Optimization!J3` |
| D | Current SS ($) | `=C3*Item_Master!D3` |
| E | **SL @ 90%** | `=ROUND(NORM.S.INV(0.9)*Optimization!I3,0)` |
| F | **SL @ 95%** | `=ROUND(NORM.S.INV(0.95)*Optimization!I3,0)` |
| G | **SL @ 97%** | `=ROUND(NORM.S.INV(0.97)*Optimization!I3,0)` |
| H | **SL @ 99%** | `=ROUND(NORM.S.INV(0.99)*Optimization!I3,0)` |
| I | Cost @ 90% ($) | `=E3*Item_Master!D3` |
| J | Cost @ 95% ($) | `=F3*Item_Master!D3` |
| K | Cost @ 97% ($) | `=G3*Item_Master!D3` |
| L | Cost @ 99% ($) | `=H3*Item_Master!D3` |
| M | Cost Increase 95→99 | `=L3-J3` |
| N | % Increase | `=M3/J3` |

### Summary Row (Row 53)
```excel
Total SS @ 90%: =SUM(E3:E52)
Total SS @ 95%: =SUM(F3:F52)
Total SS @ 97%: =SUM(G3:G52)
Total SS @ 99%: =SUM(H3:H52)

Total Cost @ 90%: =SUM(I3:I52)
Total Cost @ 95%: =SUM(J3:J52)
Total Cost @ 97%: =SUM(K3:K52)
Total Cost @ 99%: =SUM(L3:L52)
```

---

# SHEET 12: ALERTS

## Exception Management (Auto-Generated)

### Alert Criteria and Formulas

| Col | Header | Formula |
|-----|--------|---------|
| A | Item_Code | Filtered list |
| B | Description | VLOOKUP |
| C | Alert Type | See categories below |
| D | Alert Description | Generated text |
| E | Severity | High/Medium/Low |
| F | Recommended Action | Auto-generated |
| G | Current Value | Metric value |
| H | Threshold | Comparison value |

### Alert Generation Formulas

**High Variability Alert:**
```excel
=IF(Demand_Statistics!G3>1.5,
    "HIGH VARIABILITY: CV = "&TEXT(Demand_Statistics!G3,"0.00")&" exceeds 1.5 threshold",
    "")
```

**Excessive Safety Stock Alert:**
```excel
=IF(Optimization!K3>Settings!$D$10,
    "EXCESSIVE SS: "&Optimization!K3&" days exceeds "&Settings!$D$10&" day maximum",
    "")
```

**Insufficient Safety Stock Alert:**
```excel
=IF(Optimization!K3<Settings!$D$9,
    "LOW SS: "&Optimization!K3&" days below "&Settings!$D$9&" day minimum",
    "")
```

**Declining Demand Alert:**
```excel
=IF(AND(Demand_Statistics!P3="Decreasing",ABC_XYZ!D3="C"),
    "PHASE-OUT CANDIDATE: Declining C-class item",
    "")
```

**Lumpy Demand Alert:**
```excel
=IF(Demand_Statistics!J3="Lumpy",
    "LUMPY DEMAND: Standard formulas may not apply - manual review needed",
    "")
```

---

# SHEET 13: DATA_VALIDATION

## Data Quality Checks

| Check | Formula | Status |
|-------|---------|--------|
| All Items Have Cost | `=COUNTBLANK(Item_Master!D3:D52)=0` | TRUE/FALSE |
| All Items Have Lead Time | `=COUNTBLANK(Lead_Times!C3:C52)=0` | TRUE/FALSE |
| All Items Have Service Target | `=COUNTBLANK(Service_Targets!C3:C52)=0` | TRUE/FALSE |
| No Negative Demand | `=COUNTIF(Demand_History!C3:AM52,"<0")=0` | TRUE/FALSE |
| Items with No Demand History | `=SUMPRODUCT((COUNTIF(OFFSET(Demand_History!C3,ROW(1:50)-1,0,1,36),">0")=0)*1)` | Count |
| Lead Times Within Range | `=COUNTIFS(Lead_Times!C3:C52,"<1")+COUNTIFS(Lead_Times!C3:C52,">365")` | Count errors |
| Service Levels Valid | `=COUNTIFS(Service_Targets!C3:C52,"<0.85")+COUNTIFS(Service_Targets!C3:C52,">0.999")` | Count errors |
| Overall Data Quality | `=IF(AND(B3:B9),"PASS","REVIEW REQUIRED")` | Status |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| Items | Item_Master!A3:A52 | Item list |
| Item_Costs | Item_Master!D3:D52 | Unit costs |
| Demand_Avg | Demand_Statistics!C3:C52 | Average demands |
| Demand_StdDev | Demand_Statistics!E3:E52 | Demand variability |
| Lead_Times_Avg | Lead_Times!C3:C52 | Lead times |
| Service_Levels | Service_Targets!C3:C52 | Target SL |
| Z_Scores | Service_Targets!G3:G52 | Z values |
| Safety_Stock | Optimization!J3:J52 | SS units |
| Reorder_Points | Optimization!L3:L52 | ROP units |
| EOQ_Values | Optimization!N3:N52 | Order quantities |
| ABC_Classes | ABC_XYZ!D3:D52 | ABC classification |
| XYZ_Classes | ABC_XYZ!G3:G52 | XYZ classification |
| Working_Days_Month | Settings!D3 | Days per month |
| Holding_Cost_Pct | Settings!D5 | Annual holding % |
| Order_Cost | Settings!D6 | Cost per order |

---

# VBA AUTOMATION

```vba
Option Explicit

'====================================
' MAIN REFRESH PROCEDURE
'====================================
Sub RefreshAllCalculations()
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' Validate data first
    If Not ValidateInputData() Then
        MsgBox "Data validation failed. Please review the Data_Validation sheet.", vbExclamation
        Application.ScreenUpdating = True
        Exit Sub
    End If

    ' Recalculate all sheets in order
    ThisWorkbook.Sheets("Demand_Statistics").Calculate
    ThisWorkbook.Sheets("ABC_XYZ").Calculate
    ThisWorkbook.Sheets("Optimization").Calculate
    ThisWorkbook.Sheets("Policy_Recommendations").Calculate
    ThisWorkbook.Sheets("Simulation").Calculate
    ThisWorkbook.Sheets("Alerts").Calculate
    ThisWorkbook.Sheets("Dashboard").Calculate

    ' Update timestamp
    ThisWorkbook.Sheets("Dashboard").Range("J2").Value = Now

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    ' Show summary
    Dim ss_total As Double
    Dim items_review As Long

    ss_total = Application.WorksheetFunction.Sum(Range("Safety_Stock"))
    items_review = Application.WorksheetFunction.CountIf( _
        ThisWorkbook.Sheets("Optimization").Range("Q3:Q52"), "*Review*")

    MsgBox "Optimization Complete!" & vbCrLf & vbCrLf & _
           "Total Safety Stock: " & Format(ss_total, "#,##0") & " units" & vbCrLf & _
           "Items Requiring Review: " & items_review, vbInformation, "Inventory Optimization"
End Sub

'====================================
' DATA VALIDATION
'====================================
Function ValidateInputData() As Boolean
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Data_Validation")

    ws.Calculate

    ' Check critical validations
    If ws.Range("B3").Value = False Then
        ValidateInputData = False
        Exit Function
    End If

    If ws.Range("B4").Value = False Then
        ValidateInputData = False
        Exit Function
    End If

    ValidateInputData = True
End Function

'====================================
' EXPORT RESULTS
'====================================
Sub ExportOptimizationResults()
    Dim newWb As Workbook
    Dim ws As Worksheet

    Set newWb = Workbooks.Add

    ' Export Optimization sheet
    ThisWorkbook.Sheets("Optimization").UsedRange.Copy
    newWb.Sheets(1).Range("A1").PasteSpecial xlPasteValues
    newWb.Sheets(1).Range("A1").PasteSpecial xlPasteFormats
    newWb.Sheets(1).Name = "Safety_Stock_Results"

    ' Export Policy Recommendations
    ThisWorkbook.Sheets("Policy_Recommendations").UsedRange.Copy
    Set ws = newWb.Sheets.Add(After:=newWb.Sheets(1))
    ws.Range("A1").PasteSpecial xlPasteValues
    ws.Range("A1").PasteSpecial xlPasteFormats
    ws.Name = "Policy_Recommendations"

    ' Export Alerts
    ThisWorkbook.Sheets("Alerts").UsedRange.Copy
    Set ws = newWb.Sheets.Add(After:=newWb.Sheets(2))
    ws.Range("A1").PasteSpecial xlPasteValues
    ws.Range("A1").PasteSpecial xlPasteFormats
    ws.Name = "Alerts"

    Application.CutCopyMode = False

    ' Save
    Dim fileName As String
    fileName = "Inventory_Optimization_Results_" & Format(Date, "YYYYMMDD") & ".xlsx"

    newWb.SaveAs fileName

    MsgBox "Results exported to: " & fileName, vbInformation
End Sub

'====================================
' WHAT-IF ANALYSIS
'====================================
Sub RunServiceLevelScenario()
    Dim targetSL As Double
    Dim response As String

    response = InputBox("Enter target service level (e.g., 0.95 for 95%):", _
                        "Service Level Scenario", "0.95")

    If response = "" Then Exit Sub

    targetSL = CDbl(response)

    If targetSL < 0.85 Or targetSL > 0.999 Then
        MsgBox "Service level must be between 85% and 99.9%", vbExclamation
        Exit Sub
    End If

    Dim z_score As Double
    z_score = Application.WorksheetFunction.Norm_S_Inv(targetSL)

    Dim totalSS As Double
    Dim totalCost As Double
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Optimization")

    Dim i As Long
    For i = 3 To 52
        Dim combinedStdDev As Double
        combinedStdDev = ws.Cells(i, 9).Value ' Column I

        Dim itemSS As Double
        itemSS = z_score * combinedStdDev

        Dim itemCost As Double
        itemCost = itemSS * ThisWorkbook.Sheets("Item_Master").Cells(i, 4).Value

        totalSS = totalSS + itemSS
        totalCost = totalCost + itemCost
    Next i

    MsgBox "Scenario Results for " & Format(targetSL, "0.0%") & " Service Level:" & vbCrLf & vbCrLf & _
           "Total Safety Stock: " & Format(totalSS, "#,##0") & " units" & vbCrLf & _
           "Total SS Value: " & Format(totalCost, "$#,##0") & vbCrLf & _
           "Z-Score Used: " & Format(z_score, "0.00"), vbInformation, "What-If Analysis"
End Sub

'====================================
' GENERATE ITEM TEMPLATE
'====================================
Sub GenerateItemTemplate()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Item_Master")

    Dim i As Long
    For i = 3 To 52
        If ws.Cells(i, 1).Value = "" Then
            ws.Cells(i, 1).Value = "SKU" & Format(i - 2, "000")
            ws.Cells(i, 2).Value = "Item " & (i - 2) & " Description"
            ws.Cells(i, 3).Value = "EA"
            ws.Cells(i, 4).Value = 10 ' Default cost
        End If
    Next i

    ' Set default lead times
    Set ws = ThisWorkbook.Sheets("Lead_Times")
    For i = 3 To 52
        If ws.Cells(i, 3).Value = "" Then
            ws.Cells(i, 3).Value = 14 ' Default 14 days
        End If
    Next i

    ' Set default service levels
    Set ws = ThisWorkbook.Sheets("Service_Targets")
    For i = 3 To 52
        If ws.Cells(i, 3).Value = "" Then
            ws.Cells(i, 3).Value = 0.95 ' Default 95%
        End If
    Next i

    MsgBox "Template generated with 50 placeholder items." & vbCrLf & _
           "Please update with your actual data.", vbInformation
End Sub

'====================================
' HIGHLIGHT INPUT CELLS
'====================================
Sub HighlightInputCells()
    Dim inputColor As Long
    inputColor = RGB(254, 249, 195) ' Light yellow

    ' Item Master inputs
    With ThisWorkbook.Sheets("Item_Master")
        .Range("A3:F52").Interior.Color = inputColor
    End With

    ' Demand History inputs
    With ThisWorkbook.Sheets("Demand_History")
        .Range("C3:AM52").Interior.Color = inputColor
    End With

    ' Lead Times inputs
    With ThisWorkbook.Sheets("Lead_Times")
        .Range("C3:D52").Interior.Color = inputColor
    End With

    ' Service Targets inputs
    With ThisWorkbook.Sheets("Service_Targets")
        .Range("C3:C52").Interior.Color = inputColor
    End With

    MsgBox "Input cells highlighted in yellow.", vbInformation
End Sub

'====================================
' CLEAR ALL DATA
'====================================
Sub ClearAllInputData()
    Dim response As VbMsgBoxResult
    response = MsgBox("This will clear ALL input data. Are you sure?", _
                      vbYesNo + vbExclamation, "Confirm Clear")

    If response = vbNo Then Exit Sub

    ' Clear Item Master (except headers)
    ThisWorkbook.Sheets("Item_Master").Range("A3:F52").ClearContents

    ' Clear Demand History
    ThisWorkbook.Sheets("Demand_History").Range("A3:AM52").ClearContents

    ' Clear Lead Times
    ThisWorkbook.Sheets("Lead_Times").Range("C3:D52").ClearContents

    ' Clear Service Targets
    ThisWorkbook.Sheets("Service_Targets").Range("C3:C52").ClearContents

    MsgBox "All input data cleared.", vbInformation
End Sub

'====================================
' AUTO-RUN ON OPEN
'====================================
Private Sub Workbook_Open()
    ' Validate data on open
    ThisWorkbook.Sheets("Data_Validation").Calculate

    If ThisWorkbook.Sheets("Data_Validation").Range("B10").Value = "REVIEW REQUIRED" Then
        MsgBox "Data validation issues detected. Please review the Data_Validation sheet.", _
               vbExclamation, "Data Quality Alert"
    End If
End Sub
```

---

# QUICK START GUIDE

## Step 1: Enter Item Master Data
1. Go to **Item_Master** sheet
2. Enter Item_Code, Description, Unit of Measure, and **Unit Cost** for up to 50 items
3. Category and Supplier are optional

## Step 2: Enter Demand History
1. Go to **Demand_History** sheet
2. Enter monthly demand for each item (36 months recommended, minimum 12)
3. Use 0 for months with no demand (not blank)

## Step 3: Enter Lead Times
1. Go to **Lead_Times** sheet
2. Enter **Avg Lead Time (Days)** for each item
3. Optionally override Lead Time Variability factor

## Step 4: Enter Service Targets
1. Go to **Service_Targets** sheet
2. Enter **Target Service Level %** (e.g., 0.95 for 95%)
3. Use values between 0.85 and 0.999

## Step 5: Refresh Calculations
1. Press **Ctrl+Shift+R** or run `RefreshAllCalculations` macro
2. Review **Dashboard** for summary
3. Check **Alerts** sheet for exceptions
4. Review **Optimization** sheet for detailed results

---

# OUTPUT SUMMARY

After entering inputs, the model automatically calculates:

| Output | Sheet | Description |
|--------|-------|-------------|
| Safety Stock (Units) | Optimization!J | Recommended buffer inventory |
| Safety Stock (Days) | Optimization!K | Days of supply coverage |
| Reorder Point | Optimization!L | When to trigger replenishment |
| EOQ | Optimization!N | Economic order quantity |
| ABC Classification | ABC_XYZ!D | Value-based segmentation |
| XYZ Classification | ABC_XYZ!G | Variability segmentation |
| Demand Pattern | Demand_Statistics!J | Smooth/Erratic/Intermittent/Lumpy |
| Inventory Policy | Policy_Recommendations!E | Recommended approach |
| Review Frequency | Policy_Recommendations!F | How often to review |
| Total Inventory Cost | Policy_Recommendations!N | Annual carrying + ordering cost |
| Service Level Scenarios | Simulation | What-if for different SL targets |

---

*Complete inventory optimization model with automatic statistical calculations for 50 SKUs.*
