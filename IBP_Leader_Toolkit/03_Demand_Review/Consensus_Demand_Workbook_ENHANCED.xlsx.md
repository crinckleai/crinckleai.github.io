# Consensus Demand Workbook - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Consensus_Summary
### Sheet 3: Statistical_Baseline
### Sheet 4: Sales_Input
### Sheet 5: Marketing_Input
### Sheet 6: Finance_Input
### Sheet 7: Reconciliation
### Sheet 8: Final_Demand_Plan
### Sheet 9: Assumptions_Log
### Sheet 10: Settings

---

## SHEET 1: DASHBOARD

### Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "CONSENSUS DEMAND DASHBOARD" (Cyan #00838F)                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:F10  PLAN SUMMARY              │ H3:P10  DEMAND TREND (18-Month)        │
│ ┌─────────────────────────────┐   │ ┌───────────────────────────────────┐  │
│ │ Current Month Demand: 125K  │   │ │ Line chart: Actual vs Forecast   │  │
│ │ YTD Demand: 1.2M           │   │ │ with confidence bands             │  │
│ │ Full Year Forecast: 2.8M   │   │ └───────────────────────────────────┘  │
│ │ vs Budget: +3.2%           │   │                                        │
│ │ vs Prior Year: +5.8%       │   │                                        │
│ └─────────────────────────────┘   │                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ A12:G25  CONSENSUS WATERFALL      │ I12:P25  DEMAND BY FAMILY             │
│ (Statistical → Final)             │ (Stacked bar by month)                │
├─────────────────────────────────────────────────────────────────────────────┤
│ A27:P35  KEY ASSUMPTIONS & RISKS (Top 5 each)                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=SUMIF(Final_Demand_Plan!$B:$B,Settings!$B$2,Final_Demand_Plan!$E:$E)` | Current month demand |
| C5 | `=SUMPRODUCT((Final_Demand_Plan!$B$3:$B$500<=Settings!$B$2)*(YEAR(Final_Demand_Plan!$B$3:$B$500)=YEAR(Settings!$B$2))*Final_Demand_Plan!$E$3:$E$500)` | YTD demand |
| C6 | `=SUMIF(Final_Demand_Plan!$A:$A,YEAR(Settings!$B$2),Final_Demand_Plan!$E:$E)` | Full year forecast |
| C7 | `=(C6-Budget!$B$2)/Budget!$B$2` | vs Budget % |
| C8 | `=(C6-PriorYear!$B$2)/PriorYear!$B$2` | vs Prior Year % |

---

## SHEET 2: Consensus_Summary

### Column Structure (Rolling 18-Month View)
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Planning month |
| B | Statistical_Baseline | System-generated forecast |
| C | Sales_Adjustment | Sales team input |
| D | Marketing_Adjustment | Marketing input (promos, campaigns) |
| E | Finance_Adjustment | Finance input (budget alignment) |
| F | Other_Adjustments | NPI, one-time events |
| G | Consensus_Demand | Final agreed number |
| H | Change_vs_Prior | vs last month's plan |
| I | Change_vs_Budget | vs annual budget |
| J | Assumptions_Count | Number of assumptions |
| K | Risk_Rating | High/Med/Low |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| G3 | `=B3+C3+D3+E3+F3` | Total consensus (sum of all inputs) |
| H3 | `=G3-Prior_Month!G3` | Change vs prior month plan |
| I3 | `=G3-VLOOKUP(A3,Budget!$A:$B,2,FALSE)` | Change vs budget |
| J3 | `=COUNTIF(Assumptions_Log!$B:$B,A3)` | Count of assumptions for this month |
| K3 | `=IF(COUNTIF(Assumptions_Log!$E:$E,"High")>2,"High",IF(COUNTIF(Assumptions_Log!$E:$E,"Medium")>3,"Medium","Low"))` | Risk rating |

### Waterfall Calculation
```
Consensus Waterfall Steps:
1. Statistical Baseline: =B3
2. + Sales Overlay: =C3 (with sign)
3. + Marketing Events: =D3 (with sign)
4. + Finance Alignment: =E3 (with sign)
5. + Other: =F3 (with sign)
6. = Final Consensus: =G3

