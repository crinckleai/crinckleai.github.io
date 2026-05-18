# IBP Meeting Cadence & Structure - Enhanced Excel Workbook Specification

## Overview

This workbook provides a comprehensive framework for managing the IBP meeting cadence across all five core review meetings (Product, Demand, Supply, Financial, and Executive). It includes automated scheduling, attendance tracking, effectiveness scoring, and an annual calendar view. The workbook serves as the operational backbone for IBP governance, ensuring consistent process execution and continuous improvement of meeting quality.

**Workbook Name:** `Meeting_Cadence_ENHANCED.xlsx`
**Total Sheets:** 10
**Primary Users:** IBP Process Owner, Meeting Facilitators, Executive Sponsors
**Update Frequency:** Monthly (with weekly references)

---

## Design Theme

### Color Palette

| Element | Color | Hex Code | Usage |
|---------|-------|----------|-------|
| Primary Header | Navy | `#1B2A4A` | Sheet headers, title bars |
| Secondary Header | Dark Navy | `#0F1B2D` | Sub-headers, section dividers |
| Accent | Teal | `#0D9488` | Key metrics, highlights, active items |
| Status Green | Emerald | `#10B981` | On-target, >90% attendance, high effectiveness |
| Status Yellow | Amber | `#F59E0B` | Warning, 80-90% attendance, moderate effectiveness |
| Status Red | Red | `#EF4444` | Alert, <80% attendance, low effectiveness |
| Background | Light Gray | `#F8FAFC` | Alternating row fill |
| Text Primary | Charcoal | `#1E293B` | Body text |
| Text Secondary | Slate | `#64748B` | Labels, footnotes |
| Border | Light Border | `#E2E8F0` | Cell borders, gridlines |

### Typography

| Element | Font | Size | Weight | Color |
|---------|------|------|--------|-------|
| Workbook Title | Calibri | 18pt | Bold | White on `#1B2A4A` |
| Sheet Title | Calibri | 16pt | Bold | `#1B2A4A` |
| Section Header | Calibri | 13pt | Bold | `#1B2A4A` |
| Column Header | Calibri | 11pt | Bold | White on `#1B2A4A` |
| Body Text | Calibri | 11pt | Regular | `#1E293B` |
| Footnotes | Calibri | 9pt | Italic | `#64748B` |

### Standard Formatting Rules

- All sheets: Freeze panes at row 3 (below title and column headers)
- Print area: Set to data region on each sheet, landscape orientation
- Sheet tab colors: Match meeting type accent color
- Zoom level: Default 100%
- Column widths: Auto-fit with minimum 12 characters

---

## Sheet 1: Settings & Configuration

### Purpose
Central configuration sheet for all workbook parameters. All other sheets reference this sheet for dynamic values.

### Layout

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 1 | **IBP Meeting Cadence - Settings & Configuration** (merged A1:D1) | | | |
| 2 | *Last Updated:* | `=TODAY()` | *Updated By:* | (manual entry) |
| 4 | **COMPANY SETTINGS** (merged A4:D4, section header) | | | |
| 5 | Company Name | (input cell) | | |
| 6 | Fiscal Year Start Month | (dropdown: Jan-Dec) | Fiscal Year | (auto: e.g., "FY2026") |
| 7 | IBP Cycle Start Date | (date input) | Current Cycle | `=TEXT(IBP_Cycle_Start,"MMMM YYYY")` |
| 8 | Planning Horizon (months) | 24 | | |
| 10 | **MEETING DEFAULTS** (merged A10:D10) | | | |
| 11 | Header | Day of Week | Default Time | Default Duration (min) |
| 12 | Product Review | Thursday | 09:00 | 90 |
| 13 | Demand Review | Thursday | 09:00 | 90 |
| 14 | Supply Review | Thursday | 09:00 | 90 |
| 15 | Financial Review | Tuesday | 14:00 | 60 |
| 16 | Executive IBP | Thursday | 10:00 | 120 |
| 18 | **MEETING LOCATIONS** (merged A18:D18) | | | |
| 19 | Header | Room Name | Building | Capacity |
| 20 | Product Review | (input) | (input) | (input) |
| 21 | Demand Review | (input) | (input) | (input) |
| 22 | Supply Review | (input) | (input) | (input) |
| 23 | Financial Review | (input) | (input) | (input) |
| 24 | Executive IBP | (input) | (input) | (input) |
| 26 | **CONDITIONAL FORMATTING CODES** (merged A26:D26) | | | |
| 27 | Status | Color | Hex Code | Threshold |
| 28 | Excellent / On Track | Green Fill | `#10B981` | >90% or Score >4.0 |
| 29 | Needs Attention | Yellow Fill | `#F59E0B` | 80-90% or Score 3.0-4.0 |
| 30 | Critical / Action Required | Red Fill | `#EF4444` | <80% or Score <3.0 |
| 32 | **WEEK MAPPING** (merged A32:D32) | | | |
| 33 | Meeting | Week of Month | Offset Days | Notes |
| 34 | Product Review | Week 1 | 0 | First week of IBP cycle |
| 35 | Demand Review | Week 2 | 7 | After product review |
| 36 | Supply Review | Week 3 | 14 | After demand review |
| 37 | Financial Review | Week 3 | 16 | Follows supply review |
| 38 | Executive IBP | Week 4 | 21 | Final integration meeting |

