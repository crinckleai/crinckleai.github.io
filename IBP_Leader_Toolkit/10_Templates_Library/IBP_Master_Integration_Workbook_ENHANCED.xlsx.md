# IBP Master Integration Workbook
## Central Hub for All IBP Templates & Data Flows

---

## PURPOSE

This workbook serves as the **central integration hub** for the entire IBP toolkit, providing:
1. Consolidated data views from all IBP templates
2. Automated data flow and synchronization
3. Master reference tables used across all workbooks
4. Cross-functional reporting and analytics
5. Single source of truth for IBP process health

---

## WORKBOOK STRUCTURE

### Sheet 1: IBP_COMMAND_CENTER
### Sheet 2: Data_Connections
### Sheet 3: Master_Data
### Sheet 4: Cross_Reference_Tables
### Sheet 5: Integration_Map
### Sheet 6: Refresh_Control
### Sheet 7: Error_Log
### Sheet 8: Settings

---

## SHEET 1: IBP_COMMAND_CENTER

### Layout (Executive Control Panel)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ "IBP COMMAND CENTER" (Gradient: #1A237E → #311B92)                         │
│ Last Refresh: [DateTime] | Data Status: [Green/Yellow/Red]                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    IBP PROCESS HEALTH                                │   │
│  │                                                                      │   │
│  │   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │   │
│  │   │ PRODUCT  │ │ DEMAND   │ │ SUPPLY   │ │ FINANCE  │ │EXECUTIVE │ │   │
│  │   │  REVIEW  │ │ REVIEW   │ │ REVIEW   │ │ REVIEW   │ │   IBP    │ │   │
│  │   │   ✓      │ │   ✓      │ │   ⚠      │ │   ✓      │ │   ✓      │ │   │
│  │   │  Score:  │ │  Score:  │ │  Score:  │ │  Score:  │ │  Score:  │ │   │
│  │   │   85     │ │   82     │ │   75     │ │   88     │ │   90     │ │   │
│  │   └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │   │
│  │                                                                      │   │
│  │   OVERALL IBP MATURITY: 3.4/5.0 - INTEGRATED                        │   │
│  │   ████████████████████████████████░░░░░░░░░░░░░░░░░░░░ 68%          │   │
│  │                                                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ KEY METRICS SUMMARY                                                        │
│ ┌─────────────────────────────────────────────────────────────────────┐   │
│ │ Revenue vs Plan: +2.4%  │ Forecast Accuracy: 72%  │ OTIF: 94.2%    │   │
│ │ Margin: 34.2%          │ Plan Stability: 92%     │ Capacity: 84%   │   │
│ │ Working Capital: 8.8%  │ Bias: +2.1%            │ Inventory: 48d  │   │
│ └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ DATA QUALITY DASHBOARD                                                     │
│ ┌─────────────────────────────────────────────────────────────────────┐   │
│ │ Source            │ Status │ Last Update │ Records │ Quality Score │   │
│ │ Demand_Consensus  │   ✓    │ 2 hrs ago   │  1,245  │     98%       │   │
│ │ Supply_Capacity   │   ✓    │ 4 hrs ago   │    324  │     95%       │   │
│ │ Financial_Actuals │   ✓    │ 1 hr ago    │  2,456  │     99%       │   │
│ │ Customer_Service  │   ⚠    │ 26 hrs ago  │    892  │     92%       │   │
│ │ Inventory_Data    │   ✓    │ 3 hrs ago   │  5,678  │     96%       │   │
│ └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ QUICK LINKS TO WORKBOOKS                                                   │
│ [Calendar] [RACI] [Demand] [Supply] [Finance] [Executive] [KPIs]          │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Process Health Score Formulas
```
Product_Review_Score:
=Data_Connections!B3

Demand_Review_Score:
=Data_Connections!B4

Supply_Review_Score:
=Data_Connections!B5

Finance_Review_Score:
=Data_Connections!B6

Executive_IBP_Score:
=Data_Connections!B7

Overall_IBP_Score:
=AVERAGE(B3:B7)

Maturity_Level:
=IF(Overall>=90,"Leading",IF(Overall>=75,"Advanced",IF(Overall>=60,"Integrated",IF(Overall>=40,"Developing","Initial"))))
```

---

## SHEET 2: Data_Connections

