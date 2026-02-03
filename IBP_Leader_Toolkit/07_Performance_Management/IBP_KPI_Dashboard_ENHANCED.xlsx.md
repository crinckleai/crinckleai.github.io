# IBP KPI Dashboard - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: EXECUTIVE_VIEW
### Sheet 2: Detailed_KPIs
### Sheet 3: Trend_Analysis
### Sheet 4: Benchmarking
### Sheet 5: Scorecard_Data
### Sheet 6: Settings

---

## SHEET 1: EXECUTIVE_VIEW

### Layout (Balanced Scorecard Format)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "IBP PERFORMANCE SCORECARD" (Purple #4A148C) | Period: [Month Year]        │
├─────────────────────────────────────────────────────────────────────────────┤
│ OVERALL IBP HEALTH SCORE: 82/100  ████████████████░░░░ STRONG              │
├──────────────────────────────────────┬──────────────────────────────────────┤
│ 🎯 CUSTOMER (Score: 85)              │ 💰 FINANCIAL (Score: 88)             │
│ ┌────────────────────────────────┐   │ ┌────────────────────────────────┐   │
│ │ OTIF: 94.2% (Tgt: 95%) ⚠       │   │ │ Revenue vs Plan: +2.4% ✓      │   │
│ │ Perfect Order: 91.8% (92%) ⚠   │   │ │ Margin: 34.2% (33.5%) ✓       │   │
│ │ Lead Time: 8.5d (8d) ⚠         │   │ │ Working Cap: 8.8% (8.5%) ⚠    │   │
│ │ Customer Sat: 4.2 (4.0) ✓      │   │ │ Forecast-Budget: +2.4% ✓      │   │
│ └────────────────────────────────┘   │ └────────────────────────────────┘   │
├──────────────────────────────────────┼──────────────────────────────────────┤
│ ⚙️ PROCESS (Score: 78)               │ 📊 ENABLER (Score: 75)               │
│ ┌────────────────────────────────┐   │ ┌────────────────────────────────┐   │
│ │ Forecast Accuracy: 72% (75%) ⚠ │   │ │ Meeting Effect.: 4.2/5 ✓      │   │
│ │ Bias: +2.1% (±3%) ✓            │   │ │ Decision Time: 36hr (48hr) ✓  │   │
│ │ Plan Adherence: 92% (90%) ✓    │   │ │ Data Quality: 94% (95%) ⚠     │   │
│ │ Plan Stability: 92% (90%) ✓    │   │ │ User Adoption: 82% (85%) ⚠    │   │
│ └────────────────────────────────┘   │ └────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────────────────┤
│ 12-MONTH TREND: Overall Score                                              │
│ 90|                                  ●───●                                 │
│ 80|          ●───●───●───●───●───●───                                     │
│ 70|───●───●───                                                             │
│   └──J───F───M───A───M───J───J───A───S───O───N───D──                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Overall Score Formula
```
Cell C2 (Overall Score):
=(Customer_Score*0.25)+(Financial_Score*0.30)+(Process_Score*0.25)+(Enabler_Score*0.20)

Customer_Score:
=AVERAGE(OTIF_Score,PerfectOrder_Score,LeadTime_Score,CustSat_Score)*100

Individual KPI Score (0-100):
=MIN(100,MAX(0,(Actual/Target)*100))
```

### Status Icon Formula
```
=IF(Actual>=Target,"✓",IF(Actual>=Target*0.95,"⚠","✗"))
```

### Conditional Formatting
```
Score Cells:
- 90-100: Dark Green (#1B5E20)
- 80-89: Green (#43A047)
- 70-79: Yellow (#FDD835)
- 60-69: Orange (#FB8C00)
- <60: Red (#E53935)

Status Icons:
- "✓": Green (#2E7D32), Bold
- "⚠": Orange (#EF6C00), Bold
- "✗": Red (#C62828), Bold
```

---

## SHEET 2: Detailed_KPIs

