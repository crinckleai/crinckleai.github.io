# SKU Rationalization Analysis - Enhanced Excel Workbook Specification

## Overview

This workbook provides a comprehensive, data-driven framework for evaluating SKU portfolio complexity and identifying rationalization opportunities. It combines Pareto analysis, multi-criteria scoring, customer impact assessment, inventory disposition planning, and business case development into a single integrated tool. The workbook enables Product Review teams to make informed decisions about which SKUs to protect, optimize, monitor, or sunset.

**Workbook Name:** `SKU_Rationalization_Analysis_ENHANCED.xlsx`
**Total Sheets:** 11
**Primary Users:** Product Management, Supply Chain, Finance, IBP Process Owner
**Update Frequency:** Quarterly (with monthly data refresh)

---

## Design Theme

### Color Palette

| Element | Color | Hex Code | Usage |
|---------|-------|----------|-------|
| Primary Header | Navy | `#1B2A4A` | Sheet headers, title bars |
| Secondary Header | Dark Navy | `#0F1B2D` | Sub-headers, section dividers |
| Accent | Emerald | `#059669` | Key metrics, highlights |
| ABC-A Class | Deep Green | `#065F46` | A-class SKUs |
| ABC-B Class | Amber | `#D97706` | B-class SKUs |
| ABC-C Class | Red | `#DC2626` | C-class / Tail SKUs |
| Status Green | Green | `#10B981` | Protect, on-track |
| Status Yellow | Yellow | `#F59E0B` | Monitor, attention |
| Status Red | Red | `#EF4444` | Sunset, critical |
| Background | Light Gray | `#F8FAFC` | Alternating rows |
| Text Primary | Charcoal | `#1E293B` | Body text |
| Text Secondary | Slate | `#64748B` | Labels, footnotes |

### Typography

| Element | Font | Size | Weight | Color |
|---------|------|------|--------|-------|
| Workbook Title | Calibri | 18pt | Bold | White on `#1B2A4A` |
| Sheet Title | Calibri | 16pt | Bold | `#1B2A4A` |
| Section Header | Calibri | 13pt | Bold | `#1B2A4A` |
| Column Header | Calibri | 11pt | Bold | White on `#1B2A4A` |
| Body Text | Calibri | 11pt | Regular | `#1E293B` |
| KPI Value | Calibri | 24pt | Bold | `#059669` |

---

## Sheet 1: Settings

### Purpose
Central configuration for all thresholds, weights, and criteria used throughout the workbook.

### Layout

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 1 | **SKU Rationalization - Settings** (merged A1:D1) | | | |
| 2 | *Last Updated:* | `=TODAY()` | *Updated By:* | (manual) |
| 4 | **ABC CLASSIFICATION THRESHOLDS** (section header) | | | |
| 5 | Classification | Cumulative Revenue % | Description | Color Code |
| 6 | A | 80% | High-value, vital few | `#065F46` |
| 7 | B | 95% (80-95%) | Medium-value, important | `#D97706` |
| 8 | C | 100% (95-100%) | Low-value, long tail | `#DC2626` |
| 10 | **SCORING WEIGHTS** (section header) | | | |
| 11 | Criterion | Weight | Min Score | Max Score |
| 12 | Revenue Contribution | 25% | 1 | 5 |
| 13 | Margin Contribution | 20% | 1 | 5 |
| 14 | Volume Trend | 15% | 1 | 5 |
| 15 | Customer Breadth | 15% | 1 | 5 |
| 16 | Strategic Importance | 15% | 1 | 5 |
| 17 | Operational Complexity | 10% | 1 | 5 |
| 18 | Weight Validation | `=SUM(B12:B17)` | | Must = 100% |
| 20 | **TAIL SKU CRITERIA** (section header) | | | |
| 21 | Criterion | Threshold | Description | |
| 22 | Minimum Annual Revenue | $10,000 | Below = tail candidate | |
| 23 | Minimum Annual Volume | 100 units | Below = tail candidate | |
| 24 | Maximum Days Since Last Order | 180 | Above = dormant | |
| 25 | Minimum Customer Count | 2 | Below = single-customer risk | |
| 26 | Minimum Margin % | 10% | Below = margin erosion | |
| 28 | **DISPOSITION CATEGORIES** (section header) | | | |
| 29 | Category | Description | Action Timeline | |
| 30 | Protect | High-value, maintain investment | Ongoing | |
| 31 | Optimize | Good potential, improve efficiency | 0-6 months | |
| 32 | Monitor | Watch list, may improve or decline | 3-12 months | |
| 33 | Sunset | Plan for discontinuation | 6-18 months | |
| 34 | Immediate Exit | No viable business case | 0-3 months | |
| 36 | **FINANCIAL PARAMETERS** (section header) | | | |
| 37 | Discount Rate (NPV) | 10% | | |
| 38 | Inventory Holding Cost % | 25% | Annual carrying cost | |
| 39 | Average Recovery Rate | 40% | For obsolete inventory | |
| 40 | One-time Sunset Cost/SKU | $5,000 | Admin, communication | |

