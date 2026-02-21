# Supplier Capacity Tracker - Enhanced Excel Workbook
## Strategic Supplier Management with Capacity Analysis & Risk Assessment

---

## Overview
Enterprise supplier capacity management workbook for tracking supplier performance, capacity availability, lead times, risk assessment, and collaboration status across the supply base. Designed for multi-tier supplier visibility with integrated scorecard and early warning systems.

---

## Design Theme: "Supply Network"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Teal (#0D9488) |
| Accent | Slate (#475569) |
| Capacity OK | Emerald (#059669) |
| Capacity Tight | Amber (#F59E0B) |
| Capacity Gap | Red (#EF4444) |
| Single Source Risk | Purple (#7C3AED) |
| Font - Headers | Segoe UI Semibold, 11pt |

---

# SHEET 1: SETTINGS & CONFIGURATION

## Supplier Tier Definitions

| Tier | Criteria | Review Frequency | Collaboration Level |
|------|----------|------------------|-------------------|
| Strategic | >$5M annual, critical materials | Weekly | Joint capacity planning |
| Preferred | $1M-$5M annual, key materials | Bi-weekly | Forecast sharing |
| Approved | <$1M annual, standard materials | Monthly | Order-based |
| Conditional | New or underperforming | Weekly | Close monitoring |

## Scoring Criteria Weights

| Dimension | Weight | Components |
|-----------|--------|------------|
| Quality | 30% | Defect rate, certifications, audit scores |
| Delivery | 30% | OTIF, lead time variance, responsiveness |
| Cost | 20% | Price competitiveness, cost reduction |
| Responsiveness | 20% | Communication, flexibility, innovation |

## Risk Thresholds

| Risk Level | Utilization | Lead Time Variance | Single Source |
|------------|-------------|-------------------|---------------|
| Low | <70% | <10% | No |
| Medium | 70-85% | 10-20% | Yes (qualified backup) |
| High | 85-95% | 20-30% | Yes (no backup) |
| Critical | >95% | >30% | Yes (no backup, critical item) |

---

# SHEET 2: SUPPLIER DASHBOARD

## KPI Tiles (Row 3-10)

| KPI | Formula | Conditional Format |
|-----|---------|-------------------|
| Total Active Suppliers | `=COUNTIF(Supplier_Master!Status_Col,"Active")` | — |
| Strategic Partners | `=COUNTIF(Supplier_Master!Tier_Col,"Strategic")` | — |
| Avg Capacity Utilization | `=AVERAGE(Capacity_Status!Utilization_Col)` | <80% GREEN, 80-90% YELLOW, >90% RED |
| Suppliers at Risk | `=COUNTIF(Capacity_Status!Risk_Col,"High")+COUNTIF(Capacity_Status!Risk_Col,"Critical")` | >0 = RED |
| Total Capacity Gap ($K) | `=SUMIF(Capacity_Status!Gap_Col,"<0",Capacity_Status!Gap_Value_Col)*-1` | — |
| Single Source Items | `=COUNTIF(Material_Category!Single_Source_Col,"Yes")` | >10% of items = WARNING |
| Avg Supplier Score | `=AVERAGE(Scorecard!Overall_Score_Col)` | ≥80 GREEN, 60-80 YELLOW, <60 RED |
| On-Time Delivery % | `=AVERAGE(Performance!OTIF_Col)` | ≥95% GREEN |

## Tier Distribution Summary

| Tier | Count | Annual Spend ($M) | % of Spend | Avg Score |
|------|-------|------------------|------------|-----------|
| Strategic | Formula | Formula | Formula | Formula |
| Preferred | Formula | Formula | Formula | Formula |
| Approved | Formula | Formula | Formula | Formula |
| Conditional | Formula | Formula | Formula | Formula |

---

# SHEET 3: SUPPLIER MASTER DATA

## Column Layout

| Col | Header | Width | Validation/Formula |
|-----|--------|-------|-------------------|
| A | Supplier_ID | 10 | Auto: `="SUP-"&TEXT(ROW()-2,"000")` |
| B | Supplier Name | 30 | Text |
| C | **Tier** | 12 | Dropdown: Strategic/Preferred/Approved/Conditional |
| D | Category | 20 | Dropdown: Raw Materials/Components/Packaging/Services |
| E | Primary Contact | 20 | Text |
| F | Contact Email | 25 | Email validation |
| G | Contact Phone | 15 | Text |
| H | Location (Country) | 15 | Dropdown |
| I | Lead Time (Days) | 10 | Number ≥1 |
| J | Payment Terms | 12 | Dropdown: Net 30/Net 45/Net 60 |
| K | Annual Spend ($K) | 15 | Number |
| L | % of Category Spend | 12 | `=K3/SUMIF($D$3:$D$500,$D3,$K$3:$K$500)` |
| M | Contract End Date | 12 | Date |
| N | Days to Expiry | 10 | `=M3-TODAY()` |
| O | Contract Status | 12 | `=IF(N3<0,"EXPIRED",IF(N3<60,"EXPIRING","ACTIVE"))` |
| P | **Single Source?** | 10 | `=IF(COUNTIF(Material_Cat!Supplier_Col,A3)=COUNTIF(Material_Cat!Material_Col,VLOOKUP(A3,Material_Cat!A:B,2,FALSE)),"Yes","No")` |
| Q | Backup Qualified? | 10 | Dropdown: Yes/No/In Progress |
| R | Certifications | 20 | Multi-select or text |
| S | Last Audit Date | 12 | Date |
| T | Audit Score | 8 | Number 0-100 |
| U | Status | 10 | Dropdown: Active/On Hold/Inactive |
| V | Notes | 40 | Text |

### Conditional Formatting
- Contract Status "EXPIRED": Red background
- Contract Status "EXPIRING": Yellow background
- Single Source = "Yes" AND Backup = "No": Purple highlight
- Tier = "Conditional": Orange row highlight

---

# SHEET 4: CAPACITY STATUS

## Monthly Capacity Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | From Master |
| B | Supplier Name | `=VLOOKUP(A3,Supplier_Master!A:B,2,FALSE)` |
| C | Tier | `=VLOOKUP(A3,Supplier_Master!A:C,3,FALSE)` |
| D | Material/Category | Primary material supplied |
| E | Our Demand (Units) | From demand plan |
| F | Supplier Capacity (Units) | Supplier-provided |
| G | Other Customer Demand | Estimated |
| H | Total Demand on Supplier | `=E3+G3` |
| I | **Utilization %** | `=H3/F3` |
| J | **Available for Us** | `=MAX(0,F3-G3)` |
| K | **Gap/Surplus (Units)** | `=J3-E3` |
| L | Gap/Surplus ($K) | `=K3*Unit_Cost/1000` |
| M | **Risk Level** | See formula below |
| N | Mitigation Required? | `=IF(OR(M3="High",M3="Critical"),"Yes","No")` |
| O | Mitigation Plan | Text |
| P | Alternative Supplier | Dropdown from Master |
| Q | Alternative Capacity | Number |
| R | Combined Coverage | `=J3+Q3` |
| S | Remaining Gap | `=E3-R3` |

### Risk Level Formula (Column M)
```excel
=IF(I3>0.95,"Critical",
  IF(I3>0.85,"High",
    IF(I3>0.7,"Medium","Low")))
```

### Conditional Formatting
- Utilization >95%: Red background (#FEE2E2)
- Utilization 85-95%: Yellow background (#FEF3C7)
- Utilization 70-85%: Light green (#D1FAE5)
- Utilization <70%: White
- Gap negative (shortage): Red text, bold
- Gap positive (surplus): Green text

---

# SHEET 5: MATERIAL CATEGORY VIEW

## Aggregated by Material Category

| Col | Header | Formula |
|-----|--------|---------|
| A | Material Category | Unique list |
| B | Active Suppliers | `=COUNTIFS(Supplier_Master!D:D,A3,Supplier_Master!U:U,"Active")` |
| C | Strategic Suppliers | `=COUNTIFS(Supplier_Master!D:D,A3,Supplier_Master!C:C,"Strategic")` |
| D | Total Our Demand | `=SUMIF(Capacity!D:D,A3,Capacity!E:E)` |
| E | Total Capacity | `=SUMIF(Capacity!D:D,A3,Capacity!F:F)` |
| F | Category Utilization | `=D3/E3` |
| G | Gap/Surplus | `=E3-D3` |
| H | Single Source Items | `=COUNTIFS(Single_Source_Analysis!Category,A3,Single_Source_Analysis!Single,"Yes")` |
| I | Single Source % | `=H3/COUNTIF(Single_Source_Analysis!Category,A3)` |
| J | Category Risk | `=IF(OR(F3>0.9,I3>0.3),"High",IF(OR(F3>0.8,I3>0.2),"Medium","Low"))` |
| K | Backup Coverage | % of single-source items with qualified backup |
| L | Action Required | Text |

---

# SHEET 6: GAP ANALYSIS

## Detailed Capacity Gap Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | Filtered: Gap < 0 only |
| B | Supplier Name | Lookup |
| C | Material | Material with gap |
| D | Our Demand | From Capacity sheet |
| E | Available Capacity | From Capacity sheet |
| F | **Gap (Units)** | `=E3-D3` (negative = shortage) |
| G | **Gap ($K)** | `=F3*Unit_Cost/1000` |
| H | Impact Start Date | When gap impacts production |
| I | Duration (Months) | How long gap persists |
| J | Total Impact ($K) | `=G3*I3` |
| K | Alternative Source | Dropdown |
| L | Alt Source Capacity | Number |
| M | Alt Source Lead Time | Days |
| N | Cost Premium % | % over primary |
| O | Premium Cost ($K) | `=D3*Unit_Cost*N3/1000` |
| P | **Mitigation Strategy** | Dropdown |
| Q | Strategy Details | Text |
| R | Owner | Dropdown |
| S | Due Date | Date |
| T | Status | Dropdown: Not Started/In Progress/Resolved |

### Mitigation Strategy Options
- Qualify alternative supplier
- Negotiate capacity increase
- Place buffer inventory
- Demand reduction (work with sales)
- Product substitution
- Expedite (premium freight)
- Accept risk

---

# SHEET 7: FORECAST SHARING STATUS

## Track Forecast Communication with Suppliers

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | From Master |
| B | Supplier Name | Lookup |
| C | Tier | Lookup |
| D | Collaboration Level | JBP/Forecast Share/None |
| E | Forecast Sharing Required? | `=IF(C3="Strategic","Yes",IF(C3="Preferred","Yes","Recommended"))` |
| F | Last Forecast Shared | Date |
| G | Days Since Shared | `=IF(F3="","Never",TODAY()-F3)` |
| H | Sharing Frequency Target | `=IF(C3="Strategic",7,IF(C3="Preferred",14,30))` |
| I | **Compliance Status** | `=IF(G3="Never","⚠ NEVER SHARED",IF(G3>H3*1.5,"❌ OVERDUE",IF(G3>H3,"⚡ DUE","✓ CURRENT")))` |
| J | Forecast Horizon Shared | Months shared |
| K | Supplier Acknowledgment | Yes/No |
| L | Capacity Confirmation | Yes/No/Pending |
| M | Issues Identified | Text |
| N | Resolution Status | Text |
| O | Next Share Date | `=F3+H3` |

### Conditional Formatting
- Never Shared: Red background
- Overdue: Orange background
- Due: Yellow background
- Current: Green background

---

# SHEET 8: LEAD TIME ANALYSIS

## Lead Time Tracking and Variance

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | From Master |
| B | Supplier Name | Lookup |
| C | Quoted Lead Time | From contract/quote |
| D | Avg Actual Lead Time | `=AVERAGEIF(PO_History!Supplier,A3,PO_History!Actual_LT)` |
| E | Lead Time Variance | `=D3-C3` |
| F | Variance % | `=E3/C3` |
| G | LT Trend (3M) | `=IF(Recent_Avg>Prior_Avg,"Increasing",IF(Recent_Avg<Prior_Avg,"Decreasing","Stable"))` |
| H | Min LT (Last 12M) | `=MINIFS(PO_History!Actual_LT,PO_History!Supplier,A3,PO_History!Date,">="&EDATE(TODAY(),-12))` |
| I | Max LT (Last 12M) | `=MAXIFS(...)` |
| J | LT Std Dev | `=STDEVIFS(PO_History!Actual_LT,PO_History!Supplier,A3)` |
| K | LT Reliability Score | `=1-J3/D3` (lower CV = more reliable) |
| L | **Performance Rating** | `=IF(F3<=0,"Excellent",IF(F3<=0.1,"Good",IF(F3<=0.2,"Fair","Poor")))` |
| M | Safety Stock Impact | Days of additional SS needed |
| N | Notes | Text |

---

# SHEET 9: RISK ASSESSMENT

## Multi-Dimensional Risk Scoring

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | From Master |
| B | Supplier Name | Lookup |
| C | Tier | Lookup |
| D | **Capacity Risk** (1-5) | `=IF(Utilization>0.95,5,IF(Utilization>0.85,4,IF(Utilization>0.7,3,IF(Utilization>0.5,2,1))))` |
| E | **Delivery Risk** (1-5) | `=IF(OTIF<0.8,5,IF(OTIF<0.85,4,IF(OTIF<0.9,3,IF(OTIF<0.95,2,1))))` |
| F | **Quality Risk** (1-5) | `=IF(Defect_Rate>0.05,5,IF(Defect_Rate>0.02,4,IF(Defect_Rate>0.01,3,IF(Defect_Rate>0.005,2,1))))` |
| G | **Financial Risk** (1-5) | Based on financial health assessment |
| H | **Geographic Risk** (1-5) | Based on location risk factors |
| I | **Single Source Risk** (1-5) | `=IF(AND(Single_Source="Yes",Backup="No"),5,IF(Single_Source="Yes",3,1))` |
| J | **Overall Risk Score** | `=(D3*0.2+E3*0.2+F3*0.2+G3*0.15+H3*0.1+I3*0.15)` |
| K | Risk Level | `=IF(J3>=4,"Critical",IF(J3>=3,"High",IF(J3>=2,"Medium","Low")))` |
| L | Risk Trend | Improving/Stable/Worsening |
| M | Mitigation Required | `=IF(OR(K3="Critical",K3="High"),"Yes","No")` |
| N | Mitigation Plan | Text |
| O | Owner | Dropdown |
| P | Review Date | Date |

---

# SHEET 10: ALTERNATIVE SUPPLIER STATUS

## Backup Qualification Pipeline

| Col | Header | Formula |
|-----|--------|---------|
| A | Primary Supplier | Current supplier |
| B | Material/Item | What they supply |
| C | Single Source? | Yes/No |
| D | Risk Level | From Risk Assessment |
| E | Alternative Supplier | Potential backup |
| F | Qualification Status | Not Started/In Progress/Qualified/Rejected |
| G | Qualification Start | Date |
| H | Target Completion | Date |
| I | Days to Target | `=H3-TODAY()` |
| J | **Progress %** | Manual or calculated |
| K | Current Step | Text |
| L | Blocker | Text |
| M | Est. Qualification Cost | Number |
| N | Lead Time Comparison | `=Alt_LT - Primary_LT` |
| O | Cost Comparison % | `=(Alt_Cost-Primary_Cost)/Primary_Cost` |
| P | Capacity Available | Units |
| Q | Qualification Owner | Dropdown |
| R | Notes | Text |

### Status Conditional Formatting
- Qualified: Green background
- In Progress: Yellow background
- Not Started with Critical risk: Red background
- Rejected: Gray strikethrough

---

# SHEET 11: CAPACITY RESERVATIONS

## Capacity Commitments and Agreements

| Col | Header | Formula |
|-----|--------|---------|
| A | Agreement_ID | Auto-generated |
| B | Supplier_ID | Dropdown |
| C | Supplier Name | Lookup |
| D | Material/Category | Text |
| E | Reserved Capacity | Units per period |
| F | Period | Monthly/Quarterly/Annual |
| G | Agreement Start | Date |
| H | Agreement End | Date |
| I | Days to Expiration | `=H3-TODAY()` |
| J | **Expiration Status** | `=IF(I3<0,"EXPIRED",IF(I3<60,"EXPIRING",IF(I3<90,"REVIEW SOON","ACTIVE")))` |
| K | Penalty for Under-Use | % or $ |
| L | Actual Usage (LTM) | Units |
| M | Usage % | `=L3/(E3*12)` or appropriate calculation |
| N | Value at Risk | Penalty exposure if under-used |
| O | Renewal Recommended? | Yes/No/Reduce/Expand |
| P | Renewal Notes | Text |

---

# SHEET 12: SUPPLIER SCORECARD

## Performance Scoring (4 Dimensions)

| Col | Header | Formula |
|-----|--------|---------|
| A | Supplier_ID | From Master |
| B | Supplier Name | Lookup |
| C | Tier | Lookup |
| D | **Quality Score** (0-100) | Weighted quality metrics |
| E | Quality Weight | 30% |
| F | **Delivery Score** (0-100) | OTIF-based |
| G | Delivery Weight | 30% |
| H | **Cost Score** (0-100) | Price competitiveness |
| I | Cost Weight | 20% |
| J | **Responsiveness Score** (0-100) | Communication, flexibility |
| K | Responsiveness Weight | 20% |
| L | **Overall Score** | `=D3*E3+F3*G3+H3*I3+J3*K3` |
| M | Score vs Target | `=L3-Settings!Score_Target` |
| N | Performance Level | `=IF(L3>=85,"Excellent",IF(L3>=70,"Good",IF(L3>=55,"Acceptable","Needs Improvement")))` |
| O | Trend (QoQ) | `=Current_Score-Prior_Quarter_Score` |
| P | Trend Direction | `=IF(O3>2,"↑ Improving",IF(O3<-2,"↓ Declining","→ Stable"))` |
| Q | Recognition/Action | Text |

### Score Component Formulas

**Quality Score:**
```excel
=100 - (Defect_Rate*1000) - IF(Audit_Score<80,(80-Audit_Score)*0.5,0) - IF(Certifications_Missing,10,0)
```

**Delivery Score:**
```excel
=OTIF_Pct*100*0.6 + (100-Lead_Time_Variance_Pct*100)*0.4
```

**Cost Score:**
```excel
=100 - MAX(0,(Price_vs_Target-1)*100) + Cost_Reduction_Achieved*50
```

---

# SHEET 13: COLLABORATION CALENDAR

## Supplier Meeting and Review Schedule

| Col | Header | Validation |
|-----|--------|------------|
| A | Meeting Date | Date |
| B | Supplier_ID | Dropdown |
| C | Supplier Name | Lookup |
| D | Meeting Type | Dropdown: QBR/Capacity Review/Issue Resolution/Strategy |
| E | Attendees (Our Side) | Text |
| F | Attendees (Supplier) | Text |
| G | Agenda Items | Text |
| H | Status | Scheduled/Completed/Cancelled |
| I | Key Outcomes | Text |
| J | Action Items | Text |
| K | Next Meeting Date | Date |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| Supplier_Master | Supplier_Master!A:V | Full supplier data |
| Supplier_Capacity | Capacity_Status!A:S | Capacity tracking |
| Supplier_Risk | Risk_Assessment!A:P | Risk scores |
| Supplier_Scorecard | Scorecard!A:Q | Performance scores |
| Capacity_Gap_Total | Dashboard!B7 | Total gap value |
| Suppliers_At_Risk | Dashboard!B6 | At-risk count |
| Avg_Utilization | Dashboard!B5 | Average utilization |
| Single_Source_Count | Dashboard!B8 | Single source items |

---

# VBA AUTOMATION

```vba
Sub RefreshSupplierDashboard()
    Application.ScreenUpdating = False

    ' Recalculate all sheets
    ThisWorkbook.Sheets("Capacity_Status").Calculate
    ThisWorkbook.Sheets("Risk_Assessment").Calculate
    ThisWorkbook.Sheets("Scorecard").Calculate
    ThisWorkbook.Sheets("Dashboard").Calculate

    Application.ScreenUpdating = True
    MsgBox "Supplier Dashboard refreshed.", vbInformation
End Sub

Sub AlertHighRiskSuppliers()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Risk_Assessment")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim alertMsg As String
    Dim count As Long: count = 0

    For i = 3 To lastRow
        If ws.Cells(i, 11).Value = "Critical" Or ws.Cells(i, 11).Value = "High" Then
            alertMsg = alertMsg & ws.Cells(i, 2).Value & " - " & _
                       ws.Cells(i, 11).Value & " Risk (Score: " & _
                       Format(ws.Cells(i, 10).Value, "0.0") & ")" & vbCrLf
            count = count + 1
        End If
    Next i

    If count > 0 Then
        MsgBox "⚠ " & count & " suppliers require attention:" & vbCrLf & vbCrLf & _
               alertMsg, vbExclamation, "Supplier Risk Alert"
    Else
        MsgBox "No high-risk suppliers identified.", vbInformation
    End If
End Sub

Sub GenerateCapacityReport()
    ' Export capacity status to new worksheet for reporting
    Dim wsSource As Worksheet, wsReport As Worksheet
    Set wsSource = ThisWorkbook.Sheets("Capacity_Status")

    ' Create new report sheet
    Set wsReport = ThisWorkbook.Sheets.Add
    wsReport.Name = "Capacity_Report_" & Format(Date, "YYYYMMDD")

    ' Copy headers and data
    wsSource.Range("A2:S2").Copy wsReport.Range("A1")
    wsSource.Range("A3:S" & wsSource.Cells(Rows.Count, "A").End(xlUp).Row).Copy wsReport.Range("A2")

    ' Format
    wsReport.Columns.AutoFit

    MsgBox "Capacity report generated in new sheet.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Capacity_Planning_ENHANCED | Supplier capacity input | Named range Supplier_Capacity |
| Supply_Constraints_ENHANCED | Constraint identification | Named range Capacity_Gap_Total |
| Scenario_Planning_ENHANCED | Supply scenarios | Named range integration |
| Risk_Register_ENHANCED | Supplier risks | Named range Supplier_Risk |
| Executive_Dashboard_ENHANCED | Supply KPIs | Named range Avg_Utilization |
| IBP_Master_Integration | Central hub | Power Query connection |

---

*Strategic supplier management with capacity tracking, risk assessment, and performance scorecards.*