### Complete KPI Matrix
| Category | KPI | Definition | Actual | Target | Prior_Month | Prior_Year | Trend | Score | Status |
|----------|-----|------------|--------|--------|-------------|------------|-------|-------|--------|
| Customer | OTIF | On-Time In-Full % | 94.2% | 95% | 93.8% | 92.1% | ↑ | 99 | ⚠ |
| Customer | Perfect_Order | Orders with no errors | 91.8% | 92% | 91.5% | 90.2% | ↑ | 100 | ⚠ |
| Customer | Lead_Time | Avg days to deliver | 8.5 | 8.0 | 8.3 | 9.2 | ↑ | 94 | ⚠ |
| Customer | Customer_Sat | Satisfaction score | 4.2 | 4.0 | 4.1 | 3.9 | ↑ | 105 | ✓ |
| Financial | Revenue_vs_Plan | % variance to plan | 102.4% | 100% | 101.8% | 103.2% | ↑ | 102 | ✓ |
| Financial | Gross_Margin | GM % | 34.2% | 33.5% | 33.8% | 32.5% | ↑ | 102 | ✓ |
| Financial | Working_Cap | WC % of revenue | 8.8% | 8.5% | 8.6% | 9.2% | → | 97 | ⚠ |
| Financial | Inventory_Turns | Annual turns | 5.2 | 5.5 | 5.3 | 4.8 | → | 95 | ⚠ |
| Process | Forecast_Accuracy | 1-MAPE | 72% | 75% | 71% | 68% | ↑ | 96 | ⚠ |
| Process | Bias | Systematic over/under | 2.1% | 3% | 2.5% | 4.2% | ↑ | 100 | ✓ |
| Process | Demand_Plan_Adherence | Actual vs plan | 92% | 90% | 91% | 88% | ↑ | 102 | ✓ |
| Process | Supply_Plan_Adherence | Production vs plan | 96% | 95% | 95% | 93% | ↑ | 101 | ✓ |
| Process | Plan_Stability | MoM change | 8% | 10% | 9% | 12% | ↑ | 100 | ✓ |
| Enabler | Meeting_Effectiveness | Survey score | 4.2 | 4.0 | 4.0 | 3.8 | ↑ | 105 | ✓ |
| Enabler | Decision_Cycle | Hours to decision | 36 | 48 | 42 | 56 | ↑ | 100 | ✓ |
| Enabler | Data_Quality | Completeness/accuracy | 94% | 95% | 93% | 91% | ↑ | 99 | ⚠ |
| Enabler | Process_Compliance | Adherence to calendar | 100% | 100% | 100% | 92% | → | 100 | ✓ |
| Enabler | User_Adoption | Active users % | 82% | 85% | 80% | 75% | ↑ | 96 | ⚠ |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| H3 (Trend) | `=IF(D3>E3,"↑",IF(D3<E3,"↓","→"))` | Trend vs prior month |
| I3 (Score) | `=MIN(100,ROUND(IF(C3="Lower Better",(E3/D3)*100,(D3/E3)*100),0))` | Normalized score |
| J3 (Status) | `=IF(D3>=E3,"✓",IF(D3>=E3*0.95,"⚠","✗"))` | Status indicator |

### Score Calculation Logic
```
For "Higher is Better" metrics (Revenue, Accuracy, etc.):
Score = MIN(100, (Actual/Target)*100)

For "Lower is Better" metrics (Lead Time, Bias):
Score = MIN(100, (Target/Actual)*100)

For "Target Range" metrics (Utilization 80-85%):
Score = IF(AND(Actual>=Low,Actual<=High),100,100-ABS((Actual-MidPoint)/MidPoint)*100)
```

---

## SHEET 3: Trend_Analysis

### 12-Month Trend Data
| Month | Overall | Customer | Financial | Process | Enabler |
|-------|---------|----------|-----------|---------|---------|
| Jan | 72 | 75 | 78 | 68 | 65 |
| Feb | 74 | 76 | 79 | 70 | 68 |
| Mar | 75 | 78 | 80 | 71 | 70 |
| ... | ... | ... | ... | ... | ... |
| Dec | 82 | 85 | 88 | 78 | 75 |

### Trend Statistics
```
3-Month Moving Average (G3):
=AVERAGE(B3:B5)

YoY Improvement (H3):
=B14-B2

Trend Direction (I3):
=SLOPE(B2:B13,ROW(B2:B13)-ROW(B2)+1)

Projected Next Month (J3):
=FORECAST(13,B2:B13,ROW(B2:B13)-ROW(B2)+1)
```

### Performance Momentum
```
Momentum Score:
=IF(AND(Current>Prior_3Mo_Avg,Trend_Slope>0),"Strong",
  IF(OR(Current>Prior_3Mo_Avg,Trend_Slope>0),"Building",
    IF(Trend_Slope<0,"Declining","Stable")))
```

---

## SHEET 4: Benchmarking

### Industry Benchmark Comparison
| KPI | Our_Score | Bottom_Quartile | Median | Top_Quartile | Our_Percentile |
|-----|-----------|-----------------|--------|--------------|----------------|
| Forecast_Accuracy | 72% | 55% | 68% | 82% | 65th |
| OTIF | 94.2% | 88% | 93% | 97% | 58th |
| Inventory_Days | 48 | 65 | 52 | 38 | 62nd |
| Plan_Adherence | 92% | 75% | 85% | 95% | 78th |

### Percentile Formula
```
Our_Percentile (F3):
=IF(D3>E3,75+25*(D3-E3)/(Top-E3),
  IF(D3>C3,50+25*(D3-C3)/(E3-C3),
    25+25*(D3-Bottom)/(C3-Bottom)))
```

