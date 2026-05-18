# Gap Closure Tracker - Enhanced Excel Workbook

## Workbook Overview

**Purpose:** Track and manage initiatives to close revenue, gross margin, and operating income gaps versus budget with risk-adjusted projections and monthly progress monitoring.

**Version:** 2.0 Enhanced
**Last Updated:** 2026-02-21
**IBP Integration:** Financial Review (Pillar 4)

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy (#1B365D) |
| Accent Color 1 | Forest Green (#2E7D32) - Positive/On Track |
| Accent Color 2 | Amber (#FF8F00) - At Risk |
| Accent Color 3 | Crimson (#C62828) - Off Track/Gaps |
| Header Font | Calibri Bold 12pt White |
| Body Font | Calibri 10pt |
| Number Format | Currency with 1 decimal (M) |
| Gridlines | Light gray (#E0E0E0) |

---

## Sheet 1: Dashboard

### Purpose
Executive overview of all gaps and closure progress with visual waterfall bridge.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **GAP CLOSURE TRACKER - EXECUTIVE DASHBOARD** | | | | | | Last Updated: | =TODAY() |
| 2 | Fiscal Year: | =FiscalYear | | Period: | =CurrentPeriod | | Status: | =OverallStatus |
| 3 | | | | | | | | |
| 4 | **GAP SUMMARY ($M)** | | | | | | | |
| 5 | Metric | Annual Budget | Current Forecast | Starting Gap | Identified Initiatives | Risk-Adj Value | Remaining Gap | Gap Status |
| 6 | Revenue | =Budget_Revenue | =Forecast_Revenue | =C6-B6 | =SUMIF(Initiatives,Rev) | =SUMIF(RiskAdj,Rev) | =D6+F6 | =IF(G6>0,"GAP","CLOSED") |
| 7 | Gross Margin | =Budget_GM | =Forecast_GM | =C7-B7 | =SUMIF(Initiatives,GM) | =SUMIF(RiskAdj,GM) | =D7+F7 | =IF(G7>0,"GAP","CLOSED") |
| 8 | Operating Income | =Budget_OI | =Forecast_OI | =C8-B8 | =SUMIF(Initiatives,OI) | =SUMIF(RiskAdj,OI) | =D8+F8 | =IF(G8>0,"GAP","CLOSED") |
| 9 | | | | | | | | |
| 10 | **INITIATIVE SUMMARY** | | | | | | | |
| 11 | Category | # Initiatives | Total Value | Risk-Adj Value | % Identified | Avg Probability | On Track | At Risk |
| 12 | Revenue Initiatives | =COUNTA(Rev_Init) | =SUM(Rev_Values) | =SUM(Rev_RiskAdj) | =F12/ABS(D6) | =AVG(Rev_Prob) | =COUNTIF(Rev_Status,"On Track") | =COUNTIF(Rev_Status,"At Risk") |
| 13 | Margin Initiatives | =COUNTA(GM_Init) | =SUM(GM_Values) | =SUM(GM_RiskAdj) | =F13/ABS(D7) | =AVG(GM_Prob) | =COUNTIF(GM_Status,"On Track") | =COUNTIF(GM_Status,"At Risk") |
| 14 | Cost Initiatives | =COUNTA(Cost_Init) | =SUM(Cost_Values) | =SUM(Cost_RiskAdj) | =F14/ABS(D8) | =AVG(Cost_Prob) | =COUNTIF(Cost_Status,"On Track") | =COUNTIF(Cost_Status,"At Risk") |
| 15 | **TOTAL** | =SUM(B12:B14) | =SUM(C12:C14) | =SUM(D12:D14) | | =AVG(F12:F14) | =SUM(G12:G14) | =SUM(H12:H14) |
| 16 | | | | | | | | |
| 17 | **WATERFALL BRIDGE - OPERATING INCOME GAP ($M)** | | | | | | | |
| 18 | Starting Gap | Revenue Init | Margin Init | Cost Init | Remaining Gap | | | |
| 19 | =D8 | =F12 | =F13 | =F14 | =G8 | | [CHART AREA] | |
| 20-30 | [Waterfall chart visualization area] | | | | | | | |
| 31 | | | | | | | | |
| 32 | **MONTHLY CLOSURE TRACKING** | | | | | | | |
| 33 | Month | Planned Closure | Actual Closure | Cumulative Plan | Cumulative Actual | Variance | % of Plan | |
| 34 | January | =Plan_Jan | =Actual_Jan | =D34 | =E34 | =E34-D34 | =E34/D34 | |
| 35 | February | =Plan_Feb | =Actual_Feb | =D34+B35 | =E34+C35 | =E35-D35 | =E35/D35 | |
| 36 | March | =Plan_Mar | =Actual_Mar | =D35+B36 | =E35+C36 | =E36-D36 | =E36/D36 | |
| 37 | April | =Plan_Apr | =Actual_Apr | =D36+B37 | =E36+C37 | =E37-D37 | =E37/D37 | |
| 38 | May | =Plan_May | =Actual_May | =D37+B38 | =E37+C38 | =E38-D38 | =E38/D38 | |
| 39 | June | =Plan_Jun | =Actual_Jun | =D38+B39 | =E38+C39 | =E39-D39 | =E39/D39 | |
| 40 | July | =Plan_Jul | =Actual_Jul | =D39+B40 | =E39+C40 | =E40-D40 | =E40/D40 | |
| 41 | August | =Plan_Aug | =Actual_Aug | =D40+B41 | =E40+C41 | =E41-D41 | =E41/D41 | |
| 42 | September | =Plan_Sep | =Actual_Sep | =D41+B42 | =E41+C42 | =E42-D42 | =E42/D42 | |
| 43 | October | =Plan_Oct | =Actual_Oct | =D42+B43 | =E42+C43 | =E43-D43 | =E43/D43 | |
| 44 | November | =Plan_Nov | =Actual_Nov | =D43+B44 | =E43+C44 | =E44-D44 | =E44/D44 | |
| 45 | December | =Plan_Dec | =Actual_Dec | =D44+B45 | =E44+C45 | =E45-D45 | =E45/D45 | |
| 46 | **TOTAL** | =SUM(B34:B45) | =SUM(C34:C45) | | | =SUM(F34:F45) | =E45/D45 | |

### Conditional Formatting Rules

| Range | Condition | Format |
|-------|-----------|--------|
| H6:H8 | ="CLOSED" | Green fill, white text |
| H6:H8 | ="GAP" | Red fill, white text |
| G12:G15 | >0 | Green fill |
| H12:H15 | >0 | Amber fill |
| F34:F45 | <0 | Red font |
| F34:F45 | >=0 | Green font |
| G34:G45 | <90% | Red fill |
| G34:G45 | 90%-100% | Amber fill |
| G34:G45 | >=100% | Green fill |

---

## Sheet 2: Revenue_Initiatives

### Purpose
Track all revenue-generating initiatives to close the revenue gap.

### Layout

| Column | Header | Width | Format | Description |
|--------|--------|-------|--------|-------------|
| A | Initiative ID | 12 | Text | REV-001 format |
| B | Initiative Name | 35 | Text | Descriptive name |
| C | Category | 15 | Dropdown | New Business/Pricing/Volume/Mix |
| D | Owner | 20 | Text | Accountable person |
| E | Region | 12 | Dropdown | NA/EMEA/APAC/LATAM |
| F | Product Family | 15 | Dropdown | From product master |
| G | Customer Segment | 15 | Dropdown | Strategic/Key/Standard |
| H | Start Date | 12 | Date | Initiative start |
| I | Target Close | 12 | Date | Expected completion |
| J | Gross Value ($M) | 14 | Currency | Total potential value |
| K | Probability | 10 | Percentage | High/Med/Low |
| L | Prob % | 10 | Percentage | =IF(K="High",90%,IF(K="Med",60%,30%)) |
| M | Risk-Adj Value | 14 | Currency | =J*L |
| N | Status | 12 | Dropdown | On Track/At Risk/Delayed/Complete |
| O | Q1 Impact | 12 | Currency | Quarterly phasing |
| P | Q2 Impact | 12 | Currency | Quarterly phasing |
| Q | Q3 Impact | 12 | Currency | Quarterly phasing |
| R | Q4 Impact | 12 | Currency | Quarterly phasing |
| S | YTD Actual | 12 | Currency | Realized value |
| T | Remaining | 12 | Currency | =M-S |
| U | % Complete | 10 | Percentage | =S/M |
| V | Last Updated | 12 | Date | Last status update |
| W | Notes/Actions | 50 | Text | Comments and next steps |

### Data Validation

| Column | Validation Type | Source |
|--------|-----------------|--------|
| C | List | "New Business,Pricing,Volume,Mix" |
| E | List | =Regions (named range) |
| F | List | =ProductFamilies (named range) |
| G | List | "Strategic,Key,Standard" |
| K | List | "High,Med,Low" |
| N | List | "On Track,At Risk,Delayed,Complete,Cancelled" |

### Formulas

```
Cell L2: =IF(K2="High",0.9,IF(K2="Med",0.6,IF(K2="Low",0.3,0)))
Cell M2: =J2*L2
Cell T2: =M2-S2
Cell U2: =IFERROR(S2/M2,0)
Cell SUM Row: =SUMIF($N:$N,"<>Cancelled",J:J) [for each numeric column]
```

### Conditional Formatting

| Range | Condition | Format |
|-------|-----------|--------|
| N:N | ="On Track" | Green fill |
| N:N | ="At Risk" | Amber fill |
| N:N | ="Delayed" | Red fill |
| N:N | ="Complete" | Blue fill |
| U:U | >=100% | Green fill |
| U:U | 75%-99% | Light green fill |
| U:U | 50%-74% | Amber fill |
| U:U | <50% | Red fill |
| I:I | <TODAY() AND N<>"Complete" | Red fill (overdue) |

---

## Sheet 3: Margin_Initiatives

### Purpose
Track gross margin improvement initiatives.

### Layout

| Column | Header | Width | Format | Description |
|--------|--------|-------|--------|-------------|
| A | Initiative ID | 12 | Text | MGN-001 format |
| B | Initiative Name | 35 | Text | Descriptive name |
| C | Category | 18 | Dropdown | Material Cost/Labor/Yield/Mix/Pricing |
| D | Owner | 20 | Text | Accountable person |
| E | Plant/Region | 15 | Dropdown | Manufacturing location |
| F | Product Family | 15 | Dropdown | From product master |
| G | Baseline Margin % | 12 | Percentage | Current margin |
| H | Target Margin % | 12 | Percentage | Goal margin |
| I | Margin Impact (bps) | 12 | Number | =(H-G)*10000 |
| J | Revenue Base ($M) | 14 | Currency | Applicable revenue |
| K | Gross Value ($M) | 14 | Currency | =J*(H-G) |
| L | Investment Req | 14 | Currency | Required investment |
| M | Net Value ($M) | 14 | Currency | =K-L |
| N | Probability | 10 | Dropdown | High/Med/Low |
| O | Prob % | 10 | Percentage | =IF(N="High",90%,IF(N="Med",60%,30%)) |
| P | Risk-Adj Value | 14 | Currency | =M*O |
| Q | Status | 12 | Dropdown | Status tracking |
| R | Implementation Date | 12 | Date | Expected go-live |
| S | Monthly Run Rate | 12 | Currency | =P/12 |
| T | Months Remaining | 8 | Number | =MAX(0,MONTH(R)-MONTH(TODAY())+1) |
| U | CY Impact | 12 | Currency | =S*MIN(T,12-MONTH(R)+1) |
| V | YTD Actual | 12 | Currency | Realized value |
| W | Variance | 12 | Currency | =V-[Expected YTD] |
| X | Next Milestone | 25 | Text | Key upcoming action |
| Y | Risk/Issues | 40 | Text | Blockers and concerns |

### Category Breakdown

```
Material Cost Initiatives:
- Supplier negotiations
- Specification optimization
- Sourcing alternatives
- Volume consolidation

Labor Efficiency:
- Automation investments
- Process improvements
- Training programs
- Shift optimization

Yield Improvement:
- Waste reduction
- Quality improvements
- Rework elimination
- Scrap reduction

Mix Optimization:
- SKU rationalization
- Channel optimization
- Customer profitability
- Product portfolio focus

Pricing Actions:
- Price increases
- Surcharge implementation
- Value-based pricing
- Contract renegotiation
```

### Conditional Formatting

| Range | Condition | Format |
|-------|-----------|--------|
| I:I | >100 | Dark green (significant impact) |
| I:I | 50-100 | Light green |
| I:I | 25-50 | Yellow |
| I:I | <25 | Light red (low impact) |
| W:W | <0 | Red font |
| W:W | >=0 | Green font |

---

## Sheet 4: Cost_Initiatives

### Purpose
Track cost reduction and operating expense optimization initiatives.

### Layout

| Column | Header | Width | Format | Description |
|--------|--------|-------|--------|-------------|
| A | Initiative ID | 12 | Text | CST-001 format |
| B | Initiative Name | 35 | Text | Descriptive name |
| C | Cost Category | 18 | Dropdown | S&M/G&A/R&D/Other |
| D | Expense Type | 18 | Dropdown | Labor/Travel/Facilities/Services/Other |
| E | Owner | 20 | Text | Accountable person |
| F | Department | 15 | Dropdown | Organizational unit |
| G | Current Spend ($M) | 14 | Currency | Baseline annual spend |
| H | Target Spend ($M) | 14 | Currency | Goal annual spend |
| I | Gross Savings ($M) | 14 | Currency | =G-H |
| J | One-Time Costs | 14 | Currency | Implementation costs |
| K | Net Savings Yr1 | 14 | Currency | =I-J |
| L | Ongoing Savings | 14 | Currency | Annual run rate |
| M | Probability | 10 | Dropdown | High/Med/Low |
| N | Prob % | 10 | Percentage | Probability value |
| O | Risk-Adj Savings | 14 | Currency | =K*N |
| P | Status | 12 | Dropdown | Status tracking |
| Q | Start Date | 12 | Date | Initiative start |
| R | Completion Date | 12 | Date | Full implementation |
| S | Months to Realize | 8 | Number | Implementation time |
| T | CY Impact ($M) | 14 | Currency | Current year benefit |
| U | YTD Actual ($M) | 14 | Currency | Realized savings |
| V | Variance | 12 | Currency | =U-[Expected] |
| W | FTE Impact | 8 | Number | Headcount change |
| X | Approval Status | 15 | Dropdown | Pending/Approved/In Progress |
| Y | Dependencies | 35 | Text | Related initiatives |
| Z | Notes | 40 | Text | Comments |

### Cost Category Details

```
S&M (Sales & Marketing):
- Sales force optimization
- Marketing spend efficiency
- Travel reduction
- Agency consolidation

G&A (General & Administrative):
- Shared services expansion
- Process automation
- Facility consolidation
- Professional services

R&D:
- Portfolio prioritization
- Development efficiency
- Lab consolidation
- External partnerships

Other:
- Supply chain costs
- Logistics optimization
- IT infrastructure
- Insurance/benefits
```

---

## Sheet 5: Risk_Adjustment

### Purpose
Define and manage probability weightings for risk adjustment.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E |
|-----|----------|----------|----------|----------|----------|
| 1 | **RISK ADJUSTMENT METHODOLOGY** | | | | |
| 2 | | | | | |
| 3 | **Probability Categories** | | | | |
| 4 | Category | Description | Default % | Override % | Effective % |
| 5 | High | Strong confidence, committed resources, clear path | 90% | | =IF(D5="",C5,D5) |
| 6 | Medium | Reasonable confidence, some dependencies | 60% | | =IF(D6="",C6,D6) |
| 7 | Low | Exploratory, significant uncertainty | 30% | | =IF(D7="",C7,D7) |
| 8 | | | | | |
| 9 | **Category-Specific Adjustments** | | | | |
| 10 | Initiative Type | High | Medium | Low | Notes |
| 11 | New Customer Win | 85% | 55% | 25% | Higher uncertainty |
| 12 | Price Increase | 95% | 70% | 40% | More controllable |
| 13 | Volume Growth | 85% | 55% | 25% | Market dependent |
| 14 | Material Cost Reduction | 90% | 65% | 35% | Supplier dependent |
| 15 | Headcount Reduction | 95% | 75% | 50% | Execution risk |
| 16 | Process Improvement | 80% | 55% | 30% | Implementation risk |
| 17 | | | | | |
| 18 | **Monthly Probability Decay** | | | | |
| 19 | Months Past Target | Probability Adjustment | | | |
| 20 | 0-1 months | 100% of assigned | | | |
| 21 | 2-3 months | 90% of assigned | | | |
| 22 | 4-6 months | 75% of assigned | | | |
| 23 | >6 months | 50% of assigned | | | |

### Probability Lookup Formula

```excel
=VLOOKUP(ProbabilityCategory,RiskAdjustmentTable,3,FALSE)*
 IF(MonthsPastTarget<=1,1,
  IF(MonthsPastTarget<=3,0.9,
   IF(MonthsPastTarget<=6,0.75,0.5)))
```

---

## Sheet 6: Waterfall_Analysis

### Purpose
Detailed waterfall bridge analysis from starting gap to remaining gap.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **WATERFALL BRIDGE ANALYSIS** | | | | | |
| 2 | | | | | | |
| 3 | **REVENUE GAP WATERFALL** | | | | | |
| 4 | Component | Gross Value | Probability | Risk-Adj Value | Cumulative | % of Gap |
| 5 | Starting Revenue Gap | | | =Dashboard!D6 | =D5 | 100% |
| 6 | + New Customer Wins | =SUMIF(Rev,Cat,"New Business") | =AVG | =B6*C6 | =E5+D6 | =D6/ABS($D$5) |
| 7 | + Pricing Actions | =SUMIF(Rev,Cat,"Pricing") | =AVG | =B7*C7 | =E6+D7 | =D7/ABS($D$5) |
| 8 | + Volume Growth | =SUMIF(Rev,Cat,"Volume") | =AVG | =B8*C8 | =E7+D8 | =D8/ABS($D$5) |
| 9 | + Mix Improvement | =SUMIF(Rev,Cat,"Mix") | =AVG | =B9*C9 | =E8+D9 | =D9/ABS($D$5) |
| 10 | = Remaining Revenue Gap | | | =E9 | | =E9/$D$5 |
| 11 | | | | | | |
| 12 | **GROSS MARGIN GAP WATERFALL** | | | | | |
| 13 | Component | Gross Value | Probability | Risk-Adj Value | Cumulative | % of Gap |
| 14 | Starting GM Gap | | | =Dashboard!D7 | =D14 | 100% |
| 15 | + Material Cost Savings | =SUMIF(Margin,Cat,"Material") | =AVG | =B15*C15 | =E14+D15 | =D15/ABS($D$14) |
| 16 | + Labor Efficiency | =SUMIF(Margin,Cat,"Labor") | =AVG | =B16*C16 | =E15+D16 | =D16/ABS($D$14) |
| 17 | + Yield Improvement | =SUMIF(Margin,Cat,"Yield") | =AVG | =B17*C17 | =E16+D17 | =D17/ABS($D$14) |
| 18 | + Mix/Pricing | =SUMIF(Margin,Cat,"Mix")+... | =AVG | =B18*C18 | =E17+D18 | =D18/ABS($D$14) |
| 19 | = Remaining GM Gap | | | =E18 | | =E18/$D$14 |
| 20 | | | | | | |
| 21 | **OPERATING INCOME GAP WATERFALL** | | | | | |
| 22 | Component | Gross Value | Probability | Risk-Adj Value | Cumulative | % of Gap |
| 23 | Starting OI Gap | | | =Dashboard!D8 | =D23 | 100% |
| 24 | + Revenue Flow-through | =Rev_RiskAdj*GM% | | =B24 | =E23+D24 | =D24/ABS($D$23) |
| 25 | + Margin Initiatives | =GM_RiskAdj | | =B25 | =E24+D25 | =D25/ABS($D$23) |
| 26 | + S&M Savings | =SUMIF(Cost,Cat,"S&M") | =AVG | =B26*C26 | =E25+D26 | =D26/ABS($D$23) |
| 27 | + G&A Savings | =SUMIF(Cost,Cat,"G&A") | =AVG | =B27*C27 | =E26+D27 | =D27/ABS($D$23) |
| 28 | + R&D Savings | =SUMIF(Cost,Cat,"R&D") | =AVG | =B28*C28 | =E27+D28 | =D28/ABS($D$23) |
| 29 | + Other Savings | =SUMIF(Cost,Cat,"Other") | =AVG | =B29*C29 | =E28+D29 | =D29/ABS($D$23) |
| 30 | = Remaining OI Gap | | | =E29 | | =E29/$D$23 |

### Chart Configuration

```
Waterfall Chart Settings:
- Chart Type: Waterfall
- Series: Risk-Adjusted Values
- First/Last as Total: Yes
- Colors:
  - Starting Gap: Red
  - Improvements: Green
  - Remaining Gap: Red (if gap), Blue (if closed)
- Data Labels: Value and % of gap
```

---

## Sheet 7: Monthly_Tracking

### Purpose
Track actual closure vs plan by month with variance analysis.

### Layout

| Column | Header | Description |
|--------|--------|-------------|
| A | Month | Calendar month |
| B | # Active Initiatives | Count of active initiatives |
| C | Planned Closures ($M) | Scheduled completions |
| D | Actual Closures ($M) | Realized value |
| E | Variance ($M) | =D-C |
| F | Cumulative Plan | Running total plan |
| G | Cumulative Actual | Running total actual |
| H | Cumulative Variance | =G-F |
| I | % of Annual Target | =G/Annual_Target |
| J | Forecast to Complete | Remaining estimate |
| K | Projected Year-End | =G+J |
| L | vs Target | =K-Annual_Target |
| M | Key Wins | Notable completions |
| N | Key Misses | Delayed/cancelled |
| O | Commentary | Executive summary |

### Formulas

```excel
C2 (Planned Closures):
=SUMPRODUCT((Revenue_Initiatives!$I:$I>=StartOfMonth)*(Revenue_Initiatives!$I:$I<=EndOfMonth)*(Revenue_Initiatives!$M:$M))
+SUMPRODUCT((Margin_Initiatives!$R:$R>=StartOfMonth)*(Margin_Initiatives!$R:$R<=EndOfMonth)*(Margin_Initiatives!$P:$P))
+SUMPRODUCT((Cost_Initiatives!$R:$R>=StartOfMonth)*(Cost_Initiatives!$R:$R<=EndOfMonth)*(Cost_Initiatives!$O:$O))

F2 (Cumulative Plan):
=F1+C2

I2 (% of Target):
=G2/Annual_Gap_Target
```

---

## Named Ranges

| Range Name | Scope | Reference | Purpose |
|------------|-------|-----------|---------|
| FiscalYear | Workbook | Dashboard!$B$2 | Current fiscal year |
| CurrentPeriod | Workbook | Dashboard!$E$2 | Current period |
| Budget_Revenue | Workbook | Dashboard!$B$6 | Annual revenue budget |
| Budget_GM | Workbook | Dashboard!$B$7 | Annual GM budget |
| Budget_OI | Workbook | Dashboard!$B$8 | Annual OI budget |
| Forecast_Revenue | Workbook | Dashboard!$C$6 | Current revenue forecast |
| Forecast_GM | Workbook | Dashboard!$C$7 | Current GM forecast |
| Forecast_OI | Workbook | Dashboard!$C$8 | Current OI forecast |
| Rev_Initiatives | Workbook | Revenue_Initiatives!$A:$W | All revenue initiatives |
| Rev_RiskAdj | Workbook | Revenue_Initiatives!$M:$M | Risk-adjusted revenue values |
| Rev_Status | Workbook | Revenue_Initiatives!$N:$N | Revenue initiative status |
| GM_Initiatives | Workbook | Margin_Initiatives!$A:$Y | All margin initiatives |
| GM_RiskAdj | Workbook | Margin_Initiatives!$P:$P | Risk-adjusted margin values |
| Cost_Initiatives | Workbook | Cost_Initiatives!$A:$Z | All cost initiatives |
| Cost_RiskAdj | Workbook | Cost_Initiatives!$O:$O | Risk-adjusted cost values |
| Regions | Workbook | Lookups!$A$2:$A$10 | Valid regions |
| ProductFamilies | Workbook | Lookups!$B$2:$B$50 | Valid product families |
| RiskProbabilities | Workbook | Risk_Adjustment!$A$5:$E$7 | Probability table |

---

## VBA Automation

### Module: GapClosureAutomation

```vba
Option Explicit

' Global constants
Const ALERT_THRESHOLD As Double = 0.1 ' 10% gap remaining triggers alert
Const OVERDUE_DAYS As Integer = 7 ' Days past target for warning

'=============================================================================
' Refresh Dashboard
'=============================================================================
Sub RefreshDashboard()
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    ' Update timestamp
    Sheets("Dashboard").Range("H1").Value = Now()

    ' Recalculate all initiative sheets
    Sheets("Revenue_Initiatives").Calculate
    Sheets("Margin_Initiatives").Calculate
    Sheets("Cost_Initiatives").Calculate

    ' Update waterfall analysis
    Call UpdateWaterfallChart

    ' Check for alerts
    Call CheckGapAlerts

    ' Recalculate dashboard
    Sheets("Dashboard").Calculate

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Dashboard refreshed successfully!", vbInformation, "Gap Closure Tracker"
End Sub

'=============================================================================
' Gap Alert System
'=============================================================================
Sub CheckGapAlerts()
    Dim ws As Worksheet
    Dim remainingGap As Double
    Dim startingGap As Double
    Dim alertMsg As String
    Dim hasAlert As Boolean

    Set ws = Sheets("Dashboard")
    hasAlert = False
    alertMsg = "GAP CLOSURE ALERTS:" & vbCrLf & vbCrLf

    ' Check Revenue Gap
    startingGap = Abs(ws.Range("D6").Value)
    remainingGap = ws.Range("G6").Value
    If remainingGap > 0 And remainingGap / startingGap > ALERT_THRESHOLD Then
        alertMsg = alertMsg & "REVENUE: " & Format(remainingGap, "$#,##0.0M") & _
                   " remaining (" & Format(remainingGap / startingGap, "0%") & " of starting gap)" & vbCrLf
        hasAlert = True
    End If

    ' Check Gross Margin Gap
    startingGap = Abs(ws.Range("D7").Value)
    remainingGap = ws.Range("G7").Value
    If remainingGap > 0 And remainingGap / startingGap > ALERT_THRESHOLD Then
        alertMsg = alertMsg & "GROSS MARGIN: " & Format(remainingGap, "$#,##0.0M") & _
                   " remaining (" & Format(remainingGap / startingGap, "0%") & " of starting gap)" & vbCrLf
        hasAlert = True
    End If

    ' Check Operating Income Gap
    startingGap = Abs(ws.Range("D8").Value)
    remainingGap = ws.Range("G8").Value
    If remainingGap > 0 And remainingGap / startingGap > ALERT_THRESHOLD Then
        alertMsg = alertMsg & "OPERATING INCOME: " & Format(remainingGap, "$#,##0.0M") & _
                   " remaining (" & Format(remainingGap / startingGap, "0%") & " of starting gap)" & vbCrLf
        hasAlert = True
    End If

    ' Check for overdue initiatives
    Dim overdueCount As Integer
    overdueCount = CountOverdueInitiatives()
    If overdueCount > 0 Then
        alertMsg = alertMsg & vbCrLf & "WARNING: " & overdueCount & " initiatives are overdue!" & vbCrLf
        hasAlert = True
    End If

    ' Check for at-risk initiatives
    Dim atRiskCount As Integer
    atRiskCount = CountAtRiskInitiatives()
    If atRiskCount > 0 Then
        alertMsg = alertMsg & "ATTENTION: " & atRiskCount & " initiatives are at risk." & vbCrLf
        hasAlert = True
    End If

    If hasAlert Then
        ws.Range("H2").Value = "ALERT"
        ws.Range("H2").Interior.Color = RGB(198, 40, 40) ' Red
        ws.Range("H2").Font.Color = RGB(255, 255, 255)
        MsgBox alertMsg, vbExclamation, "Gap Closure Alerts"
    Else
        ws.Range("H2").Value = "On Track"
        ws.Range("H2").Interior.Color = RGB(46, 125, 50) ' Green
        ws.Range("H2").Font.Color = RGB(255, 255, 255)
    End If
End Sub

'=============================================================================
' Count Overdue Initiatives
'=============================================================================
Function CountOverdueInitiatives() As Integer
    Dim count As Integer
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    Dim targetDate As Date
    Dim status As String

    count = 0

    ' Check Revenue Initiatives
    Set ws = Sheets("Revenue_Initiatives")
    lastRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row
    For i = 2 To lastRow
        targetDate = ws.Cells(i, "I").Value
        status = ws.Cells(i, "N").Value
        If targetDate < Date And status <> "Complete" And status <> "Cancelled" Then
            count = count + 1
        End If
    Next i

    ' Check Margin Initiatives
    Set ws = Sheets("Margin_Initiatives")
    lastRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row
    For i = 2 To lastRow
        targetDate = ws.Cells(i, "R").Value
        status = ws.Cells(i, "Q").Value
        If targetDate < Date And status <> "Complete" And status <> "Cancelled" Then
            count = count + 1
        End If
    Next i

    ' Check Cost Initiatives
    Set ws = Sheets("Cost_Initiatives")
    lastRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row
    For i = 2 To lastRow
        targetDate = ws.Cells(i, "R").Value
        status = ws.Cells(i, "P").Value
        If targetDate < Date And status <> "Complete" And status <> "Cancelled" Then
            count = count + 1
        End If
    Next i

    CountOverdueInitiatives = count
End Function

'=============================================================================
' Count At-Risk Initiatives
'=============================================================================
Function CountAtRiskInitiatives() As Integer
    Dim count As Integer

    count = Application.WorksheetFunction.CountIf( _
            Sheets("Revenue_Initiatives").Range("N:N"), "At Risk")
    count = count + Application.WorksheetFunction.CountIf( _
            Sheets("Margin_Initiatives").Range("Q:Q"), "At Risk")
    count = count + Application.WorksheetFunction.CountIf( _
            Sheets("Cost_Initiatives").Range("P:P"), "At Risk")

    CountAtRiskInitiatives = count
End Function

'=============================================================================
' Update Waterfall Chart
'=============================================================================
Sub UpdateWaterfallChart()
    Dim cht As ChartObject
    Dim ws As Worksheet

    Set ws = Sheets("Dashboard")

    ' Delete existing chart if present
    On Error Resume Next
    ws.ChartObjects("WaterfallChart").Delete
    On Error GoTo 0

    ' Create new waterfall chart
    Set cht = ws.ChartObjects.Add(Left:=400, Top:=320, Width:=500, Height:=250)
    cht.Name = "WaterfallChart"

    With cht.Chart
        .ChartType = xlColumnClustered ' Simulated waterfall
        .SetSourceData Source:=Sheets("Waterfall_Analysis").Range("A23:D30")
        .HasTitle = True
        .ChartTitle.Text = "Operating Income Gap Bridge ($M)"
        .ChartTitle.Font.Size = 12
        .ChartTitle.Font.Bold = True

        ' Format series colors
        .SeriesCollection(1).Points(1).Interior.Color = RGB(198, 40, 40) ' Starting gap - red
        .SeriesCollection(1).Points(8).Interior.Color = RGB(46, 125, 50) ' If closed - green

        ' Add data labels
        .SeriesCollection(1).HasDataLabels = True
        .SeriesCollection(1).DataLabels.Position = xlLabelPositionOutsideEnd
    End With
End Sub

'=============================================================================
' Generate Initiative Report
'=============================================================================
Sub GenerateInitiativeReport()
    Dim ws As Worksheet
    Dim reportWs As Worksheet
    Dim reportName As String

    reportName = "Initiative_Report_" & Format(Date, "YYYYMMDD")

    ' Check if report sheet exists
    On Error Resume Next
    Set reportWs = Sheets(reportName)
    On Error GoTo 0

    If Not reportWs Is Nothing Then
        Application.DisplayAlerts = False
        reportWs.Delete
        Application.DisplayAlerts = True
    End If

    ' Create new report sheet
    Set reportWs = Sheets.Add(After:=Sheets(Sheets.count))
    reportWs.Name = reportName

    ' Build report header
    With reportWs
        .Range("A1").Value = "GAP CLOSURE INITIATIVE REPORT"
        .Range("A1").Font.Bold = True
        .Range("A1").Font.Size = 14

        .Range("A2").Value = "Generated: " & Now()
        .Range("A3").Value = "Period: " & Sheets("Dashboard").Range("E2").Value

        ' Summary section
        .Range("A5").Value = "SUMMARY"
        .Range("A5").Font.Bold = True

        .Range("A6").Value = "Total Initiatives:"
        .Range("B6").Value = Sheets("Dashboard").Range("B15").Value

        .Range("A7").Value = "Total Risk-Adjusted Value:"
        .Range("B7").Value = Sheets("Dashboard").Range("D15").Value
        .Range("B7").NumberFormat = "$#,##0.0"

        .Range("A8").Value = "On Track:"
        .Range("B8").Value = Sheets("Dashboard").Range("G15").Value

        .Range("A9").Value = "At Risk:"
        .Range("B9").Value = Sheets("Dashboard").Range("H15").Value

        ' Copy initiative details
        .Range("A11").Value = "REVENUE INITIATIVES"
        .Range("A11").Font.Bold = True
        Sheets("Revenue_Initiatives").Range("A1:W100").Copy .Range("A12")

        .Columns.AutoFit
    End With

    MsgBox "Report generated: " & reportName, vbInformation, "Gap Closure Tracker"
End Sub

'=============================================================================
' Add New Initiative Wizard
'=============================================================================
Sub AddNewInitiative()
    Dim initiativeType As String
    Dim ws As Worksheet
    Dim newRow As Long
    Dim newID As String

    ' Get initiative type
    initiativeType = InputBox("Enter initiative type:" & vbCrLf & _
                              "1 = Revenue" & vbCrLf & _
                              "2 = Margin" & vbCrLf & _
                              "3 = Cost", _
                              "Add New Initiative", "1")

    Select Case initiativeType
        Case "1"
            Set ws = Sheets("Revenue_Initiatives")
            newRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row + 1
            newID = "REV-" & Format(newRow - 1, "000")
        Case "2"
            Set ws = Sheets("Margin_Initiatives")
            newRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row + 1
            newID = "MGN-" & Format(newRow - 1, "000")
        Case "3"
            Set ws = Sheets("Cost_Initiatives")
            newRow = ws.Cells(ws.Rows.count, "A").End(xlUp).Row + 1
            newID = "CST-" & Format(newRow - 1, "000")
        Case Else
            MsgBox "Invalid selection.", vbExclamation
            Exit Sub
    End Select

    ' Add new row with ID
    ws.Cells(newRow, 1).Value = newID
    ws.Cells(newRow, 2).Select

    MsgBox "New initiative added: " & newID & vbCrLf & _
           "Please complete the initiative details.", vbInformation, "Add Initiative"
End Sub

'=============================================================================
' Auto-assign Button
'=============================================================================
Sub CreateDashboardButtons()
    Dim ws As Worksheet
    Dim btn As Button

    Set ws = Sheets("Dashboard")

    ' Delete existing buttons
    On Error Resume Next
    ws.Buttons.Delete
    On Error GoTo 0

    ' Refresh button
    Set btn = ws.Buttons.Add(700, 10, 100, 25)
    With btn
        .Caption = "Refresh Data"
        .OnAction = "RefreshDashboard"
    End With

    ' Add Initiative button
    Set btn = ws.Buttons.Add(700, 40, 100, 25)
    With btn
        .Caption = "Add Initiative"
        .OnAction = "AddNewInitiative"
    End With

    ' Generate Report button
    Set btn = ws.Buttons.Add(700, 70, 100, 25)
    With btn
        .Caption = "Generate Report"
        .OnAction = "GenerateInitiativeReport"
    End With
End Sub
```

---

## Integration Points

### Integration with Other IBP Workbooks

| Source Workbook | Data Element | Update Frequency |
|-----------------|--------------|------------------|
| Rolling_Forecast_Template | Budget values, Current forecast | Monthly |
| Financial_P&L_Template | Actual revenue, margin, costs | Monthly |
| Demand_Assumptions_Log | Volume assumptions for revenue initiatives | Monthly |
| Supply_Constraints_Log | Capacity assumptions for margin initiatives | Monthly |
| Executive_Summary_Pack | Gap status for executive review | Monthly |

### Data Flow Diagram

```
┌─────────────────────┐     ┌─────────────────────┐
│  Rolling Forecast   │────▶│                     │
│  (Budget/Forecast)  │     │                     │
└─────────────────────┘     │                     │
                            │   Gap Closure       │
┌─────────────────────┐     │   Tracker           │
│  Financial P&L      │────▶│                     │
│  (Actuals)          │     │                     │
└─────────────────────┘     │                     │
                            │                     │
┌─────────────────────┐     │                     │
│  Demand/Supply      │────▶│                     │
│  Assumptions        │     └─────────────────────┘
└─────────────────────┘              │
                                     │
                                     ▼
                            ┌─────────────────────┐
                            │  Executive Summary  │
                            │  Pack               │
                            └─────────────────────┘
```

---

## Usage Guidelines

### Monthly Process

1. **Week 1:** Update budget and forecast values from Rolling Forecast
2. **Week 2:** Review all initiatives, update status and probabilities
3. **Week 3:** Record actual closures, analyze variances
4. **Week 4:** Prepare executive summary, identify new initiatives

### Best Practices

1. **Initiative Entry**
   - Enter all initiatives regardless of probability
   - Be conservative with probability assignments
   - Document assumptions clearly

2. **Status Updates**
   - Update initiative status weekly
   - Move to "At Risk" early when issues arise
   - Document root causes for delays

3. **Risk Adjustment**
   - Review probability assignments monthly
   - Adjust for time-based decay
   - Consider category-specific probabilities

4. **Reporting**
   - Focus on remaining gap, not just initiatives
   - Highlight "At Risk" items requiring action
   - Track cumulative performance vs plan

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-15 | IBP Team | Initial release |
| 2.0 | 2026-02-21 | IBP CoE | Enhanced with VBA automation, waterfall analysis |
