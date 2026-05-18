# Bias Analysis Template - Enhanced Excel Workbook
## Advanced Forecast Bias Detection, Behavioral Analytics & Correction Engine

---

## Overview
Comprehensive bias analysis workbook featuring multi-dimensional bias tracking (by customer, region, sales rep, product, horizon), tracking signal monitoring with control limits, behavioral pattern detection, automated correction factors, and accountability reporting. Designed for 100 customers × 4 SKUs with 36-month historical analysis.

---

## Design Theme: "Precision Analytics"

| Element | Specification |
|---------|--------------|
| Primary Color | Purple (#7C3AED) |
| Secondary Color | Coral (#F43F5E) |
| Accent | Teal (#0D9488) |
| Positive Bias (Over) | Amber (#F59E0B) |
| Negative Bias (Under) | Blue (#3B82F6) |
| Neutral | Slate (#64748B) |
| Critical Alert | Red (#EF4444) |
| Font - Headers | Segoe UI Semibold, 11pt |
| Font - Body | Segoe UI, 10pt |
| Row Banding | White / Light Purple (#F5F3FF) |

---

# SHEET 1: CONFIGURATION & SETTINGS

## Bias Thresholds (Row 3-12)

| Parameter | Value | Description |
|-----------|-------|-------------|
| Target Bias % | ±3% | Acceptable bias range |
| Warning Threshold | ±5% | Amber alert level |
| Critical Threshold | ±10% | Red alert level |
| Tracking Signal Limit | ±4 | Control chart limit |
| Warning Signal | ±3 | Early warning level |
| Consecutive Month Limit | 3 | Max same-direction bias before intervention |
| Min Volume for Analysis | 100 | Units minimum for inclusion |
| Correction Factor Max | 1.30 | Maximum adjustment (30%) |
| Correction Factor Min | 0.70 | Minimum adjustment (-30%) |
| Statistical Significance | 0.05 | P-value threshold |

## Bias Direction Definitions (Row 15-18)

| Direction | Definition | Color Code |
|-----------|-----------|------------|
| Positive Bias | Forecast > Actual (Over-forecasting) | Amber (#F59E0B) |
| Negative Bias | Forecast < Actual (Under-forecasting) | Blue (#3B82F6) |
| Neutral | Bias within ±3% | Slate (#64748B) |

## Behavioral Pattern Definitions (Row 21-28)

| Pattern | Description | Detection Criteria |
|---------|-------------|-------------------|
| Sandbagging | Deliberate under-forecasting | Consistent negative bias >5% for 6+ months |
| Hockey Stick | Over-forecast long-term, under near-term | Bias increases with horizon |
| Optimism Bias | Systematic over-forecasting | Positive bias >5% for 6+ months |
| Anchoring | Insufficient adjustment from baseline | Low overlay adjustment frequency |
| Recency Bias | Over-weighting recent events | High volatility in month-over-month overlays |
| Herd Behavior | Following market consensus blindly | Forecast mirrors external forecasts |

---

# SHEET 2: BIAS DASHBOARD

## KPI Tiles (Row 3-10)

| KPI | Formula | Conditional Formatting |
|-----|---------|----------------------|
| Overall Bias % | `=(SUM(Forecast_Col)-SUM(Actual_Col))/SUM(Actual_Col)` | ±3% GREEN, 3-5% YELLOW, >5% RED |
| Bias Direction | `=IF(B3>0.03,"Over-Forecast",IF(B3<-0.03,"Under-Forecast","Neutral"))` | Color by direction |
| Consecutive Same Direction | `=MAX(Tracking!Consecutive_Col)` | >3 months = RED |
| Tracking Signal | `=SUM(Cumulative_Error)/Average_MAD` | ±4 limits, ±3 warning |
| Control Limit Breaches | `=COUNTIF(Tracking!Signal_Col,"OUT OF CONTROL")` | >0 = RED |
| Interventions Triggered | `=COUNTIF(Tracking!Intervention_Col,"Yes")` | — |
| SKUs with High Bias | `=COUNTIF(SKU_Bias!Bias_Col,">="&Settings!$B$6)+COUNTIF(SKU_Bias!Bias_Col,"<="&-Settings!$B$6)` | — |
| Accuracy Impact of Bias | `=AVERAGE(Error_Metrics!MAPE_With_Bias)-AVERAGE(Error_Metrics!MAPE_Without_Bias)` | — |

## Monthly Trend Summary (Row 13-26)

| Month | Bias % | Direction | Consecutive | Signal | Status |
|-------|--------|-----------|-------------|--------|--------|
| Jan | Formula | Formula | Formula | Formula | Formula |
| ... | ... | ... | ... | ... | ... |
| Dec | Formula | Formula | Formula | Formula | Formula |

### Formulas for Monthly Summary
```excel
B13 (Bias %): =(SUMIF(Detail!Month,"Jan",Detail!Forecast)-SUMIF(Detail!Month,"Jan",Detail!Actual))/SUMIF(Detail!Month,"Jan",Detail!Actual)
C13 (Direction): =IF(B13>0.03,"Over",IF(B13<-0.03,"Under","Neutral"))
D13 (Consecutive): =IF(SIGN(B13)=SIGN(B12),D12+1,1)
E13 (Signal): =SUM($B$13:B13)/AVERAGE(ABS($B$13:B13))
F13 (Status): =IF(ABS(E13)>Settings!$B$4,"⚠ OUT OF CONTROL",IF(ABS(E13)>Settings!$B$5,"⚡ WARNING","✓ OK"))
```

---

# SHEET 3: BIAS BY CUSTOMER-SKU (400 Combinations)

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Customer-SKU key |
| B | Customer | `=VLOOKUP(LEFT(A3,4),Customer_Master!A:B,2,FALSE)` |
| C | Tier | `=VLOOKUP(LEFT(A3,4),Customer_Master!A:H,8,FALSE)` |
| D | SKU | `=MID(A3,6,99)` |
| E | LTM Forecast | `=SUMIFS(History!Forecast_Col,History!Key_Col,A3,History!Month_Col,">="&DATE(YEAR(TODAY())-1,MONTH(TODAY()),1))` |
| F | LTM Actual | `=SUMIFS(History!Actual_Col,History!Key_Col,A3,History!Month_Col,">="&DATE(YEAR(TODAY())-1,MONTH(TODAY()),1))` |
| G | Bias ($K) | `=E3-F3` |
| H | **Bias %** | `=IF(F3>0,(E3-F3)/F3,0)` |
| I | Bias Direction | `=IF(H3>0.03,"Over",IF(H3<-0.03,"Under","Neutral"))` |
| J | 6-Month Bias % | `=AVERAGEIFS(Monthly_Bias,Key_Col,A3,Month_Col,">="&EDATE(TODAY(),-6))` |
| K | 12-Month Bias % | `=H3` |
| L | Trend (3M Slope) | `=SLOPE(OFFSET(Monthly_Bias!$D$3,MATCH(A3,Monthly_Bias!$A:$A,0)-3,0,3,1),{1,2,3})` |
| M | **Pattern Type** | See formula below |
| N | Consecutive Same Dir | Count from monthly data |
| O | Tracking Signal | `=SUM(Monthly_Error)/AVG(ABS(Monthly_Error))` |
| P | Signal Status | `=IF(ABS(O3)>4,"OUT OF CONTROL",IF(ABS(O3)>3,"WARNING","OK"))` |
| Q | Statistical Significance | `=T.TEST(Forecast_Range,Actual_Range,2,1)` |
| R | Significant? | `=IF(Q3<Settings!$B$10,"Yes","No")` |
| S | **Correction Factor** | See formula below |
| T | Corrected Forecast | `=E3*S3` |
| U | Root Cause | Dropdown |
| V | Action Required | Text |

### Pattern Type Detection Formula (Column M)
```excel
=IF(AND(H3<-0.05,N3>=6),"Sandbagging",
  IF(AND(H3>0.05,N3>=6),"Optimism Bias",
    IF(AND(J3<0,H3>0.05),"Hockey Stick",
      IF(ABS(L3)<0.001,"Anchoring",
        IF(ABS(L3)>0.03,"Recency Bias","Normal")))))
```

### Auto-Correction Factor Formula (Column S)
```excel
=IF(R3="No",1,
  IF(H3>0,MAX(Settings!$B$9,1-ABS(H3)*0.8),
    MIN(Settings!$B$8,1+ABS(H3)*0.8)))
```
*Explanation: Applies 80% of historical bias as correction when statistically significant*

---

# SHEET 4: BIAS BY PRODUCT FAMILY

## Summary by Family

| Col | Header | Formula |
|-----|--------|---------|
| A | Product Family | Unique family list |
| B | SKU Count | `=COUNTIF(SKU_Bias!Family_Col,A3)` |
| C | Total Forecast ($K) | `=SUMIF(SKU_Bias!Family_Col,A3,SKU_Bias!E:E)` |
| D | Total Actual ($K) | `=SUMIF(SKU_Bias!Family_Col,A3,SKU_Bias!F:F)` |
| E | Bias ($K) | `=C3-D3` |
| F | Bias % | `=E3/D3` |
| G | 6-Month Avg Bias | `=AVERAGEIF(Monthly_Family!Family_Col,A3,Monthly_Family!Bias_Col)` |
| H | Pattern | `=IF(ABS(G3)>0.05,IF(G3>0,"Systematic Over","Systematic Under"),"Random")` |
| I | Root Cause | Dropdown |
| J | Corrective Action | Text |
| K | Owner | Dropdown |
| L | Due Date | Date |
| M | Status | Dropdown: Open/In Progress/Closed |

### Conditional Formatting
- Bias % ≥5%: Red background
- Bias % 3-5%: Yellow background
- Bias % -3% to 3%: Green background
- Bias % <-3%: Blue background

---

# SHEET 5: BIAS BY REGION

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Region | NA/EMEA/APAC/LATAM |
| B | Customer Count | `=COUNTIF(Customer_Master!D:D,A3)` |
| C | Total Forecast ($M) | `=SUMIF(Customer!Region_Col,A3,Customer!Forecast_Col)/1000` |
| D | Total Actual ($M) | `=SUMIF(Customer!Region_Col,A3,Customer!Actual_Col)/1000` |
| E | Bias ($M) | `=C3-D3` |
| F | Bias % | `=E3/D3` |
| G | 6-Month Avg Bias | Rolling average |
| H | Pattern | Systematic/Random |
| I | Trend | Improving/Stable/Worsening |
| J | Root Cause | Text |
| K | Corrective Action | Text |

---

# SHEET 6: BIAS BY SALES REP

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Sales Rep | Account manager name |
| B | Customer Count | `=COUNTIF(Customer_Master!C:C,A3)` |
| C | Annual Revenue ($M) | `=SUMIF(Customer_Master!C:C,A3,Customer_Master!G:G)/1000` |
| D | LTM Forecast | `=SUMIF(...)` |
| E | LTM Actual | `=SUMIF(...)` |
| F | **Bias %** | `=(D3-E3)/E3` |
| G | 6-Month Avg Bias | Rolling average |
| H | Consistency Score | `=1-STDEV(Monthly_Bias_by_Rep)/ABS(AVERAGE(Monthly_Bias_by_Rep))` |
| I | Pattern Detected | Sandbagging/Optimism/Hockey Stick/Normal |
| J | **Coaching Needed?** | `=IF(AND(ABS(F3)>0.05,H3>0.7),"Yes - Systematic",IF(ABS(F3)>0.1,"Yes - Magnitude","No"))` |
| K | Manager | Manager name |
| L | Last Review Date | Date |
| M | Days Since Review | `=TODAY()-L3` |
| N | Review Status | `=IF(M3>90,"OVERDUE",IF(M3>60,"DUE SOON","OK"))` |
| O | Improvement Actions | Text |
| P | Progress | Dropdown: Not Started/In Progress/On Track/Complete |

### Conditional Formatting
- Coaching Needed = "Yes - Systematic": Red bold text, yellow background
- Coaching Needed = "Yes - Magnitude": Orange text
- Bias >10% either direction: Red background

---

# SHEET 7: BIAS BY FORECAST HORIZON

## Purpose
Analyze how bias changes across forecast horizons (1-month out vs 12-month out).

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Horizon (Months Out) | 1, 2, 3, 6, 12 |
| B | Avg Forecast | Average forecast at this horizon |
| C | Avg Actual | Average actual when it materializes |
| D | Bias % | `=(B3-C3)/C3` |
| E | Bias Direction | Over/Under/Neutral |
| F | Expected Behavior | "Near-term accurate, long-term optimistic" typical |
| G | Variance from Expected | `=D3-F3` |
| H | Interpretation | Text |
| I | Action | Text |

### Typical Horizon Bias Pattern
```
Horizon    Expected Bias    Typical Pattern
1 month    ±2%              Most accurate
2 months   ±3%              Slight optimism
3 months   ±5%              Moderate optimism
6 months   ±8%              Higher uncertainty
12 months  ±12%             Significant optimism typical
```

### Analysis Formulas
```excel
D3 (1-month bias): =AVERAGEIF(History!Horizon_Col,1,History!Bias_Col)
D4 (2-month bias): =AVERAGEIF(History!Horizon_Col,2,History!Bias_Col)
... and so on
```

---

# SHEET 8: TRACKING SIGNAL ANALYSIS

## Purpose
Statistical process control for forecast bias using tracking signal and control charts.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | Month identifier |
| B | Total Forecast | Monthly total |
| C | Total Actual | Monthly total |
| D | Error (F-A) | `=B3-C3` |
| E | Absolute Error | `=ABS(D3)` |
| F | Cumulative Error (RSFE) | `=SUM($D$3:D3)` |
| G | Cumulative Absolute | `=SUM($E$3:E3)` |
| H | MAD (Mean Abs Dev) | `=G3/(ROW()-2)` |
| I | **Tracking Signal** | `=F3/H3` |
| J | Upper Control Limit | `=Settings!$B$4` (+4) |
| K | Lower Control Limit | `=-Settings!$B$4` (-4) |
| L | Upper Warning | `=Settings!$B$5` (+3) |
| M | Lower Warning | `=-Settings!$B$5` (-3) |
| N | **Signal Status** | `=IF(OR(I3>J3,I3<K3),"OUT OF CONTROL",IF(OR(I3>L3,I3<M3),"WARNING","IN CONTROL"))` |
| O | Consecutive in Zone | Count of consecutive periods in same status |
| P | **Intervention Triggered?** | `=IF(OR(N3="OUT OF CONTROL",AND(N3="WARNING",O3>=3)),"Yes","No")` |
| Q | Intervention Date | Date if triggered |
| R | Action Taken | Text |
| S | Result | Text |

### Tracking Signal Interpretation
| Signal Value | Interpretation | Action |
|-------------|----------------|--------|
| -4 to +4 | In control | Monitor |
| -3 to -4 or +3 to +4 | Warning zone | Investigate |
| < -4 or > +4 | Out of control | Immediate action |

---

# SHEET 9: OVERLAY BIAS ANALYSIS

## Purpose
Analyze accuracy and bias contribution of each forecast overlay type.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Overlay Type | Sales/Marketing/NPI/Customer Intel/Management |
| B | # Adjustments (LTM) | `=COUNTIF(Overlays!Type_Col,A3)` |
| C | Total Adjustment ($K) | `=SUMIF(Overlays!Type_Col,A3,Overlays!Adjustment_Col)` |
| D | Net Direction | `=IF(C3>0,"Up",IF(C3<0,"Down","None"))` |
| E | Actual Impact ($K) | What actually happened |
| F | Accuracy of Adjustments | `=1-ABS(C3-E3)/ABS(C3)` |
| G | Bias % | `=(C3-E3)/E3` |
| H | **Value Added?** | `=IF(ABS(G3)<ABS(Stat_Only_Bias),"Yes","No")` |
| I | Recommendation | Continue/Modify/Eliminate |
| J | Notes | Text |

### Value-Add Analysis Formula
```excel
Stat_Only_MAPE = Historical statistical forecast MAPE
With_Overlay_MAPE = Actual MAPE with overlay applied
Value_Add = Stat_Only_MAPE - With_Overlay_MAPE

H3: =IF(With_Overlay_MAPE<Stat_Only_MAPE,"Yes - "&TEXT((Stat_Only_MAPE-With_Overlay_MAPE),"0%")&" improvement","No - "&TEXT((With_Overlay_MAPE-Stat_Only_MAPE),"0%")&" worse")
```

---

# SHEET 10: BEHAVIORAL PATTERN DETECTION

## Pre-defined Patterns with Detection

| Pattern | Description | Detection Formula | Indicators | Impact | Mitigation |
|---------|-------------|-------------------|------------|--------|-----------|
| Sandbagging | Deliberate under-forecast | `=IF(AND(Bias<-0.05,Consecutive>=6,Beat_Rate>0.8),"DETECTED","")` | Consistent negative bias; high beat rate | Under-investment | Align incentives; track bias by rep |
| Hockey Stick | Over-forecast long-term | `=IF(AND(Horizon_12M_Bias>0.1,Horizon_1M_Bias<0.03),"DETECTED","")` | Bias increases with horizon | Resource misallocation | Accountability at all horizons |
| Optimism Bias | Systematic over-forecast | `=IF(AND(Bias>0.05,Consecutive>=6),"DETECTED","")` | Consistent positive bias | Excess inventory | Require evidence |
| Anchoring | Insufficient adjustment | `=IF(AND(Adjustment_Freq<0.25,Market_Volatility>0.15),"DETECTED","")` | Low adjustment frequency despite changes | Missed trends | Challenge assumptions |
| Recency Bias | Over-weight recent events | `=IF(Overlay_Volatility>2*Demand_Volatility,"DETECTED","")` | High volatility in overlays | Whipsaw plans | Longer perspective |

---

# SHEET 11: CORRECTION FACTOR CALCULATOR

## Automated Bias Correction

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Key |
| B | Customer | Lookup |
| C | SKU | Lookup |
| D | Historical Bias % | 12-month average bias |
| E | Bias Direction | Over/Under |
| F | Statistical Significance | T-test p-value |
| G | Significant? | `=IF(F3<0.05,"Yes","No")` |
| H | Pattern Detected | From behavioral analysis |
| I | Consecutive Months | Same direction count |
| J | **Recommended Correction** | See formula below |
| K | Application Method | Multiplicative/Additive |
| L | Expected Improvement | `=ABS(D3)*0.7` (70% of bias) |
| M | Implementation Date | Date |
| N | Owner | Dropdown |
| O | Status | Planned/Active/Monitoring/Retired |
| P | Actual Improvement | Post-implementation measurement |
| Q | Effectiveness | `=P3/L3` |

### Correction Factor Formula (Column J)
```excel
=IF(G3="No",1,
  IF(D3>0,
    MAX(0.7, 1-MIN(ABS(D3)*0.8, 0.3)),
    MIN(1.3, 1+MIN(ABS(D3)*0.8, 0.3))))
```

**Explanation:**
- Only apply if statistically significant
- For positive bias (over-forecast): Multiply by factor < 1
- For negative bias (under-forecast): Multiply by factor > 1
- Apply 80% of bias as correction
- Cap at ±30% maximum adjustment

---

# SHEET 12: ACCOUNTABILITY REPORT

## Bias Accountability by Role

| Col | Header | Formula |
|-----|--------|---------|
| A | Role | Demand Planning/Sales VP/Marketing VP/Product Mgmt/Overall |
| B | Responsible For | What they forecast |
| C | LTM Bias % | Actual bias for their inputs |
| D | Target Bias | ±3% for all |
| E | Gap to Target | `=ABS(C3)-D3` |
| F | 3-Month Trend | Improving/Stable/Worsening |
| G | 6-Month Trend | Same |
| H | **Performance Rating** | `=IF(ABS(C3)<=0.03,"Green",IF(ABS(C3)<=0.05,"Yellow","Red"))` |
| I | Action Required | Text |
| J | Owner | Name |
| K | Due Date | Date |
| L | Status | Open/In Progress/Closed |

### Example Accountability Structure
| Role | Responsible For | Target |
|------|----------------|--------|
| Demand Planning | Statistical baseline accuracy | ±3% |
| Sales VP | Sales overlay accuracy | ±3% |
| Marketing VP | Marketing overlay/promo accuracy | ±5% |
| Product Management | NPI forecast accuracy | ±10% |
| Overall | Consensus demand bias | ±3% |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| BIAS_Overall | Dashboard!B3 | Overall bias % |
| BIAS_Direction | Dashboard!B4 | Current direction |
| BIAS_Signal | Dashboard!B5 | Tracking signal |
| BIAS_By_SKU | SKU_Bias!A:V | Customer-SKU bias data |
| BIAS_By_Family | Family_Bias!A:M | Family-level bias |
| BIAS_By_Region | Region_Bias!A:K | Regional bias |
| BIAS_By_Rep | Rep_Bias!A:P | Sales rep bias |
| BIAS_Tracking | Tracking_Signal!A:S | Control chart data |
| BIAS_Corrections | Corrections!A:Q | Correction factors |
| BIAS_Accountability | Accountability!A:L | Role accountability |

---

# VBA AUTOMATION

```vba
' ========================================
' Module: BiasAnalysis
' Purpose: Automated bias detection and correction
' ========================================

Option Explicit

Sub RunFullBiasAnalysis()
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    Call CalculateSKULevelBias
    Call DetectBehavioralPatterns
    Call CalculateTrackingSignals
    Call GenerateCorrectionFactors
    Call UpdateAccountabilityReport
    Call RefreshDashboard

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Bias analysis complete." & vbCrLf & _
           "Overall Bias: " & Format(Range("BIAS_Overall").Value, "0.0%") & vbCrLf & _
           "Direction: " & Range("BIAS_Direction").Value & vbCrLf & _
           "Tracking Signal: " & Format(Range("BIAS_Signal").Value, "0.00"), _
           vbInformation, "Bias Analysis Complete"
End Sub

Sub CalculateSKULevelBias()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("SKU_Bias")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    For i = 3 To lastRow
        ' Calculate bias percentage
        If ws.Cells(i, 6).Value > 0 Then
            ws.Cells(i, 8).Value = (ws.Cells(i, 5).Value - ws.Cells(i, 6).Value) / _
                                    ws.Cells(i, 6).Value
        End If

        ' Determine direction
        If ws.Cells(i, 8).Value > 0.03 Then
            ws.Cells(i, 9).Value = "Over"
        ElseIf ws.Cells(i, 8).Value < -0.03 Then
            ws.Cells(i, 9).Value = "Under"
        Else
            ws.Cells(i, 9).Value = "Neutral"
        End If
    Next i
End Sub

Sub DetectBehavioralPatterns()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("SKU_Bias")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim bias As Double, sixMonthBias As Double
    Dim consecutive As Long
    Dim pattern As String

    For i = 3 To lastRow
        bias = ws.Cells(i, 8).Value
        sixMonthBias = ws.Cells(i, 10).Value
        consecutive = ws.Cells(i, 14).Value

        ' Pattern detection logic
        If bias < -0.05 And consecutive >= 6 Then
            pattern = "Sandbagging"
        ElseIf bias > 0.05 And consecutive >= 6 Then
            pattern = "Optimism Bias"
        ElseIf sixMonthBias < 0 And bias > 0.05 Then
            pattern = "Hockey Stick"
        Else
            pattern = "Normal"
        End If

        ws.Cells(i, 13).Value = pattern

        ' Apply conditional formatting
        Select Case pattern
            Case "Sandbagging", "Optimism Bias"
                ws.Cells(i, 13).Interior.Color = RGB(254, 226, 226)
                ws.Cells(i, 13).Font.Color = RGB(185, 28, 28)
            Case "Hockey Stick"
                ws.Cells(i, 13).Interior.Color = RGB(254, 243, 199)
                ws.Cells(i, 13).Font.Color = RGB(180, 83, 9)
            Case Else
                ws.Cells(i, 13).Interior.ColorIndex = xlNone
                ws.Cells(i, 13).Font.Color = RGB(0, 0, 0)
        End Select
    Next i
End Sub

Sub GenerateCorrectionFactors()
    Dim wsBias As Worksheet, wsCorr As Worksheet
    Set wsBias = ThisWorkbook.Sheets("SKU_Bias")
    Set wsCorr = ThisWorkbook.Sheets("Corrections")

    Dim lastRow As Long
    lastRow = wsBias.Cells(wsBias.Rows.Count, "A").End(xlUp).Row

    Dim bias As Double, significant As Boolean
    Dim correction As Double

    Dim destRow As Long: destRow = 3

    For i = 3 To lastRow
        bias = wsBias.Cells(i, 8).Value
        significant = (wsBias.Cells(i, 18).Value = "Yes")

        If significant And Abs(bias) > 0.05 Then
            wsCorr.Cells(destRow, 1).Value = wsBias.Cells(i, 1).Value ' Key
            wsCorr.Cells(destRow, 2).Value = wsBias.Cells(i, 2).Value ' Customer
            wsCorr.Cells(destRow, 3).Value = wsBias.Cells(i, 4).Value ' SKU
            wsCorr.Cells(destRow, 4).Value = bias ' Historical bias
            wsCorr.Cells(destRow, 5).Value = IIf(bias > 0, "Over", "Under")

            ' Calculate correction factor
            If bias > 0 Then
                correction = Application.Max(0.7, 1 - Application.Min(Abs(bias) * 0.8, 0.3))
            Else
                correction = Application.Min(1.3, 1 + Application.Min(Abs(bias) * 0.8, 0.3))
            End If

            wsCorr.Cells(destRow, 10).Value = Round(correction, 3)
            wsCorr.Cells(destRow, 11).Value = "Multiplicative"
            wsCorr.Cells(destRow, 12).Value = Abs(bias) * 0.7 ' Expected improvement
            wsCorr.Cells(destRow, 15).Value = "Planned"

            destRow = destRow + 1
        End If
    Next i

    MsgBox (destRow - 3) & " correction factors generated.", vbInformation
End Sub

Sub AlertOutOfControlSignals()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Tracking_Signal")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim outOfControl As String
    Dim count As Long: count = 0

    For i = 3 To lastRow
        If ws.Cells(i, 14).Value = "OUT OF CONTROL" Then
            outOfControl = outOfControl & ws.Cells(i, 1).Value & ": Signal = " & _
                          Format(ws.Cells(i, 9).Value, "0.00") & vbCrLf
            count = count + 1
        End If
    Next i

    If count > 0 Then
        MsgBox "⚠ " & count & " periods have OUT OF CONTROL tracking signals:" & _
               vbCrLf & vbCrLf & outOfControl, vbExclamation, "Bias Alert"
    Else
        MsgBox "All tracking signals are within control limits.", vbInformation
    End If
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Forecast_Accuracy_ENHANCED | Accuracy metrics | Named range sharing |
| Consensus_Demand_ENHANCED | Bias-adjusted baseline | Named range BIAS_Corrections |
| Statistical_Forecast_ENHANCED | Model bias by type | Cross-reference |
| Customer_Forecast_ENHANCED | Customer-level bias | Named range BIAS_By_SKU |
| Executive_Dashboard_ENHANCED | Bias KPI | Named range BIAS_Overall |
| IBP_KPI_Dashboard_ENHANCED | Process metrics | Named range integration |
| IBP_Master_Integration | Central hub | Power Query connection |

---

*Advanced bias analytics engine with behavioral pattern detection, statistical process control, and automated correction factor generation for 100 customers × 4 SKUs.*