### Named Ranges (Sheet 1)

| Named Range | Reference | Scope |
|-------------|-----------|-------|
| `Company_Name` | `Settings!$B$5` | Workbook |
| `FY_Start` | `Settings!$B$6` | Workbook |
| `IBP_Cycle_Start` | `Settings!$B$7` | Workbook |
| `Planning_Horizon` | `Settings!$B$8` | Workbook |
| `Meeting_Names` | `Settings!$A$12:$A$16` | Workbook |
| `Meeting_Days` | `Settings!$B$12:$B$16` | Workbook |
| `Meeting_Times` | `Settings!$C$12:$C$16` | Workbook |
| `Meeting_Durations` | `Settings!$D$12:$D$16` | Workbook |
| `Week_Offsets` | `Settings!$C$34:$C$38` | Workbook |

### Data Validation

| Cell(s) | Validation Type | Values |
|---------|----------------|--------|
| B6 | List | Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec |
| B7 | Date | >= TODAY()-365 |
| B12:B16 | List | Monday, Tuesday, Wednesday, Thursday, Friday |
| C12:C16 | Time | 07:00 - 18:00 |
| D12:D16 | Whole Number | 30 - 180 |

---

## Sheet 2: Meeting Overview Dashboard

### Purpose
At-a-glance view of all five IBP meetings with key status indicators, next meeting dates, attendance rates, and effectiveness scores.

### Layout

| Row | Content |
|-----|---------|
| 1 | **IBP Meeting Overview Dashboard** (merged A1:L1, Navy header bar) |
| 2 | Subtitle: `="Current Cycle: "&TEXT(IBP_Cycle_Start,"MMMM YYYY")&" | "&Company_Name` |
| 4 | **KPI TILES ROW** (merged cells for 5 tiles across columns A-L) |

### KPI Tiles (Row 4-7)

| Tile | Label | Formula | Format |
|------|-------|---------|--------|
| Tile 1 (A4:B7) | Avg Attendance Rate | `=AVERAGE(Attendance!$M$5:$M$9)` | Percentage, 1 decimal |
| Tile 2 (C4:D7) | Avg Effectiveness | `=AVERAGE('Meeting Effectiveness'!$N$5:$N$9)` | Number, 1 decimal /5 |
| Tile 3 (E4:F7) | Meetings This Month | `=COUNTIFS(Calendar!$B:$B,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),Calendar!$B:$B,"<="&EOMONTH(TODAY(),0))` | Integer |
| Tile 4 (G4:H7) | Decisions Pending | (manual input or linked) | Integer |
| Tile 5 (I4:J7) | Action Items Open | (manual input or linked) | Integer |

### Meeting Detail Table (Rows 9-16)

| Column | Header | Width |
|--------|--------|-------|
| A | Meeting Name | 25 |
| B | Week | 10 |
| C | Day | 12 |
| D | Time | 10 |
| E | Duration (min) | 14 |
| F | Location | 20 |
| G | Chair | 18 |
| H | Next Meeting Date | 16 |
| I | Days Until | 12 |
| J | Last Attendance % | 16 |
| K | Last Effectiveness | 16 |
| L | Status | 12 |

### Formulas (Meeting Detail Table)

```excel
' Row 10 (Product Review), example formulas:

' H10 - Next Meeting Date
=WORKDAY(IBP_Cycle_Start + INDEX(Week_Offsets, MATCH("Product Review", Meeting_Names, 0)) + (DATEDIF(IBP_Cycle_Start, TODAY(), "M")) * 30, 0)

' Simplified next meeting date calculation
=LET(
    offset, INDEX(Week_Offsets, MATCH(A10, Meeting_Names, 0)),
    base, IBP_Cycle_Start,
    months_elapsed, DATEDIF(base, TODAY(), "M"),
    next_date, WORKDAY(EDATE(base, months_elapsed) + offset, 0),
    IF(next_date < TODAY(), WORKDAY(EDATE(base, months_elapsed + 1) + offset, 0), next_date)
)

' I10 - Days Until Next Meeting
=MAX(0, H10 - TODAY())

' J10 - Last Attendance %
=IFERROR(INDEX(Attendance!$M:$M, MATCH(A10, Attendance!$A:$A, 0)), "N/A")

' K10 - Last Effectiveness Score
=IFERROR(INDEX('Meeting Effectiveness'!$N:$N, MATCH(A10, 'Meeting Effectiveness'!$A:$A, 0)), "N/A")

' L10 - Status (combined assessment)
=IF(AND(J10>=0.9, K10>=4), "On Track",
   IF(OR(J10<0.8, K10<3), "Critical", "Attention"))
```

