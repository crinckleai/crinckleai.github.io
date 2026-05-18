# Plan vs Actual Analysis - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Monthly_PvA
### Sheet 3: Revenue_Bridge
### Sheet 4: Margin_Analysis
### Sheet 5: Variance_Drivers
### Sheet 6: Rolling_Forecast
### Sheet 7: Data_Import
### Sheet 8: Settings

---

## SHEET 1: DASHBOARD

### Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "PLAN vs ACTUAL DASHBOARD" (Navy #1A237E)                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:G14  P&L SUMMARY               │ I3:P14  VARIANCE TREND (12-Month)      │
│ ┌─────────────────────────────┐   │ ┌─────────────────────────────────┐    │
│ │           Act    Plan   Var │   │ │ [Line chart: Actual vs Plan]    │    │
│ │ Revenue   128M   125M  +2.4%│   │ │ with variance bars below        │    │
│ │ Gross Prft 44M   42M  +4.8%│   │ │                                 │    │
│ │ Margin%   34.2%  33.5% +0.7%│   │ │                                 │    │
│ │ OpEx      25M    26M  -3.8%│   │ │                                 │    │
│ │ EBITDA    19M    16M  +18.8%│   │ │                                 │    │
│ └─────────────────────────────┘   │ └─────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────────────────────┤
│ A16:P28  REVENUE WATERFALL (Budget → Actual)                               │
│ [Waterfall chart: Budget + Volume + Price + Mix + FX + Other = Actual]     │
├─────────────────────────────────────────────────────────────────────────────┤
│ A30:G42  TOP VARIANCES            │ I30:P42  YTD PROGRESS TRACKER          │
│ (Ranked by absolute impact)       │ (Actual vs Plan with full-year outlook)│
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard KPI Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| D5 | `=Monthly_PvA!B3` | Revenue actual |
| E5 | `=Monthly_PvA!C3` | Revenue plan |
| F5 | `=(D5-E5)/E5` | Variance % |
| G5 | `=IF(F5>=0,"✓ Favorable",IF(F5>=-0.03,"⚠ Watch","✗ Unfavorable"))` | Status |

### Conditional Formatting
```
Variance % Column (F):
- >= 0%: Green text (#2E7D32)
- -3% to 0%: Orange text (#EF6C00)
- < -3%: Red text (#C62828)

Variance Trend Sparklines:
- In column H, show 12-month trend
- Green if improving, red if declining
```

---

## SHEET 2: Monthly_PvA

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Period |
| B | Revenue_Actual | Actual revenue |
| C | Revenue_Plan | Plan/Budget |
| D | Revenue_Variance | =B-C |
| E | Revenue_Var_Pct | =D/C |
| F | COGS_Actual | |
| G | COGS_Plan | |
| H | COGS_Variance | =F-G |
| I | Gross_Profit_Act | =B-F |
| J | Gross_Profit_Plan | =C-G |
| K | GP_Variance | =I-J |
| L | GP_Margin_Act | =I/B |
| M | GP_Margin_Plan | =J/C |
| N | Margin_Variance | =L-M |
| O | OpEx_Actual | |
| P | OpEx_Plan | |
| Q | OpEx_Variance | =O-P |
| R | EBITDA_Actual | =I-O |
| S | EBITDA_Plan | =J-P |
| T | EBITDA_Variance | =R-S |
| U | EBITDA_Var_Pct | =T/S |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| D3 | `=B3-C3` | Revenue variance |
| E3 | `=IF(C3=0,0,D3/C3)` | Variance % (handle div/0) |
| K3 | `=I3-J3` | GP variance |
| N3 | `=L3-M3` | Margin point variance |
| U3 | `=IF(S3=0,0,T3/S3)` | EBITDA variance % |

### YTD Calculations (Row at bottom)
```
YTD_Revenue_Actual: =SUMIF($A:$A,"<="&Settings!$B$2,$B:$B)
YTD_Revenue_Plan: =SUMIF($A:$A,"<="&Settings!$B$2,$C:$C)
YTD_Variance: =YTD_Actual-YTD_Plan
YTD_Var_Pct: =YTD_Variance/YTD_Plan
```

### Conditional Formatting
```
Variance columns (D, H, K, Q, T):
- Positive: Green fill for favorable
- Negative: Red fill for unfavorable
- Note: For costs, negative (under budget) is favorable

Data Bars:
- Column E: Red-White-Green data bars centered at 0
```

---

## SHEET 3: Revenue_Bridge