### Named Ranges (Sheet 1)

| Named Range | Reference | Scope |
|-------------|-----------|-------|
| `ABC_A_Threshold` | `Settings!$B$6` | Workbook |
| `ABC_B_Threshold` | `Settings!$B$7` | Workbook |
| `Scoring_Weights` | `Settings!$B$12:$B$17` | Workbook |
| `Min_Revenue_Threshold` | `Settings!$B$22` | Workbook |
| `Min_Volume_Threshold` | `Settings!$B$23` | Workbook |
| `Max_Days_No_Order` | `Settings!$B$24` | Workbook |
| `Min_Customer_Count` | `Settings!$B$25` | Workbook |
| `Min_Margin_Pct` | `Settings!$B$26` | Workbook |
| `Discount_Rate` | `Settings!$B$37` | Workbook |
| `Holding_Cost_Pct` | `Settings!$B$38` | Workbook |
| `Recovery_Rate` | `Settings!$B$39` | Workbook |
| `Sunset_Cost_Per_SKU` | `Settings!$B$40` | Workbook |

### Data Validation

| Cell(s) | Type | Constraint |
|---------|------|------------|
| B6 | Decimal | 0.50 - 0.90 |
| B7 | Decimal | 0.90 - 1.00 |
| B12:B17 | Decimal | 0 - 1.00 |
| B37 | Decimal | 0.01 - 0.30 |
| B38 | Decimal | 0.10 - 0.50 |
| B39 | Decimal | 0 - 1.00 |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| B18 | `<>1` | Fill `#FEE2E2`, Font `#991B1B` (weights must sum to 100%) |
| B18 | `=1` | Fill `#D1FAE5`, Font `#065F46` |

---

## Sheet 2: Executive Summary Dashboard

### Purpose
High-level overview of portfolio rationalization status with KPI tiles and summary charts.

### KPI Tiles (Row 4-8, 6 tiles across)

| Tile | Label | Formula | Format |
|------|-------|---------|--------|
| 1 | Total Active SKUs | `=COUNTA('SKU Data'!A:A)-1` | Integer, 24pt |
| 2 | Revenue per SKU | `=SUM('SKU Data'!E:E)/COUNTA('SKU Data'!A:A)-1` | Currency, $#,##0 |
| 3 | Tail SKU % | `=COUNTIF('Pareto Analysis'!H:H,"C")/Total_SKUs` | Percentage |
| 4 | Tail Revenue % | `=SUMIF('Pareto Analysis'!H:H,"C",'SKU Data'!E:E)/SUM('SKU Data'!E:E)` | Percentage |
| 5 | Avg Portfolio Margin | `=AVERAGE('SKU Data'!G:G)` | Percentage, 1 decimal |
| 6 | Est. Complexity Cost | `=COUNTIF('Pareto Analysis'!H:H,"C")*Sunset_Cost_Per_SKU` | Currency |

### Summary Tables

#### ABC Classification Summary (Rows 10-16)

| Column A | Column B | Column C | Column D | Column E | Column F |
|----------|----------|----------|----------|----------|----------|
| Classification | SKU Count | % of SKUs | Total Revenue | % of Revenue | Avg Margin |
| A | `=COUNTIF(...)` | `=B11/Total_SKUs` | `=SUMIF(...)` | `=D11/Total_Revenue` | `=AVERAGEIF(...)` |
| B | (same pattern) | | | | |
| C | (same pattern) | | | | |
| Total | `=SUM(B11:B13)` | 100% | `=SUM(D11:D13)` | 100% | `=AVERAGE(...)` |

#### Disposition Summary (Rows 18-25)

| Column A | Column B | Column C | Column D | Column E |
|----------|----------|----------|----------|----------|
| Recommendation | SKU Count | Revenue at Risk | Inventory Value | Est. Savings |
| Protect | `=COUNTIF('Scoring Matrix'!I:I,"Protect")` | `=SUMIF(...)` | `=SUMIF(...)` | - |
| Optimize | (same pattern) | | | |
| Monitor | (same pattern) | | | |
| Sunset | (same pattern) | | | |
| Immediate Exit | (same pattern) | | | |

### Chart Specifications

| Chart | Type | Data Source | Position |
|-------|------|------------|----------|
| ABC Pie Chart | Donut | ABC Summary table | Rows 10-16, right side |
| Revenue Pareto | Combo (Bar + Line) | Pareto Analysis sheet | Below KPI tiles |
| Disposition Waterfall | Stacked Bar | Disposition Summary | Rows 18-25, right side |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| Tile 3 (Tail %) | Value > 0.5 | Fill `#FEE2E2` (too many tail SKUs) |
| Tile 3 (Tail %) | Value <= 0.3 | Fill `#D1FAE5` (healthy) |
| Tile 5 (Margin) | Value < Min_Margin_Pct | Fill `#FEE2E2` |

---

## Sheet 3: SKU Data (Master Data Input)

### Purpose
Central data repository for all SKU-level information. This is the primary input sheet that feeds all analysis sheets.

