# Strategic Initiatives Tracker - Enhanced Excel Workbook
## Portfolio Management for IBP Strategic Programs

---

## Overview
Strategic initiative portfolio management with investment tracking, benefits realization, milestone monitoring, and resource allocation. Supports executive decision-making on strategic priorities.

---

## Design Theme: "Strategic Portfolio"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Royal Blue (#2563EB) |
| On Track | Green (#10B981) |
| At Risk | Amber (#F59E0B) |
| Off Track | Red (#EF4444) |

---

# SHEET 1: PORTFOLIO DASHBOARD

## KPI Tiles

| KPI | Formula |
|-----|---------|
| Total Initiatives | `=COUNTA(Portfolio!A3:A100)` |
| Total Investment ($M) | `=SUM(Portfolio!H:H)/1000000` |
| Total Expected Benefit ($M) | `=SUM(Portfolio!I:I)/1000000` |
| Portfolio ROI | `=(Total_Benefit-Total_Investment)/Total_Investment` |
| On Track % | `=COUNTIF(Portfolio!M:M,"On Track")/Total` |
| At Risk % | `=COUNTIF(Portfolio!M:M,"At Risk")/Total` |
| Avg Completion % | `=AVERAGE(Portfolio!L:L)` |

---

# SHEET 2: INITIATIVE PORTFOLIO

## Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Initiative_ID | Auto: `="SI-"&TEXT(ROW()-2,"000")` |
| B | Initiative Name | Text |
| C | Strategic Pillar | Dropdown |
| D | Description | Text |
| E | Sponsor | Dropdown |
| F | Project Lead | Dropdown |
| G | Start Date | Date |
| H | End Date | Date |
| I | **Investment ($K)** | Budget |
| J | **Expected Benefit ($K)** | Target benefit |
| K | **ROI** | `=(J3-I3)/I3` |
| L | **Completion %** | 0-100% |
| M | **Status** | `=IF(Schedule_Var<=-10,"Off Track",IF(Schedule_Var<0,"At Risk","On Track"))` |
| N | Budget Spent ($K) | Actual spend |
| O | Budget Variance | `=(N3-I3*L3)/I3` |
| P | Benefits Realized ($K) | Actual benefits |
| Q | Realization Rate | `=P3/J3` |
| R | Priority | High/Medium/Low |
| S | Phase | Planning/Execution/Closing |
| T | Next Milestone | Text |
| U | Milestone Date | Date |
| V | Days to Milestone | `=U3-TODAY()` |

### Conditional Formatting
- Status "On Track": Green
- Status "At Risk": Yellow
- Status "Off Track": Red
- ROI >50%: Green bold

---

# SHEET 3: BY STRATEGIC PILLAR

## Summary by Pillar

| Col | Header | Formula |
|-----|--------|---------|
| A | Pillar | Strategic pillar |
| B | Initiative Count | `=COUNTIF(Portfolio!C:C,A3)` |
| C | Total Investment ($K) | `=SUMIF(Portfolio!C:C,A3,Portfolio!I:I)` |
| D | Total Benefit ($K) | `=SUMIF(Portfolio!C:C,A3,Portfolio!J:J)` |
| E | Pillar ROI | `=(D3-C3)/C3` |
| F | Avg Completion | `=AVERAGEIF(Portfolio!C:C,A3,Portfolio!L:L)` |
| G | On Track Count | `=COUNTIFS(Portfolio!C:C,A3,Portfolio!M:M,"On Track")` |

---

# SHEET 4: BUDGET TRACKING

## Monthly Investment vs Spend

| Col | Header | Formula |
|-----|--------|---------|
| A | Initiative_ID | From Portfolio |
| B | Initiative | Lookup |
| C | Total Budget ($K) | From Portfolio |
| D-O | M1-M12 Planned | Monthly budget |
| P-AA | M1-M12 Actual | Monthly actuals |
| AB | Cumulative Planned | `=SUM(D3:O3)` |
| AC | Cumulative Actual | `=SUM(P3:AA3)` |
| AD | Variance | `=AC3-AB3` |
| AE | CPI | `=AB3/AC3` (Cost Performance Index) |

---

# SHEET 5: BENEFITS REALIZATION

## Benefits Tracking

| Col | Header | Formula |
|-----|--------|---------|
| A | Initiative_ID | From Portfolio |
| B | Initiative | Lookup |
| C | Expected Benefit ($K) | Total expected |
| D | Benefit Type | Revenue/Cost/Efficiency |
| E-P | Q1-Q4 Target | Quarterly targets |
| Q-AB | Q1-Q4 Actual | Quarterly actuals |
| AC | Total Realized | `=SUM(Q3:AB3)` |
| AD | Realization % | `=AC3/C3` |
| AE | Gap to Target | `=C3-AC3` |
| AF | Confidence | High/Medium/Low |

---

# SHEET 6: MILESTONE TRACKER

## Key Milestones

| Col | Header | Formula |
|-----|--------|-------------------|
| A | Initiative_ID | From Portfolio |
| B | Milestone | Description |
| C | Target Date | Planned date |
| D | Actual Date | Completion date |
| E | Variance (Days) | `=IF(D3="",C3-TODAY(),D3-C3)` |
| F | Status | `=IF(D3<>"","Complete",IF(C3<TODAY(),"Overdue","Upcoming"))` |
| G | Owner | Responsible person |
| H | Dependencies | Related milestones |
| I | Notes | Comments |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| SI_Portfolio | Portfolio!A:V | All initiatives |
| SI_Total_Investment | Dashboard!B4 | Total investment |
| SI_Total_Benefit | Dashboard!B5 | Total expected benefit |
| SI_Portfolio_ROI | Dashboard!B6 | Portfolio ROI |
| SI_OnTrack_Pct | Dashboard!B7 | On track percentage |

---

# VBA AUTOMATION

```vba
Sub RefreshPortfolioDashboard()
    ThisWorkbook.Sheets("Dashboard").Calculate
    MsgBox "Portfolio dashboard refreshed." & vbCrLf & _
           "Total Initiatives: " & Range("SI_Portfolio").Rows.Count - 1 & vbCrLf & _
           "Portfolio ROI: " & Format(Range("SI_Portfolio_ROI").Value, "0%"), _
           vbInformation
End Sub
```

---

*Strategic initiative portfolio management with ROI tracking, benefits realization, and milestone monitoring.*