### External Workbook Links
| Source_Workbook | Link_Path | Key_Data | Refresh_Method | Last_Refresh |
|-----------------|-----------|----------|----------------|--------------|
| IBP_Calendar_Template.xlsx | [Path] | Meeting_Status | Manual/Auto | =NOW() |
| RACI_Matrix.xlsx | [Path] | Role_Assignments | Manual | |
| Consensus_Demand_Workbook.xlsx | [Path] | Demand_Plan | Auto-Daily | |
| Forecast_Accuracy_Tracker.xlsx | [Path] | Accuracy_Metrics | Auto-Daily | |
| Capacity_Planning_Template.xlsx | [Path] | Utilization_Data | Auto-Daily | |
| Plan_vs_Actual_Analysis.xlsx | [Path] | Financial_Variance | Auto-Daily | |
| Executive_Dashboard.xlsx | [Path] | KPI_Summary | Auto-Daily | |
| IBP_KPI_Dashboard.xlsx | [Path] | Scorecard_Data | Auto-Weekly | |

### Power Query Connection Template
```
// Master Connection Query
let
    // Demand Data
    DemandSource = Excel.Workbook(File.Contents(DemandPath), null, true),
    DemandTable = DemandSource{[Item="Final_Demand_Plan",Kind="Sheet"]}[Data],

    // Supply Data
    SupplySource = Excel.Workbook(File.Contents(SupplyPath), null, true),
    SupplyTable = SupplySource{[Item="Utilization_Analysis",Kind="Sheet"]}[Data],

    // Financial Data
    FinanceSource = Excel.Workbook(File.Contents(FinancePath), null, true),
    FinanceTable = FinanceSource{[Item="Monthly_PvA",Kind="Sheet"]}[Data],

    // Combine
    Combined = Table.Combine({DemandTable, SupplyTable, FinanceTable})
in
    Combined
```

### Link Validation
```
Link_Status (D column):
=IF(ISERROR(INDIRECT("'"&B3&"'!A1")),"✗ Broken","✓ Active")

Last_Modified (E column):
=IF(D3="✓ Active",FileDateTime(B3),"N/A")
```

---

## SHEET 3: Master_Data

### Product Master
| SKU_ID | Product_Name | Family | Category | Status | Launch_Date | Standard_Cost | List_Price |
|--------|--------------|--------|----------|--------|-------------|---------------|------------|
| SKU001 | Product A | Family_1 | Cat_A | Active | 2020-01-15 | $45.00 | $89.99 |

### Customer Master
| Customer_ID | Customer_Name | Segment | Region | Territory | Account_Manager | Credit_Limit |
|-------------|---------------|---------|--------|-----------|-----------------|--------------|
| CUST001 | Customer A | Strategic | North | NE-01 | John Smith | $1,000,000 |

### Facility Master
| Facility_ID | Facility_Name | Type | Region | Capacity_Units | Operating_Days |
|-------------|---------------|------|--------|----------------|----------------|
| FAC001 | Plant Chicago | Manufacturing | NA | 100,000 | 250 |

### Formulas for Master Data Lookups
```
// Used across all workbooks
Product_Family: =VLOOKUP(SKU_ID,Master_Data!ProductMaster,3,FALSE)
Customer_Segment: =VLOOKUP(Customer_ID,Master_Data!CustomerMaster,3,FALSE)
Facility_Capacity: =VLOOKUP(Facility_ID,Master_Data!FacilityMaster,5,FALSE)
```

---

## SHEET 4: Cross_Reference_Tables

### Period Reference
| Period_ID | Month_Start | Month_End | Quarter | Fiscal_Year | Period_Name | Is_Current |
|-----------|-------------|-----------|---------|-------------|-------------|------------|
| P202401 | 2024-01-01 | 2024-01-31 | Q1 | FY2024 | January 2024 | FALSE |
| P202402 | 2024-02-01 | 2024-02-29 | Q1 | FY2024 | February 2024 | TRUE |

### KPI Reference
| KPI_ID | KPI_Name | Category | Target | Unit | Higher_Better | Weight |
|--------|----------|----------|--------|------|---------------|--------|
| KPI001 | OTIF | Customer | 95% | % | TRUE | 0.15 |
| KPI002 | Forecast_Accuracy | Process | 75% | % | TRUE | 0.20 |

### Status Codes
| Status_Code | Status_Name | Color_Hex | Display_Order |
|-------------|-------------|-----------|---------------|
| GRN | On Track | #4CAF50 | 1 |
| YEL | At Risk | #FFC107 | 2 |
| RED | Off Track | #F44336 | 3 |