### Column Structure

| Column | Header | Width | Format | Data Validation |
|--------|--------|-------|--------|----------------|
| A | SKU Code | 15 | Text | Unique, no blanks |
| B | Product Name | 30 | Text | |
| C | Product Family | 20 | Text | Dropdown from family list |
| D | Sub-Category | 18 | Text | Dependent dropdown |
| E | Annual Revenue ($) | 16 | Currency $#,##0 | >= 0 |
| F | Annual Volume (Units) | 16 | Number #,##0 | >= 0 |
| G | Gross Margin % | 14 | Percentage 0.0% | -100% to 100% |
| H | Customer Count | 14 | Integer | >= 0 |
| I | Last Order Date | 14 | Date mm/dd/yyyy | <= TODAY() |
| J | Unit Cost ($) | 14 | Currency $#,##0.00 | > 0 |
| K | Current Inventory (Units) | 18 | Number #,##0 | >= 0 |
| L | Inventory Value ($) | 16 | Currency $#,##0 | `=K(row)*J(row)` |
| M | Unit Price ($) | 14 | Currency $#,##0.00 | `=IF(F(row)>0,E(row)/F(row),0)` |
| N | Lifecycle Stage | 16 | Text | Dropdown: Introduction, Growth, Maturity, Decline, EOL |
| O | Strategic Flag | 14 | Text | Dropdown: Yes, No |
| P | Notes | 35 | Text | |

### Auto-Calculated Columns

```excel
' L2 - Inventory Value
=K2 * J2

' M2 - Unit Price
=IF(F2 > 0, E2 / F2, 0)
```

### Data Validation Rules

| Column | Rule |
|--------|------|
| A | Custom: `=COUNTIF($A:$A, A2) = 1` (enforce unique SKU codes) |
| C | List: Product Family names (defined in Settings or separate list) |
| G | Decimal: Between -1 and 1 |
| I | Date: Less than or equal to `=TODAY()` |
| N | List: Introduction, Growth, Maturity, Decline, EOL |
| O | List: Yes, No |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| E2:E5000 | Top 10% | Bold, `#065F46` font |
| E2:E5000 | Bottom 10% | `#991B1B` font |
| G2:G5000 | Value < Min_Margin_Pct | Fill `#FEE2E2` |
| I2:I5000 | `=TODAY()-I2 > Max_Days_No_Order` | Fill `#FEF3C7` (no recent orders) |
| N2:N5000 | Text = "EOL" | Fill `#FEE2E2`, Font `#991B1B` |
| N2:N5000 | Text = "Growth" | Fill `#D1FAE5`, Font `#065F46` |

---

## Sheet 4: Pareto Analysis

### Purpose
Automated Pareto (ABC) analysis ranking all SKUs by revenue contribution with cumulative percentages and classification assignment.

### Column Structure

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | Rank | 8 | Auto-calculated rank |
| B | SKU Code | 15 | Linked from SKU Data |
| C | Product Name | 30 | Linked from SKU Data |
| D | Product Family | 20 | Linked from SKU Data |
| E | Annual Revenue ($) | 16 | Linked from SKU Data |
| F | % of Total Revenue | 14 | Individual contribution |
| G | Cumulative Revenue % | 18 | Running total |
| H | ABC Classification | 16 | Auto-assigned class |
| I | Annual Volume | 14 | Linked from SKU Data |
| J | Gross Margin % | 14 | Linked from SKU Data |
| K | Margin Contribution ($) | 18 | Revenue x Margin |

### Formulas

```excel
' A2 - Revenue Rank (descending)
=RANK(E2, $E$2:$E$5000, 0)

' B2 - SKU Code (sorted by rank)
=INDEX('SKU Data'!$A$2:$A$5000, MATCH(SMALL('SKU Data'!$E$2:$E$5000, ROWS($A$2:$A$5000)-ROW()+2), 'SKU Data'!$E$2:$E$5000, 0))

' Alternative: Use SORT function (Excel 365)
' Column B:K can be populated with:
=SORT('SKU Data'!A2:K5000, 5, -1)

' F2 - % of Total Revenue
=E2 / SUM($E$2:$E$5000)

' G2 - Cumulative Revenue %
=SUM($F$2:F2)

' Alternative cumulative formula
=SUM($E$2:E2) / SUM($E$2:$E$5000)

' H2 - ABC Classification
=IF(G2 <= ABC_A_Threshold, "A",
  IF(G2 <= ABC_B_Threshold, "B", "C"))

' K2 - Margin Contribution
=E2 * J2
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H2:H5000 | Text = "A" | Fill `#D1FAE5`, Font `#065F46`, Bold |
| H2:H5000 | Text = "B" | Fill `#FEF3C7`, Font `#92400E`, Bold |
| H2:H5000 | Text = "C" | Fill `#FEE2E2`, Font `#991B1B`, Bold |
| G2:G5000 | Data bars | Color `#0D9488`, gradient fill |
| E2:E5000 | Data bars | Color `#1B2A4A`, gradient fill |