### Conditional Formatting (Meeting Detail Table)

| Range | Rule | Format |
|-------|------|--------|
| I10:I14 | Value <= 3 | Bold, `#EF4444` font (meeting is imminent) |
| I10:I14 | Value <= 7 AND > 3 | `#F59E0B` font |
| J10:J14 | Value >= 0.9 | Fill `#D1FAE5`, Font `#065F46` |
| J10:J14 | Value >= 0.8 AND < 0.9 | Fill `#FEF3C7`, Font `#92400E` |
| J10:J14 | Value < 0.8 | Fill `#FEE2E2`, Font `#991B1B` |
| K10:K14 | Value >= 4 | Fill `#D1FAE5`, Font `#065F46` |
| K10:K14 | Value >= 3 AND < 4 | Fill `#FEF3C7`, Font `#92400E` |
| K10:K14 | Value < 3 | Fill `#FEE2E2`, Font `#991B1B` |
| L10:L14 | Text = "On Track" | Fill `#10B981`, Font White |
| L10:L14 | Text = "Attention" | Fill `#F59E0B`, Font White |
| L10:L14 | Text = "Critical" | Fill `#EF4444`, Font White |

---

## Sheet 3: Product Review Structure

### Purpose
Detailed agenda template for the monthly Product Review meeting, including timing, presenters, materials checklist, and preparation tracker.

### Layout

| Row | Content |
|-----|---------|
| 1 | **Product Review - Meeting Structure** (merged, Navy header) |
| 2 | `="Meeting Date: "&TEXT(Next_Product_Date,"dddd, mmmm d, yyyy")&" | Duration: "&INDEX(Meeting_Durations,1)&" minutes"` |

### Agenda Table (Rows 4-25)

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | Seq # | 6 | Agenda item sequence |
| B | Section | 20 | Major section name |
| C | Agenda Item | 35 | Detailed agenda item |
| D | Duration (min) | 14 | Allocated time |
| E | Cumulative (min) | 16 | Running total |
| F | Presenter | 18 | Responsible person |
| G | Materials Required | 30 | Supporting documents |
| H | Material Status | 14 | Ready / Pending / Late |
| I | Pre-Read Required | 14 | Yes / No |
| J | Notes | 30 | Additional context |

### Pre-populated Agenda Items

| Seq | Section | Agenda Item | Duration |
|-----|---------|-------------|----------|
| 1 | Opening | Welcome & Previous Action Review | 5 |
| 2 | Performance Review | NPI Performance vs Plan | 10 |
| 3 | Performance Review | Portfolio Health Metrics Review | 10 |
| 4 | Performance Review | Lifecycle Stage Updates | 5 |
| 5 | Portfolio Updates | New Product Pipeline Review | 15 |
| 6 | Portfolio Updates | Project Status & Timeline Changes | 10 |
| 7 | Portfolio Updates | Rationalization Recommendations | 5 |
| 8 | Market Intelligence | Market Trends & Opportunities | 10 |
| 9 | Market Intelligence | Competitive Actions & Responses | 5 |
| 10 | Decisions & Actions | Go/No-Go Decisions | 10 |
| 11 | Decisions & Actions | Resource Allocation | 5 |
| 12 | Closing | Action Items & Next Steps | 5 |

### Formulas

```excel
' E5 - Cumulative Duration (first data row)
=D5

' E6 - Cumulative Duration (subsequent rows)
=E5 + D6

' Total Duration (below last item)
=SUM(D5:D16)

' Duration Validation (merged cell below table)
=IF(SUM(D5:D16) > INDEX(Meeting_Durations, 1),
    "WARNING: Agenda exceeds allocated time by " & SUM(D5:D16) - INDEX(Meeting_Durations, 1) & " minutes",
    "Agenda fits within allocated " & INDEX(Meeting_Durations, 1) & " minutes (" & INDEX(Meeting_Durations, 1) - SUM(D5:D16) & " min buffer)")

' Material Readiness %
=COUNTIF(H5:H16, "Ready") / COUNTA(H5:H16)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| Total Duration Cell | `=SUM(D5:D16) > 90` | Fill `#FEE2E2`, Font `#991B1B`, Bold |
| Total Duration Cell | `=SUM(D5:D16) <= 90` | Fill `#D1FAE5`, Font `#065F46`, Bold |
| H5:H16 | Text = "Ready" | Fill `#D1FAE5`, Font `#065F46` |
| H5:H16 | Text = "Pending" | Fill `#FEF3C7`, Font `#92400E` |
| H5:H16 | Text = "Late" | Fill `#FEE2E2`, Font `#991B1B` |
| E5:E16 | Value > 90 | Font `#EF4444`, Bold (overtime indicator) |

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| H5:H16 | List | Ready, Pending, Late, N/A |
| I5:I16 | List | Yes, No |
| D5:D16 | Whole Number | 1 - 60 |

### Key Participants Section (Rows 28-38)

