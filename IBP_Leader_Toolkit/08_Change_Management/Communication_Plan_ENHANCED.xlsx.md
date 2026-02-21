# Communication Plan with ADKAR Framework
## IBP Change Management - Strategic Communication Workbook

---

## Workbook Overview

**Purpose:** Comprehensive communication planning and tracking aligned with the ADKAR change management model to drive IBP adoption across the enterprise.

**ADKAR Framework:**
- **A**wareness - Understanding why change is needed
- **D**esire - Personal motivation to support the change
- **K**nowledge - Information on how to change
- **A**bility - Skills and behaviors to implement change
- **R**einforcement - Sustaining the change long-term

---

## Design Theme

| Element | Specification |
|---------|---------------|
| Primary Color | Navy Blue (#1E3A5F) |
| Accent Color | Coral Orange (#FF6B4A) |
| Success Color | Teal (#20B2AA) |
| Warning Color | Amber (#FFB347) |
| Header Font | Calibri Bold 14pt |
| Body Font | Calibri 11pt |
| Grid Lines | Light Gray (#E0E0E0) |

---

## Sheet 1: Communication_Dashboard

### Layout Structure

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **IBP COMMUNICATION DASHBOARD** (merged A1:H1) |||||||||
| 2 | Report Date: | =TODAY() | Last Updated: | =NOW() | Plan Owner: | [Name] | Phase: | [Current] |
| 3 | ||||||||
| 4 | **ADKAR PROGRESS** (merged A4:D4) |||| **OVERALL METRICS** (merged E4:H4) ||||
| 5 | Phase | Target % | Actual % | Status | Metric | Target | Actual | Variance |
| 6 | Awareness | 100% | =ADKAR_Awareness_Score | =IF(C6>=B6,"On Track","Behind") | Total Communications | =Plan_Comms_Count | =Actual_Comms_Count | =G6-F6 |
| 7 | Desire | 85% | =ADKAR_Desire_Score | =IF(C7>=B7,"On Track","Behind") | Reach Rate | 95% | =Audience_Reach_Rate | =G7-F7 |
| 8 | Knowledge | 80% | =ADKAR_Knowledge_Score | =IF(C8>=B8,"On Track","Behind") | Engagement Rate | 75% | =Engagement_Rate | =G8-F8 |
| 9 | Ability | 75% | =ADKAR_Ability_Score | =IF(C9>=B9,"On Track","Behind") | Positive Sentiment | 70% | =Positive_Sentiment_Rate | =G9-F9 |
| 10 | Reinforcement | 90% | =ADKAR_Reinforcement_Score | =IF(C10>=B10,"On Track","Behind") | Content Readiness | 100% | =Content_Ready_Rate | =G10-F10 |
| 11 | **Overall ADKAR** | 86% | =AVERAGE(C6:C10) | =IF(C11>=B11,"On Track","Behind") | Feedback Response | 48hrs | =Avg_Response_Time | =G11-F11 |

### ADKAR Progress Chart Data (Rows 13-20)

| Row | Column A | Column B | Column C | Column D | Column E |
|-----|----------|----------|----------|----------|----------|
| 13 | **ADKAR PHASE PROGRESS** |||||
| 14 | Phase | Week 1 | Week 2 | Week 3 | Week 4 |
| 15 | Awareness | =INDEX(ADKAR_Weekly,1,1) | =INDEX(ADKAR_Weekly,1,2) | =INDEX(ADKAR_Weekly,1,3) | =INDEX(ADKAR_Weekly,1,4) |
| 16 | Desire | =INDEX(ADKAR_Weekly,2,1) | =INDEX(ADKAR_Weekly,2,2) | =INDEX(ADKAR_Weekly,2,3) | =INDEX(ADKAR_Weekly,2,4) |
| 17 | Knowledge | =INDEX(ADKAR_Weekly,3,1) | =INDEX(ADKAR_Weekly,3,2) | =INDEX(ADKAR_Weekly,3,3) | =INDEX(ADKAR_Weekly,3,4) |
| 18 | Ability | =INDEX(ADKAR_Weekly,4,1) | =INDEX(ADKAR_Weekly,4,2) | =INDEX(ADKAR_Weekly,4,3) | =INDEX(ADKAR_Weekly,4,4) |
| 19 | Reinforcement | =INDEX(ADKAR_Weekly,5,1) | =INDEX(ADKAR_Weekly,5,2) | =INDEX(ADKAR_Weekly,5,3) | =INDEX(ADKAR_Weekly,5,4) |

### Communication Status Summary (Rows 22-30)

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 22 | **COMMUNICATION STATUS** ||||||
| 23 | Status | Count | % of Total | This Week | Next Week | Overdue |
| 24 | Planned | =COUNTIF(Comm_Status,"Planned") | =B24/Total_Comms | =COUNTIFS(Comm_Status,"Planned",Comm_Week,This_Week) | =COUNTIFS(Comm_Status,"Planned",Comm_Week,Next_Week) | - |
| 25 | In Progress | =COUNTIF(Comm_Status,"In Progress") | =B25/Total_Comms | =COUNTIFS(Comm_Status,"In Progress",Comm_Week,This_Week) | - | - |
| 26 | Completed | =COUNTIF(Comm_Status,"Completed") | =B26/Total_Comms | =COUNTIFS(Comm_Status,"Completed",Comm_Week,This_Week) | - | - |
| 27 | On Hold | =COUNTIF(Comm_Status,"On Hold") | =B27/Total_Comms | - | - | - |
| 28 | Cancelled | =COUNTIF(Comm_Status,"Cancelled") | =B28/Total_Comms | - | - | - |
| 29 | Overdue | =COUNTIFS(Comm_Status,"<>Completed",Comm_Due,"<"&TODAY()) | =B29/Total_Comms | - | - | =B29 |
| 30 | **Total** | =SUM(B24:B28) | 100% | =SUM(D24:D26) | =D24 | =B29 |

---

## Sheet 2: Communication_Calendar

### Column Headers (Row 1)

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Comm_ID | 12 | Text |
| B | Communication_Title | 40 | Text |
| C | ADKAR_Phase | 15 | Dropdown |
| D | Audience | 25 | Dropdown |
| E | Channel | 20 | Dropdown |
| F | Sender | 20 | Text |
| G | Scheduled_Date | 12 | Date |
| H | Scheduled_Time | 10 | Time |
| I | Duration_Min | 10 | Number |
| J | Priority | 12 | Dropdown |
| K | Status | 15 | Dropdown |
| L | Actual_Date | 12 | Date |
| M | Reach_Count | 12 | Number |
| N | Open_Rate | 10 | Percentage |
| O | Click_Rate | 10 | Percentage |
| P | Response_Count | 12 | Number |
| Q | Content_Owner | 20 | Text |
| R | Approver | 20 | Text |
| S | Approval_Date | 12 | Date |
| T | Notes | 50 | Text |

### Sample Data Rows

| Comm_ID | Communication_Title | ADKAR_Phase | Audience | Channel | Sender | Scheduled_Date | Status |
|---------|---------------------|-------------|----------|---------|--------|----------------|--------|
| COMM-001 | IBP Vision & Why Change | Awareness | All Employees | Town Hall | CEO | 2026-02-24 | Completed |
| COMM-002 | Executive Sponsor Video Message | Awareness | All Employees | Email + Video | COO | 2026-02-25 | Completed |
| COMM-003 | Department Impact Sessions | Awareness | Department Heads | Workshop | IBP Lead | 2026-02-26 | In Progress |
| COMM-004 | What's In It For Me - Sales | Desire | Sales Team | Team Meeting | Sales VP | 2026-03-01 | Planned |
| COMM-005 | What's In It For Me - Operations | Desire | Operations Team | Team Meeting | Ops VP | 2026-03-02 | Planned |
| COMM-006 | Success Stories from Pilot | Desire | All Employees | Newsletter | Change Team | 2026-03-05 | Planned |
| COMM-007 | IBP Process Training Overview | Knowledge | All IBP Users | Webinar | Training Lead | 2026-03-10 | Planned |
| COMM-008 | System Navigation Guide | Knowledge | All IBP Users | E-Learning | IT Lead | 2026-03-12 | Planned |
| COMM-009 | Role-Based Quick Reference | Knowledge | All IBP Users | Document | Training Lead | 2026-03-15 | Planned |
| COMM-010 | Hands-On Practice Sessions | Ability | All IBP Users | Workshop | Super Users | 2026-03-20 | Planned |
| COMM-011 | Go-Live Celebration | Reinforcement | All Employees | Event | Leadership | 2026-04-01 | Planned |
| COMM-012 | Monthly IBP Success Metrics | Reinforcement | All Employees | Newsletter | IBP Lead | 2026-04-15 | Planned |

### Dropdown Lists

**ADKAR_Phase:**
- Awareness
- Desire
- Knowledge
- Ability
- Reinforcement

**Channel:**
- Town Hall
- Email
- Video
- Newsletter
- Team Meeting
- Workshop
- Webinar
- E-Learning
- Intranet
- Poster/Digital Signage
- One-on-One
- Social/Collaboration Tool

**Priority:**
- Critical
- High
- Medium
- Low

**Status:**
- Planned
- In Progress
- Completed
- On Hold
- Cancelled

---

## Sheet 3: By_ADKAR_Phase

### Layout Structure

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 1 | **COMMUNICATIONS BY ADKAR PHASE** |||||||
| 2 | |||||||
| 3 | **AWARENESS PHASE** | Goal: Build understanding of why IBP change is necessary ||||||
| 4 | Target Completion: | [Date] | Current Score: | =ADKAR_Awareness_Score | Status: | =IF(D4>=80%,"Complete","In Progress") ||
| 5 | |||||||
| 6 | Communication | Audience | Channel | Date | Status | Effectiveness | Notes |
| 7 | =FILTER(Comm_Calendar,ADKAR_Phase="Awareness") ||||||

### Phase Summary Tables

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 20 | **AWARENESS METRICS** ||||
| 21 | Total Communications | =COUNTIF(ADKAR_Phase,"Awareness") |||
| 22 | Completed | =COUNTIFS(ADKAR_Phase,"Awareness",Status,"Completed") |||
| 23 | Average Reach | =AVERAGEIFS(Reach_Count,ADKAR_Phase,"Awareness") |||
| 24 | Average Engagement | =AVERAGEIFS(Open_Rate,ADKAR_Phase,"Awareness") |||
| 25 | Sentiment Score | =AVERAGEIFS(Sentiment,ADKAR_Phase,"Awareness") |||

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 30 | **DESIRE PHASE** | Goal: Create personal motivation to support IBP |||
| 31 | Target Completion: | [Date] | Current Score: | =ADKAR_Desire_Score |

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 50 | **KNOWLEDGE PHASE** | Goal: Provide information on how to participate in IBP |||
| 51 | Target Completion: | [Date] | Current Score: | =ADKAR_Knowledge_Score |

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 70 | **ABILITY PHASE** | Goal: Build skills and confidence to execute IBP processes |||
| 71 | Target Completion: | [Date] | Current Score: | =ADKAR_Ability_Score |

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 90 | **REINFORCEMENT PHASE** | Goal: Sustain adoption and prevent regression |||
| 91 | Target Completion: | [Date] | Current Score: | =ADKAR_Reinforcement_Score |

---

## Sheet 4: By_Audience

### Audience Segmentation Matrix

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **AUDIENCE COMMUNICATION MATRIX** ||||||||
| 2 | ||||||||
| 3 | Audience Segment | Population | A-Comms | D-Comms | K-Comms | AB-Comms | R-Comms | Total |
| 4 | Executive Leadership | 15 | =COUNTIFS(Audience,"*Executive*",ADKAR,"Awareness") | =COUNTIFS(Audience,"*Executive*",ADKAR,"Desire") | =COUNTIFS(Audience,"*Executive*",ADKAR,"Knowledge") | =COUNTIFS(Audience,"*Executive*",ADKAR,"Ability") | =COUNTIFS(Audience,"*Executive*",ADKAR,"Reinforcement") | =SUM(C4:G4) |
| 5 | Senior Management | 45 | Formula | Formula | Formula | Formula | Formula | =SUM(C5:G5) |
| 6 | Middle Management | 120 | Formula | Formula | Formula | Formula | Formula | =SUM(C6:G6) |
| 7 | Sales Team | 200 | Formula | Formula | Formula | Formula | Formula | =SUM(C7:G7) |
| 8 | Operations Team | 350 | Formula | Formula | Formula | Formula | Formula | =SUM(C8:G8) |
| 9 | Finance Team | 80 | Formula | Formula | Formula | Formula | Formula | =SUM(C9:G9) |
| 10 | Planning Team | 50 | Formula | Formula | Formula | Formula | Formula | =SUM(C10:G10) |
| 11 | IT Team | 40 | Formula | Formula | Formula | Formula | Formula | =SUM(C11:G11) |
| 12 | All Employees | 900 | Formula | Formula | Formula | Formula | Formula | =SUM(C12:G12) |

### Audience Engagement Tracking

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 15 | **AUDIENCE ENGAGEMENT METRICS** ||||||
| 16 | Audience | Reach Rate | Open Rate | Response Rate | Sentiment | ADKAR Score |
| 17 | Executive Leadership | =Exec_Reach | =Exec_Open | =Exec_Response | =Exec_Sentiment | =Exec_ADKAR |
| 18 | Senior Management | =SM_Reach | =SM_Open | =SM_Response | =SM_Sentiment | =SM_ADKAR |
| 19 | Middle Management | =MM_Reach | =MM_Open | =MM_Response | =MM_Sentiment | =MM_ADKAR |
| 20 | Sales Team | =Sales_Reach | =Sales_Open | =Sales_Response | =Sales_Sentiment | =Sales_ADKAR |
| 21 | Operations Team | =Ops_Reach | =Ops_Open | =Ops_Response | =Ops_Sentiment | =Ops_ADKAR |
| 22 | Finance Team | =Fin_Reach | =Fin_Open | =Fin_Response | =Fin_Sentiment | =Fin_ADKAR |
| 23 | Planning Team | =Plan_Reach | =Plan_Open | =Plan_Response | =Plan_Sentiment | =Plan_ADKAR |
| 24 | IT Team | =IT_Reach | =IT_Open | =IT_Response | =IT_Sentiment | =IT_ADKAR |

### Audience-Specific Communication Plans

| Row | Column A | Column B | Column C | Column D | Column E |
|-----|----------|----------|----------|----------|----------|
| 28 | **EXECUTIVE LEADERSHIP COMMUNICATION PLAN** |||||
| 29 | Key Messages | Preferred Channels | Frequency | Owner | Status |
| 30 | Strategic alignment with company goals | Executive briefings, 1:1 meetings | Bi-weekly | CEO/COO | Active |
| 31 | ROI and business case | Board presentations | Monthly | CFO | Active |
| 32 | Resource commitments | Steering Committee | Monthly | IBP Sponsor | Active |
| 33 | Risk mitigation | Email updates | As needed | IBP Lead | Active |

---

## Sheet 5: By_Channel

### Channel Effectiveness Analysis

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **COMMUNICATION CHANNEL ANALYSIS** ||||||||
| 2 | ||||||||
| 3 | Channel | Total Sent | Avg Reach | Avg Open Rate | Avg Click Rate | Avg Response | Effectiveness Score | Recommendation |
| 4 | Town Hall | =COUNTIF(Channel,"Town Hall") | =AVERAGEIF(Channel,"Town Hall",Reach) | =AVERAGEIF(Channel,"Town Hall",Open_Rate) | =AVERAGEIF(Channel,"Town Hall",Click_Rate) | =AVERAGEIF(Channel,"Town Hall",Response) | =AVERAGE(D4:G4)*100 | =IF(H4>75,"Increase Use",IF(H4>50,"Maintain","Reduce Use")) |
| 5 | Email | =COUNTIF(Channel,"Email") | Formula | Formula | Formula | Formula | Formula | Formula |
| 6 | Video | =COUNTIF(Channel,"Video") | Formula | Formula | Formula | Formula | Formula | Formula |
| 7 | Newsletter | =COUNTIF(Channel,"Newsletter") | Formula | Formula | Formula | Formula | Formula | Formula |
| 8 | Team Meeting | =COUNTIF(Channel,"Team Meeting") | Formula | Formula | Formula | Formula | Formula | Formula |
| 9 | Workshop | =COUNTIF(Channel,"Workshop") | Formula | Formula | Formula | Formula | Formula | Formula |
| 10 | Webinar | =COUNTIF(Channel,"Webinar") | Formula | Formula | Formula | Formula | Formula | Formula |
| 11 | E-Learning | =COUNTIF(Channel,"E-Learning") | Formula | Formula | Formula | Formula | Formula | Formula |
| 12 | Intranet | =COUNTIF(Channel,"Intranet") | Formula | Formula | Formula | Formula | Formula | Formula |
| 13 | One-on-One | =COUNTIF(Channel,"One-on-One") | Formula | Formula | Formula | Formula | Formula | Formula |

### Channel by ADKAR Phase Matrix

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 16 | **CHANNEL x ADKAR MATRIX** |||||||
| 17 | Channel | Awareness | Desire | Knowledge | Ability | Reinforcement | Best Phase |
| 18 | Town Hall | =COUNTIFS(Channel,"Town Hall",ADKAR,"Awareness") | Formula | Formula | Formula | Formula | =INDEX(ADKAR_Phases,MATCH(MAX(B18:F18),B18:F18,0)) |
| 19 | Email | Formula | Formula | Formula | Formula | Formula | Formula |
| 20 | Video | Formula | Formula | Formula | Formula | Formula | Formula |
| 21 | Workshop | Formula | Formula | Formula | Formula | Formula | Formula |
| 22 | Team Meeting | Formula | Formula | Formula | Formula | Formula | Formula |
| 23 | E-Learning | Formula | Formula | Formula | Formula | Formula | Formula |

### Channel Optimization Recommendations

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 28 | **CHANNEL OPTIMIZATION** ||||
| 29 | ADKAR Phase | Most Effective | Recommended Mix | Rationale |
| 30 | Awareness | Town Hall, Video | 40% Town Hall, 30% Video, 30% Email | High visibility needed for initial messaging |
| 31 | Desire | Team Meeting, 1:1 | 50% Team Meeting, 30% 1:1, 20% Success Stories | Personal connection builds motivation |
| 32 | Knowledge | E-Learning, Workshop | 40% E-Learning, 40% Workshop, 20% Documentation | Interactive learning most effective |
| 33 | Ability | Workshop, Practice | 60% Hands-on Workshop, 40% Simulation | Skill building requires practice |
| 34 | Reinforcement | Newsletter, Recognition | 40% Newsletter, 30% Recognition, 30% Metrics Sharing | Regular touchpoints sustain change |

---

## Sheet 6: Content_Tracker

### Content Development Status

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H | Column I | Column J |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **CONTENT DEVELOPMENT TRACKER** ||||||||||
| 2 | ||||||||||
| 3 | Content_ID | Content_Title | Type | ADKAR_Phase | Owner | Draft_Due | Draft_Status | Review_Due | Approval_Status | Final_Due |
| 4 | CNT-001 | IBP Vision Presentation | Presentation | Awareness | CEO Office | 2026-02-15 | Complete | 2026-02-18 | Approved | 2026-02-22 |
| 5 | CNT-002 | Executive Video Script | Script | Awareness | Comms Team | 2026-02-16 | Complete | 2026-02-19 | Approved | 2026-02-23 |
| 6 | CNT-003 | Department Impact Guide | Document | Awareness | IBP Lead | 2026-02-20 | In Review | 2026-02-23 | Pending | 2026-02-25 |
| 7 | CNT-004 | WIIFM Sales Deck | Presentation | Desire | Sales VP | 2026-02-25 | In Progress | 2026-02-28 | - | 2026-03-01 |
| 8 | CNT-005 | Success Story Video | Video | Desire | Comms Team | 2026-02-28 | Planned | 2026-03-03 | - | 2026-03-05 |
| 9 | CNT-006 | IBP Process Training | E-Learning | Knowledge | Training | 2026-03-01 | In Progress | 2026-03-05 | - | 2026-03-08 |
| 10 | CNT-007 | Quick Reference Cards | Document | Knowledge | Training | 2026-03-05 | Planned | 2026-03-10 | - | 2026-03-12 |
| 11 | CNT-008 | Practice Scenarios | Simulation | Ability | Training | 2026-03-10 | Planned | 2026-03-15 | - | 2026-03-18 |
| 12 | CNT-009 | Monthly Newsletter Template | Template | Reinforcement | Comms Team | 2026-03-15 | Planned | 2026-03-20 | - | 2026-03-25 |

### Additional Columns (K-P)

| Column | Header | Description |
|--------|--------|-------------|
| K | Final_Status | Complete/In Progress/Planned |
| L | Quality_Score | 1-5 rating |
| M | Reviewer | Name of reviewer |
| N | Revision_Count | Number of revisions |
| O | Storage_Location | SharePoint/Drive link |
| P | Notes | Additional comments |

### Content Status Summary

| Row | Column A | Column B | Column C | Column D | Column E |
|-----|----------|----------|----------|----------|----------|
| 20 | **CONTENT STATUS SUMMARY** |||||
| 21 | Status | Count | % Complete | On Track | At Risk |
| 22 | Complete | =COUNTIF(Final_Status,"Complete") | =B22/Total_Content | =COUNTIFS(Final_Status,"Complete",Final_Due,">="&TODAY()) | 0 |
| 23 | In Progress | =COUNTIF(Final_Status,"In Progress") | - | =COUNTIFS(Final_Status,"In Progress",Final_Due,">="&TODAY()+7) | =COUNTIFS(Final_Status,"In Progress",Final_Due,"<"&TODAY()+7) |
| 24 | Planned | =COUNTIF(Final_Status,"Planned") | - | =COUNTIFS(Final_Status,"Planned",Draft_Due,">="&TODAY()) | =COUNTIFS(Final_Status,"Planned",Draft_Due,"<"&TODAY()) |
| 25 | **Total** | =SUM(B22:B24) | =B22/B25 | =SUM(D22:D24) | =SUM(E22:E24) |

---

## Sheet 7: Feedback_Tracker

### Feedback Collection and Analysis

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G | Column H | Column I | Column J |
|-----|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| 1 | **COMMUNICATION FEEDBACK TRACKER** ||||||||||
| 2 | ||||||||||
| 3 | Feedback_ID | Date_Received | Source | ADKAR_Phase | Communication | Audience_Segment | Feedback_Type | Sentiment | Feedback_Text | Priority |
| 4 | FB-001 | 2026-02-25 | Survey | Awareness | Town Hall | All Employees | Positive | 5 | Clear explanation of why change is needed | Low |
| 5 | FB-002 | 2026-02-25 | Survey | Awareness | Town Hall | Operations | Question | 3 | When will we see the new system? | Medium |
| 6 | FB-003 | 2026-02-26 | Email | Awareness | Executive Video | Sales | Concern | 2 | Worried about impact on quota achievement | High |
| 7 | FB-004 | 2026-02-26 | Focus Group | Awareness | Dept Session | Finance | Suggestion | 4 | More detail on financial integration needed | Medium |
| 8 | FB-005 | 2026-02-27 | Survey | Awareness | Newsletter | All Employees | Positive | 5 | Great communication - keep it coming | Low |

### Additional Columns (K-Q)

| Column | Header | Description |
|--------|--------|-------------|
| K | Response_Status | Open/In Progress/Resolved |
| L | Response_Owner | Person responsible for response |
| M | Response_Date | Date response provided |
| N | Response_Text | Actual response given |
| O | Resolution_Time_Hrs | Hours to resolve |
| P | Escalated | Yes/No |
| Q | Action_Taken | Description of action |

### Sentiment Analysis Summary

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 20 | **SENTIMENT ANALYSIS** ||||||
| 21 | Sentiment Score | Count | % of Total | Trend vs Last Week | Response Rate | Avg Resolution Time |
| 22 | 5 - Very Positive | =COUNTIF(Sentiment,5) | =B22/Total_Feedback | =B22-Last_Week_5 | =COUNTIFS(Sentiment,5,Response_Status,"Resolved")/B22 | =AVERAGEIF(Sentiment,5,Resolution_Time) |
| 23 | 4 - Positive | =COUNTIF(Sentiment,4) | =B23/Total_Feedback | Formula | Formula | Formula |
| 24 | 3 - Neutral | =COUNTIF(Sentiment,3) | =B24/Total_Feedback | Formula | Formula | Formula |
| 25 | 2 - Negative | =COUNTIF(Sentiment,2) | =B25/Total_Feedback | Formula | Formula | Formula |
| 26 | 1 - Very Negative | =COUNTIF(Sentiment,1) | =B26/Total_Feedback | Formula | Formula | Formula |
| 27 | **Average Score** | =AVERAGE(Sentiment_Range) | - | =C27-Last_Week_Avg | =COUNTIF(Response_Status,"Resolved")/Total_Feedback | =AVERAGE(Resolution_Time) |

### Feedback by ADKAR Phase

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 31 | **FEEDBACK BY ADKAR PHASE** ||||||
| 32 | Phase | Total Feedback | Avg Sentiment | % Positive (4-5) | % Negative (1-2) | Top Theme |
| 33 | Awareness | =COUNTIF(Phase,"Awareness") | =AVERAGEIF(Phase,"Awareness",Sentiment) | Formula | Formula | =INDEX(Themes,MATCH(MAX(Aware_Themes),Aware_Themes,0)) |
| 34 | Desire | =COUNTIF(Phase,"Desire") | Formula | Formula | Formula | Formula |
| 35 | Knowledge | =COUNTIF(Phase,"Knowledge") | Formula | Formula | Formula | Formula |
| 36 | Ability | =COUNTIF(Phase,"Ability") | Formula | Formula | Formula | Formula |
| 37 | Reinforcement | =COUNTIF(Phase,"Reinforcement") | Formula | Formula | Formula | Formula |

### Open Issues Requiring Action

| Row | Column A | Column B | Column C | Column D | Column E | Column F |
|-----|----------|----------|----------|----------|----------|----------|
| 42 | **OPEN ISSUES** ||||||
| 43 | Issue | ADKAR Phase | Audience | Days Open | Owner | Priority |
| 44 | =FILTER(Feedback_Data,Response_Status="Open") ||||||

---

## Sheet 8: Effectiveness_Measurement

### Communication Effectiveness Scorecard

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 1 | **COMMUNICATION EFFECTIVENESS MEASUREMENT** |||||||
| 2 | |||||||
| 3 | **REACH METRICS** |||||||
| 4 | Metric | Target | Week 1 | Week 2 | Week 3 | Week 4 | Trend |
| 5 | Total Audience Reach | 95% | 78% | 85% | 90% | 93% | =TREND(C5:F5) |
| 6 | Email Open Rate | 65% | 52% | 58% | 62% | 65% | =TREND(C6:F6) |
| 7 | Event Attendance Rate | 80% | 72% | 78% | 82% | 85% | =TREND(C7:F7) |
| 8 | Intranet Page Views | 500/week | 320 | 450 | 520 | 580 | =TREND(C8:F8) |

### Engagement Metrics

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 11 | **ENGAGEMENT METRICS** |||||||
| 12 | Metric | Target | Week 1 | Week 2 | Week 3 | Week 4 | Trend |
| 13 | Click-Through Rate | 25% | 15% | 18% | 22% | 25% | Formula |
| 14 | Survey Response Rate | 40% | 25% | 32% | 38% | 42% | Formula |
| 15 | Questions Submitted | 50/week | 35 | 48 | 55 | 62 | Formula |
| 16 | Discussion Forum Posts | 30/week | 12 | 22 | 28 | 35 | Formula |
| 17 | Training Sign-ups | 100% | 65% | 78% | 88% | 95% | Formula |

### Understanding & Retention Metrics

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 20 | **UNDERSTANDING METRICS** |||||||
| 21 | Metric | Target | Week 1 | Week 2 | Week 3 | Week 4 | Trend |
| 22 | Knowledge Check Pass Rate | 85% | 68% | 75% | 82% | 86% | Formula |
| 23 | Message Recall Rate | 80% | 55% | 65% | 72% | 78% | Formula |
| 24 | Process Understanding Score | 4.0/5 | 3.2 | 3.5 | 3.8 | 4.0 | Formula |
| 25 | FAQ Reduction Rate | -20% | +15% | +5% | -8% | -18% | Formula |

### Sentiment & Attitude Metrics

| Row | Column A | Column B | Column C | Column D | Column E | Column F | Column G |
|-----|----------|----------|----------|----------|----------|----------|----------|
| 28 | **SENTIMENT METRICS** |||||||
| 29 | Metric | Target | Week 1 | Week 2 | Week 3 | Week 4 | Trend |
| 30 | Overall Sentiment Score | 4.0/5 | 3.2 | 3.5 | 3.7 | 3.9 | Formula |
| 31 | % Positive Comments | 70% | 52% | 58% | 64% | 68% | Formula |
| 32 | % Neutral Comments | 20% | 28% | 25% | 22% | 20% | Formula |
| 33 | % Negative Comments | 10% | 20% | 17% | 14% | 12% | Formula |
| 34 | Change Readiness Index | 75% | 58% | 65% | 70% | 74% | Formula |

### Effectiveness Score Calculation

| Row | Column A | Column B | Column C | Column D | Column E |
|-----|----------|----------|----------|----------|----------|
| 38 | **OVERALL EFFECTIVENESS SCORE** |||||
| 39 | Category | Weight | Score | Weighted Score | Status |
| 40 | Reach | 25% | =AVERAGE(Reach_Metrics)/Target_Reach*100 | =B40*C40 | =IF(C40>=90,"Excellent",IF(C40>=75,"Good",IF(C40>=60,"Fair","Needs Improvement"))) |
| 41 | Engagement | 25% | =AVERAGE(Engage_Metrics)/Target_Engage*100 | =B41*C41 | Formula |
| 42 | Understanding | 30% | =AVERAGE(Understand_Metrics)/Target_Understand*100 | =B42*C42 | Formula |
| 43 | Sentiment | 20% | =AVERAGE(Sentiment_Metrics)/Target_Sentiment*100 | =B43*C43 | Formula |
| 44 | **OVERALL SCORE** | 100% | - | =SUM(D40:D43) | =IF(D44>=90,"Excellent",IF(D44>=75,"Good",IF(D44>=60,"Fair","Needs Improvement"))) |

---

## Conditional Formatting Rules

### Dashboard Status Indicators

```
Rule 1: ADKAR Progress Cells (C6:C10)
- Green (#20B2AA): Value >= Target
- Yellow (#FFB347): Value >= Target - 10%
- Red (#FF6B4A): Value < Target - 10%

Rule 2: Status Column
- "Completed" = Green background
- "In Progress" = Yellow background
- "Planned" = Blue background
- "On Hold" = Gray background
- "Cancelled" = Red strikethrough

Rule 3: Sentiment Scores
- 5 = Dark Green
- 4 = Light Green
- 3 = Yellow
- 2 = Orange
- 1 = Red

Rule 4: Priority Indicators
- "Critical" = Red background, white text
- "High" = Orange background
- "Medium" = Yellow background
- "Low" = Green background

Rule 5: Date Overdue
- Date < TODAY() AND Status <> "Completed" = Red background
```

### Progress Bars

```
Data Bars for:
- ADKAR Phase completion percentages
- Content development progress
- Feedback resolution rates
- Effectiveness scores
```

---

## Named Ranges

| Range Name | Reference | Description |
|------------|-----------|-------------|
| Comm_Calendar | Communication_Calendar!A4:T500 | All communication data |
| ADKAR_Phase | Communication_Calendar!C:C | ADKAR phase column |
| Comm_Status | Communication_Calendar!K:K | Status column |
| Comm_Due | Communication_Calendar!G:G | Scheduled date column |
| Channel | Communication_Calendar!E:E | Channel column |
| Audience | Communication_Calendar!D:D | Audience column |
| Reach_Count | Communication_Calendar!M:M | Reach numbers |
| Open_Rate | Communication_Calendar!N:N | Open rates |
| Click_Rate | Communication_Calendar!O:O | Click rates |
| Response | Communication_Calendar!P:P | Response counts |
| Feedback_Data | Feedback_Tracker!A4:Q500 | All feedback data |
| Sentiment | Feedback_Tracker!H:H | Sentiment scores |
| Response_Status | Feedback_Tracker!K:K | Response status |
| Content_Status | Content_Tracker!K:K | Content status |
| ADKAR_Awareness_Score | Dashboard!C6 | Awareness score |
| ADKAR_Desire_Score | Dashboard!C7 | Desire score |
| ADKAR_Knowledge_Score | Dashboard!C8 | Knowledge score |
| ADKAR_Ability_Score | Dashboard!C9 | Ability score |
| ADKAR_Reinforcement_Score | Dashboard!C10 | Reinforcement score |
| Total_Comms | Dashboard!B30 | Total communication count |
| Effectiveness_Score | Effectiveness!D44 | Overall effectiveness |

---

## VBA Automation Code

### Module: Communication_Automation

```vba
Option Explicit

' ============================================
' COMMUNICATION PLAN AUTOMATION MODULE
' IBP Change Management Workbook
' ============================================

' Constants for styling
Private Const COLOR_NAVY As Long = 1981503      ' #1E3A5F
Private Const COLOR_CORAL As Long = 4877055     ' #FF6B4A
Private Const COLOR_TEAL As Long = 11194144     ' #20B2AA
Private Const COLOR_AMBER As Long = 3454719     ' #FFB347

' ============================================
' DASHBOARD REFRESH
' ============================================
Sub RefreshDashboard()
    Application.ScreenUpdating = False

    ' Update ADKAR scores
    Call CalculateADKARScores

    ' Update communication metrics
    Call UpdateCommunicationMetrics

    ' Update feedback analysis
    Call RefreshFeedbackAnalysis

    ' Update effectiveness scores
    Call CalculateEffectivenessScores

    ' Refresh charts
    Call RefreshAllCharts

    ' Update timestamp
    Sheets("Communication_Dashboard").Range("D2").Value = Now()

    Application.ScreenUpdating = True
    MsgBox "Dashboard refreshed successfully!", vbInformation
End Sub

' ============================================
' ADKAR SCORE CALCULATIONS
' ============================================
Sub CalculateADKARScores()
    Dim ws As Worksheet
    Dim wsCal As Worksheet
    Dim wsFB As Worksheet

    Set ws = Sheets("Communication_Dashboard")
    Set wsCal = Sheets("Communication_Calendar")
    Set wsFB = Sheets("Feedback_Tracker")

    Dim phases As Variant
    phases = Array("Awareness", "Desire", "Knowledge", "Ability", "Reinforcement")

    Dim i As Integer
    Dim completionRate As Double
    Dim sentimentScore As Double
    Dim engagementRate As Double
    Dim adkarScore As Double

    For i = 0 To 4
        ' Calculate completion rate for phase
        completionRate = CalculatePhaseCompletion(wsCal, CStr(phases(i)))

        ' Calculate sentiment for phase
        sentimentScore = CalculatePhaseSentiment(wsFB, CStr(phases(i)))

        ' Calculate engagement for phase
        engagementRate = CalculatePhaseEngagement(wsCal, CStr(phases(i)))

        ' Weighted ADKAR score (40% completion, 30% sentiment, 30% engagement)
        adkarScore = (completionRate * 0.4) + (sentimentScore * 0.3) + (engagementRate * 0.3)

        ' Write to dashboard (row 6 + i)
        ws.Cells(6 + i, 3).Value = adkarScore
    Next i
End Sub

Function CalculatePhaseCompletion(ws As Worksheet, phase As String) As Double
    Dim totalCount As Long
    Dim completedCount As Long

    totalCount = Application.WorksheetFunction.CountIf(ws.Range("C:C"), phase)
    completedCount = Application.WorksheetFunction.CountIfs(ws.Range("C:C"), phase, ws.Range("K:K"), "Completed")

    If totalCount > 0 Then
        CalculatePhaseCompletion = completedCount / totalCount
    Else
        CalculatePhaseCompletion = 0
    End If
End Function

Function CalculatePhaseSentiment(ws As Worksheet, phase As String) As Double
    Dim avgSentiment As Double

    On Error Resume Next
    avgSentiment = Application.WorksheetFunction.AverageIf(ws.Range("D:D"), phase, ws.Range("H:H"))
    On Error GoTo 0

    If avgSentiment > 0 Then
        CalculatePhaseSentiment = avgSentiment / 5  ' Normalize to 0-1
    Else
        CalculatePhaseSentiment = 0.6  ' Default neutral
    End If
End Function

Function CalculatePhaseEngagement(ws As Worksheet, phase As String) As Double
    Dim avgOpenRate As Double
    Dim avgClickRate As Double

    On Error Resume Next
    avgOpenRate = Application.WorksheetFunction.AverageIf(ws.Range("C:C"), phase, ws.Range("N:N"))
    avgClickRate = Application.WorksheetFunction.AverageIf(ws.Range("C:C"), phase, ws.Range("O:O"))
    On Error GoTo 0

    CalculatePhaseEngagement = (avgOpenRate + avgClickRate) / 2
End Function

' ============================================
' COMMUNICATION SCHEDULING
' ============================================
Sub AddNewCommunication()
    Dim ws As Worksheet
    Set ws = Sheets("Communication_Calendar")

    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row + 1

    ' Generate new Comm ID
    Dim newID As String
    newID = "COMM-" & Format(nextRow - 3, "000")

    ' Add new row with ID
    ws.Cells(nextRow, 1).Value = newID
    ws.Cells(nextRow, 11).Value = "Planned"  ' Default status

    ' Apply formatting
    Call FormatCommunicationRow(ws, nextRow)

    ' Activate cell for data entry
    ws.Cells(nextRow, 2).Select

    MsgBox "New communication " & newID & " created. Please fill in details.", vbInformation
End Sub

Sub FormatCommunicationRow(ws As Worksheet, rowNum As Long)
    With ws.Range(ws.Cells(rowNum, 1), ws.Cells(rowNum, 20))
        .Borders.LineStyle = xlContinuous
        .Borders.Weight = xlThin
    End With

    ' Add data validation for dropdowns
    With ws.Cells(rowNum, 3).Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="Awareness,Desire,Knowledge,Ability,Reinforcement"
    End With

    With ws.Cells(rowNum, 5).Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="Town Hall,Email,Video,Newsletter,Team Meeting,Workshop,Webinar,E-Learning,Intranet,One-on-One"
    End With

    With ws.Cells(rowNum, 10).Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="Critical,High,Medium,Low"
    End With

    With ws.Cells(rowNum, 11).Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="Planned,In Progress,Completed,On Hold,Cancelled"
    End With
End Sub

' ============================================
' FEEDBACK MANAGEMENT
' ============================================
Sub LogNewFeedback()
    Dim ws As Worksheet
    Set ws = Sheets("Feedback_Tracker")

    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row + 1

    ' Generate new Feedback ID
    Dim newID As String
    newID = "FB-" & Format(nextRow - 3, "000")

    ' Add new row with defaults
    ws.Cells(nextRow, 1).Value = newID
    ws.Cells(nextRow, 2).Value = Date
    ws.Cells(nextRow, 11).Value = "Open"  ' Default status

    ' Apply formatting
    Call FormatFeedbackRow(ws, nextRow)

    ws.Cells(nextRow, 3).Select
    MsgBox "New feedback " & newID & " logged. Please complete details.", vbInformation
End Sub

Sub FormatFeedbackRow(ws As Worksheet, rowNum As Long)
    With ws.Range(ws.Cells(rowNum, 1), ws.Cells(rowNum, 17))
        .Borders.LineStyle = xlContinuous
        .Borders.Weight = xlThin
    End With

    ' Sentiment validation (1-5)
    With ws.Cells(rowNum, 8).Validation
        .Delete
        .Add Type:=xlValidateWholeNumber, AlertStyle:=xlValidAlertStop, _
             Operator:=xlBetween, Formula1:=1, Formula2:=5
    End With

    ' Status validation
    With ws.Cells(rowNum, 11).Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="Open,In Progress,Resolved"
    End With
End Sub

Sub CalculateFeedbackMetrics()
    Dim ws As Worksheet
    Dim wsFB As Worksheet

    Set ws = Sheets("Communication_Dashboard")
    Set wsFB = Sheets("Feedback_Tracker")

    Dim totalFeedback As Long
    Dim positiveFeedback As Long
    Dim avgSentiment As Double
    Dim avgResponseTime As Double

    totalFeedback = Application.WorksheetFunction.CountA(wsFB.Range("A4:A500")) - 1
    positiveFeedback = Application.WorksheetFunction.CountIf(wsFB.Range("H:H"), ">=4")

    On Error Resume Next
    avgSentiment = Application.WorksheetFunction.Average(wsFB.Range("H:H"))
    avgResponseTime = Application.WorksheetFunction.Average(wsFB.Range("O:O"))
    On Error GoTo 0

    ' Update dashboard
    If totalFeedback > 0 Then
        ws.Range("G9").Value = positiveFeedback / totalFeedback
        ws.Range("G11").Value = avgResponseTime
    End If
End Sub

' ============================================
' CONTENT MANAGEMENT
' ============================================
Sub UpdateContentStatus()
    Dim ws As Worksheet
    Set ws = Sheets("Content_Tracker")

    Dim lastRow As Long
    Dim i As Long
    Dim draftDue As Date
    Dim reviewDue As Date
    Dim finalDue As Date
    Dim currentStatus As String

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    For i = 4 To lastRow
        draftDue = ws.Cells(i, 6).Value
        reviewDue = ws.Cells(i, 8).Value
        finalDue = ws.Cells(i, 10).Value
        currentStatus = ws.Cells(i, 11).Value

        ' Auto-flag overdue items
        If currentStatus <> "Complete" Then
            If finalDue < Date Then
                ws.Cells(i, 11).Interior.Color = COLOR_CORAL
                ws.Cells(i, 16).Value = "OVERDUE - Action Required"
            ElseIf finalDue < Date + 3 Then
                ws.Cells(i, 11).Interior.Color = COLOR_AMBER
                ws.Cells(i, 16).Value = "Due Soon"
            End If
        End If
    Next i
End Sub

' ============================================
' EFFECTIVENESS CALCULATIONS
' ============================================
Sub CalculateEffectivenessScores()
    Dim ws As Worksheet
    Set ws = Sheets("Effectiveness_Measurement")

    Dim reachScore As Double
    Dim engageScore As Double
    Dim understandScore As Double
    Dim sentimentScore As Double
    Dim overallScore As Double

    ' Calculate category scores (actual vs target ratios)
    reachScore = CalculateCategoryScore(ws, 5, 8, 3, 7)
    engageScore = CalculateCategoryScore(ws, 13, 17, 3, 7)
    understandScore = CalculateCategoryScore(ws, 22, 25, 3, 7)
    sentimentScore = CalculateCategoryScore(ws, 30, 34, 3, 7)

    ' Write scores
    ws.Range("C40").Value = reachScore * 100
    ws.Range("C41").Value = engageScore * 100
    ws.Range("C42").Value = understandScore * 100
    ws.Range("C43").Value = sentimentScore * 100

    ' Calculate weighted overall
    overallScore = (reachScore * 0.25) + (engageScore * 0.25) + _
                   (understandScore * 0.3) + (sentimentScore * 0.2)

    ws.Range("D44").Value = overallScore * 100
End Sub

Function CalculateCategoryScore(ws As Worksheet, startRow As Long, endRow As Long, _
                                targetCol As Long, actualCol As Long) As Double
    Dim total As Double
    Dim count As Long
    Dim i As Long

    total = 0
    count = 0

    For i = startRow To endRow
        If IsNumeric(ws.Cells(i, targetCol).Value) And _
           IsNumeric(ws.Cells(i, actualCol).Value) Then
            If ws.Cells(i, targetCol).Value > 0 Then
                total = total + (ws.Cells(i, actualCol).Value / ws.Cells(i, targetCol).Value)
                count = count + 1
            End If
        End If
    Next i

    If count > 0 Then
        CalculateCategoryScore = total / count
    Else
        CalculateCategoryScore = 0
    End If
End Function

' ============================================
' REPORTING
' ============================================
Sub GenerateWeeklyReport()
    Dim wsReport As Worksheet
    Dim wsData As Worksheet
    Dim wsFB As Worksheet

    ' Create or clear report sheet
    On Error Resume Next
    Set wsReport = Sheets("Weekly_Report")
    If wsReport Is Nothing Then
        Set wsReport = Sheets.Add(After:=Sheets(Sheets.Count))
        wsReport.Name = "Weekly_Report"
    Else
        wsReport.Cells.Clear
    End If
    On Error GoTo 0

    Set wsData = Sheets("Communication_Dashboard")
    Set wsFB = Sheets("Feedback_Tracker")

    ' Header
    With wsReport.Range("A1")
        .Value = "IBP COMMUNICATION WEEKLY REPORT"
        .Font.Bold = True
        .Font.Size = 16
        .Interior.Color = COLOR_NAVY
        .Font.Color = vbWhite
    End With

    wsReport.Range("A2").Value = "Report Date: " & Format(Date, "mmmm d, yyyy")
    wsReport.Range("A3").Value = "Week: " & Format(Date, "ww")

    ' ADKAR Summary
    wsReport.Range("A5").Value = "ADKAR PROGRESS SUMMARY"
    wsReport.Range("A5").Font.Bold = True

    wsReport.Range("A6").Value = "Phase"
    wsReport.Range("B6").Value = "Score"
    wsReport.Range("C6").Value = "Status"

    Dim phases As Variant
    phases = Array("Awareness", "Desire", "Knowledge", "Ability", "Reinforcement")

    Dim i As Integer
    For i = 0 To 4
        wsReport.Cells(7 + i, 1).Value = phases(i)
        wsReport.Cells(7 + i, 2).Value = wsData.Cells(6 + i, 3).Value
        wsReport.Cells(7 + i, 3).Value = wsData.Cells(6 + i, 4).Value
    Next i

    ' Key Metrics
    wsReport.Range("A14").Value = "KEY METRICS"
    wsReport.Range("A14").Font.Bold = True

    ' Communications this week
    wsReport.Range("A15").Value = "Communications Completed This Week:"
    wsReport.Range("B15").Value = CountWeeklyCompletions()

    ' Feedback Summary
    wsReport.Range("A16").Value = "Feedback Received:"
    wsReport.Range("B16").Value = CountWeeklyFeedback()

    wsReport.Range("A17").Value = "Average Sentiment:"
    wsReport.Range("B17").Value = Format(GetWeeklyAverageSentiment(), "0.0")

    ' Format report
    wsReport.Columns("A:C").AutoFit

    MsgBox "Weekly report generated on 'Weekly_Report' sheet.", vbInformation
End Sub

Function CountWeeklyCompletions() As Long
    Dim ws As Worksheet
    Set ws = Sheets("Communication_Calendar")

    Dim weekStart As Date
    weekStart = Date - Weekday(Date, vbMonday) + 1

    CountWeeklyCompletions = Application.WorksheetFunction.CountIfs( _
        ws.Range("K:K"), "Completed", _
        ws.Range("L:L"), ">=" & weekStart, _
        ws.Range("L:L"), "<=" & Date)
End Function

Function CountWeeklyFeedback() As Long
    Dim ws As Worksheet
    Set ws = Sheets("Feedback_Tracker")

    Dim weekStart As Date
    weekStart = Date - Weekday(Date, vbMonday) + 1

    CountWeeklyFeedback = Application.WorksheetFunction.CountIfs( _
        ws.Range("B:B"), ">=" & weekStart, _
        ws.Range("B:B"), "<=" & Date)
End Function

Function GetWeeklyAverageSentiment() As Double
    Dim ws As Worksheet
    Set ws = Sheets("Feedback_Tracker")

    On Error Resume Next
    GetWeeklyAverageSentiment = Application.WorksheetFunction.Average(ws.Range("H:H"))
    On Error GoTo 0
End Function

' ============================================
' CHART MANAGEMENT
' ============================================
Sub RefreshAllCharts()
    Dim ws As Worksheet
    Dim cht As ChartObject

    For Each ws In ThisWorkbook.Worksheets
        For Each cht In ws.ChartObjects
            cht.Chart.Refresh
        Next cht
    Next ws
End Sub

Sub CreateADKARProgressChart()
    Dim ws As Worksheet
    Set ws = Sheets("Communication_Dashboard")

    Dim cht As ChartObject

    ' Delete existing chart if present
    On Error Resume Next
    ws.ChartObjects("ADKAR_Chart").Delete
    On Error GoTo 0

    ' Create new chart
    Set cht = ws.ChartObjects.Add(Left:=500, Top:=50, Width:=400, Height:=250)
    cht.Name = "ADKAR_Chart"

    With cht.Chart
        .ChartType = xlBarClustered
        .SetSourceData Source:=ws.Range("A6:C10")
        .HasTitle = True
        .ChartTitle.Text = "ADKAR Progress by Phase"

        ' Format bars
        .SeriesCollection(1).Interior.Color = COLOR_TEAL

        ' Add target line
        .SeriesCollection(2).ChartType = xlLine
        .SeriesCollection(2).Border.Color = COLOR_CORAL
        .SeriesCollection(2).Border.Weight = 2
    End With
End Sub

' ============================================
' UTILITY FUNCTIONS
' ============================================
Sub ApplyThemeFormatting()
    Dim ws As Worksheet

    For Each ws In ThisWorkbook.Worksheets
        ' Header row formatting
        With ws.Rows(1)
            .Interior.Color = COLOR_NAVY
            .Font.Color = vbWhite
            .Font.Bold = True
        End With

        ' Column headers
        With ws.Rows(3)
            .Interior.Color = RGB(240, 240, 240)
            .Font.Bold = True
        End With
    Next ws
End Sub

Sub ProtectAllSheets()
    Dim ws As Worksheet
    Dim pwd As String

    pwd = InputBox("Enter password to protect sheets:", "Sheet Protection")

    If pwd <> "" Then
        For Each ws In ThisWorkbook.Worksheets
            ws.Protect Password:=pwd, UserInterfaceOnly:=True
        Next ws
        MsgBox "All sheets protected.", vbInformation
    End If
End Sub

Sub ExportToPDF()
    Dim fileName As String
    fileName = ThisWorkbook.Path & "\IBP_Communication_Report_" & Format(Date, "yyyymmdd") & ".pdf"

    ' Export dashboard and summary sheets
    Sheets(Array("Communication_Dashboard", "By_ADKAR_Phase", "Effectiveness_Measurement")).Select
    ActiveSheet.ExportAsFixedFormat Type:=xlTypePDF, fileName:=fileName

    Sheets("Communication_Dashboard").Select
    MsgBox "Report exported to: " & fileName, vbInformation
End Sub
```

---

## Integration Points

### Integration with Other IBP Workbooks

| Source Workbook | Data Element | Integration Method |
|-----------------|--------------|-------------------|
| Change_Readiness_Assessment | Readiness Scores | ADKAR phase targeting |
| Training_Curriculum | Training Schedule | Knowledge phase communications |
| Adoption_Tracker | Adoption Metrics | Reinforcement messaging |
| Master_Integration_Workbook | Project Timeline | Communication calendar sync |
| Stakeholder_Analysis | Stakeholder Map | Audience segmentation |

### External System Integration

| System | Integration | Data Flow |
|--------|-------------|-----------|
| Email Platform (Outlook/Gmail) | Send tracking | Open/click rates import |
| Intranet/SharePoint | Page analytics | View counts import |
| Survey Tool (Forms/Qualtrics) | Response data | Feedback import |
| LMS | Training completion | Knowledge phase metrics |
| HRIS | Employee data | Audience population |

### Data Refresh Schedule

| Data Element | Refresh Frequency | Automation |
|--------------|-------------------|------------|
| Email metrics | Daily | API pull |
| Survey responses | Real-time | Webhook |
| Training completions | Daily | LMS export |
| ADKAR scores | Weekly | VBA calculation |
| Effectiveness scores | Weekly | VBA calculation |

---

## Usage Instructions

### Initial Setup

1. **Configure Dropdowns:** Update validation lists for your organization
2. **Set Targets:** Customize ADKAR phase targets in Dashboard
3. **Define Audiences:** Update audience segments in By_Audience sheet
4. **Load Communication Plan:** Enter planned communications
5. **Enable Macros:** Required for automation features

### Daily Operations

1. Update communication status as activities complete
2. Log feedback as received
3. Record reach metrics from email/event platforms
4. Review overdue communications

### Weekly Procedures

1. Run `RefreshDashboard` macro
2. Calculate ADKAR progress scores
3. Review effectiveness metrics
4. Generate weekly report
5. Update content development status

### Monthly Review

1. Full dashboard analysis
2. ADKAR phase transition assessment
3. Channel effectiveness optimization
4. Audience engagement analysis
5. Communication plan adjustments

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-21 | IBP CoE | Initial creation |
| 1.1 | TBD | - | Enhanced ADKAR tracking |
| 1.2 | TBD | - | Advanced analytics |

---

*This workbook is part of the IBP Leader Toolkit for change management excellence.*