### Chart Specification: Pareto Chart

| Property | Value |
|----------|-------|
| Type | Combo (Clustered Bar + Line on secondary axis) |
| Bar Series | Annual Revenue (Column E) |
| Line Series | Cumulative % (Column G) |
| Bar Color | `#1B2A4A` |
| Line Color | `#EF4444` |
| Secondary Axis | 0% to 100% |
| Reference Lines | 80% and 95% horizontal lines (dashed `#64748B`) |
| Position | To the right of data or on separate chart sheet |

---

## Sheet 5: ABC Summary

### Purpose
Aggregated summary of ABC classification results with pivot-style analysis by product family and classification.

### Summary Table 1: Overall ABC Summary (Rows 4-9)

| Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|----------|----------|----------|----------|----------|----------|----------|
| Class | SKU Count | % of Total SKUs | Total Revenue | % of Revenue | Avg Margin % | Inventory Value |
| A | `=COUNTIF('Pareto'!H:H,"A")` | `=B5/SUM(B5:B7)` | `=SUMIF('Pareto'!H:H,"A",'Pareto'!E:E)` | `=D5/SUM(D5:D7)` | `=AVERAGEIF('Pareto'!H:H,"A",'Pareto'!J:J)` | `=SUMIF(...)` |
| B | (same pattern) | | | | | |
| C | (same pattern) | | | | | |
| **Total** | `=SUM(B5:B7)` | 100% | `=SUM(D5:D7)` | 100% | `=AVERAGE(...)` | `=SUM(G5:G7)` |

### Summary Table 2: By Product Family (Rows 12+)

| Column A | Column B | Column C | Column D | Column E | Column F |
|----------|----------|----------|----------|----------|----------|
| Product Family | A-Count | B-Count | C-Count | Total SKUs | C-SKU % |
| (family name) | `=COUNTIFS(Family_Col, A13, Class_Col, "A")` | ... | ... | `=SUM(B13:D13)` | `=D13/E13` |

### Formulas

```excel
' Cross-tab count
=COUNTIFS('Pareto Analysis'!$D$2:$D$5000, $A13, 'Pareto Analysis'!$H$2:$H$5000, B$4)

' Revenue concentration ratio
=SUMIF('Pareto Analysis'!$H$2:$H$5000, "A", 'Pareto Analysis'!$E$2:$E$5000) / SUM('Pareto Analysis'!$E$2:$E$5000)

' Family with highest tail %
=INDEX(Family_Names, MATCH(MAX(C_Pct_Range), C_Pct_Range, 0))
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| F13:F100 | Value > 0.5 | Fill `#FEE2E2` (>50% tail = concern) |
| F13:F100 | Value <= 0.2 | Fill `#D1FAE5` (healthy tail ratio) |

---

## Sheet 6: Scoring Matrix

### Purpose
Multi-criteria weighted scoring for each SKU to generate rationalization recommendations. Each SKU is scored across six dimensions with configurable weights.

### Column Structure

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | SKU Code | 15 | Linked from SKU Data |
| B | Product Name | 25 | Linked from SKU Data |
| C | ABC Class | 10 | Linked from Pareto |
| D | Revenue Score (1-5) | 14 | Auto-calculated or manual |
| E | Margin Score (1-5) | 14 | Auto-calculated or manual |
| F | Volume Trend Score (1-5) | 16 | Manual input |
| G | Customer Breadth Score (1-5) | 18 | Auto-calculated |
| H | Strategic Importance (1-5) | 18 | Manual input |
| I | Operational Complexity (1-5) | 18 | Manual input (inverse: 5=simple) |
| J | Weighted Total | 14 | Auto-calculated |
| K | Percentile Rank | 14 | Auto-calculated |
| L | Recommendation | 16 | Auto-generated |
| M | Override | 12 | Manual override |
| N | Final Recommendation | 18 | Override or auto |
| O | Justification | 35 | Manual notes |

### Auto-Scoring Formulas

