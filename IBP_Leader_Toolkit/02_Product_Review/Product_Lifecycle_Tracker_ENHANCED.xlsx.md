# Product Lifecycle Tracker - Enhanced Excel Workbook

## Overview
Comprehensive product lifecycle management workbook tracking products from introduction through end-of-life, with auto-calculated stage recommendations, revenue projections, and portfolio health scoring. Integrates with Portfolio Health Dashboard and NPI Pipeline Tracker.

---

## Design Theme: "Deep Horizon"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1E3A5F) |
| Secondary Color | Amber (#F59E0B) |
| Accent | Teal (#0D9488) |
| Success | Emerald (#059669) |
| Warning | Orange (#F97316) |
| Critical | Red (#EF4444) |
| Font - Headers | Segoe UI Semibold, 11pt |
| Font - Body | Segoe UI, 10pt |
| Gridlines | Light gray (#E5E7EB), thin |
| Row Banding | Alternating White / Light Blue (#F0F9FF) |

---

## Sheet 1: Settings & Configuration

### Purpose
Central configuration for lifecycle stage definitions, transition criteria, and planning parameters.

### Layout

| Row | A | B | C | D |
|-----|---|---|---|---|
| 1 | **PRODUCT LIFECYCLE SETTINGS** | | | |
| 3 | **Company** | [Company Name] | | |
| 4 | **Fiscal Year Start** | [Date] | | |
| 5 | **Last Updated** | [Date] | | |
| 7 | **LIFECYCLE STAGE DEFINITIONS** | | | |
| 8 | Stage | Description | Typical Duration (Months) | Revenue Characteristic |
| 9 | Introduction | New product launch phase | 6-18 | Rapidly growing |
| 10 | Growth | Market adoption accelerating | 12-36 | Strong growth |
| 11 | Maturity | Stable market position | 24-60+ | Stable/slow growth |
| 12 | Decline | Market share erosion | 12-24 | Declining |
| 13 | End of Life | Planned sunset | 6-12 | Minimal/zero |

### Transition Criteria Table (Row 16+)

| Stage Transition | Revenue Trend | Growth Rate | Market Share | Auto-Trigger |
|-----------------|---------------|-------------|-------------|--------------|
| Intro → Growth | 3 months consecutive growth | >15% QoQ | Gaining | All criteria met |
| Growth → Maturity | Growth decelerating | <5% QoQ | Stable | 2 of 3 criteria |
| Maturity → Decline | Revenue declining | Negative | Losing | 2 of 3 criteria |
| Decline → EOL | Below threshold | <-10% QoQ | <2% | Management decision |

### Planning Parameters by Stage (Row 25+)

| Parameter | Introduction | Growth | Maturity | Decline | EOL |
|-----------|-------------|--------|----------|---------|-----|
| Safety Stock Factor | 1.5x | 1.2x | 1.0x | 0.8x | 0.5x |
| Forecast Method | Analog/Judgmental | Trend + Expert | Statistical | Statistical | Order-based |
| Review Frequency | Weekly | Bi-weekly | Monthly | Monthly | Weekly |
| Inventory Policy | Build ahead | Lean replenish | Min/Max | Run down | No replenish |
| Marketing Spend % | High (15%) | Medium (10%) | Low (5%) | Minimal (2%) | Zero |

---

## Sheet 2: Lifecycle Dashboard

### Purpose
Executive view of portfolio lifecycle health with auto-calculated metrics.

### KPI Tiles (Row 3-7)

| KPI | Formula | Conditional Formatting |
|-----|---------|----------------------|
| Total Active Products | `=COUNTA(Product_Detail!A3:A5000)-COUNTIF(Product_Detail!F3:F5000,"Discontinued")` | — |
| Portfolio Vitality Index | `=SUMIFS(Product_Detail!H3:H5000,Product_Detail!F3:F5000,"Introduction",Product_Detail!H3:H5000,">"&0)+SUMIFS(Product_Detail!H3:H5000,Product_Detail!F3:F5000,"Growth",Product_Detail!H3:H5000,">"&0))/SUM(Product_Detail!H3:H5000)` | ≥25% GREEN, 15-25% YELLOW, <15% RED |
| Avg Product Age (Months) | `=AVERAGE(Product_Detail!J3:J5000)` | — |
| Products in Decline/EOL | `=COUNTIF(Product_Detail!F3:F5000,"Decline")+COUNTIF(Product_Detail!F3:F5000,"End of Life")` | >20% of total = RED |
| Revenue at Risk (Decline) | `=SUMIFS(Product_Detail!H3:H5000,Product_Detail!F3:F5000,"Decline")+SUMIFS(Product_Detail!H3:H5000,Product_Detail!F3:F5000,"End of Life")` | — |

### Stage Distribution Summary (Row 10-16)

| Column | A | B | C | D | E |
|--------|---|---|---|---|---|
| Header | Stage | SKU Count | Revenue ($M) | % of Revenue | Avg Margin % |
| Formula | — | `=COUNTIF(Product_Detail!F:F,A11)` | `=SUMIF(Product_Detail!F:F,A11,Product_Detail!H:H)/1000` | `=C11/SUM(C$11:C$15)` | `=AVERAGEIF(Product_Detail!F:F,A11,Product_Detail!I:I)` |

### Conditional Formatting
- Vitality Index cell: `≥0.25` → Background #059669 (green), `0.15-0.25` → #F59E0B (amber), `<0.15` → #EF4444 (red)
- Stage count: Decline/EOL rows highlighted with light red (#FEF2F2) background

---

## Sheet 3: Product Detail

### Purpose
Master product lifecycle data with auto-calculated fields.

### Column Layout

| Col | Header | Width | Type | Validation/Formula |
|-----|--------|-------|------|-------------------|
| A | SKU Code | 15 | Text | Required, unique |
| B | Product Name | 30 | Text | Required |
| C | Product Family | 20 | Dropdown | List from Settings!B30:B50 |
| D | Launch Date | 12 | Date | Must be valid date |
| E | Current Stage | 15 | Dropdown | Introduction/Growth/Maturity/Decline/End of Life |
| F | Status | 12 | Dropdown | Active/Discontinued/Pending Launch |
| G | Annual Volume (Units) | 15 | Number | ≥0 |
| H | Annual Revenue ($K) | 15 | Number | ≥0 |
| I | Gross Margin % | 12 | Percentage | 0-100% |
| J | Age (Months) | 12 | **Formula** | `=DATEDIF(D3,TODAY(),"M")` |
| K | Revenue Trend (QoQ) | 15 | **Formula** | `=IF(AND(Q3>0,P3>0),(Q3-P3)/P3,"N/A")` |
| L | 3-Month Revenue Avg | 15 | **Formula** | `=AVERAGE(O3:Q3)` |
| M | Recommended Stage | 15 | **Formula** | See below |
| N | Stage Match? | 10 | **Formula** | `=IF(E3=M3,"✓","⚠ REVIEW")` |
| O | Month -3 Revenue | 12 | Number | Manual input |
| P | Month -2 Revenue | 12 | Number | Manual input |
| Q | Month -1 Revenue | 12 | Number | Manual input |
| R | Customer Count | 10 | Number | ≥0 |
| S | Last Order Date | 12 | Date | — |
| T | Days Since Last Order | 12 | **Formula** | `=IF(S3="","N/A",TODAY()-S3)` |

### Recommended Stage Formula (Column M)

```excel
=IF(F3="Discontinued","N/A",
  IF(J3<=Settings!$C$9,
    IF(K3>0.15,"Growth","Introduction"),
    IF(AND(J3>Settings!$C$9,K3>0.05),"Growth",
      IF(AND(K3>=-0.02,K3<=0.05),"Maturity",
        IF(K3<-0.02,"Decline","Maturity")))))
```

### Conditional Formatting Rules

| Rule | Range | Format |
|------|-------|--------|
| Stage = Introduction | E:E | Background #DBEAFE (light blue) |
| Stage = Growth | E:E | Background #D1FAE5 (light green) |
| Stage = Maturity | E:E | Background #FEF3C7 (light amber) |
| Stage = Decline | E:E | Background #FEE2E2 (light red) |
| Stage = End of Life | E:E | Background #F3F4F6 (gray) |
| Stage mismatch (N col) | N:N | "⚠ REVIEW" → Bold red text, yellow background |
| Margin < 15% | I:I | Red text |
| Days since order > 180 | T:T | Red background |

---

## Sheet 4: Stage Transition Log

### Purpose
Audit trail of all product stage transitions.

### Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Date | Date validated |
| B | SKU Code | Dropdown from Product_Detail!A:A |
| C | Product Name | `=VLOOKUP(B3,Product_Detail!A:B,2,FALSE)` |
| D | Previous Stage | Dropdown: lifecycle stages |
| E | New Stage | Dropdown: lifecycle stages |
| F | Criteria Met | Multi-select or text |
| G | Approved By | Text |
| H | Rationale | Text |
| I | Revenue at Transition | `=VLOOKUP(B3,Product_Detail!A:H,8,FALSE)` |
| J | Days in Previous Stage | `=A3-VLOOKUP(B3&D3,Transition_Lookup,2,FALSE)` |

---

## Sheet 5: Revenue Projection

### Purpose
Forward-looking revenue projection by product using lifecycle stage growth rates.

### Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | From Product_Detail |
| B | Product Name | `=VLOOKUP(A3,Product_Detail!A:B,2,FALSE)` |
| C | Current Stage | `=VLOOKUP(A3,Product_Detail!A:E,5,FALSE)` |
| D | Current Annual Revenue | `=VLOOKUP(A3,Product_Detail!A:H,8,FALSE)` |
| E | Growth Rate Applied | `=VLOOKUP(C3,Settings!A30:B35,2,FALSE)` |
| F | Year 1 Projected | `=D3*(1+E3)` |
| G | Year 2 Projected | `=F3*(1+E3*0.9)` (deceleration factor) |
| H | Year 3 Projected | `=G3*(1+E3*0.8)` |
| I | 3-Year Cumulative | `=SUM(F3:H3)` |

### Growth Rate Lookup (from Settings)

| Stage | Default Growth Rate |
|-------|-------------------|
| Introduction | +25% |
| Growth | +15% |
| Maturity | +2% |
| Decline | -10% |
| End of Life | -50% |

---

## Sheet 6: End-of-Life Management

### Purpose
Track products approaching or in end-of-life phase.

### Column Layout

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | SKU Code | Filtered: Stage = Decline or EOL |
| B | Product Name | `=VLOOKUP(A3,Product_Detail!A:B,2,FALSE)` |
| C | EOL Decision Date | Date |
| D | Last Ship Date | Date |
| E | Days Remaining | `=MAX(0,D3-TODAY())` |
| F | Remaining Inventory (Units) | Number |
| G | Remaining Inventory ($K) | Number |
| H | Expected Recovery Rate % | Percentage, default 40% |
| I | Expected Recovery ($K) | `=G3*H3` |
| J | Write-off Amount ($K) | `=G3-I3` |
| K | Affected Customers | Number |
| L | Replacement Product | Dropdown from Product_Detail |
| M | Migration Status | Dropdown: Not Started/In Progress/Complete |
| N | Migration % Complete | `=IF(M3="Complete",100%,IF(M3="In Progress",[manual],0))` |

### Conditional Formatting
- Days Remaining <30: RED background
- Days Remaining 30-90: YELLOW background
- Migration Not Started with <60 days: RED text, bold

---

## Sheet 7: Product Family View

### Purpose
Aggregated view by product family with health scoring.

### Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Product Family | Unique list |
| B | Total SKUs | `=COUNTIF(Product_Detail!C:C,A3)` |
| C | Active SKUs | `=COUNTIFS(Product_Detail!C:C,A3,Product_Detail!F:F,"Active")` |
| D | Total Revenue ($K) | `=SUMIF(Product_Detail!C:C,A3,Product_Detail!H:H)` |
| E | Avg Margin % | `=AVERAGEIF(Product_Detail!C:C,A3,Product_Detail!I:I)` |
| F | Vitality Index | `=SUMIFS(Product_Detail!H:H,Product_Detail!C:C,A3,Product_Detail!J:J,"<="&36)/D3` |
| G | % in Decline/EOL | `=(COUNTIFS(Product_Detail!C:C,A3,Product_Detail!E:E,"Decline")+COUNTIFS(Product_Detail!C:C,A3,Product_Detail!E:E,"End of Life"))/B3` |
| H | Family Health Score | `=F3*0.3+(1-G3)*0.3+E3*0.2+(C3/B3)*0.2` |
| I | Health Rating | `=IF(H3>=0.7,"Strong",IF(H3>=0.5,"Moderate",IF(H3>=0.3,"Weak","Critical")))` |

### Conditional Formatting
- Health ≥0.7: GREEN
- Health 0.5-0.7: YELLOW
- Health <0.5: RED

---

## Sheet 8: Planning Parameters

### Purpose
Auto-looked-up planning parameters based on product lifecycle stage.

### Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | SKU Code | From Product_Detail |
| B | Product Name | `=VLOOKUP(A3,Product_Detail!A:B,2,FALSE)` |
| C | Stage | `=VLOOKUP(A3,Product_Detail!A:E,5,FALSE)` |
| D | Safety Stock Factor | `=INDEX(Settings!$B$26:$F$26,MATCH(C3,Settings!$B$25:$F$25,0))` |
| E | Forecast Method | `=INDEX(Settings!$B$27:$F$27,MATCH(C3,Settings!$B$25:$F$25,0))` |
| F | Review Frequency | `=INDEX(Settings!$B$28:$F$28,MATCH(C3,Settings!$B$25:$F$25,0))` |
| G | Inventory Policy | `=INDEX(Settings!$B$29:$F$29,MATCH(C3,Settings!$B$25:$F$25,0))` |
| H | Marketing Spend % | `=INDEX(Settings!$B$30:$F$30,MATCH(C3,Settings!$B$25:$F$25,0))` |

---

## Named Ranges

| Name | Reference | Purpose |
|------|-----------|---------|
| PLC_Product_Data | Product_Detail!A:T | Full product data |
| PLC_Stage_Col | Product_Detail!E:E | Stage column |
| PLC_Revenue_Col | Product_Detail!H:H | Revenue column |
| PLC_Vitality_Index | Dashboard!B5 | Portfolio vitality |
| PLC_Decline_Revenue | Dashboard!B7 | Revenue at risk |
| PLC_Family_Health | Family_View!A:I | Family health data |
| PLC_EOL_Products | EOL_Management!A:N | EOL tracking |
| PLC_Planning_Params | Planning_Parameters!A:H | Planning lookups |

---

## Integration Points

| Workbook | Integration | Method |
|----------|-------------|--------|
| Portfolio_Health_Dashboard_ENHANCED | Feed stage distribution and vitality | Named range PLC_Vitality_Index |
| NPI_Pipeline_Tracker_ENHANCED | New products entering Introduction | Named range PLC_Product_Data |
| SKU_Rationalization_ENHANCED | Decline/EOL products for rationalization | Named range PLC_Decline_Revenue |
| Capacity_Planning_ENHANCED | Planning parameters by stage | Named range PLC_Planning_Params |
| Forecast_Accuracy_ENHANCED | Forecast method by stage | Named range PLC_Planning_Params |
| IBP_Master_Integration | Central hub connection | Power Query refresh |

---

## VBA Automation

```vba
Sub AutoUpdateStageRecommendations()
    ' Highlights products where current stage doesn't match recommended
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Product_Detail")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim mismatchCount As Long
    mismatchCount = 0

    For i = 3 To lastRow
        If ws.Cells(i, 14).Value = "⚠ REVIEW" Then
            ws.Cells(i, 14).Interior.Color = RGB(254, 243, 199)
            ws.Cells(i, 14).Font.Color = RGB(234, 88, 12)
            ws.Cells(i, 14).Font.Bold = True
            mismatchCount = mismatchCount + 1
        Else
            ws.Cells(i, 14).Interior.ColorIndex = xlNone
            ws.Cells(i, 14).Font.Color = RGB(5, 150, 105)
        End If
    Next i

    MsgBox mismatchCount & " products have stage mismatch recommendations.", _
        vbInformation, "Stage Review"
End Sub

Sub GenerateEOLReport()
    ' Auto-filters products into EOL sheet
    Dim wsSource As Worksheet, wsDest As Worksheet
    Set wsSource = ThisWorkbook.Sheets("Product_Detail")
    Set wsDest = ThisWorkbook.Sheets("EOL_Management")

    ' Clear existing data
    wsDest.Range("A3:N5000").ClearContents

    Dim destRow As Long
    destRow = 3
    Dim lastRow As Long
    lastRow = wsSource.Cells(wsSource.Rows.Count, "A").End(xlUp).Row

    For i = 3 To lastRow
        If wsSource.Cells(i, 5).Value = "Decline" Or _
           wsSource.Cells(i, 5).Value = "End of Life" Then
            wsDest.Cells(destRow, 1).Value = wsSource.Cells(i, 1).Value
            destRow = destRow + 1
        End If
    Next i

    MsgBox (destRow - 3) & " products added to EOL Management.", _
        vbInformation, "EOL Report"
End Sub
```

---

## Data Validation Rules

| Field | Validation | Error Message |
|-------|-----------|---------------|
| SKU Code | No duplicates in column | "Duplicate SKU code detected" |
| Launch Date | Must be ≤ TODAY() for active products | "Launch date cannot be in the future" |
| Current Stage | List: Introduction,Growth,Maturity,Decline,End of Life | "Select valid lifecycle stage" |
| Status | List: Active,Discontinued,Pending Launch | "Select valid status" |
| Product Family | List from Settings | "Select valid product family" |
| Gross Margin % | Between 0 and 1 | "Enter margin as decimal (0-1)" |
| Revenue | ≥ 0 | "Revenue must be non-negative" |

---

*Integration-ready workbook with automated stage tracking and portfolio health assessment.*
