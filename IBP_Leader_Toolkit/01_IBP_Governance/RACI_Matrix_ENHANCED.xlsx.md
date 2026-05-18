# RACI Matrix - Enhanced Excel Workbook
## Complete Specification with Formulas & Automation

---

## WORKBOOK STRUCTURE

### Sheet 1: DASHBOARD
### Sheet 2: RACI_Master
### Sheet 3: By_Role_View
### Sheet 4: By_Activity_View
### Sheet 5: Workload_Analysis
### Sheet 6: Settings

---

## SHEET 1: DASHBOARD

### Layout Design
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ A1:N1  HEADER BAR (Merged, Dark Teal #004D40)                              │
│        "IBP RACI MATRIX DASHBOARD"                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ A3:E10  RACI SUMMARY STATS         │ G3:N10  ACCOUNTABILITY HEATMAP        │
│ ┌───────────────────────────┐      │ ┌─────────────────────────────────┐   │
│ │ Total Activities: =COUNT  │      │ │ Shows concentration of R/A      │   │
│ │ Total Roles: =COUNT       │      │ │ assignments by role             │   │
│ │ Unassigned A's: =FORMULA  │      │ │                                 │   │
│ │ Overloaded Roles: =FORMULA│      │ └─────────────────────────────────┘   │
│ └───────────────────────────┘      │                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ A12:N25  RACI DISTRIBUTION CHART                                           │
│ (Stacked bar showing R/A/C/I distribution per role)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ A27:G35  GAPS & ISSUES             │ I27:N35  KEY INSIGHTS                 │
│ - Missing Accountable              │ - Most loaded roles                    │
│ - Multiple Accountable             │ - Least engaged roles                  │
│ - Unbalanced workload              │ - Critical dependencies                │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Dashboard Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| B4 | `=COUNTA(RACI_Master!$A$3:$A$100)-COUNTBLANK(RACI_Master!$A$3:$A$100)` | Count activities |
| B5 | `=COUNTA(RACI_Master!$C$2:$Z$2)-COUNTBLANK(RACI_Master!$C$2:$Z$2)` | Count roles |
| B6 | `=COUNTIF(RACI_Master!$C$3:$Z$100,"A")` | Total Accountable |
| B7 | `=SUMPRODUCT((COUNTIF(RACI_Master!$C3:$Z3,"A")=0)*1)` | Activities missing A |
| B8 | `=SUMPRODUCT((COUNTIF(RACI_Master!$C3:$Z3,"A")>1)*1)` | Activities with multiple A |

---

## SHEET 2: RACI_Master

### Column Structure
| Column | Header | Width | Description |
|--------|--------|-------|-------------|
| A | Activity_ID | 10 | Auto-generated ID |
| B | IBP_Process | 20 | Process area (dropdown) |
| C | Activity_Name | 40 | Description of activity |
| D-Z | [Role Names] | 8 each | RACI assignments |

### Row Structure
| Row | Content |
|-----|---------|
| 1 | Title Row |
| 2 | Role Names (headers) |
| 3+ | Activities |

### Sample Data Structure
```
     A          B                  C                    D         E         F         G         H         I
1    IBP RACI MATRIX - [Organization Name]
2    Activity_ID Process           Activity             CEO       CFO       COO       VP_Sales  VP_Supply IBP_Lead
3    ACT-001    Product Review    Portfolio Strategy    I         C         C         C         C         A
4    ACT-002    Product Review    NPI Gate Decisions    A         C         C         R         C         R
5    ACT-003    Demand Review     Statistical Forecast  I         I         I         C         I         A
6    ACT-004    Demand Review     Consensus Building    I         C         I         A         C         R
7    ACT-005    Demand Review     Demand Assumptions    I         I         I         R         C         A
```

### Key Formulas

| Cell | Formula | Purpose |
|------|---------|---------|
| A3 | `="ACT-"&TEXT(ROW()-2,"000")` | Auto-generate Activity ID |
| AA3 | `=COUNTIF($D3:$Z3,"A")` | Count Accountable per activity |
| AB3 | `=COUNTIF($D3:$Z3,"R")` | Count Responsible per activity |
| AC3 | `=COUNTIF($D3:$Z3,"C")` | Count Consulted per activity |
| AD3 | `=COUNTIF($D3:$Z3,"I")` | Count Informed per activity |
| AE3 | `=IF(AA3=0,"⚠ NO A",IF(AA3>1,"⚠ MULTI-A","✓"))` | Validation check |

### Data Validation for RACI Cells
```
Validation Type: List
Source: R,A,C,I
Allow Blank: Yes
Input Message: "R=Responsible, A=Accountable, C=Consulted, I=Informed"
Error Alert: "Please enter R, A, C, or I only"
```

### Conditional Formatting
```
Rule 1: Responsible (R)
- Range: D3:Z100
- Formula: =D3="R"
- Format: Dark Blue fill (#1565C0), White text, Bold

Rule 2: Accountable (A)
- Range: D3:Z100
- Formula: =D3="A"
- Format: Dark Red fill (#C62828), White text, Bold

Rule 3: Consulted (C)
- Range: D3:Z100
- Formula: =D3="C"
- Format: Light Yellow fill (#FFF9C4)

Rule 4: Informed (I)
- Range: D3:Z100
- Formula: =D3="I"
- Format: Light Gray fill (#E0E0E0)

Rule 5: Missing Accountable Row
- Range: A3:C100
- Formula: =COUNTIF($D3:$Z3,"A")=0
- Format: Red border, Light red fill (#FFEBEE)

Rule 6: Multiple Accountable Row
- Range: A3:C100
- Formula: =COUNTIF($D3:$Z3,"A")>1
- Format: Orange border, Light orange fill (#FFF3E0)
```

---

## SHEET 3: By_Role_View

### Purpose: Pivot view showing all activities per role

### Structure
| Column | Header | Formula/Content |
|--------|--------|-----------------|
| A | Role_Name | From RACI_Master headers |
| B | Department | Lookup from Settings |
| C | Total_Accountable | `=COUNTIF(RACI_Master!D:D,"A")` |
| D | Total_Responsible | `=COUNTIF(RACI_Master!D:D,"R")` |
| E | Total_Consulted | `=COUNTIF(RACI_Master!D:D,"C")` |
| F | Total_Informed | `=COUNTIF(RACI_Master!D:D,"I")` |
| G | Workload_Score | `=(C2*4)+(D2*3)+(E2*2)+(F2*1)` |
| H | Workload_Status | `=IF(G2>Settings!$B$10,"Overloaded",IF(G2<Settings!$B$11,"Underutilized","Balanced"))` |
| I | Accountable_Activities | `=TEXTJOIN(", ",TRUE,IF(RACI_Master!D$3:D$100="A",RACI_Master!$C$3:$C$100,""))` |

### Conditional Formatting
```
Rule 1: Overloaded
- Range: H:H
- Formula: =H2="Overloaded"
- Format: Red fill (#FFCDD2)

Rule 2: Underutilized
- Range: H:H
- Formula: =H2="Underutilized"
- Format: Yellow fill (#FFF9C4)

Rule 3: Balanced
- Range: H:H
- Formula: =H2="Balanced"
- Format: Green fill (#C8E6C9)
```

---

## SHEET 4: By_Activity_View

### Purpose: Analyze each activity's RACI completeness

### Structure
| Column | Header | Formula |
|--------|--------|---------|
| A | Activity_ID | =RACI_Master!A3 |
| B | Process | =RACI_Master!B3 |
| C | Activity | =RACI_Master!C3 |
| D | Has_Accountable | `=IF(COUNTIF(RACI_Master!D3:Z3,"A")>=1,"✓","✗")` |
| E | Accountable_Count | `=COUNTIF(RACI_Master!D3:Z3,"A")` |
| F | Has_Responsible | `=IF(COUNTIF(RACI_Master!D3:Z3,"R")>=1,"✓","✗")` |
| G | Responsible_Count | `=COUNTIF(RACI_Master!D3:Z3,"R")` |
| H | Consulted_Count | `=COUNTIF(RACI_Master!D3:Z3,"C")` |
| I | Informed_Count | `=COUNTIF(RACI_Master!D3:Z3,"I")` |
| J | Total_Involved | `=SUM(E3:I3)` |
| K | Completeness_Score | `=IF(AND(D3="✓",F3="✓",E3=1),100,IF(AND(D3="✓",F3="✓"),80,IF(D3="✓",50,0)))` |
| L | Status | `=IF(K3=100,"Complete",IF(K3>=50,"Needs Review","Incomplete"))` |
| M | Issues | `=IF(E3=0,"No Accountable",IF(E3>1,"Multiple Accountable",IF(G3=0,"No Responsible","")))` |

---

## SHEET 5: Workload_Analysis

### Purpose: Workload balancing and capacity planning

### Summary Statistics
```
Cell B3: Total Activities
=COUNTA(RACI_Master!$A$3:$A$100)

Cell B4: Total Roles
=COUNTA(RACI_Master!$D$2:$Z$2)

Cell B5: Avg Accountabilities per Role
=COUNTIF(RACI_Master!$D$3:$Z$100,"A")/COUNTA(RACI_Master!$D$2:$Z$2)

Cell B6: Avg Responsibilities per Role
=COUNTIF(RACI_Master!$D$3:$Z$100,"R")/COUNTA(RACI_Master!$D$2:$Z$2)

Cell B7: Most Accountable Role
=INDEX(RACI_Master!$D$2:$Z$2,MATCH(MAX(D10:Z10),D10:Z10,0))

Cell B8: Most Responsible Role
=INDEX(RACI_Master!$D$2:$Z$2,MATCH(MAX(D11:Z11),D11:Z11,0))
```

### Workload Matrix
```
Row 10: Accountable Count per Role
=COUNTIF(RACI_Master!D$3:D$100,"A")  (drag across)

Row 11: Responsible Count per Role
=COUNTIF(RACI_Master!D$3:D$100,"R")  (drag across)

Row 12: Consulted Count per Role
=COUNTIF(RACI_Master!D$3:D$100,"C")  (drag across)

Row 13: Informed Count per Role
=COUNTIF(RACI_Master!D$3:D$100,"I")  (drag across)

Row 14: Weighted Workload Score
=(D10*4)+(D11*3)+(D12*2)+(D13*1)  (drag across)

Row 15: Workload % of Max
=D14/MAX($D$14:$Z$14)  (drag across)
```

### Workload Threshold Formulas
```
Cell B20: Overloaded Threshold
=AVERAGE(D14:Z14)+STDEV(D14:Z14)

Cell B21: Underutilized Threshold
=AVERAGE(D14:Z14)-STDEV(D14:Z14)

Cell B22: Roles Overloaded Count
=COUNTIF(D14:Z14,">"&B20)

Cell B23: Roles Underutilized Count
=COUNTIF(D14:Z14,"<"&B21)
```

---

## SHEET 6: Settings

### Configuration Parameters
| Row | Parameter | Default Value | Description |
|-----|-----------|---------------|-------------|
| 2 | Organization_Name | [Enter] | Company name |
| 3 | IBP_Leader | [Enter] | Process owner |
| 4 | Last_Review_Date | [Date] | Last matrix review |
| 5 | Next_Review_Date | =B4+90 | Quarterly review |
| 8 | Workload_Weight_A | 4 | Weight for Accountable |
| 9 | Workload_Weight_R | 3 | Weight for Responsible |
| 10 | Overload_Threshold | 25 | Score above = overloaded |
| 11 | Underutil_Threshold | 5 | Score below = underutilized |

### IBP Process List (for dropdown)
```
B15: Product Review
B16: Demand Review
B17: Supply Review
B18: Financial Review
B19: Executive IBP
B20: Data Management
B21: Performance Management
B22: Governance
```

### Role List with Details
| Column A | Column B | Column C |
|----------|----------|----------|
| Role_Code | Role_Name | Department |
| CEO | Chief Executive Officer | Executive |
| CFO | Chief Financial Officer | Finance |
| COO | Chief Operating Officer | Operations |
| CSO | Chief Sales Officer | Sales |
| CMO | Chief Marketing Officer | Marketing |
| VP_Supply | VP Supply Chain | Supply Chain |
| VP_Demand | VP Demand Planning | Planning |
| IBP_Lead | IBP Process Leader | Planning |

---

## NAMED RANGES

```
Name: RACI_Data
Refers to: =RACI_Master!$A$3:$Z$100

Name: RoleHeaders
Refers to: =RACI_Master!$D$2:$Z$2

Name: ActivityList
Refers to: =RACI_Master!$C$3:$C$100

Name: ProcessList
Refers to: =Settings!$B$15:$B$22

Name: RACIOptions
Refers to: ={"R";"A";"C";"I"}

Name: WorkloadThresholdHigh
Refers to: =Settings!$B$10

Name: WorkloadThresholdLow
Refers to: =Settings!$B$11
```

---

## INTEGRATION POINTS

### Links to Other Workbooks
```
1. IBP_Calendar_Template.xlsx
   - Push: Facilitator names (Accountable for each review)
   - Push: Required attendees (R and A assignments)

2. Meeting_Cadence.xlsx
   - Push: Participation requirements
   - Validate: Role involvement levels

3. Stakeholder_Analysis.xlsx
   - Sync: Role definitions
   - Push: Involvement levels for change management

4. Training_Curriculum.xlsx
   - Push: Role-based training requirements
   - Link: Competency needs by responsibility level
```

### Power Query for Role Analysis
```
// Query: Roles Needing Attention
let
    Source = Excel.CurrentWorkbook(){[Name="By_Role_View"]}[Content],
    FilteredRows = Table.SelectRows(Source, each [Workload_Status] <> "Balanced"),
    SortedRows = Table.Sort(FilteredRows,{{"Workload_Score", Order.Descending}})
in
    SortedRows
```

---

## CHARTS TO INCLUDE

### Chart 1: RACI Distribution by Role (Stacked Bar)
```
Data Range: By_Role_View C:F
Chart Type: Stacked Horizontal Bar
Series: Accountable, Responsible, Consulted, Informed
Colors: #C62828, #1565C0, #FFF9C4, #E0E0E0
```

### Chart 2: Workload Balance (Column Chart)
```
Data Range: Workload_Analysis D14:Z14
Chart Type: Column
Threshold Lines: Overload (red), Underutil (yellow)
```

### Chart 3: Completeness Score (Donut Chart)
```
Data: Count of Complete, Needs Review, Incomplete
Colors: Green, Yellow, Red
```

---

## VALIDATION RULES

### Business Rules Enforced
1. Every activity MUST have exactly one Accountable (A)
2. Every activity SHOULD have at least one Responsible (R)
3. The Accountable cannot be the same as Responsible for executive decisions
4. No role should exceed workload threshold without review
5. RACI matrix must be reviewed quarterly

### Formula-Based Validation
```
Cell AE3 (Validation Status):
=IF(COUNTIF($D3:$Z3,"A")=0,"❌ Missing A",
  IF(COUNTIF($D3:$Z3,"A")>1,"⚠️ Multiple A",
    IF(COUNTIF($D3:$Z3,"R")=0,"⚠️ No R",
      "✅ Valid")))
```

---

## PRINT SETTINGS

### Full Matrix Print
- Range: A1:Z+last row
- Orientation: Landscape
- Scale: Fit to 1 page wide
- Repeat Rows: 1-2 (headers)
- Repeat Columns: A-C (Activity info)

### Role Summary Print
- Range: By_Role_View
- Orientation: Portrait
- Include: Role name, counts, status

---

**Template Version:** Enhanced RACI Matrix 2.0
**Last Updated:** [Auto: =TODAY()]
**Review Frequency:** Quarterly