```excel
' D2 - Revenue Score (auto-calculate based on quintiles)
=IF(E_SKUData >= PERCENTILE(Revenue_Range, 0.8), 5,
  IF(E_SKUData >= PERCENTILE(Revenue_Range, 0.6), 4,
    IF(E_SKUData >= PERCENTILE(Revenue_Range, 0.4), 3,
      IF(E_SKUData >= PERCENTILE(Revenue_Range, 0.2), 2, 1))))

' E2 - Margin Score
=IF(Margin >= PERCENTILE(Margin_Range, 0.8), 5,
  IF(Margin >= PERCENTILE(Margin_Range, 0.6), 4,
    IF(Margin >= PERCENTILE(Margin_Range, 0.4), 3,
      IF(Margin >= PERCENTILE(Margin_Range, 0.2), 2, 1))))

' G2 - Customer Breadth Score
=IF(Cust_Count >= PERCENTILE(Cust_Range, 0.8), 5,
  IF(Cust_Count >= PERCENTILE(Cust_Range, 0.6), 4,
    IF(Cust_Count >= PERCENTILE(Cust_Range, 0.4), 3,
      IF(Cust_Count >= PERCENTILE(Cust_Range, 0.2), 2, 1))))

' J2 - Weighted Total Score
=SUMPRODUCT(D2:I2, Scoring_Weights)

' K2 - Percentile Rank
=RANK(J2, $J$2:$J$5000, 1) / (COUNT($J$2:$J$5000))

' L2 - Auto Recommendation
=IF(J2 >= 4, "Protect",
  IF(J2 >= 3, "Optimize",
    IF(J2 >= 2, "Monitor",
      IF(J2 >= 1.5, "Sunset", "Immediate Exit"))))

' N2 - Final Recommendation (respects override)
=IF(M2 <> "", M2, L2)
```

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| D2:I5000 | Whole Number | 1 - 5 |
| M2:M5000 | List | (blank), Protect, Optimize, Monitor, Sunset, Immediate Exit |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| J2:J5000 | Color Scale | Min (1) = `#EF4444`, Mid (3) = `#F59E0B`, Max (5) = `#10B981` |
| L2:L5000 | Text = "Protect" | Fill `#059669`, Font White |
| L2:L5000 | Text = "Optimize" | Fill `#0D9488`, Font White |
| L2:L5000 | Text = "Monitor" | Fill `#F59E0B`, Font White |
| L2:L5000 | Text = "Sunset" | Fill `#F97316`, Font White |
| L2:L5000 | Text = "Immediate Exit" | Fill `#EF4444`, Font White |
| N2:N5000 | Same as L column rules | Same formatting |
| M2:M5000 | Not blank | Fill `#DBEAFE` (indicates manual override) |
| K2:K5000 | Data bars | Color `#059669` |

---

## Sheet 7: Tail SKU Deep Dive

### Purpose
Focused analysis of C-class and low-performing SKUs to support sunset decisions.

### Column Structure

| Column | Header | Width | Formula/Source |
|--------|--------|-------|---------------|
| A | SKU Code | 15 | Filter from Pareto where Class = "C" |
| B | Product Name | 25 | Linked |
| C | Annual Revenue | 16 | Linked |
| D | Annual Volume | 14 | Linked |
| E | Gross Margin % | 14 | Linked |
| F | Customer Count | 14 | Linked |
| G | Last Order Date | 14 | Linked |
| H | Days Since Last Order | 18 | `=MAX(0, TODAY()-G2)` |
| I | Months of Inventory | 16 | `=IF(D2>0, (K2/(D2/12)), 999)` |
| J | Inventory Value | 16 | Linked |
| K | Current Inventory | 14 | Linked |
| L | Holding Cost/Year | 14 | `=J2 * Holding_Cost_Pct` |
| M | Tail Flags | 14 | Count of tail criteria met |
| N | Disposition | 16 | Dropdown |
| O | Target Exit Date | 14 | Date input |
| P | Customer Migration Plan | 30 | Text |

### Formulas

```excel
' H2 - Days Since Last Order
=MAX(0, TODAY() - G2)

' I2 - Months of Inventory on Hand
=IF(D2 > 0, K2 / (D2 / 12), 999)

' L2 - Annual Holding Cost
=J2 * Holding_Cost_Pct

' M2 - Tail Flag Count (how many tail criteria are met)
=COUNTIF(C2, "<" & Min_Revenue_Threshold) +
 COUNTIF(D2, "<" & Min_Volume_Threshold) +
 COUNTIF(H2, ">" & Max_Days_No_Order) +
 COUNTIF(F2, "<" & Min_Customer_Count) +
 COUNTIF(E2, "<" & Min_Margin_Pct)

' Total Tail Inventory Value
=SUMPRODUCT(('Pareto Analysis'!H2:H5000="C") * ('SKU Data'!L2:L5000))

' Total Holding Cost for Tail
=SUMPRODUCT(('Pareto Analysis'!H2:H5000="C") * ('SKU Data'!L2:L5000)) * Holding_Cost_Pct
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| H2:H5000 | Value > Max_Days_No_Order | Fill `#FEE2E2`, Font `#991B1B` |
| H2:H5000 | Value > Max_Days_No_Order / 2 | Fill `#FEF3C7` |
| I2:I5000 | Value > 12 | Fill `#FEE2E2` (>12 months of stock) |
| I2:I5000 | Value > 6 | Fill `#FEF3C7` |
| M2:M5000 | Value >= 4 | Fill `#EF4444`, Font White (critical) |
| M2:M5000 | Value >= 2 | Fill `#F59E0B` |
| M2:M5000 | Value <= 1 | Fill `#D1FAE5` |

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| N2:N5000 | List | Sell Through, Discount & Clear, Return to Supplier, Scrap, Donate, Rework, Hold |

---

## Sheet 8: Customer Impact Analysis

### Purpose
Assess the impact of SKU rationalization decisions on customer relationships and revenue.

