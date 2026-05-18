# Action Item Tracker - Enhanced Excel Workbook
## IBP Meeting Action Management & Accountability System

---

## Overview
Comprehensive action item tracking workbook for IBP meetings with assignment management, deadline tracking, escalation protocols, and completion analytics. Ensures accountability and drives execution across all IBP pillars.

---

## Design Theme: "Execution Excellence"

| Element | Specification |
|---------|---------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Teal (#0D9488) |
| Complete | Green (#10B981) |
| In Progress | Blue (#3B82F6) |
| At Risk | Amber (#F59E0B) |
| Overdue | Red (#EF4444) |
| Not Started | Gray (#6B7280) |

---

# SHEET 1: ACTION DASHBOARD

## KPI Tiles

| KPI | Formula | Format |
|-----|---------|--------|
| Total Open Actions | `=COUNTIFS(Actions!H:H,"<>Complete",Actions!H:H,"<>Cancelled")` | Number |
| Actions Due This Week | `=COUNTIFS(Actions!G:G,">="&TODAY(),Actions!G:G,"<="&TODAY()+7,Actions!H:H,"<>Complete")` | Number |
| Overdue Actions | `=COUNTIFS(Actions!G:G,"<"&TODAY(),Actions!H:H,"<>Complete",Actions!H:H,"<>Cancelled")` | Number |
| Completion Rate (30 Days) | `=COUNTIFS(Actions!I:I,">="&TODAY()-30,Actions!H:H,"Complete")/COUNTIFS(Actions!E:E,">="&TODAY()-30)` | Percentage |
| On-Time Completion % | `=COUNTIFS(Actions!I:I,"<="&Actions!G:G,Actions!H:H,"Complete")/COUNTIF(Actions!H:H,"Complete")` | Percentage |
| Avg Days to Complete | `=AVERAGEIFS(Actions!J:J,Actions!H:H,"Complete")` | Days |
| Actions by Pillar | Chart data | Pie chart |
| Owner Workload | Chart data | Bar chart |

### Conditional Formatting
- Overdue >5 days: Red bold
- Overdue 1-5 days: Orange
- Due within 3 days: Yellow
- Complete: Green checkmark

---

# SHEET 2: ACTION ITEMS

## Main Action Register

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Action_ID | Auto: `="ACT-"&TEXT(YEAR(E3),"0000")&"-"&TEXT(ROW()-2,"0000")` |
| B | Action Description | Text |
| C | IBP Pillar | Dropdown: Product/Demand/Supply/Financial/Executive |
| D | Source Meeting | Reference to meeting |
| E | Created Date | Date |
| F | Owner | Dropdown from team list |
| G | Due Date | Date |
| H | **Status** | Dropdown: Not Started/In Progress/Complete/Blocked/Cancelled |
| I | Completion Date | Date (when complete) |
| J | **Days to Complete** | `=IF(H3="Complete",I3-E3,TODAY()-E3)` |
| K | **Days Until Due** | `=IF(H3="Complete","N/A",G3-TODAY())` |
| L | **Priority** | High/Medium/Low |
| M | Category | Dropdown: Process/Data/System/People/Other |
| N | Related Decision | Decision_ID link |
| O | Related Risk | Risk_ID link |
| P | Deliverable | Expected output |
| Q | Progress % | 0-100% |
| R | Last Update | Date |
| S | Comments | Text |
| T | Escalation Required | Yes/No |

### Status Logic
```excel
Auto_Status = IF(H3="Complete", "Complete",
              IF(G3<TODAY(), "Overdue",
              IF(G3<=TODAY()+3, "Due Soon",
              IF(Q3>0, "In Progress", "Not Started"))))
```

### Conditional Formatting
- Status "Complete": Green row (#D1FAE5)
- Status "Overdue": Red row (#FEE2E2)
- Status "Blocked": Yellow row (#FEF3C7)
- Priority "High" + Overdue: Red bold text

---

# SHEET 3: MY ACTIONS

## Personal Action View (Filter by Current User)

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | `=IF(Actions!F3=Settings!$B$2,Actions!A3,"")` |
| B | Description | Filtered by owner |
| C | Due Date | From Actions |
| D | Days Until Due | From Actions |
| E | Status | From Actions |
| F | Priority | From Actions |
| G | Progress % | From Actions |
| H | Source | From Actions |
| I | Quick Status | `=IF(E3="Complete","Done",IF(D3<0,"OVERDUE",IF(D3<=3,"URGENT","OK")))` |

### Summary Metrics
```excel
My Total Open: =COUNTIFS(Actions!F:F,Current_User,Actions!H:H,"<>Complete")
My Overdue: =COUNTIFS(Actions!F:F,Current_User,Actions!H:H,"<>Complete",Actions!G:G,"<"&TODAY())
My Due This Week: =COUNTIFS(Actions!F:F,Current_User,Actions!G:G,">="&TODAY(),Actions!G:G,"<="&TODAY()+7)
```

---

# SHEET 4: BY OWNER

## Owner Workload Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Owner | Team member name |
| B | Total Assigned | `=COUNTIF(Actions!F:F,A3)` |
| C | Open Actions | `=COUNTIFS(Actions!F:F,A3,Actions!H:H,"<>Complete",Actions!H:H,"<>Cancelled")` |
| D | Complete | `=COUNTIFS(Actions!F:F,A3,Actions!H:H,"Complete")` |
| E | Overdue | `=COUNTIFS(Actions!F:F,A3,Actions!H:H,"<>Complete",Actions!G:G,"<"&TODAY())` |
| F | Completion Rate | `=D3/B3` |
| G | On-Time Rate | `=COUNTIFS(Actions!F:F,A3,Actions!I:I,"<="&Actions!G:G)/D3` |
| H | Avg Days to Complete | `=AVERAGEIFS(Actions!J:J,Actions!F:F,A3,Actions!H:H,"Complete")` |
| I | High Priority Open | `=COUNTIFS(Actions!F:F,A3,Actions!L:L,"High",Actions!H:H,"<>Complete")` |
| J | Workload Status | `=IF(C3>10,"Overloaded",IF(C3>5,"Heavy","Normal"))` |

---

# SHEET 5: BY PILLAR

## IBP Pillar Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | IBP Pillar | Product/Demand/Supply/Financial/Executive |
| B | Total Actions | `=COUNTIF(Actions!C:C,A3)` |
| C | Open | `=COUNTIFS(Actions!C:C,A3,Actions!H:H,"<>Complete",Actions!H:H,"<>Cancelled")` |
| D | Complete | `=COUNTIFS(Actions!C:C,A3,Actions!H:H,"Complete")` |
| E | Overdue | `=COUNTIFS(Actions!C:C,A3,Actions!H:H,"<>Complete",Actions!G:G,"<"&TODAY())` |
| F | Completion Rate | `=D3/B3` |
| G | Avg Cycle Time | `=AVERAGEIFS(Actions!J:J,Actions!C:C,A3,Actions!H:H,"Complete")` |
| H | High Priority | `=COUNTIFS(Actions!C:C,A3,Actions!L:L,"High")` |
| I | Blocked | `=COUNTIFS(Actions!C:C,A3,Actions!H:H,"Blocked")` |

---

# SHEET 6: BY MEETING

## Meeting-Sourced Actions

| Col | Header | Formula |
|-----|--------|---------|
| A | Meeting | Meeting reference |
| B | Meeting Date | Date |
| C | Actions Created | `=COUNTIF(Actions!D:D,A3)` |
| D | Actions Complete | `=COUNTIFS(Actions!D:D,A3,Actions!H:H,"Complete")` |
| E | Completion Rate | `=D3/C3` |
| F | Actions Overdue | `=COUNTIFS(Actions!D:D,A3,Actions!H:H,"<>Complete",Actions!G:G,"<"&TODAY())` |
| G | Avg Days to Complete | `=AVERAGEIFS(Actions!J:J,Actions!D:D,A3,Actions!H:H,"Complete")` |
| H | Open Actions | `=C3-D3-COUNTIFS(Actions!D:D,A3,Actions!H:H,"Cancelled")` |

---

# SHEET 7: OVERDUE ACTIONS

## Overdue Action Management

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | Filter: Status<>Complete AND Due<Today |
| B | Description | From Actions |
| C | Owner | From Actions |
| D | Due Date | From Actions |
| E | **Days Overdue** | `=TODAY()-D3` |
| F | Priority | From Actions |
| G | IBP Pillar | From Actions |
| H | Progress % | From Actions |
| I | Blocker | Reason for delay |
| J | Recovery Plan | Mitigation action |
| K | New Target Date | Revised deadline |
| L | Escalation Status | Escalation level |

### Escalation Logic
```excel
Escalation_Level = IF(Days_Overdue > 14, "Executive",
                   IF(Days_Overdue > 7, "Director",
                   IF(Days_Overdue > 3, "Manager", "Owner")))
```

### Conditional Formatting
- Days Overdue >14: Dark red (#DC2626)
- Days Overdue 8-14: Red (#EF4444)
- Days Overdue 4-7: Orange (#F97316)
- Days Overdue 1-3: Yellow (#FBBF24)

---

# SHEET 8: WEEKLY TREND

## Action Performance Trend

| Col | Header | Formula |
|-----|--------|---------|
| A | Week Ending | Week identifier |
| B | Actions Created | `=COUNTIFS(Actions!E:E,">="&A3-6,Actions!E:E,"<="&A3)` |
| C | Actions Completed | `=COUNTIFS(Actions!I:I,">="&A3-6,Actions!I:I,"<="&A3)` |
| D | Net Change | `=B3-C3` |
| E | Cumulative Open | Running total |
| F | On-Time Completions | `=COUNTIFS(Actions!I:I,">="&A3-6,Actions!I:I,"<="&A3,Actions!I:I,"<="&Actions!G:G)` |
| G | On-Time % | `=F3/C3` |
| H | Overdue Count | Count at week end |
| I | Overdue Rate | `=H3/E3` |
| J | Avg Completion Days | `=AVERAGEIFS(Actions!J:J,Actions!I:I,">="&A3-6,Actions!I:I,"<="&A3)` |

---

# SHEET 9: MONTHLY SUMMARY

## Monthly Performance Report

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | Month identifier |
| B | Opening Balance | Prior month closing |
| C | New Actions | Created in month |
| D | Completed | Completed in month |
| E | Cancelled | Cancelled in month |
| F | Closing Balance | `=B3+C3-D3-E3` |
| G | Completion Rate | `=D3/(B3+C3)` |
| H | On-Time % | On-time completions/Total |
| I | Overdue Carryover | Overdue from prior |
| J | Avg Cycle Time | Days to complete |
| K | High Priority Complete | High priority done |
| L | Escalations | Number escalated |

---

# SHEET 10: ESCALATION LOG

## Escalation Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | Escalated action |
| B | Description | From Actions |
| C | Original Owner | Initial assignee |
| D | Original Due Date | Initial deadline |
| E | Days Overdue at Escalation | `=Escalation_Date - D3` |
| F | Escalation Date | When escalated |
| G | Escalation Level | Manager/Director/Executive |
| H | Escalated To | Person escalated to |
| I | Root Cause | Why delayed |
| J | Resolution | How resolved |
| K | Resolution Date | When resolved |
| L | Days to Resolve | `=K3-F3` |
| M | Lessons Learned | Improvements needed |
| N | Process Change | Recommended changes |

---

# SHEET 11: BLOCKED ACTIONS

## Blocked Action Resolution

| Col | Header | Formula |
|-----|--------|---------|
| A | Action_ID | Blocked actions only |
| B | Description | From Actions |
| C | Owner | From Actions |
| D | Blocked Since | Date blocked |
| E | Days Blocked | `=TODAY()-D3` |
| F | Blocker Type | Resource/Dependency/Decision/External/Other |
| G | Blocker Description | What's blocking |
| H | Dependency | Related item |
| I | Resolution Owner | Who can unblock |
| J | Expected Resolution | Target date |
| K | Workaround | Alternative approach |
| L | Impact of Delay | Business impact |

---

# SHEET 12: ACTION TEMPLATES

## Standard Action Templates

| Col | Header | Description |
|-----|--------|-------------|
| A | Template_ID | Template identifier |
| B | Template Name | Description |
| C | Default Pillar | IBP pillar |
| D | Default Category | Action category |
| E | Default Duration | Days to complete |
| F | Default Priority | Priority level |
| G | Standard Deliverable | Expected output |
| H | Checklist Items | Sub-tasks |

### Example Templates
| Template | Duration | Priority | Deliverable |
|----------|----------|----------|-------------|
| Forecast Review | 5 days | Medium | Updated forecast file |
| Capacity Analysis | 7 days | High | Capacity report |
| Supplier Follow-up | 3 days | Medium | Supplier response |
| Financial Reconciliation | 5 days | High | Variance report |
| Customer Collaboration | 10 days | High | Joint forecast |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| AI_Actions | Actions!A:T | All action items |
| AI_Open_Count | Dashboard!B3 | Open actions count |
| AI_Overdue_Count | Dashboard!B5 | Overdue count |
| AI_Completion_Rate | Dashboard!B6 | 30-day completion rate |
| AI_OnTime_Rate | Dashboard!B7 | On-time completion % |
| AI_Owners | Settings!A:A | Owner list |
| AI_Current_User | Settings!B2 | Current user |

---

# VBA AUTOMATION

```vba
Sub RefreshActionDashboard()
    Application.ScreenUpdating = False

    ' Refresh all calculated sheets
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("By_Owner").Calculate
    ThisWorkbook.Sheets("By_Pillar").Calculate
    ThisWorkbook.Sheets("Overdue_Actions").Calculate

    ' Update last refresh timestamp
    ThisWorkbook.Sheets("Dashboard").Range("L1").Value = Now

    Application.ScreenUpdating = True

    MsgBox "Action Dashboard Refreshed" & vbCrLf & _
           "Open Actions: " & Range("AI_Open_Count").Value & vbCrLf & _
           "Overdue: " & Range("AI_Overdue_Count").Value & vbCrLf & _
           "Completion Rate: " & Format(Range("AI_Completion_Rate").Value, "0%"), _
           vbInformation
End Sub

Sub AlertOverdueActions()
    Dim overdue As Long
    overdue = Range("AI_Overdue_Count").Value

    If overdue > 0 Then
        MsgBox "Alert: " & overdue & " action(s) are overdue!" & vbCrLf & _
               "High Priority Overdue: " & _
               Application.WorksheetFunction.CountIfs( _
                   Range("Actions!H:H"), "<>Complete", _
                   Range("Actions!G:G"), "<" & Date, _
                   Range("Actions!L:L"), "High") & vbCrLf & _
               "Please review the Overdue Actions sheet.", _
               vbExclamation, "Action Tracker Alert"
    End If
End Sub

Sub NewActionEntry()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Actions")

    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row + 1

    ' Auto-generate Action ID
    ws.Cells(nextRow, 1).Value = "ACT-" & Year(Date) & "-" & Format(nextRow - 2, "0000")
    ws.Cells(nextRow, 5).Value = Date ' Created Date
    ws.Cells(nextRow, 8).Value = "Not Started" ' Default Status

    ws.Cells(nextRow, 2).Select
    MsgBox "New action entry created. Please complete the details.", vbInformation
End Sub

Sub SendReminders()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Actions")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim i As Long
    Dim dueList As String

    For i = 3 To lastRow
        If ws.Cells(i, 8).Value <> "Complete" And _
           ws.Cells(i, 8).Value <> "Cancelled" Then
            If ws.Cells(i, 7).Value <= Date + 3 Then
                dueList = dueList & ws.Cells(i, 1).Value & ": " & _
                          ws.Cells(i, 2).Value & " (Due: " & _
                          Format(ws.Cells(i, 7).Value, "MM/DD") & ")" & vbCrLf
            End If
        End If
    Next i

    If dueList <> "" Then
        MsgBox "Actions due within 3 days:" & vbCrLf & vbCrLf & dueList, _
               vbInformation, "Action Reminders"
    Else
        MsgBox "No actions due within 3 days.", vbInformation
    End If
End Sub

Sub ExportOverdueReport()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Overdue_Actions")

    Dim newWb As Workbook
    Set newWb = Workbooks.Add

    ws.UsedRange.Copy newWb.Sheets(1).Range("A1")

    newWb.SaveAs Filename:="Overdue_Actions_" & Format(Date, "YYYYMMDD") & ".xlsx"
    newWb.Close

    MsgBox "Overdue actions report exported successfully.", vbInformation
End Sub

Sub CompleteAction()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Actions")

    If ActiveCell.Row < 3 Then Exit Sub

    ws.Cells(ActiveCell.Row, 8).Value = "Complete"
    ws.Cells(ActiveCell.Row, 9).Value = Date
    ws.Cells(ActiveCell.Row, 17).Value = 100 ' Progress %
    ws.Cells(ActiveCell.Row, 18).Value = Date ' Last Update

    MsgBox "Action marked as complete.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Decision_Log_ENHANCED | Decision-to-action link | Decision_ID reference |
| Risk_Register_ENHANCED | Risk mitigation actions | Risk_ID cross-reference |
| Meeting_Cadence_ENHANCED | Meeting-sourced actions | Meeting reference |
| Gap_Closure_ENHANCED | Gap closure actions | Initiative link |
| Executive_Dashboard_ENHANCED | Action KPIs | Named range AI_* |
| IBP_Master_Integration | Central hub | Power Query |

---

*IBP action item tracking with accountability management, escalation protocols, and completion analytics.*