| Column A | Column B | Column C | Column D |
|----------|----------|----------|----------|
| Role | Name | Required/Optional | Delegate |
| VP Product Management | (input) | Required | (input) |
| Product Managers (x3) | (input) | Required | (input) |
| VP Marketing | (input) | Optional | (input) |
| R&D Director | (input) | Required | (input) |
| Supply Chain Lead | (input) | Optional | (input) |
| Finance Business Partner | (input) | Required | (input) |
| IBP Process Owner | (input) | Required | (input) |

---

## Sheet 4: Demand Review Structure

### Purpose
Detailed agenda template for the monthly Demand Review meeting.

### Layout
Identical structure to Sheet 3 with demand-specific content.

### Pre-populated Agenda Items

| Seq | Section | Agenda Item | Duration |
|-----|---------|-------------|----------|
| 1 | Opening | Welcome & Previous Action Review | 5 |
| 2 | Forecast Performance | Accuracy & Bias Metrics Review | 10 |
| 3 | Forecast Performance | Root Cause Analysis of Variances | 10 |
| 4 | Forecast Performance | Improvement Action Status | 5 |
| 5 | Demand Plan Review | Statistical Baseline Presentation | 10 |
| 6 | Demand Plan Review | Sales Overlay Review by Region | 10 |
| 7 | Demand Plan Review | Marketing Overlay (Promotions, Events) | 5 |
| 8 | Demand Plan Review | Risk & Opportunity Assessment | 10 |
| 9 | Assumptions & Drivers | Key Assumption Validation | 5 |
| 10 | Assumptions & Drivers | Leading Indicator Review | 5 |
| 11 | Consensus Building | Consensus Demand Agreement | 10 |
| 12 | Closing | Escalations for Executive Review | 5 |

### Formulas

```excel
' Same structure as Product Review
=SUM(D5:D16)  ' Total duration
=IF(SUM(D5:D16) > INDEX(Meeting_Durations, 2),
    "WARNING: Agenda exceeds allocated time by " & SUM(D5:D16) - INDEX(Meeting_Durations, 2) & " minutes",
    "Agenda fits within allocated " & INDEX(Meeting_Durations, 2) & " minutes")
```

### Key Participants

| Role | Required/Optional |
|------|-------------------|
| VP Sales / CSO | Required |
| Regional Sales Directors | Required |
| Marketing Director | Required |
| Demand Planning Manager | Required |
| Finance Business Partner | Required |
| IBP Process Owner | Required |
| Supply Chain Representative | Optional |
| Key Account Managers | Optional (rotating) |

---

## Sheet 5: Supply Review Structure

### Purpose
Detailed agenda template for the monthly Supply Review meeting.

### Pre-populated Agenda Items

| Seq | Section | Agenda Item | Duration |
|-----|---------|-------------|----------|
| 1 | Opening | Welcome & Previous Action Review | 5 |
| 2 | Supply Performance | Plan Adherence Metrics | 10 |
| 3 | Supply Performance | Capacity Utilization Review | 10 |
| 4 | Supply Performance | Service Level Achievement | 5 |
| 5 | Supply Response | Demand-Supply Gap Analysis | 15 |
| 6 | Supply Response | Constraint Identification & Mitigation | 10 |
| 7 | Supply Response | Resource Requirements Review | 5 |
| 8 | Scenario Planning | Supply Scenarios for Demand Uncertainty | 10 |
| 9 | Scenario Planning | Risk Mitigation Options | 5 |
| 10 | Scenario Planning | Investment Recommendations | 5 |
| 11 | Escalations | Items Requiring Executive Decision | 5 |
| 12 | Closing | Committed Actions & Communication | 5 |

### Key Participants

| Role | Required/Optional |
|------|-------------------|
| VP Supply Chain / COO | Required |
| Plant Managers | Required |
| Procurement Director | Required |
| Logistics Manager | Required |
| Quality Director | Optional |
| Finance Business Partner | Required |
| IBP Process Owner | Required |

---

## Sheet 6: Financial Review Structure

### Purpose
Detailed agenda template for the Financial Review / Integrated Reconciliation meeting.

### Pre-populated Agenda Items

| Seq | Section | Agenda Item | Duration |
|-----|---------|-------------|----------|
| 1 | Opening | Welcome & Previous Action Review | 5 |
| 2 | Financial Performance | Revenue vs Plan & Prior Year | 10 |
| 3 | Financial Performance | Gross Margin Analysis | 10 |
| 4 | Financial Performance | Working Capital Review | 5 |
| 5 | Plan Reconciliation | Volume Plan to Revenue Bridge | 10 |
| 6 | Plan Reconciliation | Cost Variance Analysis | 5 |
| 7 | Plan Reconciliation | FX and Transfer Pricing Impact | 5 |
| 8 | Gap Analysis | Budget Gap Identification | 5 |
| 9 | Gap Analysis | Gap Closure Initiative Status | 10 |
| 10 | Scenarios | Financial Impact of Scenarios | 10 |
| 11 | Recommendations | Investment / Divestment Proposals | 5 |
| 12 | Closing | Escalations & Action Items | 5 |