### Column Structure

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | Customer Name | 25 | Key account name |
| B | Customer Tier | 12 | Tier 1/2/3/4 |
| C | Total Customer Revenue | 18 | Total annual revenue |
| D | # SKUs Purchased | 14 | Total SKUs bought by customer |
| E | # SKUs Flagged for Sunset | 20 | Count of sunset SKUs |
| F | Revenue from Sunset SKUs | 20 | Revenue at risk |
| G | % Revenue at Risk | 16 | `=F2/C2` |
| H | Alternative SKUs Available | 20 | Count of substitutes |
| I | Migration Difficulty | 16 | Low/Medium/High |
| J | Communication Status | 16 | Dropdown |
| K | Customer Response | 20 | Dropdown |
| L | Risk Score | 12 | Calculated |
| M | Action Required | 25 | Text |

### Formulas

```excel
' E2 - Count of sunset SKUs for this customer
=SUMPRODUCT(('Scoring Matrix'!$N$2:$N$5000="Sunset") *
            (Customer_SKU_Matrix!B$2:B$5000=A2))

' F2 - Revenue from sunset SKUs
=SUMPRODUCT(('Scoring Matrix'!$N$2:$N$5000="Sunset") *
            (Customer_SKU_Matrix!B$2:B$5000=A2) *
            ('SKU Data'!$E$2:$E$5000))

' G2 - Percentage of Customer Revenue at Risk
=IF(C2 > 0, F2 / C2, 0)

' L2 - Risk Score (weighted)
=IF(B2="Tier 1", G2*3, IF(B2="Tier 2", G2*2, G2))
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| G2:G1000 | Value > 0.2 | Fill `#FEE2E2` (>20% revenue at risk) |
| G2:G1000 | Value > 0.1 | Fill `#FEF3C7` |
| G2:G1000 | Value <= 0.05 | Fill `#D1FAE5` |
| L2:L1000 | Color scale | Low `#10B981` to High `#EF4444` |
| B2:B1000 | Text = "Tier 1" | Bold, Fill `#DBEAFE` |

---

## Sheet 9: Inventory Disposition

### Purpose
Track the financial impact of inventory write-offs and recovery for sunset SKUs.

### Column Structure

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | SKU Code | 15 | Sunset SKUs only |
| B | Product Name | 25 | Linked |
| C | Current Inventory (Units) | 18 | From SKU Data |
| D | Unit Cost | 14 | From SKU Data |
| E | Total Inventory Value | 18 | `=C2*D2` |
| F | Disposition Method | 18 | Dropdown |
| G | Expected Recovery Rate | 16 | Per method |
| H | Expected Recovery Value | 18 | `=E2*G2` |
| I | Write-Off Amount | 16 | `=E2-H2` |
| J | Actual Recovery | 16 | Manual entry (post-disposition) |
| K | Variance | 14 | `=J2-H2` |
| L | Disposition Date | 14 | Planned date |
| M | Status | 12 | Dropdown |
| N | Notes | 30 | |

### Formulas

```excel
' E2 - Total Inventory Value
=C2 * D2

' G2 - Expected Recovery Rate (auto based on method)
=IF(F2="Sell Through", 0.9,
  IF(F2="Discount & Clear", 0.5,
    IF(F2="Return to Supplier", 0.7,
      IF(F2="Scrap", 0.05,
        IF(F2="Donate", 0,
          IF(F2="Rework", 0.6, Recovery_Rate))))))

' H2 - Expected Recovery Value
=E2 * G2

' I2 - Write-Off Amount
=E2 - H2

' K2 - Variance
=IF(J2 > 0, J2 - H2, "")

' Summary totals
' Total Inventory Value at Risk
=SUM(E2:E5000)

' Total Expected Recovery
=SUM(H2:H5000)

' Total Write-Off
=SUM(I2:I5000)

' Net Recovery Rate
=SUM(H2:H5000) / SUM(E2:E5000)
```

### Data Validation

| Cell(s) | Type | Values |
|---------|------|--------|
| F2:F5000 | List | Sell Through, Discount & Clear, Return to Supplier, Scrap, Donate, Rework |
| M2:M5000 | List | Planned, In Progress, Complete, On Hold, Cancelled |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| I2:I5000 | Value > 10000 | Fill `#FEE2E2` (significant write-off) |
| K2:K5000 | Value > 0 | Font `#065F46` (better than expected) |
| K2:K5000 | Value < 0 | Font `#991B1B` (worse than expected) |
| M2:M5000 | Text = "Complete" | Fill `#10B981`, Font White |
| M2:M5000 | Text = "In Progress" | Fill `#3B82F6`, Font White |
| M2:M5000 | Text = "On Hold" | Fill `#F59E0B`, Font White |

---

## Sheet 10: Business Case

### Purpose
Financial justification for rationalization program with 3-year cost-benefit analysis and NPV calculation.

### Layout

#### Section 1: Program Costs (Rows 4-18)

