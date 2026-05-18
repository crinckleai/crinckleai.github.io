# Gap Analysis By Dimension - Enhanced Excel Workbook
## IBP Maturity Gap Identification & Prioritization System

---

## Overview
Comprehensive gap analysis workbook that evaluates IBP maturity across all dimensions, identifies capability gaps, quantifies improvement opportunities, and prioritizes actions for systematic maturity advancement.

---

## Design Theme: "Gap to Excellence"

| Element | Specification |
|---------|---------------|
| Primary Color | Slate (#475569) |
| Secondary Color | Blue (#3B82F6) |
| No Gap | Green (#10B981) |
| Minor Gap | Yellow (#EAB308) |
| Moderate Gap | Amber (#F59E0B) |
| Significant Gap | Orange (#F97316) |
| Critical Gap | Red (#EF4444) |

---

# SHEET 1: GAP ANALYSIS DASHBOARD

## Overall Gap Summary

| KPI | Formula | Format |
|-----|---------|--------|
| Overall Maturity Score | `=AVERAGE(Dimensions!G:G)` | 1-5 |
| Target Maturity | `=Settings!B3` | 1-5 |
| **Overall Gap** | `=B4-B3` | Number |
| Dimensions with Critical Gaps | `=COUNTIF(Dimensions!J:J,"Critical")` | Count |
| Dimensions with Significant Gaps | `=COUNTIF(Dimensions!J:J,"Significant")` | Count |
| Dimensions On Target | `=COUNTIF(Dimensions!J:J,"None")` | Count |
| Total Improvement Actions | `=COUNTA(Actions!A:A)-1` | Count |
| Estimated Effort (Person-Days) | `=SUM(Actions!H:H)` | Days |
| Estimated Investment | `=SUM(Actions!I:I)` | Currency |

### Gap Heat Map Summary
```
Dimension              Current   Target   Gap    Severity
Process Governance     2.8       4.0      1.2    Significant
Demand Planning        3.2       4.0      0.8    Moderate
Supply Planning        3.0       4.0      1.0    Significant
Financial Integration  2.5       4.0      1.5    Critical
Technology & Data      2.8       4.0      1.2    Significant
Organization & People  3.5       4.0      0.5    Minor
Performance Management 3.0       4.0      1.0    Significant
```

---

# SHEET 2: DIMENSIONS

## Maturity Dimension Overview

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Dimension_ID | Auto-number |
| B | Dimension Name | IBP dimension |
| C | Description | What is measured |
| D | Weight | Importance (1-5) |
| E | Sub-Elements | Count of elements |
| F | Target Maturity | 1-5 goal |
| G | **Current Maturity** | `=AVERAGE(Detail!Score for this dimension)` |
| H | **Gap** | `=F3-G3` |
| I | **Weighted Gap** | `=H3*D3` |
| J | **Gap Severity** | `=IF(H3>=1.5,"Critical",IF(H3>=1,"Significant",IF(H3>=0.5,"Moderate",IF(H3>0,"Minor","None"))))` |
| K | Priority Rank | `=RANK(I3,I:I)` |
| L | Key Issues | Primary gaps |
| M | Quick Wins | Easy improvements |
| N | Owner | Responsible person |

### IBP Maturity Dimensions
| Dimension | Weight | Elements |
|-----------|--------|----------|
| Process Governance | 5 | Calendar, meetings, escalation, decisions |
| Demand Planning | 5 | Forecasting, sensing, collaboration, bias |
| Supply Planning | 5 | Capacity, inventory, network, response |
| Financial Integration | 5 | P&L, working capital, scenarios, alignment |
| Product Management | 4 | Portfolio, NPI, lifecycle, rationalization |
| Technology & Data | 4 | Systems, integration, analytics, quality |
| Organization & People | 4 | Structure, skills, culture, collaboration |
| Performance Management | 4 | KPIs, reviews, accountability, improvement |
| External Integration | 3 | Customer, supplier, market, ecosystem |
| Continuous Improvement | 3 | Innovation, learning, benchmarking, optimization |

---

# SHEET 3: DETAILED ELEMENTS

## Element-Level Gap Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Element_ID | Auto-number |
| B | Dimension | Parent dimension |
| C | Element Name | Specific capability |
| D | Description | What it measures |
| E | Maturity Criteria L1 | Level 1 description |
| F | Maturity Criteria L2 | Level 2 description |
| G | Maturity Criteria L3 | Level 3 description |
| H | Maturity Criteria L4 | Level 4 description |
| I | Maturity Criteria L5 | Level 5 description |
| J | Target Level | 1-5 goal |
| K | Current Level | 1-5 assessed |
| L | **Gap** | `=J3-K3` |
| M | **Gap Severity** | As above |
| N | Evidence | Assessment basis |
| O | Assessment Date | When evaluated |
| P | Assessor | Who evaluated |

### Sample Elements - Demand Planning
| Element | Target | Current | Gap |
|---------|--------|---------|-----|
| Statistical Forecasting | 4 | 3 | 1 |
| Demand Sensing | 4 | 2 | 2 |
| Customer Collaboration | 4 | 2 | 2 |
| Bias Management | 4 | 3 | 1 |
| Segmented Planning | 4 | 3 | 1 |
| Consensus Process | 4 | 4 | 0 |
| Market Intelligence | 3 | 2 | 1 |
| Promotional Planning | 4 | 3 | 1 |

---

# SHEET 4: GAP PRIORITIZATION

## Prioritized Gap Closure Actions

| Col | Header | Formula |
|-----|--------|---------|
| A | Gap_ID | Identifier |
| B | Dimension | Related dimension |
| C | Element | Specific gap |
| D | Gap Size | Levels to close |
| E | Business Impact | High/Medium/Low |
| F | Effort Required | High/Medium/Low |
| G | **Priority Matrix** | `=IF(AND(E3="High",F3="Low"),"Quick Win",IF(AND(E3="High",F3="High"),"Major Initiative",IF(AND(E3="Low",F3="Low"),"Fill-In","Deprioritize")))` |
| H | **Priority Score** | `=IF(E3="High",3,IF(E3="Medium",2,1))*IF(F3="Low",3,IF(F3="Medium",2,1))*D3` |
| I | Priority Rank | `=RANK(H3,H:H)` |
| J | Dependencies | Prerequisites |
| K | Risks | Implementation risks |
| L | Owner | Responsible person |
| M | Target Close Date | When to achieve |
| N | Status | Not Started/In Progress/Closed |

### Priority Matrix Logic
```
                High Impact     Medium Impact    Low Impact
Low Effort      Quick Win       Quick Win        Fill-In
                (Priority 1)    (Priority 2)     (Priority 4)

Medium Effort   Major Init      Targeted         Deprioritize
                (Priority 2)    (Priority 3)     (Priority 5)

High Effort     Major Init      Deprioritize     Deprioritize
                (Priority 3)    (Priority 4)     (Priority 5)
```

---

# SHEET 5: IMPROVEMENT ACTIONS

## Detailed Action Plan

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | Auto-number |
| B | Gap_ID | Related gap |
| C | Action Description | What to do |
| D | Dimension | IBP area |
| E | From Level | Starting maturity |
| F | To Level | Target maturity |
| G | Timeline | Short/Medium/Long |
| H | Effort (Person-Days) | Resource estimate |
| I | Investment ($) | Cost estimate |
| J | Owner | Responsible person |
| K | Start Date | Planned start |
| L | End Date | Planned end |
| M | Dependencies | Prerequisites |
| N | Success Criteria | How to measure |
| O | Status | Not Started/In Progress/Complete |
| P | Progress % | Completion |
| Q | Blockers | Current issues |

### Timeline Definitions
| Timeline | Duration | Typical Actions |
|----------|----------|-----------------|
| Short | 0-3 months | Quick wins, process changes |
| Medium | 3-9 months | System enhancements, training |
| Long | 9-18 months | Major implementations, transformations |

---

# SHEET 6: BY DIMENSION DETAIL

## Dimension Deep-Dive Analysis

### Template for Each Dimension (Repeat for all 10)

**DEMAND PLANNING DIMENSION**

| Element | Current | Target | Gap | Severity | Priority | Action |
|---------|---------|--------|-----|----------|----------|--------|
| Statistical Forecasting | 3 | 4 | 1 | Moderate | 2 | Implement ML models |
| Demand Sensing | 2 | 4 | 2 | Critical | 1 | Deploy sensing tool |
| Customer Collaboration | 2 | 4 | 2 | Critical | 1 | Launch customer portal |
| Bias Management | 3 | 4 | 1 | Moderate | 3 | Enhance tracking |
| Segmented Planning | 3 | 4 | 1 | Moderate | 4 | Refine segmentation |
| Consensus Process | 4 | 4 | 0 | None | - | Maintain |
| Market Intelligence | 2 | 3 | 1 | Moderate | 5 | Integrate market data |
| Promotional Planning | 3 | 4 | 1 | Moderate | 3 | Improve promo lift |

**Dimension Summary**
```excel
Avg Current:     2.75
Avg Target:      3.88
Avg Gap:         1.13
Weighted Score:  2.75
Status:          Significant Gaps
```

---

# SHEET 7: GAP TRENDS

## Gap Closure Progress Over Time

| Col | Header | Formula |
|-----|--------|---------|
| A | Period | Month/Quarter |
| B | Overall Maturity | Average score |
| C | Target | Goal |
| D | **Gap** | `=C3-B3` |
| E | Gap Change | `=D2-D3` (improvement) |
| F | Process Governance | Dimension score |
| G | Demand Planning | Dimension score |
| H | Supply Planning | Dimension score |
| I | Financial Integration | Dimension score |
| J | Technology & Data | Dimension score |
| K | Gaps Closed | Actions completed |
| L | New Gaps | Gaps identified |
| M | Net Progress | `=K3-L3` |

---

# SHEET 8: ROOT CAUSE ANALYSIS

## Gap Root Cause Identification

| Col | Header | Description |
|-----|--------|-------------|
| A | Gap_ID | Related gap |
| B | Dimension | IBP area |
| C | Gap Description | What's missing |
| D | Symptom | Observable issue |
| E | Root Cause Category | People/Process/Technology/Data/Culture |
| F | Root Cause Detail | Specific cause |
| G | Contributing Factors | Secondary causes |
| H | Why (5 Whys) | Deep analysis |
| I | Systemic Issue | Yes/No |
| J | Addressable | Yes/Partial/No |
| K | Solution Approach | How to fix |
| L | Related Gaps | Connected issues |

### Root Cause Categories
| Category | Common Causes | Solution Types |
|----------|---------------|----------------|
| People | Skills, capacity, engagement | Training, hiring, change mgmt |
| Process | Missing steps, unclear roles | Process design, documentation |
| Technology | System gaps, integration | Implementation, upgrades |
| Data | Quality, availability, timeliness | Governance, cleansing |
| Culture | Silos, resistance, priorities | Change management, leadership |

---

# SHEET 9: IMPACT ANALYSIS

## Gap Impact Quantification

| Col | Header | Formula |
|-----|--------|---------|
| A | Gap_ID | Identifier |
| B | Gap Description | What's missing |
| C | Impact Category | Revenue/Cost/Service/Risk/Efficiency |
| D | Impact Type | Direct/Indirect |
| E | Current State Impact | Quantified current |
| F | Future State Benefit | Quantified improvement |
| G | **Net Opportunity** | `=F3-E3` |
| H | Confidence Level | High/Medium/Low |
| I | Measurement Method | How calculated |
| J | Data Source | Where from |
| K | Assumptions | Key assumptions |
| L | Annual Value | `=G3*12 if monthly` |
| M | 3-Year Value | `=L3*3` (simple) |

### Impact Categories
| Category | Typical Metrics | Value Driver |
|----------|-----------------|--------------|
| Revenue | Forecast accuracy → availability | Lost sales reduction |
| Cost | Planning efficiency | FTE productivity |
| Service | OTIF improvement | Customer retention |
| Risk | Supply disruption reduction | Avoided losses |
| Efficiency | Cycle time reduction | Working capital |

---

# SHEET 10: RESOURCE REQUIREMENTS

## Gap Closure Resource Planning

| Col | Header | Formula |
|-----|--------|---------|
| A | Resource Type | Category |
| B | Q1 Need | FTEs/$ |
| C | Q2 Need | FTEs/$ |
| D | Q3 Need | FTEs/$ |
| E | Q4 Need | FTEs/$ |
| F | **Total Year** | `=SUM(B3:E3)` |
| G | Available | Current capacity |
| H | **Gap** | `=F3-G3` |
| I | Source | Internal/External/Hire |
| J | Status | Secured/Planned/Gap |

### Resource Categories
| Resource | Description |
|----------|-------------|
| Internal FTEs | Full-time employee effort |
| External Consultants | Outside expertise |
| Technology Investment | Software, tools |
| Training Budget | Capability building |
| Infrastructure | Systems, hardware |
| Change Management | Communication, adoption |

---

# SHEET 11: QUICK WINS

## Immediate Improvement Opportunities

| Col | Header | Formula |
|-----|--------|---------|
| A | Quick_Win_ID | Identifier |
| B | Description | Action |
| C | Dimension | IBP area |
| D | Gap Addressed | What improves |
| E | Effort (Days) | Resource need |
| F | Timeline (Weeks) | Duration |
| G | Expected Benefit | Improvement |
| H | Owner | Responsible |
| I | Start Date | When to begin |
| J | Status | Planned/In Progress/Done |
| K | Actual Benefit | Realized improvement |

### Quick Win Criteria
- Effort: <10 person-days
- Timeline: <6 weeks
- Dependencies: Minimal
- Risk: Low
- Visibility: Demonstrable results

---

# SHEET 12: COMPARISON

## Benchmarking Gap Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Dimension | IBP area |
| B | Your Score | Current maturity |
| C | Industry Median | Benchmark |
| D | Best-in-Class | Top performers |
| E | **Gap to Median** | `=C3-B3` |
| F | **Gap to Best** | `=D3-B3` |
| G | Percentile | Where you rank |
| H | Competitive Position | Lead/Parity/Lag |
| I | Strategic Importance | High/Medium/Low |
| J | Investment Priority | Based on strategy |

---

# SHEET 13: SETTINGS

## Assessment Configuration

| Setting | Value |
|---------|-------|
| Organization | [Company Name] |
| Assessment Date | [Date] |
| Target Maturity Level | 4.0 |
| Assessment Version | 1.0 |
| Planning Horizon | 24 months |
| Gap Severity Thresholds | Critical: ≥1.5, Significant: ≥1.0, Moderate: ≥0.5, Minor: >0 |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| GA_Overall_Maturity | Dashboard!B3 | Current maturity |
| GA_Target_Maturity | Dashboard!B4 | Target level |
| GA_Overall_Gap | Dashboard!B5 | Gap size |
| GA_Dimensions | Dimensions!A:N | All dimensions |
| GA_Elements | Detailed_Elements!A:P | All elements |
| GA_Actions | Actions!A:Q | All actions |
| GA_Critical_Count | Dashboard!B6 | Critical gaps |
| GA_Significant_Count | Dashboard!B7 | Significant gaps |

---

# VBA AUTOMATION

```vba
Sub RefreshGapAnalysis()
    Application.ScreenUpdating = False

    ' Recalculate all sheets
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("Dimensions").Calculate
    ThisWorkbook.Sheets("Gap_Prioritization").Calculate
    ThisWorkbook.Sheets("Actions").Calculate

    ' Update timestamp
    ThisWorkbook.Sheets("Settings").Range("B10").Value = Now

    Application.ScreenUpdating = True

    MsgBox "Gap Analysis Refreshed!" & vbCrLf & _
           "Overall Maturity: " & Format(Range("GA_Overall_Maturity").Value, "0.0") & vbCrLf & _
           "Overall Gap: " & Format(Range("GA_Overall_Gap").Value, "0.0") & vbCrLf & _
           "Critical Gaps: " & Range("GA_Critical_Count").Value, _
           vbInformation
End Sub

Sub IdentifyCriticalGaps()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Dimensions")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim criticalList As String
    Dim i As Long

    For i = 3 To lastRow
        If ws.Cells(i, 10).Value = "Critical" Then
            criticalList = criticalList & ws.Cells(i, 2).Value & _
                           " (Gap: " & Format(ws.Cells(i, 8).Value, "0.0") & ")" & vbCrLf
        End If
    Next i

    If criticalList <> "" Then
        MsgBox "Critical Gaps Requiring Immediate Attention:" & vbCrLf & vbCrLf & _
               criticalList, vbExclamation, "Critical Gap Alert"
    Else
        MsgBox "No critical gaps identified.", vbInformation
    End If
End Sub

Sub GenerateGapReport()
    Dim newWb As Workbook
    Set newWb = Workbooks.Add

    ' Export dashboard
    ThisWorkbook.Sheets("Dashboard").UsedRange.Copy newWb.Sheets(1).Range("A1")
    newWb.Sheets(1).Name = "Gap_Summary"

    ' Export dimensions
    ThisWorkbook.Sheets("Dimensions").UsedRange.Copy
    newWb.Sheets.Add After:=newWb.Sheets(1)
    newWb.Sheets(2).Paste
    newWb.Sheets(2).Name = "Dimension_Gaps"

    ' Export prioritized actions
    ThisWorkbook.Sheets("Actions").UsedRange.Copy
    newWb.Sheets.Add After:=newWb.Sheets(2)
    newWb.Sheets(3).Paste
    newWb.Sheets(3).Name = "Action_Plan"

    newWb.SaveAs "Gap_Analysis_Report_" & Format(Date, "YYYYMMDD") & ".xlsx"
    newWb.Close

    MsgBox "Gap analysis report exported successfully.", vbInformation
End Sub

Sub CalculatePriorityScores()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Gap_Prioritization")

    ws.Calculate

    MsgBox "Priority scores recalculated. Check the Priority Rank column.", vbInformation
End Sub

Sub UpdateGapStatus()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Actions")

    Dim actID As String
    actID = InputBox("Enter Action ID to update:", "Update Gap Status")

    If actID = "" Then Exit Sub

    Dim r As Range
    Set r = ws.Range("A:A").Find(actID, LookIn:=xlValues)

    If Not r Is Nothing Then
        r.Offset(0, 14).Value = "Complete" ' Status column
        r.Offset(0, 15).Value = 100 ' Progress %
        MsgBox "Action " & actID & " marked as complete.", vbInformation
    Else
        MsgBox "Action ID not found.", vbExclamation
    End If
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Maturity_Assessment | Overall scores | GA_* named ranges |
| Improvement_Roadmap | Actions link | Action_ID reference |
| Benchmark_Comparison | External benchmarks | Cross-reference |
| Gap_Closure_Tracker | Initiative tracking | Gap_ID link |
| Strategic_Initiatives | Major initiatives | Project connection |

---

*IBP maturity gap analysis with prioritization and action planning capabilities.*