### Duration Override
Financial Review default is 60 minutes. Conditional formatting threshold adjusted accordingly:
```excel
=IF(SUM(D5:D16) > INDEX(Meeting_Durations, 4),
    "WARNING: Exceeds " & INDEX(Meeting_Durations, 4) & " min allocation",
    "Within " & INDEX(Meeting_Durations, 4) & " min allocation")
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| Total Duration Cell | `> 60` | Fill `#FEE2E2`, Font `#991B1B` |
| Total Duration Cell | `<= 60` | Fill `#D1FAE5`, Font `#065F46` |

---

## Sheet 7: Executive IBP Structure

### Purpose
Detailed agenda template for the Executive IBP / Management Business Review meeting.

### Pre-populated Agenda Items

| Seq | Section | Agenda Item | Duration |
|-----|---------|-------------|----------|
| 1 | Opening | Strategic Context Setting | 5 |
| 2 | Business Performance | Key Metrics Dashboard Review | 15 |
| 3 | Business Performance | Financial Results vs Plan | 10 |
| 4 | Business Performance | Critical Issues Requiring Attention | 10 |
| 5 | Integrated Plan Review | Rolling 24-Month Demand Outlook | 10 |
| 6 | Integrated Plan Review | Supply Response & Constraints | 10 |
| 7 | Integrated Plan Review | Financial Projection vs Targets | 10 |
| 8 | Gap Analysis | Plan-to-Target Gap Identification | 10 |
| 9 | Gap Analysis | Scenario Options with Trade-offs | 10 |
| 10 | Gap Analysis | Risk Mitigation Strategies | 5 |
| 11 | Decisions | Investment / Divestment Decisions | 10 |
| 12 | Decisions | Capacity Commitments | 5 |
| 13 | Decisions | Policy Changes | 5 |
| 14 | Closing | Action Items, Owners, Deadlines | 5 |
| 15 | Closing | Communication Requirements | 5 |

### Duration Validation
```excel
=IF(SUM(D5:D19) > INDEX(Meeting_Durations, 5),
    "WARNING: Exceeds " & INDEX(Meeting_Durations, 5) & " min allocation",
    "Within " & INDEX(Meeting_Durations, 5) & " min allocation")
```

### Executive IBP Pre-Read Package Checklist

| Row | Document | Owner | Deadline | Status |
|-----|----------|-------|----------|--------|
| 1 | Executive Summary (1-pager) | IBP Process Owner | Meeting -3 days | (dropdown) |
| 2 | KPI Dashboard | Analytics Team | Meeting -3 days | (dropdown) |
| 3 | Demand-Supply Reconciliation | Planning Team | Meeting -2 days | (dropdown) |
| 4 | Financial Bridge | FP&A | Meeting -2 days | (dropdown) |
| 5 | Decision Request Forms | Various | Meeting -3 days | (dropdown) |
| 6 | Scenario Analysis Pack | IBP Leader | Meeting -2 days | (dropdown) |

---

## Sheet 8: Attendance Tracker

### Purpose
Track monthly attendance for each IBP meeting, calculate participation rates, and identify chronic absenteeism.

### Layout

| Row | Content |
|-----|---------|
| 1 | **IBP Meeting Attendance Tracker** (merged, Navy header) |
| 2 | `="Tracking Period: "&TEXT(IBP_Cycle_Start,"MMM YYYY")&" - Present"` |

### Column Structure (Rows 4+)

| Column | Header | Width |
|--------|--------|-------|
| A | Meeting Type | 20 |
| B | Participant Name | 22 |
| C | Role | 18 |
| D | Required/Optional | 16 |
| E | Jan | 10 |
| F | Feb | 10 |
| G | Mar | 10 |
| H | Apr | 10 |
| I | May | 10 |
| J | Jun | 10 |
| K | Jul | 10 |
| L | Aug | 10 |
| M | Sep | 10 |
| N | Oct | 10 |
| O | Nov | 10 |
| P | Dec | 10 |
| Q | Attendance % | 14 |
| R | Trend | 10 |
| S | Status | 12 |

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| A5:A100 | List | Product Review, Demand Review, Supply Review, Financial Review, Executive IBP |
| D5:D100 | List | Required, Optional |
| E5:P100 | List | Present, Absent, Delegate, N/A |

### Formulas

