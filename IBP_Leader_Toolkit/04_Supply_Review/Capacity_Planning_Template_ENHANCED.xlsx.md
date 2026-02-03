# Capacity Planning Template - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Capacity_Master
### Sheet 3: Demand_Load
### Sheet 4: Utilization_Analysis
### Sheet 5: Bottleneck_Analysis
### Sheet 6: Scenario_Planner
### Sheet 7: Investment_Options
### Sheet 8: Settings

---

## SHEET 1: DASHBOARD

### Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "CAPACITY PLANNING DASHBOARD" (Steel #37474F)                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:F12  CAPACITY SUMMARY          │ H3:P12  UTILIZATION BY FACILITY        │
│ ┌─────────────────────────────┐   │ ┌─────────────────────────────────┐    │
│ │ Total Capacity: 500K units  │   │ │ [Horizontal bar chart]          │    │
│ │ Current Load: 420K (84%)    │   │ │ Plant A  ████████████░░░ 84%   │    │
│ │ Available: 80K units        │   │ │ Plant B  ██████████░░░░░ 78%   │    │
│ │ Bottleneck: Plant C Q3      │   │ │ Plant C  █████████████████ 96% │    │
│ │ Peak Utilization: 96%       │   │ │                                 │    │
│ └─────────────────────────────┘   │ └─────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────────────────────┤
│ A14:P28  18-MONTH CAPACITY vs DEMAND TREND                                 │
│ [Area chart: Capacity ceiling, demand load, optimal zone 80-85%]           │
├─────────────────────────────────────────────────────────────────────────────┤
│ A30:H40  CONSTRAINT ALERTS        │ J30:P40  SCENARIO COMPARISON           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard KPI Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=SUM(Capacity_Master!$E$3:$E$50)` | Total capacity |
| C5 | `=SUM(Demand_Load!$D$3:$D$500)` | Current load |
| C6 | `=C5/C4` | Utilization % |
| C7 | `=C4-C5` | Available capacity |
| C8 | `=INDEX(Bottleneck_Analysis!$A$3:$A$20,MATCH(MAX(Bottleneck_Analysis!$F$3:$F$20),Bottleneck_Analysis!$F$3:$F$20,0))` | Top bottleneck |
| C9 | `=MAX(Utilization_Analysis!$E$3:$E$50)` | Peak utilization |

### Conditional Formatting
```
Utilization (C6):
- 80-85%: Green (#C8E6C9) "Optimal"
- 75-79% or 86-90%: Yellow (#FFF9C4) "Watch"
- <75%: Blue (#BBDEFB) "Underutilized"
- >90%: Red (#FFCDD2) "Constrained"
```

---

## SHEET 2: Capacity_Master

### Column Structure
| Col | Header | Format | Description |
|-----|--------|--------|-------------|
| A | Facility_ID | Text | Plant identifier |
| B | Facility_Name | Text | Location name |
| C | Resource_Type | Dropdown | Equipment/Labor/Space |
| D | Work_Center | Text | Specific work center |
| E | Theoretical_Capacity | Number | Maximum output |
| F | Efficiency_Factor | Percentage | OEE or efficiency |
| G | Demonstrated_Capacity | =E*F | Realistic capacity |
| H | Unit_of_Measure | Dropdown | Units/Hours/Tons |
| I | Shift_Pattern | Dropdown | 1/2/3 shifts |
| J | Days_Per_Week | Number | Operating days |
| K | Weekly_Capacity | =G*(J/5) | Weekly output |
| L | Monthly_Capacity | =K*4.33 | Monthly output |
| M | Quarterly_Capacity | =L*3 | Quarterly output |
| N | Cost_Per_Unit | Currency | Variable cost |
| O | Fixed_Cost_Monthly | Currency | Fixed overhead |
| P | Expansion_Potential | Percentage | Available upside |
| Q | Expansion_Cost | Currency | Cost to expand |
| R | Lead_Time_Weeks | Number | Expansion lead time |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| G3 | `=E3*F3` | Demonstrated capacity |
| K3 | `=G3*(J3/5)` | Weekly capacity adjusted for days |
| L3 | `=K3*4.33` | Monthly capacity |
| P3 (Expansion Hours) | `=E3*Settings!$B$15-G3` | Available expansion |

### Data Validation
```
Column C (Resource_Type):
="Equipment,Labor,Space,Material,Other"

Column I (Shift_Pattern):
="1 Shift,2 Shifts,3 Shifts,24/7"

Efficiency_Factor (F):
- Between 0.5 and 1.0
- Warning if < 0.7
```

---

## SHEET 3: Demand_Load

### Column Structure
| Col | Header | Formula/Description |
|-----|--------|---------------------|
| A | Month | Planning period |
| B | Product_Family | Product grouping |
| C | Facility_ID | Manufacturing location |
| D | Demand_Units | From Consensus Demand |
| E | Hours_Required | =D*VLOOKUP(B,Routing,3,FALSE) |
| F | Facility_Capacity | =VLOOKUP(C,Capacity_Master!A:L,12,FALSE) |
| G | Utilization_Pct | =E/F |
| H | Over_Under | =F-E |
| I | Status | =IF(G>0.9,"⚠ HIGH",IF(G>0.85,"WATCH",IF(G<0.75,"LOW","OK"))) |

### Load Summary by Facility
```
Pivot Structure:
Rows: Facility_ID
Columns: Month (next 18)
Values: Sum of Demand_Units

Total_Load_Q1: =SUMIFS($D:$D,$A:$A,">="&Q1_Start,$A:$A,"<="&Q1_End,$C:$C,Facility)
```

### Routing Table (Linked)
| Product_Family | Facility | Hours_Per_Unit | Setup_Hours |
|----------------|----------|----------------|-------------|
| Family_A | Plant_A | 0.5 | 2 |
| Family_B | Plant_A | 0.8 | 4 |
| Family_A | Plant_B | 0.6 | 3 |

---

## SHEET 4: Utilization_Analysis

### By Facility/Month Matrix
```
         Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
Plant_A  84%   87%   92%   88%   85%   82%   78%   75%   80%   85%   88%   82%
Plant_B  78%   82%   85%   80%   78%   75%   72%   70%   75%   80%   82%   78%
Plant_C  96%   98%   94%   90%   88%   85%   82%   80%   85%   90%   92%   88%
```

### Utilization Formulas
```
Cell B3:
=SUMIFS(Demand_Load!$E:$E,Demand_Load!$A:$A,B$2,Demand_Load!$C:$C,$A3)/
 VLOOKUP($A3,Capacity_Master!$A:$L,12,FALSE)

Conditional Formatting:
- 80-85%: Green fill
- 75-80% or 85-90%: Yellow fill
- <75%: Blue fill
- >90%: Red fill
```

### Utilization Statistics
```
Average Utilization: =AVERAGE(B3:M10)
Peak Utilization: =MAX(B3:M10)
Lowest Utilization: =MIN(B3:M10)
Std Deviation: =STDEV(B3:M10)
Months Over 90%: =COUNTIF(B3:M10,">0.9")
```

---

## SHEET 5: Bottleneck_Analysis

### Bottleneck Identification
| Col | Header | Formula |
|-----|--------|---------|
| A | Facility | From Capacity_Master |
| B | Resource | Work center |
| C | Month | Peak period |
| D | Demand | Required load |
| E | Capacity | Available |
| F | Gap | =D-E |
| G | Gap_Pct | =F/E |
| H | Revenue_At_Risk | =F*Avg_Price |
| I | Priority | =RANK(H,$H:$H,0) |
| J | Resolution_Options | Text |

### Bottleneck Detection Formula
```
Is_Bottleneck (K3):
=IF(AND(G3>0,G3>=LARGE($G$3:$G$50,3)),"PRIMARY",
  IF(G3>0,"SECONDARY",""))

Severity Score (L3):
=G3*VLOOKUP(A3,Facility_Priority,2,FALSE)*IF(C3<=TODAY()+90,2,1)
```

### Impact Analysis
```
Total Revenue at Risk: =SUMIF(K:K,"PRIMARY",H:H)
Affected Customers: =SUMPRODUCT((K3:K50="PRIMARY")*(CustomerCount))
Service Level Impact: =Bottleneck_Units/Total_Demand
```

---

## SHEET 6: Scenario_Planner

### Scenario Definition
| Scenario | Description | Demand_Factor | Capacity_Factor |
|----------|-------------|---------------|-----------------|
| Base | Current plan | 1.00 | 1.00 |
| Upside | High demand | 1.15 | 1.00 |
| Downside | Low demand | 0.85 | 1.00 |
| Expansion | Add capacity | 1.00 | 1.15 |
| Constraint | Supply issue | 1.00 | 0.90 |

### Scenario Results Matrix
```
              Base    Upside   Downside  Expansion  Constraint
Utilization   84%     97%      71%       73%        93%
Bottlenecks   1       4        0         0          3
Revenue Gap   $0      $4.2M    $0        $0         $2.8M
Service Risk  Low     High     None      None       Medium
Invest Req    $0      $1.5M    $0        $1.5M      $0
```

### Scenario Calculation
```
Scenario_Utilization (C3):
=SUMPRODUCT(Demand_Load!$D:$D,Scenarios!C$1)/SUMPRODUCT(Capacity_Master!$L:$L,Scenarios!D$1)

Revenue_Gap (C5):
=MAX(0,(SUMPRODUCT(Demand_Load!$D:$D,Scenarios!C$1)-SUMPRODUCT(Capacity_Master!$L:$L,Scenarios!D$1))*Avg_Price)
```

---

## SHEET 7: Investment_Options

### Capital Investment Analysis
| Option_ID | Description | CapEx | Lead_Time | Capacity_Add | Annual_Savings | NPV | IRR | Payback |
|-----------|-------------|-------|-----------|--------------|----------------|-----|-----|---------|
| OPT-001 | New Line Plant A | $1.5M | 12 mo | +50K units | $400K | =NPV() | =IRR() | =Payback() |
| OPT-002 | Outsource 3PL | $0 | 2 mo | +30K units | -$200K | | | |
| OPT-003 | OT Authorization | $0 | 0 | +15K units | -$150K | | | |
| OPT-004 | Efficiency Improve | $200K | 6 mo | +20K units | $100K | | | |

### Financial Formulas
```
NPV (G3):
=-C3+NPV(Settings!$B$20,F3,F3*1.02,F3*1.04,F3*1.05,F3*1.05)

IRR (H3):
=IRR({-C3,F3,F3*1.02,F3*1.04,F3*1.05,F3*1.05})

Payback (I3):
=C3/F3

ROI (J3):
=(F3*5-C3)/C3
```

### Recommendation Logic
```
Recommended (K3):
=IF(AND(H3>Settings!$B$21,I3<Settings!$B$22),"RECOMMEND",
  IF(OR(H3>Settings!$B$21,I3<Settings!$B$22),"CONSIDER","REJECT"))
```

---

## SHEET 8: Settings

### Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Planning_Horizon | 18 | Months forward |
| Optimal_Util_Low | 0.80 | 80% lower bound |
| Optimal_Util_High | 0.85 | 85% upper bound |
| Constraint_Threshold | 0.90 | 90% = constrained |
| OT_Premium | 1.5 | Overtime multiplier |
| Outsource_Premium | 1.25 | 3PL cost premium |
| Hurdle_Rate | 0.15 | 15% IRR minimum |
| Max_Payback_Years | 3 | Payback threshold |
| Buffer_Capacity | 0.05 | 5% safety buffer |

### Facility Priority Weights
| Facility | Priority_Weight | Strategic_Score |
|----------|-----------------|-----------------|
| Plant_A | 1.0 | 85 |
| Plant_B | 0.9 | 75 |
| Plant_C | 1.2 | 90 |

---

## INTEGRATION POINTS

```
1. Consensus_Demand_Workbook.xlsx
   - Pull: Demand plan by family/month
   - Validate: Capacity feasibility

2. Supply_Constraints_Log.xlsx
   - Push: Identified constraints
   - Track: Resolution status

3. Financial_Review_Rolling_Forecast.xlsx
   - Push: Capacity investment needs
   - Link: CapEx requirements

4. Scenario_Planning_Matrix.xlsx
   - Share: Scenario definitions
   - Sync: Impact calculations

5. Executive_Dashboard.xlsx
   - Push: Utilization KPIs
   - Push: Constraint alerts
```

---

## KEY FORMULAS SUMMARY

### Utilization
```excel
=Demand_Hours/Available_Capacity
```

### Rough-Cut Capacity
```excel
=Demand_Units*Hours_Per_Unit/Available_Hours
```

### Bottleneck Identification
```excel
=IF(Utilization>Threshold,"Bottleneck","OK")
```

### NPV for Investment
```excel
=-Initial_Investment+NPV(Discount_Rate,CF1,CF2,CF3,CF4,CF5)
```

---

**Template Version:** Enhanced Capacity Planning 2.0
**Refresh Frequency:** Weekly (before Supply Review)
