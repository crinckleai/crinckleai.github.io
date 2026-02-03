# Forecast Accuracy Tracker - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Monthly_Accuracy
### Sheet 3: By_Product_Family
### Sheet 4: By_Customer
### Sheet 5: Bias_Analysis
### Sheet 6: Root_Cause_Log
### Sheet 7: Settings

---

## SHEET 1: DASHBOARD

### Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "FORECAST ACCURACY DASHBOARD" (Blue #1565C0)                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:F12  KPI SUMMARY               │ H3:P12  ACCURACY TREND (12-Month)      │
│ ┌─────────────────────────────┐   │ ┌─────────────────────────────────┐    │
│ │ Current Month Accuracy: 72% │   │ │    Target Line at 75%           │    │
│ │ Target: 75%                 │   │ │ 80%|     ●───●                   │    │
│ │ Gap: -3%                    │   │ │ 70%| ●──●       ●──●──●          │    │
│ │ Bias: +2.1%                 │   │ │ 60%|                             │    │
│ │ WMAPE: 28%                  │   │ │    └─────────────────────────   │    │
│ │ Best Family: Family A (82%)│   │ └─────────────────────────────────┘    │
│ │ Worst Family: Family D (58%)│   │                                        │
│ └─────────────────────────────┘   │                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ A14:H28  ACCURACY BY FAMILY       │ J14:P28  ACCURACY BY LEVEL             │
│ (Horizontal bar chart)            │ (Total→Family→SKU→SKU-Loc)            │
├─────────────────────────────────────────────────────────────────────────────┤
│ A30:P40  TOP 10 FORECAST MISSES (Largest absolute errors)                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard KPI Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=Monthly_Accuracy!B2` | Current month accuracy (latest) |
| C5 | `=Settings!$B$3` | Target accuracy |
| C6 | `=C4-C5` | Gap to target |
| C7 | `=Monthly_Accuracy!C2` | Current month bias |
| C8 | `=Monthly_Accuracy!D2` | Current month WMAPE |
| C9 | `=INDEX(By_Product_Family!$A$3:$A$20,MATCH(MAX(By_Product_Family!$D$3:$D$20),By_Product_Family!$D$3:$D$20,0))` | Best performing family |
| C10 | `=INDEX(By_Product_Family!$A$3:$A$20,MATCH(MIN(By_Product_Family!$D$3:$D$20),By_Product_Family!$D$3:$D$20,0))` | Worst performing family |

### Conditional Formatting
```
Gap (C6):
- >= 0: Green (#C8E6C9) with ✓
- -5% to 0: Yellow (#FFF9C4) with ⚠
- < -5%: Red (#FFCDD2) with ✗

Bias (C7):
- Between -3% and +3%: Green
- Between -5% and +5%: Yellow
- Outside ±5%: Red
```

---

## SHEET 2: Monthly_Accuracy

### Column Structure
| Col | Header | Format | Description |
|-----|--------|--------|-------------|
| A | Month | Date (MMM-YY) | Reporting month |
| B | Forecast_Accuracy_Pct | Percentage | Overall accuracy |
| C | Bias_Pct | Percentage | Over/under forecast |
| D | WMAPE | Percentage | Weighted MAPE |
| E | Total_Forecast | Number | Total units forecast |
| F | Total_Actual | Number | Total units actual |
| G | Absolute_Error | Number | Sum of absolute errors |
| H | SKU_Count | Number | SKUs measured |
| I | SKUs_Above_Target | Number | Count meeting target |
| J | Pct_SKUs_Above_Target | Percentage | % meeting target |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| B2 | `=1-G2/F2` | Forecast Accuracy % |
| C2 | `=(E2-F2)/F2` | Bias % (positive = over-forecast) |
| D2 | `=SUMPRODUCT(ABS(Detail!$E$3:$E$5000-Detail!$F$3:$F$5000),Detail!$F$3:$F$5000)/SUM(Detail!$F$3:$F$5000)` | Weighted MAPE |
| G2 | `=SUMPRODUCT(ABS(Detail!$E$3:$E$5000-Detail!$F$3:$F$5000))` | Total absolute error |
| I2 | `=COUNTIF(Detail!$G$3:$G$5000,">="&Settings!$B$3)` | SKUs above target |
| J2 | `=I2/H2` | Percent above target |

### Trend Analysis Formulas
```
3-Month Moving Average (K2):
=AVERAGE(B2:B4)

YoY Comparison (L2):
=B2-INDEX($B:$B,MATCH(EDATE(A2,-12),$A:$A,0))

Trend Direction (M2):
=IF(B2>B3,"↑ Improving",IF(B2<B3,"↓ Declining","→ Stable"))
```

---

## SHEET 3: By_Product_Family

### Column Structure
| Col | Header | Formula | Description |
|-----|--------|---------|-------------|
| A | Product_Family | | Family name |
| B | Forecast_Units | `=SUMIF(Detail!$C:$C,A3,Detail!$E:$E)` | Total forecast |
| C | Actual_Units | `=SUMIF(Detail!$C:$C,A3,Detail!$F:$F)` | Total actual |
| D | Accuracy_Pct | `=1-ABS(B3-C3)/C3` | Family accuracy |
| E | Bias_Pct | `=(B3-C3)/C3` | Family bias |
| F | WMAPE | `=SUMPRODUCT((Detail!$C$3:$C$5000=A3)*ABS(Detail!$E$3:$E$5000-Detail!$F$3:$F$5000),Detail!$F$3:$F$5000)/C3` | Weighted error |
| G | SKU_Count | `=COUNTIF(Detail!$C:$C,A3)` | SKUs in family |
| H | Revenue_Impact | `=ABS(B3-C3)*AVERAGEIF(Detail!$C:$C,A3,Detail!$H:$H)` | Est. revenue impact |
| I | Rank | `=RANK(D3,$D$3:$D$20,0)` | Accuracy ranking |
| J | Status | `=IF(D3>=Settings!$B$3,"✓ Target",IF(D3>=Settings!$B$3*0.9,"⚠ Watch","✗ Miss"))` | Performance status |

### Conditional Formatting
```
Accuracy (D column):
- Data bars: Green gradient, max at 100%

Status (J column):
- "✓ Target": Green fill
- "⚠ Watch": Yellow fill
- "✗ Miss": Red fill
```

---

## SHEET 4: By_Customer

### Column Structure (Same logic as By_Product_Family)
| Col | Header | Formula |
|-----|--------|---------|
| A | Customer_Name | |
| B | Customer_Segment | Dropdown |
| C | Forecast_Units | `=SUMIF(Detail!$D:$D,A3,Detail!$E:$E)` |
| D | Actual_Units | `=SUMIF(Detail!$D:$D,A3,Detail!$F:$F)` |
| E | Accuracy_Pct | `=1-ABS(C3-D3)/D3` |
| F | Bias_Pct | `=(C3-D3)/D3` |
| G | Collaboration_Level | Dropdown (High/Med/Low) |
| H | Forecast_Source | Dropdown (Customer/Sales/Statistical) |
| I | Revenue_Rank | `=RANK(D3,$D$3:$D$100,0)` |
| J | Improvement_Priority | `=IF(AND(E3<Settings!$B$3,I3<=10),"HIGH",IF(E3<Settings!$B$3,"MEDIUM","LOW"))` |

### Customer Forecast Quality Score
```
K3 (Quality Score 0-100):
=IF(E3>=0.9,100,IF(E3>=0.8,80,IF(E3>=0.7,60,IF(E3>=0.6,40,20))))+
IF(ABS(F3)<=0.03,20,IF(ABS(F3)<=0.05,10,0))+
IF(G3="High",20,IF(G3="Medium",10,0))
```

---

## SHEET 5: Bias_Analysis

### Bias Summary Table
| Category | Count_Over | Count_Under | Count_Accurate | Bias_Direction |
|----------|------------|-------------|----------------|----------------|
| By Family | =FORMULA | =FORMULA | =FORMULA | =FORMULA |
| By Customer | =FORMULA | =FORMULA | =FORMULA | =FORMULA |
| By Planner | =FORMULA | =FORMULA | =FORMULA | =FORMULA |

### Formulas
```
B3 (Count Over-forecast):
=COUNTIF(Detail!$I$3:$I$5000,">0.03")

C3 (Count Under-forecast):
=COUNTIF(Detail!$I$3:$I$5000,"<-0.03")

D3 (Count Accurate):
=COUNTIFS(Detail!$I$3:$I$5000,">=-0.03",Detail!$I$3:$I$5000,"<=0.03")

E3 (Bias Direction):
=IF(B3>C3*1.2,"OVER-FORECAST",IF(C3>B3*1.2,"UNDER-FORECAST","BALANCED"))
```

### Systematic Bias Detection
```
Consecutive Months Over-Forecast (F3):
=MAX(FREQUENCY(IF(Monthly_Accuracy!$C$2:$C$13>0.03,ROW(Monthly_Accuracy!$C$2:$C$13)),IF(Monthly_Accuracy!$C$2:$C$13<=0.03,ROW(Monthly_Accuracy!$C$2:$C$13))))

Bias Trend (G3):
=SLOPE(Monthly_Accuracy!$C$2:$C$7,Monthly_Accuracy!$A$2:$A$7)
```

---

## SHEET 6: Root_Cause_Log

### Column Structure
| Col | Header | Description |
|-----|--------|-------------|
| A | Month | Period of miss |
| B | Product_Family | Affected family |
| C | SKU_ID | Specific SKU if applicable |
| D | Forecast_Error_Pct | Size of miss |
| E | Error_Direction | Over/Under |
| F | Root_Cause_Category | Dropdown |
| G | Root_Cause_Detail | Text description |
| H | Responsible_Function | Dropdown |
| I | Corrective_Action | Text |
| J | Action_Owner | Name |
| K | Due_Date | Date |
| L | Status | Dropdown |
| M | Recurrence_Prevention | Text |

### Root Cause Categories (Dropdown)
```
Demand Side:
- Customer order change
- Promotional variance
- New customer/lost customer
- Market condition change
- Competitive action

Supply Side:
- Production issue
- Quality problem
- Supplier constraint
- Logistics delay

Process Side:
- Data error
- Timing issue
- Communication gap
- Model limitation
```

### Summary Analysis
```
Top 3 Root Causes (N3:N5):
=INDEX(Pivot!$A$2:$A$20,MATCH(LARGE(Pivot!$B$2:$B$20,ROW()-2),Pivot!$B$2:$B$20,0))

Pareto: % of errors from top 3 causes
=SUM(LARGE(Pivot!$B$2:$B$20,{1,2,3}))/SUM(Pivot!$B$2:$B$20)
```

---

## SHEET 7: Settings

### Configuration Parameters
| Row | Parameter | Value | Description |
|-----|-----------|-------|-------------|
| 2 | Report_Period | =EOMONTH(TODAY(),-1) | Default to last month |
| 3 | Target_Accuracy | 0.75 | 75% target |
| 4 | Target_Bias | 0.03 | ±3% acceptable |
| 5 | Lag_Months | 1 | Forecast lag (1 = M-1 forecast) |
| 6 | Measurement_Level | "SKU-Location" | Granularity |
| 8 | Accuracy_Calc_Method | "1-MAPE" | Options: 1-MAPE, 1-wMAPE |
| 9 | Exclude_Low_Volume | TRUE | Exclude SKUs below threshold |
| 10 | Low_Volume_Threshold | 100 | Units to exclude |
| 12 | Value_Add_Target | 0.10 | 10% vs statistical |

### Measurement Level Weights
```
Total Company: 100%
Product Family: 85%
SKU: 75%
SKU-Location: 70%
```

---

## NAMED RANGES

```
Name: AccuracyData
Refers to: =Monthly_Accuracy!$A$2:$M$100

Name: FamilyAccuracy
Refers to: =By_Product_Family!$A$3:$J$50

Name: CustomerAccuracy
Refers to: =By_Customer!$A$3:$K$200

Name: TargetAccuracy
Refers to: =Settings!$B$3

Name: TargetBias
Refers to: =Settings!$B$4

Name: CurrentMonthAccuracy
Refers to: =Monthly_Accuracy!$B$2

Name: RootCauses
Refers to: =Root_Cause_Log!$A$3:$M$500
```

---

## INTEGRATION POINTS

```
1. Consensus_Demand_Workbook.xlsx
   - Pull: Forecast values by SKU
   - Push: Accuracy feedback by product/customer

2. Demand_Assumptions_Log.xlsx
   - Link: Assumptions that drove forecast errors
   - Push: Accuracy results for assumption validation

3. IBP_KPI_Dashboard.xlsx
   - Push: Monthly accuracy, bias, WMAPE
   - Push: Family-level performance

4. Customer_Forecast_Collaboration.xlsx
   - Push: Customer-level accuracy
   - Link: Collaboration impact on accuracy
```

---

## KEY FORMULAS SUMMARY

### Forecast Accuracy
```excel
=1-ABS(Forecast-Actual)/Actual
```

### Weighted MAPE
```excel
=SUMPRODUCT(ABS(Forecast-Actual),Actual)/SUM(Actual)
```

### Bias
```excel
=(Forecast-Actual)/Actual
```

### Value-Added Forecast
```excel
=(Statistical_Accuracy-Consensus_Accuracy)/Statistical_Accuracy
```

---

**Template Version:** Enhanced Forecast Accuracy Tracker 2.0
**Refresh Frequency:** Monthly (after actuals close)
