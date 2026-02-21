# Demand Assumptions Log - Enhanced Excel Workbook

## Overview
Centralized demand assumption management workbook for tracking, validating, and auditing all assumptions that underpin the IBP demand plan. Includes auto-expiry alerts, risk-weighted impact analysis, and executive escalation workflows.

---

## Design Theme: "Indigo Precision"

| Element | Specification |
|---------|--------------|
| Primary Color | Indigo (#4F46E5) |
| Secondary Color | Steel (#64748B) |
| Accent | Teal (#0D9488) |
| Valid | Emerald (#059669) |
| Expiring Soon | Amber (#F59E0B) |
| Expired | Red (#EF4444) |
| Font - Headers | Segoe UI Semibold, 11pt |
| Font - Body | Segoe UI, 10pt |
| Row Banding | White / Light Indigo (#EEF2FF) |

---

## Sheet 1: Settings & Configuration

### Assumption Categories
| Category Code | Category | Default Review Cycle |
|--------------|----------|---------------------|
| ECON | Economic & Macro | Quarterly |
| MKT | Market & Competitive | Monthly |
| CUST | Customer-Specific | Monthly |
| PROD | Product & Portfolio | Quarterly |
| PRC | Pricing | Monthly |
| PROMO | Promotional | Per event |
| CHAN | Channel & Distribution | Quarterly |
| REG | Regulatory & External | Quarterly |

### Impact Levels
| Level | Revenue Impact Range | Score |
|-------|---------------------|-------|
| Critical | >$5M | 5 |
| High | $1M-$5M | 4 |
| Medium | $500K-$1M | 3 |
| Low | $100K-$500K | 2 |
| Minimal | <$100K | 1 |

### Confidence Definitions
| Level | Definition | Probability Factor |
|-------|-----------|-------------------|
| High | Strong evidence, data-backed | 0.90 |
| Medium | Reasonable basis, some uncertainty | 0.60 |
| Low | Limited evidence, significant uncertainty | 0.30 |

---

## Sheet 2: Assumptions Dashboard

### KPI Tiles (Row 3-8)

| KPI | Formula | Conditional Formatting |
|-----|---------|----------------------|
| Total Active Assumptions | `=COUNTIF(Master_Log!G3:G5000,"Valid")+COUNTIF(Master_Log!G3:G5000,"Expiring Soon")` | — |
| Valid Assumptions | `=COUNTIF(Master_Log!G3:G5000,"Valid")` | GREEN |
| Expiring Soon (30 days) | `=COUNTIF(Master_Log!G3:G5000,"Expiring Soon")` | AMBER |
| Expired (Needs Review) | `=COUNTIF(Master_Log!G3:G5000,"EXPIRED")` | RED if >0 |
| Health Rate | `=COUNTIF(Master_Log!G3:G5000,"Valid")/COUNTA(Master_Log!G3:G5000)` | ≥90% GREEN, 75-90% YELLOW, <75% RED |
| High-Impact Expired | `=COUNTIFS(Master_Log!G3:G5000,"EXPIRED",Master_Log!E3:E5000,"Critical")+COUNTIFS(Master_Log!G3:G5000,"EXPIRED",Master_Log!E3:E5000,"High")` | RED if >0 |

### Category Summary (Row 11+)

| Col | Header | Formula |
|-----|--------|---------|
| A | Category | Category name |
| B | Total | `=COUNTIF(Master_Log!B:B,A11)` |
| C | Valid | `=COUNTIFS(Master_Log!B:B,A11,Master_Log!G:G,"Valid")` |
| D | Expiring | `=COUNTIFS(Master_Log!B:B,A11,Master_Log!G:G,"Expiring Soon")` |
| E | Expired | `=COUNTIFS(Master_Log!B:B,A11,Master_Log!G:G,"EXPIRED")` |
| F | Health % | `=C11/B11` |
| G | Avg Impact Score | `=AVERAGEIF(Master_Log!B:B,A11,Master_Log!E_Score:E_Score)` |

---

## Sheet 3: Master Assumptions Log

### Column Layout

| Col | Header | Width | Type | Formula/Validation |
|-----|--------|-------|------|-------------------|
| A | Assumption ID | 12 | Text | Auto: `="ASM-"&TEXT(ROW()-2,"0000")` |
| B | Category | 15 | Dropdown | From Settings category list |
| C | Assumption Statement | 50 | Text | Required |
| D | Value / Metric | 20 | Text | Quantified where possible |
| E | Impact Level | 12 | Dropdown | Critical/High/Medium/Low/Minimal |
| F | Confidence | 10 | Dropdown | High/Medium/Low |
| G | Status | 15 | **Formula** | `=IF(H3="","",IF(H3<TODAY(),"EXPIRED",IF(H3<TODAY()+30,"Expiring Soon","Valid")))` |
| H | Valid Through | 12 | Date | Required |
| I | Source | 20 | Text | Data source or person |
| J | Owner | 15 | Text | Assumption owner |
| K | Impact Value ($K) | 15 | Number | Estimated revenue impact |
| L | Risk-Weighted Impact ($K) | 15 | **Formula** | `=K3*VLOOKUP(F3,Settings!ConfidenceTable,2,FALSE)` |
| M | Created Date | 12 | Date | Initial entry date |
| N | Last Reviewed | 12 | Date | Last review date |
| O | Days Since Review | 10 | **Formula** | `=IF(N3="","Never",TODAY()-N3)` |
| P | Review Overdue? | 10 | **Formula** | `=IF(O3="Never","Yes",IF(O3>VLOOKUP(B3,Settings!ReviewCycle,2,FALSE),"Yes","No"))` |
| Q | Notes | 30 | Text | Additional context |

### Conditional Formatting Rules

| Rule | Range | Format |
|------|-------|--------|
| Status = "EXPIRED" | G:G | Background #FEE2E2, Bold Red text |
| Status = "Expiring Soon" | G:G | Background #FEF3C7, Orange text |
| Status = "Valid" | G:G | Background #D1FAE5, Green text |
| Impact = Critical | E:E | Bold, Red background |
| Review Overdue = "Yes" | P:P | Red text, Yellow background |
| Days Since Review > 60 | O:O | Red text |

---

## Sheet 4: Economic Assumptions

### Pre-populated assumptions for economic factors

| ID | Assumption | Default Value | Source | Review |
|----|-----------|--------------|--------|--------|
| ECON-001 | GDP Growth Rate | [%] | World Bank/IMF | Quarterly |
| ECON-002 | Inflation Rate | [%] | Central Bank | Monthly |
| ECON-003 | Interest Rate | [%] | Fed/ECB | Quarterly |
| ECON-004 | Unemployment Rate | [%] | Labor Stats | Quarterly |
| ECON-005 | Consumer Confidence Index | [Index] | Conference Board | Monthly |
| ECON-006 | Industrial Production Index | [Index] | Gov't Stats | Monthly |
| ECON-007 | Currency Exchange Rates | [Table] | FX Markets | Monthly |

### Formulas
Same column structure as Master Log, auto-filtered by Category = "ECON"

---

## Sheet 5: Market & Competitive Assumptions

### Pre-populated
| ID | Assumption | Source |
|----|-----------|--------|
| MKT-001 | Total addressable market size | Market research |
| MKT-002 | Market growth rate | Industry reports |
| MKT-003 | Competitor pricing actions | Competitive intel |
| MKT-004 | New market entrants | Industry analysis |
| MKT-005 | Technology disruption risk | R&D/Innovation |
| MKT-006 | Market share assumptions | Sales/Marketing |

---

## Sheet 6: Customer-Specific Assumptions

### Pre-populated
| ID | Assumption | Source |
|----|-----------|--------|
| CUST-001 | Key account volume commitments | Account managers |
| CUST-002 | Contract renewal probabilities | Sales pipeline |
| CUST-003 | Customer expansion plans | JBP meetings |
| CUST-004 | Customer inventory levels | VMI/customer data |
| CUST-005 | Seasonal demand patterns by customer | Historical data |

---

## Sheet 7: Product & Portfolio Assumptions

| ID | Assumption | Source |
|----|-----------|--------|
| PROD-001 | NPI launch dates and ramp | Product management |
| PROD-002 | Cannibalization rates | Analytics |
| PROD-003 | EOL timeline and rundown | Product review |
| PROD-004 | Product mix shifts | Market analysis |

---

## Sheet 8: Pricing Assumptions

| ID | Assumption | Source |
|----|-----------|--------|
| PRC-001 | Annual price increase % | Commercial strategy |
| PRC-002 | Competitive pricing pressure | Market intel |
| PRC-003 | Raw material cost pass-through | Procurement |
| PRC-004 | Discount/rebate accrual rates | Finance |

---

## Sheet 9: Promotional Assumptions

| ID | Assumption | Source |
|----|-----------|--------|
| PROMO-001 | Promotional calendar and timing | Marketing |
| PROMO-002 | Expected promotional uplift % | Historical data |
| PROMO-003 | Cannibalization from promotions | Analytics |
| PROMO-004 | Post-promotional dip factor | Historical analysis |

---

## Sheet 10: Channel & Distribution Assumptions

| ID | Assumption | Source |
|----|-----------|--------|
| CHAN-001 | Channel mix shifts | Sales analytics |
| CHAN-002 | New distribution partnerships | Business development |
| CHAN-003 | E-commerce growth rate | Digital team |
| CHAN-004 | Distribution lead time changes | Logistics |

---

## Sheet 11: Regulatory & External Assumptions

| ID | Assumption | Source |
|----|-----------|--------|
| REG-001 | Regulatory changes impacting demand | Legal/Compliance |
| REG-002 | Trade policy / tariff changes | Government affairs |
| REG-003 | Environmental regulation impact | Sustainability |
| REG-004 | Industry standards changes | Technical team |

---

## Sheet 12: Change Log

### Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Change Date | `=NOW()` auto-timestamp on entry |
| B | Assumption ID | Dropdown from Master_Log!A:A |
| C | Assumption | `=VLOOKUP(B3,Master_Log!A:C,3,FALSE)` |
| D | Field Changed | Dropdown: Value/Impact/Confidence/Valid Through/Status |
| E | Previous Value | Text |
| F | New Value | Text |
| G | Reason for Change | Text |
| H | Changed By | Text |
| I | Impact on Demand Plan | Text/Number |

---

## Sheet 13: Executive Escalation

### Purpose
High-impact assumptions requiring executive visibility.

### Auto-filter criteria:
```excel
=AND(OR(E3="Critical",E3="High"),OR(G3="EXPIRED",G3="Expiring Soon"))
```

### Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Assumption ID | Filtered from Master |
| B | Assumption | `=VLOOKUP(A3,Master_Log!A:C,3,FALSE)` |
| C | Impact Level | `=VLOOKUP(A3,Master_Log!A:E,5,FALSE)` |
| D | Status | `=VLOOKUP(A3,Master_Log!A:G,7,FALSE)` |
| E | Impact Value ($K) | `=VLOOKUP(A3,Master_Log!A:K,11,FALSE)` |
| F | Risk-Weighted ($K) | `=VLOOKUP(A3,Master_Log!A:L,12,FALSE)` |
| G | Days Expired/Until Expiry | `=IF(D3="EXPIRED",TODAY()-VLOOKUP(A3,Master_Log!A:H,8,FALSE),VLOOKUP(A3,Master_Log!A:H,8,FALSE)-TODAY())` |
| H | Executive Action Required | Dropdown: Validate/Revise/Escalate/Accept Risk |
| I | Decision Date | Date |
| J | Decision Maker | Text |

### Conditional Formatting
- All rows with "EXPIRED" + "Critical": Bold red border, red background
- Total risk-weighted exposure: `=SUM(F:F)` in summary tile

---

## Sheet 14: Validation Calendar

### Auto-calculated review schedule

| Col | Header | Formula |
|-----|--------|---------|
| A | Assumption ID | From Master |
| B | Category | `=VLOOKUP(A3,Master_Log!A:B,2,FALSE)` |
| C | Last Reviewed | `=VLOOKUP(A3,Master_Log!A:N,14,FALSE)` |
| D | Review Cycle (Days) | `=VLOOKUP(B3,Settings!ReviewCycleTable,2,FALSE)` |
| E | Next Review Due | `=C3+D3` |
| F | Days Until Due | `=E3-TODAY()` |
| G | Status | `=IF(F3<0,"OVERDUE",IF(F3<7,"THIS WEEK",IF(F3<30,"THIS MONTH","SCHEDULED")))` |

---

## Named Ranges

| Name | Reference | Purpose |
|------|-----------|---------|
| ASM_Master_Data | Master_Log!A:Q | Full assumption data |
| ASM_Valid_Count | Dashboard!B4 | Valid assumptions |
| ASM_Expired_Count | Dashboard!B6 | Expired count |
| ASM_Health_Rate | Dashboard!B7 | Overall health |
| ASM_Total_Risk_Exposure | Dashboard!B10 | Total risk-weighted impact |
| ASM_High_Impact_Expired | Dashboard!B8 | Critical expired count |

---

## Integration Points

| Workbook | Integration | Method |
|----------|-------------|--------|
| Consensus_Demand_ENHANCED | Assumptions feed consensus process | Named range ASM_Master_Data |
| Statistical_Forecast_ENHANCED | Model parameter assumptions | VLOOKUP from ASM_Master_Data |
| Bias_Analysis_ENHANCED | Assumption-driven bias identification | Cross-reference |
| Executive_Dashboard_ENHANCED | Assumption health KPI | Named range ASM_Health_Rate |
| Risk_Register_ENHANCED | High-impact assumption risks | Named range ASM_Total_Risk_Exposure |
| IBP_Master_Integration | Central hub connection | Power Query |

---

## VBA Automation

```vba
Sub CheckExpiredAssumptions()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Master_Log")
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim expiredCount As Long, criticalExpired As Long
    expiredCount = 0: criticalExpired = 0

    For i = 3 To lastRow
        If ws.Cells(i, 7).Value = "EXPIRED" Then
            expiredCount = expiredCount + 1
            If ws.Cells(i, 5).Value = "Critical" Or ws.Cells(i, 5).Value = "High" Then
                criticalExpired = criticalExpired + 1
            End If
        End If
    Next i

    If criticalExpired > 0 Then
        MsgBox criticalExpired & " HIGH/CRITICAL assumptions have expired!" & vbCrLf & _
               "Total expired: " & expiredCount & vbCrLf & _
               "Please review the Executive Escalation sheet.", _
               vbExclamation, "Assumption Alert"
    ElseIf expiredCount > 0 Then
        MsgBox expiredCount & " assumptions need review.", _
               vbInformation, "Assumption Review"
    End If
End Sub

Sub GenerateValidationReminders()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Validation_Calendar")
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim dueThisWeek As String
    dueThisWeek = "Assumptions due for review this week:" & vbCrLf & vbCrLf
    Dim count As Long: count = 0

    For i = 3 To lastRow
        If ws.Cells(i, 7).Value = "THIS WEEK" Or ws.Cells(i, 7).Value = "OVERDUE" Then
            dueThisWeek = dueThisWeek & "- " & ws.Cells(i, 1).Value & ": " & _
                          ws.Cells(i, 7).Value & vbCrLf
            count = count + 1
        End If
    Next i

    If count > 0 Then
        MsgBox dueThisWeek, vbInformation, count & " Reviews Due"
    Else
        MsgBox "No assumption reviews due this week.", vbInformation, "All Clear"
    End If
End Sub
```

---

*Integration-ready assumption management with automated expiry tracking and executive escalation.*