| Row | Cost Category | Year 0 | Year 1 | Year 2 | Year 3 |
|-----|--------------|--------|--------|--------|--------|
| 5 | Inventory Write-Off | `=SUM('Inventory Disposition'!I:I)` | | | |
| 6 | Customer Migration Costs | (input) | (input) | | |
| 7 | System/Data Cleanup | (input) | (input) | | |
| 8 | Communication & Change Mgmt | (input) | (input) | | |
| 9 | Staff Time (FTE Allocation) | (input) | (input) | (input) | |
| 10 | Tooling/Technology | (input) | | | |
| 11 | **Total Costs** | `=SUM(B5:B10)` | `=SUM(C5:C10)` | `=SUM(D5:D10)` | `=SUM(E5:E10)` |

#### Section 2: Program Benefits (Rows 14-25)

| Row | Benefit Category | Year 0 | Year 1 | Year 2 | Year 3 |
|-----|-----------------|--------|--------|--------|--------|
| 15 | Inventory Holding Cost Savings | | `=Sunset_Inv * Holding_Cost_Pct` | (same) | (same) |
| 16 | Manufacturing Efficiency | | (input) | (input) | (input) |
| 17 | Procurement Savings (fewer POs) | | (input) | (input) | (input) |
| 18 | Warehouse Space Savings | | (input) | (input) | (input) |
| 19 | Quality Cost Reduction | | (input) | (input) | (input) |
| 20 | Planning Complexity Reduction | | (input) | (input) | (input) |
| 21 | Revenue Reallocation Benefit | | (input) | (input) | (input) |
| 22 | Inventory Recovery | `=SUM('Inventory Disposition'!H:H)` | | | |
| 23 | **Total Benefits** | `=SUM(B15:B22)` | `=SUM(C15:C22)` | `=SUM(D15:D22)` | `=SUM(E15:E22)` |

#### Section 3: Summary Financials (Rows 28-35)

```excel
' Row 29 - Net Cash Flow
=Total_Benefits_Row - Total_Costs_Row  ' For each year column

' Row 30 - Cumulative Cash Flow
=SUM($B$29:B29)  ' Running cumulative

' Row 31 - NPV (3-Year)
=NPV(Discount_Rate, C29:E29) + B29

' Row 32 - IRR
=IRR(B29:E29)

' Row 33 - Payback Period (months)
=IF(B29 >= 0, 0,
  IF(B29+C29 >= 0, 12 * (-B29/C29),
    IF(B29+C29+D29 >= 0, 12 + 12 * (-(B29+C29)/D29),
      24 + 12 * (-(B29+C29+D29)/E29))))

' Row 34 - ROI (3-Year)
=(SUM(B23:E23) - SUM(B11:E11)) / SUM(B11:E11)

' Row 35 - Benefit/Cost Ratio
=SUM(B23:E23) / SUM(B11:E11)
```

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| NPV Cell | Value > 0 | Fill `#D1FAE5`, Font `#065F46`, Bold |
| NPV Cell | Value <= 0 | Fill `#FEE2E2`, Font `#991B1B`, Bold |
| ROI Cell | Value > 0.5 | Fill `#D1FAE5` |
| Payback Cell | Value <= 12 | Fill `#D1FAE5` (payback within 1 year) |
| Payback Cell | Value > 24 | Fill `#FEE2E2` (long payback) |

---

## Sheet 11: Timeline & Status

### Purpose
Gantt-style implementation tracker for the rationalization program.

### Column Structure

| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | Phase | 12 | Program phase |
| B | Task | 30 | Activity description |
| C | Owner | 18 | Responsible person |
| D | Start Date | 14 | Planned start |
| E | End Date | 14 | Planned end |
| F | Duration (Days) | 14 | `=NETWORKDAYS(D2,E2)` |
| G | % Complete | 12 | Manual input 0-100% |
| H | Status | 12 | Auto-calculated |
| I | Dependencies | 16 | Task IDs |
| J-U | Weekly columns | 4 each | Gantt bars |

### Formulas

```excel
' F2 - Duration in business days
=NETWORKDAYS(D2, E2)

' H2 - Status auto-calculation
=IF(G2 >= 1, "Complete",
  IF(AND(G2 > 0, E2 < TODAY()), "Overdue",
    IF(AND(G2 > 0, E2 >= TODAY()), "In Progress",
      IF(D2 <= TODAY(), "Not Started - Overdue",
        "Not Started"))))

' Gantt bar formula for column J (representing a specific week)
' If week falls within task date range, show filled cell
=IF(AND(J$1 >= $D2, J$1 <= $E2), 1, 0)
```

### Conditional Formatting for Gantt

| Range | Rule | Format |
|-------|------|--------|
| J2:U100 | Value = 1 AND Status = "Complete" | Fill `#10B981` |
| J2:U100 | Value = 1 AND Status = "In Progress" | Fill `#3B82F6` |
| J2:U100 | Value = 1 AND Status = "Overdue" | Fill `#EF4444` |
| J2:U100 | Value = 1 AND Status = "Not Started" | Fill `#E2E8F0` |
| H2:H100 | Text = "Complete" | Fill `#10B981`, Font White |
| H2:H100 | Text = "In Progress" | Fill `#3B82F6`, Font White |
| H2:H100 | Text = "Overdue" | Fill `#EF4444`, Font White |
| G2:G100 | Data bars | Color `#059669` |