```excel
' Q5 - Attendance % (per participant per year)
=COUNTIF(E5:P5, "Present") / (COUNTA(E5:P5) - COUNTIF(E5:P5, "N/A"))

' Alternative formula handling delegates as partial attendance
=(COUNTIF(E5:P5, "Present") + 0.5 * COUNTIF(E5:P5, "Delegate")) / (COUNTA(E5:P5) - COUNTIF(E5:P5, "N/A"))

' S5 - Status
=IF(Q5 >= 0.9, "Good", IF(Q5 >= 0.8, "Monitor", "Action Needed"))

' Summary Metrics (below data table)
' Meeting-specific attendance rate
=AVERAGEIF($A$5:$A$100, "Executive IBP", $Q$5:$Q$100)

' Required-only attendance rate
=AVERAGEIFS($Q$5:$Q$100, $A$5:$A$100, "Executive IBP", $D$5:$D$100, "Required")

' Overall attendance across all meetings
=AVERAGE($Q$5:$Q$100)

' Monthly trend (last 3 months average vs prior 3 months)
=AVERAGE(N5:P5) - AVERAGE(K5:M5)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| E5:P100 | Text = "Present" | Fill `#D1FAE5`, Font `#065F46` |
| E5:P100 | Text = "Absent" | Fill `#FEE2E2`, Font `#991B1B` |
| E5:P100 | Text = "Delegate" | Fill `#DBEAFE`, Font `#1E40AF` |
| Q5:Q100 | Value >= 0.9 | Fill `#D1FAE5`, Font `#065F46` |
| Q5:Q100 | Value >= 0.8 AND < 0.9 | Fill `#FEF3C7`, Font `#92400E` |
| Q5:Q100 | Value < 0.8 | Fill `#FEE2E2`, Font `#991B1B` |
| S5:S100 | Text = "Good" | Fill `#10B981`, Font White |
| S5:S100 | Text = "Monitor" | Fill `#F59E0B`, Font White |
| S5:S100 | Text = "Action Needed" | Fill `#EF4444`, Font White |

### Summary Section (below data, row ~105)

| Metric | Formula |
|--------|---------|
| Overall Attendance Rate | `=AVERAGE(Q5:Q100)` |
| Product Review Rate | `=AVERAGEIF(A5:A100,"Product Review",Q5:Q100)` |
| Demand Review Rate | `=AVERAGEIF(A5:A100,"Demand Review",Q5:Q100)` |
| Supply Review Rate | `=AVERAGEIF(A5:A100,"Supply Review",Q5:Q100)` |
| Financial Review Rate | `=AVERAGEIF(A5:A100,"Financial Review",Q5:Q100)` |
| Executive IBP Rate | `=AVERAGEIF(A5:A100,"Executive IBP",Q5:Q100)` |
| Participants with 100% | `=COUNTIF(Q5:Q100,1)` |
| Participants below 80% | `=COUNTIF(Q5:Q100,"<0.8")` |

---

## Sheet 9: Meeting Effectiveness

### Purpose
Track and analyze meeting effectiveness across multiple dimensions on a monthly basis. Enables trend analysis and identifies improvement opportunities.

### Scoring Dimensions

| Dimension | Description | Scale |
|-----------|-------------|-------|
| Preparation Quality | Pre-reads distributed on time, quality of materials | 1-5 |
| Participation Level | Active engagement, right people in room | 1-5 |
| Decision Quality | Clear decisions made, well-informed | 1-5 |
| Action Follow-Through | Previous actions completed, accountability | 1-5 |
| Time Management | Meeting ran to time, focused agenda | 1-5 |
| Strategic Value | Discussion elevated beyond tactical | 1-5 |

### Column Structure

| Column | Header | Width |
|--------|--------|-------|
| A | Meeting Type | 20 |
| B | Month | 12 |
| C | Preparation Quality (1-5) | 16 |
| D | Participation Level (1-5) | 16 |
| E | Decision Quality (1-5) | 16 |
| F | Action Follow-Through (1-5) | 18 |
| G | Time Management (1-5) | 16 |
| H | Strategic Value (1-5) | 16 |
| I | Overall Score | 14 |
| J | 6-Month Avg | 14 |
| K | Trend | 10 |
| L | Improvement Notes | 35 |

### Formulas

```excel
' I5 - Overall Score (average of 6 dimensions)
=AVERAGE(C5:H5)

' J5 - 6-Month Rolling Average
=IFERROR(AVERAGE(OFFSET(I5, -5, 0, 6, 1)), AVERAGE(I$5:I5))

' Alternative using AVERAGEIFS for meeting-specific rolling average
=AVERAGEIFS($I$5:$I$500, $A$5:$A$500, $A5, $B$5:$B$500, ">="&EDATE($B5,-5), $B$5:$B$500, "<="&$B5)

' Trend indicator
=IF(I5 > J5, "Improving", IF(I5 < J5, "Declining", "Stable"))

' Meeting-level summary (in a summary section)
=AVERAGEIF($A$5:$A$500, "Executive IBP", $I$5:$I$500)
```

### Sparkline Specifications

