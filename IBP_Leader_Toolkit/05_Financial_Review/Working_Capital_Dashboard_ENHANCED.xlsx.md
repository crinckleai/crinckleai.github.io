# Working Capital Dashboard - Enhanced Excel Workbook
## Cash Conversion Cycle Optimization & Working Capital Management

---

## Overview
Comprehensive working capital management workbook with DSO/DIO/DPO analysis, cash conversion cycle tracking, AR/AP aging, inventory optimization, and forward projections. Integrates with inventory and financial planning for holistic working capital visibility.

---

## Design Theme: "Capital Flow"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Green (#16A34A) |
| Accent | Slate (#475569) |
| Positive Cash | Emerald (#059669) |
| Negative Cash | Red (#EF4444) |
| Warning | Amber (#F59E0B) |

---

# SHEET 1: SETTINGS

## Working Capital Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| DSO Target | 45 | Days Sales Outstanding target |
| DIO Target | 60 | Days Inventory Outstanding target |
| DPO Target | 45 | Days Payables Outstanding target |
| CCC Target | 60 | Cash Conversion Cycle target |
| AR Aging Buckets | Current, 31-60, 61-90, >90 | Standard buckets |
| WC % Revenue Target | 18% | Working capital as % of revenue |

---

# SHEET 2: WORKING CAPITAL DASHBOARD

## KPI Tiles

| KPI | Formula | Format |
|-----|---------|--------|
| Net Working Capital ($M) | `=AR_Balance + Inventory_Balance - AP_Balance` | Currency |
| WC % of Revenue | `=NWC / LTM_Revenue` | Percentage |
| Cash Conversion Cycle | `=DSO + DIO - DPO` | Days |
| DSO (Days Sales Outstanding) | `=AVG_AR / (Revenue/365)` | Days |
| DIO (Days Inventory Outstanding) | `=AVG_Inventory / (COGS/365)` | Days |
| DPO (Days Payables Outstanding) | `=AVG_AP / (COGS/365)` | Days |
| CCC vs Target | `=CCC - Target_CCC` | Days variance |
| Cash Tied Up ($M) | `=CCC_Variance * Daily_COGS / 1000000` | Currency |

### Conditional Formatting
- CCC ≤ Target: Green (#D1FAE5)
- CCC > Target by ≤10 days: Amber (#FEF3C7)
- CCC > Target by >10 days: Red (#FEE2E2)

---

# SHEET 3: COMPONENTS ANALYSIS

## Working Capital Components

| Col | Header | Formula |
|-----|--------|---------|
| A | Component | AR/Inventory/AP |
| B | Current Balance ($K) | From balance sheet |
| C | Prior Month ($K) | Prior period |
| D | Change ($K) | `=B3-C3` |
| E | Change % | `=(B3-C3)/C3` |
| F | Prior Year ($K) | Year ago |
| G | YoY Change ($K) | `=B3-F3` |
| H | YoY % | `=(B3-F3)/F3` |
| I | % of NWC | `=B3/SUM($B$3:$B$5)` |
| J | Days Outstanding | DSO/DIO/DPO |
| K | Target Days | From Settings |
| L | Days Variance | `=J3-K3` |
| M | $ Impact of Variance | `=L3*Daily_Rate` |
| N | Trend (3M) | Improving/Stable/Worsening |

---

# SHEET 4: CCC TREND

## Cash Conversion Cycle Trend Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | Month identifier |
| B | DSO | Monthly DSO |
| C | DIO | Monthly DIO |
| D | DPO | Monthly DPO |
| E | CCC | `=B3+C3-D3` |
| F | Target CCC | From Settings |
| G | Variance | `=E3-F3` |
| H | Cash Impact ($K) | `=G3*Daily_COGS` |
| I | Cumulative Impact | `=SUM($H$3:H3)` |
| J | Rolling 3M Avg | `=AVERAGE(E1:E3)` |
| K | Trend | `=IF(J3<J2,"Improving",IF(J3>J2,"Worsening","Stable"))` |

### Chart Data
- Line chart: DSO, DIO, DPO, CCC over 12 months
- Reference line at Target CCC

---

# SHEET 5: AR ANALYSIS

## Accounts Receivable Aging

| Col | Header | Formula |
|-----|--------|---------|
| A | Customer | Customer name |
| B | Total AR ($K) | Total outstanding |
| C | Current (0-30) | `=SUMIF(Invoice_Age,"<=30",Amount)` |
| D | 31-60 Days | `=SUMIFS(Amount,Age,">30",Age,"<=60")` |
| E | 61-90 Days | `=SUMIFS(Amount,Age,">60",Age,"<=90")` |
| F | >90 Days | `=SUMIF(Age,">90",Amount)` |
| G | % Past Due | `=(D3+E3+F3)/B3` |
| H | Weighted DSO | `=(C3*15+D3*45+E3*75+F3*120)/B3` |
| I | Credit Limit | Credit limit |
| J | % of Limit Used | `=B3/I3` |
| K | Risk Rating | `=IF(G3>0.3,"High",IF(G3>0.1,"Medium","Low"))` |
| L | Collection Status | On Track/At Risk/Past Due |
| M | Last Payment Date | Date |
| N | Days Since Payment | `=TODAY()-M3` |

### Summary Metrics
```excel
Total AR: =SUM(B:B)
% Current: =SUMIF(K:K,"Current")/Total_AR
% Past Due: =1 - %_Current
Top 10 Customers: =SUMPRODUCT(LARGE(B:B,{1,2,3,4,5,6,7,8,9,10}))
Concentration Risk: =Top_10/Total_AR
```

---

# SHEET 6: INVENTORY ANALYSIS

## Inventory by Category with DOS

| Col | Header | Formula |
|-----|--------|---------|
| A | Category | RM/WIP/FG |
| B | Value ($K) | Current value |
| C | % of Total | `=B3/SUM($B$3:$B$5)` |
| D | COGS (Annual) | Cost of goods sold |
| E | Daily COGS | `=D3/365` |
| F | DOS | `=B3/E3` |
| G | Target DOS | From Settings |
| H | Variance (Days) | `=F3-G3` |
| I | Excess Value ($K) | `=MAX(0,H3)*E3` |
| J | Turns | `=D3/B3` |
| K | Target Turns | From Settings |
| L | SLOB Value ($K) | From Inventory sheet |
| M | SLOB % | `=L3/B3` |

### Inventory Optimization
```excel
Total Excess Inventory: =SUM(I:I)
Potential Cash Release: =Total_Excess
Turn Improvement Value: =(Target_Turns-Actual_Turns)*COGS/Target_Turns
```

---

# SHEET 7: AP ANALYSIS

## Accounts Payable Aging

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier | Supplier name |
| B | Total AP ($K) | Total outstanding |
| C | Current (0-30) | Current invoices |
| D | 31-60 Days | Aging bucket |
| E | >60 Days | Aging bucket |
| F | Payment Terms | Net 30/45/60 |
| G | Target Payment Date | `=Invoice_Date + Terms` |
| H | Days Until Due | `=G3-TODAY()` |
| I | Early Payment Discount | % available |
| J | Discount Value ($K) | `=B3*I3` |
| K | APR Equivalent | `=I3/(1-I3)*365/(Terms-Discount_Days)` |
| L | Take Discount? | `=IF(K3>Cost_of_Capital,"Yes","No")` |
| M | Stretched AP ($K) | Amount beyond terms |
| N | Supplier Risk | Risk of supply disruption |

### AP Optimization
```excel
Total AP: =SUM(B:B)
Avg DPO: =Total_AP/(COGS/365)
Discount Opportunity: =SUMIF(L:L,"Yes",J:J)
Stretch Opportunity: =(Target_DPO-Current_DPO)*Daily_COGS
```

---

# SHEET 8: PROJECTION

## 6-Month Working Capital Projection

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | M1 through M6 |
| B | Revenue | From forecast |
| C | COGS | From forecast |
| D | Projected AR | `=Revenue_LTM * (DSO_Target/365)` |
| E | Projected Inventory | `=COGS_Annual * (DIO_Target/365)` |
| F | Projected AP | `=COGS_Annual * (DPO_Target/365)` |
| G | Projected NWC | `=D3+E3-F3` |
| H | WC Change | `=G3-G2` |
| I | Cash Impact | `=-H3` (negative WC increase = cash outflow) |
| J | Cumulative Cash | `=SUM($I$3:I3)` |

---

# SHEET 9: IMPROVEMENT INITIATIVES

## Working Capital Improvement Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Initiative ID | Auto-number |
| B | Component | AR/Inventory/AP |
| C | Initiative | Description |
| D | Target Improvement ($K) | Expected benefit |
| E | Actual Improvement ($K) | Realized benefit |
| F | % Complete | `=E3/D3` |
| G | Start Date | Date |
| H | Target Date | Date |
| I | Status | On Track/At Risk/Complete |
| J | Owner | Responsible person |
| K | Days Impact | Days improvement |
| L | Cash Released ($K) | `=K3*Daily_Rate` |

---

# SHEET 10: CASH FLOW IMPACT

## Operating Cash Flow with WC Changes

| Col | Header | Formula |
|-----|--------|---------|
| A | Period | Month |
| B | Operating Income | From P&L |
| C | D&A (Add-back) | Non-cash |
| D | AR Change | `=Prior_AR - Current_AR` |
| E | Inventory Change | `=Prior_Inv - Current_Inv` |
| F | AP Change | `=Current_AP - Prior_AP` |
| G | Total WC Change | `=D3+E3+F3` |
| H | Operating Cash Flow | `=B3+C3+G3` |
| I | OCF Margin % | `=H3/Revenue` |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| WC_NWC | Dashboard!B3 | Net working capital |
| WC_CCC | Dashboard!B5 | Cash conversion cycle |
| WC_DSO | Dashboard!B6 | Days sales outstanding |
| WC_DIO | Dashboard!B7 | Days inventory outstanding |
| WC_DPO | Dashboard!B8 | Days payables outstanding |
| WC_AR_Total | AR_Analysis!Total | Total AR |
| WC_Inv_Total | Inventory!Total | Total inventory |
| WC_AP_Total | AP_Analysis!Total | Total AP |

---

# VBA AUTOMATION

```vba
Sub RefreshWorkingCapital()
    Application.ScreenUpdating = False

    ' Calculate all sheets
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("AR_Analysis").Calculate
    ThisWorkbook.Sheets("Inventory_Analysis").Calculate
    ThisWorkbook.Sheets("AP_Analysis").Calculate

    ' Update CCC trend
    Call UpdateCCCTrend

    Application.ScreenUpdating = True

    MsgBox "Working Capital Dashboard Updated" & vbCrLf & _
           "NWC: $" & Format(Range("WC_NWC").Value/1000, "#,##0") & "M" & vbCrLf & _
           "CCC: " & Range("WC_CCC").Value & " days", vbInformation
End Sub

Sub AlertCCCVariance()
    Dim ccc As Double, target As Double
    ccc = Range("WC_CCC").Value
    target = Range("Settings!B6").Value

    If ccc > target + 10 Then
        MsgBox "⚠ CCC is " & (ccc - target) & " days above target!" & vbCrLf & _
               "Cash impact: $" & Format((ccc-target)*Range("Daily_COGS").Value/1000, "#,##0") & "K", _
               vbExclamation, "Working Capital Alert"
    End If
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Inventory_Analysis_ENHANCED | Inventory value and DOS | Named range WC_Inv_Total |
| Plan_vs_Actual_ENHANCED | Financial actuals | Cross-reference |
| Executive_Dashboard_ENHANCED | WC KPIs | Named range WC_CCC |
| Rolling_Forecast_ENHANCED | WC projections | Named range integration |
| IBP_Master_Integration | Central hub | Power Query |

---

*Comprehensive working capital management with CCC optimization, component analysis, and cash flow impact tracking.*
