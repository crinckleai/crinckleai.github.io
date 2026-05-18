# Decision Log - Enhanced Excel Workbook
## Executive Decision Tracking & Impact Analysis for IBP

---

## Overview
Comprehensive decision tracking workbook for IBP executive reviews with decision lifecycle management, impact assessment, implementation tracking, and outcome analysis. Supports governance, accountability, and continuous improvement.

---

## Design Theme: "Executive Decision"

| Element | Specification |
|---------|---------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Royal Blue (#2563EB) |
| Approved | Green (#10B981) |
| Pending | Amber (#F59E0B) |
| Rejected | Red (#EF4444) |
| Deferred | Gray (#6B7280) |

---

# SHEET 1: DECISION DASHBOARD

## KPI Tiles

| KPI | Formula | Format |
|-----|---------|--------|
| Total Decisions YTD | `=COUNTA(Log!A3:A500)` | Number |
| Decisions This Month | `=COUNTIF(Log!C:C,">="&EOMONTH(TODAY(),-1)+1)` | Number |
| Approval Rate | `=COUNTIF(Log!G:G,"Approved")/COUNTA(Log!G:G)` | Percentage |
| Avg Decision Time (Days) | `=AVERAGE(Log!I:I)` | Days |
| Pending Decisions | `=COUNTIF(Log!G:G,"Pending")` | Number |
| Overdue Decisions | `=COUNTIFS(Log!G:G,"Pending",Log!E:E,"<"&TODAY())` | Number |
| Implementation Rate | `=COUNTIF(Log!L:L,"Complete")/COUNTIF(Log!G:G,"Approved")` | Percentage |
| Positive Outcome Rate | `=COUNTIF(Log!N:N,"Positive")/COUNTIF(Log!N:N,"<>")` | Percentage |

---

# SHEET 2: DECISION LOG

## Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Decision_ID | Auto: `="DEC-"&TEXT(YEAR(C3),"0000")&"-"&TEXT(ROW()-2,"000")` |
| B | Decision Title | Text |
| C | Request Date | Date |
| D | Requested By | Dropdown from Stakeholders |
| E | Target Decision Date | Date |
| F | Actual Decision Date | Date |
| G | **Status** | Dropdown: Pending/Approved/Rejected/Deferred/Escalated |
| H | Decision Maker | Dropdown: CEO/CFO/COO/CSO/IBP Council |
| I | **Days to Decide** | `=IF(F3="",TODAY()-C3,F3-C3)` |
| J | Category | Dropdown: Capacity/Inventory/Pricing/NPI/Supply/Demand/Financial |
| K | IBP Pillar | Dropdown: Product/Demand/Supply/Financial/Executive |
| L | **Implementation Status** | Dropdown: Not Started/In Progress/Complete/N/A |
| M | Implementation Owner | Text |
| N | **Outcome** | Dropdown: Positive/Neutral/Negative/TBD |
| O | Priority | High/Medium/Low |
| P | Financial Impact ($K) | Currency |
| Q | Strategic Alignment | 1-5 scale |
| R | Risk Level | High/Medium/Low |
| S | Review Meeting | Meeting reference |
| T | Notes | Text |

### Conditional Formatting
- Status "Approved": Green (#D1FAE5)
- Status "Pending" & Overdue: Red (#FEE2E2)
- Status "Rejected": Gray (#E5E7EB)
- Days to Decide > 7: Yellow highlight
- Implementation "Complete": Green text

---

# SHEET 3: DECISION DETAIL

## Detailed Decision Record

| Col | Header | Description |
|-----|--------|-------------|
| A | Decision_ID | From Log |
| B | Decision Title | From Log |
| C | Background | Context and history |
| D | Issue Statement | Clear problem definition |
| E | Options Considered | Alternative approaches |
| F | Recommended Option | Preferred choice |
| G | Supporting Data | Evidence and analysis |
| H | Stakeholders Consulted | Who was involved |
| I | Risks Identified | Known risks |
| J | Mitigation Plan | Risk response |
| K | Dependencies | Related decisions/actions |
| L | Success Criteria | How to measure success |
| M | Review Date | When to assess outcome |

---

# SHEET 4: BY CATEGORY

## Decision Analysis by Category

| Col | Header | Formula |
|-----|--------|---------|
| A | Category | Decision category |
| B | Total Decisions | `=COUNTIF(Log!J:J,A3)` |
| C | Approved | `=COUNTIFS(Log!J:J,A3,Log!G:G,"Approved")` |
| D | Rejected | `=COUNTIFS(Log!J:J,A3,Log!G:G,"Rejected")` |
| E | Pending | `=COUNTIFS(Log!J:J,A3,Log!G:G,"Pending")` |
| F | Approval Rate | `=C3/B3` |
| G | Avg Days to Decide | `=AVERAGEIF(Log!J:J,A3,Log!I:I)` |
| H | Total Financial Impact | `=SUMIF(Log!J:J,A3,Log!P:P)` |
| I | Positive Outcomes | `=COUNTIFS(Log!J:J,A3,Log!N:N,"Positive")` |
| J | Success Rate | `=I3/COUNTIFS(Log!J:J,A3,Log!N:N,"<>TBD")` |

---

# SHEET 5: BY DECISION MAKER

## Decision Maker Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Decision Maker | Executive/Council |
| B | Total Decisions | `=COUNTIF(Log!H:H,A3)` |
| C | Approved | `=COUNTIFS(Log!H:H,A3,Log!G:G,"Approved")` |
| D | Avg Days to Decide | `=AVERAGEIF(Log!H:H,A3,Log!I:I)` |
| E | High Priority | `=COUNTIFS(Log!H:H,A3,Log!O:O,"High")` |
| F | Total Impact ($K) | `=SUMIF(Log!H:H,A3,Log!P:P)` |
| G | Overdue Rate | `=COUNTIFS(Log!H:H,A3,Log!G:G,"Pending",Log!E:E,"<"&TODAY())/B3` |
| H | Implementation Rate | `=COUNTIFS(Log!H:H,A3,Log!L:L,"Complete")/COUNTIFS(Log!H:H,A3,Log!G:G,"Approved")` |

---

# SHEET 6: MONTHLY TREND

## Decision Volume and Performance Trend

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | Month identifier |
| B | New Decisions | `=COUNTIFS(Log!C:C,">="&A3,Log!C:C,"<"&EDATE(A3,1))` |
| C | Decisions Made | `=COUNTIFS(Log!F:F,">="&A3,Log!F:F,"<"&EDATE(A3,1))` |
| D | Approved | `=COUNTIFS(Log!F:F,">="&A3,Log!F:F,"<"&EDATE(A3,1),Log!G:G,"Approved")` |
| E | Rejected | `=COUNTIFS(Log!F:F,">="&A3,Log!F:F,"<"&EDATE(A3,1),Log!G:G,"Rejected")` |
| F | Approval Rate | `=D3/C3` |
| G | Avg Days to Decide | `=AVERAGEIFS(Log!I:I,Log!F:F,">="&A3,Log!F:F,"<"&EDATE(A3,1))` |
| H | Pending Carryover | `=COUNTIFS(Log!G:G,"Pending",Log!C:C,"<"&EDATE(A3,1))` |
| I | Implementation Complete | `=COUNTIFS(Log!F:F,">="&A3,Log!F:F,"<"&EDATE(A3,1),Log!L:L,"Complete")` |

---

# SHEET 7: IMPACT ANALYSIS

## Financial and Strategic Impact

| Col | Header | Formula |
|-----|--------|---------|
| A | Decision_ID | From Log |
| B | Decision Title | From Log |
| C | Category | From Log |
| D | Decision Date | From Log |
| E | Projected Impact ($K) | Expected financial impact |
| F | Actual Impact ($K) | Realized financial impact |
| G | Impact Variance ($K) | `=F3-E3` |
| H | Variance % | `=G3/E3` |
| I | Revenue Impact | Revenue effect |
| J | Cost Impact | Cost effect |
| K | Working Capital Impact | WC effect |
| L | Strategic Score | 1-5 strategic alignment |
| M | Risk Reduction | Qualitative assessment |
| N | Customer Impact | Positive/Neutral/Negative |
| O | Overall Assessment | Success/Partial/Failure |

---

# SHEET 8: ESCALATION TRACKING

## Escalated Decision Management

| Col | Header | Formula |
|-----|--------|---------|
| A | Decision_ID | Escalated decisions |
| B | Original Request Date | Date |
| C | Escalation Date | When escalated |
| D | Days Before Escalation | `=C3-B3` |
| E | Escalation Reason | Why escalated |
| F | Escalated From | Original decision maker |
| G | Escalated To | New decision maker |
| H | Resolution Date | When resolved |
| I | Days to Resolve | `=H3-C3` |
| J | Final Decision | Approved/Rejected/Other |
| K | Lessons Learned | Text |

### Escalation Metrics
```excel
Total Escalations: =COUNTA(A:A)-1
Avg Days Before Escalation: =AVERAGE(D:D)
Avg Days to Resolve: =AVERAGE(I:I)
Escalation Rate: =Escalations/Total_Decisions
```

---

# SHEET 9: DECISION MATRIX

## Decision Authority Matrix

| Col | Header | Description |
|-----|--------|-------------|
| A | Decision Type | Category of decision |
| B | Financial Threshold ($K) | Value threshold |
| C | Decision Authority | Who decides |
| D | Consultation Required | Who to consult |
| E | Information Required | Documentation needed |
| F | Turnaround Target (Days) | Expected decision time |
| G | Escalation Path | Next level |
| H | Governance Policy | Reference |

### Example Matrix Rows
| Decision Type | <$100K | $100K-$500K | $500K-$1M | >$1M |
|--------------|--------|-------------|-----------|------|
| Capacity Investment | Supply VP | COO | IBP Council | CEO |
| Pricing Change | Sales VP | CSO | IBP Council | CEO |
| Inventory Build | Supply VP | CFO | IBP Council | CEO |
| New Product Launch | Product VP | CMO | IBP Council | CEO |
| Supplier Change | Procurement | COO | IBP Council | CEO |

---

# SHEET 10: OUTCOME REVIEW

## Decision Outcome Assessment

| Col | Header | Formula |
|-----|--------|---------|
| A | Decision_ID | From Log |
| B | Decision Title | Lookup |
| C | Decision Date | Lookup |
| D | Implementation Date | When implemented |
| E | Review Date | Assessment date |
| F | Expected Outcome | Planned result |
| G | Actual Outcome | Realized result |
| H | Variance | Qualitative assessment |
| I | Root Cause | Why variance occurred |
| J | Lessons Learned | Key learnings |
| K | Process Improvement | Suggested changes |
| L | Outcome Score | 1-5 scale |
| M | Follow-up Required | Yes/No |
| N | Follow-up Action | Description |

---

# SHEET 11: PENDING DECISIONS

## Active Decision Queue

| Col | Header | Formula |
|-----|--------|---------|
| A | Decision_ID | `=IF(Log!G3="Pending",Log!A3,"")` |
| B | Decision Title | Lookup pending only |
| C | Request Date | From Log |
| D | Target Date | From Log |
| E | Days Outstanding | `=TODAY()-C3` |
| F | Days to Target | `=D3-TODAY()` |
| G | Status | `=IF(F3<0,"Overdue",IF(F3<3,"Urgent","On Track"))` |
| H | Category | From Log |
| I | Priority | From Log |
| J | Decision Maker | From Log |
| K | Financial Impact | From Log |
| L | Blocker | What's preventing decision |
| M | Next Step | Required action |

### Conditional Formatting
- Overdue: Red background
- Urgent (≤3 days): Yellow background
- On Track: Green background

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| DL_Log | Log!A:T | All decisions |
| DL_Total_Decisions | Dashboard!B3 | Total decision count |
| DL_Approval_Rate | Dashboard!B5 | Approval percentage |
| DL_Avg_Decision_Time | Dashboard!B6 | Average days to decide |
| DL_Pending_Count | Dashboard!B7 | Pending decisions |
| DL_Implementation_Rate | Dashboard!B9 | Implementation completion |

---

# VBA AUTOMATION

```vba
Sub RefreshDecisionDashboard()
    Application.ScreenUpdating = False

    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("By_Category").Calculate
    ThisWorkbook.Sheets("Monthly_Trend").Calculate

    Application.ScreenUpdating = True

    MsgBox "Decision Log Dashboard Updated" & vbCrLf & _
           "Total Decisions: " & Range("DL_Total_Decisions").Value & vbCrLf & _
           "Pending: " & Range("DL_Pending_Count").Value & vbCrLf & _
           "Approval Rate: " & Format(Range("DL_Approval_Rate").Value, "0%"), _
           vbInformation
End Sub

Sub AlertOverdueDecisions()
    Dim overdue As Long
    overdue = Application.WorksheetFunction.CountIfs( _
        Range("Log!G:G"), "Pending", _
        Range("Log!E:E"), "<" & Date)

    If overdue > 0 Then
        MsgBox "Alert: " & overdue & " decision(s) are overdue!" & vbCrLf & _
               "Please review the Pending Decisions sheet.", _
               vbExclamation, "Decision Log Alert"
    End If
End Sub

Sub NewDecisionEntry()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Log")

    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row + 1

    ' Auto-generate Decision ID
    ws.Cells(nextRow, 1).Value = "DEC-" & Year(Date) & "-" & Format(nextRow - 2, "000")
    ws.Cells(nextRow, 3).Value = Date ' Request Date

    ws.Cells(nextRow, 2).Select
    MsgBox "New decision entry created. Please complete the details.", vbInformation
End Sub

Sub ExportPendingDecisions()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Pending_Decisions")

    Dim newWb As Workbook
    Set newWb = Workbooks.Add

    ws.UsedRange.Copy newWb.Sheets(1).Range("A1")

    newWb.SaveAs Filename:="Pending_Decisions_" & Format(Date, "YYYYMMDD") & ".xlsx"
    newWb.Close

    MsgBox "Pending decisions exported successfully.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Action_Item_Tracker_ENHANCED | Decision-to-action link | Decision_ID reference |
| Risk_Register_ENHANCED | Risk-based decisions | Risk_ID cross-reference |
| Strategic_Initiatives_ENHANCED | Initiative decisions | Initiative_ID link |
| Executive_Dashboard_ENHANCED | Decision KPIs | Named range DL_* |
| Gap_Closure_ENHANCED | Gap closure decisions | Decision tracking |
| IBP_Master_Integration | Central hub | Power Query |

---

*Executive decision tracking with lifecycle management, impact analysis, and outcome assessment.*