| Cell | Type | Data Range | Formatting |
|------|------|------------|------------|
| K5 | Line Sparkline | I5 and 5 cells above (6-month window) | Color: `#0D9488`, High point: `#10B981`, Low point: `#EF4444` |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| C5:H500 | Value = 5 | Fill `#D1FAE5`, Font `#065F46` |
| C5:H500 | Value = 4 | Fill `#ECFDF5`, Font `#065F46` |
| C5:H500 | Value = 3 | Fill `#FEF3C7`, Font `#92400E` |
| C5:H500 | Value <= 2 | Fill `#FEE2E2`, Font `#991B1B` |
| I5:I500 | Value >= 4.0 | Fill `#10B981`, Font White, Bold |
| I5:I500 | Value >= 3.0 AND < 4.0 | Fill `#F59E0B`, Font White, Bold |
| I5:I500 | Value < 3.0 | Fill `#EF4444`, Font White, Bold |
| K5:K500 | Text = "Improving" | Font `#10B981`, Bold |
| K5:K500 | Text = "Declining" | Font `#EF4444`, Bold |
| K5:K500 | Text = "Stable" | Font `#64748B` |

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| A5:A500 | List | Product Review, Demand Review, Supply Review, Financial Review, Executive IBP |
| C5:H500 | Whole Number | 1 - 5 |

### Summary Dashboard (Rows below data)

| Meeting | Current Month | 6-Month Avg | Best Dimension | Weakest Dimension |
|---------|---------------|-------------|-----------------|-------------------|
| Formula: | `=AVERAGEIFS(...)` | `=AVERAGEIFS(...)` | `=INDEX(Dimensions, MATCH(MAX(...), ..., 0))` | `=INDEX(Dimensions, MATCH(MIN(...), ..., 0))` |

---

## Sheet 10: Annual Calendar View

### Purpose
Visual 12-month calendar showing all IBP meetings color-coded by type, providing a full-year view for planning and communication.

### Layout
- Rows 1-2: Title and year selector
- Row 3: Blank separator
- Rows 4-10: January (header + days of week + up to 6 week rows)
- Rows 11-17: February
- Continue pattern for all 12 months
- Two months per row group, 6 groups total (2 columns of months side-by-side)

### Calendar Cell Formulas

```excel
' Generate date for calendar cell
' Assuming month starts in row 5, column B for first day
=IF(WEEKDAY(DATE(Calendar_Year, 1, 1)) <= COLUMN() - 1,
    DATE(Calendar_Year, 1, 1) + (COLUMN() - 1 - WEEKDAY(DATE(Calendar_Year, 1, 1))),
    "")

' Check if date has a meeting scheduled
=IFERROR(INDEX(Meeting_Names, MATCH(Cell_Date, Meeting_Date_List, 0)), "")
```

### Color Coding for Meeting Types

| Meeting Type | Calendar Fill Color | Font Color |
|-------------|-------------------|------------|
| Product Review | `#7C3AED` (Purple) | White |
| Demand Review | `#2563EB` (Blue) | White |
| Supply Review | `#0D9488` (Teal) | White |
| Financial Review | `#059669` (Green) | White |
| Executive IBP | `#1B2A4A` (Navy) | White |
| No Meeting | No fill | `#64748B` |
| Today | `#F59E0B` border | N/A |
| Weekend | `#F1F5F9` fill | `#94A3B8` |

### Conditional Formatting (Calendar Cells)

```excel
' Highlight today
=Cell_Date = TODAY()  --> Bold border, #F59E0B

' Meeting type highlighting (applied per meeting type using COUNTIF against meeting schedule)
=COUNTIF(Product_Meeting_Dates, Cell_Date) > 0  --> Fill #7C3AED, Font White
=COUNTIF(Demand_Meeting_Dates, Cell_Date) > 0   --> Fill #2563EB, Font White
=COUNTIF(Supply_Meeting_Dates, Cell_Date) > 0   --> Fill #0D9488, Font White
=COUNTIF(Finance_Meeting_Dates, Cell_Date) > 0  --> Fill #059669, Font White
=COUNTIF(Executive_Meeting_Dates, Cell_Date) > 0 --> Fill #1B2A4A, Font White
```

### Legend (Bottom of calendar)

Color-coded legend strip with meeting type names and their assigned colors.

---

## Named Ranges for Cross-Workbook Integration

| Named Range | Sheet | Reference | Purpose |
|-------------|-------|-----------|---------|
| `IBP_Meeting_Dates` | Annual Calendar | Dynamic range of all meeting dates | Referenced by other workbooks for scheduling |
| `IBP_Attendance_Rate` | Attendance Tracker | Overall attendance rate cell | Linked to Performance Dashboard |
| `Meeting_Effectiveness_Score` | Meeting Effectiveness | Overall effectiveness score cell | Linked to Maturity Assessment |
| `Product_Review_Date` | Meeting Overview | Next Product Review date | Cross-workbook scheduling |
| `Demand_Review_Date` | Meeting Overview | Next Demand Review date | Cross-workbook scheduling |
| `Supply_Review_Date` | Meeting Overview | Next Supply Review date | Cross-workbook scheduling |
| `Financial_Review_Date` | Meeting Overview | Next Financial Review date | Cross-workbook scheduling |
| `Executive_IBP_Date` | Meeting Overview | Next Executive IBP date | Cross-workbook scheduling |
| `IBP_Cycle_Month` | Settings | Current cycle month | Cross-workbook reference |

---

## Integration Points with Other IBP Workbooks