### IBP Phase Reference
| Week_of_Month | Phase_Name | Key_Activities | Responsible_Role |
|---------------|------------|----------------|------------------|
| 1 | Product Review | Portfolio, NPI, Rationalization | VP Product |
| 2 | Demand Review | Forecast, Consensus, Assumptions | VP Demand Planning |
| 3 | Supply Review | Capacity, Inventory, Constraints | VP Supply Chain |
| 4 | Executive IBP | Decisions, Commitments, Actions | Executive Team |

---

## SHEET 5: Integration_Map

### Data Flow Diagram (Text Representation)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         IBP DATA INTEGRATION MAP                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                 │
│   │   ERP       │────▶│  Master     │────▶│  All IBP    │                 │
│   │  Systems    │     │   Data      │     │  Workbooks  │                 │
│   └─────────────┘     └─────────────┘     └─────────────┘                 │
│                              │                                             │
│                              ▼                                             │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                 │
│   │  Demand     │────▶│  Financial  │────▶│  Executive  │                 │
│   │  Consensus  │     │  Reconcile  │     │  Dashboard  │                 │
│   └─────────────┘     └─────────────┘     └─────────────┘                 │
│         │                    │                   │                         │
│         ▼                    ▼                   ▼                         │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                 │
│   │  Capacity   │────▶│  Gap        │────▶│   KPI       │                 │
│   │  Planning   │     │  Analysis   │     │ Dashboard   │                 │
│   └─────────────┘     └─────────────┘     └─────────────┘                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Integration Matrix
| Source | Destination | Data_Element | Frequency | Method |
|--------|-------------|--------------|-----------|--------|
| Consensus_Demand | Capacity_Planning | Volume_by_Month | Weekly | Link |
| Consensus_Demand | Financial_Review | Revenue_Forecast | Weekly | Link |
| Capacity_Planning | Executive_Dashboard | Utilization_KPI | Daily | Query |
| Forecast_Accuracy | KPI_Dashboard | Accuracy_Metric | Monthly | Link |
| Plan_vs_Actual | Executive_Dashboard | Variance_Summary | Daily | Query |
| All_Sources | Master_Integration | All_KPIs | Daily | Query |

---

## SHEET 6: Refresh_Control

### Refresh Schedule
| Workbook | Refresh_Time | Frequency | Priority | Status | Last_Run | Next_Run |
|----------|--------------|-----------|----------|--------|----------|----------|
| Financial_Actuals | 06:00 | Daily | 1 | Active | [DateTime] | [DateTime] |
| Demand_Consensus | 07:00 | Daily | 2 | Active | | |
| Capacity_Data | 07:30 | Daily | 3 | Active | | |
| KPI_Calculations | 08:00 | Daily | 4 | Active | | |
| Master_Integration | 08:30 | Daily | 5 | Active | | |

### Refresh Control VBA
```vba
Sub MasterRefresh()
    ' Refresh in priority order
    Dim wb As Workbook
    Dim refreshOrder As Variant
    refreshOrder = Array("Financial", "Demand", "Capacity", "KPI", "Master")

    For Each item In refreshOrder
        On Error Resume Next
        Set wb = Workbooks(item & ".xlsx")
        If Not wb Is Nothing Then
            wb.RefreshAll
            DoEvents
            Application.Wait Now + TimeValue("00:00:30") ' Wait 30 sec
        End If
        On Error GoTo 0
    Next item

    ' Update master timestamp
    ThisWorkbook.Sheets("Refresh_Control").Range("LastMasterRefresh").Value = Now()

    MsgBox "Master refresh complete at " & Now()
End Sub

Sub ScheduleRefresh()
    Application.OnTime TimeValue("06:00:00"), "MasterRefresh"
End Sub
```

### Refresh Status Tracking
```
Refresh_Success (F column):
=IF(E3>NOW()-1,"✓",IF(E3>NOW()-2,"⚠ Stale","✗ Failed"))

Hours_Since_Refresh:
=(NOW()-E3)*24
```

---

## SHEET 7: Error_Log

### Error Tracking
| Error_ID | Timestamp | Source_Workbook | Error_Type | Error_Message | Severity | Status | Resolution |
|----------|-----------|-----------------|------------|---------------|----------|--------|------------|
| ERR001 | [DateTime] | Demand_Consensus | Data | Missing values in column E | Medium | Resolved | Filled gaps |
| ERR002 | [DateTime] | Capacity_Planning | Link | Broken link to ERP | High | Open | IT ticket |

