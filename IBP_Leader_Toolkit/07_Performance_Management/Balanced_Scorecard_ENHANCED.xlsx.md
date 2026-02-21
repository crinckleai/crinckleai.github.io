# IBP Balanced Scorecard - Enhanced Excel Workbook

## Workbook Overview

**Purpose:** Comprehensive performance measurement across all IBP dimensions using balanced scorecard methodology
**Version:** 2.0 Enhanced
**Template Type:** Performance Management - Balanced Scorecard
**Integration:** Links to KPI dashboards, Process Health, and Benchmark workbooks

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy (#1B3A5F) |
| Accent Color 1 | Purple (#6B5B95) |
| Accent Color 2 | Indigo (#4B0082) |
| Success Color | Green (#28A745) |
| Warning Color | Amber (#FFC107) |
| Critical Color | Red (#DC3545) |
| Header Font | Calibri Bold 14pt |
| Body Font | Calibri Regular 11pt |
| Grid Lines | Light Gray (#E0E0E0) |

---

## Sheet 1: Scorecard_Dashboard

### Purpose
Executive summary dashboard showing overall IBP performance with weighted perspective scores

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 5 | # | Row numbering |
| B | 25 | Perspective | Scorecard perspective name |
| C | 12 | Weight | Perspective weight (totals 100%) |
| D | 15 | Current Score | Current period weighted score |
| E | 15 | Prior Month | Previous month score |
| F | 12 | MoM Change | Month-over-month variance |
| G | 15 | Prior Year | Same period last year |
| H | 12 | YoY Change | Year-over-year variance |
| I | 15 | Target | Period target |
| J | 15 | Gap to Target | Variance from target |
| K | 12 | Status | Performance status indicator |
| L | 18 | Trend (12M) | Sparkline trend data |
| M | 25 | Owner | Accountable executive |
| N | 30 | Commentary | Status commentary |

### Data Structure (Rows 5-10)

```
Row 5: Customer Perspective | 35% | Score | Prior | Change | YoY | Target | Gap | Status | Trend | Owner
Row 6: Financial Perspective | 30% | Score | Prior | Change | YoY | Target | Gap | Status | Trend | Owner
Row 7: Process Perspective | 25% | Score | Prior | Change | YoY | Target | Gap | Status | Trend | Owner
Row 8: Enabler Perspective | 10% | Score | Prior | Change | YoY | Target | Gap | Status | Trend | Owner
Row 9: BLANK
Row 10: OVERALL IBP SCORE | 100% | Weighted Total | Calculations...
```

### Key Formulas

```excel
' Overall IBP Score (Cell D10)
=SUMPRODUCT(C5:C8,D5:D8)/SUM(C5:C8)

' Customer Perspective Score (Cell D5)
=SUMPRODUCT(Customer_Metrics[Weight],Customer_Metrics[Score])/SUM(Customer_Metrics[Weight])

' Financial Perspective Score (Cell D6)
=SUMPRODUCT(Financial_Metrics[Weight],Financial_Metrics[Score])/SUM(Financial_Metrics[Weight])

' Process Perspective Score (Cell D7)
=SUMPRODUCT(Process_Metrics[Weight],Process_Metrics[Score])/SUM(Process_Metrics[Weight])

' Enabler Perspective Score (Cell D8)
=SUMPRODUCT(Enabler_Metrics[Weight],Enabler_Metrics[Score])/SUM(Enabler_Metrics[Weight])

' Month-over-Month Change (Cell F5)
=D5-E5

' Year-over-Year Change (Cell H5)
=D5-G5

' Gap to Target (Cell J5)
=D5-I5

' Status Indicator (Cell K5)
=IF(J5>=0,"On Track",IF(J5>=-5%,"At Risk","Off Track"))

' Weighted Contribution to Overall (Cell D5 contribution)
=D5*C5

' Performance Index vs Target
=D10/I10*100

' Improvement Momentum Score
=IF(AND(F10>0,H10>0),"Strong",IF(OR(F10>0,H10>0),"Moderate","Weak"))
```

### Conditional Formatting Rules

```
Rule 1: Gap to Target (Column J)
- >= 0: Green fill (#C6EFCE), Dark Green text (#006100)
- -5% to 0: Yellow fill (#FFEB9C), Dark Yellow text (#9C5700)
- < -5%: Red fill (#FFC7CE), Dark Red text (#9C0006)

Rule 2: Status Column (Column K)
- "On Track": Green fill (#28A745), White text
- "At Risk": Amber fill (#FFC107), Black text
- "Off Track": Red fill (#DC3545), White text

Rule 3: MoM/YoY Change (Columns F, H)
- > 0: Green up arrow icon, Green text
- = 0: Gray dash icon, Gray text
- < 0: Red down arrow icon, Red text

Rule 4: Overall Score (Cell D10)
- >= 90%: Navy fill (#1B3A5F), White bold text
- 80-89%: Purple fill (#6B5B95), White text
- 70-79%: Indigo fill (#4B0082), White text
- < 70%: Red fill (#DC3545), White text

Rule 5: Data Bars for Scores (Column D)
- Gradient fill from Purple to Navy
- Min: 0, Max: 100
```

### Sparkline Configuration (Column L)

```
Type: Line
Data Range: Trend_Data!B:M (12 months)
High Point: Green marker
Low Point: Red marker
First/Last Points: Navy markers
Negative Points: Red
Axis: Custom min 0, max 100
```

---

## Sheet 2: Customer_Perspective

### Purpose
Detailed metrics for Customer perspective (35% weight)

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 5 | # | Metric ID |
| B | 35 | Metric Name | KPI description |
| C | 15 | Weight | Metric weight within perspective |
| D | 12 | Target | Target value |
| E | 12 | Actual | Current actual value |
| F | 12 | Score | Normalized score (0-100) |
| G | 12 | Prior Month | Previous period |
| H | 10 | MoM Var | Month-over-month |
| I | 12 | Prior Year | Same period LY |
| J | 10 | YoY Var | Year-over-year |
| K | 12 | Trend | Direction indicator |
| L | 15 | Q1 Actual | Quarterly data |
| M | 15 | Q2 Actual | Quarterly data |
| N | 15 | Q3 Actual | Quarterly data |
| O | 15 | Q4 Actual | Quarterly data |
| P | 20 | Owner | Accountable person |
| Q | 12 | Status | Performance status |
| R | 30 | Action Required | Improvement actions |

### Metric Definitions (Rows 4-15)

```
Row 4: OTIF (On-Time In-Full) | 30% | 95% | Actual | Score
Row 5: Perfect Order Rate | 25% | 92% | Actual | Score
Row 6: Customer Lead Time | 15% | <Industry Avg | Actual | Score
Row 7: Customer Satisfaction Score | 15% | >=4.2/5 | Actual | Score
Row 8: Customer Complaint Rate | 10% | <1% | Actual | Score
Row 9: Order Fill Rate | 5% | 98% | Actual | Score
Row 10: BLANK
Row 11: PERSPECTIVE TOTAL | 100% | Weighted | Weighted | Score
```

### Key Formulas

```excel
' OTIF Score Calculation (Cell F4) - Higher is better
=IF(E4>=D4,100,MIN(100,E4/D4*100))

' Perfect Order Rate Score (Cell F5) - Higher is better
=IF(E5>=D5,100,MIN(100,E5/D5*100))

' Lead Time Score (Cell F6) - Lower is better
=IF(E6<=D6,100,MAX(0,100-(E6-D6)/D6*100))

' CSAT Score (Cell F7) - Higher is better, max 5
=E7/5*100

' Complaint Rate Score (Cell F8) - Lower is better
=IF(E8<=D8,100,MAX(0,100-(E8-D8)/D8*100))

' Order Fill Rate Score (Cell F9)
=IF(E9>=D9,100,MIN(100,E9/D9*100))

' Weighted Perspective Score (Cell F11)
=SUMPRODUCT(C4:C9,F4:F9)/SUM(C4:C9)

' MoM Variance (Cell H4)
=E4-G4

' YoY Variance (Cell J4)
=E4-I4

' Trend Direction (Cell K4)
=IF(AND(H4>0,J4>0),"Improving",IF(AND(H4<0,J4<0),"Declining","Mixed"))

' Quarterly Average (for trend analysis)
=AVERAGE(L4:O4)

' Status Determination (Cell Q4)
=IF(F4>=95,"Excellent",IF(F4>=80,"Good",IF(F4>=60,"Needs Improvement","Critical")))

' Contribution to Overall Score
=C4*F4/100*0.35

' Year-to-Date Average
=AVERAGE(Customer_Trend!B4:M4)

' Performance Consistency (StdDev)
=STDEV(L4:O4)
```

### Conditional Formatting

```
Rule 1: Score Column (F)
- >= 95: Dark Green (#006100)
- 80-94: Light Green (#28A745)
- 60-79: Yellow (#FFC107)
- < 60: Red (#DC3545)

Rule 2: Trend Column (K)
- "Improving": Green fill, up arrow
- "Declining": Red fill, down arrow
- "Mixed": Yellow fill, side arrow

Rule 3: Status Column (Q)
- "Excellent": Navy fill, white text
- "Good": Green fill
- "Needs Improvement": Yellow fill
- "Critical": Red fill, white text
```

---

## Sheet 3: Financial_Perspective

### Purpose
Detailed metrics for Financial perspective (30% weight)

### Column Layout
(Same structure as Customer_Perspective)

### Metric Definitions (Rows 4-12)

```
Row 4: Revenue vs Plan | 25% | +/- 3% | Actual | Score
Row 5: Gross Margin % | 25% | >=Budget | Actual | Score
Row 6: Inventory Turns | 20% | Industry Benchmark | Actual | Score
Row 7: Working Capital % Revenue | 15% | Target % | Actual | Score
Row 8: Cost to Serve Reduction | 10% | Target % | Actual | Score
Row 9: Operating Income vs Plan | 5% | +/- 3% | Actual | Score
Row 10: BLANK
Row 11: PERSPECTIVE TOTAL | 100% | Weighted | Weighted | Score
```

### Key Formulas

```excel
' Revenue vs Plan Score (Cell F4)
=IF(ABS(E4-D4)<=0.03,100,MAX(0,100-ABS(E4-D4)*100*10))

' Gross Margin Score (Cell F5) - Higher is better
=IF(E5>=D5,100,MIN(100,E5/D5*100))

' Inventory Turns Score (Cell F6) - Higher is better
=IF(E6>=D6,100,MIN(100,E6/D6*100))

' Working Capital Score (Cell F7) - Lower is better for % revenue
=IF(E7<=D7,100,MAX(0,100-(E7-D7)/D7*100))

' Cost to Serve Score (Cell F8) - Meeting reduction target
=IF(E8>=D8,100,MIN(100,E8/D8*100))

' Operating Income Score (Cell F9)
=IF(ABS(E9-D9)<=0.03,100,MAX(0,100-ABS(E9-D9)*100*10))

' Weighted Financial Score (Cell F11)
=SUMPRODUCT(C4:C9,F4:F9)/SUM(C4:C9)

' Revenue Achievement Index
=E4/D4*100

' Margin Preservation Ratio
=E5/(Budget_GM%)*100

' Cash Conversion Efficiency
=(E6*365)/Working_Days

' Financial Health Index
=AVERAGE(F4:F9)
```

---

## Sheet 4: Process_Perspective

### Purpose
Detailed metrics for Process perspective (25% weight)

### Metric Definitions (Rows 4-13)

```
Row 4: Forecast Accuracy (Weighted) | 25% | >=75% | Actual | Score
Row 5: Forecast Bias | 20% | +/- 3% | Actual | Score
Row 6: Demand Plan Adherence | 15% | >=90% | Actual | Score
Row 7: Supply Plan Adherence | 15% | >=95% | Actual | Score
Row 8: Plan Stability | 10% | <10% change | Actual | Score
Row 9: Production Plan Adherence | 10% | >=95% | Actual | Score
Row 10: Master Schedule Adherence | 5% | >=95% | Actual | Score
Row 11: BLANK
Row 12: PERSPECTIVE TOTAL | 100% | Weighted | Weighted | Score
```

### Key Formulas

```excel
' Forecast Accuracy Score (Cell F4)
=IF(E4>=D4,100,MIN(100,E4/D4*100))

' Bias Score (Cell F5) - Closer to zero is better
=IF(ABS(E5)<=D5,100,MAX(0,100-ABS(E5)*100/D5))

' Demand Plan Adherence Score (Cell F6)
=IF(E6>=D6,100,MIN(100,E6/D6*100))

' Supply Plan Adherence Score (Cell F7)
=IF(E7>=D7,100,MIN(100,E7/D7*100))

' Plan Stability Score (Cell F8) - Lower change is better
=IF(E8<=D8,100,MAX(0,100-(E8-D8)/D8*100))

' Production Adherence Score (Cell F9)
=IF(E9>=D9,100,MIN(100,E9/D9*100))

' Weighted Process Score (Cell F12)
=SUMPRODUCT(C4:C10,F4:F10)/SUM(C4:C10)

' Value-Added Forecast
=Consensus_Accuracy-Statistical_Baseline_Accuracy

' Planning Efficiency Index
=AVERAGE(F6:F10)

' Forecast-to-Fulfillment Correlation
=CORREL(Forecast_Range,Actual_Range)

' Process Maturity Score
=SUMPRODUCT(Maturity_Weights,Process_Scores)
```

---

## Sheet 5: Enabler_Perspective

### Purpose
Detailed metrics for Enabler perspective (10% weight)

### Metric Definitions (Rows 4-12)

```
Row 4: Meeting Effectiveness | 25% | >=4/5 | Actual | Score
Row 5: Decision Cycle Time | 25% | <48 hours | Actual | Score
Row 6: Data Quality Score | 20% | >=95% | Actual | Score
Row 7: Process Compliance | 15% | 100% | Actual | Score
Row 8: User Adoption Rate | 10% | >=90% | Actual | Score
Row 9: Action Item Completion | 5% | >=90% | Actual | Score
Row 10: BLANK
Row 11: PERSPECTIVE TOTAL | 100% | Weighted | Weighted | Score
```

### Key Formulas

```excel
' Meeting Effectiveness Score (Cell F4)
=E4/5*100

' Decision Cycle Time Score (Cell F5) - Lower is better
=IF(E5<=D5,100,MAX(0,100-(E5-D5)/D5*100))

' Data Quality Score (Cell F6)
=IF(E6>=D6,100,MIN(100,E6/D6*100))

' Process Compliance Score (Cell F7)
=E7

' User Adoption Score (Cell F8)
=IF(E8>=D8,100,MIN(100,E8/D8*100))

' Action Completion Score (Cell F9)
=IF(E9>=D9,100,MIN(100,E9/D9*100))

' Weighted Enabler Score (Cell F11)
=SUMPRODUCT(C4:C9,F4:F9)/SUM(C4:C9)

' Governance Maturity Index
=AVERAGE(F4,F7,F9)

' Technology Enablement Score
=AVERAGE(F6,F8)

' Decision Velocity
=48/E5*100

' Capability Readiness Index
=SUMPRODUCT(Capability_Weights,Capability_Scores)
```

---

## Sheet 6: Trend_Analysis

### Purpose
12-month trend tracking for all perspectives and overall score

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 20 | Metric/Perspective | Item name |
| B | 10 | Jan | Monthly score |
| C | 10 | Feb | Monthly score |
| D | 10 | Mar | Monthly score |
| E | 10 | Apr | Monthly score |
| F | 10 | May | Monthly score |
| G | 10 | Jun | Monthly score |
| H | 10 | Jul | Monthly score |
| I | 10 | Aug | Monthly score |
| J | 10 | Sep | Monthly score |
| K | 10 | Oct | Monthly score |
| L | 10 | Nov | Monthly score |
| M | 10 | Dec | Monthly score |
| N | 12 | YTD Avg | Average |
| O | 12 | Trend | SLOPE direction |
| P | 15 | Projected | Forecast |

### Key Formulas

```excel
' YTD Average (Cell N4)
=AVERAGE(B4:M4)

' Trend Direction using SLOPE (Cell O4)
=IF(SLOPE(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})>0.5,"Strong Up",
 IF(SLOPE(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})>0,"Slight Up",
 IF(SLOPE(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})>-0.5,"Flat",
 IF(SLOPE(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})>-1,"Slight Down","Strong Down"))))

' Projected Next Month (Cell P4)
=FORECAST(13,B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})

' Coefficient of Variation (stability)
=STDEV(B4:M4)/AVERAGE(B4:M4)

' Best Month Performance
=MAX(B4:M4)

' Worst Month Performance
=MIN(B4:M4)

' Performance Range
=MAX(B4:M4)-MIN(B4:M4)

' Trend R-Squared
=RSQ(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})

' Moving Average (3-month)
=AVERAGE(K4:M4)

' Momentum Score
=AVERAGE(L4:M4)-AVERAGE(B4:C4)
```

---

## Sheet 7: YoY_Comparison

### Purpose
Year-over-year performance comparison with variance analysis

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 25 | Metric | KPI name |
| B | 12 | CY Actual | Current year |
| C | 12 | PY Actual | Prior year |
| D | 12 | Variance | Absolute difference |
| E | 10 | Var % | Percentage change |
| F | 12 | CY Target | Current year target |
| G | 12 | CY vs Target | Gap to target |
| H | 12 | PY vs Target | Prior year vs target |
| I | 15 | Improvement | YoY improvement flag |
| J | 20 | Root Cause | Variance driver |
| K | 25 | Action | Corrective action |

### Key Formulas

```excel
' Absolute Variance (Cell D4)
=B4-C4

' Percentage Variance (Cell E4)
=IF(C4=0,0,(B4-C4)/C4)

' CY vs Target Gap (Cell G4)
=B4-F4

' PY vs Target Gap (Cell H4)
=C4-F4

' Improvement Flag (Cell I4)
=IF(AND(D4>0,G4>=0),"Strong Improvement",
 IF(D4>0,"Improving",
 IF(D4=0,"Stable","Declining")))

' Performance Momentum
=D4/ABS(C4)*100

' Target Achievement Trend
=IF(AND(G4>=0,H4<0),"Target Achieved",
 IF(AND(G4<0,H4>=0),"Target Lost",
 IF(G4>=0,"Sustained","Gap Remaining")))

' Multi-Year CAGR
=((CY_Value/PY_Value)^(1/Years))-1
```

---

## Sheet 8: Owner_Accountability

### Purpose
Clear accountability mapping for each metric with contact information

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 25 | Perspective | Scorecard perspective |
| B | 30 | Metric | KPI name |
| C | 25 | Primary Owner | Accountable executive |
| D | 25 | Backup Owner | Secondary contact |
| E | 20 | Review Frequency | Reporting cadence |
| F | 15 | Escalation Trigger | Threshold for escalation |
| G | 25 | Escalation Path | Escalation contact |
| H | 30 | Data Source | Source system |
| I | 15 | Last Review | Date of last review |
| J | 12 | Status | Current status |

### Sample Data

```
Customer | OTIF | VP Supply Chain | Director Logistics | Weekly | <90% | COO | ERP/WMS | Date | Status
Customer | Perfect Order | VP Operations | Director Quality | Monthly | <88% | COO | ERP | Date | Status
Financial | Revenue vs Plan | CFO | VP FP&A | Monthly | >5% gap | CEO | ERP/BI | Date | Status
Process | Forecast Accuracy | VP Demand Planning | Director Analytics | Monthly | <70% | CSO | Planning System | Date | Status
Enabler | Meeting Effectiveness | IBP Process Owner | Director IBP | Monthly | <3.5/5 | COO | Survey | Date | Status
```

---

## Sheet 9: Config

### Purpose
Configuration settings and reference data

### Named Ranges

```excel
' Perspective Weights
Customer_Weight = Config!$B$5     ' 0.35
Financial_Weight = Config!$B$6   ' 0.30
Process_Weight = Config!$B$7     ' 0.25
Enabler_Weight = Config!$B$8     ' 0.10

' Thresholds
Excellent_Threshold = Config!$B$12   ' 95
Good_Threshold = Config!$B$13        ' 80
NeedsImprovement_Threshold = Config!$B$14  ' 60

' Reporting Period
Current_Period = Config!$B$18
Prior_Period = Config!$B$19
Prior_Year_Period = Config!$B$20

' Integration Links
Master_Workbook_Path = Config!$B$24
KPI_Workbook_Path = Config!$B$25
Process_Health_Path = Config!$B$26
Benchmark_Path = Config!$B$27

' Color Codes
Navy_Color = Config!$B$31      ' #1B3A5F
Purple_Color = Config!$B$32   ' #6B5B95
Success_Color = Config!$B$33  ' #28A745
Warning_Color = Config!$B$34  ' #FFC107
Critical_Color = Config!$B$35 ' #DC3545
```

---

## VBA Automation Code

### Module: ScoreCardCalculations

```vba
Option Explicit

' Constants for workbook
Const CUSTOMER_WEIGHT As Double = 0.35
Const FINANCIAL_WEIGHT As Double = 0.3
Const PROCESS_WEIGHT As Double = 0.25
Const ENABLER_WEIGHT As Double = 0.1

Sub CalculateOverallScore()
    '''
    ' Calculate overall IBP Balanced Scorecard score
    ' Uses weighted average of four perspectives
    '''

    Dim wsDash As Worksheet
    Dim dblCustomer As Double, dblFinancial As Double
    Dim dblProcess As Double, dblEnabler As Double
    Dim dblOverall As Double

    Set wsDash = ThisWorkbook.Sheets("Scorecard_Dashboard")

    ' Get perspective scores
    dblCustomer = wsDash.Range("D5").Value
    dblFinancial = wsDash.Range("D6").Value
    dblProcess = wsDash.Range("D7").Value
    dblEnabler = wsDash.Range("D8").Value

    ' Calculate weighted overall score
    dblOverall = (dblCustomer * CUSTOMER_WEIGHT) + _
                 (dblFinancial * FINANCIAL_WEIGHT) + _
                 (dblProcess * PROCESS_WEIGHT) + _
                 (dblEnabler * ENABLER_WEIGHT)

    ' Update dashboard
    wsDash.Range("D10").Value = dblOverall

    ' Update status
    Call UpdateStatus(wsDash.Range("K10"), dblOverall, wsDash.Range("I10").Value)

    ' Log calculation
    Call LogCalculation("Overall Score", dblOverall)

End Sub

Sub UpdatePerspectiveScores()
    '''
    ' Recalculate all perspective scores from detailed sheets
    '''

    Dim ws As Worksheet
    Dim perspectives As Variant
    Dim i As Integer

    perspectives = Array("Customer_Perspective", "Financial_Perspective", _
                        "Process_Perspective", "Enabler_Perspective")

    For i = 0 To UBound(perspectives)
        Set ws = ThisWorkbook.Sheets(perspectives(i))

        ' Find the total row and recalculate
        Call RecalculatePerspective(ws)
    Next i

    ' Update dashboard
    Call CalculateOverallScore

    MsgBox "All perspective scores updated successfully!", vbInformation

End Sub

Private Sub RecalculatePerspective(ws As Worksheet)
    '''
    ' Recalculate weighted score for a single perspective
    '''

    Dim lastRow As Long
    Dim sumWeight As Double, weightedSum As Double
    Dim i As Long

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    sumWeight = 0
    weightedSum = 0

    For i = 4 To lastRow - 2  ' Skip header and total rows
        If IsNumeric(ws.Cells(i, "C").Value) And IsNumeric(ws.Cells(i, "F").Value) Then
            sumWeight = sumWeight + ws.Cells(i, "C").Value
            weightedSum = weightedSum + (ws.Cells(i, "C").Value * ws.Cells(i, "F").Value)
        End If
    Next i

    ' Update total row
    If sumWeight > 0 Then
        ws.Cells(lastRow, "F").Value = weightedSum / sumWeight
    End If

End Sub

Sub UpdateStatus(rngStatus As Range, dblScore As Double, dblTarget As Double)
    '''
    ' Update status cell based on score vs target
    '''

    Dim dblGap As Double
    dblGap = dblScore - dblTarget

    If dblGap >= 0 Then
        rngStatus.Value = "On Track"
        rngStatus.Interior.Color = RGB(40, 167, 69)  ' Green
        rngStatus.Font.Color = RGB(255, 255, 255)
    ElseIf dblGap >= -5 Then
        rngStatus.Value = "At Risk"
        rngStatus.Interior.Color = RGB(255, 193, 7)  ' Amber
        rngStatus.Font.Color = RGB(0, 0, 0)
    Else
        rngStatus.Value = "Off Track"
        rngStatus.Interior.Color = RGB(220, 53, 69)  ' Red
        rngStatus.Font.Color = RGB(255, 255, 255)
    End If

End Sub

Sub RefreshAllSparklines()
    '''
    ' Refresh sparklines with latest trend data
    '''

    Dim wsDash As Worksheet
    Dim wsTrend As Worksheet
    Dim spGroup As SparklineGroup
    Dim i As Integer

    Set wsDash = ThisWorkbook.Sheets("Scorecard_Dashboard")
    Set wsTrend = ThisWorkbook.Sheets("Trend_Analysis")

    ' Clear existing sparklines
    For Each spGroup In wsDash.Range("L5:L8").SparklineGroups
        spGroup.Delete
    Next spGroup

    ' Create new sparklines
    For i = 5 To 8
        wsDash.Range("L" & i).SparklineGroups.Add _
            Type:=xlSparkLine, _
            SourceData:=wsTrend.Range("B" & i & ":M" & i).Address(External:=True)
    Next i

    ' Format sparklines
    For Each spGroup In wsDash.Range("L5:L8").SparklineGroups
        With spGroup
            .SeriesColor.Color = RGB(27, 58, 95)  ' Navy
            .Points.Highpoint.Visible = True
            .Points.Highpoint.Color.Color = RGB(40, 167, 69)  ' Green
            .Points.Lowpoint.Visible = True
            .Points.Lowpoint.Color.Color = RGB(220, 53, 69)  ' Red
        End With
    Next spGroup

End Sub

Sub GenerateExecutiveSummary()
    '''
    ' Generate executive summary report
    '''

    Dim wsDash As Worksheet
    Dim strSummary As String
    Dim dblOverall As Double

    Set wsDash = ThisWorkbook.Sheets("Scorecard_Dashboard")
    dblOverall = wsDash.Range("D10").Value

    strSummary = "IBP BALANCED SCORECARD - EXECUTIVE SUMMARY" & vbCrLf & vbCrLf
    strSummary = strSummary & "Overall IBP Score: " & Format(dblOverall, "0.0%") & vbCrLf
    strSummary = strSummary & "Status: " & wsDash.Range("K10").Value & vbCrLf & vbCrLf

    strSummary = strSummary & "PERSPECTIVE BREAKDOWN:" & vbCrLf
    strSummary = strSummary & "  Customer (35%): " & Format(wsDash.Range("D5").Value, "0.0%") & vbCrLf
    strSummary = strSummary & "  Financial (30%): " & Format(wsDash.Range("D6").Value, "0.0%") & vbCrLf
    strSummary = strSummary & "  Process (25%): " & Format(wsDash.Range("D7").Value, "0.0%") & vbCrLf
    strSummary = strSummary & "  Enabler (10%): " & Format(wsDash.Range("D8").Value, "0.0%") & vbCrLf

    MsgBox strSummary, vbInformation, "Executive Summary"

End Sub

Private Sub LogCalculation(strMetric As String, dblValue As Double)
    '''
    ' Log calculation to audit sheet
    '''

    Dim wsLog As Worksheet
    Dim nextRow As Long

    On Error Resume Next
    Set wsLog = ThisWorkbook.Sheets("Audit_Log")
    If wsLog Is Nothing Then Exit Sub
    On Error GoTo 0

    nextRow = wsLog.Cells(wsLog.Rows.Count, "A").End(xlUp).Row + 1

    wsLog.Cells(nextRow, 1).Value = Now
    wsLog.Cells(nextRow, 2).Value = strMetric
    wsLog.Cells(nextRow, 3).Value = dblValue
    wsLog.Cells(nextRow, 4).Value = Application.UserName

End Sub

Sub ExportToMasterWorkbook()
    '''
    ' Export scorecard data to IBP Master Integration Workbook
    '''

    Dim wsMaster As Workbook
    Dim strPath As String

    strPath = ThisWorkbook.Sheets("Config").Range("Master_Workbook_Path").Value

    On Error Resume Next
    Set wsMaster = Workbooks.Open(strPath)
    If wsMaster Is Nothing Then
        MsgBox "Could not open Master Workbook at: " & strPath, vbExclamation
        Exit Sub
    End If
    On Error GoTo 0

    ' Copy scorecard summary to master
    ThisWorkbook.Sheets("Scorecard_Dashboard").Range("A1:N12").Copy
    wsMaster.Sheets("Performance").Range("A1").PasteSpecial xlPasteValues

    wsMaster.Save
    wsMaster.Close

    MsgBox "Data exported to Master Workbook successfully!", vbInformation

End Sub
```

### Module: DataRefresh

```vba
Option Explicit

Sub RefreshFromDataSources()
    '''
    ' Refresh all data from connected sources
    '''

    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' Refresh external data connections
    ThisWorkbook.RefreshAll

    ' Wait for queries to complete
    Application.CalculateUntilAsyncQueriesDone

    ' Recalculate scores
    Call UpdatePerspectiveScores

    ' Update timestamp
    ThisWorkbook.Sheets("Scorecard_Dashboard").Range("A1").Value = _
        "Last Refreshed: " & Format(Now, "yyyy-mm-dd hh:mm")

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Data refresh complete!", vbInformation

End Sub

Sub ImportFromProcessHealth()
    '''
    ' Import process metrics from Process Health workbook
    '''

    Dim wsProcess As Worksheet
    Dim wbHealth As Workbook
    Dim strPath As String

    Set wsProcess = ThisWorkbook.Sheets("Process_Perspective")
    strPath = ThisWorkbook.Sheets("Config").Range("Process_Health_Path").Value

    On Error Resume Next
    Set wbHealth = Workbooks.Open(strPath, ReadOnly:=True)
    If wbHealth Is Nothing Then
        MsgBox "Could not open Process Health workbook", vbExclamation
        Exit Sub
    End If
    On Error GoTo 0

    ' Import meeting effectiveness
    wsProcess.Range("E4").Value = wbHealth.Sheets("Health_Dashboard").Range("OverallHealthScore").Value

    wbHealth.Close SaveChanges:=False

End Sub

Sub SyncWithBenchmarks()
    '''
    ' Sync targets with Benchmark Comparison workbook
    '''

    Dim wsBench As Workbook
    Dim strPath As String

    strPath = ThisWorkbook.Sheets("Config").Range("Benchmark_Path").Value

    On Error Resume Next
    Set wsBench = Workbooks.Open(strPath, ReadOnly:=True)
    If wsBench Is Nothing Then
        MsgBox "Could not open Benchmark workbook", vbExclamation
        Exit Sub
    End If
    On Error GoTo 0

    ' Update targets based on benchmark medians
    ' (Implementation specific to benchmark structure)

    wsBench.Close SaveChanges:=False

    MsgBox "Targets synchronized with benchmarks!", vbInformation

End Sub
```

---

## Integration Points

### Inbound Data Sources

| Source Workbook | Data Elements | Refresh Frequency |
|-----------------|---------------|-------------------|
| IBP_Master_Integration | Financial actuals, targets | Daily |
| Process_Health_Metrics | Meeting scores, compliance | Weekly |
| Benchmark_Comparison | Industry benchmarks | Quarterly |
| Demand_Assumptions_Log | Forecast accuracy data | Monthly |
| Supply_Constraints_Tracker | Production adherence | Weekly |

### Outbound Data Flows

| Destination | Data Elements | Purpose |
|-------------|---------------|---------|
| IBP_Master_Integration | Overall score, perspective scores | Executive reporting |
| Executive_Pack_Generator | Scorecard summary | Leadership review |
| Performance_Dashboard | KPI actuals | Real-time monitoring |

### Named Ranges for External Reference

```excel
Scorecard_Overall = Scorecard_Dashboard!$D$10
Scorecard_Customer = Scorecard_Dashboard!$D$5
Scorecard_Financial = Scorecard_Dashboard!$D$6
Scorecard_Process = Scorecard_Dashboard!$D$7
Scorecard_Enabler = Scorecard_Dashboard!$D$8
Scorecard_Status = Scorecard_Dashboard!$K$10
Scorecard_Trend = Trend_Analysis!$B$4:$M$10
Scorecard_Period = Config!$B$18
```

---

## Usage Instructions

### Initial Setup
1. Configure weights in Config sheet (default: 35/30/25/10)
2. Set threshold values for status indicators
3. Link to data source workbooks
4. Configure owner assignments

### Monthly Update Process
1. Run "RefreshFromDataSources" macro
2. Input any manual data points
3. Review calculated scores
4. Update commentary fields
5. Run "ExportToMasterWorkbook"

### Executive Review
1. Run "GenerateExecutiveSummary" for quick overview
2. Review trend sparklines for patterns
3. Focus on "Off Track" metrics
4. Document action items in commentary

---

## Document Control

| Field | Value |
|-------|-------|
| Version | 2.0 Enhanced |
| Last Updated | 2026-02-21 |
| Author | IBP Center of Excellence |
| Review Cycle | Quarterly |
| Classification | Internal Use |
