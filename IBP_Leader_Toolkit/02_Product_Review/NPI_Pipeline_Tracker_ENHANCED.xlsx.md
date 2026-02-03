# NPI Pipeline Tracker - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: Pipeline_Master
### Sheet 3: Stage_Gate_Tracker
### Sheet 4: Resource_Planning
### Sheet 5: Financial_Projections
### Sheet 6: Settings

---

## SHEET 1: DASHBOARD

### Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "NPI PIPELINE DASHBOARD" (Purple #7B1FA2)                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:F10  PIPELINE SUMMARY          │ H3:P10  PIPELINE FUNNEL CHART          │
│ ┌─────────────────────────┐       │ ┌────────────────────────────────┐     │
│ │ Total Projects: 24      │       │ │   Concept ████████████ 8      │     │
│ │ Active: 18              │       │ │   Develop ██████████ 6        │     │
│ │ On Track: 12 (67%)      │       │ │   Validate ██████ 4           │     │
│ │ At Risk: 4 (22%)        │       │ │   Launch ████ 3               │     │
│ │ Delayed: 2 (11%)        │       │ │   Complete ██ 3               │     │
│ │ Revenue Pipeline: $45M  │       │ └────────────────────────────────┘     │
│ └─────────────────────────┘       │                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│ A12:P20  UPCOMING LAUNCHES (Next 6 Months)                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ A22:H35  STAGE GATE STATUS        │ J22:P35  RESOURCE ALLOCATION           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| C4 | `=COUNTA(Pipeline_Master!$A$3:$A$200)-COUNTBLANK(Pipeline_Master!$A$3:$A$200)` | Total projects |
| C5 | `=COUNTIF(Pipeline_Master!$H$3:$H$200,"Active")` | Active projects |
| C6 | `=COUNTIF(Pipeline_Master!$I$3:$I$200,"On Track")` | On track count |
| C7 | `=COUNTIF(Pipeline_Master!$I$3:$I$200,"At Risk")` | At risk count |
| C8 | `=COUNTIF(Pipeline_Master!$I$3:$I$200,"Delayed")` | Delayed count |
| C9 | `=SUMIF(Pipeline_Master!$H$3:$H$200,"Active",Pipeline_Master!$N$3:$N$200)` | Revenue pipeline |
| D6 | `=C6/C5` | % On track |

---

## SHEET 2: Pipeline_Master

### Column Structure
| Col | Header | Width | Format | Description |
|-----|--------|-------|--------|-------------|
| A | Project_ID | 12 | Text | Auto-generated |
| B | Project_Name | 35 | Text | NPI project name |
| C | Product_Family | 20 | Dropdown | Target family |
| D | Project_Type | 15 | Dropdown | New/Extension/Refresh |
| E | Strategic_Priority | 12 | Dropdown | High/Med/Low |
| F | Current_Stage | 15 | Dropdown | Stage gate |
| G | Stage_Entry_Date | 12 | Date | When entered current stage |
| H | Project_Status | 12 | Dropdown | Active/Hold/Cancelled |
| I | Health_Status | 12 | Formula | Auto-calculated |
| J | Target_Launch_Date | 12 | Date | Planned launch |
| K | Forecast_Launch_Date | 12 | Date | Current forecast |
| L | Launch_Variance_Days | 10 | Formula | Days difference |
| M | Year_1_Volume | 12 | Number | Expected units Y1 |
| N | Year_1_Revenue | 15 | Currency | Expected revenue Y1 |
| O | Year_1_Margin | 12 | Percentage | Expected margin Y1 |
| P | NPV | 15 | Currency | Net present value |
| Q | Project_Manager | 20 | Dropdown | Owner |
| R | Next_Gate_Date | 12 | Date | Next decision point |
| S | Next_Gate_Readiness | 12 | Dropdown | Ready/Not Ready |
| T | Key_Risks | 40 | Text | Top risks |
| U | Last_Update_Date | 12 | Date | Most recent update |

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| A3 | `="NPI-"&TEXT(YEAR(TODAY()),"YY")&"-"&TEXT(ROW()-2,"000")` | Auto-generate Project ID |
| I3 | `=IF(H3<>"Active","N/A",IF(L3<=0,"On Track",IF(L3<=30,"At Risk","Delayed")))` | Auto-calculate health |
| L3 | `=IF(OR(ISBLANK(J3),ISBLANK(K3)),"",K3-J3)` | Launch variance days |
| P3 | `=IF(N3="","",-Settings!$B$10+NPV(Settings!$B$11,N3*O3,N3*O3*1.05,N3*O3*1.1,N3*O3*1.1,N3*O3*1.05))` | NPV calculation |

