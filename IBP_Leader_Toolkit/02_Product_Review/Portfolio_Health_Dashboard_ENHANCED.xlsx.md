# Portfolio Health Dashboard - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Product_Data
### Sheet 3: Lifecycle_Analysis
### Sheet 4: Revenue_Mix
### Sheet 5: Vitality_Index
### Sheet 6: Settings

---

## SHEET 1: DASHBOARD

### Layout Design
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ A1:P1  HEADER: "PORTFOLIO HEALTH DASHBOARD" (Dark Purple #4A148C)          │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:E10  KEY METRICS              │ G3:P10  PORTFOLIO COMPOSITION PIE       │
│ ┌─────────────────────────┐      │                                         │
│ │ Total SKUs: =COUNT      │      │  [Donut Chart: Revenue by Lifecycle]    │
│ │ Active SKUs: =COUNTIF   │      │                                         │
│ │ Revenue: =SUM           │      │                                         │
│ │ Margin %: =FORMULA      │      │                                         │
│ │ Vitality Index: =FORMULA│      │                                         │
│ └─────────────────────────┘      │                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│ A12:H25  LIFECYCLE MATRIX        │ J12:P25  TOP/BOTTOM PERFORMERS          │
│ (Products by Stage vs Revenue)   │ (Ranked by margin contribution)         │
├─────────────────────────────────────────────────────────────────────────────┤
│ A27:P35  TREND CHARTS (Revenue, Margin, SKU Count over 12 months)          │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard KPI Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=COUNTA(Product_Data!$A$3:$A$5000)-COUNTBLANK(Product_Data!$A$3:$A$5000)` | Total SKU count |
| C5 | `=COUNTIF(Product_Data!$H$3:$H$5000,"Active")` | Active SKUs |
| C6 | `=SUM(Product_Data!$I$3:$I$5000)` | Total Revenue |
| C7 | `=SUMPRODUCT(Product_Data!$I$3:$I$5000,Product_Data!$J$3:$J$5000)/C6` | Weighted Avg Margin % |
| C8 | `=SUMIF(Product_Data!$G$3:$G$5000,"<="&DATE(YEAR(TODAY())-3,MONTH(TODAY()),DAY(TODAY())),Product_Data!$I$3:$I$5000)/C6` | Vitality Index (% revenue from products <3 yrs) |
| C9 | `=COUNTIF(Product_Data!$F$3:$F$5000,"Decline")/C4` | % in Decline |
| C10 | `=COUNTIF(Product_Data!$F$3:$F$5000,"Launch")+COUNTIF(Product_Data!$F$3:$F$5000,"Growth")` | Growth Products |

### Conditional Formatting
```
Vitality Index (C8):
- >= 25%: Green (#C8E6C9)
- 15-24%: Yellow (#FFF9C4)
- < 15%: Red (#FFCDD2)

Margin % (C7):
- >= Target (Settings!$B$5): Green
- Within 2% of target: Yellow
- Below target -2%: Red
```

---

## SHEET 2: Product_Data

### Column Structure
| Col | Header | Width | Format | Description |
|-----|--------|-------|--------|-------------|
| A | SKU_ID | 15 | Text | Unique identifier |
| B | Product_Name | 35 | Text | Product description |
| C | Product_Family | 20 | Dropdown | Family grouping |
| D | Category | 20 | Dropdown | Product category |
| E | Launch_Date | 12 | Date | Market launch date |
| F | Lifecycle_Stage | 15 | Dropdown | Current stage |
| G | Product_Age_Years | 10 | Number | =FORMULA |
| H | Status | 12 | Dropdown | Active/Inactive |
| I | Revenue_LTM | 15 | Currency | Last 12 months |
| J | Margin_Pct | 10 | Percentage | Gross margin % |
| K | Margin_Contribution | 15 | Currency | =FORMULA |
| L | Volume_LTM | 12 | Number | Units sold LTM |
| M | Avg_Price | 12 | Currency | =FORMULA |
| N | Customer_Count | 10 | Number | Unique customers |
| O | Revenue_Growth_YoY | 12 | Percentage | YoY change |
| P | Complexity_Score | 10 | Number (1-5) | Manufacturing complexity |
| Q | Strategic_Priority | 12 | Dropdown | High/Med/Low |
| R | Rationalization_Flag | 12 | Formula | Auto-flag candidates |
| S | Notes | 40 | Text | Comments |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| G3 | `=DATEDIF(E3,TODAY(),"Y")` | Calculate product age in years |
| K3 | `=I3*J3` | Margin contribution dollars |
| M3 | `=IF(L3>0,I3/L3,0)` | Average selling price |
| R3 | `=IF(AND(F3="Decline",I3<Settings!$B$10,J3<Settings!$B$11),"REVIEW",IF(AND(L3<Settings!$B$12,N3<Settings!$B$13),"CANDIDATE",""))` | Auto-flag rationalization candidates |

### Data Validation
```
Column C (Product_Family):
=Settings!$D$3:$D$20

Column D (Category):
=Settings!$E$3:$E$20

Column F (Lifecycle_Stage):
="Launch,Growth,Mature,Decline,End of Life"

Column H (Status):
="Active,Inactive,Discontinued,Pending Launch"

Column Q (Strategic_Priority):
="High,Medium,Low"
```

### Conditional Formatting
```
Rule 1: Lifecycle Stage Colors
- Launch: Light Blue (#BBDEFB)
- Growth: Light Green (#C8E6C9)
- Mature: Light Yellow (#FFF9C4)
- Decline: Light Orange (#FFE0B2)
- End of Life: Light Red (#FFCDD2)

Rule 2: Rationalization Flags
- "REVIEW": Orange fill, Bold
- "CANDIDATE": Red fill, Bold

Rule 3: Margin Below Target
- J3 < Settings!$B$5: Red text

Rule 4: High Revenue Products
- I3 >= PERCENTILE(I:I, 0.9): Green bold border
```

---

## SHEET 3: Lifecycle_Analysis

### Summary by Lifecycle Stage

| Row | Stage | SKU Count | Revenue | % Revenue | Avg Margin | Margin $ |
|-----|-------|-----------|---------|-----------|------------|----------|
| 3 | Launch | =COUNTIF | =SUMIF | =FORMULA | =AVERAGEIF | =SUMPRODUCT |
| 4 | Growth | =COUNTIF | =SUMIF | =FORMULA | =AVERAGEIF | =SUMPRODUCT |
| 5 | Mature | =COUNTIF | =SUMIF | =FORMULA | =AVERAGEIF | =SUMPRODUCT |
| 6 | Decline | =COUNTIF | =SUMIF | =FORMULA | =AVERAGEIF | =SUMPRODUCT |
| 7 | End of Life | =COUNTIF | =SUMIF | =FORMULA | =AVERAGEIF | =SUMPRODUCT |

### Formulas for Row 3 (Launch)

| Cell | Formula |
|------|---------|
| B3 | `=COUNTIF(Product_Data!$F:$F,"Launch")` |
| C3 | `=SUMIF(Product_Data!$F:$F,"Launch",Product_Data!$I:$I)` |
| D3 | `=C3/SUM($C$3:$C$7)` |
| E3 | `=AVERAGEIF(Product_Data!$F:$F,"Launch",Product_Data!$J:$J)` |
| F3 | `=SUMPRODUCT((Product_Data!$F$3:$F$5000="Launch")*(Product_Data!$I$3:$I$5000)*(Product_Data!$J$3:$J$5000))` |

### Lifecycle Transition Matrix
```
Shows movement between stages over time
- Row headers: Current Stage
- Column headers: Recommended Next Stage
- Cells: SKU count

Formula Example (B12):
=COUNTIFS(Product_Data!$F:$F,"Launch",Product_Data!$O:$O,">0.1")
```

---

## SHEET 4: Revenue_Mix

### By Product Family
| Col A | Col B | Col C | Col D | Col E | Col F |
|-------|-------|-------|-------|-------|-------|
| Family | SKUs | Revenue | % Total | Margin % | YoY Growth |

### Formulas
```
B3: =COUNTIF(Product_Data!$C:$C,A3)
C3: =SUMIF(Product_Data!$C:$C,A3,Product_Data!$I:$I)
D3: =C3/SUM($C$3:$C$20)
E3: =SUMPRODUCT((Product_Data!$C$3:$C$5000=A3)*(Product_Data!$I$3:$I$5000)*(Product_Data!$J$3:$J$5000))/C3
F3: =SUMPRODUCT((Product_Data!$C$3:$C$5000=A3)*(Product_Data!$O$3:$O$5000)*(Product_Data!$I$3:$I$5000))/C3
```

### Pareto Analysis (80/20)
```
G3 (Cumulative %): =SUM($D$3:D3)
H3 (Pareto Class): =IF(G3<=0.8,"A",IF(G3<=0.95,"B","C"))
```

---

## SHEET 5: Vitality_Index

### Vitality Calculation
```
Definition: % of revenue from products launched in last 3 years

Cell B3 (Total Revenue): =SUM(Product_Data!$I:$I)
Cell B4 (Revenue <3 Years): =SUMIF(Product_Data!$G:$G,"<3",Product_Data!$I:$I)
Cell B5 (Vitality Index): =B4/B3
Cell B6 (Target): =Settings!$B$8
Cell B7 (Gap): =B5-B6
Cell B8 (Status): =IF(B5>=B6,"✓ On Target",IF(B5>=B6*0.8,"⚠ Watch","✗ Below Target"))
```

### Vitality Trend (12-Month)
```
Monthly vitality calculation for trend chart
Row 12: Month names (Jan-Dec)
Row 13: Vitality % each month
Formula: =SUMPRODUCT((Product_Data!$G$3:$G$5000<3)*(MONTH(Product_Data!$E$3:$E$5000)<=COLUMN()-1)*(Product_Data!$I$3:$I$5000))/SUMIF(Product_Data!$H:$H,"Active",Product_Data!$I:$I)
```

### NPI Impact Analysis
```
B20: NPI Products This Year: =COUNTIF(Product_Data!$E:$E,">="&DATE(YEAR(TODAY()),1,1))
B21: NPI Revenue: =SUMIF(Product_Data!$E:$E,">="&DATE(YEAR(TODAY()),1,1),Product_Data!$I:$I)
B22: NPI % of Total: =B21/B3
B23: NPI Avg Margin: =AVERAGEIF(Product_Data!$E:$E,">="&DATE(YEAR(TODAY()),1,1),Product_Data!$J:$J)
```

---

## SHEET 6: Settings

### Configuration Parameters
| Row | Parameter | Value | Description |
|-----|-----------|-------|-------------|
| 2 | Report_Date | =TODAY() | Auto-update |
| 3 | Currency | USD | Display currency |
| 4 | Fiscal_Year_Start | 1 | Month (1=Jan) |
| 5 | Target_Margin_Pct | 0.35 | 35% target |
| 6 | Target_Vitality_Index | 0.25 | 25% target |
| 8 | Vitality_Years | 3 | Years for vitality calc |
| 10 | Rationalization_Revenue_Threshold | 50000 | Below this = review |
| 11 | Rationalization_Margin_Threshold | 0.15 | Below this = review |
| 12 | Rationalization_Volume_Threshold | 100 | Below this = review |
| 13 | Rationalization_Customer_Threshold | 3 | Below this = review |

### Product Family List (D3:D20)
```
Family_A
Family_B
Family_C
(Add as needed)
```

### Category List (E3:E20)
```
Category_1
Category_2
Category_3
(Add as needed)
```

---

## NAMED RANGES

```
Name: ProductData
Refers to: =Product_Data!$A$3:$S$5000

Name: ActiveProducts
Refers to: =OFFSET(Product_Data!$A$3,0,0,COUNTA(Product_Data!$A:$A)-1,19)

Name: RevenueColumn
Refers to: =Product_Data!$I:$I

Name: MarginColumn
Refers to: =Product_Data!$J:$J

Name: LifecycleColumn
Refers to: =Product_Data!$F:$F

Name: TargetMargin
Refers to: =Settings!$B$5

Name: TargetVitality
Refers to: =Settings!$B$6
```

---

## INTEGRATION POINTS

### Links to Other Workbooks
```
1. NPI_Pipeline_Tracker.xlsx
   - Pull: Upcoming launches (add to vitality forecast)
   - Push: Current vitality index

2. SKU_Rationalization_Analysis.xlsx
   - Push: Flagged SKUs for detailed analysis
   - Sync: Rationalization criteria thresholds

3. Demand_Consensus_Workbook.xlsx
   - Push: Product family performance
   - Link: Growth rates for forecasting

4. Financial_Review_Plan_vs_Actual.xlsx
   - Push: Revenue and margin by family
   - Sync: YoY growth calculations
```

### Power Query: Refresh Product Data
```
let
    Source = Excel.CurrentWorkbook(){[Name="ProductData"]}[Content],
    FilterActive = Table.SelectRows(Source, each [Status] = "Active"),
    SortedByRevenue = Table.Sort(FilterActive,{{"Revenue_LTM", Order.Descending}})
in
    SortedByRevenue
```

---

## CHARTS SPECIFICATION

### Chart 1: Portfolio Composition Donut
```
Data: Lifecycle_Analysis C3:C7
Labels: Lifecycle_Analysis A3:A7
Type: Donut
Colors: Blue, Green, Yellow, Orange, Red
Hole Size: 60%
```

### Chart 2: Revenue vs Margin Scatter
```
X-Axis: Revenue (Product_Data I column)
Y-Axis: Margin % (Product_Data J column)
Bubble Size: Volume (Product_Data L column)
Color: By Lifecycle Stage
Quadrant Lines: At target margin and median revenue
```

### Chart 3: Vitality Trend Line
```
Data: Vitality_Index Row 13
Type: Line with markers
Target Line: Horizontal at Settings!$B$6
```

---

**Template Version:** Enhanced Portfolio Health Dashboard 2.0
**Refresh Frequency:** Monthly (before Product Review)