---

## Named Ranges for Cross-Workbook Integration

| Named Range | Sheet | Reference | Purpose |
|-------------|-------|-----------|---------|
| `Total_Active_SKUs` | Executive Summary | SKU count cell | Performance dashboard |
| `Tail_SKU_Percentage` | Executive Summary | Tail % cell | Portfolio health metric |
| `SKU_Revenue_Data` | SKU Data | Revenue column | Demand planning reference |
| `ABC_Classification` | Pareto Analysis | Classification column | Supply planning segmentation |
| `Rationalization_Decisions` | Scoring Matrix | Final recommendation column | Product review input |
| `Sunset_SKU_List` | Tail SKU Deep Dive | SKU codes flagged for sunset | Cross-functional notification |
| `Portfolio_Complexity_Score` | Executive Summary | Complexity metric | Maturity assessment |

---

## Integration Points

| Target Workbook | Data Shared | Direction | Purpose |
|----------------|-------------|-----------|---------|
| Product_Lifecycle_Tracker.xlsx | Lifecycle stage data | Bi-directional | Stage informs rationalization |
| Meeting_Cadence.xlsx | Decision items | Outbound | Product Review agenda input |
| Demand_Assumptions_Log.xlsx | Sunset assumptions | Outbound | Demand plan adjustments |
| Statistical_Forecast_Template.xlsx | SKU status flags | Outbound | Exclude sunset SKUs from forecast |
| IBP_Master_Integration.xlsx | Summary KPIs | Outbound | Central dashboard reporting |

---

## VBA / Automation

### Macro 1: Refresh Pareto Analysis

```vba
Sub RefreshParetoAnalysis()
    ' Sorts SKU data by revenue descending and recalculates ABC
    Dim wsData As Worksheet, wsPareto As Worksheet
    Set wsData = ThisWorkbook.Sheets("SKU Data")
    Set wsPareto = ThisWorkbook.Sheets("Pareto Analysis")

    ' Sort data by revenue descending
    Dim lastRow As Long
    lastRow = wsData.Cells(wsData.Rows.Count, "A").End(xlUp).Row

    wsData.Sort.SortFields.Clear
    wsData.Sort.SortFields.Add2 Key:=wsData.Range("E2:E" & lastRow), _
        SortOn:=xlSortOnValues, Order:=xlDescending

    wsData.Sort.SetRange wsData.Range("A1:P" & lastRow)
    wsData.Sort.Header = xlYes
    wsData.Sort.Apply

    ' Recalculate cumulative percentages
    wsPareto.Calculate

    MsgBox "Pareto analysis refreshed. " & lastRow - 1 & " SKUs analyzed.", vbInformation
End Sub
```

### Macro 2: Generate Sunset Report

```vba
Sub GenerateSunsetReport()
    ' Creates filtered report of all SKUs recommended for sunset
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Scoring Matrix")

    Dim wsReport As Worksheet
    On Error Resume Next
    Set wsReport = ThisWorkbook.Sheets("Sunset Report")
    If wsReport Is Nothing Then
        Set wsReport = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
        wsReport.Name = "Sunset Report"
    End If
    On Error GoTo 0

    wsReport.Cells.Clear

    ' Copy header
    ws.Rows(1).Copy wsReport.Rows(1)

    ' Copy sunset items
    Dim srcRow As Long, destRow As Long
    destRow = 2
    For srcRow = 2 To ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
        If ws.Cells(srcRow, 14).Value = "Sunset" Or ws.Cells(srcRow, 14).Value = "Immediate Exit" Then
            ws.Rows(srcRow).Copy wsReport.Rows(destRow)
            destRow = destRow + 1
        End If
    Next srcRow

    MsgBox destRow - 2 & " SKUs identified for sunset/exit.", vbInformation
End Sub
```

---

## Print Settings

| Sheet | Orientation | Scaling | Repeat Rows |
|-------|-------------|---------|-------------|
| Executive Summary | Landscape | Fit to 1 page | Row 1 |
| SKU Data | Landscape | Fit to 1 page wide | Rows 1-2 |
| Pareto Analysis | Landscape | Fit to 1 page wide | Rows 1-2 |
| Scoring Matrix | Landscape | Fit to 1 page wide | Rows 1-2 |
| Business Case | Portrait | Fit to 1 page | Row 1 |
| Timeline | Landscape | Fit to 1 page wide | Rows 1-2 |

---

## Document Properties

| Property | Value |
|----------|-------|
| Title | SKU Rationalization Analysis |
| Subject | Product Portfolio Optimization |
| Category | IBP Leader Toolkit - Product Review |
| Version | 2.0 Enhanced |
| Classification | Internal Use - Confidential |

---

*This specification defines the complete structure for the SKU Rationalization Analysis workbook. All formulas use standard Excel syntax compatible with Excel 2016+ and Microsoft 365.*