Validation Check:
=IF(G3=SUM(B3:F3),"✓","ERROR")
```

---

## SHEET 3: Statistical_Baseline

### Column Structure
| Col | Header | Formula/Description |
|-----|--------|---------------------|
| A | SKU_ID | Product identifier |
| B | Product_Family | Lookup from master |
| C | Month | Forecast period |
| D | History_Avg_12M | `=AVERAGE(OFFSET(...))` |
| E | Trend_Factor | `=SLOPE(history)/AVERAGE(history)` |
| F | Seasonality_Index | `=VLOOKUP(MONTH(C3),Seasonality!$A:$B,2,FALSE)` |
| G | Statistical_Forecast | `=D3*(1+E3)*F3` |
| H | Model_Type | Best fit model used |
| I | Model_Fit_Score | MAPE of model |
| J | Confidence_Level | High/Med/Low |

### Statistical Model Selection
```
Model Types:
- Moving Average: =AVERAGE(Last N periods)
- Exponential Smoothing: =Alpha*Actual + (1-Alpha)*Prior_Forecast
- Linear Trend: =INTERCEPT + SLOPE*Period
- Seasonal: =Base * Seasonality_Index

Auto-Selection Logic (H3):
=IF(I_Trend>0.8,"Linear Trend",
  IF(I_Seasonal>0.7,"Seasonal",
    IF(I_MA<I_ES,"Moving Average","Exp Smoothing")))
```

### Seasonality Index Table (Separate Area)
| Month | Index |
|-------|-------|
| Jan | 0.92 |
| Feb | 0.88 |
| Mar | 1.02 |
| Apr | 1.05 |
| May | 1.08 |
| Jun | 1.12 |
| Jul | 0.95 |
| Aug | 0.98 |
| Sep | 1.10 |
| Oct | 1.08 |
| Nov | 0.95 |
| Dec | 0.87 |

---

## SHEET 4: Sales_Input

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Period |
| B | Region | Sales region |
| C | Sales_Rep | Responsible rep |
| D | Customer | Customer name |
| E | Product_Family | Family |
| F | Statistical_Base | Reference from Sheet 3 |
| G | Sales_Adjustment | +/- units |
| H | Adjustment_Reason | Dropdown |
| I | Confidence_Level | Dropdown (1-5) |
| J | Customer_Commit | Yes/No/Partial |
| K | Probability_Pct | Likelihood |
| L | Weighted_Adjustment | =G*K |
| M | Notes | Free text |
| N | Last_Updated | =NOW() on change |
| O | Updated_By | User name |

### Sales Adjustment Reasons (Dropdown)
```
- New customer win
- Customer expansion
- Customer reduction
- Lost customer
- Project/tender
- Seasonal adjustment
- Competitive situation
- Economic outlook
- Customer inventory adjustment
```

### Validation Rules
```
1. Adjustment > 20% requires confidence level and reason
   =IF(ABS(G3/F3)>0.2,AND(NOT(ISBLANK(H3)),I3>=3),"OK","NEEDS REVIEW")

2. Customer commit required for adjustments > $100K
   =IF(G3*Price>100000,J3<>"","OK")

3. Total adjustment by rep cannot exceed authority limit
   =SUMIF($C:$C,C3,$G:$G)<=VLOOKUP(C3,AuthorityLimits,2,FALSE)
```

---

## SHEET 5: Marketing_Input

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Period |
| B | Campaign_ID | Marketing campaign reference |
| C | Campaign_Name | Description |
| D | Campaign_Type | Dropdown |
| E | Product_Family | Affected family |
| F | Start_Date | Campaign start |
| G | End_Date | Campaign end |
| H | Expected_Lift_Pct | Percent increase |
| I | Baseline_Volume | Base demand |
| J | Incremental_Volume | =I*H |
| K | Cannibalization_Pct | Impact on other products |
| L | Net_Adjustment | =J*(1-K) |
| M | Confidence_Level | 1-5 scale |
| N | Historical_Benchmark | Similar past campaign |
| O | Status | Confirmed/Tentative/Cancelled |

### Campaign Types
```
- Price promotion
- Trade promotion
- Advertising campaign
- New product launch
- Seasonal event
- Bundle offer
- Loyalty program
```

### Marketing Adjustment Formulas
```
Total Marketing Lift (by month):
=SUMIFS($L:$L,$A:$A,[@Month],$O:$O,"<>Cancelled")

Promotional Efficiency:
=Incremental_Revenue/Campaign_Cost
```

---

## SHEET 6: Finance_Input

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Period |
| B | Budget_Volume | Annual budget allocation |
| C | Bottom_Up_Forecast | Sum of other inputs |
| D | Gap_to_Budget | =C-B |
| E | Finance_Adjustment | Recommended change |
| F | Adjustment_Rationale | Text |
| G | P&L_Impact | Revenue/margin impact |
| H | Risk_Assessment | High/Med/Low |
| I | Approved_By | Finance approver |
| J | Approval_Date | Date |

### Budget Alignment Logic
```
Gap Analysis (D3):
=C3-B3

