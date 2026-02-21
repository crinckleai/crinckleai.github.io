# Process Health Metrics - Enhanced Excel Workbook

## Workbook Overview

**Purpose:** Comprehensive tracking of IBP process health across all five review steps with dimension-based scoring
**Version:** 2.0 Enhanced
**Template Type:** Performance Management - Process Health
**Integration:** Links to Balanced Scorecard, Meeting Cadence, and Master Integration workbooks

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy (#1B3A5F) |
| Accent Color 1 | Purple (#6B5B95) |
| Accent Color 2 | Indigo (#4B0082) |
| Success Color | Green (#28A745) |
| Warning Color | Amber (#FFC107) |
| Critical Color | Red (#DC3545) |
| Header Font | Calibri Bold 14pt |
| Body Font | Calibri Regular 11pt |
| Grid Lines | Light Gray (#E0E0E0) |

---

## Sheet 1: Health_Dashboard

### Purpose
Executive summary dashboard showing overall process health scores by IBP step and dimension

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 5 | # | Row numbering |
| B | 25 | Process Step | IBP review step name |
| C | 12 | Attendance | Attendance score (0-100) |
| D | 12 | Preparation | Preparation quality (0-100) |
| E | 12 | Quality | Meeting quality (0-100) |
| F | 12 | Timeliness | On-time delivery (0-100) |
| G | 12 | Outputs | Output quality (0-100) |
| H | 15 | Overall Score | Weighted dimension average |
| I | 12 | Prior Month | Previous month overall |
| J | 10 | MoM Change | Month-over-month variance |
| K | 12 | Target | Target score |
| L | 10 | Gap | Variance to target |
| M | 12 | Status | Health status indicator |
| N | 15 | Trend (12M) | Sparkline trend |
| O | 20 | Owner | Process step owner |
| P | 25 | Top Issue | Primary issue to address |

### Data Structure (Rows 5-12)

```
Row 5: Product Review | Att% | Prep% | Qual% | Time% | Out% | Overall | Prior | Change | Target | Gap | Status
Row 6: Demand Review | Att% | Prep% | Qual% | Time% | Out% | Overall | Prior | Change | Target | Gap | Status
Row 7: Supply Review | Att% | Prep% | Qual% | Time% | Out% | Overall | Prior | Change | Target | Gap | Status
Row 8: Financial Review | Att% | Prep% | Qual% | Time% | Out% | Overall | Prior | Change | Target | Gap | Status
Row 9: Executive IBP Review | Att% | Prep% | Qual% | Time% | Out% | Overall | Prior | Change | Target | Gap | Status
Row 10: BLANK
Row 11: OVERALL PROCESS HEALTH | Avg | Avg | Avg | Avg | Avg | Weighted | Prior | Change | Target | Gap | Status
```

### Dimension Weights

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Attendance | 20% | Critical participants present |
| Preparation | 25% | Pre-meeting preparation quality |
| Quality | 25% | Meeting discussion quality |
| Timeliness | 15% | On-time start/finish/deliverables |
| Outputs | 15% | Quality of decisions/actions |

### Key Formulas

```excel
' Overall Health Score per Step (Cell H5)
=SUMPRODUCT($C$3:$G$3,C5:G5)/SUM($C$3:$G$3)

' Where Row 3 contains weights: 0.20, 0.25, 0.25, 0.15, 0.15

' Overall Process Health (Cell H11)
=AVERAGE(H5:H9)

' MoM Change (Cell J5)
=H5-I5

' Gap to Target (Cell L5)
=H5-K5

' Status Indicator (Cell M5)
=IF(L5>=0,"Healthy",IF(L5>=-10,"Monitor","At Risk"))

' Dimension Average across all steps (Cell C11)
=AVERAGE(C5:C9)

' Weakest Dimension Identification
=INDEX({"Attendance","Preparation","Quality","Timeliness","Outputs"},
       MATCH(MIN(C11:G11),C11:G11,0))

' Strongest Dimension Identification
=INDEX({"Attendance","Preparation","Quality","Timeliness","Outputs"},
       MATCH(MAX(C11:G11),C11:G11,0))

' Process Health Trend Direction
=IF(SLOPE(Trend_Data!B5:M5,{1,2,3,4,5,6,7,8,9,10,11,12})>0,"Improving","Declining")

' Health Maturity Level
=IF(H11>=90,"Advanced",IF(H11>=75,"Integrated",IF(H11>=60,"Developing","Initial")))

' Critical Process Flag
=IF(MIN(H5:H9)<60,INDEX(B5:B9,MATCH(MIN(H5:H9),H5:H9,0)),"None")
```

### Conditional Formatting Rules

```
Rule 1: Overall Score (Column H)
- >= 90: Dark Green fill (#006100), White text - "Advanced"
- 75-89: Green fill (#28A745) - "Integrated"
- 60-74: Yellow fill (#FFC107) - "Developing"
- < 60: Red fill (#DC3545), White text - "Initial"

Rule 2: Status Column (Column M)
- "Healthy": Green fill (#28A745), White text
- "Monitor": Amber fill (#FFC107), Black text
- "At Risk": Red fill (#DC3545), White text

Rule 3: Gap Column (Column L)
- >= 0: Green font, up arrow
- -10 to 0: Yellow font, side arrow
- < -10: Red font, down arrow

Rule 4: Dimension Scores (Columns C-G)
- Data bars: Gradient Purple to Navy, min 0, max 100
- Icon set: 3 traffic lights based on 60/75 thresholds

Rule 5: MoM Change (Column J)
- > 5: Bold green with up arrow
- -5 to 5: Normal black
- < -5: Bold red with down arrow
```

---

## Sheet 2: Product_Review_Health

### Purpose
Detailed health metrics for Product Management Review step

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 5 | # | Item number |
| B | 30 | Health Metric | Metric description |
| C | 15 | Dimension | Category (Attendance/Prep/Quality/Time/Output) |
| D | 10 | Weight | Metric weight within dimension |
| E | 12 | Target | Target score |
| F | 12 | Actual | Current score |
| G | 12 | Score | Normalized score |
| H | 12 | Prior Month | Previous period |
| I | 10 | Variance | MoM change |
| J | 15 | Data Source | Where metric comes from |
| K | 12 | Status | Health status |
| L | 30 | Issue/Action | Issue description or action needed |

### Detailed Metrics (Rows 4-25)

```
ATTENDANCE DIMENSION
Row 4: Executive Sponsor Present | Attendance | 30% | Y/N | Y/N | Score
Row 5: Product Management VP Present | Attendance | 25% | Y/N | Y/N | Score
Row 6: Engineering Representative | Attendance | 15% | Y/N | Y/N | Score
Row 7: Marketing Representative | Attendance | 15% | Y/N | Y/N | Score
Row 8: Finance Representative | Attendance | 15% | Y/N | Y/N | Score

PREPARATION DIMENSION
Row 10: Portfolio Dashboard Updated | Preparation | 25% | 100% | Actual% | Score
Row 11: NPI Status Current | Preparation | 25% | 100% | Actual% | Score
Row 12: Product P&L Available | Preparation | 20% | 100% | Actual% | Score
Row 13: Market Intelligence Prepared | Preparation | 15% | 100% | Actual% | Score
Row 14: Pre-Read Distributed On-Time | Preparation | 15% | 48 hrs | Actual | Score

QUALITY DIMENSION
Row 16: Strategic Decisions Made | Quality | 30% | Target # | Actual # | Score
Row 17: Issues Resolved vs Raised | Quality | 25% | 80% | Actual% | Score
Row 18: Cross-Functional Engagement | Quality | 25% | Rating 1-5 | Rating | Score
Row 19: Data-Driven Discussion | Quality | 20% | Rating 1-5 | Rating | Score

TIMELINESS DIMENSION
Row 21: Meeting Started On-Time | Timeliness | 40% | Y/N | Y/N | Score
Row 22: Meeting Ended On-Time | Timeliness | 30% | Y/N | Y/N | Score
Row 23: Agenda Items Completed | Timeliness | 30% | 100% | Actual% | Score

OUTPUTS DIMENSION
Row 25: Portfolio Recommendations Published | Outputs | 35% | 24 hrs | Actual | Score
Row 26: Go/No-Go Decisions Documented | Outputs | 35% | 100% | Actual% | Score
Row 27: Action Items Assigned | Outputs | 30% | 100% | Actual% | Score
```

### Key Formulas

```excel
' Attendance Score (Binary Y/N)
=IF(F4="Y",100,0)

' Preparation Score (Percentage)
=IF(F10>=E10,100,F10/E10*100)

' Pre-Read Score (Hours - lower is better)
=IF(F14<=E14,100,MAX(0,100-(F14-E14)/E14*100))

' Quality Rating Score (1-5 scale)
=F18/5*100

' Issues Resolution Score
=IF(F17>=E17,100,F17/E17*100)

' Dimension Score (weighted)
=SUMPRODUCT(IF(C4:C27="Attendance",D4:D27*G4:G27,0))/SUMIF(C4:C27,"Attendance",D4:D27)

' Overall Product Review Health
=Attendance_Score*0.2+Preparation_Score*0.25+Quality_Score*0.25+Timeliness_Score*0.15+Outputs_Score*0.15

' MoM Variance (Cell I4)
=F4-H4

' Status Determination
=IF(G4>=90,"Excellent",IF(G4>=75,"Good",IF(G4>=60,"Needs Improvement","Critical")))

' Critical Item Flag
=IF(G4<60,"CRITICAL ACTION REQUIRED","")

' Dimension Health Index
=AVERAGEIF(C:C,"Attendance",G:G)
```

---

## Sheet 3: Demand_Review_Health

### Purpose
Detailed health metrics for Demand Review step

### Detailed Metrics (Rows 4-27)

```
ATTENDANCE DIMENSION
Row 4: Sales VP/Director Present | Attendance | 30% | Y/N | Y/N | Score
Row 5: Marketing Leadership Present | Attendance | 25% | Y/N | Y/N | Score
Row 6: Demand Planning Lead | Attendance | 20% | Y/N | Y/N | Score
Row 7: Finance Representative | Attendance | 15% | Y/N | Y/N | Score
Row 8: Key Account Managers (coverage) | Attendance | 10% | 80% | Actual% | Score

PREPARATION DIMENSION
Row 10: Statistical Forecast Generated | Preparation | 25% | 100% | Actual% | Score
Row 11: Sales Input Submitted | Preparation | 25% | 100% | Actual% | Score
Row 12: Marketing Events Updated | Preparation | 20% | 100% | Actual% | Score
Row 13: Assumptions Documented | Preparation | 15% | 100% | Actual% | Score
Row 14: Historical Analysis Complete | Preparation | 15% | 100% | Actual% | Score

QUALITY DIMENSION
Row 16: Consensus Achieved | Quality | 30% | Y/N | Y/N | Score
Row 17: Bias Addressed | Quality | 25% | Y/N | Y/N | Score
Row 18: Risk/Opportunity Quantified | Quality | 25% | 100% | Actual% | Score
Row 19: Segmentation Applied | Quality | 20% | Y/N | Y/N | Score

TIMELINESS DIMENSION
Row 21: Sales Input Deadline Met | Timeliness | 35% | Y/N | Y/N | Score
Row 22: Meeting Started On-Time | Timeliness | 25% | Y/N | Y/N | Score
Row 23: Consensus Published On-Time | Timeliness | 40% | 24 hrs | Actual | Score

OUTPUTS DIMENSION
Row 25: Consensus Demand Plan Published | Outputs | 40% | 100% | Actual% | Score
Row 26: Assumption Log Updated | Outputs | 30% | 100% | Actual% | Score
Row 27: Escalations Documented | Outputs | 30% | 100% | Actual% | Score
```

---

## Sheet 4: Supply_Review_Health

### Purpose
Detailed health metrics for Supply Review step

### Detailed Metrics (Rows 4-27)

```
ATTENDANCE DIMENSION
Row 4: Supply Chain VP Present | Attendance | 30% | Y/N | Y/N | Score
Row 5: Operations Director Present | Attendance | 25% | Y/N | Y/N | Score
Row 6: Procurement Representative | Attendance | 15% | Y/N | Y/N | Score
Row 7: Logistics Representative | Attendance | 15% | Y/N | Y/N | Score
Row 8: Quality Representative | Attendance | 15% | Y/N | Y/N | Score

PREPARATION DIMENSION
Row 10: Capacity Analysis Complete | Preparation | 30% | 100% | Actual% | Score
Row 11: Inventory Projections Updated | Preparation | 25% | 100% | Actual% | Score
Row 12: Supplier Constraints Identified | Preparation | 20% | 100% | Actual% | Score
Row 13: Scenario Options Prepared | Preparation | 15% | 2+ | Actual # | Score
Row 14: Cost Implications Calculated | Preparation | 10% | 100% | Actual% | Score

QUALITY DIMENSION
Row 16: Supply-Demand Balance Achieved | Quality | 35% | Y/N | Y/N | Score
Row 17: Constraints Resolved/Escalated | Quality | 25% | 100% | Actual% | Score
Row 18: Network Optimization Discussed | Quality | 20% | Y/N | Y/N | Score
Row 19: Risk Mitigation Identified | Quality | 20% | Y/N | Y/N | Score

TIMELINESS DIMENSION
Row 21: Demand Input Received On-Time | Timeliness | 35% | Y/N | Y/N | Score
Row 22: Meeting Within Time Box | Timeliness | 30% | Y/N | Y/N | Score
Row 23: Supply Response Published | Timeliness | 35% | 24 hrs | Actual | Score

OUTPUTS DIMENSION
Row 25: Constrained Supply Plan Published | Outputs | 40% | 100% | Actual% | Score
Row 26: Action Items with Owners | Outputs | 30% | 100% | Actual% | Score
Row 27: Escalation Items Documented | Outputs | 30% | 100% | Actual% | Score
```

---

## Sheet 5: Financial_Review_Health

### Purpose
Detailed health metrics for Financial/Integrated Reconciliation Review step

### Detailed Metrics (Rows 4-27)

```
ATTENDANCE DIMENSION
Row 4: CFO/VP Finance Present | Attendance | 35% | Y/N | Y/N | Score
Row 5: FP&A Director Present | Attendance | 25% | Y/N | Y/N | Score
Row 6: Demand Planning Lead | Attendance | 15% | Y/N | Y/N | Score
Row 7: Supply Chain Finance | Attendance | 15% | Y/N | Y/N | Score
Row 8: Controller/Accounting | Attendance | 10% | Y/N | Y/N | Score

PREPARATION DIMENSION
Row 10: P&L Projection Updated | Preparation | 30% | 100% | Actual% | Score
Row 11: Volume-to-Value Bridge | Preparation | 25% | 100% | Actual% | Score
Row 12: Working Capital Analysis | Preparation | 20% | 100% | Actual% | Score
Row 13: Gap Analysis Complete | Preparation | 15% | 100% | Actual% | Score
Row 14: Scenario Financial Impact | Preparation | 10% | 100% | Actual% | Score

QUALITY DIMENSION
Row 16: Budget Gap Quantified | Quality | 30% | Y/N | Y/N | Score
Row 17: Gap Closure Actions Identified | Quality | 25% | 100% | Actual% | Score
Row 18: Financial Risks Assessed | Quality | 25% | Y/N | Y/N | Score
Row 19: One-Number Alignment | Quality | 20% | Y/N | Y/N | Score

TIMELINESS DIMENSION
Row 21: Operational Plans Received | Timeliness | 35% | Y/N | Y/N | Score
Row 22: Meeting Duration Managed | Timeliness | 30% | Y/N | Y/N | Score
Row 23: Financial Pack Published | Timeliness | 35% | 24 hrs | Actual | Score

OUTPUTS DIMENSION
Row 25: Integrated Financial Outlook | Outputs | 40% | 100% | Actual% | Score
Row 26: Gap Closure Commitments | Outputs | 35% | 100% | Actual% | Score
Row 27: Executive Pack Contribution | Outputs | 25% | 100% | Actual% | Score
```

---

## Sheet 6: Executive_IBP_Health

### Purpose
Detailed health metrics for Executive IBP/Management Business Review step

### Detailed Metrics (Rows 4-30)

```
ATTENDANCE DIMENSION
Row 4: CEO/President Present | Attendance | 30% | Y/N | Y/N | Score
Row 5: CFO Present | Attendance | 20% | Y/N | Y/N | Score
Row 6: CSO/Sales Leader Present | Attendance | 15% | Y/N | Y/N | Score
Row 7: COO/Supply Chain Leader | Attendance | 15% | Y/N | Y/N | Score
Row 8: CMO/Marketing Leader | Attendance | 10% | Y/N | Y/N | Score
Row 9: HR/Other Function Heads | Attendance | 10% | 80% | Actual% | Score

PREPARATION DIMENSION
Row 11: Executive Dashboard Current | Preparation | 25% | 100% | Actual% | Score
Row 12: Scenario Options Prepared | Preparation | 20% | 3+ | Actual # | Score
Row 13: Decision Recommendations Ready | Preparation | 20% | 100% | Actual% | Score
Row 14: Pre-Read Distributed (48hr) | Preparation | 20% | Y/N | Y/N | Score
Row 15: Risk Register Updated | Preparation | 15% | 100% | Actual% | Score

QUALITY DIMENSION
Row 17: Strategic Decisions Made | Quality | 30% | Target # | Actual # | Score
Row 18: Resource Allocation Decisions | Quality | 25% | Y/N | Y/N | Score
Row 19: Discussion vs. Presentation Ratio | Quality | 25% | 60%+ | Actual% | Score
Row 20: Future-Focused (>50% time) | Quality | 20% | Y/N | Y/N | Score

TIMELINESS DIMENSION
Row 22: Meeting Started On-Time | Timeliness | 30% | Y/N | Y/N | Score
Row 23: Meeting Ended On-Time | Timeliness | 30% | Y/N | Y/N | Score
Row 24: All Agenda Items Covered | Timeliness | 40% | 100% | Actual% | Score

OUTPUTS DIMENSION
Row 26: Decisions Documented | Outputs | 30% | 100% | Actual% | Score
Row 27: Actions Assigned with Deadlines | Outputs | 25% | 100% | Actual% | Score
Row 28: Communication Plan Defined | Outputs | 25% | Y/N | Y/N | Score
Row 29: Plan Sign-Off Achieved | Outputs | 20% | Y/N | Y/N | Score
```

---

## Sheet 7: Cross_Process_Analysis

### Purpose
Comparative analysis across all process steps by dimension

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 15 | Dimension | Health dimension |
| B | 15 | Product Review | Score |
| C | 15 | Demand Review | Score |
| D | 15 | Supply Review | Score |
| E | 15 | Financial Review | Score |
| F | 15 | Executive IBP | Score |
| G | 12 | Average | Dimension average |
| H | 12 | Min | Lowest score |
| I | 12 | Max | Highest score |
| J | 12 | Range | Variability |
| K | 15 | Weakest Step | Step needing attention |
| L | 20 | Recommendation | Improvement action |

### Data Structure (Rows 4-10)

```
Row 4: Attendance | PR Score | DR Score | SR Score | FR Score | EIBP Score | Avg | Min | Max | Range | Weakest | Action
Row 5: Preparation | PR Score | DR Score | SR Score | FR Score | EIBP Score | Avg | Min | Max | Range | Weakest | Action
Row 6: Quality | PR Score | DR Score | SR Score | FR Score | EIBP Score | Avg | Min | Max | Range | Weakest | Action
Row 7: Timeliness | PR Score | DR Score | SR Score | FR Score | EIBP Score | Avg | Min | Max | Range | Weakest | Action
Row 8: Outputs | PR Score | DR Score | SR Score | FR Score | EIBP Score | Avg | Min | Max | Range | Weakest | Action
Row 9: BLANK
Row 10: Overall | PR Total | DR Total | SR Total | FR Total | EIBP Total | Avg | Min | Max | Range | Weakest | Action
```

### Key Formulas

```excel
' Dimension Average (Cell G4)
=AVERAGE(B4:F4)

' Minimum Score (Cell H4)
=MIN(B4:F4)

' Maximum Score (Cell I4)
=MAX(B4:F4)

' Range/Variability (Cell J4)
=I4-H4

' Weakest Step Identification (Cell K4)
=INDEX({"Product","Demand","Supply","Financial","Executive"},MATCH(MIN(B4:F4),B4:F4,0))

' Process Consistency Score
=100-STDEV(B4:F4)

' Dimension Health Ranking
=RANK(G4,G4:G8,0)

' Cross-Process Correlation
=CORREL(B4:B8,C4:C8)

' Improvement Priority Score
=(100-G4)*COUNT(IF(B4:F4<70,1))

' Best Practice Benchmark
=MAX(B4:F4)

' Gap to Best Practice
=MAX(B4:F4)-MIN(B4:F4)
```

### Conditional Formatting

```
Rule 1: Process Scores (Columns B-F)
- Heatmap: Red (low) to Yellow (mid) to Green (high)
- Scale: Min 0, Midpoint 70, Max 100

Rule 2: Range Column (Column J)
- > 20: Red fill - high variability concern
- 10-20: Yellow fill - moderate variability
- < 10: Green fill - consistent performance

Rule 3: Weakest Step (Column K)
- Bold red text for visibility
```

---

## Sheet 8: Trend_12_Month

### Purpose
12-month trend analysis for all process steps with SLOPE-based direction indicators

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 20 | Process Step | Step name |
| B | 8 | Jan | Monthly score |
| C | 8 | Feb | Monthly score |
| D | 8 | Mar | Monthly score |
| E | 8 | Apr | Monthly score |
| F | 8 | May | Monthly score |
| G | 8 | Jun | Monthly score |
| H | 8 | Jul | Monthly score |
| I | 8 | Aug | Monthly score |
| J | 8 | Sep | Monthly score |
| K | 8 | Oct | Monthly score |
| L | 8 | Nov | Monthly score |
| M | 8 | Dec | Monthly score |
| N | 10 | YTD Avg | Average |
| O | 10 | SLOPE | Trend coefficient |
| P | 12 | Direction | Trend direction |
| Q | 12 | Momentum | Trend strength |
| R | 15 | Projection | Next month forecast |

### Key Formulas

```excel
' YTD Average (Cell N4)
=AVERAGE(B4:M4)

' SLOPE Calculation (Cell O4)
=SLOPE(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})

' Direction Determination (Cell P4)
=IF(O4>1,"Strong Improving",
 IF(O4>0.3,"Improving",
 IF(O4>-0.3,"Stable",
 IF(O4>-1,"Declining","Strong Declining"))))

' Momentum Classification (Cell Q4)
=IF(ABS(O4)>1,"Strong",IF(ABS(O4)>0.5,"Moderate","Weak"))

' Next Month Projection (Cell R4)
=FORECAST(13,B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})

' R-Squared for Trend Reliability
=RSQ(B4:M4,{1,2,3,4,5,6,7,8,9,10,11,12})

' 3-Month Moving Average
=AVERAGE(K4:M4)

' Volatility Index
=STDEV(B4:M4)/AVERAGE(B4:M4)*100

' Best Month
=MAX(B4:M4)

' Worst Month
=MIN(B4:M4)

' Improvement from Start
=M4-B4

' Consecutive Improvement Months
=SUMPRODUCT(--(C4:M4>B4:L4))
```

### Conditional Formatting

```
Rule 1: Direction Column (P)
- "Strong Improving": Dark green fill
- "Improving": Light green fill
- "Stable": Gray fill
- "Declining": Light red fill
- "Strong Declining": Dark red fill

Rule 2: Monthly Scores (B-M)
- Sparkline in additional column
- Data bars showing relative performance

Rule 3: SLOPE Values (O)
- Icon set: 5 arrows based on value ranges
```

---

## Sheet 9: Issue_Log

### Purpose
Log of process health issues with tracking for resolution

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 8 | Issue ID | Unique identifier |
| B | 12 | Date Raised | Issue identification date |
| C | 20 | Process Step | Affected IBP step |
| D | 15 | Dimension | Health dimension affected |
| E | 40 | Issue Description | Detailed description |
| F | 15 | Severity | Critical/High/Medium/Low |
| G | 15 | Impact Score | Score impact estimate |
| H | 20 | Root Cause | Root cause analysis |
| I | 20 | Owner | Responsible person |
| J | 30 | Corrective Action | Planned action |
| K | 12 | Target Date | Resolution target |
| L | 12 | Actual Date | Actual resolution |
| M | 12 | Status | Open/In Progress/Closed |
| N | 30 | Notes | Additional comments |

### Key Formulas

```excel
' Issue ID Generation (Cell A4)
=TEXT(ROW()-3,"ISS-0000")

' Days Open (calculated column)
=IF(M4="Closed",L4-B4,TODAY()-B4)

' Overdue Flag
=IF(AND(M4<>"Closed",K4<TODAY()),"OVERDUE","")

' Severity Score
=SWITCH(F4,"Critical",4,"High",3,"Medium",2,"Low",1)

' Priority Index
=Severity_Score*Impact_Score

' Open Issue Count by Process
=COUNTIFS(C:C,"Product Review",M:M,"<>Closed")

' Open Issue Count by Dimension
=COUNTIFS(D:D,"Attendance",M:M,"<>Closed")

' Average Resolution Time
=AVERAGEIF(M:M,"Closed",Days_Open_Range)

' Issue Trend (monthly count)
=COUNTIFS(B:B,">="&EOMONTH(TODAY(),-1)+1,B:B,"<="&EOMONTH(TODAY(),0))

' Closure Rate
=COUNTIF(M:M,"Closed")/COUNTA(M:M)
```

### Conditional Formatting

```
Rule 1: Severity Column (F)
- "Critical": Red fill, bold white text
- "High": Orange fill
- "Medium": Yellow fill
- "Low": Light blue fill

Rule 2: Status Column (M)
- "Open": Red text
- "In Progress": Amber text
- "Closed": Green text

Rule 3: Overdue Items
- Entire row: Light red fill when overdue
```

---

## Sheet 10: Improvement_Actions

### Purpose
Track improvement initiatives to enhance process health

### Column Layout

| Column | Width | Header | Purpose |
|--------|-------|--------|---------|
| A | 10 | Action ID | Unique identifier |
| B | 15 | Process Step | Target process |
| C | 15 | Dimension | Target dimension |
| D | 35 | Improvement Initiative | Description |
| E | 12 | Current Score | Baseline |
| F | 12 | Target Score | Goal |
| G | 12 | Expected Lift | Improvement |
| H | 20 | Owner | Responsible person |
| I | 12 | Start Date | Initiative start |
| J | 12 | Target Date | Completion target |
| K | 12 | Actual Date | Actual completion |
| L | 12 | Status | Not Started/Active/Complete |
| M | 12 | Progress % | Completion percentage |
| N | 12 | Actual Lift | Measured improvement |
| O | 25 | Lessons Learned | Insights |

### Key Formulas

```excel
' Action ID Generation
=TEXT(ROW()-3,"IMP-0000")

' Expected Lift (Cell G4)
=F4-E4

' Actual Lift (Cell N4)
=New_Score-E4

' Lift Achievement %
=IF(G4>0,N4/G4*100,0)

' Days to Complete
=IF(L4="Complete",K4-I4,TODAY()-I4)

' On-Track Flag
=IF(AND(L4<>"Complete",J4<TODAY(),M4<80),"AT RISK","On Track")

' Initiative Count by Process
=COUNTIF(B:B,"Product Review")

' Active Initiative Count
=COUNTIF(L:L,"Active")

' Average Completion Time
=AVERAGEIF(L:L,"Complete",Days_Range)

' Total Expected Impact
=SUMIF(L:L,"Active",G:G)

' Realized Impact
=SUMIF(L:L,"Complete",N:N)

' Success Rate
=COUNTIFS(L:L,"Complete",N:N,">="&Expected_Range)/COUNTIF(L:L,"Complete")
```

---

## Sheet 11: Config

### Purpose
Configuration settings and reference data

### Named Ranges

```excel
' Dimension Weights
Attendance_Weight = Config!$B$5      ' 0.20
Preparation_Weight = Config!$B$6    ' 0.25
Quality_Weight = Config!$B$7        ' 0.25
Timeliness_Weight = Config!$B$8     ' 0.15
Outputs_Weight = Config!$B$9        ' 0.15

' Health Thresholds
Healthy_Threshold = Config!$B$13     ' 80
Monitor_Threshold = Config!$B$14     ' 70
AtRisk_Threshold = Config!$B$15      ' 60

' Target Scores
Product_Target = Config!$B$19        ' 85
Demand_Target = Config!$B$20         ' 85
Supply_Target = Config!$B$21         ' 85
Financial_Target = Config!$B$22      ' 85
Executive_Target = Config!$B$23      ' 90

' Integration Links
Master_Workbook_Path = Config!$B$27
Balanced_Scorecard_Path = Config!$B$28
Meeting_Cadence_Path = Config!$B$29

' Reporting Period
Current_Period = Config!$B$33
Prior_Period = Config!$B$34

' Color Codes
Navy_Color = Config!$B$38           ' #1B3A5F
Purple_Color = Config!$B$39        ' #6B5B95
```

---

## VBA Automation Code

### Module: ProcessHealthCalculations

```vba
Option Explicit

' Dimension weight constants
Const ATTENDANCE_WEIGHT As Double = 0.2
Const PREPARATION_WEIGHT As Double = 0.25
Const QUALITY_WEIGHT As Double = 0.25
Const TIMELINESS_WEIGHT As Double = 0.15
Const OUTPUTS_WEIGHT As Double = 0.15

Sub CalculateAllProcessHealth()
    '''
    ' Calculate health scores for all process steps
    '''

    Dim processes As Variant
    Dim i As Integer

    Application.ScreenUpdating = False

    processes = Array("Product_Review_Health", "Demand_Review_Health", _
                     "Supply_Review_Health", "Financial_Review_Health", _
                     "Executive_IBP_Health")

    For i = 0 To UBound(processes)
        Call CalculateProcessStepHealth(processes(i))
    Next i

    ' Update dashboard
    Call UpdateHealthDashboard

    Application.ScreenUpdating = True

    MsgBox "All process health scores calculated!", vbInformation

End Sub

Sub CalculateProcessStepHealth(strSheetName As String)
    '''
    ' Calculate health score for a single process step
    '''

    Dim ws As Worksheet
    Dim dblAttendance As Double, dblPreparation As Double
    Dim dblQuality As Double, dblTimeliness As Double
    Dim dblOutputs As Double, dblOverall As Double

    Set ws = ThisWorkbook.Sheets(strSheetName)

    ' Calculate dimension scores using SUMPRODUCT logic
    dblAttendance = CalculateDimensionScore(ws, "Attendance")
    dblPreparation = CalculateDimensionScore(ws, "Preparation")
    dblQuality = CalculateDimensionScore(ws, "Quality")
    dblTimeliness = CalculateDimensionScore(ws, "Timeliness")
    dblOutputs = CalculateDimensionScore(ws, "Outputs")

    ' Calculate weighted overall
    dblOverall = (dblAttendance * ATTENDANCE_WEIGHT) + _
                 (dblPreparation * PREPARATION_WEIGHT) + _
                 (dblQuality * QUALITY_WEIGHT) + _
                 (dblTimeliness * TIMELINESS_WEIGHT) + _
                 (dblOutputs * OUTPUTS_WEIGHT)

    ' Store results (in summary section of each sheet)
    ws.Range("G30").Value = dblAttendance
    ws.Range("G31").Value = dblPreparation
    ws.Range("G32").Value = dblQuality
    ws.Range("G33").Value = dblTimeliness
    ws.Range("G34").Value = dblOutputs
    ws.Range("G35").Value = dblOverall

End Sub

Function CalculateDimensionScore(ws As Worksheet, strDimension As String) As Double
    '''
    ' Calculate weighted score for a specific dimension
    '''

    Dim lastRow As Long
    Dim sumWeight As Double, weightedSum As Double
    Dim i As Long

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    sumWeight = 0
    weightedSum = 0

    For i = 4 To lastRow
        If ws.Cells(i, "C").Value = strDimension Then
            If IsNumeric(ws.Cells(i, "D").Value) And IsNumeric(ws.Cells(i, "G").Value) Then
                sumWeight = sumWeight + ws.Cells(i, "D").Value
                weightedSum = weightedSum + (ws.Cells(i, "D").Value * ws.Cells(i, "G").Value)
            End If
        End If
    Next i

    If sumWeight > 0 Then
        CalculateDimensionScore = weightedSum / sumWeight
    Else
        CalculateDimensionScore = 0
    End If

End Function

Sub UpdateHealthDashboard()
    '''
    ' Update the main Health Dashboard with calculated scores
    '''

    Dim wsDash As Worksheet
    Dim wsProduct As Worksheet, wsDemand As Worksheet
    Dim wsSupply As Worksheet, wsFinance As Worksheet
    Dim wsExec As Worksheet

    Set wsDash = ThisWorkbook.Sheets("Health_Dashboard")

    ' Product Review (Row 5)
    Set wsProduct = ThisWorkbook.Sheets("Product_Review_Health")
    wsDash.Range("C5").Value = wsProduct.Range("G30").Value  ' Attendance
    wsDash.Range("D5").Value = wsProduct.Range("G31").Value  ' Preparation
    wsDash.Range("E5").Value = wsProduct.Range("G32").Value  ' Quality
    wsDash.Range("F5").Value = wsProduct.Range("G33").Value  ' Timeliness
    wsDash.Range("G5").Value = wsProduct.Range("G34").Value  ' Outputs
    wsDash.Range("H5").Value = wsProduct.Range("G35").Value  ' Overall

    ' Demand Review (Row 6)
    Set wsDemand = ThisWorkbook.Sheets("Demand_Review_Health")
    wsDash.Range("C6").Value = wsDemand.Range("G30").Value
    wsDash.Range("D6").Value = wsDemand.Range("G31").Value
    wsDash.Range("E6").Value = wsDemand.Range("G32").Value
    wsDash.Range("F6").Value = wsDemand.Range("G33").Value
    wsDash.Range("G6").Value = wsDemand.Range("G34").Value
    wsDash.Range("H6").Value = wsDemand.Range("G35").Value

    ' Supply Review (Row 7)
    Set wsSupply = ThisWorkbook.Sheets("Supply_Review_Health")
    wsDash.Range("C7").Value = wsSupply.Range("G30").Value
    wsDash.Range("D7").Value = wsSupply.Range("G31").Value
    wsDash.Range("E7").Value = wsSupply.Range("G32").Value
    wsDash.Range("F7").Value = wsSupply.Range("G33").Value
    wsDash.Range("G7").Value = wsSupply.Range("G34").Value
    wsDash.Range("H7").Value = wsSupply.Range("G35").Value

    ' Financial Review (Row 8)
    Set wsFinance = ThisWorkbook.Sheets("Financial_Review_Health")
    wsDash.Range("C8").Value = wsFinance.Range("G30").Value
    wsDash.Range("D8").Value = wsFinance.Range("G31").Value
    wsDash.Range("E8").Value = wsFinance.Range("G32").Value
    wsDash.Range("F8").Value = wsFinance.Range("G33").Value
    wsDash.Range("G8").Value = wsFinance.Range("G34").Value
    wsDash.Range("H8").Value = wsFinance.Range("G35").Value

    ' Executive IBP (Row 9)
    Set wsExec = ThisWorkbook.Sheets("Executive_IBP_Health")
    wsDash.Range("C9").Value = wsExec.Range("G30").Value
    wsDash.Range("D9").Value = wsExec.Range("G31").Value
    wsDash.Range("E9").Value = wsExec.Range("G32").Value
    wsDash.Range("F9").Value = wsExec.Range("G33").Value
    wsDash.Range("G9").Value = wsExec.Range("G34").Value
    wsDash.Range("H9").Value = wsExec.Range("G35").Value

    ' Calculate overall averages (Row 11)
    wsDash.Range("C11").Formula = "=AVERAGE(C5:C9)"
    wsDash.Range("D11").Formula = "=AVERAGE(D5:D9)"
    wsDash.Range("E11").Formula = "=AVERAGE(E5:E9)"
    wsDash.Range("F11").Formula = "=AVERAGE(F5:F9)"
    wsDash.Range("G11").Formula = "=AVERAGE(G5:G9)"
    wsDash.Range("H11").Formula = "=AVERAGE(H5:H9)"

    ' Update status indicators
    Call UpdateStatusIndicators

End Sub

Sub UpdateStatusIndicators()
    '''
    ' Update status indicators based on scores and targets
    '''

    Dim wsDash As Worksheet
    Dim i As Integer

    Set wsDash = ThisWorkbook.Sheets("Health_Dashboard")

    For i = 5 To 9
        Call SetHealthStatus(wsDash.Range("M" & i), _
                            wsDash.Range("H" & i).Value, _
                            wsDash.Range("K" & i).Value)
    Next i

    ' Overall status
    Call SetHealthStatus(wsDash.Range("M11"), _
                        wsDash.Range("H11").Value, _
                        wsDash.Range("K11").Value)

End Sub

Sub SetHealthStatus(rngStatus As Range, dblScore As Double, dblTarget As Double)
    '''
    ' Set status cell formatting based on score
    '''

    Dim dblGap As Double
    dblGap = dblScore - dblTarget

    If dblGap >= 0 Then
        rngStatus.Value = "Healthy"
        rngStatus.Interior.Color = RGB(40, 167, 69)
        rngStatus.Font.Color = RGB(255, 255, 255)
    ElseIf dblGap >= -10 Then
        rngStatus.Value = "Monitor"
        rngStatus.Interior.Color = RGB(255, 193, 7)
        rngStatus.Font.Color = RGB(0, 0, 0)
    Else
        rngStatus.Value = "At Risk"
        rngStatus.Interior.Color = RGB(220, 53, 69)
        rngStatus.Font.Color = RGB(255, 255, 255)
    End If

End Sub

Sub AnalyzeTrends()
    '''
    ' Calculate SLOPE and trend direction for all processes
    '''

    Dim wsTrend As Worksheet
    Dim i As Long
    Dim rngData As Range
    Dim dblSlope As Double

    Set wsTrend = ThisWorkbook.Sheets("Trend_12_Month")

    For i = 4 To 8
        Set rngData = wsTrend.Range("B" & i & ":M" & i)

        ' Calculate SLOPE
        dblSlope = Application.WorksheetFunction.Slope( _
                   rngData, Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))

        wsTrend.Range("O" & i).Value = Round(dblSlope, 3)

        ' Determine direction
        Select Case dblSlope
            Case Is > 1
                wsTrend.Range("P" & i).Value = "Strong Improving"
                wsTrend.Range("P" & i).Interior.Color = RGB(0, 100, 0)
            Case Is > 0.3
                wsTrend.Range("P" & i).Value = "Improving"
                wsTrend.Range("P" & i).Interior.Color = RGB(40, 167, 69)
            Case Is > -0.3
                wsTrend.Range("P" & i).Value = "Stable"
                wsTrend.Range("P" & i).Interior.Color = RGB(128, 128, 128)
            Case Is > -1
                wsTrend.Range("P" & i).Value = "Declining"
                wsTrend.Range("P" & i).Interior.Color = RGB(255, 165, 0)
            Case Else
                wsTrend.Range("P" & i).Value = "Strong Declining"
                wsTrend.Range("P" & i).Interior.Color = RGB(220, 53, 69)
        End Select

    Next i

End Sub

Sub GenerateIssueReport()
    '''
    ' Generate summary of open issues by process and dimension
    '''

    Dim wsIssue As Worksheet
    Dim strReport As String
    Dim dictProcess As Object, dictDimension As Object
    Dim i As Long, lastRow As Long

    Set wsIssue = ThisWorkbook.Sheets("Issue_Log")
    Set dictProcess = CreateObject("Scripting.Dictionary")
    Set dictDimension = CreateObject("Scripting.Dictionary")

    lastRow = wsIssue.Cells(wsIssue.Rows.Count, "A").End(xlUp).Row

    ' Count open issues by process and dimension
    For i = 4 To lastRow
        If wsIssue.Cells(i, "M").Value <> "Closed" Then
            ' Count by process
            If dictProcess.Exists(wsIssue.Cells(i, "C").Value) Then
                dictProcess(wsIssue.Cells(i, "C").Value) = dictProcess(wsIssue.Cells(i, "C").Value) + 1
            Else
                dictProcess.Add wsIssue.Cells(i, "C").Value, 1
            End If

            ' Count by dimension
            If dictDimension.Exists(wsIssue.Cells(i, "D").Value) Then
                dictDimension(wsIssue.Cells(i, "D").Value) = dictDimension(wsIssue.Cells(i, "D").Value) + 1
            Else
                dictDimension.Add wsIssue.Cells(i, "D").Value, 1
            End If
        End If
    Next i

    ' Build report
    strReport = "OPEN ISSUES SUMMARY" & vbCrLf & vbCrLf
    strReport = strReport & "BY PROCESS:" & vbCrLf

    Dim key As Variant
    For Each key In dictProcess.Keys
        strReport = strReport & "  " & key & ": " & dictProcess(key) & vbCrLf
    Next key

    strReport = strReport & vbCrLf & "BY DIMENSION:" & vbCrLf
    For Each key In dictDimension.Keys
        strReport = strReport & "  " & key & ": " & dictDimension(key) & vbCrLf
    Next key

    MsgBox strReport, vbInformation, "Issue Summary"

End Sub

Sub ExportToBalancedScorecard()
    '''
    ' Export process health data to Balanced Scorecard workbook
    '''

    Dim wbScorecard As Workbook
    Dim strPath As String

    strPath = ThisWorkbook.Sheets("Config").Range("Balanced_Scorecard_Path").Value

    On Error Resume Next
    Set wbScorecard = Workbooks.Open(strPath)
    If wbScorecard Is Nothing Then
        MsgBox "Could not open Balanced Scorecard at: " & strPath, vbExclamation
        Exit Sub
    End If
    On Error GoTo 0

    ' Export overall process health score
    wbScorecard.Sheets("Enabler_Perspective").Range("E4").Value = _
        ThisWorkbook.Sheets("Health_Dashboard").Range("H11").Value

    wbScorecard.Save
    wbScorecard.Close

    MsgBox "Data exported to Balanced Scorecard!", vbInformation

End Sub
```

---

## Integration Points

### Inbound Data Sources

| Source Workbook | Data Elements | Refresh Frequency |
|-----------------|---------------|-------------------|
| Meeting_Cadence_Calendar | Meeting dates, attendees | After each meeting |
| Action_Item_Tracker | Action completion rates | Weekly |
| Survey_Results | Effectiveness ratings | Monthly |

### Outbound Data Flows

| Destination | Data Elements | Purpose |
|-------------|---------------|---------|
| Balanced_Scorecard | Process health score | Enabler perspective metric |
| IBP_Master_Integration | Health summary | Executive reporting |
| Improvement_Plan | Issue list, priorities | Action planning |

### Named Ranges for External Reference

```excel
Process_Health_Overall = Health_Dashboard!$H$11
Product_Health = Health_Dashboard!$H$5
Demand_Health = Health_Dashboard!$H$6
Supply_Health = Health_Dashboard!$H$7
Financial_Health = Health_Dashboard!$H$8
Executive_Health = Health_Dashboard!$H$9
Health_Trend_Data = Trend_12_Month!$B$4:$M$9
Open_Issues_Count = COUNTIF(Issue_Log!M:M,"<>Closed")
```

---

## Usage Instructions

### Initial Setup
1. Configure dimension weights in Config sheet
2. Set target scores for each process step
3. Assign owners for each process step
4. Link to related workbooks

### After Each IBP Cycle
1. Complete health assessment for each process step
2. Run "CalculateAllProcessHealth" macro
3. Review dashboard for issues
4. Log any new issues in Issue_Log
5. Update improvement actions

### Monthly Review
1. Run "AnalyzeTrends" macro
2. Review SLOPE indicators
3. Prioritize improvement actions
4. Export to Balanced Scorecard

---

## Document Control

| Field | Value |
|-------|-------|
| Version | 2.0 Enhanced |
| Last Updated | 2026-02-21 |
| Author | IBP Center of Excellence |
| Review Cycle | Monthly |
| Classification | Internal Use |
