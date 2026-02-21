# Inventory Analysis Dashboard - Enhanced Excel Workbook
## Multi-Echelon Inventory Optimization with SLOB Management & Service Level Optimization

---

## Overview
Enterprise inventory analytics workbook featuring ABC-XYZ segmentation, safety stock optimization, days-of-supply analysis, SLOB (Slow/Obsolete) identification, stockout risk monitoring, and service level correlation. Designed for multi-location inventory visibility with automated policy recommendations.

---

## Design Theme: "Inventory Intelligence"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Emerald (#059669) |
| Accent | Slate (#475569) |
| Optimal | Green (#10B981) |
| Warning | Amber (#F59E0B) |
| Critical | Red (#EF4444) |
| SLOB | Purple (#7C3AED) |
| Font - Headers | Segoe UI Semibold, 11pt |

---

# SHEET 1: SETTINGS & CONFIGURATION

## Inventory Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| Target Service Level | 95% | Overall OTIF target |
| Safety Stock Method | Statistical | Statistical/Fixed/% of Demand |
| Z-Score (95%) | 1.645 | For safety stock calculation |
| Z-Score (99%) | 2.326 | For critical items |
| Review Period (Days) | 30 | Inventory review cycle |
| Min DOS Warning | 14 | Days below this = warning |
| Min DOS Critical | 7 | Days below this = critical |
| SLOB Threshold - Slow | 90 | Days without movement |
| SLOB Threshold - Obsolete | 180 | Days = obsolete classification |
| E&O Reserve Rate | 50% | Reserve % for obsolete |

## ABC Classification Thresholds

| Class | Revenue Cumulative % | Service Level Target | Review Frequency |
|-------|---------------------|---------------------|------------------|
| A | 0-80% | 98% | Weekly |
| B | 80-95% | 95% | Bi-weekly |
| C | 95-100% | 90% | Monthly |

## XYZ Classification (Variability)

| Class | CV Range | Forecast Reliability | Inventory Strategy |
|-------|----------|---------------------|-------------------|
| X | 0-0.5 | High | Lean inventory |
| Y | 0.5-1.0 | Medium | Buffer stock |
| Z | >1.0 | Low | Safety stock heavy |

---

# SHEET 2: EXECUTIVE DASHBOARD

## KPI Tiles (Row 3-12)

| KPI | Formula | Conditional Format |
|-----|---------|-------------------|
| Total Inventory Value ($M) | `=SUM(Inventory_Data!Value_Col)/1000000` | — |
| Inventory Turns | `=COGS_Annual/AVG_Inventory` | ≥6 GREEN, 4-6 YELLOW, <4 RED |
| Days of Supply (DOS) | `=AVG_INVENTORY/(COGS_Annual/365)` | Target ±10% GREEN |
| Target DOS | From Settings | — |
| DOS Variance | `=(Actual_DOS-Target_DOS)/Target_DOS` | ±10% GREEN |
| Fill Rate % | `=Lines_Filled/Lines_Ordered` | ≥95% GREEN |
| Stockout Risk Items | `=COUNTIF(Inventory_Data!Risk_Col,"Critical")+COUNTIF(Inventory_Data!Risk_Col,"High")` | >10 = RED |
| SLOB Value ($K) | `=SUM(SLOB!Value_Col)` | — |
| SLOB % of Total | `=SLOB_Value/Total_Inventory` | <5% GREEN, 5-10% YELLOW, >10% RED |
| E&O Reserve Required | `=SUMPRODUCT(SLOB!Obsolete_Value,Settings!E_O_Rate)` | — |
| Excess Inventory ($K) | `=SUMIF(Inventory_Data!DOS_Col,">"&Target*1.5,Inventory_Data!Value_Col)` | — |
| Perfect Inventory Score | Composite score | ≥80 GREEN |

## Category Summary (Row 16+)

| Category | Value ($K) | % of Total | DOS | Turns | SLOB % | Service % |
|----------|-----------|-----------|-----|-------|--------|----------|
| Raw Materials | Formula | Formula | Formula | Formula | Formula | Formula |
| WIP | Formula | Formula | Formula | Formula | Formula | Formula |
| Finished Goods | Formula | Formula | Formula | Formula | Formula | Formula |
| Safety Stock | Formula | Formula | Formula | Formula | Formula | Formula |

---

# SHEET 3: INVENTORY DATA (Master)

## Column Layout (400 SKUs)

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | SKU_ID | Unique identifier |
| B | Product Name | Text |
| C | Category | Dropdown: RM/WIP/FG |
| D | Product Family | Dropdown |
| E | Location | Dropdown: Plant/DC |
| F | Unit Cost ($) | Number |
| G | Current Qty (Units) | Number |
| H | Current Value ($K) | `=F3*G3/1000` |
| I | Avg Monthly Demand | From demand plan |
| J | Avg Daily Demand | `=I3/30` |
| K | **Days of Supply** | `=IF(J3>0,G3/J3,"No Demand")` |
| L | Target DOS | Based on ABC class |
| M | DOS Variance | `=(K3-L3)/L3` |
| N | **DOS Status** | `=IF(K3<Settings!Min_Critical,"CRITICAL",IF(K3<Settings!Min_Warning,"LOW",IF(K3>L3*1.5,"EXCESS","OK")))` |
| O | Last Receipt Date | Date |
| P | Last Issue Date | Date |
| Q | Days Since Movement | `=TODAY()-MAX(O3,P3)` |
| R | **Movement Status** | `=IF(Q3>Settings!Obsolete_Days,"OBSOLETE",IF(Q3>Settings!Slow_Days,"SLOW MOVING","ACTIVE"))` |
| S | LTM Usage (Units) | Last 12 months |
| T | LTM Usage ($K) | `=S3*F3/1000` |
| U | Annual Revenue | For ABC classification |
| V | CV (Variability) | `=STDEV(Monthly_History)/AVERAGE(Monthly_History)` |
| W | **ABC Class** | See formula below |
| X | **XYZ Class** | See formula below |
| Y | **ABC-XYZ Segment** | `=W3&X3` |
| Z | Service Level Target | `=VLOOKUP(W3,Settings!ABC_Targets,2,FALSE)` |
| AA | Safety Stock (Units) | See formula below |
| AB | Reorder Point | `=AA3+J3*Lead_Time` |
| AC | Lead Time (Days) | From supplier data |
| AD | **Stockout Risk** | `=IF(G3<AB3,IF(G3<AA3,"CRITICAL","HIGH"),IF(G3<AB3*1.2,"MEDIUM","LOW"))` |

### ABC Classification Formula (Column W)
```excel
=IF(SUMPRODUCT(($U$3:$U$402>=U3)*($U$3:$U$402))/SUM($U$3:$U$402)<=0.8,"A",
  IF(SUMPRODUCT(($U$3:$U$402>=U3)*($U$3:$U$402))/SUM($U$3:$U$402)<=0.95,"B","C"))
```

### XYZ Classification Formula (Column X)
```excel
=IF(V3<=0.5,"X",IF(V3<=1,"Y","Z"))
```

### Safety Stock Formula (Column AA)
```excel
=Settings!Z_Score * SQRT(AC3 * POWER(Demand_StdDev,2) + POWER(I3,2) * POWER(LT_StdDev,2))
```
*Statistical safety stock based on demand and lead time variability*

---

# SHEET 4: DOS TREND ANALYSIS

## 6-Month Days of Supply Trend

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | SKU list |
| B | Product Name | Lookup |
| C | Category | Lookup |
| D-I | Month -6 through Month -1 DOS | Historical DOS values |
| J | Current DOS | `=VLOOKUP(A3,Inventory_Data!A:K,11,FALSE)` |
| K | Target DOS | Lookup |
| L | 6-Month Avg DOS | `=AVERAGE(D3:J3)` |
| M | DOS Trend | `=SLOPE(D3:J3,{1,2,3,4,5,6,7})` |
| N | **Trend Direction** | `=IF(M3>2,"Increasing",IF(M3<-2,"Decreasing","Stable"))` |
| O | Variance from Target | `=(J3-K3)/K3` |
| P | Projected DOS (Next Mo) | `=J3+M3` |
| Q | Action Required | `=IF(AND(N3="Increasing",J3>K3*1.3),"Reduce Receipts",IF(AND(N3="Decreasing",J3<K3*0.7),"Expedite","Monitor"))` |

### Conditional Formatting - DOS Column
- DOS < Min Critical: Red background (#FEE2E2)
- DOS < Min Warning: Orange background (#FFEDD5)
- DOS within ±20% of target: Green background (#D1FAE5)
- DOS > Target × 1.5: Yellow background (#FEF3C7)
- DOS > Target × 2: Purple background (excess) (#F3E8FF)

---

# SHEET 5: ABC-XYZ ANALYSIS

## Segmentation Matrix

| | X (Low Variability) | Y (Medium) | Z (High Variability) |
|-|-------------------|-----------|---------------------|
| **A (High Value)** | AX: Formula | AY: Formula | AZ: Formula |
| **B (Medium)** | BX: Formula | BY: Formula | BZ: Formula |
| **C (Low Value)** | CX: Formula | CY: Formula | CZ: Formula |

### Segment Count Formula
```excel
AX: =COUNTIFS(Inventory_Data!W:W,"A",Inventory_Data!X:X,"X")
AY: =COUNTIFS(Inventory_Data!W:W,"A",Inventory_Data!X:X,"Y")
... etc.
```

### Segment Strategy Table

| Segment | SKU Count | Value % | Strategy | Review | Safety Stock |
|---------|----------|---------|----------|--------|-------------|
| AX | Formula | Formula | Just-in-Time | Daily | Minimal |
| AY | Formula | Formula | VMI/Kanban | Weekly | Statistical |
| AZ | Formula | Formula | Strategic Buffer | Weekly | High |
| BX | Formula | Formula | Standard Replenish | Weekly | Calculated |
| BY | Formula | Formula | Periodic Review | Bi-weekly | Statistical |
| BZ | Formula | Formula | Buffer Stock | Bi-weekly | High |
| CX | Formula | Formula | Economic Order | Monthly | Minimal |
| CY | Formula | Formula | Periodic Order | Monthly | Fixed |
| CZ | Formula | Formula | Stock to Order | As needed | None |

---

# SHEET 6: SAFETY STOCK ANALYSIS

## Safety Stock Optimization

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | SKU list |
| B | Product Name | Lookup |
| C | ABC Class | Lookup |
| D | Target Service Level | `=VLOOKUP(C3,Settings!SL_Targets,2,FALSE)` |
| E | Z-Score | `=NORM.S.INV(D3)` |
| F | Avg Daily Demand | From Inventory Data |
| G | Demand Std Dev | `=STDEV(Monthly_Demand_History)/SQRT(30)` |
| H | Lead Time (Days) | From Supplier data |
| I | Lead Time Std Dev | `=STDEV(Actual_Lead_Times)` |
| J | **Calculated SS (Units)** | `=E3*SQRT(H3*G3^2+F3^2*I3^2)` |
| K | Current SS (Units) | From inventory data |
| L | SS Difference | `=J3-K3` |
| M | SS $ Difference | `=L3*Unit_Cost` |
| N | **Recommendation** | `=IF(L3>K3*0.2,"↑ Increase SS",IF(L3<-K3*0.2,"↓ Reduce SS","✓ Appropriate"))` |
| O | Investment/Release ($K) | `=M3/1000` |
| P | Service Level Impact | If changed |

### Summary Metrics
- Total Current SS Value: `=SUMPRODUCT(Inventory_Data!AA:AA,Inventory_Data!F:F)`
- Total Calculated SS Value: `=SUMPRODUCT(Safety_Stock!J:J,Inventory_Data!F:F)`
- Net Investment/Release: `=Calculated-Current`
- SKUs Needing Increase: `=COUNTIF(N:N,"*Increase*")`
- SKUs Needing Decrease: `=COUNTIF(N:N,"*Reduce*")`

---

# SHEET 7: SLOB ANALYSIS

## Slow-Moving and Obsolete Inventory

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | Filtered: Slow or Obsolete only |
| B | Product Name | Lookup |
| C | Category | Lookup |
| D | Location | Lookup |
| E | On-Hand Qty | Current quantity |
| F | On-Hand Value ($K) | `=E3*Unit_Cost/1000` |
| G | Days Since Last Movement | From Inventory Data |
| H | **SLOB Classification** | `=IF(G3>Settings!Obsolete_Days,"Obsolete",IF(G3>Settings!Slow_Days,"Slow Moving",""))` |
| I | Last 12M Usage | Historical usage |
| J | Months of Stock | `=IF(I3>0,E3/(I3/12),"∞")` |
| K | Est. Future Demand | From forecast |
| L | Excess Qty | `=MAX(0,E3-K3*12)` |
| M | Excess Value ($K) | `=L3*Unit_Cost/1000` |
| N | **Disposition** | Dropdown: Sell/Return/Scrap/Rework/Hold |
| O | Recovery Rate % | Based on disposition |
| P | Est. Recovery ($K) | `=M3*O3` |
| Q | Write-off Required ($K) | `=M3-P3` |
| R | Disposition Owner | Dropdown |
| S | Target Date | Date |
| T | Status | Not Started/In Progress/Complete |

### Summary Metrics
| Metric | Formula |
|--------|---------|
| Total SLOB Value | `=SUM(F:F)` |
| Slow Moving Value | `=SUMIF(H:H,"Slow Moving",F:F)` |
| Obsolete Value | `=SUMIF(H:H,"Obsolete",F:F)` |
| Est. Total Recovery | `=SUM(P:P)` |
| Est. Total Write-off | `=SUM(Q:Q)` |
| % of Total Inventory | `=Total_SLOB/Total_Inventory` |

---

# SHEET 8: STOCKOUT RISK

## Items at Risk of Stockout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | Filtered: Risk = Critical or High |
| B | Product Name | Lookup |
| C | ABC Class | Lookup |
| D | Current Qty | On-hand |
| E | Safety Stock | From calculations |
| F | Daily Demand | Average |
| G | Days of Supply | `=D3/F3` |
| H | Days Until Stockout | `=MAX(0,(D3-E3)/F3)` |
| I | **Risk Level** | `=IF(H3<7,"CRITICAL",IF(H3<14,"HIGH",IF(H3<21,"MEDIUM","LOW")))` |
| J | Open PO Qty | Outstanding orders |
| K | PO Due Date | Expected receipt |
| L | Coverage with PO | `=(D3+J3)/F3` |
| M | **Action Required** | `=IF(AND(I3="CRITICAL",J3=0),"EXPEDITE/EMERGENCY PO",IF(I3="CRITICAL","EXPEDITE PO",IF(I3="HIGH","MONITOR PO","STANDARD")))` |
| N | Alternative Source | Backup supplier |
| O | Alt Lead Time | Days |
| P | Demand Priority | Customer priorities affected |
| Q | Service Impact % | Est. fill rate if stockout |
| R | Action Owner | Dropdown |
| S | Resolution Status | Open/Mitigating/Resolved |

### Conditional Formatting
- Risk = CRITICAL: Red background, bold text
- Risk = HIGH: Orange background
- Days Until Stockout < 7: Red text
- No Open PO for Critical: Additional red border

---

# SHEET 9: LOCATION VIEW

## Inventory by Location/Plant/DC

| Col | Header | Formula |
|-----|--------|---------|
| A | Location | Plant/DC list |
| B | Location Type | Plant/DC/Hub |
| C | Total SKUs | `=COUNTIF(Inventory_Data!E:E,A3)` |
| D | Total Value ($M) | `=SUMIF(Inventory_Data!E:E,A3,Inventory_Data!H:H)/1000` |
| E | Avg DOS | `=AVERAGEIF(Inventory_Data!E:E,A3,Inventory_Data!K:K)` |
| F | Target DOS | Location-specific target |
| G | DOS Variance % | `=(E3-F3)/F3` |
| H | Stockout Risk Items | `=COUNTIFS(Inventory_Data!E:E,A3,Inventory_Data!AD:AD,"CRITICAL")+COUNTIFS(Inventory_Data!E:E,A3,Inventory_Data!AD:AD,"HIGH")` |
| I | SLOB Value ($K) | `=SUMIFS(SLOB!F:F,SLOB!D:D,A3)` |
| J | SLOB % | `=I3/D3` |
| K | Warehouse Utilization % | Space used |
| L | Capacity Status | `=IF(K3>0.95,"FULL",IF(K3>0.85,"TIGHT",IF(K3>0.7,"OPTIMAL","AVAILABLE")))` |
| M | Location Health Score | Composite |

---

# SHEET 10: INVENTORY PROJECTION

## 6-Month Forward Projection

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | SKU list |
| B | Product Name | Lookup |
| C | Current Qty | On-hand |
| D | Safety Stock | Target |
| E-J | Month 1-6 Demand | From demand plan |
| K-P | Month 1-6 Receipts | From supply plan |
| Q-V | Month 1-6 Ending Inventory | `=Prior_Ending + Receipts - Demand` |
| W-AB | Month 1-6 DOS | `=Ending_Inv/Next_Month_Demand*30` |
| AC | Min DOS (6 months) | `=MIN(W3:AB3)` |
| AD | Max DOS (6 months) | `=MAX(W3:AB3)` |
| AE | Stockout Month? | `=IF(MIN(Q3:V3)<0,MATCH(TRUE,INDEX(Q3:V3<0,0),0),"None")` |
| AF | Excess Month? | `=IF(MAX(W3:AB3)>Target*2,MATCH(TRUE,INDEX(W3:AB3>Target*2,0),0),"None")` |
| AG | Action Required | Based on stockout/excess flags |

---

# SHEET 11: POLICY RECOMMENDATIONS

## Inventory Policy Optimization

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU_ID | SKU |
| B | ABC-XYZ Segment | From Analysis |
| C | Current Policy | Manual entry |
| D | **Recommended Policy** | Based on segment |
| E | Current Reorder Point | From data |
| F | Recommended ROP | Calculated |
| G | Current Order Qty | From data |
| H | Recommended EOQ | `=SQRT(2*Annual_Demand*Order_Cost/(Holding_Cost*Unit_Cost))` |
| I | Current SS | From data |
| J | Recommended SS | From Safety Stock sheet |
| K | Current Turns | Actual |
| L | Target Turns | Based on segment |
| M | Investment Change ($K) | `=((F3+J3)-(E3+I3))*Unit_Cost/1000` |
| N | Service Level Change | Expected improvement |
| O | Priority | `=IF(ABC="A",3,IF(ABC="B",2,1))*IF(Investment_Impact>10,2,1)` |
| P | Implementation Status | Not Started/In Progress/Complete |

### Policy by Segment

| Segment | Policy | ROP Formula | SS Formula |
|---------|--------|------------|-----------|
| AX | Just-in-Time | LT × Daily Demand | Minimal (1-3 days) |
| AY | Continuous Review | LT × Demand + SS | Statistical |
| AZ | Strategic Buffer | LT × Demand + High SS | 2× Statistical |
| BX | Periodic Review | Review Period Demand + SS | Calculated |
| BY | Min-Max | Max - (Demand × LT) | Statistical |
| BZ | Buffer Stock | Demand × (LT + Buffer) | 1.5× Statistical |
| CX | EOQ | Minimal | Order-based |
| CY | Periodic Order | Period demand | Fixed |
| CZ | Stock to Order | Customer order | None |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| Inventory_Master | Inventory_Data!A:AD | Full inventory data |
| Inventory_Value | Dashboard!B3 | Total value |
| Inventory_Turns | Dashboard!B4 | Turns calculation |
| Inventory_DOS | Dashboard!B5 | Overall DOS |
| SLOB_Data | SLOB!A:T | SLOB details |
| Stockout_Risk | Stockout_Risk!A:S | At-risk items |
| Safety_Stock_Calc | Safety_Stock!A:P | SS analysis |
| ABC_XYZ_Matrix | ABC_XYZ!A:I | Segmentation |

---

# VBA AUTOMATION

```vba
Sub RefreshInventoryDashboard()
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    Call CalculateABCXYZ
    Call CalculateSafetyStock
    Call IdentifySLOB
    Call AssessStockoutRisk
    Call UpdateProjections

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Inventory dashboard refreshed." & vbCrLf & _
           "Total Value: $" & Format(Range("Inventory_Value").Value/1000000, "0.0") & "M" & vbCrLf & _
           "Turns: " & Format(Range("Inventory_Turns").Value, "0.0") & vbCrLf & _
           "DOS: " & Format(Range("Inventory_DOS").Value, "0") & " days", _
           vbInformation, "Inventory Analysis Complete"
End Sub

Sub AlertStockoutRisk()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Stockout_Risk")

    Dim critical As Long, high As Long
    critical = WorksheetFunction.CountIf(ws.Range("I:I"), "CRITICAL")
    high = WorksheetFunction.CountIf(ws.Range("I:I"), "HIGH")

    If critical > 0 Then
        MsgBox "⚠ ALERT: " & critical & " items at CRITICAL stockout risk!" & vbCrLf & _
               high & " items at HIGH risk." & vbCrLf & vbCrLf & _
               "Immediate action required.", vbCritical, "Stockout Alert"
    ElseIf high > 0 Then
        MsgBox "⚡ WARNING: " & high & " items at HIGH stockout risk." & vbCrLf & _
               "Review and take action.", vbExclamation, "Inventory Warning"
    Else
        MsgBox "All items within acceptable risk levels.", vbInformation
    End If
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Capacity_Planning_ENHANCED | Inventory for capacity planning | Named range Inventory_Master |
| Supply_Constraints_ENHANCED | Stockout constraints | Named range Stockout_Risk |
| Working_Capital_ENHANCED | Inventory value for WC | Named range Inventory_Value |
| Plan_vs_Actual_ENHANCED | Inventory variance analysis | Cross-reference |
| Executive_Dashboard_ENHANCED | KPI summary | Named range integration |
| IBP_Master_Integration | Central hub | Power Query connection |

---

*Comprehensive inventory optimization with ABC-XYZ segmentation, safety stock calculation, SLOB management, and stockout risk monitoring.*