Recommended Action (E3):
=IF(D3>B3*0.1,"Review upside - validate assumptions",
  IF(D3<-B3*0.1,"Gap closure needed - identify initiatives",
    "Within tolerance"))

P&L Impact (G3):
=D3*VLOOKUP(Month,ASP_Table,2,FALSE)*VLOOKUP(Month,Margin_Table,2,FALSE)
```

---

## SHEET 7: Reconciliation

### Reconciliation Matrix
```
          Statistical  Sales    Marketing  Finance  Consensus  Variance
Family A     1,200     +150       +80       -30      1,400      +200
Family B       850      -50       +20         0        820       -30
Family C     1,100     +200      +100       +50      1,450      +350
...
TOTAL        5,000     +400      +250       +50      5,700      +700
```

### Key Formulas
```
Family Total (E3):
=SUMIF(Consensus_Summary!$A:$A,"Family A",Consensus_Summary!$G:$G)

Variance Explanation Required:
=IF(ABS(F3/B3)>0.15,"EXPLAIN","OK")
```

### Sign-Off Section
```
| Role | Name | Signature | Date | Approved Y/N |
|------|------|-----------|------|--------------|
| Demand Planning | | | | |
| Sales | | | | |
| Marketing | | | | |
| Finance | | | | |
| IBP Leader | | | | |
```

---

## SHEET 8: Final_Demand_Plan

### Column Structure (Official Output)
| Col | Header | Format |
|-----|--------|--------|
| A | Year | Number |
| B | Month | Date |
| C | Product_Family | Text |
| D | SKU_ID | Text |
| E | Consensus_Volume | Number |
| F | Unit_Price | Currency |
| G | Revenue | =E*F |
| H | Prior_Month_Plan | Number |
| I | Change_Units | =E-H |
| J | Change_Pct | =I/H |
| K | Budget | Number |
| L | Variance_to_Budget | =E-K |
| M | Plan_Version | Text |
| N | Approval_Status | Dropdown |
| O | Lock_Date | Date |

### Plan Lock Formula
```
P3 (Edit Protection):
=IF(O3<>"",IF(TODAY()>O3,"LOCKED","OPEN"),"DRAFT")

Data Validation:
- If LOCKED, prevent edits (VBA or protection)
```

---

## SHEET 9: Assumptions_Log

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Assumption_ID | Auto-generated |
| B | Month | Affected period |
| C | Category | Dropdown |
| D | Assumption_Description | Text |
| E | Risk_Level | High/Med/Low |
| F | Volume_Impact | Units |
| G | Revenue_Impact | Currency |
| H | Owner | Responsible person |
| I | Validation_Method | How to confirm |
| J | Validation_Date | When to check |
| K | Status | Open/Validated/Invalid |
| L | Actual_Outcome | Result |
| M | Learning | Text |

### Assumption Categories
```
- Market growth
- Customer behavior
- Competitive action
- Pricing
- Promotion response
- Supply availability
- Economic conditions
- Regulatory
- Weather/seasonal
```

### Summary Statistics
```
Total Open Assumptions:
=COUNTIF($K:$K,"Open")

High Risk Assumptions:
=COUNTIFS($K:$K,"Open",$E:$E,"High")

Assumptions Validated This Month:
=COUNTIFS($J:$J,">="&EOMONTH(TODAY(),-1)+1,$J:$J,"<="&EOMONTH(TODAY(),0),$K:$K,"Validated")
```

---

## SHEET 10: Settings

### Configuration
| Row | Parameter | Value |
|-----|-----------|-------|
| 2 | Current_Period | =EOMONTH(TODAY(),0) |
| 3 | Planning_Horizon | 18 |
| 4 | History_Months | 24 |
| 5 | Smoothing_Alpha | 0.3 |
| 6 | Budget_Tolerance | 0.05 |
| 7 | Auto_Lock_Days | 5 |
| 10 | Variance_Alert_Threshold | 0.10 |
| 11 | High_Value_Threshold | 100000 |

---

## INTEGRATION POINTS

```
1. Forecast_Accuracy_Tracker.xlsx
   - Push: Consensus plan for accuracy measurement
   - Pull: Historical accuracy for confidence levels

2. Statistical_Forecast_Template.xlsx
   - Pull: Automated baseline forecasts
   - Sync: Model parameters

3. Plan_vs_Actual_Analysis.xlsx
   - Push: Final demand plan
   - Link: Revenue forecasts

4. Capacity_Planning_Template.xlsx
   - Push: Volume requirements by month
   - Validate: Capacity constraints
```

---

**Template Version:** Enhanced Consensus Demand Workbook 2.0
**Refresh Frequency:** Monthly (Week 2 of IBP cycle)
