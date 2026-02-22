# Risk Register - Enhanced Excel Workbook
## Enterprise IBP Risk Management with Heat Map & Mitigation Tracking

---

## Overview
Comprehensive risk management workbook for IBP with probability-impact scoring, heat map visualization, mitigation tracking, and financial exposure analysis. Supports proactive risk identification and executive escalation.

---

## Design Theme: "Risk Intelligence"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Crimson (#DC2626) |
| Low Risk | Green (#10B981) |
| Medium Risk | Amber (#F59E0B) |
| High Risk | Orange (#EA580C) |
| Critical Risk | Red (#DC2626) |

---

# SHEET 1: SETTINGS

## Risk Scoring Framework

| Score | Probability | Impact |
|-------|------------|--------|
| 1 | Very Low (<10%) | Negligible (<$50K) |
| 2 | Low (10-25%) | Minor ($50K-$250K) |
| 3 | Medium (25-50%) | Moderate ($250K-$1M) |
| 4 | High (50-75%) | Major ($1M-$5M) |
| 5 | Very High (>75%) | Severe (>$5M) |

## Risk Categories
- Supply Chain
- Demand/Market
- Financial
- Operational
- Technology
- Regulatory
- Quality
- People

---

# SHEET 2: RISK DASHBOARD

## KPI Tiles

| KPI | Formula | Format |
|-----|---------|--------|
| Total Active Risks | `=COUNTIF(Register!Status,"Active")` | Count |
| Critical Risks | `=COUNTIF(Register!Risk_Level,"Critical")` | Count |
| High Risks | `=COUNTIF(Register!Risk_Level,"High")` | Count |
| Avg Risk Score | `=AVERAGE(Register!Risk_Score)` | Number |
| Total Exposure ($M) | `=SUM(Register!Exposure)/1000000` | Currency |
| Expected Loss ($M) | `=SUMPRODUCT(Register!Exposure,Register!Probability)/1000000` | Currency |
| Mitigation Coverage | `=COUNTIF(Register!Mitigation_Status,"Active")/Total_Risks` | Percentage |

## Risk Distribution

| Level | Count | % of Total | Exposure |
|-------|-------|-----------|----------|
| Critical | Formula | Formula | Formula |
| High | Formula | Formula | Formula |
| Medium | Formula | Formula | Formula |
| Low | Formula | Formula | Formula |

---

# SHEET 3: RISK REGISTER

## Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Risk_ID | Auto: `="R-"&TEXT(ROW()-2,"000")` |
| B | Category | Dropdown from Settings |
| C | Risk Title | Text |
| D | Risk Description | Text |
| E | Risk Owner | Dropdown |
| F | Date Identified | Date |
| G | **Probability (1-5)** | Dropdown 1-5 |
| H | **Impact (1-5)** | Dropdown 1-5 |
| I | **Risk Score** | `=G3*H3` |
| J | **Risk Level** | `=IF(I3>=15,"Critical",IF(I3>=9,"High",IF(I3>=4,"Medium","Low")))` |
| K | Impact Value ($K) | Financial exposure |
| L | Expected Loss ($K) | `=K3*G3/5` |
| M | Mitigation Strategy | Text |
| N | Mitigation Owner | Dropdown |
| O | Mitigation Due Date | Date |
| P | Mitigation Status | Dropdown: Not Started/In Progress/Complete |
| Q | Residual Probability | After mitigation |
| R | Residual Impact | After mitigation |
| S | Residual Score | `=Q3*R3` |
| T | Score Reduction | `=I3-S3` |
| U | Status | Active/Monitoring/Closed |
| V | Last Review | Date |
| W | Next Review | `=V3+30` |
| X | Days Until Review | `=W3-TODAY()` |

### Conditional Formatting
- Risk Level "Critical": Red background (#FEE2E2)
- Risk Level "High": Orange background (#FFEDD5)
- Risk Level "Medium": Yellow background (#FEF3C7)
- Risk Level "Low": Green background (#D1FAE5)
- Days Until Review <0: Red text (overdue)

---

# SHEET 4: HEAT MAP DATA

## 5x5 Probability-Impact Matrix

| Impact↓ / Prob→ | 1 | 2 | 3 | 4 | 5 |
|-----------------|---|---|---|---|---|
| 5 (Severe) | 5 | 10 | 15 | 20 | 25 |
| 4 (Major) | 4 | 8 | 12 | 16 | 20 |
| 3 (Moderate) | 3 | 6 | 9 | 12 | 15 |
| 2 (Minor) | 2 | 4 | 6 | 8 | 10 |
| 1 (Negligible) | 1 | 2 | 3 | 4 | 5 |

### Risk Count per Cell
```excel
=COUNTIFS(Register!$G:$G,Col_Prob,Register!$H:$H,Row_Impact,Register!$U:$U,"Active")
```

### Color Scale
- Score 1-3: Green
- Score 4-8: Yellow
- Score 9-14: Orange
- Score 15-25: Red

---

# SHEET 5: BY CATEGORY

## Risk Summary by Category

| Col | Header | Formula |
|-----|--------|---------|
| A | Category | Category list |
| B | Count | `=COUNTIF(Register!B:B,A3)` |
| C | Avg Score | `=AVERAGEIF(Register!B:B,A3,Register!I:I)` |
| D | Max Score | `=MAXIFS(Register!I:I,Register!B:B,A3)` |
| E | Total Exposure ($K) | `=SUMIF(Register!B:B,A3,Register!K:K)` |
| F | Expected Loss ($K) | `=SUMIF(Register!B:B,A3,Register!L:L)` |
| G | Critical Count | `=COUNTIFS(Register!B:B,A3,Register!J:J,"Critical")` |
| H | % Mitigated | `=COUNTIFS(Register!B:B,A3,Register!P:P,"Complete")/B3` |
| I | Trend | Improving/Stable/Worsening |

---

# SHEET 6: MITIGATION TRACKER

## Mitigation Action Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Risk_ID | From Register |
| B | Risk Title | `=VLOOKUP(A3,Register!A:C,3,FALSE)` |
| C | Current Score | `=VLOOKUP(A3,Register!A:I,9,FALSE)` |
| D | Mitigation Action | From Register |
| E | Owner | From Register |
| F | Due Date | From Register |
| G | Days Until Due | `=F3-TODAY()` |
| H | Status | From Register |
| I | Progress % | Manual entry |
| J | Blockers | Text |
| K | Target Residual | Target score after mitigation |
| L | Achieved Residual | Actual residual score |
| M | Effectiveness | `=IF(L3<=K3,"Effective","Below Target")` |

### Conditional Formatting
- Days Until Due <0: Red (overdue)
- Status "Complete" and Effective: Green row
- Progress <50% and Due <14 days: Yellow alert

---

# SHEET 7: FINANCIAL EXPOSURE

## Risk Financial Impact Analysis

| Col | Header | Formula |
|-----|--------|---------|
| A | Risk_ID | Active risks |
| B | Risk Title | Lookup |
| C | Category | Lookup |
| D | Probability % | `=G/5*100` |
| E | Impact Value ($K) | From Register |
| F | Expected Loss ($K) | `=D3*E3/100` |
| G | Best Case ($K) | Minimum impact |
| H | Worst Case ($K) | Maximum impact |
| I | Insurance/Hedge ($K) | Covered amount |
| J | Net Exposure ($K) | `=E3-I3` |
| K | Net Expected Loss ($K) | `=D3*J3/100` |

### Summary
```excel
Total Gross Exposure: =SUM(E:E)
Total Expected Loss: =SUM(F:F)
Total Insured/Hedged: =SUM(I:I)
Net Exposure: =SUM(J:J)
Net Expected Loss: =SUM(K:K)
```

---

# SHEET 8: TREND ANALYSIS

## Monthly Risk Score Trend

| Col | Header | Formula |
|-----|--------|---------|
| A | Month | Month list |
| B | Active Risks | Count per month |
| C | Avg Score | Average score |
| D | Critical Count | Critical risks |
| E | New Risks | Risks identified |
| F | Closed Risks | Risks closed |
| G | Net Change | `=E3-F3` |
| H | Total Exposure ($M) | Monthly exposure |
| I | Trend Direction | `=IF(C3<C2,"Improving",IF(C3>C2,"Worsening","Stable"))` |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| Risk_Register | Register!A:X | Full risk data |
| Risk_Active_Count | Dashboard!B3 | Active risks |
| Risk_Critical_Count | Dashboard!B4 | Critical count |
| Risk_Total_Exposure | Dashboard!B7 | Total exposure |
| Risk_Expected_Loss | Dashboard!B8 | Expected loss |

---

# VBA AUTOMATION

```vba
Sub AlertCriticalRisks()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Register")

    Dim critical As Long
    critical = WorksheetFunction.CountIf(ws.Range("J:J"), "Critical")

    If critical > 0 Then
        MsgBox "⚠ " & critical & " CRITICAL risks require immediate attention!", _
               vbCritical, "Risk Alert"
    End If
End Sub

Sub ReviewOverdueRisks()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Register")

    Dim overdue As Long
    overdue = WorksheetFunction.CountIf(ws.Range("X:X"), "<0")

    If overdue > 0 Then
        MsgBox overdue & " risks are overdue for review.", vbExclamation
    End If
End Sub
```

---

*Enterprise risk management with heat map visualization, mitigation tracking, and financial exposure analysis.*
