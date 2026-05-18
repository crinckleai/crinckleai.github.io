# Executive IBP Dashboard - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: EXECUTIVE_SUMMARY (Main Dashboard)
### Sheet 2: Financial_View
### Sheet 3: Customer_View
### Sheet 4: Operations_View
### Sheet 5: Risk_Portfolio
### Sheet 6: Decisions_Required
### Sheet 7: Data_Feeds
### Sheet 8: Settings

---

## SHEET 1: EXECUTIVE_SUMMARY

### Layout (Single Page Executive View)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ A1:P1  "EXECUTIVE IBP DASHBOARD - [Month Year]" (Black #212121)            │
│ A2:P2  "Last Updated: [DateTime] | Status: [Overall Health]"               │
├─────────────────────────────────────────────────────────────────────────────┤
│ A4:E12  FINANCIAL HEALTH          │ G4:L12  CUSTOMER HEALTH                │
│ ┌─────────────────────────────┐   │ ┌─────────────────────────────────┐    │
│ │ Revenue: $128M (+2.1% Plan) │   │ │ Service Level: 94.2% (⚠-0.8%)  │    │
│ │ ████████████████░░ 96%      │   │ │ ████████████████░░░ 94%        │    │
│ │                             │   │ │                                 │    │
│ │ Margin: 34.2% (+0.7% Plan)  │   │ │ Perfect Order: 91.8% (✓)       │    │
│ │ ████████████████░░ 102%     │   │ │ ████████████████░░░ 92%        │    │
│ │                             │   │ │                                 │    │
│ │ EBITDA: $18.5M (+23% Plan)  │   │ │ Lead Time: 8.5 days (⚠+0.5d)   │    │
│ │ ██████████████████████ 123% │   │ │ ████████████░░░░░░░ 85%        │    │
│ └─────────────────────────────┘   │ └─────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────────────────────┤
│ A14:E22  SUPPLY HEALTH            │ G14:L22  PLAN ALIGNMENT                │
│ ┌─────────────────────────────┐   │ ┌─────────────────────────────────┐    │
│ │ Plan Adherence: 96% (✓)     │   │ │ Demand Plan: $553M              │    │
│ │ ██████████████████░░ 96%    │   │ │ Supply Plan: $548M              │    │
│ │                             │   │ │ Finance Plan: $553M             │    │
│ │ Capacity Util: 84% (✓)      │   │ │ Gap: -$5M (Capacity)            │    │
│ │ ████████████████░░░░ 84%    │   │ │                                 │    │
│ │                             │   │ │ Plan Stability: 92% (✓)         │    │
│ │ Inventory Days: 48 (⚠+3)    │   │ │ Forecast Accuracy: 72% (⚠)      │    │
│ │ ████████████████████░░ 107% │   │ │                                 │    │
│ └─────────────────────────────┘   │ └─────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────────────────────┤
│ A24:P32  24-MONTH OUTLOOK CHART                                            │
│ ┌───────────────────────────────────────────────────────────────────────┐  │
│ │ [Area chart: Revenue trend with confidence bands]                     │  │
│ │ Actuals ████  Plan ░░░░  Budget ────  Prior Year - - -               │  │
│ └───────────────────────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────────────────┤
│ A34:G42  TOP RISKS                │ I34:P42  DECISIONS REQUIRED            │
│ (Top 5 risks with impact scores)  │ (Critical decisions needing approval)  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### KPI Card Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C5 | `=Data_Feeds!B2` | Revenue actual |
| D5 | `=(C5-Data_Feeds!C2)/Data_Feeds!C2` | vs Plan % |
| E5 | `=IF(D5>=0,"✓",IF(D5>=-0.03,"⚠","✗"))` | Status icon |
| C6 | `=C5/Data_Feeds!C2` | % of Plan (for progress bar) |

### Overall Health Score
```
Cell N2 (Overall Status):
=IF(COUNTIF(StatusRange,"✗")>0,"RED",
  IF(COUNTIF(StatusRange,"⚠")>2,"AMBER","GREEN"))

Health Score (0-100):
=(Financial_Score*0.3)+(Customer_Score*0.25)+(Supply_Score*0.25)+(Process_Score*0.2)
```

### Conditional Formatting for KPI Bars
```
Progress Bar (C6):
- Data bar: Green gradient
- Minimum: 0
- Maximum: 1.2 (120% of plan)

Status Icons:
- "✓": Green bold (#2E7D32)
- "⚠": Orange bold (#EF6C00)
- "✗": Red bold (#C62828)
```

---

## SHEET 2: Financial_View

### Section 1: P&L Summary
| Row | Metric | Actual | Plan | Budget | Prior_Yr | vs_Plan | vs_Budget | vs_PY |
|-----|--------|--------|------|--------|----------|---------|-----------|-------|
| 3 | Revenue | =FORMULA | | | | =FORMULA | =FORMULA | =FORMULA |
| 4 | COGS | | | | | | | |
| 5 | Gross_Profit | =B3-B4 | | | | | | |
| 6 | Gross_Margin% | =B5/B3 | | | | | | |
| 7 | OpEx | | | | | | | |
| 8 | EBITDA | =B5-B7 | | | | | | |
| 9 | EBITDA_Margin% | =B8/B3 | | | | | | |

