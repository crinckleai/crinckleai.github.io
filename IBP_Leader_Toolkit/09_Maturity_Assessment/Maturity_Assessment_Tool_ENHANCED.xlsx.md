# IBP Maturity Assessment Tool - Enhanced Excel Workbook

## Workbook Overview

**Purpose:** Comprehensive assessment tool to evaluate IBP maturity across Process, People, Technology, and Performance dimensions with weighted scoring, multi-period tracking, and target gap analysis.

**File Name:** `Maturity_Assessment_Tool_ENHANCED.xlsx`

**Design Theme:**
- Primary Color: Navy (#1E3A5F)
- Secondary Color: White (#FFFFFF)
- Accent Color 1: Emerald (#10B981)
- Accent Color 2: Teal (#0D9488)
- Level Colors: Red (#DC2626) Level 1, Orange (#F59E0B) Level 2, Yellow (#EAB308) Level 3, Emerald (#10B981) Level 4, Teal (#0D9488) Level 5
- Font: Calibri for body, Calibri Light for headers

---

## Sheet 1: Dashboard

### Purpose
Executive summary view of overall IBP maturity with visual indicators, trend analysis, and dimension breakdown.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **IBP MATURITY ASSESSMENT DASHBOARD** | | | | | | Assessment Date: | =TODAY() |
| 2 | | | | | | | Assessed By: | [Input] |
| 3 | | | | | | | Version: | 1.0 |
| 4 | | | | | | | | |
| 5 | **OVERALL MATURITY** | | | **MATURITY LEVEL** | | | **TREND** | |
| 6 | Score: | =Calculations!B2 | /5.0 | =VLOOKUP(B6,MaturityLevels,2,TRUE) | | | vs Last: | =B6-PriorAssessments!B2 |
| 7 | | | | | | | | |
| 8 | **DIMENSION SCORES** | | | | | | | |
| 9 | Dimension | Weight | Score | Weighted | Level | Gap to Target | Target | Status |
| 10 | Process | 30% | =ProcessDimension!$B$50 | =B10*C10 | =VLOOKUP(C10,MaturityLevels,2,TRUE) | =G10-C10 | 4.0 | =IF(F10>1,"Critical",IF(F10>0.5,"Attention","On Track")) |
| 11 | People | 25% | =PeopleDimension!$B$40 | =B11*C11 | =VLOOKUP(C11,MaturityLevels,2,TRUE) | =G11-C11 | 4.0 | =IF(F11>1,"Critical",IF(F11>0.5,"Attention","On Track")) |
| 12 | Technology | 25% | =TechnologyDimension!$B$40 | =B12*C12 | =VLOOKUP(C12,MaturityLevels,2,TRUE) | =G12-C12 | 4.0 | =IF(F12>1,"Critical",IF(F12>0.5,"Attention","On Track")) |
| 13 | Performance | 20% | =PerformanceDimension!$B$45 | =B13*C13 | =VLOOKUP(C13,MaturityLevels,2,TRUE) | =G13-C13 | 4.0 | =IF(F13>1,"Critical",IF(F13>0.5,"Attention","On Track")) |
| 14 | **TOTAL** | 100% | =SUM(D10:D13) | | | =AVERAGE(F10:F13) | | |
| 15 | | | | | | | | |
| 16 | **MATURITY DISTRIBUTION** | | | | | | | |
| 17 | Level | Count | Percentage | | | | | |
| 18 | Level 1 - Initial | =COUNTIF(AllScores,1) | =B18/COUNTA(AllScores) | | | | | |
| 19 | Level 2 - Developing | =COUNTIF(AllScores,2) | =B19/COUNTA(AllScores) | | | | | |
| 20 | Level 3 - Integrated | =COUNTIF(AllScores,3) | =B20/COUNTA(AllScores) | | | | | |
| 21 | Level 4 - Advanced | =COUNTIF(AllScores,4) | =B21/COUNTA(AllScores) | | | | | |
| 22 | Level 5 - Leading | =COUNTIF(AllScores,5) | =B22/COUNTA(AllScores) | | | | | |
| 23 | | | | | | | | |
| 24 | **STRENGTHS (Top 3)** | | | **OPPORTUNITIES (Bottom 3)** | | | | |
| 25 | =INDEX(SubDimensions,MATCH(LARGE(SubDimensionScores,1),SubDimensionScores,0)) | =LARGE(SubDimensionScores,1) | | =INDEX(SubDimensions,MATCH(SMALL(SubDimensionScores,1),SubDimensionScores,0)) | =SMALL(SubDimensionScores,1) | | | |
| 26 | =INDEX(SubDimensions,MATCH(LARGE(SubDimensionScores,2),SubDimensionScores,0)) | =LARGE(SubDimensionScores,2) | | =INDEX(SubDimensions,MATCH(SMALL(SubDimensionScores,2),SubDimensionScores,0)) | =SMALL(SubDimensionScores,2) | | | |
| 27 | =INDEX(SubDimensions,MATCH(LARGE(SubDimensionScores,3),SubDimensionScores,0)) | =LARGE(SubDimensionScores,3) | | =INDEX(SubDimensions,MATCH(SMALL(SubDimensionScores,3),SubDimensionScores,0)) | =SMALL(SubDimensionScores,3) | | | |
| 28 | | | | | | | | |
| 29 | **ASSESSMENT HISTORY** | | | | | | | |
| 30 | Period | Overall | Process | People | Technology | Performance | Trend | |
| 31 | Current | =C14 | =C10 | =C11 | =C12 | =C13 | =IF(B31>B32,"Up","Down") | |
| 32 | Prior Q | =PriorAssessments!B2 | =PriorAssessments!C2 | =PriorAssessments!D2 | =PriorAssessments!E2 | =PriorAssessments!F2 | | |
| 33 | 2Q Ago | =PriorAssessments!B3 | =PriorAssessments!C3 | =PriorAssessments!D3 | =PriorAssessments!E3 | =PriorAssessments!F3 | | |
| 34 | 3Q Ago | =PriorAssessments!B4 | =PriorAssessments!C4 | =PriorAssessments!D4 | =PriorAssessments!E4 | =PriorAssessments!F4 | | |

### Conditional Formatting Rules

```
1. Overall Score (C14):
   - Rule: 3-Color Scale
   - Minimum: 1 (Red #DC2626)
   - Midpoint: 3 (Yellow #EAB308)
   - Maximum: 5 (Emerald #10B981)

2. Dimension Scores (C10:C13):
   - Rule: 3-Color Scale
   - Minimum: 1 (Red #DC2626)
   - Midpoint: 3 (Yellow #EAB308)
   - Maximum: 5 (Emerald #10B981)

3. Status Column (H10:H13):
   - Rule: Text Contains "Critical" -> Red fill (#FEE2E2), Red text (#DC2626)
   - Rule: Text Contains "Attention" -> Yellow fill (#FEF3C7), Orange text (#F59E0B)
   - Rule: Text Contains "On Track" -> Green fill (#D1FAE5), Green text (#10B981)

4. Gap to Target (F10:F13):
   - Rule: >1 -> Red fill
   - Rule: 0.5-1 -> Yellow fill
   - Rule: <0.5 -> Green fill

5. Trend Column (G6):
   - Rule: >0 -> Green up arrow
   - Rule: <0 -> Red down arrow
   - Rule: =0 -> Gray dash
```

### Charts

```
1. Radar Chart - Dimension Scores
   - Data: C10:C13
   - Labels: A10:A13
   - Position: I5:N20
   - Style: Filled radar with Navy outline

2. Bar Chart - Sub-Dimension Breakdown
   - Data: Sub-dimension scores from each dimension sheet
   - Position: I22:N35
   - Style: Horizontal bars, colored by dimension

3. Line Chart - Maturity Trend
   - Data: B31:B34
   - Position: O5:T15
   - Style: Line with markers, Navy color
```

---

## Sheet 2: ProcessDimension

### Purpose
Detailed assessment of Process maturity across Product, Demand, Supply, Financial, and Executive review sub-dimensions.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **PROCESS DIMENSION ASSESSMENT** | | | | | |
| 2 | Dimension Weight: 30% | | Target Level: | 4.0 | Current: | =B50 |
| 3 | | | | | | |
| 4 | **PRODUCT REVIEW SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 5 | Portfolio lifecycle management documented | [1-5] | 15% | =B5*C5 | [Notes] | =IF(B5<3,"Yes","No") |
| 6 | Stage-gate process with clear criteria | [1-5] | 15% | =B6*C6 | [Notes] | =IF(B6<3,"Yes","No") |
| 7 | Rolling 24-month product roadmap | [1-5] | 15% | =B7*C7 | [Notes] | =IF(B7<3,"Yes","No") |
| 8 | NPI integration with demand/supply | [1-5] | 15% | =B8*C8 | [Notes] | =IF(B8<3,"Yes","No") |
| 9 | SKU rationalization process active | [1-5] | 15% | =B9*C9 | [Notes] | =IF(B9<3,"Yes","No") |
| 10 | Portfolio health metrics tracked | [1-5] | 15% | =B10*C10 | [Notes] | =IF(B10<3,"Yes","No") |
| 11 | Customer co-development integration | [1-5] | 10% | =B11*C11 | [Notes] | =IF(B11<3,"Yes","No") |
| 12 | **Product Review Total** | =SUMPRODUCT(B5:B11,C5:C11) | 100% | | | |
| 13 | | | | | | |
| 14 | **DEMAND REVIEW SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 15 | Statistical baseline forecasting deployed | [1-5] | 15% | =B15*C15 | [Notes] | =IF(B15<3,"Yes","No") |
| 16 | Automated model selection in place | [1-5] | 10% | =B16*C16 | [Notes] | =IF(B16<3,"Yes","No") |
| 17 | Demand sensing using leading indicators | [1-5] | 15% | =B17*C17 | [Notes] | =IF(B17<3,"Yes","No") |
| 18 | Structured consensus demand process | [1-5] | 20% | =B18*C18 | [Notes] | =IF(B18<3,"Yes","No") |
| 19 | Clear assumption documentation | [1-5] | 10% | =B19*C19 | [Notes] | =IF(B19<3,"Yes","No") |
| 20 | Bias tracking and accountability | [1-5] | 15% | =B20*C20 | [Notes] | =IF(B20<3,"Yes","No") |
| 21 | Customer collaboration on forecasts | [1-5] | 15% | =B21*C21 | [Notes] | =IF(B21<3,"Yes","No") |
| 22 | **Demand Review Total** | =SUMPRODUCT(B15:B21,C15:C21) | 100% | | | |
| 23 | | | | | | |
| 24 | **SUPPLY REVIEW SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 25 | Rough-cut capacity planning active | [1-5] | 15% | =B25*C25 | [Notes] | =IF(B25<3,"Yes","No") |
| 26 | Demonstrated vs theoretical capacity tracked | [1-5] | 10% | =B26*C26 | [Notes] | =IF(B26<3,"Yes","No") |
| 27 | Multi-echelon inventory optimization | [1-5] | 15% | =B27*C27 | [Notes] | =IF(B27<3,"Yes","No") |
| 28 | Service-level driven inventory targets | [1-5] | 15% | =B28*C28 | [Notes] | =IF(B28<3,"Yes","No") |
| 29 | Supply network design reviews regular | [1-5] | 15% | =B29*C29 | [Notes] | =IF(B29<3,"Yes","No") |
| 30 | Supplier capacity alignment | [1-5] | 15% | =B30*C30 | [Notes] | =IF(B30<3,"Yes","No") |
| 31 | Scenario-based supply planning | [1-5] | 15% | =B31*C31 | [Notes] | =IF(B31<3,"Yes","No") |
| 32 | **Supply Review Total** | =SUMPRODUCT(B25:B31,C25:C31) | 100% | | | |
| 33 | | | | | | |
| 34 | **FINANCIAL REVIEW SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 35 | Monthly plan-to-budget reconciliation | [1-5] | 20% | =B35*C35 | [Notes] | =IF(B35<3,"Yes","No") |
| 36 | Rolling forecast integration | [1-5] | 15% | =B36*C36 | [Notes] | =IF(B36<3,"Yes","No") |
| 37 | Scenario financial modeling | [1-5] | 20% | =B37*C37 | [Notes] | =IF(B37<3,"Yes","No") |
| 38 | One number philosophy implemented | [1-5] | 20% | =B38*C38 | [Notes] | =IF(B38<3,"Yes","No") |
| 39 | Structured gap closure management | [1-5] | 15% | =B39*C39 | [Notes] | =IF(B39<3,"Yes","No") |
| 40 | Working capital planning integrated | [1-5] | 10% | =B40*C40 | [Notes] | =IF(B40<3,"Yes","No") |
| 41 | **Financial Review Total** | =SUMPRODUCT(B35:B40,C35:C40) | 100% | | | |
| 42 | | | | | | |
| 43 | **EXECUTIVE REVIEW SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 44 | Structured decision framework | [1-5] | 20% | =B44*C44 | [Notes] | =IF(B44<3,"Yes","No") |
| 45 | Exception-based management focus | [1-5] | 15% | =B45*C45 | [Notes] | =IF(B45<3,"Yes","No") |
| 46 | Executive sign-off on integrated plan | [1-5] | 25% | =B46*C46 | [Notes] | =IF(B46<3,"Yes","No") |
| 47 | Clear ownership of gap closure | [1-5] | 20% | =B47*C47 | [Notes] | =IF(B47<3,"Yes","No") |
| 48 | Strategic alignment maintained | [1-5] | 20% | =B48*C48 | [Notes] | =IF(B48<3,"Yes","No") |
| 49 | **Executive Review Total** | =SUMPRODUCT(B44:B48,C44:C48) | 100% | | | |
| 50 | | | | | | |
| 51 | **PROCESS DIMENSION TOTAL** | =AVERAGE(B12,B22,B32,B41,B49) | | | | |

### Scoring Guide (Column G, merged cells)

```
Level 1 - Initial:
- Ad-hoc processes, no documentation
- Inconsistent execution
- No clear ownership

Level 2 - Developing:
- Basic processes defined
- Partial implementation
- Some documentation exists

Level 3 - Integrated:
- Formal processes documented
- Consistent execution
- Cross-functional alignment

Level 4 - Advanced:
- Optimized processes
- Proactive management
- Continuous improvement

Level 5 - Leading:
- Best-in-class practices
- Innovation focus
- Industry benchmark
```

---

## Sheet 3: PeopleDimension

### Purpose
Assessment of People maturity including Leadership, Roles, Skills, and Culture.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **PEOPLE DIMENSION ASSESSMENT** | | | | | |
| 2 | Dimension Weight: 25% | | Target Level: | 4.0 | Current: | =B40 |
| 3 | | | | | | |
| 4 | **LEADERSHIP SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 5 | Executive sponsor identified and active | [1-5] | 20% | =B5*C5 | [Notes] | =IF(B5<3,"Yes","No") |
| 6 | C-suite participation in Executive IBP | [1-5] | 25% | =B6*C6 | [Notes] | =IF(B6<3,"Yes","No") |
| 7 | IBP linked to executive incentives | [1-5] | 15% | =B7*C7 | [Notes] | =IF(B7<3,"Yes","No") |
| 8 | Leaders model IBP behaviors | [1-5] | 20% | =B8*C8 | [Notes] | =IF(B8<3,"Yes","No") |
| 9 | Resource commitment for IBP | [1-5] | 20% | =B9*C9 | [Notes] | =IF(B9<3,"Yes","No") |
| 10 | **Leadership Total** | =SUMPRODUCT(B5:B9,C5:C9) | 100% | | | |
| 11 | | | | | | |
| 12 | **ROLES SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 13 | Dedicated IBP process owner | [1-5] | 25% | =B13*C13 | [Notes] | =IF(B13<3,"Yes","No") |
| 14 | Review owners clearly defined | [1-5] | 20% | =B14*C14 | [Notes] | =IF(B14<3,"Yes","No") |
| 15 | RACI matrix documented | [1-5] | 15% | =B15*C15 | [Notes] | =IF(B15<3,"Yes","No") |
| 16 | Cross-functional team structure | [1-5] | 20% | =B16*C16 | [Notes] | =IF(B16<3,"Yes","No") |
| 17 | IBP roles in job descriptions | [1-5] | 10% | =B17*C17 | [Notes] | =IF(B17<3,"Yes","No") |
| 18 | Succession planning for key roles | [1-5] | 10% | =B18*C18 | [Notes] | =IF(B18<3,"Yes","No") |
| 19 | **Roles Total** | =SUMPRODUCT(B13:B18,C13:C18) | 100% | | | |
| 20 | | | | | | |
| 21 | **SKILLS SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 22 | IBP training program exists | [1-5] | 20% | =B22*C22 | [Notes] | =IF(B22<3,"Yes","No") |
| 23 | Role-based competency framework | [1-5] | 15% | =B23*C23 | [Notes] | =IF(B23<3,"Yes","No") |
| 24 | Analytics/data skills development | [1-5] | 20% | =B24*C24 | [Notes] | =IF(B24<3,"Yes","No") |
| 25 | Cross-functional rotation programs | [1-5] | 10% | =B25*C25 | [Notes] | =IF(B25<3,"Yes","No") |
| 26 | External certification supported | [1-5] | 10% | =B26*C26 | [Notes] | =IF(B26<3,"Yes","No") |
| 27 | Continuous learning culture | [1-5] | 15% | =B27*C27 | [Notes] | =IF(B27<3,"Yes","No") |
| 28 | Coaching and mentoring programs | [1-5] | 10% | =B28*C28 | [Notes] | =IF(B28<3,"Yes","No") |
| 29 | **Skills Total** | =SUMPRODUCT(B22:B28,C22:C28) | 100% | | | |
| 30 | | | | | | |
| 31 | **CULTURE SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 32 | Cross-functional collaboration evident | [1-5] | 25% | =B32*C32 | [Notes] | =IF(B32<3,"Yes","No") |
| 33 | Data-driven decision making | [1-5] | 20% | =B33*C33 | [Notes] | =IF(B33<3,"Yes","No") |
| 34 | Root cause focus vs blame | [1-5] | 15% | =B34*C34 | [Notes] | =IF(B34<3,"Yes","No") |
| 35 | One number transparency | [1-5] | 20% | =B35*C35 | [Notes] | =IF(B35<3,"Yes","No") |
| 36 | Proactive planning vs firefighting | [1-5] | 20% | =B36*C36 | [Notes] | =IF(B36<3,"Yes","No") |
| 37 | **Culture Total** | =SUMPRODUCT(B32:B36,C32:C36) | 100% | | | |
| 38 | | | | | | |
| 39 | | | | | | |
| 40 | **PEOPLE DIMENSION TOTAL** | =AVERAGE(B10,B19,B29,B37) | | | | |

---

## Sheet 4: TechnologyDimension

### Purpose
Assessment of Technology maturity including Systems, Data, Analytics, and Integration.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **TECHNOLOGY DIMENSION ASSESSMENT** | | | | | |
| 2 | Dimension Weight: 25% | | Target Level: | 4.0 | Current: | =B40 |
| 3 | | | | | | |
| 4 | **SYSTEMS SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 5 | Dedicated IBP planning platform | [1-5] | 25% | =B5*C5 | [Notes] | =IF(B5<3,"Yes","No") |
| 6 | ERP integration complete | [1-5] | 20% | =B6*C6 | [Notes] | =IF(B6<3,"Yes","No") |
| 7 | Demand planning system deployed | [1-5] | 20% | =B7*C7 | [Notes] | =IF(B7<3,"Yes","No") |
| 8 | Supply planning system deployed | [1-5] | 20% | =B8*C8 | [Notes] | =IF(B8<3,"Yes","No") |
| 9 | Financial planning integration | [1-5] | 15% | =B9*C9 | [Notes] | =IF(B9<3,"Yes","No") |
| 10 | **Systems Total** | =SUMPRODUCT(B5:B9,C5:C9) | 100% | | | |
| 11 | | | | | | |
| 12 | **DATA SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 13 | Single source of truth established | [1-5] | 25% | =B13*C13 | [Notes] | =IF(B13<3,"Yes","No") |
| 14 | Master data governance in place | [1-5] | 20% | =B14*C14 | [Notes] | =IF(B14<3,"Yes","No") |
| 15 | Historical data clean and complete | [1-5] | 20% | =B15*C15 | [Notes] | =IF(B15<3,"Yes","No") |
| 16 | Real-time data availability | [1-5] | 15% | =B16*C16 | [Notes] | =IF(B16<3,"Yes","No") |
| 17 | Data quality metrics tracked | [1-5] | 10% | =B17*C17 | [Notes] | =IF(B17<3,"Yes","No") |
| 18 | Data stewardship program active | [1-5] | 10% | =B18*C18 | [Notes] | =IF(B18<3,"Yes","No") |
| 19 | **Data Total** | =SUMPRODUCT(B13:B18,C13:C18) | 100% | | | |
| 20 | | | | | | |
| 21 | **ANALYTICS SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 22 | Statistical forecasting automated | [1-5] | 20% | =B22*C22 | [Notes] | =IF(B22<3,"Yes","No") |
| 23 | Scenario modeling capability | [1-5] | 25% | =B23*C23 | [Notes] | =IF(B23<3,"Yes","No") |
| 24 | Dashboard/visualization tools | [1-5] | 15% | =B24*C24 | [Notes] | =IF(B24<3,"Yes","No") |
| 25 | Machine learning deployed | [1-5] | 15% | =B25*C25 | [Notes] | =IF(B25<3,"Yes","No") |
| 26 | Predictive analytics capability | [1-5] | 15% | =B26*C26 | [Notes] | =IF(B26<3,"Yes","No") |
| 27 | Self-service analytics enabled | [1-5] | 10% | =B27*C27 | [Notes] | =IF(B27<3,"Yes","No") |
| 28 | **Analytics Total** | =SUMPRODUCT(B22:B27,C22:C27) | 100% | | | |
| 29 | | | | | | |
| 30 | **INTEGRATION SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 31 | API architecture defined | [1-5] | 20% | =B31*C31 | [Notes] | =IF(B31<3,"Yes","No") |
| 32 | CRM integration active | [1-5] | 20% | =B32*C32 | [Notes] | =IF(B32<3,"Yes","No") |
| 33 | Supplier portal connectivity | [1-5] | 15% | =B33*C33 | [Notes] | =IF(B33<3,"Yes","No") |
| 34 | Customer portal integration | [1-5] | 15% | =B34*C34 | [Notes] | =IF(B34<3,"Yes","No") |
| 35 | MES/WMS/TMS connectivity | [1-5] | 15% | =B35*C35 | [Notes] | =IF(B35<3,"Yes","No") |
| 36 | EDI/B2B integration capability | [1-5] | 15% | =B36*C36 | [Notes] | =IF(B36<3,"Yes","No") |
| 37 | **Integration Total** | =SUMPRODUCT(B31:B36,C31:C36) | 100% | | | |
| 38 | | | | | | |
| 39 | | | | | | |
| 40 | **TECHNOLOGY DIMENSION TOTAL** | =AVERAGE(B10,B19,B28,B37) | | | | |

---

## Sheet 5: PerformanceDimension

### Purpose
Assessment of Performance management maturity including KPIs, Tracking, Benchmarking, Impact, and Improvement.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **PERFORMANCE DIMENSION ASSESSMENT** | | | | | |
| 2 | Dimension Weight: 20% | | Target Level: | 4.0 | Current: | =B45 |
| 3 | | | | | | |
| 4 | **KPI FRAMEWORK SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 5 | IBP balanced scorecard defined | [1-5] | 25% | =B5*C5 | [Notes] | =IF(B5<3,"Yes","No") |
| 6 | Customer metrics tracked | [1-5] | 15% | =B6*C6 | [Notes] | =IF(B6<3,"Yes","No") |
| 7 | Financial metrics tracked | [1-5] | 15% | =B7*C7 | [Notes] | =IF(B7<3,"Yes","No") |
| 8 | Process metrics tracked | [1-5] | 15% | =B8*C8 | [Notes] | =IF(B8<3,"Yes","No") |
| 9 | Enabler metrics tracked | [1-5] | 15% | =B9*C9 | [Notes] | =IF(B9<3,"Yes","No") |
| 10 | KPIs aligned to strategy | [1-5] | 15% | =B10*C10 | [Notes] | =IF(B10<3,"Yes","No") |
| 11 | **KPI Framework Total** | =SUMPRODUCT(B5:B10,C5:C10) | 100% | | | |
| 12 | | | | | | |
| 13 | **TRACKING SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 14 | Forecast accuracy measured properly | [1-5] | 25% | =B14*C14 | [Notes] | =IF(B14<3,"Yes","No") |
| 15 | Plan vs actual variance analysis | [1-5] | 20% | =B15*C15 | [Notes] | =IF(B15<3,"Yes","No") |
| 16 | Root cause analysis conducted | [1-5] | 20% | =B16*C16 | [Notes] | =IF(B16<3,"Yes","No") |
| 17 | Performance dashboards available | [1-5] | 20% | =B17*C17 | [Notes] | =IF(B17<3,"Yes","No") |
| 18 | Automated reporting in place | [1-5] | 15% | =B18*C18 | [Notes] | =IF(B18<3,"Yes","No") |
| 19 | **Tracking Total** | =SUMPRODUCT(B14:B18,C14:C18) | 100% | | | |
| 20 | | | | | | |
| 21 | **BENCHMARKING SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 22 | Industry benchmarks identified | [1-5] | 30% | =B22*C22 | [Notes] | =IF(B22<3,"Yes","No") |
| 23 | Regular benchmark comparison | [1-5] | 25% | =B23*C23 | [Notes] | =IF(B23<3,"Yes","No") |
| 24 | Internal best practice sharing | [1-5] | 25% | =B24*C24 | [Notes] | =IF(B24<3,"Yes","No") |
| 25 | External network participation | [1-5] | 20% | =B25*C25 | [Notes] | =IF(B25<3,"Yes","No") |
| 26 | **Benchmarking Total** | =SUMPRODUCT(B22:B25,C22:C25) | 100% | | | |
| 27 | | | | | | |
| 28 | **IMPACT SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 29 | Service level improvement tracked | [1-5] | 25% | =B29*C29 | [Notes] | =IF(B29<3,"Yes","No") |
| 30 | Inventory optimization measured | [1-5] | 25% | =B30*C30 | [Notes] | =IF(B30<3,"Yes","No") |
| 31 | Cost savings quantified | [1-5] | 25% | =B31*C31 | [Notes] | =IF(B31<3,"Yes","No") |
| 32 | Revenue impact measured | [1-5] | 25% | =B32*C32 | [Notes] | =IF(B32<3,"Yes","No") |
| 33 | **Impact Total** | =SUMPRODUCT(B29:B32,C29:C32) | 100% | | | |
| 34 | | | | | | |
| 35 | **IMPROVEMENT SUB-DIMENSION** | Score | Weight | Weighted | Evidence | Action Required |
| 36 | Continuous improvement process | [1-5] | 25% | =B36*C36 | [Notes] | =IF(B36<3,"Yes","No") |
| 37 | Action tracking from reviews | [1-5] | 25% | =B37*C37 | [Notes] | =IF(B37<3,"Yes","No") |
| 38 | Lessons learned captured | [1-5] | 20% | =B38*C38 | [Notes] | =IF(B38<3,"Yes","No") |
| 39 | Innovation pipeline maintained | [1-5] | 15% | =B39*C39 | [Notes] | =IF(B39<3,"Yes","No") |
| 40 | Maturity assessment regular | [1-5] | 15% | =B40*C40 | [Notes] | =IF(B40<3,"Yes","No") |
| 41 | **Improvement Total** | =SUMPRODUCT(B36:B40,C36:C40) | 100% | | | |
| 42 | | | | | | |
| 43 | | | | | | |
| 44 | | | | | | |
| 45 | **PERFORMANCE DIMENSION TOTAL** | =AVERAGE(B11,B19,B26,B33,B41) | | | | |

---

## Sheet 6: ScoringMatrix

### Purpose
Visual heatmap matrix showing all sub-dimension scores across the organization.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 1 | **IBP MATURITY SCORING MATRIX** | | | | | |
| 2 | | | | | | |
| 3 | **Dimension** | **Sub-Dimension** | **Score** | **Level** | **Target** | **Gap** |
| 4 | Process | Product Review | =ProcessDimension!B12 | =VLOOKUP(C4,MaturityLevels,2,TRUE) | 4 | =E4-C4 |
| 5 | Process | Demand Review | =ProcessDimension!B22 | =VLOOKUP(C5,MaturityLevels,2,TRUE) | 4 | =E5-C5 |
| 6 | Process | Supply Review | =ProcessDimension!B32 | =VLOOKUP(C6,MaturityLevels,2,TRUE) | 4 | =E6-C6 |
| 7 | Process | Financial Review | =ProcessDimension!B41 | =VLOOKUP(C7,MaturityLevels,2,TRUE) | 4 | =E7-C7 |
| 8 | Process | Executive Review | =ProcessDimension!B49 | =VLOOKUP(C8,MaturityLevels,2,TRUE) | 4 | =E8-C8 |
| 9 | People | Leadership | =PeopleDimension!B10 | =VLOOKUP(C9,MaturityLevels,2,TRUE) | 4 | =E9-C9 |
| 10 | People | Roles | =PeopleDimension!B19 | =VLOOKUP(C10,MaturityLevels,2,TRUE) | 4 | =E10-C10 |
| 11 | People | Skills | =PeopleDimension!B29 | =VLOOKUP(C11,MaturityLevels,2,TRUE) | 4 | =E11-C11 |
| 12 | People | Culture | =PeopleDimension!B37 | =VLOOKUP(C12,MaturityLevels,2,TRUE) | 4 | =E12-C12 |
| 13 | Technology | Systems | =TechnologyDimension!B10 | =VLOOKUP(C13,MaturityLevels,2,TRUE) | 4 | =E13-C13 |
| 14 | Technology | Data | =TechnologyDimension!B19 | =VLOOKUP(C14,MaturityLevels,2,TRUE) | 4 | =E14-C14 |
| 15 | Technology | Analytics | =TechnologyDimension!B28 | =VLOOKUP(C15,MaturityLevels,2,TRUE) | 4 | =E15-C15 |
| 16 | Technology | Integration | =TechnologyDimension!B37 | =VLOOKUP(C16,MaturityLevels,2,TRUE) | 4 | =E16-C16 |
| 17 | Performance | KPIs | =PerformanceDimension!B11 | =VLOOKUP(C17,MaturityLevels,2,TRUE) | 4 | =E17-C17 |
| 18 | Performance | Tracking | =PerformanceDimension!B19 | =VLOOKUP(C18,MaturityLevels,2,TRUE) | 4 | =E18-C18 |
| 19 | Performance | Benchmarking | =PerformanceDimension!B26 | =VLOOKUP(C19,MaturityLevels,2,TRUE) | 4 | =E19-C19 |
| 20 | Performance | Impact | =PerformanceDimension!B33 | =VLOOKUP(C20,MaturityLevels,2,TRUE) | 4 | =E20-C20 |
| 21 | Performance | Improvement | =PerformanceDimension!B41 | =VLOOKUP(C21,MaturityLevels,2,TRUE) | 4 | =E21-C21 |

### Visual Heatmap Section (Rows 25-45)

```
Row 25: VISUAL HEATMAP - SUB-DIMENSION SCORES

         Process    People     Technology  Performance
         --------   --------   ----------  -----------
Product     [C]
Demand      [C]
Supply      [C]
Financial   [C]
Executive   [C]
Leadership            [C]
Roles                 [C]
Skills                [C]
Culture               [C]
Systems                          [C]
Data                             [C]
Analytics                        [C]
Integration                      [C]
KPIs                                         [C]
Tracking                                     [C]
Benchmark                                    [C]
Impact                                       [C]
Improvement                                  [C]

Where [C] = Color-coded score cell (1=Red, 2=Orange, 3=Yellow, 4=Emerald, 5=Teal)
```

### Conditional Formatting for Heatmap

```
All score cells (C4:C21):
- Rule: Cell Value = 1 -> Fill Red (#DC2626), White text
- Rule: Cell Value = 2 -> Fill Orange (#F59E0B), White text
- Rule: Cell Value = 3 -> Fill Yellow (#EAB308), Black text
- Rule: Cell Value = 4 -> Fill Emerald (#10B981), White text
- Rule: Cell Value = 5 -> Fill Teal (#0D9488), White text
```

---

## Sheet 7: PriorAssessments

### Purpose
Track historical assessment scores for trend analysis.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 1 | **PRIOR ASSESSMENTS HISTORY** | | | | | | |
| 2 | Assessment Date | Overall | Process | People | Technology | Performance | Assessed By |
| 3 | [Date 1] | [Score] | [Score] | [Score] | [Score] | [Score] | [Name] |
| 4 | [Date 2] | [Score] | [Score] | [Score] | [Score] | [Score] | [Name] |
| 5 | [Date 3] | [Score] | [Score] | [Score] | [Score] | [Score] | [Name] |
| 6 | [Date 4] | [Score] | [Score] | [Score] | [Score] | [Score] | [Name] |
| 7 | ... | ... | ... | ... | ... | ... | ... |
| 15 | | | | | | | |
| 16 | **TREND ANALYSIS** | | | | | | |
| 17 | Dimension | 12M Change | 6M Change | 3M Change | Trend Direction | | |
| 18 | Overall | =Dashboard!C14-B3 | =Dashboard!C14-B4 | =Dashboard!C14-B5 | =IF(C18>0,"Improving","Declining") | | |
| 19 | Process | =Dashboard!C10-C3 | =Dashboard!C10-C4 | =Dashboard!C10-C5 | =IF(C19>0,"Improving","Declining") | | |
| 20 | People | =Dashboard!C11-D3 | =Dashboard!C11-D4 | =Dashboard!C11-D5 | =IF(C20>0,"Improving","Declining") | | |
| 21 | Technology | =Dashboard!C12-E3 | =Dashboard!C12-E4 | =Dashboard!C12-E5 | =IF(C21>0,"Improving","Declining") | | |
| 22 | Performance | =Dashboard!C13-F3 | =Dashboard!C13-F4 | =Dashboard!C13-F5 | =IF(C22>0,"Improving","Declining") | | |

---

## Sheet 8: TargetSetting

### Purpose
Set maturity targets and analyze gaps for improvement planning.

### Layout

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 1 | **TARGET SETTING & GAP ANALYSIS** | | | | | | |
| 2 | | | | | | | |
| 3 | **DIMENSION TARGETS** | Current | 6M Target | 12M Target | 24M Target | Ultimate Target | |
| 4 | Process | =Dashboard!C10 | [Input] | [Input] | [Input] | 4.5 | |
| 5 | People | =Dashboard!C11 | [Input] | [Input] | [Input] | 4.5 | |
| 6 | Technology | =Dashboard!C12 | [Input] | [Input] | [Input] | 4.5 | |
| 7 | Performance | =Dashboard!C13 | [Input] | [Input] | [Input] | 4.5 | |
| 8 | **Overall** | =Dashboard!C14 | =AVERAGE(C4:C7) | =AVERAGE(D4:D7) | =AVERAGE(E4:E7) | =AVERAGE(F4:F7) | |
| 9 | | | | | | | |
| 10 | **GAP ANALYSIS** | Gap to 6M | Gap to 12M | Gap to 24M | Gap to Ultimate | Priority Score | |
| 11 | Process | =C4-B4 | =D4-B4 | =E4-B4 | =F4-B4 | =E11*0.30 | |
| 12 | People | =C5-B5 | =D5-B5 | =E5-B5 | =F5-B5 | =E12*0.25 | |
| 13 | Technology | =C6-B6 | =D6-B6 | =E6-B6 | =F6-B6 | =E13*0.25 | |
| 14 | Performance | =C7-B7 | =D7-B7 | =E7-B7 | =F7-B7 | =E14*0.20 | |
| 15 | | | | | | | |
| 16 | **SUB-DIMENSION GAP DETAIL** | Current | Target | Gap | Priority | Initiative Required | |
| 17 | Product Review | =ScoringMatrix!C4 | 4.0 | =C17-B17 | =IF(D17>1.5,"Critical",IF(D17>1,"High",IF(D17>0.5,"Medium","Low"))) | =IF(D17>0.5,"Yes","No") | |
| 18 | Demand Review | =ScoringMatrix!C5 | 4.0 | =C18-B18 | =IF(D18>1.5,"Critical",IF(D18>1,"High",IF(D18>0.5,"Medium","Low"))) | =IF(D18>0.5,"Yes","No") | |
| 19 | Supply Review | =ScoringMatrix!C6 | 4.0 | =C19-B19 | =IF(D19>1.5,"Critical",IF(D19>1,"High",IF(D19>0.5,"Medium","Low"))) | =IF(D19>0.5,"Yes","No") | |
| 20 | Financial Review | =ScoringMatrix!C7 | 4.0 | =C20-B20 | =IF(D20>1.5,"Critical",IF(D20>1,"High",IF(D20>0.5,"Medium","Low"))) | =IF(D20>0.5,"Yes","No") | |
| 21 | Executive Review | =ScoringMatrix!C8 | 4.0 | =C21-B21 | =IF(D21>1.5,"Critical",IF(D21>1,"High",IF(D21>0.5,"Medium","Low"))) | =IF(D21>0.5,"Yes","No") | |
| 22 | Leadership | =ScoringMatrix!C9 | 4.0 | =C22-B22 | =IF(D22>1.5,"Critical",IF(D22>1,"High",IF(D22>0.5,"Medium","Low"))) | =IF(D22>0.5,"Yes","No") | |
| 23 | Roles | =ScoringMatrix!C10 | 4.0 | =C23-B23 | =IF(D23>1.5,"Critical",IF(D23>1,"High",IF(D23>0.5,"Medium","Low"))) | =IF(D23>0.5,"Yes","No") | |
| 24 | Skills | =ScoringMatrix!C11 | 4.0 | =C24-B24 | =IF(D24>1.5,"Critical",IF(D24>1,"High",IF(D24>0.5,"Medium","Low"))) | =IF(D24>0.5,"Yes","No") | |
| 25 | Culture | =ScoringMatrix!C12 | 4.0 | =C25-B25 | =IF(D25>1.5,"Critical",IF(D25>1,"High",IF(D25>0.5,"Medium","Low"))) | =IF(D25>0.5,"Yes","No") | |
| 26 | Systems | =ScoringMatrix!C13 | 4.0 | =C26-B26 | =IF(D26>1.5,"Critical",IF(D26>1,"High",IF(D26>0.5,"Medium","Low"))) | =IF(D26>0.5,"Yes","No") | |
| 27 | Data | =ScoringMatrix!C14 | 4.0 | =C27-B27 | =IF(D27>1.5,"Critical",IF(D27>1,"High",IF(D27>0.5,"Medium","Low"))) | =IF(D27>0.5,"Yes","No") | |
| 28 | Analytics | =ScoringMatrix!C15 | 4.0 | =C28-B28 | =IF(D28>1.5,"Critical",IF(D28>1,"High",IF(D28>0.5,"Medium","Low"))) | =IF(D28>0.5,"Yes","No") | |
| 29 | Integration | =ScoringMatrix!C16 | 4.0 | =C29-B29 | =IF(D29>1.5,"Critical",IF(D29>1,"High",IF(D29>0.5,"Medium","Low"))) | =IF(D29>0.5,"Yes","No") | |
| 30 | KPIs | =ScoringMatrix!C17 | 4.0 | =C30-B30 | =IF(D30>1.5,"Critical",IF(D30>1,"High",IF(D30>0.5,"Medium","Low"))) | =IF(D30>0.5,"Yes","No") | |
| 31 | Tracking | =ScoringMatrix!C18 | 4.0 | =C31-B31 | =IF(D31>1.5,"Critical",IF(D31>1,"High",IF(D31>0.5,"Medium","Low"))) | =IF(D31>0.5,"Yes","No") | |
| 32 | Benchmarking | =ScoringMatrix!C19 | 4.0 | =C32-B32 | =IF(D32>1.5,"Critical",IF(D32>1,"High",IF(D32>0.5,"Medium","Low"))) | =IF(D32>0.5,"Yes","No") | |
| 33 | Impact | =ScoringMatrix!C20 | 4.0 | =C33-B33 | =IF(D33>1.5,"Critical",IF(D33>1,"High",IF(D33>0.5,"Medium","Low"))) | =IF(D33>0.5,"Yes","No") | |
| 34 | Improvement | =ScoringMatrix!C21 | 4.0 | =C34-B34 | =IF(D34>1.5,"Critical",IF(D34>1,"High",IF(D34>0.5,"Medium","Low"))) | =IF(D34>0.5,"Yes","No") | |

---

## Sheet 9: Calculations

### Purpose
Central calculation hub for all formulas and lookups.

### Layout

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 1 | **CALCULATIONS** | | | |
| 2 | Overall Maturity Score | =SUMPRODUCT(Dashboard!B10:B13,Dashboard!C10:C13) | | |
| 3 | | | | |
| 4 | **MATURITY LEVELS LOOKUP** | | | |
| 5 | Score Range | Level | Description | |
| 6 | 0 | 1 | Initial | |
| 7 | 1.5 | 2 | Developing | |
| 8 | 2.5 | 3 | Integrated | |
| 9 | 3.5 | 4 | Advanced | |
| 10 | 4.5 | 5 | Leading | |

---

## Named Ranges

```
MaturityLevels = Calculations!$A$6:$C$10
AllScores = ProcessDimension!$B$5:$B$11,ProcessDimension!$B$15:$B$21,...
SubDimensions = ScoringMatrix!$B$4:$B$21
SubDimensionScores = ScoringMatrix!$C$4:$C$21
DimensionWeights = Dashboard!$B$10:$B$13
DimensionScores = Dashboard!$C$10:$C$13
ProcessScores = ProcessDimension!$B$5:$B$48
PeopleScores = PeopleDimension!$B$5:$B$36
TechnologyScores = TechnologyDimension!$B$5:$B$36
PerformanceScores = PerformanceDimension!$B$5:$B$40
AssessmentHistory = PriorAssessments!$A$3:$G$15
TargetGaps = TargetSetting!$D$17:$D$34
```

---

## VBA Automation Code

```vba
Option Explicit

' ============================================
' MATURITY ASSESSMENT AUTOMATION MODULE
' ============================================

' Global Constants
Const NAVY As Long = &H5F3A1E
Const EMERALD As Long = &H81B910
Const TEAL As Long = &H88940D
Const LEVEL1_RED As Long = &H2626DC
Const LEVEL2_ORANGE As Long = &H0B9EF5
Const LEVEL3_YELLOW As Long = &H08B3EA
Const WHITE As Long = &HFFFFFF

' ============================================
' SUB: InitializeAssessment
' Purpose: Set up new assessment with date/assessor
' ============================================
Sub InitializeAssessment()
    Dim ws As Worksheet
    Dim assessorName As String

    Set ws = ThisWorkbook.Worksheets("Dashboard")

    ' Prompt for assessor name
    assessorName = InputBox("Enter Assessor Name:", "New Assessment")
    If assessorName = "" Then Exit Sub

    ' Set assessment details
    ws.Range("H1").Value = Date
    ws.Range("H2").Value = assessorName

    ' Clear previous scores
    Call ClearAllScores

    ' Format dashboard
    Call FormatDashboard

    MsgBox "Assessment initialized for " & assessorName & " on " & Date, vbInformation
End Sub

' ============================================
' SUB: ClearAllScores
' Purpose: Reset all dimension scores to blank
' ============================================
Sub ClearAllScores()
    Dim ws As Worksheet

    ' Clear Process Dimension
    Set ws = ThisWorkbook.Worksheets("ProcessDimension")
    ws.Range("B5:B11").ClearContents
    ws.Range("B15:B21").ClearContents
    ws.Range("B25:B31").ClearContents
    ws.Range("B35:B40").ClearContents
    ws.Range("B44:B48").ClearContents
    ws.Range("E5:E48").ClearContents

    ' Clear People Dimension
    Set ws = ThisWorkbook.Worksheets("PeopleDimension")
    ws.Range("B5:B9").ClearContents
    ws.Range("B13:B18").ClearContents
    ws.Range("B22:B28").ClearContents
    ws.Range("B32:B36").ClearContents
    ws.Range("E5:E36").ClearContents

    ' Clear Technology Dimension
    Set ws = ThisWorkbook.Worksheets("TechnologyDimension")
    ws.Range("B5:B9").ClearContents
    ws.Range("B13:B18").ClearContents
    ws.Range("B22:B27").ClearContents
    ws.Range("B31:B36").ClearContents
    ws.Range("E5:E36").ClearContents

    ' Clear Performance Dimension
    Set ws = ThisWorkbook.Worksheets("PerformanceDimension")
    ws.Range("B5:B10").ClearContents
    ws.Range("B14:B18").ClearContents
    ws.Range("B22:B25").ClearContents
    ws.Range("B29:B32").ClearContents
    ws.Range("B36:B40").ClearContents
    ws.Range("E5:E40").ClearContents
End Sub

' ============================================
' SUB: SaveAssessment
' Purpose: Archive current assessment to history
' ============================================
Sub SaveAssessment()
    Dim wsHistory As Worksheet
    Dim wsDash As Worksheet
    Dim nextRow As Long

    Set wsHistory = ThisWorkbook.Worksheets("PriorAssessments")
    Set wsDash = ThisWorkbook.Worksheets("Dashboard")

    ' Find next empty row
    nextRow = wsHistory.Cells(wsHistory.Rows.Count, "A").End(xlUp).Row + 1

    ' Save current assessment
    wsHistory.Cells(nextRow, 1).Value = wsDash.Range("H1").Value   ' Date
    wsHistory.Cells(nextRow, 2).Value = wsDash.Range("C14").Value  ' Overall
    wsHistory.Cells(nextRow, 3).Value = wsDash.Range("C10").Value  ' Process
    wsHistory.Cells(nextRow, 4).Value = wsDash.Range("C11").Value  ' People
    wsHistory.Cells(nextRow, 5).Value = wsDash.Range("C12").Value  ' Technology
    wsHistory.Cells(nextRow, 6).Value = wsDash.Range("C13").Value  ' Performance
    wsHistory.Cells(nextRow, 7).Value = wsDash.Range("H2").Value   ' Assessor

    MsgBox "Assessment saved to history.", vbInformation
End Sub

' ============================================
' SUB: GenerateReport
' Purpose: Create PDF report of assessment
' ============================================
Sub GenerateReport()
    Dim filePath As String
    Dim ws As Worksheet

    ' Create file path with date
    filePath = ThisWorkbook.Path & "\IBP_Maturity_Assessment_" & _
               Format(Date, "YYYYMMDD") & ".pdf"

    ' Export Dashboard and Scoring Matrix
    ThisWorkbook.Worksheets(Array("Dashboard", "ScoringMatrix")).Select
    ActiveSheet.ExportAsFixedFormat _
        Type:=xlTypePDF, _
        Filename:=filePath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True

    ' Return to Dashboard
    ThisWorkbook.Worksheets("Dashboard").Select

    MsgBox "Report exported to: " & filePath, vbInformation
End Sub

' ============================================
' SUB: ApplyHeatmapFormatting
' Purpose: Apply conditional formatting to all score cells
' ============================================
Sub ApplyHeatmapFormatting()
    Dim ws As Worksheet
    Dim rng As Range

    ' Apply to Scoring Matrix
    Set ws = ThisWorkbook.Worksheets("ScoringMatrix")
    Set rng = ws.Range("C4:C21")

    ' Clear existing formatting
    rng.FormatConditions.Delete

    ' Add formatting rules
    With rng.FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="1")
        .Interior.Color = LEVEL1_RED
        .Font.Color = WHITE
    End With

    With rng.FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="2")
        .Interior.Color = LEVEL2_ORANGE
        .Font.Color = WHITE
    End With

    With rng.FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="3")
        .Interior.Color = LEVEL3_YELLOW
        .Font.Color = &H0
    End With

    With rng.FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="4")
        .Interior.Color = EMERALD
        .Font.Color = WHITE
    End With

    With rng.FormatConditions.Add(Type:=xlCellValue, Operator:=xlEqual, Formula1:="5")
        .Interior.Color = TEAL
        .Font.Color = WHITE
    End With
End Sub

' ============================================
' SUB: FormatDashboard
' Purpose: Apply consistent formatting to dashboard
' ============================================
Sub FormatDashboard()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Worksheets("Dashboard")

    ' Header formatting
    With ws.Range("A1")
        .Font.Size = 18
        .Font.Bold = True
        .Font.Color = NAVY
    End With

    ' Section headers
    With ws.Range("A5,A8,A16,A24,A29")
        .Font.Size = 12
        .Font.Bold = True
        .Interior.Color = NAVY
        .Font.Color = WHITE
    End With

    ' Column headers
    With ws.Range("A9:H9")
        .Font.Bold = True
        .Interior.Color = TEAL
        .Font.Color = WHITE
    End With
End Sub

' ============================================
' SUB: CalculateOverallMaturity
' Purpose: Recalculate weighted overall maturity score
' ============================================
Sub CalculateOverallMaturity()
    Dim ws As Worksheet
    Dim processScore As Double
    Dim peopleScore As Double
    Dim techScore As Double
    Dim perfScore As Double
    Dim overallScore As Double

    Set ws = ThisWorkbook.Worksheets("Dashboard")

    ' Get dimension scores
    processScore = ws.Range("C10").Value * 0.3
    peopleScore = ws.Range("C11").Value * 0.25
    techScore = ws.Range("C12").Value * 0.25
    perfScore = ws.Range("C13").Value * 0.2

    ' Calculate overall
    overallScore = processScore + peopleScore + techScore + perfScore

    ' Update calculations sheet
    ThisWorkbook.Worksheets("Calculations").Range("B2").Value = overallScore
End Sub

' ============================================
' SUB: ValidateScores
' Purpose: Ensure all scores are within valid range (1-5)
' ============================================
Sub ValidateScores()
    Dim ws As Worksheet
    Dim cell As Range
    Dim invalidCount As Integer

    invalidCount = 0

    ' Check Process Dimension
    Set ws = ThisWorkbook.Worksheets("ProcessDimension")
    For Each cell In ws.Range("B5:B11,B15:B21,B25:B31,B35:B40,B44:B48")
        If Not IsEmpty(cell) Then
            If cell.Value < 1 Or cell.Value > 5 Then
                cell.Interior.Color = LEVEL1_RED
                invalidCount = invalidCount + 1
            End If
        End If
    Next cell

    ' Repeat for other dimensions...

    If invalidCount > 0 Then
        MsgBox invalidCount & " invalid scores found. Please correct highlighted cells.", vbWarning
    Else
        MsgBox "All scores are valid.", vbInformation
    End If
End Sub

' ============================================
' SUB: CreateComparisonChart
' Purpose: Generate comparison chart between assessments
' ============================================
Sub CreateComparisonChart()
    Dim ws As Worksheet
    Dim chartObj As ChartObject
    Dim cht As Chart

    Set ws = ThisWorkbook.Worksheets("Dashboard")

    ' Delete existing chart if present
    On Error Resume Next
    ws.ChartObjects("ComparisonChart").Delete
    On Error GoTo 0

    ' Create new chart
    Set chartObj = ws.ChartObjects.Add(Left:=400, Top:=300, Width:=400, Height:=250)
    chartObj.Name = "ComparisonChart"
    Set cht = chartObj.Chart

    ' Configure chart
    With cht
        .ChartType = xlRadarFilled
        .SetSourceData Source:=ws.Range("A10:C13")
        .HasTitle = True
        .ChartTitle.Text = "Dimension Maturity Comparison"
        .ChartTitle.Font.Color = NAVY
    End With
End Sub

' ============================================
' FUNCTION: GetMaturityLevel
' Purpose: Return maturity level name from score
' ============================================
Function GetMaturityLevel(score As Double) As String
    Select Case score
        Case Is < 1.5
            GetMaturityLevel = "Initial"
        Case Is < 2.5
            GetMaturityLevel = "Developing"
        Case Is < 3.5
            GetMaturityLevel = "Integrated"
        Case Is < 4.5
            GetMaturityLevel = "Advanced"
        Case Else
            GetMaturityLevel = "Leading"
    End Select
End Function

' ============================================
' SUB: Workbook_Open Event
' Purpose: Initialize workbook on open
' ============================================
Private Sub Workbook_Open()
    ' Ensure Dashboard is active
    ThisWorkbook.Worksheets("Dashboard").Activate

    ' Apply formatting
    Call ApplyHeatmapFormatting
    Call FormatDashboard

    ' Recalculate
    Application.Calculate
End Sub
```

---

## Integration Points

### Links to Other IBP Workbooks

```
1. Gap_Analysis_By_Dimension_ENHANCED.xlsx
   - Export: Sub-dimension scores for gap analysis
   - Named Range: SubDimensionScores -> Gap Analysis import

2. Improvement_Roadmap_ENHANCED.xlsx
   - Export: Priority gaps for initiative planning
   - Named Range: TargetGaps -> Roadmap initiative mapping

3. IBP_Master_Integration_Workbook.xlsx
   - Import: Overall maturity score for executive dashboard
   - Export: =Maturity_Assessment_Tool_ENHANCED.xlsx!Dashboard!C14

4. Performance_Dashboard_ENHANCED.xlsx
   - Link: Maturity tracking as leading indicator
   - Formula: =Maturity_Assessment_Tool_ENHANCED.xlsx!Dashboard!$C$14
```

### Data Validation Rules

```
All score input cells (B5:B48 on dimension sheets):
- Data Validation: List
- Source: 1,2,3,4,5
- Error Alert: "Please enter a score between 1 and 5"

Assessment Date:
- Data Validation: Date
- Criteria: Between TODAY()-365 and TODAY()

Target Scores:
- Data Validation: Decimal
- Criteria: Between 1 and 5
```

---

## Print Settings

```
Dashboard Sheet:
- Print Area: A1:H35
- Orientation: Landscape
- Fit to: 1 page wide by 1 page tall
- Header: "IBP Maturity Assessment - [Date]"
- Footer: "Page &P of &N | Confidential"

Dimension Sheets:
- Print Area: A1:F52
- Orientation: Portrait
- Fit to: 1 page wide by 2 pages tall

Scoring Matrix:
- Print Area: A1:F22
- Orientation: Landscape
- Fit to: 1 page
```

---

## Usage Instructions

1. **Initialize New Assessment**
   - Click "Initialize" button or run `InitializeAssessment` macro
   - Enter assessor name and confirm date

2. **Complete Dimension Assessments**
   - Navigate to each dimension sheet (Process, People, Technology, Performance)
   - Enter scores 1-5 for each criteria
   - Add evidence notes in column E
   - System auto-calculates sub-dimension and dimension totals

3. **Review Dashboard**
   - View overall maturity score and level
   - Analyze strengths and opportunities
   - Review trend vs. prior assessments

4. **Set Targets**
   - Navigate to TargetSetting sheet
   - Enter 6M, 12M, 24M targets by dimension
   - Review gap analysis and priorities

5. **Save Assessment**
   - Click "Save" button to archive to history
   - Run `GenerateReport` to create PDF output

6. **Export for Improvement Planning**
   - Gap data automatically links to Gap_Analysis workbook
   - Priority rankings feed Improvement_Roadmap planning
