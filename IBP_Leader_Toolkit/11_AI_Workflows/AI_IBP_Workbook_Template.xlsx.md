# AI-IBP Configuration Workbook
## Master Template for AI-Enabled IBP Setup

---

## Overview
Comprehensive workbook for configuring AI-powered IBP processes, including ML model settings, automation rules, alert thresholds, and integration parameters.

---

## Design Theme: "AI Configuration"

| Element | Specification |
|---------|---------------|
| Primary Color | Deep Blue (#1E3A5F) |
| Secondary Color | Teal (#0D9488) |
| Input Cells | Light Yellow (#FEF9C3) |
| Calculated | Light Gray (#F3F4F6) |
| AI Config | Light Purple (#EDE9FE) |

---

# SHEET 1: DASHBOARD

## AI-IBP Configuration Status

| Section | Status | Last Updated | Owner |
|---------|--------|--------------|-------|
| ML Forecasting Config | `=IF(COUNTA(ML_Config!B:B)>5,"Complete","Incomplete")` | Auto | Data Science |
| Automation Rules | `=IF(COUNTA(Automation!B:B)>10,"Complete","Incomplete")` | Auto | IBP Leader |
| Alert Thresholds | `=IF(COUNTA(Alerts!B:B)>8,"Complete","Incomplete")` | Auto | Operations |
| Integration Settings | `=IF(COUNTA(Integration!B:B)>5,"Complete","Incomplete")` | Auto | IT |
| User Permissions | `=IF(COUNTA(Permissions!B:B)>3,"Complete","Incomplete")` | Auto | Admin |

---

# SHEET 2: ML_CONFIG

## Machine Learning Model Configuration

### Forecasting Models

| Col | Header | Type | Description |
|-----|--------|------|-------------|
| A | Model_ID | Auto | Model identifier |
| B | Model_Name | Input | XGBoost, Prophet, etc. |
| C | Model_Type | Dropdown | Statistical/ML/Deep Learning |
| D | Use_Case | Dropdown | Smooth/Erratic/Intermittent/Lumpy |
| E | Min_History_Months | Input | Minimum data required |
| F | Retrain_Frequency | Dropdown | Daily/Weekly/Monthly |
| G | Hyperparameters | Input | JSON config |
| H | Feature_Set | Input | Feature list |
| I | Ensemble_Weight | Input | Weight in ensemble |
| J | Active | Dropdown | Yes/No |

### Model Configuration Examples

| Model_ID | Model_Name | Use_Case | Min_History | Retrain | Weight |
|----------|------------|----------|-------------|---------|--------|
| ML001 | XGBoost | Smooth | 24 | Weekly | 0.30 |
| ML002 | LightGBM | Smooth | 24 | Weekly | 0.25 |
| ML003 | Prophet | Seasonal | 36 | Monthly | 0.20 |
| ML004 | LSTM | Complex | 48 | Monthly | 0.15 |
| ML005 | Croston | Intermittent | 24 | Weekly | 0.10 |

### Feature Configuration

| Feature_ID | Feature_Name | Source | Update_Freq | Required |
|------------|--------------|--------|-------------|----------|
| F001 | lag_1_month | Internal | Daily | Yes |
| F002 | lag_12_month | Internal | Daily | Yes |
| F003 | rolling_mean_3m | Internal | Daily | Yes |
| F004 | seasonality_index | Calculated | Monthly | Yes |
| F005 | promo_flag | Marketing | Daily | No |
| F006 | weather_factor | External API | Daily | No |
| F007 | economic_index | External API | Monthly | No |

---

# SHEET 3: AUTOMATION_RULES

## Automation Configuration

### Process Automation Rules

| Col | Header | Description |
|-----|--------|-------------|
| A | Rule_ID | Unique identifier |
| B | Rule_Name | Descriptive name |
| C | Process | IBP process step |
| D | Trigger_Type | Schedule/Event/Condition |
| E | Trigger_Value | Cron/Event name/Condition |
| F | Action | What to automate |
| G | Auto_Execute | Yes/No/Approval Required |
| H | Approval_Level | None/Analyst/Manager/Director |
| I | Notification | Who to notify |
| J | Active | Yes/No |

### Automation Rules

| Rule_ID | Rule_Name | Process | Trigger | Action | Auto_Execute |
|---------|-----------|---------|---------|--------|--------------|
| AR001 | Daily Forecast Refresh | Demand | Schedule: 2AM | Run ML pipeline | Yes |
| AR002 | Bias Alert | Demand | Condition: TS>4 | Send alert | Yes |
| AR003 | Safety Stock Update | Supply | Schedule: Daily | Recalculate SS | Yes |
| AR004 | Stockout Alert | Supply | Condition: DOS<SS | Expedite order | Approval |
| AR005 | Executive Pack | Executive | Schedule: Fri 6AM | Generate pack | Approval |
| AR006 | Supplier Risk Alert | Supply | Condition: Risk>0.7 | Send alert | Yes |
| AR007 | Bias Correction | Demand | Condition: TS>4, 3 periods | Apply correction | Approval |
| AR008 | Order Release | Supply | Condition: Below ROP | Create PO | Yes (C items) |

---

# SHEET 4: ALERT_THRESHOLDS

## Alert Configuration

### Alert Definitions

| Col | Header | Description |
|-----|--------|-------------|
| A | Alert_ID | Unique identifier |
| B | Alert_Name | Descriptive name |
| C | Category | Demand/Supply/Financial/Risk |
| D | Metric | What to monitor |
| E | Condition | Threshold condition |
| F | Threshold_Value | Trigger value |
| G | Severity | Critical/High/Medium/Low |
| H | Response_Time | Expected response |
| I | Escalation_Path | Who to escalate to |
| J | Auto_Action | Automated response |
| K | Active | Yes/No |

### Alert Thresholds

| Alert_ID | Alert_Name | Metric | Condition | Threshold | Severity |
|----------|------------|--------|-----------|-----------|----------|
| AL001 | Tracking Signal Breach | Tracking Signal | > | 4 | High |
| AL002 | Critical TS Breach | Tracking Signal | > | 6 | Critical |
| AL003 | Stockout Risk | Days of Supply | < | Safety Days | Critical |
| AL004 | Overstock | Days of Supply | > | Max Days | High |
| AL005 | Forecast Miss | WMAPE | > | 25% | Medium |
| AL006 | Bias Persistent | Bias % | > | 10% (3 periods) | Medium |
| AL007 | Supplier Risk | Risk Score | > | 0.7 | High |
| AL008 | Service Miss | OTIF | < | Target -5% | High |
| AL009 | Revenue Gap | Rev vs Plan | < | -5% | High |
| AL010 | Margin Gap | Margin vs Plan | < | -3% | High |

---

# SHEET 5: INTEGRATION_CONFIG

## System Integration Settings

### API Connections

| Col | Header | Description |
|-----|--------|-------------|
| A | System_ID | Unique identifier |
| B | System_Name | ERP, CRM, etc. |
| C | Connection_Type | API/File/Database |
| D | Endpoint | URL or connection string |
| E | Auth_Type | OAuth/API Key/Basic |
| F | Refresh_Frequency | How often to sync |
| G | Data_Direction | Inbound/Outbound/Both |
| H | Data_Objects | What data is exchanged |
| I | Error_Handling | Retry/Alert/Skip |
| J | Active | Yes/No |

### Integration Settings

| System_ID | System_Name | Type | Refresh | Direction | Data_Objects |
|-----------|-------------|------|---------|-----------|--------------|
| INT001 | SAP ERP | API | Real-time | Both | Orders, Inventory, POs |
| INT002 | Salesforce CRM | API | Hourly | Inbound | Pipeline, Forecasts |
| INT003 | Weather API | API | Hourly | Inbound | Forecasts, Actuals |
| INT004 | ML Platform | API | On-demand | Both | Forecasts, Features |
| INT005 | BI Platform | Database | Hourly | Outbound | KPIs, Dashboards |
| INT006 | Supplier Portal | API | Daily | Both | Lead times, Capacity |

---

# SHEET 6: SERVICE_TARGETS

## Service Level Configuration

### Service Target Matrix

| Col | Header | Description |
|-----|--------|-------------|
| A | Segment | ABC-XYZ segment |
| B | Default_Service_Level | Target % |
| C | Default_Safety_Days | Min SS days |
| D | Max_Safety_Days | Max SS days |
| E | Review_Frequency | How often reviewed |
| F | Auto_Replenish | Yes/No |
| G | Approval_Required | For changes |

### Service Targets by Segment

| Segment | Service Level | Safety Days | Max Days | Review | Auto_Replenish |
|---------|---------------|-------------|----------|--------|----------------|
| AX | 99% | 14 | 45 | Weekly | No |
| AY | 98% | 21 | 60 | Weekly | No |
| AZ | 97% | 28 | 75 | Bi-weekly | No |
| BX | 97% | 14 | 45 | Bi-weekly | Yes |
| BY | 95% | 21 | 60 | Bi-weekly | Yes |
| BZ | 93% | 28 | 75 | Monthly | Yes |
| CX | 93% | 7 | 30 | Monthly | Yes |
| CY | 90% | 14 | 45 | Monthly | Yes |
| CZ | 85% | 7 | 30 | Monthly | Yes |

---

# SHEET 7: USER_PERMISSIONS

## AI System Access Control

### Permission Matrix

| Col | Header | Description |
|-----|--------|-------------|
| A | Role | User role |
| B | View_Forecasts | Yes/No |
| C | Edit_Forecasts | Yes/No |
| D | Override_ML | Yes/No |
| E | Configure_Models | Yes/No |
| F | Manage_Alerts | Yes/No |
| G | Approve_Actions | Yes/No |
| H | Admin_Access | Yes/No |

### Permission Settings

| Role | View | Edit | Override | Config | Alerts | Approve | Admin |
|------|------|------|----------|--------|--------|---------|-------|
| Viewer | Yes | No | No | No | No | No | No |
| Analyst | Yes | Yes | No | No | View | No | No |
| Planner | Yes | Yes | Yes | No | Manage | Limited | No |
| Manager | Yes | Yes | Yes | View | Manage | Yes | No |
| Director | Yes | Yes | Yes | Yes | Manage | Yes | No |
| Admin | Yes | Yes | Yes | Yes | Manage | Yes | Yes |

---

# SHEET 8: SCENARIO_CONFIG

## Scenario Planning Configuration

### Scenario Drivers

| Col | Header | Description |
|-----|--------|-------------|
| A | Driver_ID | Unique identifier |
| B | Driver_Name | Demand Volume, Cost, etc. |
| C | Category | Demand/Supply/Cost/External |
| D | Base_Value | Starting value (1.0) |
| E | Min_Value | Minimum variation |
| F | Max_Value | Maximum variation |
| G | Distribution | Normal/Lognormal/Triangular |
| H | Std_Dev | Standard deviation |
| I | Correlations | Related drivers |
| J | Active | Yes/No |

### Scenario Drivers

| Driver_ID | Driver_Name | Category | Min | Max | Distribution | Std_Dev |
|-----------|-------------|----------|-----|-----|--------------|---------|
| SD001 | Demand Volume | Demand | 0.70 | 1.30 | Normal | 0.10 |
| SD002 | Price Realization | Demand | 0.90 | 1.10 | Normal | 0.05 |
| SD003 | Raw Material Cost | Cost | 0.90 | 1.30 | Lognormal | 0.08 |
| SD004 | Labor Cost | Cost | 0.95 | 1.15 | Normal | 0.05 |
| SD005 | Capacity Utilization | Supply | 0.70 | 0.95 | Triangular | - |
| SD006 | Lead Time | Supply | 0.80 | 1.50 | Lognormal | 0.15 |
| SD007 | FX Rate | External | 0.85 | 1.15 | Normal | 0.08 |

---

# SHEET 9: LLM_CONFIG

## Large Language Model Configuration

### LLM Settings

| Setting | Value | Description |
|---------|-------|-------------|
| Provider | Claude/OpenAI | LLM provider |
| Model | claude-3-opus | Specific model |
| Temperature | 0.3 | Creativity (0-1) |
| Max Tokens | 4000 | Response length |
| System Prompt | [See below] | Base instructions |
| Use Cases | Summary, Analysis, Recommendations | Enabled uses |
| Rate Limit | 100/hour | API call limit |
| Fallback | claude-3-sonnet | Backup model |

### System Prompt Template

```
You are an AI assistant for Integrated Business Planning (IBP).

Your role is to:
1. Analyze business data and identify key insights
2. Generate executive summaries in clear business language
3. Provide root cause analysis for variances
4. Recommend actions based on data

Guidelines:
- Be concise and fact-based
- Quantify impacts where possible
- Highlight exceptions and risks
- Provide confidence levels for recommendations
- Use business terminology appropriate for executives
```

### LLM Use Case Configuration

| Use_Case | Prompt_Template | Output_Format | Review_Required |
|----------|-----------------|---------------|-----------------|
| Executive Summary | exec_summary_v1 | Narrative | Yes |
| Root Cause | root_cause_v1 | Structured | No |
| Recommendations | recommend_v1 | List | Yes |
| Scenario Narrative | scenario_v1 | Narrative | Yes |
| Risk Assessment | risk_v1 | Structured | No |

---

# SHEET 10: MONITORING

## AI Performance Monitoring

### Model Performance Metrics

| Metric | Target | Alert_Threshold | Current | Status |
|--------|--------|-----------------|---------|--------|
| Forecast WMAPE | <15% | >20% | `=Dashboard!B3` | `=IF(D3<B3,"OK","ALERT")` |
| Bias | ±3% | >±5% | `=Dashboard!B4` | Formula |
| Model Uptime | >99% | <95% | `=Dashboard!B5` | Formula |
| Prediction Latency | <5 sec | >15 sec | `=Dashboard!B6` | Formula |
| Auto-Correction Accuracy | >80% | <70% | `=Dashboard!B7` | Formula |

### Monitoring Dashboard Links

| Dashboard | URL | Refresh |
|-----------|-----|---------|
| ML Performance | [Link] | Real-time |
| Automation Status | [Link] | Hourly |
| Alert Volume | [Link] | Real-time |
| Integration Health | [Link] | 5 minutes |

---

# NAMED RANGES

| Name | Reference | Purpose |
|------|-----------|---------|
| ML_Models | ML_Config!A:J | Model configuration |
| Auto_Rules | Automation_Rules!A:J | Automation rules |
| Alert_Config | Alert_Thresholds!A:K | Alert settings |
| Service_Targets | Service_Targets!A:G | SL by segment |
| Scenario_Drivers | Scenario_Config!A:J | Scenario parameters |

---

# VBA AUTOMATION

```vba
Sub RefreshAIConfiguration()
    ' Refresh all configuration sheets
    Application.ScreenUpdating = False
    
    ThisWorkbook.Sheets("Dashboard").Calculate
    ThisWorkbook.Sheets("Monitoring").Calculate
    
    ' Validate configuration
    Dim configStatus As Boolean
    configStatus = ValidateConfiguration()
    
    If configStatus Then
        MsgBox "AI-IBP Configuration is complete and valid.", vbInformation
    Else
        MsgBox "Configuration issues detected. Please review.", vbExclamation
    End If
    
    Application.ScreenUpdating = True
End Sub

Function ValidateConfiguration() As Boolean
    ' Check required configurations
    Dim issues As String
    issues = ""
    
    If Application.WorksheetFunction.CountA(Range("ML_Models")) < 5 Then
        issues = issues & "- ML models not configured" & vbCrLf
    End If
    
    If Application.WorksheetFunction.CountA(Range("Auto_Rules")) < 10 Then
        issues = issues & "- Automation rules incomplete" & vbCrLf
    End If
    
    If issues = "" Then
        ValidateConfiguration = True
    Else
        MsgBox "Configuration Issues:" & vbCrLf & issues, vbExclamation
        ValidateConfiguration = False
    End If
End Function

Sub ExportConfiguration()
    ' Export configuration to JSON for deployment
    Dim json As String
    json = ConvertConfigToJSON()
    
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    Dim file As Object
    Set file = fso.CreateTextFile("ai_ibp_config.json", True)
    file.Write json
    file.Close
    
    MsgBox "Configuration exported to ai_ibp_config.json", vbInformation
End Sub
```

---

*AI-IBP configuration workbook for comprehensive system setup and management.*