### Key Formulas
```
vs_Plan (F3): =(B3-C3)/C3
vs_Budget (G3): =(B3-D3)/D3
vs_Prior_Year (H3): =(B3-E3)/E3

Variance Status (I3):
=IF(F3>=0,"✓ Favorable",IF(F3>=-0.03,"⚠ Watch","✗ Unfavorable"))
```

### Section 2: Revenue Bridge
```
Budget → Volume → Price/Mix → FX → Other → Actual

Volume Impact: =SUMPRODUCT(Actual_Volume-Budget_Volume,Budget_Price)
Price Impact: =SUMPRODUCT(Actual_Volume,Actual_Price-Budget_Price)
```

### Section 3: Rolling Forecast
| Month | M1 | M2 | M3 | M4 | M5 | M6 | Q3 | Q4 | FY |
|-------|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| Revenue | | | | | | | | | |
| Margin% | | | | | | | | | |
| EBITDA | | | | | | | | | |

---

## SHEET 3: Customer_View

### Section 1: Service Metrics
| Metric | Current | Target | Trend | Status |
|--------|---------|--------|-------|--------|
| OTIF | =Data_Feeds!E2 | =Settings!B10 | =Sparkline | =IF(B3>=C3,"✓","⚠") |
| Perfect_Order | | | | |
| Lead_Time | | | | |
| Fill_Rate | | | | |
| Claims_Rate | | | | |

### Section 2: Top Customer Performance
| Customer | Revenue | YoY_Growth | Service_Level | Satisfaction | Risk_Flag |
|----------|---------|------------|---------------|--------------|-----------|
| Customer_A | =SUMIF | =FORMULA | =VLOOKUP | =VLOOKUP | =IF |
| Customer_B | | | | | |
| ... | | | | | |

### Customer Risk Formula
```
Risk_Flag (F3):
=IF(OR(D3<0.9,E3<3.5,C3<-0.1),"⚠ At Risk",
  IF(AND(D3>=0.95,E3>=4,C3>=0),"★ Strong","OK"))
```

---

## SHEET 4: Operations_View

### Section 1: Supply Performance
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Production_Plan_Adherence | =Data_Feeds!G2 | 95% | =IF(B3>=C3,"✓","⚠") |
| Capacity_Utilization | | 80-85% | =IF(AND(B4>=0.8,B4<=0.85),"✓","⚠") |
| Inventory_Days | | 45 | =IF(B5<=C5,"✓","⚠") |
| Supplier_OTIF | | 95% | =IF(B6>=C6,"✓","⚠") |

### Section 2: Capacity Overview
| Facility | Current_Util | Projected_Q1 | Projected_Q2 | Constraint_Flag |
|----------|--------------|--------------|--------------|-----------------|
| Plant_A | 84% | 87% | 92% | =IF(D3>0.9,"⚠ HIGH","OK") |
| Plant_B | 78% | 82% | 85% | |
| Plant_C | 96% | 98% | 94% | |

### Section 3: Inventory Analysis
| Category | Current_$M | Target_$M | Days_On_Hand | Excess_$M |
|----------|------------|-----------|--------------|-----------|
| Raw_Material | | | =B3/Daily_COGS | =MAX(0,B3-C3) |
| WIP | | | | |
| Finished_Goods | | | | |
| Safety_Stock | | | | |
| TOTAL | =SUM | =SUM | =B7/Daily_COGS | =SUM |

---

## SHEET 5: Risk_Portfolio

### Risk Register Summary
| Risk_ID | Description | Category | Probability | Impact | Score | Owner | Mitigation | Status |
|---------|-------------|----------|-------------|--------|-------|-------|------------|--------|
| R001 | | Supply | H/M/L | H/M/L | =VLOOKUP(D3,ScoreMatrix,2)*VLOOKUP(E3,ScoreMatrix,2) | | | |

### Risk Score Matrix
```
Probability Values: High=3, Medium=2, Low=1
Impact Values: High=3, Medium=2, Low=1
Score = Probability × Impact

Risk Level:
- Score >= 6: Critical (Red)
- Score 4-5: Elevated (Orange)
- Score 2-3: Moderate (Yellow)
- Score 1: Low (Green)
```

### Risk Summary Formulas
```
Critical_Risks: =COUNTIF(F:F,">=6")
Elevated_Risks: =COUNTIFS(F:F,">=4",F:F,"<6")
Open_Mitigations: =COUNTIF(I:I,"In Progress")
```

---

## SHEET 6: Decisions_Required