### Data Validation
```
Column D (Project_Type):
="New Product,Line Extension,Product Refresh,Cost Reduction,Compliance"

Column E (Strategic_Priority):
="High,Medium,Low"

Column F (Current_Stage):
="Concept,Feasibility,Development,Validation,Launch Prep,Launched,Post-Launch"

Column H (Project_Status):
="Active,On Hold,Cancelled,Complete"

Column S (Next_Gate_Readiness):
="Ready,Not Ready,Conditional"
```

### Conditional Formatting
```
Rule 1: Health Status Colors
- "On Track": Green fill (#C8E6C9)
- "At Risk": Yellow fill (#FFF9C4)
- "Delayed": Red fill (#FFCDD2)

Rule 2: Launch Date Approaching (within 30 days)
- J3-TODAY()<=30 AND J3>=TODAY(): Orange fill

Rule 3: Overdue Gate Reviews
- R3<TODAY() AND S3="Not Ready": Red bold text

Rule 4: High Priority Projects
- E3="High": Bold text, purple left border
```

---

## SHEET 3: Stage_Gate_Tracker

### Gate Definitions
| Gate | Name | Key Deliverables | Typical Duration |
|------|------|------------------|------------------|
| G0 | Concept Approval | Business case, market analysis | 4-8 weeks |
| G1 | Feasibility Complete | Technical feasibility, resource plan | 6-12 weeks |
| G2 | Development Complete | Design freeze, prototype | 12-24 weeks |
| G3 | Validation Complete | Testing complete, quality approval | 8-16 weeks |
| G4 | Launch Ready | Production ready, sales trained | 4-8 weeks |
| G5 | Post-Launch Review | Performance vs plan | 12 weeks post |

### Gate Progress Matrix
```
Rows: Projects (from Pipeline_Master)
Columns: G0, G1, G2, G3, G4, G5

Cell Formula (B3 for G0):
=IF(VLOOKUP($A3,Pipeline_Master!$A:$F,6,FALSE)="Concept","●",
  IF(MATCH(VLOOKUP($A3,Pipeline_Master!$A:$F,6,FALSE),Settings!$E$3:$E$9,0)>1,"✓","○"))

Legend:
✓ = Complete
● = Current Stage
○ = Future Stage
```

### Stage Duration Analysis
```
Project_ID | Stage | Entry_Date | Exit_Date | Duration_Days | Benchmark | Variance
Formulas:
Duration: =IF(ISBLANK(D3),"In Progress",D3-C3)
Variance: =E3-F3 (negative = ahead of schedule)
```

---

## SHEET 4: Resource_Planning

### Resource Allocation Matrix
| Resource_Type | Current_Projects | Hours_Allocated | Capacity | Utilization% |
|---------------|------------------|-----------------|----------|--------------|
| R&D Engineering | =FORMULA | =FORMULA | [Manual] | =FORMULA |
| Product Management | =FORMULA | =FORMULA | [Manual] | =FORMULA |
| Quality | =FORMULA | =FORMULA | [Manual] | =FORMULA |
| Manufacturing Eng | =FORMULA | =FORMULA | [Manual] | =FORMULA |
| Marketing | =FORMULA | =FORMULA | [Manual] | =FORMULA |

### Formulas
```
B3 (Current_Projects for R&D):
=SUMPRODUCT((Pipeline_Master!$H$3:$H$200="Active")*(Pipeline_Master!$F$3:$F$200<>"Launched")*1)

C3 (Hours_Allocated):
=SUMPRODUCT((Pipeline_Master!$H$3:$H$200="Active")*Resource_Hours!$B$3:$B$200)

E3 (Utilization%):
=C3/D3
```

