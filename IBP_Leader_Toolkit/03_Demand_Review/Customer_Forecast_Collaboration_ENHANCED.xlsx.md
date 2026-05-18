# Customer Forecast Collaboration - Enterprise Excel Workbook
## 100 Customers × 4 SKUs | Advanced Statistical Forecasting | Scenario Planning

---

## Overview
Production-ready enterprise demand planning workbook designed for managing 100 strategic customers with 4 SKUs each (400 total customer-SKU combinations). Features advanced dynamic statistical forecasting methods, 36-month historical analysis, base/risk/opportunity scenario generation with probability weighting, and automated consensus demand workflow.

---

## Design Theme: "Enterprise Analytics"

| Element | Specification |
|---------|--------------|
| Primary Color | Navy (#1B2A4A) |
| Secondary Color | Teal (#0D9488) |
| Accent | Royal Blue (#2563EB) |
| Base Scenario | Slate (#475569) |
| Upside/Opportunity | Emerald (#059669) |
| Downside/Risk | Amber (#F59E0B) |
| Critical Risk | Red (#EF4444) |
| Font - Headers | Segoe UI Semibold, 11pt |
| Font - Body | Segoe UI, 10pt |
| Row Banding | White / Light Teal (#F0FDFA) |

---

# SHEET 1: CONFIGURATION & SETTINGS

## Purpose
Central configuration hub for all forecast parameters, customer tiers, and scenario definitions.

## Section A: Forecast Parameters (Row 3-15)

| Cell | Parameter | Value | Formula/Validation |
|------|-----------|-------|-------------------|
| B3 | Fiscal Year Start | 2026-01-01 | Date |
| B4 | Current Period | 2026-02 | `=TEXT(TODAY(),"YYYY-MM")` |
| B5 | Forecast Horizon (Months) | 18 | 12-24 range |
| B6 | Historical Depth (Months) | 36 | Fixed |
| B7 | Planning Level | Customer-SKU | Fixed |
| B8 | Base Currency | USD | Dropdown |
| B9 | Confidence Interval | 95% | 90%/95%/99% |
| B10 | Z-Score for CI | 1.96 | `=IF(B9=0.95,1.96,IF(B9=0.9,1.645,2.576))` |
| B11 | Outlier Threshold (σ) | 3.0 | 2.0-4.0 range |
| B12 | Smoothing Alpha (Level) | 0.3 | 0.1-0.5 |
| B13 | Smoothing Beta (Trend) | 0.1 | 0.05-0.3 |
| B14 | Smoothing Gamma (Season) | 0.2 | 0.1-0.4 |
| B15 | Min Periods for Stats | 12 | At least 12 months |

## Section B: Customer Tier Definitions (Row 18-24)

| Tier | Revenue Threshold | Collaboration Level | Forecast Method | Review Cycle |
|------|------------------|--------------------|-----------------| ------------|
| Platinum | ≥$10M | Joint Business Planning | Customer + Stat Blend | Weekly |
| Gold | $5M-$10M | Forecast Sharing | Customer Input + Stat | Bi-weekly |
| Silver | $1M-$5M | Basic Collaboration | Statistical + Overlay | Monthly |
| Bronze | <$1M | Transactional | Statistical Only | Monthly |

### Tier Threshold Formulas
```excel
B19: =10000000  ' Platinum threshold
B20: =5000000   ' Gold threshold
B21: =1000000   ' Silver threshold
B22: =0         ' Bronze (below Silver)
```

## Section C: Scenario Probability Weights (Row 27-33)

| Scenario | Default Probability | Description | Growth Factor |
|----------|-------------------|-------------|---------------|
| Base | 50% | Most likely outcome | 1.00 |
| Upside 1 | 15% | Moderate opportunity | 1.10 |
| Upside 2 | 5% | High opportunity | 1.20 |
| Downside 1 | 20% | Moderate risk | 0.90 |
| Downside 2 | 10% | High risk | 0.75 |

### Expected Value Formula
```excel
Expected_Forecast = (Base × 0.50) + (Upside1 × 0.15) + (Upside2 × 0.05) + (Downside1 × 0.20) + (Downside2 × 0.10)
```

## Section D: Statistical Model Definitions (Row 36-45)

| Model Code | Model Name | Best For | Parameters |
|-----------|-----------|----------|------------|
| SES | Simple Exponential Smoothing | Stable, no trend | α |
| DES | Double Exponential Smoothing | Linear trend | α, β |
| TES | Triple Exp (Holt-Winters) | Trend + Seasonality | α, β, γ |
| MA3 | 3-Month Moving Average | Short-term | Window=3 |
| MA6 | 6-Month Moving Average | Medium-term | Window=6 |
| WMA | Weighted Moving Average | Recent emphasis | Custom weights |
| LR | Linear Regression | Long-term trend | Least squares |
| CROSTON | Croston's Method | Intermittent demand | α for demand/interval |

---

# SHEET 2: CUSTOMER MASTER (100 Customers)

## Purpose
Complete customer database with tier classification and collaboration status.

## Column Layout

| Col | Header | Width | Type | Validation/Formula |
|-----|--------|-------|------|-------------------|
| A | Cust_ID | 10 | Text | Format: C001-C100 |
| B | Customer Name | 30 | Text | Required |
| C | Account Manager | 20 | Dropdown | Sales rep list |
| D | Region | 15 | Dropdown | NA/EMEA/APAC/LATAM |
| E | Industry | 15 | Dropdown | Industry list |
| F | Annual Revenue ($K) | 15 | Number | `=SUMIF(Sales_History!A:A,A3,Sales_History!Annual_Col)` |
| G | LTM Revenue ($K) | 15 | **Formula** | `=SUMIF(Sales_History!A:A,A3,Sales_History!LTM_Col)` |
| H | **Tier** | 10 | **Formula** | See below |
| I | YoY Growth % | 12 | **Formula** | `=(G3-F3)/F3` |
| J | Collaboration Level | 20 | Dropdown | JBP/Forecast Share/Basic/Transactional |
| K | Last JBP Meeting | 12 | Date | — |
| L | Days Since JBP | 10 | **Formula** | `=IF(K3="","Never",TODAY()-K3)` |
| M | Forecast Accuracy (LTM) | 12 | **Formula** | `=VLOOKUP(A3,Accuracy_Summary,2,FALSE)` |
| N | Bias (LTM) | 10 | **Formula** | `=VLOOKUP(A3,Accuracy_Summary,3,FALSE)` |
| O | Risk Score | 10 | **Formula** | See below |
| P | Opportunity Score | 12 | **Formula** | See below |
| Q | Priority Rank | 10 | **Formula** | `=RANK(F3,$F$3:$F$102,0)` |
| R | Active SKUs | 8 | **Formula** | `=COUNTIF(SKU_Master!A:A,A3)` |
| S | Status | 10 | Dropdown | Active/Watch/At Risk/New |
| T | Notes | 40 | Text | Free text |

### Tier Assignment Formula (Column H)
```excel
=IF(G3>=Settings!$B$19,"Platinum",
  IF(G3>=Settings!$B$20,"Gold",
    IF(G3>=Settings!$B$21,"Silver","Bronze")))
```

### Risk Score Formula (Column O)
```excel
=ROUND((IF(I3<-0.1,3,IF(I3<0,2,IF(I3<0.05,1,0))) +
  IF(M3<0.6,3,IF(M3<0.7,2,IF(M3<0.8,1,0))) +
  IF(L3>90,2,IF(L3>60,1,0))) / 8 * 100, 0)
```
*Score 0-100: Higher = More Risk*

### Opportunity Score Formula (Column P)
```excel
=ROUND((IF(I3>0.2,3,IF(I3>0.1,2,IF(I3>0.05,1,0))) +
  IF(H3="Bronze",2,IF(H3="Silver",1,0)) +
  IF(R3<4,1,0)) / 6 * 100, 0)
```
*Score 0-100: Higher = More Opportunity*

## Sample Data Structure (Rows 3-102: 100 Customers)

| Cust_ID | Customer Name | Region | Tier | Annual Rev |
|---------|--------------|--------|------|------------|
| C001 | GlobalTech Industries | NA | Platinum | $15,234 |
| C002 | EuroManufacturing GmbH | EMEA | Gold | $8,456 |
| C003 | Pacific Solutions Ltd | APAC | Gold | $6,789 |
| ... | ... | ... | ... | ... |
| C100 | SMB Enterprises LLC | NA | Bronze | $245 |

---

# SHEET 3: SKU MASTER (400 Customer-SKU Combinations)

## Purpose
Complete SKU database mapped to customers with product attributes.

## Column Layout

| Col | Header | Width | Formula/Validation |
|-----|--------|-------|-------------------|
| A | Cust_ID | 10 | Dropdown from Customer_Master |
| B | Customer Name | 25 | `=VLOOKUP(A3,Customer_Master!A:B,2,FALSE)` |
| C | SKU_ID | 12 | Format: SKU-XXXX |
| D | Cust_SKU_Key | 15 | `=A3&"-"&C3` (Unique key) |
| E | Product Name | 30 | Text |
| F | Product Family | 15 | Dropdown |
| G | Unit Price ($) | 12 | Number, ≥0 |
| H | Unit Cost ($) | 12 | Number, ≥0 |
| I | Margin % | 10 | `=(G3-H3)/G3` |
| J | Lifecycle Stage | 12 | Intro/Growth/Mature/Decline/EOL |
| K | Min Order Qty | 10 | Number |
| L | Lead Time (Days) | 10 | Number |
| M | Demand Pattern | 15 | **Auto-calculated** (see below) |
| N | Best Forecast Model | 12 | **Auto-calculated** |
| O | LTM Volume | 12 | `=SUMIF(Sales_History!D:D,D3,Sales_History!Volume_Col)` |
| P | LTM Revenue ($K) | 12 | `=O3*G3/1000` |
| Q | CV (Coeff Variation) | 10 | From Historical Analysis |
| R | Seasonality Index | 10 | From Seasonality Sheet |
| S | MAPE (Accuracy) | 10 | From Error Metrics |
| T | Status | 10 | Active/Discontinued/Pending |

### Demand Pattern Classification (Column M)
```excel
=IF(Q3="","Insufficient Data",
  IF(AND(Q3<0.5,R3<1.5),"Smooth",
    IF(AND(Q3>=0.5,R3<1.5),"Erratic",
      IF(AND(Q3<0.5,R3>=1.5),"Seasonal",
        "Lumpy"))))
```

### Best Model Selection (Column N)
```excel
=IF(M3="Smooth","SES",
  IF(M3="Erratic","WMA",
    IF(M3="Seasonal","TES",
      IF(M3="Lumpy","CROSTON","MA6"))))
```

## Sample Data (400 rows: 100 customers × 4 SKUs each)

| Cust_ID | SKU_ID | Cust_SKU_Key | Product | Family | Pattern |
|---------|--------|--------------|---------|--------|---------|
| C001 | SKU-0001 | C001-SKU-0001 | Premium Widget A | Widgets | Smooth |
| C001 | SKU-0002 | C001-SKU-0002 | Standard Widget B | Widgets | Seasonal |
| C001 | SKU-0003 | C001-SKU-0003 | Component X | Components | Erratic |
| C001 | SKU-0004 | C001-SKU-0004 | Service Pack S | Services | Smooth |
| C002 | SKU-0001 | C002-SKU-0001 | Premium Widget A | Widgets | Smooth |
| ... | ... | ... | ... | ... | ... |

---

# SHEET 4: HISTORICAL SALES DATA (36 Months)

## Purpose
36-month transaction history for statistical analysis.

## Column Layout

| Col | Header | Description |
|-----|--------|-------------|
| A | Cust_ID | Customer ID |
| B | Customer Name | Lookup |
| C | SKU_ID | SKU ID |
| D | Cust_SKU_Key | `=A3&"-"&C3` |
| E | Product Name | Lookup |
| F-AO | M-36 through M-1 | 36 monthly columns (Units) |
| AP | LTM Total | `=SUM(AD3:AO3)` (last 12 months) |
| AQ | PY Total | `=SUM(R3:AC3)` (prior year) |
| AR | 2Y Total | `=SUM(F3:Q3)` (2 years ago) |
| AS | Avg Monthly | `=AVERAGE(F3:AO3)` |
| AT | Std Dev | `=STDEV(F3:AO3)` |
| AU | CV | `=AT3/AS3` |
| AV | Non-Zero Months | `=COUNTIF(F3:AO3,">"&0)` |
| AW | Max Month | `=MAX(F3:AO3)` |
| AX | Min Month (Non-Zero) | `=MINIFS(F3:AO3,F3:AO3,">"&0)` |
| AY | Trend Slope | `=SLOPE(F3:AO3,ROW(F3:AO3))` |
| AZ | Trend Direction | `=IF(AY3>0.05*AS3,"Increasing",IF(AY3<-0.05*AS3,"Decreasing","Stable"))` |

### Outlier Detection (Conditional Formatting)
For each data cell F3:AO402:
```excel
Condition: =ABS(F3-$AS3)/$AT3 > Settings!$B$11
Format: Red background (#FEE2E2), Bold
```

---

# SHEET 5: STATISTICAL FORECAST ENGINE

## Purpose
Advanced multi-model statistical forecasting with dynamic model selection.

## Section A: Forecast Configuration Per Customer-SKU

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | From SKU Master |
| B | Customer | Lookup |
| C | SKU | Lookup |
| D | Pattern | `=VLOOKUP(A3,SKU_Master!D:M,10,FALSE)` |
| E | Selected Model | `=VLOOKUP(A3,SKU_Master!D:N,11,FALSE)` |
| F | Override Model | Dropdown (optional manual override) |
| G | Active Model | `=IF(F3<>"",F3,E3)` |
| H | Alpha (α) | `=IF(G3="SES",Settings!$B$12,IF(G3="DES",Settings!$B$12,IF(G3="TES",Settings!$B$12,0)))` |
| I | Beta (β) | `=IF(OR(G3="DES",G3="TES"),Settings!$B$13,0)` |
| J | Gamma (γ) | `=IF(G3="TES",Settings!$B$14,0)` |

## Section B: Model Calculations (Columns K-AB)

### Simple Exponential Smoothing (SES)
```excel
Level_t = α × Actual_t + (1-α) × Level_(t-1)
Forecast_(t+h) = Level_t
```

**Excel Implementation:**
```excel
K3 (Level): =H3*Historical!AO3 + (1-H3)*K2
L3 (Forecast M1): =K3
M3 (Forecast M2): =K3
... through AA3 (Forecast M18)
```

### Double Exponential Smoothing (DES - Holt's)
```excel
Level_t = α × Actual_t + (1-α) × (Level_(t-1) + Trend_(t-1))
Trend_t = β × (Level_t - Level_(t-1)) + (1-β) × Trend_(t-1)
Forecast_(t+h) = Level_t + h × Trend_t
```

**Excel Implementation:**
```excel
K3 (Level): =H3*Historical!AO3 + (1-H3)*(K2+L2)
L3 (Trend): =I3*(K3-K2) + (1-I3)*L2
M3 (Fcst M1): =K3 + 1*L3
N3 (Fcst M2): =K3 + 2*L3
... through AB3 (Fcst M18)
```

### Triple Exponential Smoothing (TES - Holt-Winters)
```excel
Level_t = α × (Actual_t / Season_(t-s)) + (1-α) × (Level_(t-1) + Trend_(t-1))
Trend_t = β × (Level_t - Level_(t-1)) + (1-β) × Trend_(t-1)
Season_t = γ × (Actual_t / Level_t) + (1-γ) × Season_(t-s)
Forecast_(t+h) = (Level_t + h × Trend_t) × Season_(t+h-s)
```

**Excel Implementation:**
```excel
K3 (Level): =H3*(Historical!AO3/Seasonality!L3) + (1-H3)*(K2+L2)
L3 (Trend): =I3*(K3-K2) + (1-I3)*L2
M3 (Season): =J3*(Historical!AO3/K3) + (1-J3)*Seasonality!L3
N3 (Fcst M1): =(K3 + 1*L3) * INDEX(Seasonality!$D$3:$O$3,MOD(MONTH(TODAY()),12)+1)
... through AC3 (Fcst M18)
```

### Moving Average (MA3, MA6)
```excel
MA3: =AVERAGE(Historical!AM3:AO3)  ' Last 3 months
MA6: =AVERAGE(Historical!AJ3:AO3)  ' Last 6 months
```

### Weighted Moving Average (WMA)
```excel
Weights: 0.5, 0.3, 0.2 (most recent to oldest)
WMA: =SUMPRODUCT(Historical!AM3:AO3, {0.2, 0.3, 0.5})
```

### Linear Regression (LR)
```excel
=FORECAST(Future_Period, Historical!F3:AO3, ROW(F3:AO3))
' Or using LINEST for slope/intercept
Intercept: =INDEX(LINEST(Historical!F3:AO3,{1,2,...,36}),1,2)
Slope: =INDEX(LINEST(Historical!F3:AO3,{1,2,...,36}),1,1)
Forecast_t: =Intercept + Slope × (36 + t)
```

### Croston's Method (For Intermittent Demand)
```excel
Demand_Level = α × Actual_t (when demand occurs) + (1-α) × Demand_Level_(t-1)
Interval = α × Period_Since_Last_Demand + (1-α) × Interval_(t-1)
Forecast = Demand_Level / Interval
```

## Section C: Forecast Output (Columns AD-AU)

| Col | Header | Formula |
|-----|--------|---------|
| AD-AU | M1 through M18 | Selected model output |
| AV | Annual Fcst (Next 12M) | `=SUM(AD3:AO3)` |
| AW | Std Error | `=STDEV(Forecast_History - Actual_History)` |
| AX | Lower CI | `=AV3 - Settings!$B$10 * AW3 * SQRT(12)` |
| AY | Upper CI | `=AV3 + Settings!$B$10 * AW3 * SQRT(12)` |
| AZ | MAPE | `=AVERAGEIF(Actual_History,">"&0,ABS(Fcst-Actual)/Actual)` |
| BA | Bias | `=(SUM(Fcst_History)-SUM(Actual_History))/SUM(Actual_History)` |

---

# SHEET 6: SEASONALITY INDICES

## Purpose
Monthly seasonality factors per Customer-SKU for Holt-Winters and overlay adjustments.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Key |
| B | Customer | Lookup |
| C | SKU | Lookup |
| D-O | Jan through Dec Index | Monthly seasonal index |
| P | Seasonal Amplitude | `=MAX(D3:O3)/MIN(D3:O3)` |
| Q | Is Seasonal? | `=IF(P3>1.3,"Yes","No")` |
| R | Peak Month | `=TEXT(DATE(2026,MATCH(MAX(D3:O3),D3:O3,0),1),"MMM")` |
| S | Trough Month | `=TEXT(DATE(2026,MATCH(MIN(D3:O3),D3:O3,0),1),"MMM")` |

### Seasonal Index Calculation
```excel
For each month m (Jan=D, Feb=E, ... Dec=O):
D3 = AVERAGE of all January values in Historical / Overall Monthly Average

=AVERAGE(OFFSET(Historical!$F$3,ROW()-3,0,1,3)+OFFSET(Historical!$F$3,ROW()-3,12,1,3)+OFFSET(Historical!$F$3,ROW()-3,24,1,3)) /
 VLOOKUP(A3,Historical!$D:$AS,42,FALSE)
```

### Simplified Version
```excel
D3 (Jan Index): =SUMPRODUCT((Historical!$D$3:$D$402=A3)*(Historical!F$3:F$402)) /
                 SUMPRODUCT((Historical!$D$3:$D$402=A3)*(Historical!$AS$3:$AS$402)) / 3
```

---

# SHEET 7: SCENARIO GENERATOR

## Purpose
Generate Base, Upside, and Downside scenarios with probability weighting.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Key |
| B | Customer | Lookup |
| C | SKU | Lookup |
| D | Tier | `=VLOOKUP(LEFT(A3,4),Customer_Master!A:H,8,FALSE)` |
| E | **Base Forecast (Annual)** | `=VLOOKUP(A3,Stat_Forecast!A:AV,49,FALSE)` |
| F | **Probability - Base** | `=Settings!$B$28` (50%) |

### Upside Scenarios
| Col | Header | Formula |
|-----|--------|---------|
| G | Upside Factor 1 | `=Settings!$C$29` (1.10) |
| H | **Upside 1 Forecast** | `=E3 * G3` |
| I | Probability - Up1 | `=Settings!$B$29` (15%) |
| J | Upside Factor 2 | `=Settings!$C$30` (1.20) |
| K | **Upside 2 Forecast** | `=E3 * J3` |
| L | Probability - Up2 | `=Settings!$B$30` (5%) |

### Downside Scenarios
| Col | Header | Formula |
|-----|--------|---------|
| M | Downside Factor 1 | `=Settings!$C$31` (0.90) |
| N | **Downside 1 Forecast** | `=E3 * M3` |
| O | Probability - Down1 | `=Settings!$B$31` (20%) |
| P | Downside Factor 2 | `=Settings!$C$32` (0.75) |
| Q | **Downside 2 Forecast** | `=E3 * P3` |
| R | Probability - Down2 | `=Settings!$B$32` (10%) |

### Expected Value & Range
| Col | Header | Formula |
|-----|--------|---------|
| S | **Expected Value** | `=(E3*F3)+(H3*I3)+(K3*L3)+(N3*O3)+(Q3*R3)` |
| T | Variance | `=((E3-S3)^2*F3)+((H3-S3)^2*I3)+((K3-S3)^2*L3)+((N3-S3)^2*O3)+((Q3-S3)^2*R3)` |
| U | Std Dev | `=SQRT(T3)` |
| V | Range Low (5th Pct) | `=S3 - 1.645*U3` |
| W | Range High (95th Pct) | `=S3 + 1.645*U3` |
| X | Upside Potential | `=K3 - E3` (max upside - base) |
| Y | Downside Risk | `=E3 - Q3` (base - max downside) |
| Z | Risk/Reward Ratio | `=Y3/X3` (>1 means more risk than reward) |

### Scenario Summary Formulas
```excel
Total Base: =SUMIF(A:A,"<>",E:E)
Total Expected: =SUMIF(A:A,"<>",S:S)
Total Upside2: =SUMIF(A:A,"<>",K:K)
Total Downside2: =SUMIF(A:A,"<>",Q:Q)

Portfolio Risk: =SUMPRODUCT(Y3:Y402) / SUMPRODUCT(E3:E402)
Portfolio Opportunity: =SUMPRODUCT(X3:X402) / SUMPRODUCT(E3:E402)
```

---

# SHEET 8: RISK & OPPORTUNITY ANALYSIS

## Purpose
Detailed risk and opportunity identification with probability assessment.

## Section A: Risk Register

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Risk_ID | Auto: `="R-"&TEXT(ROW()-2,"000")` |
| B | Cust_SKU_Key | Dropdown or "Portfolio" |
| C | Customer | `=IF(B3="Portfolio","All",VLOOKUP(LEFT(B3,4),Customer_Master!A:B,2,FALSE))` |
| D | Risk Category | Dropdown: Demand/Market/Customer/Competitive/Operational/Economic |
| E | Risk Description | Text |
| F | Impact Type | Dropdown: Volume Decline/Price Pressure/Market Share Loss/Contract Loss |
| G | **Impact Value ($K)** | Number - potential revenue at risk |
| H | **Probability %** | Dropdown: 10%/25%/50%/75%/90% |
| I | **Expected Impact ($K)** | `=G3*H3` |
| J | Time Frame | Dropdown: Q1/Q2/Q3/Q4/H1/H2/FY |
| K | Likelihood Trend | Dropdown: Increasing/Stable/Decreasing |
| L | Mitigation Actions | Text |
| M | Mitigation Owner | Dropdown |
| N | Residual Probability | After mitigation |
| O | Residual Impact | `=G3*N3` |
| P | Risk Score | `=IF(H3>=0.5,3,IF(H3>=0.25,2,1)) * IF(G3>=1000,3,IF(G3>=500,2,1))` |
| Q | Priority | `=IF(P3>=6,"Critical",IF(P3>=4,"High",IF(P3>=2,"Medium","Low")))` |

## Section B: Opportunity Register

| Col | Header | Formula/Validation |
|-----|--------|-------------------|
| A | Opp_ID | Auto: `="O-"&TEXT(ROW()-2,"000")` |
| B | Cust_SKU_Key | Dropdown |
| C | Customer | Lookup |
| D | Opportunity Category | Dropdown: New Business/Expansion/Share Gain/New Product/Pricing/Market |
| E | Opportunity Description | Text |
| F | **Potential Value ($K)** | Number - additional revenue opportunity |
| G | **Probability %** | Dropdown |
| H | **Expected Value ($K)** | `=F3*G3` |
| I | Time to Realize | Dropdown: 0-3 Mo/3-6 Mo/6-12 Mo/12+ Mo |
| J | Confidence Level | Dropdown: High/Medium/Low |
| K | Actions Required | Text |
| L | Action Owner | Dropdown |
| M | Stage | Dropdown: Identified/Qualified/Pursuing/Committed |
| N | Pipeline Score | `=IF(M3="Committed",0.9,IF(M3="Pursuing",0.6,IF(M3="Qualified",0.3,0.1))) * G3` |
| O | Adjusted Expected | `=F3*N3` |

## Summary Metrics (Row 2)

| Metric | Formula |
|--------|---------|
| Total Risk Exposure | `=SUM(Risk!G:G)` |
| Expected Risk Impact | `=SUM(Risk!I:I)` |
| Mitigated Risk | `=SUM(Risk!I:I)-SUM(Risk!O:O)` |
| Total Opportunity | `=SUM(Opp!F:F)` |
| Expected Opportunity | `=SUM(Opp!H:H)` |
| Committed Pipeline | `=SUMIF(Opp!M:M,"Committed",Opp!F:F)` |
| Net Risk/Opp | `=Expected_Opp - Expected_Risk` |

---

# SHEET 9: CONSENSUS DEMAND WORKBOOK

## Purpose
Multi-input consensus building combining statistical, customer, sales, and market inputs.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Key |
| B | Customer | Lookup |
| C | Tier | Lookup |
| D | SKU | Lookup |
| E | **Statistical Baseline** | `=VLOOKUP(A3,Stat_Forecast!A:AV,49,FALSE)` |
| F | **Customer Input** | Manual or from JBP |
| G | Customer Input Date | Date |
| H | Customer Input Age (Days) | `=IF(G3="","No Input",TODAY()-G3)` |
| I | **Sales Input** | Manual from Account Manager |
| J | Sales Confidence | Dropdown: High/Medium/Low |
| K | **Marketing Input** | Manual - campaigns, launches |
| L | Marketing Adjustment Type | Dropdown: Promo/Launch/Campaign/None |
| M | **Risk Adjustment** | `=-SUMIF(Risk_Analysis!B:B,A3,Risk_Analysis!I:I)` |
| N | **Opportunity Adjustment** | `=SUMIF(Opp_Analysis!B:B,A3,Opp_Analysis!H:H)` |

### Consensus Calculation

| Col | Header | Formula |
|-----|--------|---------|
| O | Stat Weight | `=IF(C3="Platinum",0.2,IF(C3="Gold",0.3,IF(C3="Silver",0.5,0.7)))` |
| P | Customer Weight | `=IF(F3>0,IF(C3="Platinum",0.4,IF(C3="Gold",0.3,IF(C3="Silver",0.2,0))),0)` |
| Q | Sales Weight | `=IF(I3>0,IF(J3="High",0.3,IF(J3="Medium",0.2,0.1)),0)` |
| R | Remaining Weight | `=1-O3-P3-Q3` |
| S | **Blended Forecast** | `=E3*O3 + IF(F3>0,F3,E3)*P3 + IF(I3>0,I3,E3)*Q3 + E3*R3` |
| T | **Adjusted Forecast** | `=S3 + K3 + M3 + N3` |
| U | Change from Stat | `=T3-E3` |
| V | Change % | `=(T3-E3)/E3` |
| W | **Final Consensus** | `=T3` (or manual override) |
| X | Override? | `=IF(W3<>T3,"Yes","No")` |
| Y | Override Reason | Text if overridden |
| Z | Consensus Date | Date of finalization |
| AA | Approved By | Approver name |

### Value-Add Analysis

| Col | Header | Formula |
|-----|--------|---------|
| AB | Stat Accuracy (History) | `=VLOOKUP(A3,Error_Metrics!A:S,19,FALSE)` |
| AC | Customer Accuracy (History) | Historical customer forecast accuracy |
| AD | Sales Accuracy (History) | Historical sales input accuracy |
| AE | Best Input | `=IF(MAX(AB3:AD3)=AB3,"Statistical",IF(MAX(AB3:AD3)=AC3,"Customer","Sales"))` |
| AF | Value Added by Consensus | `=IF(Actual available, 1-ABS(Consensus-Actual)/Actual - (1-AB3), "Pending")` |

---

# SHEET 10: FORECAST DASHBOARD

## Purpose
Executive-level forecast summary with scenario analysis.

## KPI Tiles (Row 3-10)

| KPI | Formula | Conditional Format |
|-----|---------|-------------------|
| Total Base Forecast ($M) | `=SUM(Scenario!E:E)/1000` | — |
| Expected Value ($M) | `=SUM(Scenario!S:S)/1000` | — |
| Upside Potential ($M) | `=SUM(Scenario!X:X)/1000` | Green |
| Downside Risk ($M) | `=SUM(Scenario!Y:Y)/1000` | Red |
| YoY Growth % | `=(Base_Forecast-PY_Actual)/PY_Actual` | ≥5% Green |
| Forecast Accuracy (LTM) | `=1-AVERAGE(Error_Metrics!MAPE_Col)` | ≥75% Green |
| Forecast Bias | `=SUM(Error_Metrics!Bias_Col*Error_Metrics!Weight_Col)/SUM(Weight)` | ±3% Green |
| Active Risks (Count) | `=COUNTIF(Risk!H:H,">0.25")` | >10 Red |
| Committed Opportunities | `=SUMIF(Opp!M:M,"Committed",Opp!F:F)` | — |

## Scenario Comparison Table (Row 15+)

| Scenario | Annual Forecast | vs Base | Probability | Weighted |
|----------|----------------|---------|-------------|----------|
| Base | =SUM(E:E) | — | 50% | =B16*D16 |
| Upside 1 (+10%) | =SUM(H:H) | +10% | 15% | =B17*D17 |
| Upside 2 (+20%) | =SUM(K:K) | +20% | 5% | =B18*D18 |
| Downside 1 (-10%) | =SUM(N:N) | -10% | 20% | =B19*D19 |
| Downside 2 (-25%) | =SUM(Q:Q) | -25% | 10% | =B20*D20 |
| **Expected Value** | =SUM(E16:E20) | | 100% | |

## Customer Tier Summary

| Tier | Customers | Base Forecast | Expected | Risk Exposure | Opportunity |
|------|-----------|---------------|----------|---------------|-------------|
| Platinum | `=COUNTIF(H:H,"Platinum")` | `=SUMIF(H:H,"Platinum",E:E)` | ... | ... | ... |
| Gold | `=COUNTIF(H:H,"Gold")` | ... | ... | ... | ... |
| Silver | `=COUNTIF(H:H,"Silver")` | ... | ... | ... | ... |
| Bronze | `=COUNTIF(H:H,"Bronze")` | ... | ... | ... | ... |

---

# SHEET 11: ERROR METRICS & ACCURACY

## Purpose
Track forecast accuracy at customer-SKU level for model improvement.

## Column Layout

| Col | Header | Formula |
|-----|--------|---------|
| A | Cust_SKU_Key | Key |
| B | Customer | Lookup |
| C | SKU | Lookup |
| D | Tier | Lookup |
| E | M-12 Forecast | Historical forecast |
| F | M-12 Actual | Historical actual |
| G | APE M-12 | `=IF(F3>0,ABS(E3-F3)/F3,"N/A")` |
| ... | (M-11 through M-1) | Same structure |
| S | MAPE (12 Mo) | `=AVERAGE(G3,I3,K3,M3,O3,Q3,...)` (12 month average) |
| T | Weighted MAPE | `=SUMPRODUCT(APE_Range, Actual_Range)/SUM(Actual_Range)` |
| U | Bias % | `=SUM(Forecast_Range-Actual_Range)/SUM(Actual_Range)` |
| V | Tracking Signal | `=SUM(Forecast-Actual)/AVERAGE(ABS(Forecast-Actual))` |
| W | Signal Status | `=IF(ABS(V3)>4,"OUT OF CONTROL",IF(ABS(V3)>3,"WARNING","OK"))` |
| X | Accuracy | `=1-S3` |
| Y | Accuracy Grade | `=IF(X3>=0.85,"A",IF(X3>=0.75,"B",IF(X3>=0.65,"C",IF(X3>=0.50,"D","F"))))` |
| Z | Model Used | From Stat Forecast sheet |
| AA | Model Change Recommended | `=IF(AND(X3<0.7,VLOOKUP(A3,Model_Comparison,Best_MAPE)<S3*0.9),"Yes","No")` |

---

# NAMED RANGES

| Name | Range | Purpose |
|------|-------|---------|
| CustomerMaster | Customer_Master!A3:T102 | 100 customer records |
| SKUMaster | SKU_Master!A3:T402 | 400 SKU records |
| Historical_Data | Sales_History!A3:AZ402 | 36-month history |
| Stat_Forecast | Statistical_Forecast!A3:BA402 | Statistical output |
| Scenario_Data | Scenarios!A3:Z402 | All scenarios |
| Risk_Register | Risk_Analysis!A3:Q100 | Risk log |
| Opportunity_Register | Opp_Analysis!A3:O100 | Opportunity log |
| Consensus_Demand | Consensus!A3:AF402 | Consensus data |
| Error_Metrics | Accuracy!A3:AA402 | Accuracy tracking |
| Expected_Value_Total | Dashboard!B5 | Portfolio expected value |
| Base_Forecast_Total | Dashboard!B3 | Portfolio base |
| Risk_Exposure | Dashboard!B7 | Total risk |
| Opportunity_Pipeline | Dashboard!B8 | Total opportunity |

---

# VBA AUTOMATION

```vba
' ========================================
' Module: ForecastEngine
' Purpose: Advanced statistical forecast automation
' ========================================

Option Explicit

Sub RunFullForecastCycle()
    ' Master routine to run complete forecast process
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    Call ClassifyDemandPatterns
    Call CalculateSeasonalIndices
    Call GenerateStatisticalForecasts
    Call RunScenarioGenerator
    Call CalculateExpectedValues
    Call RefreshDashboard

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True

    MsgBox "Forecast cycle complete for " & _
           WorksheetFunction.CountA(Range("CustomerMaster").Columns(1)) & _
           " customers and " & _
           WorksheetFunction.CountA(Range("SKUMaster").Columns(1)) & _
           " customer-SKU combinations.", _
           vbInformation, "Forecast Complete"
End Sub

Sub ClassifyDemandPatterns()
    ' Auto-classify demand patterns based on CV and seasonality
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("SKU_Master")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim cv As Double, seasonalRatio As Double
    Dim pattern As String, model As String

    For i = 3 To lastRow
        cv = ws.Cells(i, 17).Value ' CV column
        seasonalRatio = ws.Cells(i, 18).Value ' Seasonality ratio

        ' Pattern classification
        If cv < 0.5 And seasonalRatio < 1.5 Then
            pattern = "Smooth"
            model = "SES"
        ElseIf cv >= 0.5 And seasonalRatio < 1.5 Then
            pattern = "Erratic"
            model = "WMA"
        ElseIf cv < 0.5 And seasonalRatio >= 1.5 Then
            pattern = "Seasonal"
            model = "TES"
        Else
            pattern = "Lumpy"
            model = "CROSTON"
        End If

        ws.Cells(i, 13).Value = pattern
        ws.Cells(i, 14).Value = model
    Next i
End Sub

Sub GenerateStatisticalForecasts()
    ' Generate forecasts using selected model per SKU
    Dim wsFcst As Worksheet, wsHist As Worksheet
    Set wsFcst = ThisWorkbook.Sheets("Statistical_Forecast")
    Set wsHist = ThisWorkbook.Sheets("Sales_History")

    Dim lastRow As Long
    lastRow = wsFcst.Cells(wsFcst.Rows.Count, "A").End(xlUp).Row

    Dim model As String
    Dim alpha As Double, beta As Double, gamma As Double
    Dim level As Double, trend As Double
    Dim histData(1 To 36) As Double
    Dim forecast(1 To 18) As Double

    alpha = ThisWorkbook.Sheets("Settings").Range("B12").Value
    beta = ThisWorkbook.Sheets("Settings").Range("B13").Value
    gamma = ThisWorkbook.Sheets("Settings").Range("B14").Value

    For i = 3 To lastRow
        model = wsFcst.Cells(i, 7).Value ' Active model

        ' Load historical data
        For j = 1 To 36
            histData(j) = wsHist.Cells(i, j + 5).Value
        Next j

        Select Case model
            Case "SES"
                Call CalculateSES(histData, alpha, forecast, 18)
            Case "DES"
                Call CalculateDES(histData, alpha, beta, forecast, 18)
            Case "TES"
                Call CalculateTES(histData, alpha, beta, gamma, forecast, 18, i)
            Case "WMA"
                Call CalculateWMA(histData, forecast, 18)
            Case "MA6"
                Call CalculateMA(histData, 6, forecast, 18)
            Case "CROSTON"
                Call CalculateCroston(histData, alpha, forecast, 18)
            Case Else
                Call CalculateMA(histData, 3, forecast, 18)
        End Select

        ' Write forecasts to sheet
        For j = 1 To 18
            wsFcst.Cells(i, 29 + j).Value = Application.Max(0, forecast(j))
        Next j
    Next i
End Sub

Private Sub CalculateSES(histData() As Double, alpha As Double, _
                         forecast() As Double, horizon As Long)
    Dim level As Double
    Dim i As Long

    ' Initialize level with average of first 6 periods
    level = 0
    For i = 1 To 6
        level = level + histData(i)
    Next i
    level = level / 6

    ' Update level through history
    For i = 1 To 36
        level = alpha * histData(i) + (1 - alpha) * level
    Next i

    ' Generate forecasts
    For i = 1 To horizon
        forecast(i) = level
    Next i
End Sub

Private Sub CalculateDES(histData() As Double, alpha As Double, _
                         beta As Double, forecast() As Double, horizon As Long)
    Dim level As Double, trend As Double
    Dim prevLevel As Double
    Dim i As Long

    ' Initialize
    level = histData(1)
    trend = (histData(6) - histData(1)) / 5

    ' Update through history
    For i = 2 To 36
        prevLevel = level
        level = alpha * histData(i) + (1 - alpha) * (level + trend)
        trend = beta * (level - prevLevel) + (1 - beta) * trend
    Next i

    ' Generate forecasts
    For i = 1 To horizon
        forecast(i) = level + i * trend
    Next i
End Sub

Private Sub CalculateWMA(histData() As Double, forecast() As Double, horizon As Long)
    Dim wma As Double
    Dim weights(1 To 6) As Double
    Dim i As Long, j As Long

    ' Set weights (more recent = higher weight)
    weights(1) = 0.35
    weights(2) = 0.25
    weights(3) = 0.18
    weights(4) = 0.12
    weights(5) = 0.07
    weights(6) = 0.03

    ' Calculate WMA from last 6 periods
    wma = 0
    For j = 1 To 6
        wma = wma + histData(37 - j) * weights(j)
    Next j

    ' Apply to all forecast periods
    For i = 1 To horizon
        forecast(i) = wma
    Next i
End Sub

Sub RunScenarioGenerator()
    ' Generate all 5 scenarios based on probability settings
    Dim wsScen As Worksheet, wsSet As Worksheet
    Set wsScen = ThisWorkbook.Sheets("Scenarios")
    Set wsSet = ThisWorkbook.Sheets("Settings")

    Dim lastRow As Long
    lastRow = wsScen.Cells(wsScen.Rows.Count, "A").End(xlUp).Row

    Dim baseFcst As Double
    Dim up1Factor As Double, up2Factor As Double
    Dim dn1Factor As Double, dn2Factor As Double

    up1Factor = wsSet.Range("C29").Value
    up2Factor = wsSet.Range("C30").Value
    dn1Factor = wsSet.Range("C31").Value
    dn2Factor = wsSet.Range("C32").Value

    For i = 3 To lastRow
        baseFcst = wsScen.Cells(i, 5).Value

        ' Generate scenarios
        wsScen.Cells(i, 8).Value = baseFcst * up1Factor   ' Upside 1
        wsScen.Cells(i, 11).Value = baseFcst * up2Factor  ' Upside 2
        wsScen.Cells(i, 14).Value = baseFcst * dn1Factor  ' Downside 1
        wsScen.Cells(i, 17).Value = baseFcst * dn2Factor  ' Downside 2
    Next i
End Sub

Sub CalculateExpectedValues()
    ' Calculate probability-weighted expected values
    Dim wsScen As Worksheet
    Set wsScen = ThisWorkbook.Sheets("Scenarios")

    Dim lastRow As Long
    lastRow = wsScen.Cells(wsScen.Rows.Count, "A").End(xlUp).Row

    For i = 3 To lastRow
        ' Expected Value = Sum of (Scenario × Probability)
        wsScen.Cells(i, 19).Value = _
            wsScen.Cells(i, 5).Value * wsScen.Cells(i, 6).Value + _
            wsScen.Cells(i, 8).Value * wsScen.Cells(i, 9).Value + _
            wsScen.Cells(i, 11).Value * wsScen.Cells(i, 12).Value + _
            wsScen.Cells(i, 14).Value * wsScen.Cells(i, 15).Value + _
            wsScen.Cells(i, 17).Value * wsScen.Cells(i, 18).Value
    Next i
End Sub

Sub RefreshDashboard()
    ' Recalculate dashboard KPIs
    ThisWorkbook.Sheets("Dashboard").Calculate
    MsgBox "Dashboard refreshed.", vbInformation
End Sub
```

---

# INTEGRATION POINTS

| Workbook | Integration | Method |
|----------|-------------|--------|
| Consensus_Demand_ENHANCED | Statistical baseline input | Named range Stat_Forecast |
| Forecast_Accuracy_ENHANCED | Error metrics feed | Named range Error_Metrics |
| Bias_Analysis_ENHANCED | Bias tracking | Named range Consensus_Demand |
| Capacity_Planning_ENHANCED | Demand input | Named range Expected_Value_Total |
| Supply_Constraints_ENHANCED | Risk/opportunity feed | Named range Risk_Register |
| Executive_Dashboard_ENHANCED | KPI summary | Named range Dashboard metrics |
| IBP_Master_Integration | Central hub | Power Query connection |

---

*Enterprise-grade demand forecasting engine for 100 customers × 4 SKUs with advanced statistical methods, scenario analysis, and probability-weighted expected values.*
