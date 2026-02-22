# Change Readiness Assessment - Enhanced Excel Workbook
## IBP Organizational Change Readiness Evaluation System

---

## Overview
Comprehensive change readiness assessment workbook for IBP implementations. Evaluates organizational readiness across multiple dimensions, identifies barriers and enablers, and generates actionable recommendations for successful IBP adoption.

---

## Design Theme: "Transformation Ready"

| Element | Specification |
|---------|---------------|
| Primary Color | Violet (#7C3AED) |
| Secondary Color | Purple (#8B5CF6) |
| High Readiness | Green (#10B981) |
| Medium Readiness | Amber (#F59E0B) |
| Low Readiness | Red (#EF4444) |
| Critical Risk | Dark Red (#DC2626) |
| Opportunity | Blue (#3B82F6) |

---

# SHEET 1: READINESS DASHBOARD

## Assessment Overview

| KPI | Formula | Format |
|-----|---------|--------|
| Overall Readiness Score | `=AVERAGE(Dimensions!G:G)` | 0-100 |
| Readiness Level | `=IF(B3>=75,"High",IF(B3>=50,"Medium","Low"))` | Text |
| Dimensions Assessed | `=COUNTA(Dimensions!A:A)-1` | Count |
| High Readiness Areas | `=COUNTIF(Dimensions!H:H,"High")` | Count |
| Areas Needing Attention | `=COUNTIF(Dimensions!H:H,"Low")` | Count |
| Barriers Identified | `=COUNTA(Barriers!A:A)-1` | Count |
| Critical Barriers | `=COUNTIF(Barriers!E:E,"Critical")` | Count |
| Enablers Identified | `=COUNTA(Enablers!A:A)-1` | Count |

### Readiness Gauge
```
Score Range    Status      Color     Action
0-39           Low         Red       Major intervention required
40-59          Medium      Amber     Targeted support needed
60-74          Good        Yellow    Minor adjustments
75-89          High        Green     Ready to proceed
90-100         Excellent   Dark Green   Best practice
```

### Radar Chart: Dimension Scores
```excel
Dimension              Score
Leadership Support     82
Culture Alignment      65
Skills & Capability    58
Process Readiness      72
Technology Readiness   68
Communication          55
Resource Availability  70
Stakeholder Engagement 63
```

---

# SHEET 2: ASSESSMENT DIMENSIONS

## Readiness Dimension Evaluation

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Dimension_ID | Auto-number |
| B | Dimension | Category name |
| C | Description | What is measured |
| D | Weight | Importance (1-5) |
| E | Questions Assessed | Number of questions |
| F | Avg Question Score | Average of responses |
| G | **Weighted Score** | `=F3*D3/5*100` |
| H | **Readiness Level** | `=IF(G3>=75,"High",IF(G3>=50,"Medium","Low"))` |
| I | Key Findings | Summary |
| J | Primary Gaps | Main issues |
| K | Recommendations | Actions needed |
| L | Owner | Responsible person |
| M | Priority | High/Medium/Low |

### Readiness Dimensions
| Dimension | Weight | Description |
|-----------|--------|-------------|
| Executive Sponsorship | 5 | C-suite commitment and visible support |
| Leadership Alignment | 5 | Senior leader buy-in and advocacy |
| Culture & Mindset | 4 | Organizational culture fit |
| Skills & Capabilities | 4 | Workforce competency |
| Process Maturity | 4 | Current process effectiveness |
| Technology Infrastructure | 3 | Systems and tools readiness |
| Data & Analytics | 4 | Data quality and availability |
| Resource Availability | 3 | Budget, people, time |
| Communication Effectiveness | 4 | Information flow |
| Stakeholder Engagement | 4 | Participation and involvement |
| Change History | 3 | Past change success |
| Performance Management | 3 | Metrics and accountability |

---

# SHEET 3: SURVEY QUESTIONS

## Assessment Questionnaire

| Col | Header | Description |
|-----|--------|-------------|
| A | Q_ID | Question identifier |
| B | Dimension | Related dimension |
| C | Question Text | Full question |
| D | Response Type | Scale 1-5/Yes-No/Select |
| E | Anchor Low | What 1 means |
| F | Anchor High | What 5 means |
| G | Target Score | Expected minimum |
| H | Critical | Yes/No (must-have) |

### Sample Questions by Dimension

**Executive Sponsorship**
| Q_ID | Question | Target |
|------|----------|--------|
| ES-01 | Senior executives actively champion the IBP initiative | 4 |
| ES-02 | Resources (budget, people) are committed at executive level | 4 |
| ES-03 | Executives participate in IBP meetings and decisions | 4 |

**Culture & Mindset**
| Q_ID | Question | Target |
|------|----------|--------|
| CM-01 | Cross-functional collaboration is valued and rewarded | 4 |
| CM-02 | Data-driven decision making is the norm | 3 |
| CM-03 | People are open to changing established processes | 3 |

**Skills & Capabilities**
| Q_ID | Question | Target |
|------|----------|--------|
| SC-01 | Staff have the analytical skills required for IBP | 3 |
| SC-02 | Planning expertise exists within the organization | 4 |
| SC-03 | Training resources are available for capability building | 4 |

---

# SHEET 4: SURVEY RESPONSES

## Collected Assessment Data

| Col | Header | Formula |
|-----|--------|---------|
| A | Response_ID | Auto-number |
| B | Respondent_ID | Anonymous ID |
| C | Role | Job function |
| D | Department | Business unit |
| E | Seniority | Level |
| F | Date | Response date |
| G-Z | Q_ID columns | Score 1-5 for each question |
| AA | **Avg Score** | `=AVERAGE(G3:Z3)` |
| AB | Comments | Open text |

### Response Analysis
```excel
Dimension_Score = AVERAGEIFS(Responses[Q_Scores], Questions[Dimension], Dimension_Name)
```

---

# SHEET 5: DIMENSION ANALYSIS

## Detailed Dimension Breakdown

| Col | Header | Formula |
|-----|--------|---------|
| A | Dimension | Category |
| B | Question_ID | Each question |
| C | Question Text | Full question |
| D | Response Count | `=COUNT(Responses!Column)` |
| E | Avg Score | `=AVERAGE(Responses!Column)` |
| F | Std Deviation | `=STDEV(Responses!Column)` |
| G | Target | Expected score |
| H | **Gap** | `=G3-E3` |
| I | **Status** | `=IF(E3>=G3,"Met",IF(E3>=G3-1,"Close","Gap"))` |
| J | % Meeting Target | `=COUNTIF(Responses!Column,">="&G3)/D3` |
| K | Score Distribution | 1-5 breakdown |

### Gap Analysis Formula
```excel
Gap_Severity = IF(Gap > 1.5, "Critical", IF(Gap > 0.5, "Significant", IF(Gap > 0, "Minor", "None")))
```

---

# SHEET 6: BARRIERS

## Identified Barriers to Change

| Col | Header | Formula |
|-----|--------|---------|
| A | Barrier_ID | Auto-number |
| B | Barrier Description | What blocks change |
| C | Dimension | Related area |
| D | Type | Structural/Cultural/Technical/Resource/Political |
| E | **Severity** | Critical/High/Medium/Low |
| F | Frequency Cited | Times mentioned |
| G | Impact Score | 1-5 scale |
| H | Addressability | Easy/Moderate/Difficult |
| I | **Priority Score** | `=G3*IF(H3="Easy",3,IF(H3="Moderate",2,1))` |
| J | Root Cause | Underlying issue |
| K | Mitigation Strategy | How to address |
| L | Owner | Responsible person |
| M | Status | Identified/In Progress/Resolved |

### Common IBP Barriers
| Barrier | Type | Typical Severity |
|---------|------|------------------|
| Functional silos | Cultural | High |
| Lack of data integration | Technical | High |
| Insufficient executive time | Resource | Critical |
| Resistance from sales | Political | High |
| Legacy system limitations | Technical | Medium |
| Skill gaps | Resource | Medium |
| Competing priorities | Resource | High |
| Poor change history | Cultural | Medium |

---

# SHEET 7: ENABLERS

## Change Enablers & Strengths

| Col | Header | Formula |
|-----|--------|---------|
| A | Enabler_ID | Auto-number |
| B | Enabler Description | What supports change |
| C | Dimension | Related area |
| D | Type | Leadership/Culture/Process/Technology/People |
| E | Strength | Strong/Moderate/Emerging |
| F | Leverage Potential | High/Medium/Low |
| G | Current Utilization | How well leveraged |
| H | **Opportunity Score** | `=IF(F3="High",3,IF(F3="Medium",2,1))*IF(G3="Low",3,IF(G3="Medium",2,1))` |
| I | How to Leverage | Action plan |
| J | Quick Win Potential | Yes/No |
| K | Owner | Responsible person |

---

# SHEET 8: STAKEHOLDER ANALYSIS

## Stakeholder Readiness Assessment

| Col | Header | Formula |
|-----|--------|---------|
| A | Stakeholder_ID | Identifier |
| B | Name/Group | Stakeholder |
| C | Role | Position |
| D | Influence Level | High/Medium/Low |
| E | Impact by Change | High/Medium/Low |
| F | Current Attitude | Champion/Supporter/Neutral/Skeptic/Resistor |
| G | Desired Attitude | Target state |
| H | **Engagement Gap** | Position change needed |
| I | Key Concerns | What worries them |
| J | WIIFM | What's in it for them |
| K | Engagement Strategy | How to approach |
| L | Communication Needs | Info requirements |
| M | Owner | Relationship owner |
| N | Status | On track/At risk/Needs attention |

### Stakeholder Matrix (Influence vs. Attitude)
```
            Low Influence    High Influence
Champion    Leverage         Mobilize
Supporter   Maintain         Engage
Neutral     Inform           Convert
Skeptic     Monitor          Address
Resistor    Monitor          Critical Priority
```

---

# SHEET 9: RISK ASSESSMENT

## Change Risk Register

| Col | Header | Formula |
|-----|--------|---------|
| A | Risk_ID | Auto-number |
| B | Risk Description | What could go wrong |
| C | Category | People/Process/Technology/External |
| D | Probability | 1-5 |
| E | Impact | 1-5 |
| F | **Risk Score** | `=D3*E3` |
| G | **Risk Level** | `=IF(F3>=15,"Critical",IF(F3>=9,"High",IF(F3>=4,"Medium","Low")))` |
| H | Warning Signs | Early indicators |
| I | Mitigation Actions | Prevention measures |
| J | Contingency Plan | If risk occurs |
| K | Owner | Responsible person |
| L | Status | Identified/Mitigating/Closed |

### Risk Heat Map
```
         Impact 1    Impact 2    Impact 3    Impact 4    Impact 5
Prob 5   Medium(5)   Medium(10)  High(15)    Critical(20) Critical(25)
Prob 4   Low(4)      Medium(8)   High(12)    High(16)    Critical(20)
Prob 3   Low(3)      Medium(6)   Medium(9)   High(12)    High(15)
Prob 2   Low(2)      Low(4)      Medium(6)   Medium(8)   Medium(10)
Prob 1   Low(1)      Low(2)      Low(3)      Low(4)      Medium(5)
```

---

# SHEET 10: BY DEPARTMENT

## Department Readiness Comparison

| Col | Header | Formula |
|-----|--------|---------|
| A | Department | Business unit |
| B | Respondent Count | `=COUNTIF(Responses!D:D,A3)` |
| C | Avg Overall Score | `=AVERAGEIF(Responses!D:D,A3,Responses!AA:AA)` |
| D | Executive Sponsorship | Dimension avg |
| E | Culture Score | Dimension avg |
| F | Skills Score | Dimension avg |
| G | Process Score | Dimension avg |
| H | Technology Score | Dimension avg |
| I | **Readiness Level** | `=IF(C3>=3.75,"High",IF(C3>=2.5,"Medium","Low"))` |
| J | Top Barrier | Most cited |
| K | Key Enabler | Strongest area |
| L | Priority Actions | Focus areas |

---

# SHEET 11: BY ROLE

## Role-Based Readiness Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Role | Job function |
| B | Count | Respondent count |
| C | Avg Score | Overall average |
| D | Readiness Level | High/Medium/Low |
| E | Perception Gap | vs. Overall avg |
| F | Top Concern | Primary barrier cited |
| G | Support Needed | Key enabler request |
| H | Training Priority | Capability gap |

---

# SHEET 12: RECOMMENDATIONS

## Action Recommendations

| Col | Header | Formula |
|-----|--------|---------|
| A | Rec_ID | Auto-number |
| B | Recommendation | Action statement |
| C | Dimension | Related area |
| D | Addresses Barrier | Barrier_ID |
| E | Leverages Enabler | Enabler_ID |
| F | Impact Potential | High/Medium/Low |
| G | Effort Required | High/Medium/Low |
| H | **Priority Matrix** | `=IF(AND(F3="High",G3="Low"),"Quick Win",IF(AND(F3="High",G3="High"),"Major Project",IF(AND(F3="Low",G3="Low"),"Fill-In","Deprioritize")))` |
| I | Timeline | Immediate/Short/Medium/Long |
| J | Owner | Responsible person |
| K | Success Measure | How to measure |
| L | Status | Planned/In Progress/Complete |

### Priority Matrix
```
            Low Effort      High Effort
High Impact Quick Win       Major Project
Low Impact  Fill-In         Deprioritize
```

---

# SHEET 13: ACTION PLAN

## Implementation Actions

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | Auto-number |
| B | Action | Specific task |
| C | Phase | Pre-launch/Launch/Post-launch |
| D | Dimension | Related area |
| E | Start Date | When to begin |
| F | End Date | Deadline |
| G | Owner | Responsible person |
| H | Resources | What's needed |
| I | Dependencies | Prerequisites |
| J | Status | Not Started/In Progress/Complete |
| K | Progress % | Completion |
| L | Notes | Comments |

---

# SHEET 14: TREND TRACKING

## Readiness Over Time

| Col | Header | Formula |
|-----|--------|---------|
| A | Assessment Date | When measured |
| B | Overall Score | Point-in-time score |
| C | Change vs Prior | `=B3-B2` |
| D | Executive Score | Dimension trend |
| E | Culture Score | Dimension trend |
| F | Skills Score | Dimension trend |
| G | Response Rate | Participation % |
| H | Barriers Resolved | Closed barriers |
| I | New Barriers | Newly identified |
| J | Net Progress | `=H3-I3` |

---

# SHEET 15: SETTINGS

## Assessment Configuration

| Setting | Value |
|---------|-------|
| Organization Name | [Company] |
| Assessment Version | 1.0 |
| Assessment Date | [Date] |
| Target Readiness | 75 |
| Minimum Responses | 30 |
| Dimension Weights | Standard |
| Anonymity Level | Department |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| CR_Overall_Score | Dashboard!B3 | Readiness score |
| CR_Readiness_Level | Dashboard!B4 | Level text |
| CR_Dimensions | Dimensions!A:M | All dimensions |
| CR_Barriers | Barriers!A:M | All barriers |
| CR_Enablers | Enablers!A:K | All enablers |
| CR_Responses | Responses!A:AB | Survey data |
| CR_High_Readiness | Dashboard!B6 | Count high |
| CR_Low_Readiness | Dashboard!B7 | Count low |

---

# VBA AUTOMATION

```vba
Sub RefreshReadinessAssessment()
    Application.ScreenUpdating = False

    ' Recalculate all sheets
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("Dimension_Analysis").Calculate
    ThisWorkbook.Sheets("Barriers").Calculate

    ' Update timestamp
    ThisWorkbook.Sheets("Dashboard").Range("L1").Value = Now

    Application.ScreenUpdating = True

    MsgBox "Readiness Assessment Refreshed!" & vbCrLf & _
           "Overall Score: " & Format(Range("CR_Overall_Score").Value, "0") & vbCrLf & _
           "Readiness Level: " & Range("CR_Readiness_Level").Value, _
           vbInformation
End Sub

Sub IdentifyTopBarriers()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Barriers")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim criticalCount As Long
    criticalCount = Application.WorksheetFunction.CountIf(ws.Range("E:E"), "Critical")

    If criticalCount > 0 Then
        MsgBox "Warning: " & criticalCount & " critical barriers identified!" & vbCrLf & _
               "Review the Barriers sheet for immediate attention items.", _
               vbExclamation, "Critical Barriers Alert"
    End If
End Sub

Sub GenerateReadinessReport()
    Dim newWb As Workbook
    Set newWb = Workbooks.Add

    ' Export dashboard
    ThisWorkbook.Sheets("Dashboard").UsedRange.Copy newWb.Sheets(1).Range("A1")
    newWb.Sheets(1).Name = "Readiness_Summary"

    ' Export dimensions
    ThisWorkbook.Sheets("Dimensions").UsedRange.Copy
    newWb.Sheets.Add After:=newWb.Sheets(1)
    newWb.Sheets(2).Paste
    newWb.Sheets(2).Name = "Dimension_Details"

    ' Export recommendations
    ThisWorkbook.Sheets("Recommendations").UsedRange.Copy
    newWb.Sheets.Add After:=newWb.Sheets(2)
    newWb.Sheets(3).Paste
    newWb.Sheets(3).Name = "Action_Plan"

    newWb.SaveAs "Readiness_Report_" & Format(Date, "YYYYMMDD") & ".xlsx"
    newWb.Close

    MsgBox "Readiness report exported successfully.", vbInformation
End Sub

Sub CalculateDimensionScores()
    Dim wsDim As Worksheet
    Set wsDim = ThisWorkbook.Sheets("Dimensions")

    Dim wsResp As Worksheet
    Set wsResp = ThisWorkbook.Sheets("Responses")

    ' Recalculate dimension scores from survey responses
    wsDim.Calculate

    MsgBox "Dimension scores recalculated from " & _
           (wsResp.Cells(wsResp.Rows.Count, "A").End(xlUp).Row - 2) & _
           " survey responses.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Training_Curriculum | Skill gaps | Named range CR_* |
| Adoption_Tracker | Change adoption | Cross-reference |
| Communication_Plan | Stakeholder comms | Stakeholder data |
| Risk_Register | Change risks | Risk integration |
| Stakeholder_Analysis | Engagement gaps | Power Query |

---

*IBP change readiness assessment for organizational transformation success.*
