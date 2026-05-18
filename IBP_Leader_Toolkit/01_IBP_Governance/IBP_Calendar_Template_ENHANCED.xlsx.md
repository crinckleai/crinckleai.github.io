# IBP Calendar Template - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Annual_Calendar
### Sheet 3: Monthly_Detail
### Sheet 4: Meeting_Schedule
### Sheet 5: Settings
### Sheet 6: Data_Validation

---

## SHEET 1: DASHBOARD

### Layout Design
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ A1:L1  HEADER BAR (Merged, Dark Teal #004D40)                              │
│        "IBP CALENDAR DASHBOARD"                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:D8  CURRENT MONTH WIDGET          │ F3:L8   UPCOMING MEETINGS           │
│ ┌───────────────────────────────┐    │ ┌────────────────────────────────┐  │
│ │ Current Month: =TEXT(TODAY(), │    │ │ Next 7 Days Meeting List       │  │
│ │ "MMMM YYYY")                  │    │ │ (Auto-populated from schedule) │  │
│ │ IBP Week: =FORMULA            │    │ │                                │  │
│ │ Current Phase: =FORMULA       │    │ └────────────────────────────────┘  │
│ └───────────────────────────────┘    │                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│ A10:L25  ANNUAL CALENDAR HEATMAP                                           │
│ (Conditional formatting shows meeting density by week)                      │
├─────────────────────────────────────────────────────────────────────────────┤
│ A27:F35  MEETING COMPLETION STATUS   │ H27:L35  KEY DATES ALERTS           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Key Formulas for Dashboard

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=TEXT(TODAY(),"MMMM YYYY")` | Display current month |
| C5 | `=WEEKNUM(TODAY())-WEEKNUM(DATE(YEAR(TODAY()),MONTH(TODAY()),1))+1` | IBP Week of Month |
| C6 | `=INDEX(Settings!$B$2:$B$5,MATCH(C5,Settings!$A$2:$A$5,0))` | Current IBP Phase |
| C7 | `=COUNTIF(Monthly_Detail!$G:$G,"Complete")/COUNTIF(Monthly_Detail!$G:$G,"<>")` | % Complete This Month |

### Conditional Formatting Rules
```
Rule 1: Current Week Highlight
- Range: A10:L25
- Formula: =WEEKNUM($A10)=WEEKNUM(TODAY())
- Format: Yellow fill (#FFF59D)

Rule 2: Overdue Items
- Range: A27:F35
- Formula: =AND($E27<TODAY(),$F27<>"Complete")
- Format: Red fill (#FFCDD2)

Rule 3: Upcoming (Next 3 Days)
- Range: H27:L35
- Formula: =AND($H27>=TODAY(),$H27<=TODAY()+3)
- Format: Orange fill (#FFE0B2)
```

---

## SHEET 2: Annual_Calendar

### Column Structure
| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Month | 12 | Text |
| B | Week_Number | 8 | Number |
| C | Week_Start_Date | 12 | Date (MM/DD/YYYY) |
| D | Week_End_Date | 12 | Date (MM/DD/YYYY) |
| E | IBP_Phase | 15 | Text (Dropdown) |
| F | Product_Review | 15 | Date/Blank |
| G | Demand_Review | 15 | Date/Blank |
| H | Supply_Review | 15 | Date/Blank |
| I | Financial_Review | 15 | Date/Blank |
| J | Executive_IBP | 15 | Date/Blank |
| K | Key_Milestones | 30 | Text |
| L | Status | 12 | Dropdown |
| M | Notes | 40 | Text |

### Auto-Population Formulas (Row 2 onwards)

| Cell | Formula | Purpose |
|------|---------|---------|
| A2 | `=TEXT(C2,"MMMM")` | Extract month name from date |
| B2 | `=WEEKNUM(C2)` | Calculate week number |
| C2 | `=DATE(Settings!$B$1,1,1)+((ROW()-2)*7)` | Auto-generate week start dates |
| D2 | `=C2+6` | Calculate week end date |
| E2 | `=INDEX(Settings!$B$8:$B$11,MOD(WEEKNUM(C2)-1,4)+1)` | Auto-assign IBP phase |
| L2 | `=IF(D2<TODAY(),"Complete",IF(C2<=TODAY(),"In Progress","Upcoming"))` | Auto-status |

### Named Ranges
```
Name: YearStart
Refers to: =Settings!$B$1

Name: IBPPhases
Refers to: =Settings!$B$8:$B$11

Name: CalendarData
Refers to: =Annual_Calendar!$A$2:$M$53

Name: MeetingDates
Refers to: =Annual_Calendar!$F$2:$J$53
```

### Data Validation
```
Column E (IBP_Phase):
- List: =IBPPhases
- Input Message: "Select the IBP phase for this week"

Column L (Status):
- List: "Upcoming,In Progress,Complete,Cancelled,Postponed"
- Error Alert: "Please select a valid status"
```

---

## SHEET 3: Monthly_Detail

### Column Structure
| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Date | 12 | Date |
| B | Day | 10 | Text |
| C | Week_of_Month | 8 | Number |
| D | IBP_Phase | 15 | Text |
| E | Meeting_Type | 20 | Dropdown |
| F | Meeting_Time | 12 | Time |
| G | Duration_Hours | 10 | Number |
| H | Location | 20 | Text |
| I | Required_Attendees | 40 | Text |
| J | Pre_Read_Due | 12 | Date |
| K | Materials_Owner | 20 | Text |
| L | Status | 12 | Dropdown |
| M | Completion_Notes | 40 | Text |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| B2 | `=TEXT(A2,"dddd")` | Day name |
| C2 | `=WEEKNUM(A2)-WEEKNUM(DATE(YEAR(A2),MONTH(A2),1))+1` | Week of month |
| D2 | `=INDEX(Settings!$B$8:$B$11,C2)` | IBP Phase lookup |
| J2 | `=A2-Settings!$B$15` | Pre-read due (X days before) |

### Conditional Formatting
```
Rule 1: Product Review Days
- Range: A:M
- Formula: =$E2="Product Review"
- Format: Light Purple fill (#E1BEE7)

Rule 2: Demand Review Days
- Range: A:M
- Formula: =$E2="Demand Review"
- Format: Light Blue fill (#BBDEFB)

Rule 3: Supply Review Days
- Range: A:M
- Formula: =$E2="Supply Review"
- Format: Light Orange fill (#FFE0B2)

Rule 4: Financial Review Days
- Range: A:M
- Formula: =$E2="Financial Review"
- Format: Light Green fill (#C8E6C9)

Rule 5: Executive IBP Days
- Range: A:M
- Formula: =$E2="Executive IBP"
- Format: Light Gold fill (#FFF9C4), Bold text
```

---

## SHEET 4: Meeting_Schedule

### Column Structure
| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Meeting_ID | 10 | Auto-number |
| B | Meeting_Type | 20 | Dropdown |
| C | Scheduled_Date | 12 | Date |
| D | Scheduled_Time | 10 | Time |
| E | Duration_Minutes | 12 | Number |
| F | Recurrence | 15 | Dropdown |
| G | Location | 25 | Text |
| H | Facilitator | 20 | Dropdown |
| I | Required_Attendees | 50 | Text |
| J | Optional_Attendees | 50 | Text |
| K | Pre_Read_Link | 40 | Hyperlink |
| L | Agenda_Template | 30 | Dropdown |
| M | Minutes_Link | 40 | Hyperlink |
| N | Action_Items_Count | 10 | Number |
| O | Status | 12 | Dropdown |
| P | Effectiveness_Score | 10 | Number (1-5) |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| A2 | `="MTG-"&TEXT(ROW()-1,"0000")` | Auto-generate Meeting ID |
| N2 | `=COUNTIF(Executive_IBP_Action_Tracker!$B:$B,A2)` | Count linked action items |
| E_Total | `=SUMIF($B:$B,"Executive IBP",$E:$E)/60` | Total Executive IBP hours |

### Summary Statistics (Rows at bottom)
```
Total Meetings This Month: =COUNTIFS($C:$C,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),$C:$C,"<"&DATE(YEAR(TODAY()),MONTH(TODAY())+1,1))

Average Effectiveness: =AVERAGEIF($O:$O,"Complete",$P:$P)

Meetings Completed on Time: =COUNTIFS($O:$O,"Complete",$C:$C,"<="&TODAY())
```

---

## SHEET 5: Settings

### Configuration Parameters
| Row | Parameter | Value | Description |
|-----|-----------|-------|-------------|
| 1 | Planning_Year | 2024 | Year for calendar generation |
| 2 | Fiscal_Year_Start | 1 | Month number (1=Jan) |
| 3 | Company_Name | [Enter] | Organization name |
| 4 | IBP_Leader | [Enter] | IBP Process Owner |
| 8 | Phase_Week1 | Product Review | Week 1 activity |
| 9 | Phase_Week2 | Demand Review | Week 2 activity |
| 10 | Phase_Week3 | Supply Review | Week 3 activity |
| 11 | Phase_Week4 | Executive IBP | Week 4 activity |
| 15 | Pre_Read_Lead_Days | 3 | Days before meeting |
| 16 | Default_Meeting_Duration | 90 | Minutes |
| 20 | Product_Review_Day | Thursday | Standard day |
| 21 | Demand_Review_Day | Thursday | Standard day |
| 22 | Supply_Review_Day | Thursday | Standard day |
| 23 | Executive_IBP_Day | Thursday | Standard day |

---

## SHEET 6: Data_Validation

### Dropdown Lists
```
Meeting_Types (A1:A10):
- Product Review
- Demand Review
- Supply Review
- Financial Review
- Executive IBP
- Pre-IBP Prep
- Post-IBP Follow-up
- Ad-hoc Planning
- Training Session
- Stakeholder Update

Status_Options (B1:B6):
- Scheduled
- In Progress
- Complete
- Cancelled
- Postponed
- Rescheduled

Recurrence_Options (C1:C5):
- Weekly
- Bi-weekly
- Monthly
- Quarterly
- One-time

Locations (D1:D10):
- Main Conference Room
- Executive Boardroom
- Virtual - Teams
- Virtual - Zoom
- Regional Office - [Location]
- Hybrid
- To Be Determined

Facilitators (E1:E20):
[Auto-populated from RACI Matrix - Accountable persons]
```

---

## INTEGRATION POINTS

### Links to Other Workbooks
```
1. RACI_Matrix.xlsx
   - Pull facilitator names: =RACI_Matrix.xlsx!Facilitators
   - Pull attendee lists by meeting type

2. Meeting_Cadence.xlsx
   - Sync meeting frequencies
   - Validate duration standards

3. Executive_Dashboard.xlsx
   - Push meeting completion status
   - Push effectiveness scores

4. Action_Item_Tracker.xlsx
   - Link meeting IDs to action items
   - Count open items per meeting
```

### Power Query Connections (for Excel 365)
```
// Query: Get All IBP Meetings
let
    Source = Excel.CurrentWorkbook(){[Name="MeetingSchedule"]}[Content],
    FilteredRows = Table.SelectRows(Source, each [Status] <> "Cancelled"),
    SortedRows = Table.Sort(FilteredRows,{{"Scheduled_Date", Order.Ascending}})
in
    SortedRows

// Query: Meeting Effectiveness Trend
let
    Source = Excel.CurrentWorkbook(){[Name="MeetingSchedule"]}[Content],
    Completed = Table.SelectRows(Source, each [Status] = "Complete"),
    Grouped = Table.Group(Completed, {"Meeting_Type"}, {{"Avg_Score", each List.Average([Effectiveness_Score]), type number}})
in
    Grouped
```

---

## CONDITIONAL FORMATTING SUMMARY

| Sheet | Range | Rule | Format |
|-------|-------|------|--------|
| Dashboard | C7 | Value >= 90% | Green (#C8E6C9) |
| Dashboard | C7 | Value 70-89% | Yellow (#FFF9C4) |
| Dashboard | C7 | Value < 70% | Red (#FFCDD2) |
| Annual_Calendar | F:J | Has date value | Meeting type color |
| Monthly_Detail | A:M | By meeting type | Color coded rows |
| Meeting_Schedule | O2:O100 | "Complete" | Green checkmark |
| Meeting_Schedule | P2:P100 | Score >= 4 | Green |
| Meeting_Schedule | P2:P100 | Score < 3 | Red |

---

## EXCEL FEATURES TO ENABLE

1. **Tables**: Convert all data ranges to Excel Tables for auto-expansion
2. **Slicers**: Add slicers for Meeting Type, Status, Month filtering
3. **Timeline**: Add timeline slicer for date-based filtering
4. **Sparklines**: Add meeting trend sparklines in Dashboard
5. **Data Bars**: Use data bars for completion percentages
6. **Icon Sets**: Use traffic light icons for status columns

---

## PRINT SETTINGS

### Dashboard Print Area
- Range: A1:L35
- Orientation: Landscape
- Fit to: 1 page wide x 1 page tall
- Header: "IBP Calendar - &[Date]"
- Footer: "Page &[Page] of &[Pages]"

### Monthly Calendar Print
- Range: A1:M35 (monthly view)
- Orientation: Landscape
- Repeat rows: 1 (header)

---

**Template Version:** Enhanced IBP Calendar 2.0
**Last Updated:** [Auto: =TODAY()]
**Compatible With:** Excel 2016+, Excel 365, Google Sheets (partial)