### Decision Queue
| Decision_ID | Title | Category | Requested_By | Due_Date | Impact_$M | Options | Recommendation | Status |
|-------------|-------|----------|--------------|----------|-----------|---------|----------------|--------|
| D001 | Capacity Investment | CapEx | VP_Ops | [Date] | $4.2M | A/B/C | Option A | Pending |

### Decision Categories
```
- Investment (CapEx)
- Resource Allocation
- Pricing
- Customer/Product
- Supply Chain
- Policy Change
```

### Decision Aging
```
Days_Open (J3):
=TODAY()-Request_Date

Aging_Status (K3):
=IF(J3>14,"⚠ OVERDUE",IF(J3>7,"Aging","Current"))
```

### Decision Authority Matrix
| Decision_Type | < $100K | $100K-$500K | $500K-$1M | > $1M |
|---------------|---------|-------------|-----------|-------|
| CapEx | VP | SVP | CEO | Board |
| OpEx | Dir | VP | SVP | CEO |
| Pricing | VP Sales | SVP | CEO | CEO |

---

## SHEET 7: Data_Feeds

### Source Data Connections
| Row | Metric | Source | Current_Value | Last_Updated | Refresh_Method |
|-----|--------|--------|---------------|--------------|----------------|
| 2 | Revenue_Actual | ERP | =QUERY | =NOW() | Daily |
| 3 | Revenue_Plan | IBP | =LINK | | Weekly |
| 4 | Margin_Actual | ERP | | | Daily |
| 5 | OTIF | WMS | | | Daily |
| 6 | Capacity_Util | MES | | | Daily |
| 7 | Inventory_Days | ERP | | | Daily |

### Power Query Connections
```
// Financial Data Refresh
let
    Source = Sql.Database("server", "IBP_DB"),
    Revenue = Source{[Schema="dbo",Item="vw_Revenue_Monthly"]}[Data],
    CurrentMonth = Table.SelectRows(Revenue, each [Month] = Date.From(DateTime.LocalNow()))
in
    CurrentMonth

// Refresh All Data
Sub RefreshAllData()
    ThisWorkbook.RefreshAll
    Range("Last_Refresh").Value = Now()
End Sub
```

---

## SHEET 8: Settings

### Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Report_Month | =EOMONTH(TODAY(),-1) | Reporting period |
| Currency | USD | Display currency |
| Revenue_Target | =Budget!$B$2 | Annual budget |
| OTIF_Target | 0.95 | 95% target |
| Margin_Target | 0.33 | 33% target |
| Inventory_Target | 45 | Days target |
| Capacity_Optimal_Low | 0.80 | Lower bound |
| Capacity_Optimal_High | 0.85 | Upper bound |
| Forecast_Accuracy_Target | 0.75 | 75% target |
| Plan_Stability_Target | 0.90 | 90% target |

### Alert Thresholds
| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| vs_Plan | >=0% | -3% to 0% | <-3% |
| OTIF | >=95% | 90-95% | <90% |
| Capacity | 75-88% | 88-92% | >92% |
| Inventory | <=Target | +1-5 days | >+5 days |

---

## NAMED RANGES

```
Name: KPI_Revenue
Refers to: =Financial_View!$B$3

Name: KPI_OTIF
Refers to: =Customer_View!$B$3

Name: KPI_Capacity
Refers to: =Operations_View!$B$4

Name: OpenRisks
Refers to: =Risk_Portfolio!$A$3:$I$100

Name: PendingDecisions
Refers to: =Decisions_Required!$A$3:$K$50

Name: OverallHealth
Refers to: =EXECUTIVE_SUMMARY!$N$2
```

---

## INTEGRATION POINTS

```
1. Consensus_Demand_Workbook.xlsx
   - Pull: Demand plan totals
   - Pull: Key assumptions

2. Supply_Capacity_Planning.xlsx
   - Pull: Capacity utilization
   - Pull: Constraint alerts

3. Financial_Plan_vs_Actual.xlsx
   - Pull: All financial metrics
   - Pull: Variance analysis

4. Action_Item_Tracker.xlsx
   - Push: New actions from decisions
   - Pull: Action completion status

5. Risk_Register.xlsx
   - Pull: Top risks
   - Sync: Risk scores
```

---

## REFRESH & AUTOMATION

### Auto-Refresh Schedule
```
Daily:
- Financial actuals
- Customer service metrics
- Inventory levels

Weekly:
- Plan alignment
- Forecast accuracy
- Risk updates

Monthly:
- Full dashboard rebuild
- Prior period lock
```

### VBA Refresh Macro
```vba
Sub RefreshDashboard()
    Application.ScreenUpdating = False

    ' Refresh external data
    ThisWorkbook.RefreshAll

    ' Update timestamp
    Range("Last_Refresh").Value = Now()

    ' Check for alerts
    Call CheckAlerts

    Application.ScreenUpdating = True
    MsgBox "Dashboard refreshed at " & Now()
End Sub
```

---

**Template Version:** Enhanced Executive Dashboard 2.0
**Refresh Frequency:** Daily (automated), Full review monthly
