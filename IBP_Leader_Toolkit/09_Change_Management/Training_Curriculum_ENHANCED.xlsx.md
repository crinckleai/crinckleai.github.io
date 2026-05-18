# Training Curriculum - Enhanced Excel Workbook
## IBP Capability Development & Learning Management System

---

## Overview
Comprehensive training curriculum management workbook for IBP capability building. Tracks learning paths, course completion, competency development, and certification progress across all IBP roles and skill levels.

---

## Design Theme: "Learning & Growth"

| Element | Specification |
|---------|---------------|
| Primary Color | Emerald (#047857) |
| Secondary Color | Teal (#0D9488) |
| Complete | Green (#10B981) |
| In Progress | Blue (#3B82F6) |
| Not Started | Gray (#9CA3AF) |
| Required | Red (#EF4444) |
| Optional | Amber (#F59E0B) |

---

# SHEET 1: TRAINING DASHBOARD

## Program Overview

| KPI | Formula | Format |
|-----|---------|--------|
| Total Employees in Program | `=COUNTA(Participants!A:A)-1` | Count |
| Average Completion Rate | `=AVERAGE(Participants!F:F)` | Percentage |
| Certifications Awarded | `=COUNTIF(Certifications!E:E,"Awarded")` | Count |
| Courses Completed (30 days) | `=SUMPRODUCT((Completions!D:D>=TODAY()-30)*1)` | Count |
| Active Learners | `=COUNTIF(Participants!G:G,"Active")` | Count |
| Avg Competency Score | `=AVERAGE(Competency_Matrix!F:F)` | 1-5 scale |
| Training Hours YTD | `=SUM(Completions!E:E)` | Hours |
| Upcoming Sessions | `=COUNTIFS(Calendar!C:C,">="&TODAY(),Calendar!C:C,"<="&TODAY()+30)` | Count |

### Completion by Role (Chart)
```excel
Role              Completion%
IBP Leader        95%
Demand Planner    88%
Supply Planner    82%
Finance Analyst   78%
Executive         65%
```

---

# SHEET 2: COURSE CATALOG

## Available IBP Courses

| Col | Header | Validation |
|-----|--------|------------|
| A | Course_ID | Auto: `="CRS-"&TEXT(ROW()-2,"000")` |
| B | Course Name | Text |
| C | Category | IBP Fundamentals/Demand/Supply/Financial/Process/Technology/Leadership |
| D | Level | Foundation/Intermediate/Advanced/Expert |
| E | Duration (Hours) | Number |
| F | Delivery Mode | Classroom/E-Learning/Virtual/Blended |
| G | Provider | Internal/External vendor |
| H | Required For | Role list |
| I | Prerequisites | Course_ID list |
| J | Description | Course summary |
| K | Learning Objectives | Numbered list |
| L | Assessment Type | Quiz/Project/Simulation/None |
| M | Passing Score | Percentage |
| N | Certification Credit | Yes/No |
| O | Status | Active/Retired/Under Development |
| P | Last Updated | Date |

### Sample Curriculum

| Course_ID | Course Name | Category | Level | Hours | Required For |
|-----------|-------------|----------|-------|-------|--------------|
| CRS-001 | IBP Fundamentals | IBP Fundamentals | Foundation | 8 | All roles |
| CRS-002 | Demand Planning Essentials | Demand | Foundation | 16 | Demand Planner |
| CRS-003 | Statistical Forecasting | Demand | Intermediate | 24 | Demand Planner |
| CRS-004 | Supply Planning Basics | Supply | Foundation | 16 | Supply Planner |
| CRS-005 | Capacity Management | Supply | Intermediate | 16 | Supply Planner |
| CRS-006 | Financial Integration | Financial | Intermediate | 12 | Finance Analyst |
| CRS-007 | Executive IBP | Leadership | Advanced | 8 | Executive |
| CRS-008 | IBP Technology Tools | Technology | Foundation | 12 | All roles |
| CRS-009 | Advanced Scenario Planning | Process | Advanced | 16 | IBP Leader |
| CRS-010 | Change Leadership | Leadership | Advanced | 8 | IBP Leader |

---

# SHEET 3: LEARNING PATHS

## Role-Based Learning Journeys

| Col | Header | Description |
|-----|--------|-------------|
| A | Path_ID | Learning path identifier |
| B | Path Name | Description |
| C | Target Role | Job role |
| D | Foundation Courses | Required base courses |
| E | Intermediate Courses | Next level courses |
| F | Advanced Courses | Expert level courses |
| G | Elective Options | Optional courses |
| H | Total Hours | `=SUM(Foundation_Hours + Intermediate_Hours + Advanced_Hours)` |
| I | Certification Earned | Certificate name |
| J | Expected Timeline | Months to complete |
| K | Active Participants | `=COUNTIFS(Participants!C:C,C3,Participants!G:G,"Active")` |
| L | Completion Rate | `=AVERAGEIF(Participants!C:C,C3,Participants!F:F)` |

### Learning Paths

| Path | Role | Foundation | Intermediate | Advanced | Hours | Cert |
|------|------|------------|--------------|----------|-------|------|
| LP-01 | IBP Leader | CRS-001,008 | CRS-002,004,006 | CRS-009,010 | 100 | IBP Master |
| LP-02 | Demand Planner | CRS-001,008 | CRS-002,003 | None | 60 | Demand Certified |
| LP-03 | Supply Planner | CRS-001,008 | CRS-004,005 | None | 60 | Supply Certified |
| LP-04 | Finance Analyst | CRS-001,008 | CRS-006 | None | 32 | Finance Certified |
| LP-05 | Executive | CRS-001 | CRS-007 | None | 16 | Executive IBP |

---

# SHEET 4: PARTICIPANTS

## Employee Training Roster

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Employee_ID | Employee number |
| B | Name | Full name |
| C | Role | Job title |
| D | Department | Business unit |
| E | Manager | Supervisor name |
| F | **Overall Completion %** | `=COUNTIFS(Completions!A:A,A3,Completions!F:F,"Complete")/COUNTIF(Required!A:A,C3)` |
| G | Status | Active/On Hold/Complete |
| H | Learning Path | Assigned path |
| I | Start Date | Program start |
| J | Target Completion | Expected finish |
| K | **Days Remaining** | `=J3-TODAY()` |
| L | Courses Completed | `=COUNTIFS(Completions!A:A,A3,Completions!F:F,"Complete")` |
| M | Hours Completed | `=SUMIF(Completions!A:A,A3,Completions!E:E)` |
| N | Current Course | Active enrollment |
| O | Next Due | Upcoming deadline |
| P | Certifications | Earned certs |
| Q | Competency Score | Average assessment |
| R | Notes | Comments |

---

# SHEET 5: COMPLETIONS

## Course Completion Records

| Col | Header | Formula |
|-----|--------|---------|
| A | Employee_ID | Participant link |
| B | Course_ID | Course reference |
| C | Course Name | VLOOKUP from catalog |
| D | Completion Date | Date finished |
| E | Hours | Course duration |
| F | Status | Complete/In Progress/Incomplete |
| G | Score | Assessment result |
| H | **Pass/Fail** | `=IF(F3="Complete",IF(G3>=VLOOKUP(B3,Catalog!A:M,13,FALSE),"Pass","Fail"),"N/A")` |
| I | Attempts | Number of attempts |
| J | Instructor | Teacher/facilitator |
| K | Location | Where completed |
| L | Feedback Score | 1-5 satisfaction |
| M | Comments | Participant feedback |

---

# SHEET 6: COMPETENCY MATRIX

## Skill Assessment Framework

| Col | Header | Description |
|-----|--------|-------------|
| A | Employee_ID | Participant |
| B | Competency Area | Skill category |
| C | Competency | Specific skill |
| D | Required Level | 1-5 target |
| E | Current Level | 1-5 assessed |
| F | **Gap** | `=D3-E3` |
| G | Assessment Date | Last evaluated |
| H | Assessor | Who evaluated |
| I | Evidence | Documentation |
| J | Development Action | Improvement plan |
| K | Target Date | When to achieve |

### Competency Levels
| Level | Description | Indicators |
|-------|-------------|------------|
| 1 | Novice | Basic awareness, needs guidance |
| 2 | Developing | Can perform with supervision |
| 3 | Competent | Independent performance |
| 4 | Proficient | Can teach others, optimize |
| 5 | Expert | Thought leader, innovates |

### IBP Competencies
| Area | Competencies |
|------|--------------|
| Demand Planning | Statistical Forecasting, Demand Sensing, Customer Collaboration, Bias Management |
| Supply Planning | Capacity Planning, Inventory Optimization, S&OP Integration, Supplier Management |
| Financial | P&L Integration, Scenario Modeling, Working Capital, Gap Analysis |
| Process | Meeting Facilitation, Decision Making, Cross-functional Leadership, Change Management |
| Technology | Planning Systems, Data Analysis, Reporting, Advanced Analytics |

---

# SHEET 7: CERTIFICATIONS

## Certification Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Cert_ID | Auto-number |
| B | Employee_ID | Participant |
| C | Employee Name | From roster |
| D | Certification | Certificate name |
| E | Status | Pursuing/Awarded/Expired |
| F | Requirements Met | Yes/No/Partial |
| G | Award Date | When earned |
| H | Expiry Date | When renewal needed |
| I | **Days to Expiry** | `=H3-TODAY()` |
| J | Renewal Required | Yes/No |
| K | Renewal Course | Required for renewal |
| L | Badge Issued | Yes/No |

### Certification Requirements
| Certification | Required Courses | Assessment | Validity |
|---------------|-----------------|------------|----------|
| IBP Master | All foundation + advanced | 80% on final | 2 years |
| Demand Certified | CRS-001,002,003,008 | 75% on each | 2 years |
| Supply Certified | CRS-001,004,005,008 | 75% on each | 2 years |
| Finance Certified | CRS-001,006,008 | 75% on each | 2 years |
| Executive IBP | CRS-001,007 | Participation | No expiry |

---

# SHEET 8: TRAINING CALENDAR

## Scheduled Sessions

| Col | Header | Validation |
|-----|--------|------------|
| A | Session_ID | Auto-number |
| B | Course_ID | Course reference |
| C | Date | Session date |
| D | Start Time | Time |
| E | Duration | Hours |
| F | Location | Room/Virtual link |
| G | Instructor | Facilitator |
| H | Capacity | Max attendees |
| I | Enrolled | `=COUNTIF(Enrollments!B:B,A3)` |
| J | **Available Seats** | `=H3-I3` |
| K | Status | Scheduled/Confirmed/Cancelled/Completed |
| L | Materials | Document links |
| M | Prerequisites | Required completion |

---

# SHEET 9: ENROLLMENTS

## Session Registrations

| Col | Header | Formula |
|-----|--------|---------|
| A | Employee_ID | Participant |
| B | Session_ID | Scheduled session |
| C | Course Name | From catalog |
| D | Session Date | From calendar |
| E | Enrollment Date | When registered |
| F | Status | Enrolled/Attended/No-Show/Cancelled |
| G | **Attendance** | Yes/No |
| H | Completion Status | After session |
| I | Pre-Work Complete | Yes/No |
| J | Manager Approved | Yes/No |

---

# SHEET 10: EFFECTIVENESS

## Training Impact Measurement

| Col | Header | Formula |
|-----|--------|---------|
| A | Course_ID | Course reference |
| B | Course Name | Name |
| C | Participants (12 mo) | Count completed |
| D | Avg Satisfaction | Average feedback |
| E | Avg Test Score | Assessment average |
| F | Knowledge Retention (90 day) | Follow-up quiz |
| G | On-the-Job Application | Manager survey |
| H | **Effectiveness Index** | `=AVERAGE(D3/5,E3/100,F3/100,G3/5)*100` |
| I | Business Impact | Measured outcomes |
| J | ROI Estimate | Training investment return |
| K | Recommendations | Improvement actions |

### Kirkpatrick Model
| Level | Measure | Method |
|-------|---------|--------|
| 1. Reaction | Satisfaction | Post-course survey |
| 2. Learning | Knowledge gained | Assessment score |
| 3. Behavior | Application | Manager observation |
| 4. Results | Business impact | KPI improvement |

---

# SHEET 11: BUDGET

## Training Budget Management

| Col | Header | Formula |
|-----|--------|---------|
| A | Category | Budget line |
| B | Annual Budget | Allocated amount |
| C | YTD Spend | `=SUMIF(Expenses!A:A,A3,Expenses!C:C)` |
| D | Committed | Future committed |
| E | **Available** | `=B3-C3-D3` |
| F | **% Utilized** | `=C3/B3` |
| G | Forecast Full Year | Projected total |
| H | Variance | `=B3-G3` |

### Budget Categories
| Category | Typical % |
|----------|-----------|
| External Training | 35% |
| E-Learning Licenses | 25% |
| Internal Facilitation | 15% |
| Materials & Tools | 10% |
| Travel & Venues | 10% |
| Certifications | 5% |

---

# SHEET 12: REPORTS

## Standard Reports

### Report 1: Completion Summary by Department
```excel
Department    Enrolled    Complete    In_Progress    Not_Started    Completion%
Operations    45          38          5              2              84%
Sales         32          25          4              3              78%
Finance       18          14          3              1              78%
Marketing     15          10          3              2              67%
Executive     12          8           2              2              67%
```

### Report 2: Overdue Training
```excel
=FILTER(Participants, Participants[Target_Completion]<TODAY() AND Participants[Status]<>"Complete")
```

### Report 3: Certification Pipeline
```excel
=SUMPRODUCT((Certifications!E:E="Pursuing")*1)
```

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| TC_Courses | Catalog!A:P | All courses |
| TC_Participants | Participants!A:R | All learners |
| TC_Completions | Completions!A:M | All records |
| TC_Avg_Completion | Dashboard!B4 | Overall rate |
| TC_Active_Learners | Dashboard!B6 | Active count |
| TC_Training_Hours | Dashboard!B8 | YTD hours |

---

# VBA AUTOMATION

```vba
Sub RefreshTrainingDashboard()
    Application.ScreenUpdating = False

    ' Refresh all sheets
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("Participants").Calculate
    ThisWorkbook.Sheets("Completions").Calculate

    ' Update timestamp
    ThisWorkbook.Sheets("Dashboard").Range("L1").Value = Now

    Application.ScreenUpdating = True

    MsgBox "Training Dashboard Refreshed" & vbCrLf & _
           "Active Learners: " & Range("TC_Active_Learners").Value & vbCrLf & _
           "Avg Completion: " & Format(Range("TC_Avg_Completion").Value, "0%"), _
           vbInformation
End Sub

Sub SendTrainingReminders()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Participants")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim reminderList As String
    Dim i As Long

    For i = 3 To lastRow
        If ws.Cells(i, 11).Value <= 14 And ws.Cells(i, 11).Value > 0 Then
            reminderList = reminderList & ws.Cells(i, 2).Value & _
                           " - Due: " & Format(ws.Cells(i, 10).Value, "MM/DD") & vbCrLf
        End If
    Next i

    If reminderList <> "" Then
        MsgBox "Training Due Within 14 Days:" & vbCrLf & vbCrLf & reminderList, _
               vbInformation, "Training Reminders"
    End If
End Sub

Sub GenerateCompletionCertificate()
    Dim empID As String
    empID = InputBox("Enter Employee ID:", "Generate Certificate")

    If empID = "" Then Exit Sub

    ' Check completion status
    Dim completion As Double
    completion = Application.WorksheetFunction.VLookup(empID, _
                    ThisWorkbook.Sheets("Participants").Range("A:F"), 6, False)

    If completion >= 1 Then
        MsgBox "Certificate generated for Employee " & empID & vbCrLf & _
               "Completion: 100%", vbInformation
    Else
        MsgBox "Employee has not completed all requirements." & vbCrLf & _
               "Current completion: " & Format(completion, "0%"), vbExclamation
    End If
End Sub

Sub EnrollInCourse()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Enrollments")

    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row + 1

    ws.Cells(nextRow, 5).Value = Date ' Enrollment date
    ws.Cells(nextRow, 6).Value = "Enrolled"

    ws.Cells(nextRow, 1).Select
    MsgBox "New enrollment record created. Please enter Employee ID and Session ID.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Change_Readiness_Assessment | Capability gaps | Named range TC_* |
| Adoption_Tracker | User training status | Cross-reference |
| Competency_Matrix | Skill assessments | Competency link |
| HR_System | Employee data | Power Query |
| LMS | Course completions | Data import |

---

*IBP training curriculum and capability development management system.*
