# Statistical Forecast Template - Enhanced Excel Workbook

## Overview
Advanced statistical forecasting workbook with automated demand pattern classification, multi-model comparison, outlier management, seasonality analysis, and error metrics. Provides the analytical foundation for the IBP consensus demand process.

---

## Design Theme: "Royal Analytics"

| Element | Specification |
|---------|--------------|
| Primary Color | Royal Blue (#2563EB) |
| Secondary Color | Orange (#F97316) |
| Accent | Slate (#475569) |
| Success | Emerald (#059669) |
| Warning | Amber (#F59E0B) |
| Critical | Red (#EF4444) |
| Font - Headers | Segoe UI Semibold, 11pt |
| Font - Body | Segoe UI, 10pt |
| Row Banding | White / Light Blue (#EFF6FF) |

---

## Sheet 1: Configuration

### Forecast Parameters

| Parameter | Default Value | Description |
|-----------|--------------|-------------|
| Forecast Horizon (Months) | 12 | Forward-looking period |
| History Depth (Months) | 36 | Historical data used |
| Outlier Threshold (Z-Score) | 3.0 | Standard deviations for outlier detection |
| Smoothing Alpha (Level) | 0.3 | Exponential smoothing level |
| Smoothing Beta (Trend) | 0.1 | Exponential smoothing trend |
| Smoothing Gamma (Season) | 0.2 | Exponential smoothing seasonality |
| Confidence Interval | 95% | Prediction interval |
| Z-Score for CI | 1.96 | For 95% confidence |
| CV Threshold (Smooth vs Erratic) | 0.5 | Coefficient of variation cutoff |
| ADI Threshold (Continuous vs Intermittent) | 1.32 | Average demand interval cutoff |

### Model Definitions

| Model Code | Model Name | Best For |
|-----------|-----------|----------|
| SMA | Simple Moving Average | Stable, no trend |
| WMA | Weighted Moving Average | Recent data emphasis |
| SES | Simple Exponential Smoothing | Smooth patterns |
| DES | Double Exponential Smoothing | Trend patterns |
| HW | Holt-Winters | Trend + Seasonality |
| LR | Linear Regression | Long-term trends |
| CROSTON | Croston's Method | Intermittent demand |

---

## Sheet 2: Forecast Dashboard

### KPI Tiles (Row 3-8)

| KPI | Formula | Conditional Formatting |
|-----|---------|----------------------|
| Total SKUs Forecasted | `=COUNTA(SKU_Data!A3:A5000)` | — |
| Overall WMAPE | `=SUMPRODUCT(ABS(Error_Metrics!D3:D5000),Error_Metrics!E3:E5000)/SUM(Error_Metrics!E3:E5000)` | ≤25% GREEN, 25-35% YELLOW, >35% RED |
| Avg Forecast Accuracy | `=1-AVERAGE(Error_Metrics!D3:D5000)` | ≥75% GREEN, 60-75% YELLOW, <60% RED |
| Overall Bias | `=SUM(Forecast_Family!F:F-Forecast_Family!G:G)/SUM(Forecast_Family!G:G)` | ±3% GREEN, 3-5% YELLOW, >5% RED |
| Annual Forecast (Total $M) | `=SUM(Forecast_Family!H:H)/1000` | — |
| YoY Growth % | `=(Annual_Forecast-PY_Actual)/PY_Actual` | — |

### Family Summary (Row 11+)

| Col | Header | Formula |
|-----|--------|---------|
| A | Product Family | Family names |
| B | SKU Count | `=COUNTIF(SKU_Data!C:C,A11)` |
| C | 12-Month Forecast ($K) | `=SUMIF(Forecast_SKU!C:C,A11,Forecast_SKU!Total_Col)` |
| D | PY Actual ($K) | `=SUMIF(Historical!C:C,A11,Historical!PY_Total)` |
| E | YoY Growth | `=(C11-D11)/D11` |
| F | WMAPE | `=SUMPRODUCT(ABS(IF(Error_Metrics!C:C=A11,Error_Metrics!MAPE_Col,0)),IF(Error_Metrics!C:C=A11,Error_Metrics!Volume_Col,0))/SUMIF(Error_Metrics!C:C,A11,Error_Metrics!Volume_Col)` |
| G | Best Model | `=INDEX(Model_Comp!Models,MATCH(MIN(IF(Model_Comp!Family=A11,Model_Comp!MAPE)),IF(Model_Comp!Family=A11,Model_Comp!MAPE),0))` |

---

## Sheet 3: Demand Pattern Classification

### Purpose
Auto-classify each SKU's demand pattern to select appropriate forecasting model.

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | From SKU master |
| B | Product Name | `=VLOOKUP(A3,SKU_Data!A:B,2,FALSE)` |
| C | Family | `=VLOOKUP(A3,SKU_Data!A:C,3,FALSE)` |
| D | Avg Monthly Demand | `=AVERAGE(Historical_Data!D3:AI3)` |
| E | Std Dev | `=STDEV(Historical_Data!D3:AI3)` |
| F | CV (Coefficient of Variation) | `=IF(D3>0,E3/D3,"N/A")` |
| G | Non-Zero Periods | `=COUNTIF(Historical_Data!D3:AI3,">"&0)` |
| H | Total Periods | `=COUNTA(Historical_Data!D3:AI3)` |
| I | ADI (Avg Demand Interval) | `=IF(G3>0,H3/G3,"N/A")` |
| J | **Classification** | See formula below |
| K | Recommended Model | See formula below |
| L | Seasonality Detected? | `=IF(MAX(Seasonality!D3:O3)/MIN(Seasonality!D3:O3)>1.5,"Yes","No")` |

### Classification Formula (Column J)
```excel
=IF(OR(D3=0,G3=0),"No Demand",
  IF(AND(F3<Settings!$B$13,I3<Settings!$B$14),"Smooth",
    IF(AND(F3>=Settings!$B$13,I3<Settings!$B$14),"Erratic",
      IF(AND(F3<Settings!$B$13,I3>=Settings!$B$14),"Intermittent",
        "Lumpy"))))
```

### Recommended Model Formula (Column K)
```excel
=IF(J3="No Demand","None",
  IF(J3="Smooth",IF(L3="Yes","HW","SES"),
    IF(J3="Erratic",IF(L3="Yes","HW","WMA"),
      IF(J3="Intermittent","CROSTON",
        "CROSTON"))))
```

### Conditional Formatting
| Classification | Color |
|---------------|-------|
| Smooth | Green background (#D1FAE5) |
| Erratic | Yellow background (#FEF3C7) |
| Intermittent | Orange background (#FFEDD5) |
| Lumpy | Red background (#FEE2E2) |
| No Demand | Gray background (#F3F4F6) |

---

## Sheet 4: Historical Data

### Purpose
36-month demand history by SKU with outlier detection.

### Layout
- Column A: SKU Code
- Column B: Product Name
- Columns C-AJ: Month -36 through Month -1 (actual demand values)

### Outlier Detection Row (below data)
For each cell with value:
```excel
=IF(ABS(C3-AVERAGE($C3:$AJ3))/STDEV($C3:$AJ3)>Settings!$B$7,"⚠ OUTLIER","")
```

### Conditional Formatting
- Outlier cells: Red border, light red background (#FEF2F2)
- Zero demand cells: Gray text (#9CA3AF)

---

## Sheet 5: Forecast Output - Family Level

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Product Family | Unique families |
| B | Classification Mix | Dominant classification |
| C-N | Month 1 through Month 12 | `=SUMIF(Forecast_SKU!C:C,A3,Forecast_SKU![Month_Col])` |
| O | Q1 | `=SUM(C3:E3)` |
| P | Q2 | `=SUM(F3:H3)` |
| Q | Q3 | `=SUM(I3:K3)` |
| R | Q4 | `=SUM(L3:N3)` |
| S | Annual Total | `=SUM(C3:N3)` |
| T | Revenue ($K) | `=S3*VLOOKUP(A3,Price_Lookup,2,FALSE)` |
| U | PY Actual | From historical |
| V | YoY Growth | `=(S3-U3)/U3` |

---

## Sheet 6: Forecast Output - SKU Level

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | All SKUs |
| B | Product Name | `=VLOOKUP(A3,SKU_Data!A:B,2,FALSE)` |
| C | Family | `=VLOOKUP(A3,SKU_Data!A:C,3,FALSE)` |
| D | Classification | `=VLOOKUP(A3,Pattern_Class!A:J,10,FALSE)` |
| E | Model Used | `=VLOOKUP(A3,Pattern_Class!A:K,11,FALSE)` |
| F-Q | Month 1 through Month 12 | Model output values |
| R | Annual Total | `=SUM(F3:Q3)` |
| S | Unit Price | `=VLOOKUP(A3,SKU_Data!A:F,6,FALSE)` |
| T | Revenue ($K) | `=R3*S3/1000` |
| U | Lower CI (Annual) | `=R3-Settings!$B$12*VLOOKUP(A3,Error_Metrics!A:F,6,FALSE)*SQRT(12)` |
| V | Upper CI (Annual) | `=R3+Settings!$B$12*VLOOKUP(A3,Error_Metrics!A:F,6,FALSE)*SQRT(12)` |

---

## Sheet 7: Error Metrics

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | All SKUs |
| B | Product Name | Lookup |
| C | Family | Lookup |
| D | MAPE | `=AVERAGE(ABS((Forecast_History-Actual_History)/Actual_History))` |
| E | Actual Volume (Weight) | For WMAPE calculation |
| F | Std Error | `=STDEV(Forecast_History-Actual_History)` |
| G | Bias % | `=SUM(Forecast_History-Actual_History)/SUM(Actual_History)` |
| H | Tracking Signal | `=SUM(Forecast_History-Actual_History)/AVERAGE(ABS(Forecast_History-Actual_History))` |
| I | Signal Status | `=IF(ABS(H3)>4,"⚠ OUT OF CONTROL",IF(ABS(H3)>3,"WATCH","OK"))` |
| J | Forecast Accuracy | `=1-D3` |
| K | Accuracy Rating | `=IF(J3>=0.8,"Excellent",IF(J3>=0.7,"Good",IF(J3>=0.6,"Fair","Poor")))` |

### Conditional Formatting
- MAPE >40%: Red background
- MAPE 25-40%: Yellow background
- MAPE <25%: Green background
- Tracking Signal out of control: Red text, bold

---

## Sheet 8: Seasonality Indices

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | All SKUs |
| B | Family | Lookup |
| C | Seasonal? | `=IF(MAX(D3:O3)/MIN(D3:O3)>1.5,"Yes","No")` |
| D-O | Jan through Dec Index | `=AVERAGE(Jan_Values)/AVERAGE(All_Values)` per month |
| P | Max Index | `=MAX(D3:O3)` |
| Q | Min Index | `=MIN(D3:O3)` |
| R | Seasonality Ratio | `=P3/Q3` |

### Index Interpretation
- Index = 1.0: Average month
- Index > 1.0: Above-average demand month
- Index < 1.0: Below-average demand month

### Conditional Formatting
- Index ≥ 1.3: Dark green background (peak season)
- Index 1.1-1.3: Light green background
- Index 0.9-1.1: No formatting (average)
- Index 0.7-0.9: Light orange background
- Index < 0.7: Red background (trough)

---

## Sheet 9: Model Comparison

### Purpose
Side-by-side model performance for each SKU to validate model selection.

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | All SKUs |
| B | Family | Lookup |
| C | SMA MAPE | Model-specific MAPE |
| D | WMA MAPE | Model-specific MAPE |
| E | SES MAPE | Model-specific MAPE |
| F | DES MAPE | Model-specific MAPE |
| G | HW MAPE | Model-specific MAPE |
| H | LR MAPE | Model-specific MAPE |
| I | Best Model | `=INDEX({"SMA","WMA","SES","DES","HW","LR"},MATCH(MIN(C3:H3),C3:H3,0))` |
| J | Best MAPE | `=MIN(C3:H3)` |
| K | Current Model | From Pattern Classification |
| L | Current MAPE | Lookup from Error Metrics |
| M | Model Change Recommended? | `=IF(AND(I3<>K3,J3<L3*0.9),"Yes","No")` |
| N | MAPE Improvement | `=IF(M3="Yes",L3-J3,0)` |

### Conditional Formatting
- Best model cell in each row: Green background
- Model Change = "Yes": Yellow background with bold text

---

## Sheet 10: Outlier Log

### Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Date Identified | Date |
| B | SKU Code | Dropdown |
| C | Period Affected | Month/Year |
| D | Original Value | Number |
| E | Z-Score | `=(D3-VLOOKUP(B3,Pattern_Class!A:D,4,FALSE))/VLOOKUP(B3,Pattern_Class!A:E,5,FALSE)` |
| F | Outlier Type | Dropdown: Spike/Drop/Unusual Pattern |
| G | Root Cause | Text |
| H | Treatment | Dropdown: Replace with Average/Exclude/Keep/Cap |
| I | Adjusted Value | Depends on treatment |
| J | Impact on Forecast | `=(I3-D3)/D3` percentage change |
| K | Approved By | Text |

---

## Sheet 11: Aggregation Reconciliation

### Purpose
Reconcile top-down family forecast with bottom-up SKU-level sum.

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Product Family | Family list |
| B | Top-Down Forecast | Family-level model output |
| C | Bottom-Up Sum | `=SUMIF(Forecast_SKU!C:C,A3,Forecast_SKU!R:R)` |
| D | Variance | `=B3-C3` |
| E | Variance % | `=IF(C3>0,D3/C3,0)` |
| F | Reconciliation Method | Dropdown: Top-Down/Bottom-Up/Middle-Out/Weighted Average |
| G | Reconciled Value | Based on method selected |
| H | Adjustment Factor | `=IF(F3="Top-Down",B3/C3,IF(F3="Bottom-Up",1,IF(F3="Weighted Average",(B3*0.5+C3*0.5)/C3,1)))` |
| I | Notes | Text |

### Conditional Formatting
- Variance % > ±10%: Red background (needs reconciliation)
- Variance % 5-10%: Yellow background (review recommended)
- Variance % < ±5%: Green background (acceptable)

---

## Named Ranges

| Name | Reference | Purpose |
|------|-----------|---------|
| STAT_Forecast_SKU | Forecast_SKU!A:V | SKU-level forecast data |
| STAT_Forecast_Family | Forecast_Family!A:V | Family-level forecast |
| STAT_WMAPE | Dashboard!B4 | Overall weighted MAPE |
| STAT_Overall_Accuracy | Dashboard!B5 | Overall forecast accuracy |
| STAT_Bias | Dashboard!B6 | Overall bias |
| STAT_Pattern_Class | Pattern_Classification!A:L | Demand patterns |
| STAT_Error_Metrics | Error_Metrics!A:K | Error data |
| STAT_Seasonality | Seasonality!A:R | Seasonal indices |
| STAT_Annual_Forecast | Dashboard!B7 | Total annual forecast |

---

## Integration Points

| Workbook | Integration | Method |
|----------|-------------|--------|
| Consensus_Demand_ENHANCED | Statistical baseline input | Named range STAT_Forecast_Family |
| Forecast_Accuracy_ENHANCED | Error metrics feed | Named range STAT_Error_Metrics |
| Bias_Analysis_ENHANCED | Bias data | Named range STAT_Bias |
| Demand_Assumptions_ENHANCED | Model assumptions | Cross-reference |
| Capacity_Planning_ENHANCED | Demand input for capacity | Named range STAT_Forecast_SKU |
| IBP_Master_Integration | Central hub | Power Query connection |

---

## VBA Automation

```vba
Sub RunPatternClassification()
    ' Auto-classify all SKUs and recommend models
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Pattern_Classification")
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim counts(1 To 5) As Long ' Smooth, Erratic, Intermittent, Lumpy, No Demand
    For i = 3 To lastRow
        Select Case ws.Cells(i, 10).Value
            Case "Smooth": counts(1) = counts(1) + 1
            Case "Erratic": counts(2) = counts(2) + 1
            Case "Intermittent": counts(3) = counts(3) + 1
            Case "Lumpy": counts(4) = counts(4) + 1
            Case "No Demand": counts(5) = counts(5) + 1
        End Select
    Next i

    MsgBox "Pattern Classification Complete:" & vbCrLf & _
           "Smooth: " & counts(1) & vbCrLf & _
           "Erratic: " & counts(2) & vbCrLf & _
           "Intermittent: " & counts(3) & vbCrLf & _
           "Lumpy: " & counts(4) & vbCrLf & _
           "No Demand: " & counts(5), _
           vbInformation, "Classification Results"
End Sub

Sub HighlightModelChanges()
    ' Highlight SKUs where model change is recommended
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Model_Comparison")
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    Dim changeCount As Long: changeCount = 0

    For i = 3 To lastRow
        If ws.Cells(i, 13).Value = "Yes" Then
            ws.Range(ws.Cells(i, 1), ws.Cells(i, 14)).Interior.Color = RGB(254, 243, 199)
            changeCount = changeCount + 1
        End If
    Next i

    MsgBox changeCount & " SKUs have model change recommendations." & vbCrLf & _
           "Review Model Comparison sheet for details.", _
           vbInformation, "Model Review"
End Sub
```

---

*Integration-ready statistical forecasting engine with automated pattern classification and model selection.*