### Waterfall Structure
| Component | Impact | Running_Total |
|-----------|--------|---------------|
| Plan/Budget | $125M | $125M |
| Volume | +$3.0M | $128M |
| Price | +$1.5M | $129.5M |
| Mix | +$0.5M | $130M |
| FX | -$1.2M | $128.8M |
| Other | -$0.8M | $128M |
| Actual | | $128M |

### Bridge Formulas
```
Volume Impact (B3):
=SUMPRODUCT((Actual_Volume-Plan_Volume),Plan_Price)

Price Impact (B4):
=SUMPRODUCT(Actual_Volume,(Actual_Price-Plan_Price))

Mix Impact (B5):
=Actual_Revenue-Plan_Revenue-Volume_Impact-Price_Impact-FX_Impact

FX Impact (B6):
=SUMPRODUCT(Actual_Volume_LC,Actual_Price_LC,(Plan_FX_Rate-Actual_FX_Rate))

Running Total (C3):
=C2+B3

Validation Check:
=IF(C7=B1,"✓ Balanced","✗ Error")
```

### By Product Family
| Family | Volume | Price | Mix | FX | Total | % of Variance |
|--------|--------|-------|-----|-----|-------|---------------|
| Family_A | +$1.2M | +$0.8M | +$0.2M | -$0.5M | +$1.7M | 57% |
| Family_B | +$1.0M | +$0.5M | +$0.3M | -$0.4M | +$1.4M | 47% |
| Family_C | +$0.8M | +$0.2M | 0 | -$0.3M | +$0.7M | 23% |

---

## SHEET 4: Margin_Analysis

### Margin Bridge
| Component | Impact_$M | Impact_Pts |
|-----------|-----------|------------|
| Prior Period Margin | | 33.5% |
| Revenue Mix | +$0.8M | +0.3% |
| Cost Changes | -$0.5M | -0.2% |
| Productivity | +$1.2M | +0.5% |
| Volume Leverage | +$0.3M | +0.1% |
| Current Margin | | 34.2% |

### Margin Formulas
```
Revenue Mix Impact:
=SUMPRODUCT(Actual_Volume,Actual_Margin)-SUMPRODUCT(Actual_Volume,Prior_Margin)

Cost Impact:
=SUMPRODUCT(Actual_Volume,(Prior_Cost-Actual_Cost))

Productivity Impact:
=Budget_COGS*(1-Efficiency_Gain)-Actual_COGS

Volume Leverage:
=(Actual_Volume-Budget_Volume)*Contribution_Margin
```

### Margin by Dimension
| Dimension | Actual_Margin | Plan_Margin | Variance | Status |
|-----------|---------------|-------------|----------|--------|
| By Region | | | | |
| By Family | | | | |
| By Customer | | | | |
| By Channel | | | | |

---

## SHEET 5: Variance_Drivers

### Top Variance Analysis
| Rank | Category | Driver | Impact | Root_Cause | Owner | Action |
|------|----------|--------|--------|------------|-------|--------|
| 1 | Revenue | Customer A Growth | +$1.5M | Market share gain | Sales | Continue |
| 2 | Revenue | New Product Launch | +$0.8M | Ahead of plan | Marketing | Track |
| 3 | Cost | Raw Material | -$0.5M | Commodity price | Procurement | Hedge |
| 4 | Revenue | Customer B Loss | -$0.4M | Competitive | Sales | Recovery |
| 5 | Cost | Freight | -$0.3M | Fuel surcharge | Logistics | Renegotiate |

### Variance Classification
```
Type (H3):
=IF(D3>0,"Favorable","Unfavorable")

Recurrence (I3):
="One-time,Recurring,Structural" (Dropdown)

Controllability (J3):
="Controllable,Partially,Uncontrollable" (Dropdown)

Priority Score (K3):
=ABS(D3)*IF(I3="Recurring",2,1)*IF(J3="Controllable",2,IF(J3="Partially",1.5,1))
```

### Pareto Analysis
```
Cumulative Impact:
=SUM($D$3:D3)/SUM($D$3:$D$20)

Pareto Class:
=IF(Cumulative<=0.8,"A",IF(Cumulative<=0.95,"B","C"))
```

---

## SHEET 6: Rolling_Forecast

### 18-Month Rolling Forecast
| Month | Actual | Prior_Fcst | Current_Fcst | Change | Status |
|-------|--------|------------|--------------|--------|--------|
| Jan (A) | $128M | $125M | $128M | +$3M | Complete |
| Feb (A) | $132M | $130M | $132M | +$2M | Complete |
| Mar (F) | | $135M | $138M | +$3M | In Progress |
| ... | | | | | |