### Resource Conflict Alert
```
F3: =IF(E3>1,"⚠ OVERLOADED",IF(E3>0.9,"⚠ HIGH",IF(E3<0.5,"Available","OK")))
```

---

## SHEET 5: Financial_Projections

### Pipeline Revenue Forecast
| Project_ID | Y1_Revenue | Y2_Revenue | Y3_Revenue | Total_3Yr | NPV | IRR |

### Formulas
```
B3: =VLOOKUP(A3,Pipeline_Master!$A:$N,14,FALSE)
C3: =B3*1.15 (15% growth assumption - adjust in Settings)
D3: =C3*1.10
E3: =SUM(B3:D3)
F3: =NPV(Settings!$B$11,B3,C3,D3)-Settings!$B$10
G3: =IRR({-Settings!$B$10,B3,C3,D3})
```

### Summary Totals
```
Total Pipeline Revenue Y1: =SUMIF(Pipeline_Master!$H:$H,"Active",Pipeline_Master!$N:$N)
Total Pipeline Revenue 3Yr: =SUM(E:E)
Weighted Pipeline (by probability): =SUMPRODUCT(Pipeline_Master!$N$3:$N$200,Stage_Probability!$B$3:$B$200)
```

### Stage Probability Factors
| Stage | Probability % |
|-------|--------------|
| Concept | 20% |
| Feasibility | 40% |
| Development | 60% |
| Validation | 80% |
| Launch Prep | 95% |
| Launched | 100% |

---

## SHEET 6: Settings

### Configuration Parameters
| Row | Parameter | Value | Description |
|-----|-----------|-------|-------------|
| 2 | Fiscal_Year | 2024 | Current FY |
| 3 | Discount_Rate | 0.10 | For NPV calculations |
| 4 | Y2_Growth_Rate | 0.15 | Year 2 growth assumption |
| 5 | Y3_Growth_Rate | 0.10 | Year 3 growth assumption |
| 8 | Gate_Review_Lead_Days | 14 | Days before gate for prep |
| 9 | Launch_Alert_Days | 30 | Days before launch for alert |
| 10 | Avg_Development_Cost | 500000 | For NPV calculation |
| 11 | Hurdle_Rate | 0.15 | Minimum IRR |

### Stage List (E3:E9)
```
Concept
Feasibility
Development
Validation
Launch Prep
Launched
Post-Launch
```

---

## NAMED RANGES

```
Name: NPIProjects
Refers to: =Pipeline_Master!$A$3:$U$200

Name: ActiveProjects
Refers to: =FILTER(Pipeline_Master!$A$3:$U$200,Pipeline_Master!$H$3:$H$200="Active")

Name: StageList
Refers to: =Settings!$E$3:$E$9

Name: DiscountRate
Refers to: =Settings!$B$3

Name: StageProbabilities
Refers to: =Stage_Probability!$A$2:$B$8
```

---

## INTEGRATION POINTS

### Links to Other Workbooks
```
1. Portfolio_Health_Dashboard.xlsx
   - Push: Upcoming launches to vitality forecast
   - Pull: Product family performance for targeting

2. Demand_Consensus_Workbook.xlsx
   - Push: NPI volumes for demand plan
   - Link: Launch dates for planning horizon

3. Capacity_Planning_Template.xlsx
   - Push: NPI volume requirements
   - Validate: Capacity availability for launches

4. Financial_Review_Rolling_Forecast.xlsx
   - Push: NPI revenue by quarter
   - Sync: Financial projections
```

---

## KEY REPORTS

### Report 1: Executive NPI Summary
- Total pipeline value
- Projects by stage
- On-time launch rate
- Resource utilization

### Report 2: Gate Review Package
- Project status
- Key milestones
- Financial metrics
- Risk assessment
- Go/No-Go recommendation

### Report 3: Launch Readiness Checklist
- Marketing materials
- Sales training
- Production readiness
- Quality approval
- Customer commitments

---

**Template Version:** Enhanced NPI Pipeline Tracker 2.0
**Refresh Frequency:** Weekly (before Product Review)