### Error Categories
```
Data_Error: Missing, invalid, or inconsistent data
Link_Error: Broken external links
Calc_Error: Formula errors (#REF!, #VALUE!, etc.)
Refresh_Error: Failed data refresh
Validation_Error: Business rule violations
```

### Auto-Error Detection
```vba
Sub CheckForErrors()
    Dim errorCount As Integer
    errorCount = 0

    ' Check for formula errors
    For Each cell In UsedRange
        If IsError(cell.Value) Then
            errorCount = errorCount + 1
            LogError "Calc_Error", cell.Address, CStr(cell.Value)
        End If
    Next cell

    ' Check for broken links
    For Each link In ThisWorkbook.LinkSources
        If Dir(link) = "" Then
            errorCount = errorCount + 1
            LogError "Link_Error", link, "File not found"
        End If
    Next link

    Range("TotalErrors").Value = errorCount
End Sub
```

---

## SHEET 8: Settings

### Global Configuration
| Parameter | Value | Description |
|-----------|-------|-------------|
| Organization_Name | [Enter] | Company name |
| Fiscal_Year_Start_Month | 1 | January = 1 |
| Current_Fiscal_Year | 2024 | Active FY |
| Planning_Horizon_Months | 24 | Forward planning |
| History_Months | 24 | Historical data |
| Currency_Code | USD | Reporting currency |
| Currency_Symbol | $ | Display symbol |
| Decimal_Precision | 1 | Decimal places |
| Thousands_Separator | , | Number format |
| Date_Format | MM/DD/YYYY | Date display |

### File Paths
| Workbook | File_Path |
|----------|-----------|
| IBP_Calendar | [Network path or relative] |
| RACI_Matrix | |
| Consensus_Demand | |
| Forecast_Accuracy | |
| Capacity_Planning | |
| Plan_vs_Actual | |
| Executive_Dashboard | |
| KPI_Dashboard | |

### Alert Thresholds
| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Data_Freshness_Hours | <4 | 4-24 | >24 |
| Error_Count | 0 | 1-5 | >5 |
| Link_Health_Pct | >95% | 85-95% | <85% |
| KPI_Achievement | >90% | 70-90% | <70% |

---

## NAMED RANGES (Global)

```
Name: CurrentPeriod
Refers to: =Settings!$B$5
Scope: Workbook (available to all linked workbooks)

Name: ProductMaster
Refers to: =Master_Data!$A$2:$H$5000
Scope: Workbook

Name: CustomerMaster
Refers to: =Master_Data!$J$2:$P$2000
Scope: Workbook

Name: FacilityMaster
Refers to: =Master_Data!$R$2:$W$100
Scope: Workbook

Name: KPITargets
Refers to: =Cross_Reference_Tables!$A$2:$G$50
Scope: Workbook

Name: StatusCodes
Refers to: =Cross_Reference_Tables!$I$2:$L$10
Scope: Workbook

Name: IBPPhases
Refers to: =Cross_Reference_Tables!$N$2:$Q$6
Scope: Workbook
```

---

## INTEGRATION ARCHITECTURE

### Hub-and-Spoke Model
```
                    ┌─────────────────┐
                    │     MASTER      │
                    │   INTEGRATION   │
                    │    WORKBOOK     │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Demand  │         │ Supply  │         │ Finance │
   │Templates│         │Templates│         │Templates│
   └─────────┘         └─────────┘         └─────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    EXECUTIVE    │
                    │    DASHBOARD    │
                    └─────────────────┘
```

### Data Flow Rules
1. **Master Data**: Always flows DOWN from Master Integration to individual workbooks
2. **Transaction Data**: Always flows UP from individual workbooks to Master Integration
3. **KPIs**: Calculated at source, aggregated in Master Integration
4. **Refresh**: Cascades from ERP → Master Data → Individual → Aggregation

---

## DEPLOYMENT CHECKLIST

### Initial Setup
- [ ] Configure file paths in Settings
- [ ] Update organization name and parameters
- [ ] Establish external data connections
- [ ] Set up scheduled refresh
- [ ] Test all links and queries
- [ ] Configure error notifications
- [ ] Train users on refresh procedures

### Monthly Maintenance
- [ ] Verify all links are active
- [ ] Review error log
- [ ] Update master data as needed
- [ ] Archive previous period data
- [ ] Performance optimization

---

**Template Version:** IBP Master Integration 2.0
**Purpose:** Central hub for IBP toolkit integration
**Refresh Frequency:** Daily automated + on-demand