### Forecast Formulas
```
Change vs Prior (E3):
=D3-C3

Status (F3):
=IF(MONTH($A3)<MONTH(TODAY()),"Complete",IF(MONTH($A3)=MONTH(TODAY()),"In Progress","Forecast"))

Full Year Forecast:
=SUMIF(Status,"Complete",Actual)+SUMIF(Status,"<>Complete",Current_Fcst)

vs Budget:
=Full_Year_Forecast-Annual_Budget

vs Prior Year:
=Full_Year_Forecast-Prior_Year_Actual
```

### Forecast Accuracy Tracking
```
Prior Forecast MAPE:
=AVERAGE(ABS((Actual-Prior_Fcst)/Actual))

Forecast Bias:
=(SUM(Prior_Fcst)-SUM(Actual))/SUM(Actual)
```

---

## SHEET 7: Data_Import

### Data Source Configuration
| Source | Connection | Refresh | Last_Updated |
|--------|------------|---------|--------------|
| Revenue | ERP_Link | Daily | =NOW() |
| COGS | ERP_Link | Daily | |
| Budget | File_Link | Monthly | |
| Prior_Year | File_Link | Annual | |

### Power Query Template
```
// Revenue Import
let
    Source = Sql.Database("ERP_Server", "Finance"),
    Revenue = Source{[Schema="dbo",Item="vw_Revenue"]}[Data],
    Filtered = Table.SelectRows(Revenue, each [Period] >= #date(2024, 1, 1)),
    Grouped = Table.Group(Filtered, {"Period"}, {{"Revenue", each List.Sum([Amount]), type number}})
in
    Grouped
```

### Validation Checks
```
Revenue Reconciliation:
=IF(ABS(ERP_Total-GL_Total)<1000,"✓ Reconciled","✗ Variance")

Period Completeness:
=IF(COUNTBLANK(Revenue_Column)=0,"✓ Complete","✗ Missing Data")
```

---

## SHEET 8: Settings

### Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Current_Month | =EOMONTH(TODAY(),-1) | Reporting month |
| Fiscal_Year_Start | 1 | January |
| Budget_Version | "FY2024_v1" | Budget reference |
| Variance_Threshold | 0.03 | 3% alert threshold |
| Currency | "USD" | Reporting currency |
| Decimal_Places | 1 | Display precision |
| Show_MTD | TRUE | Month-to-date toggle |
| Show_YTD | TRUE | Year-to-date toggle |
| Show_FY | TRUE | Full-year toggle |

### Variance Alert Rules
| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Revenue | >= 0% | -3% to 0% | < -3% |
| Margin | >= 0pts | -0.5 to 0pts | < -0.5pts |
| EBITDA | >= 0% | -5% to 0% | < -5% |

---

## NAMED RANGES

```
Name: CurrentMonth
Refers to: =Settings!$B$2

Name: ActualRevenue
Refers to: =Monthly_PvA!$B:$B

Name: PlanRevenue
Refers to: =Monthly_PvA!$C:$C

Name: VarianceThreshold
Refers to: =Settings!$B$5

Name: BridgeComponents
Refers to: =Revenue_Bridge!$A$3:$C$9

Name: TopVariances
Refers to: =Variance_Drivers!$A$3:$K$22
```

---

## INTEGRATION POINTS

```
1. Consensus_Demand_Workbook.xlsx
   - Pull: Revenue plan by month
   - Validate: Forecast accuracy

2. Executive_Dashboard.xlsx
   - Push: Key financial KPIs
   - Push: Variance summary

3. Gap_Closure_Tracker.xlsx
   - Push: Identified gaps
   - Track: Closure initiatives

4. Rolling_Forecast_Template.xlsx
   - Sync: Latest forecast
   - Share: Variance drivers

5. Working_Capital_Dashboard.xlsx
   - Link: Revenue for DSO calculation
   - Link: COGS for inventory days
```

---

## KEY FORMULAS SUMMARY

### Variance Calculation
```excel
=Actual-Plan
```

### Variance Percentage
```excel
=IF(Plan=0,0,(Actual-Plan)/Plan)
```

### YTD Calculation
```excel
=SUMIF(Month,"<="&CurrentMonth,Actual)
```

### Waterfall Running Total
```excel
=PriorTotal+CurrentImpact
```

---

**Template Version:** Enhanced Plan vs Actual 2.0
**Refresh Frequency:** Daily for actuals, Weekly for analysis