### Gap to Top Quartile
```
Gap (G3):
=E3-D3

Effort to Close (H3):
=IF(G3>0,"Improvement needed","At or above benchmark")
```

---

## SHEET 5: Scorecard_Data

### Data Entry Table
| Period | Category | KPI_ID | KPI_Name | Actual | Target | Source | Updated_By | Updated_Date |
|--------|----------|--------|----------|--------|--------|--------|------------|--------------|
| 2024-01 | Customer | KPI001 | OTIF | 94.2% | 95% | WMS | System | 2024-02-01 |
| 2024-01 | Customer | KPI002 | Perfect_Order | 91.8% | 92% | WMS | System | 2024-02-01 |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

### Data Validation
```
Category: =Settings!$D$3:$D$6
KPI_ID: =INDIRECT("KPI_"&B3)
Actual: Numeric, within reasonable bounds
Source: =Settings!$E$3:$E$10
```

### Audit Trail
```
Updated_Date: =IF(ISBLANK(E3),"",NOW())
Change_Log: Separate sheet tracking all changes with timestamp
```

---

## SHEET 6: Settings

### Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Report_Period | =EOMONTH(TODAY(),-1) | Current reporting month |
| Weighting_Customer | 0.25 | 25% weight |
| Weighting_Financial | 0.30 | 30% weight |
| Weighting_Process | 0.25 | 25% weight |
| Weighting_Enabler | 0.20 | 20% weight |
| Alert_Threshold | 0.95 | 95% = yellow |
| Critical_Threshold | 0.90 | 90% = red |
| Trend_Periods | 12 | Months to analyze |

### KPI Definitions
| KPI_ID | Name | Definition | Higher_Better | Target | Unit |
|--------|------|------------|---------------|--------|------|
| KPI001 | OTIF | Orders on-time in-full / Total orders | TRUE | 95% | % |
| KPI002 | Perfect_Order | Orders with no errors / Total orders | TRUE | 92% | % |
| KPI003 | Lead_Time | Avg days from order to delivery | FALSE | 8 | Days |
| ... | ... | ... | ... | ... | ... |

### Target Setting Rules
```
Target Adjustment:
- If achieved 3 consecutive months: Raise target by 2%
- If missed 3 consecutive months: Review root cause
- Annual target setting in Q4
```

---

## NAMED RANGES

```
Name: OverallScore
Refers to: =EXECUTIVE_VIEW!$C$2

Name: CustomerScore
Refers to: =EXECUTIVE_VIEW!$C$5

Name: FinancialScore
Refers to: =EXECUTIVE_VIEW!$H$5

Name: ProcessScore
Refers to: =EXECUTIVE_VIEW!$C$12

Name: EnablerScore
Refers to: =EXECUTIVE_VIEW!$H$12

Name: KPIData
Refers to: =Detailed_KPIs!$A$3:$J$50

Name: TrendData
Refers to: =Trend_Analysis!$A$2:$F$14

Name: Benchmarks
Refers to: =Benchmarking!$A$3:$F$20
```

---

## INTEGRATION POINTS

```
1. Executive_Dashboard.xlsx
   - Push: Overall IBP health score
   - Push: Key KPI summary

2. Forecast_Accuracy_Tracker.xlsx
   - Pull: Accuracy and bias metrics
   - Sync: Monthly values

3. Plan_vs_Actual_Analysis.xlsx
   - Pull: Financial KPIs
   - Sync: Revenue/margin metrics

4. Customer_Service_Dashboard.xlsx (External)
   - Pull: OTIF, Perfect Order
   - Link: Service metrics

5. Balanced_Scorecard.xlsx
   - Share: KPI definitions
   - Sync: Scores and weights
```

---

## AUTOMATION FEATURES

### Auto-Refresh
```vba
Sub RefreshScorecard()
    ' Refresh external data connections
    ThisWorkbook.RefreshAll

    ' Recalculate all scores
    Application.Calculate

    ' Update timestamp
    Range("Last_Refresh").Value = Now()

    ' Check for alerts
    Call CheckAlerts

    ' Send notification if critical
    If Range("CriticalCount").Value > 0 Then
        Call SendAlertEmail
    End If
End Sub
```

### Alert Notifications
```vba
Sub CheckAlerts()
    Dim alertCount As Integer
    alertCount = WorksheetFunction.CountIf(Range("Status"), "✗")

    If alertCount > 0 Then
        MsgBox alertCount & " KPIs are in critical status!"
    End If
End Sub
```

---

**Template Version:** Enhanced IBP KPI Dashboard 2.0
**Refresh Frequency:** Monthly (after all data closes)