| Source Workbook | Data Pulled | Target Sheet | Purpose |
|----------------|-------------|--------------|---------|
| IBP_Master_Integration.xlsx | KPI summary data | Meeting Overview | Pre-meeting data preparation |
| SKU_Rationalization_Analysis.xlsx | Rationalization decisions | Product Review Structure | Agenda item input |
| Statistical_Forecast_Template.xlsx | Forecast accuracy metrics | Demand Review Structure | Performance review data |
| Supply_Performance_Dashboard.xlsx | Capacity & service metrics | Supply Review Structure | Supply performance input |
| Financial_Performance.xlsx | P&L variances | Financial Review Structure | Budget reconciliation input |
| IBP_Maturity_Assessment.xlsx | Maturity scores | Meeting Effectiveness | Governance maturity tracking |

---

## VBA / Automation

### Macro 1: Auto-Generate Next Cycle Dates

```vba
Sub GenerateNextCycleDates()
    ' Calculates and populates meeting dates for the next IBP cycle
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Meeting Overview")

    Dim cycleStart As Date
    cycleStart = ThisWorkbook.Names("IBP_Cycle_Start").RefersToRange.Value

    Dim offsets As Variant
    offsets = Array(0, 7, 14, 16, 21) ' Week offsets for each meeting

    Dim meetingRow As Long
    For meetingRow = 10 To 14
        Dim rawDate As Date
        rawDate = cycleStart + offsets(meetingRow - 10)
        ' Adjust to next business day if falls on weekend
        If Weekday(rawDate) = 1 Then rawDate = rawDate + 1 ' Sunday -> Monday
        If Weekday(rawDate) = 7 Then rawDate = rawDate + 2 ' Saturday -> Monday
        ws.Cells(meetingRow, 8).Value = rawDate
    Next meetingRow

    MsgBox "Meeting dates generated for cycle starting " & Format(cycleStart, "MMMM YYYY"), vbInformation
End Sub
```

### Macro 2: Send Attendance Reminder

```vba
Sub SendAttendanceReminder()
    ' Generates email reminder for upcoming meeting
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Meeting Overview")

    Dim nextMeeting As String
    Dim nextDate As Date
    Dim minDays As Long: minDays = 999

    Dim i As Long
    For i = 10 To 14
        If ws.Cells(i, 9).Value < minDays And ws.Cells(i, 9).Value > 0 Then
            minDays = ws.Cells(i, 9).Value
            nextMeeting = ws.Cells(i, 1).Value
            nextDate = ws.Cells(i, 8).Value
        End If
    Next i

    If minDays <= 3 Then
        Dim olApp As Object
        Set olApp = CreateObject("Outlook.Application")
        Dim olMail As Object
        Set olMail = olApp.CreateItem(0)

        With olMail
            .Subject = "IBP Reminder: " & nextMeeting & " on " & Format(nextDate, "dddd, MMMM d")
            .Body = "This is a reminder that the " & nextMeeting & " is scheduled for " & _
                    Format(nextDate, "dddd, MMMM d, yyyy") & "." & vbCrLf & vbCrLf & _
                    "Please ensure all pre-read materials are reviewed before the meeting."
            .Display ' Use .Send for auto-send
        End With
    End If
End Sub
```

### Macro 3: Export Effectiveness Report

```vba
Sub ExportEffectivenessReport()
    ' Exports meeting effectiveness data to PDF
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Meeting Effectiveness")

    Dim filePath As String
    filePath = ThisWorkbook.Path & "\Reports\Meeting_Effectiveness_" & Format(Date, "YYYY_MM") & ".pdf"

    ws.ExportAsFixedFormat Type:=xlTypePDF, _
        Filename:=filePath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        OpenAfterPublish:=True

    MsgBox "Report exported to: " & filePath, vbInformation
End Sub
```

---

## Print Settings

| Sheet | Orientation | Scaling | Header | Footer |
|-------|-------------|---------|--------|--------|
| Settings | Portrait | Fit to 1 page | Company Name | Page X of Y, Date |
| Meeting Overview | Landscape | Fit to 1 page wide | "IBP Meeting Overview" | Confidential, Date |
| Review Structures (3-7) | Portrait | Fit to 1 page | Meeting Name | Page X of Y |
| Attendance Tracker | Landscape | Fit to 1 page wide | "Attendance Tracker" | Confidential |
| Meeting Effectiveness | Landscape | Fit to 1 page wide | "Effectiveness Tracker" | Date |
| Annual Calendar | Landscape | Fit to 1 page | Year | Company Name |

---

## Document Properties

| Property | Value |
|----------|-------|
| Title | IBP Meeting Cadence & Structure |
| Subject | IBP Governance - Meeting Management |
| Category | IBP Leader Toolkit |
| Version | 2.0 Enhanced |
| Classification | Internal Use |

---

*This specification document defines the complete structure for the Meeting Cadence Enhanced workbook. All formulas use standard Excel syntax and are compatible with Excel 2016 and later versions, as well as Microsoft 365.*
