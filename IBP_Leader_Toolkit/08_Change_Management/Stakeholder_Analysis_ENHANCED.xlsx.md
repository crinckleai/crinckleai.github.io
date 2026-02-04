# Stakeholder Analysis & Engagement Workbook - Enhanced Specification

## Overview

This workbook provides a comprehensive stakeholder analysis and engagement management tool for IBP change management programs. It enables change leaders to map stakeholders by power/interest, track attitude journeys, plan engagement activities, analyze resistance, and build coalitions of champions. The workbook integrates with the broader IBP Change Management toolkit through named ranges and cross-references.

## Design Theme

| Element | Specification |
|---------|--------------|
| Primary Header Color | Navy `#1B2A4A` |
| Accent Color | Orange `#EA580C` |
| Secondary Accent | Light Orange `#FED7AA` |
| Background | White `#FFFFFF` |
| Alternate Row | `#F8FAFC` |
| Font - Headers | Segoe UI Semibold, 11pt, White `#FFFFFF` |
| Font - Body | Segoe UI, 10pt, Dark Gray `#1E293B` |
| Font - KPI Values | Segoe UI Bold, 24pt, Navy `#1B2A4A` |
| Borders | Thin, `#E2E8F0` |
| Gridlines | Hidden on all sheets |
| Tab Colors | Sheet 1: Gray, Sheet 2: Orange, Sheets 3-10: Navy gradient |

---

## Sheet 1: Settings & Configuration

### Purpose
Central configuration sheet storing all lookup values, scale definitions, and design parameters used across the workbook.

### Layout

| Row | Column A | Column B | Column C | Column D |
|-----|----------|----------|----------|----------|
| 1 | **STAKEHOLDER ANALYSIS CONFIGURATION** (merged A1:D1) | | | |
| 3 | **Influence Scale** | | | |
| 4 | Score | Label | Description | Strategy Implication |
| 5 | 5 | Very High | Can single-handedly approve/block initiative | Must have active support |
| 6 | 4 | High | Significant influence on outcomes | Needs targeted engagement |
| 7 | 3 | Medium | Moderate influence through others | Regular communication |
| 8 | 2 | Low | Limited influence on initiative | Keep informed |
| 9 | 1 | Very Low | Minimal influence | Monitor only |
| 11 | **Interest Scale** | | | |
| 12 | Score | Label | Description | |
| 13 | 5 | Very High | Directly impacted, high engagement | |
| 14 | 4 | High | Significantly affected by change | |
| 15 | 3 | Medium | Moderately affected | |
| 16 | 2 | Low | Slightly affected | |
| 17 | 1 | Very Low | Minimally affected | |
| 19 | **Attitude Scale** | | | |
| 20 | Score | Attitude | Description | Color Code |
| 21 | 1 | Resistant | Actively opposes the change | `#EF4444` |
| 22 | 2 | Skeptical | Doubts the change will succeed | `#F97316` |
| 23 | 3 | Neutral | Neither supports nor opposes | `#F59E0B` |
| 24 | 4 | Supportive | Generally supports the change | `#22C55E` |
| 25 | 5 | Champion | Actively advocates for the change | `#059669` |
| 27 | **Engagement Strategy Templates** | | | |
| 28 | Quadrant | Strategy | Activities | Frequency |
| 29 | Manage Closely | High-touch, collaborative | 1:1 meetings, co-design workshops, steering committee | Weekly |
| 30 | Keep Satisfied | Regular updates, consultation | Executive briefings, progress reports, ad-hoc meetings | Bi-weekly |
| 31 | Keep Informed | Proactive communication | Newsletters, town halls, status updates | Monthly |
| 32 | Monitor | Passive monitoring | General communications, open forums | Quarterly |
| 34 | **Gap Classification** | | | |
| 35 | Gap Value | Classification | Color | Action Required |
| 36 | >=3 | Very High | `#EF4444` | Immediate intervention |
| 37 | 2 | High | `#F97316` | Priority engagement plan |
| 38 | 1 | Medium | `#F59E0B` | Structured engagement |
| 39 | 0 | Low | `#22C55E` | Maintain current approach |
| 40 | <0 | Exceeding | `#059669` | Leverage as champion |
| 42 | **Contact Frequency Standards** | | | |
| 43 | Quadrant | Min Contacts/Month | Preferred Channel | |
| 44 | Manage Closely | 4 | Face-to-face, 1:1 | |
| 45 | Keep Satisfied | 2 | Meeting, email | |
| 46 | Keep Informed | 1 | Email, newsletter | |
| 47 | Monitor | 0.25 | Newsletter, portal | |

### Named Ranges

| Range Name | Reference | Scope |
|------------|-----------|-------|
| Influence_Scale | Settings!$A$5:$B$9 | Workbook |
| Interest_Scale | Settings!$A$13:$B$17 | Workbook |
| Attitude_Scale | Settings!$A$21:$B$25 | Workbook |
| Attitude_Labels | Settings!$B$21:$B$25 | Workbook |
| Attitude_Scores | Settings!$A$21:$A$25 | Workbook |
| Gap_Classification | Settings!$A$36:$B$40 | Workbook |
| Engagement_Templates | Settings!$A$29:$D$32 | Workbook |

---

## Sheet 2: Stakeholder Dashboard

### Purpose
Executive summary dashboard showing stakeholder landscape, attitude distribution, engagement health, and key alerts.

### Layout

**Row 1-2: Header Bar**
- Merged A1:N1: "STAKEHOLDER ANALYSIS DASHBOARD" - Navy background, white text, 14pt bold
- Merged A2:N2: "IBP Change Management Program" - Navy background, white text, 10pt

**Row 4-6: KPI Cards (4 cards across)**

| Card | Cell Range | Label | Formula | Format |
|------|-----------|-------|---------|--------|
| Total Stakeholders | B4:D6 | Total Stakeholders | `=COUNTA(Register!B:B)-1` | Integer, 24pt bold |
| At-Risk Count | F4:H6 | At Risk | `=COUNTIF(Register!$L:$L,"High")+COUNTIF(Register!$L:$L,"Very High")` | Integer, Red `#EF4444` |
| Champions | J4:L6 | Champions | `=COUNTIF(Register!$I:$I,"Champion")` | Integer, Green `#059669` |
| Engagement Health | N4:P6 | On Track % | `=COUNTIF(Engagement!$H:$H,"On Track")/COUNTA(Engagement!$H:$H)` | Percentage, 24pt |

**Row 8-16: Power/Interest Grid Summary**

| Cell | Content | Formula |
|------|---------|---------|
| B8 | "POWER / INTEREST GRID" | Header |
| B10 | Manage Closely Count | `=COUNTIF(Matrix!$E:$E,"Manage Closely")` |
| D10 | Keep Satisfied Count | `=COUNTIF(Matrix!$E:$E,"Keep Satisfied")` |
| B12 | Keep Informed Count | `=COUNTIF(Matrix!$E:$E,"Keep Informed")` |
| D12 | Monitor Count | `=COUNTIF(Matrix!$E:$E,"Monitor")` |

**Row 8-16: Attitude Distribution (right side)**

| Cell | Content | Formula |
|------|---------|---------|
| H8 | "ATTITUDE DISTRIBUTION" | Header |
| H10 | Champion | `=COUNTIF(Register!$I:$I,"Champion")` |
| H11 | Supportive | `=COUNTIF(Register!$I:$I,"Supportive")` |
| H12 | Neutral | `=COUNTIF(Register!$I:$I,"Neutral")` |
| H13 | Skeptical | `=COUNTIF(Register!$I:$I,"Skeptical")` |
| H14 | Resistant | `=COUNTIF(Register!$I:$I,"Resistant")` |
| I10:I14 | Bar visualization | `=REPT("█",H10)` repeated for visual bar |

**Row 18-26: Engagement Health Summary**

| Cell | Content | Formula |
|------|---------|---------|
| B18 | "ENGAGEMENT HEALTH" | Header |
| B20 | On Track | `=COUNTIF(Engagement!$H:$H,"On Track")` |
| B21 | Needs Attention | `=COUNTIF(Engagement!$H:$H,"Needs Attention")` |
| B22 | At Risk | `=COUNTIF(Engagement!$H:$H,"At Risk")` |
| D20 | On Track % | `=B20/SUM(B20:B22)` |

**Row 18-26: Contact Alerts (right side)**

| Cell | Content | Formula |
|------|---------|---------|
| H18 | "CONTACT ALERTS" | Header |
| H20 | Overdue Contacts | `=COUNTIF(Register!$O:$O,"OVERDUE")` |
| H21 | Due Soon | `=COUNTIF(Register!$O:$O,"DUE SOON")` |
| H22 | OK | `=COUNTIF(Register!$O:$O,"OK")` |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| N4:P6 (Health %) | >=0.8 | Background `#DCFCE7`, Font `#059669` |
| N4:P6 (Health %) | >=0.5 AND <0.8 | Background `#FEF3C7`, Font `#D97706` |
| N4:P6 (Health %) | <0.5 | Background `#FEE2E2`, Font `#DC2626` |
| F4:H6 (At Risk) | >5 | Background `#FEE2E2`, Font `#DC2626` |
| F4:H6 (At Risk) | >0 AND <=5 | Background `#FEF3C7`, Font `#D97706` |
| F4:H6 (At Risk) | =0 | Background `#DCFCE7`, Font `#059669` |

---

## Sheet 3: Stakeholder Register

### Purpose
Master register of all stakeholders with complete profiling, gap analysis, and contact tracking.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | ID | 6 | Auto-number | `="SH-"&TEXT(ROW()-1,"000")` |
| B | Stakeholder Name | 22 | Text | Full name |
| C | Role / Title | 20 | Text | Job title |
| D | Department | 16 | Text | Organizational unit |
| E | Region | 12 | Dropdown | NA, EMEA, APAC, LATAM, MEA |
| F | Influence | 12 | Dropdown | Very High, High, Medium, Low, Very Low |
| G | Interest | 12 | Dropdown | Very High, High, Medium, Low, Very Low |
| H | Influence Score | 8 | Formula | `=MATCH(F2,{"Very Low","Low","Medium","High","Very High"},0)` |
| I | Current Attitude | 14 | Dropdown | Resistant, Skeptical, Neutral, Supportive, Champion |
| J | Desired Attitude | 14 | Dropdown | Resistant, Skeptical, Neutral, Supportive, Champion |
| K | Attitude Gap | 10 | Formula | `=MATCH(J2,Attitude_Labels,0)-MATCH(I2,Attitude_Labels,0)` |
| L | Gap Classification | 12 | Formula | `=IF(K2>=3,"Very High",IF(K2=2,"High",IF(K2=1,"Medium",IF(K2=0,"Low","Exceeding"))))` |
| M | Quadrant | 16 | Formula | `=IF(AND(H2>=4,MATCH(G2,{"Very Low","Low","Medium","High","Very High"},0)>=4),"Manage Closely",IF(AND(H2>=4,MATCH(G2,{"Very Low","Low","Medium","High","Very High"},0)<4),"Keep Satisfied",IF(AND(H2<4,MATCH(G2,{"Very Low","Low","Medium","High","Very High"},0)>=4),"Keep Informed","Monitor")))` |
| N | Last Contact Date | 14 | Date | dd-mmm-yyyy |
| O | Days Since Contact | 10 | Formula | `=IF(N2="","N/A",TODAY()-N2)` |
| P | Contact Urgency | 12 | Formula | `=IF(O2="N/A","UNKNOWN",IF(O2>30,"OVERDUE",IF(O2>14,"DUE SOON","OK")))` |
| Q | Primary Concern | 20 | Text | Main concern about the change |
| R | Engagement Owner | 16 | Text | Person responsible for engagement |
| S | Notes | 30 | Text | Additional notes |

### Data Validation Rules

| Column | Validation Type | Source | Error Message |
|--------|----------------|--------|---------------|
| E | List | "NA,EMEA,APAC,LATAM,MEA" | Select a valid region |
| F | List | "Very High,High,Medium,Low,Very Low" | Select influence level |
| G | List | "Very High,High,Medium,Low,Very Low" | Select interest level |
| I | List | Attitude_Labels named range | Select current attitude |
| J | List | Attitude_Labels named range | Select desired attitude |
| N | Date | Between 1/1/2024 and 12/31/2030 | Enter a valid date |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| I2:I100 | ="Resistant" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| I2:I100 | ="Skeptical" | Background `#FFEDD5`, Font `#EA580C` |
| I2:I100 | ="Neutral" | Background `#FEF3C7`, Font `#D97706` |
| I2:I100 | ="Supportive" | Background `#DCFCE7`, Font `#16A34A` |
| I2:I100 | ="Champion" | Background `#D1FAE5`, Font `#059669`, Bold |
| L2:L100 | ="Very High" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| L2:L100 | ="High" | Background `#FFEDD5`, Font `#EA580C` |
| L2:L100 | ="Medium" | Background `#FEF3C7`, Font `#D97706` |
| L2:L100 | ="Low" | Background `#DCFCE7`, Font `#16A34A` |
| P2:P100 | ="OVERDUE" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| P2:P100 | ="DUE SOON" | Background `#FEF3C7`, Font `#D97706` |
| P2:P100 | ="OK" | Background `#DCFCE7`, Font `#16A34A` |

### Sample Data (Rows 2-6)

| ID | Name | Role | Dept | Region | Influence | Interest | Attitude | Desired | Gap |
|----|------|------|------|--------|-----------|----------|----------|---------|-----|
| SH-001 | Sarah Chen | VP Supply Chain | Operations | NA | Very High | Very High | Supportive | Champion | 1 |
| SH-002 | Marcus Webb | CFO | Finance | NA | Very High | High | Skeptical | Supportive | 2 |
| SH-003 | Elena Rossi | Regional Director | Sales | EMEA | High | Very High | Neutral | Supportive | 1 |
| SH-004 | Raj Patel | IT Director | Technology | APAC | High | Medium | Resistant | Neutral | 2 |
| SH-005 | Anna Muller | Plant Manager | Operations | EMEA | Medium | High | Neutral | Champion | 2 |

---

## Sheet 4: Power/Interest Matrix

### Purpose
Grid mapping of stakeholders into four quadrants based on influence and interest levels, with strategy recommendations.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Formula | `=Register!A2` |
| B | Stakeholder Name | 22 | Formula | `=Register!B2` |
| C | Influence Score | 10 | Formula | `=Register!H2` |
| D | Interest Score | 10 | Formula | `=MATCH(Register!G2,{"Very Low","Low","Medium","High","Very High"},0)` |
| E | Quadrant | 16 | Formula | `=IF(AND(C2>=4,D2>=4),"Manage Closely",IF(AND(C2>=4,D2<4),"Keep Satisfied",IF(AND(C2<4,D2>=4),"Keep Informed","Monitor")))` |
| F | Recommended Strategy | 30 | Formula | `=VLOOKUP(E2,Engagement_Templates,2,FALSE)` |
| G | Recommended Activities | 30 | Formula | `=VLOOKUP(E2,Engagement_Templates,3,FALSE)` |
| H | Contact Frequency | 16 | Formula | `=VLOOKUP(E2,Engagement_Templates,4,FALSE)` |

### Grid Visualization Data (Rows 20-35)

```
Row 20: POWER / INTEREST MATRIX (Header, merged)
Row 22-24: HIGH INFLUENCE section
  Col B-E: "Keep Satisfied" quadrant label and stakeholder list
  Col F-I: "Manage Closely" quadrant label and stakeholder list

Row 26-28: LOW INFLUENCE section
  Col B-E: "Monitor" quadrant label and stakeholder list
  Col F-I: "Keep Informed" quadrant label and stakeholder list

Row 30: Axis labels - LOW INTEREST → HIGH INTEREST
```

### Quadrant Summary Table (Row 36+)

| Cell | Content | Formula |
|------|---------|---------|
| B37 | Manage Closely | Count: `=COUNTIF($E:$E,"Manage Closely")` |
| B38 | Keep Satisfied | Count: `=COUNTIF($E:$E,"Keep Satisfied")` |
| B39 | Keep Informed | Count: `=COUNTIF($E:$E,"Keep Informed")` |
| B40 | Monitor | Count: `=COUNTIF($E:$E,"Monitor")` |

### Conditional Formatting

| Range | Rule | Format |
|-------|------|--------|
| E2:E100 | ="Manage Closely" | Background `#FEE2E2`, Font `#DC2626` |
| E2:E100 | ="Keep Satisfied" | Background `#FEF3C7`, Font `#D97706` |
| E2:E100 | ="Keep Informed" | Background `#DBEAFE`, Font `#2563EB` |
| E2:E100 | ="Monitor" | Background `#F1F5F9`, Font `#64748B` |

---

## Sheet 5: Attitude Journey

### Purpose
Track desired attitude movement for each stakeholder, calculate priority based on influence and gap size.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Formula | `=Register!A2` |
| B | Stakeholder Name | 22 | Formula | `=Register!B2` |
| C | Current Attitude | 14 | Formula | `=Register!I2` |
| D | Current Score | 8 | Formula | `=MATCH(C2,Attitude_Labels,0)` |
| E | Desired Attitude | 14 | Formula | `=Register!J2` |
| F | Desired Score | 8 | Formula | `=MATCH(E2,Attitude_Labels,0)` |
| G | Gap (Levels) | 10 | Formula | `=F2-D2` |
| H | Influence Score | 10 | Formula | `=Register!H2` |
| I | Priority Score | 10 | Formula | `=H2*ABS(G2)` |
| J | Priority Level | 12 | Formula | `=IF(I2>=8,"Critical",IF(I2>=5,"High",IF(I2>=3,"Medium","Low")))` |
| K | Movement Description | 25 | Formula | `=C2&" --> "&E2` |
| L | Strategy Notes | 30 | Text | Specific approach for this stakeholder |
| M | Target Date | 12 | Date | When attitude shift should be achieved |
| N | Actual Attitude (Current) | 14 | Dropdown | Current actual attitude for tracking |
| O | Progress | 10 | Formula | `=IF(G2=0,"At Target",IF(MATCH(N2,Attitude_Labels,0)-D2>=G2,"Achieved",IF(MATCH(N2,Attitude_Labels,0)>D2,"Progressing","No Change")))` |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| J2:J100 | ="Critical" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| J2:J100 | ="High" | Background `#FFEDD5`, Font `#EA580C` |
| J2:J100 | ="Medium" | Background `#FEF3C7`, Font `#D97706` |
| J2:J100 | ="Low" | Background `#DCFCE7`, Font `#16A34A` |
| O2:O100 | ="Achieved" | Background `#D1FAE5`, Font `#059669` |
| O2:O100 | ="Progressing" | Background `#DBEAFE`, Font `#2563EB` |
| O2:O100 | ="No Change" | Background `#FEF3C7`, Font `#D97706` |

---

## Sheet 6: Engagement Plans

### Purpose
Detailed per-stakeholder engagement activity planning with tracking and compliance measurement.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Text | Reference to Register |
| B | Stakeholder Name | 22 | Formula | `=VLOOKUP(A2,Register!$A:$B,2,FALSE)` |
| C | Quadrant | 16 | Formula | `=VLOOKUP(A2,Register!$A:$M,13,FALSE)` |
| D | Activity Description | 30 | Text | Engagement activity |
| E | Activity Type | 14 | Dropdown | 1:1 Meeting, Workshop, Email, Presentation, Town Hall, Coaching |
| F | Planned Date | 12 | Date | Scheduled date |
| G | Actual Date | 12 | Date | Completed date |
| H | Status | 12 | Formula | `=IF(G2<>"","Complete",IF(F2<TODAY(),"OVERDUE",IF(F2<TODAY()+7,"THIS WEEK","Planned")))` |
| I | Required Contacts/Month | 8 | Formula | `=VLOOKUP(C2,Settings!$A$29:$D$32,4,FALSE)` |
| J | Actual Contacts This Month | 8 | Formula | `=COUNTIFS($A:$A,A2,$G:$G,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),$G:$G,"<="&EOMONTH(TODAY(),0))` |
| K | Frequency Compliance | 12 | Formula | `=IF(J2>=I2,"Compliant","Gap")` |
| L | Next Action | 25 | Text | Next planned engagement |
| M | Next Action Date | 12 | Date | When next action occurs |
| N | Owner | 16 | Text | Responsible person |
| O | Notes / Outcome | 30 | Text | Activity notes |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| H2:H200 | ="OVERDUE" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| H2:H200 | ="THIS WEEK" | Background `#FEF3C7`, Font `#D97706` |
| H2:H200 | ="Complete" | Background `#DCFCE7`, Font `#16A34A` |
| H2:H200 | ="Planned" | Background `#F1F5F9`, Font `#64748B` |
| K2:K200 | ="Gap" | Background `#FEE2E2`, Font `#DC2626` |
| K2:K200 | ="Compliant" | Background `#DCFCE7`, Font `#16A34A` |

### Data Validation

| Column | Validation | Source |
|--------|-----------|--------|
| E | List | "1:1 Meeting,Workshop,Email,Presentation,Town Hall,Coaching,Site Visit,Phone Call" |
| F, G, M | Date | Between 1/1/2024 and 12/31/2030 |

---

## Sheet 7: Communication Preferences

### Purpose
Document preferred communication channels, formats, timing, and contact details for each stakeholder.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Text | Reference |
| B | Stakeholder Name | 22 | Formula | `=VLOOKUP(A2,Register!$A:$B,2,FALSE)` |
| C | Preferred Channel | 14 | Dropdown | Face-to-Face, Video Call, Phone, Email, Teams/Slack, Portal |
| D | Secondary Channel | 14 | Dropdown | Same list |
| E | Preferred Format | 14 | Dropdown | Detailed Report, Executive Summary, Visual/Infographic, Data Table, Presentation |
| F | Best Time | 14 | Dropdown | Morning, Afternoon, End of Day, No Preference |
| G | Best Day | 12 | Dropdown | Monday, Tuesday, Wednesday, Thursday, Friday |
| H | Email Address | 24 | Text | Contact email |
| I | Phone | 16 | Text | Contact phone |
| J | Assistant/EA | 16 | Text | Executive assistant name |
| K | Meeting Frequency | 14 | Dropdown | Weekly, Bi-weekly, Monthly, Quarterly, As Needed |
| L | Communication Style | 16 | Dropdown | Direct/Concise, Detailed/Analytical, Collaborative, Formal, Casual |
| M | Key Topics of Interest | 25 | Text | What they care most about |
| N | Avoid Topics | 20 | Text | Sensitive subjects |
| O | Last Updated | 12 | Date | Last update to preferences |

---

## Sheet 8: Resistance Analysis

### Purpose
Identify, categorize, and plan mitigation for stakeholder resistance to the IBP change program.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Text | Reference |
| B | Stakeholder Name | 22 | Formula | `=VLOOKUP(A2,Register!$A:$B,2,FALSE)` |
| C | Resistance Type | 16 | Dropdown | Technical, Political, Cultural, Personal, Resource, Unknown |
| D | Resistance Source | 20 | Text | Root cause of resistance |
| E | Current Attitude | 14 | Formula | `=VLOOKUP(A2,Register!$A:$I,9,FALSE)` |
| F | Resistance Score | 10 | Formula | `=IF(E2="Resistant",5,IF(E2="Skeptical",4,IF(E2="Neutral",3,IF(E2="Supportive",2,1))))` |
| G | Influence Score | 10 | Formula | `=VLOOKUP(A2,Register!$A:$H,8,FALSE)` |
| H | Risk Score | 10 | Formula | `=F2*G2` |
| I | Risk Level | 12 | Formula | `=IF(H2>=15,"Critical",IF(H2>=10,"High",IF(H2>=5,"Medium","Low")))` |
| J | Mitigation Strategy | 30 | Text | Planned mitigation approach |
| K | Specific Actions | 30 | Text | Concrete actions to take |
| L | Responsible Owner | 16 | Text | Who owns the mitigation |
| M | Target Resolution Date | 14 | Date | When resistance should be resolved |
| N | Current Status | 12 | Dropdown | Not Started, In Progress, Resolved, Escalated |
| O | Progress Notes | 30 | Text | Update notes |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| I2:I100 | ="Critical" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| I2:I100 | ="High" | Background `#FFEDD5`, Font `#EA580C` |
| I2:I100 | ="Medium" | Background `#FEF3C7`, Font `#D97706` |
| I2:I100 | ="Low" | Background `#DCFCE7`, Font `#16A34A` |
| N2:N100 | ="Escalated" | Background `#FEE2E2`, Font `#DC2626`, Bold |
| N2:N100 | ="Not Started" | Background `#F1F5F9`, Font `#64748B` |
| N2:N100 | ="In Progress" | Background `#DBEAFE`, Font `#2563EB` |
| N2:N100 | ="Resolved" | Background `#D1FAE5`, Font `#059669` |

### Resistance Summary Table (Row 50+)

| Cell | Content | Formula |
|------|---------|---------|
| A52 | Total Resistant/Skeptical | `=COUNTIFS(Register!I:I,"Resistant")+COUNTIFS(Register!I:I,"Skeptical")` |
| A53 | Critical Risk Count | `=COUNTIF($I:$I,"Critical")` |
| A54 | Unresolved Count | `=COUNTIFS($N:$N,"<>Resolved",$A:$A,"<>")` |
| A55 | Resolution Rate | `=COUNTIF($N:$N,"Resolved")/COUNTA($N:$N)` |

---

## Sheet 9: Engagement Effectiveness

### Purpose
Track the effectiveness of engagement activities by measuring attitude changes over time.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Stakeholder ID | 8 | Text | Reference |
| B | Stakeholder Name | 22 | Formula | `=VLOOKUP(A2,Register!$A:$B,2,FALSE)` |
| C | Initial Attitude Score | 10 | Number | Score at program start |
| D | Month 1 Score | 8 | Number | Attitude score month 1 |
| E | Month 2 Score | 8 | Number | Attitude score month 2 |
| F | Month 3 Score | 8 | Number | Attitude score month 3 |
| G | Month 4 Score | 8 | Number | Attitude score month 4 |
| H | Month 5 Score | 8 | Number | Attitude score month 5 |
| I | Month 6 Score | 8 | Number | Attitude score month 6 |
| J | Latest Score | 8 | Formula | `=LOOKUP(2,1/(D2:I2<>""),D2:I2)` |
| K | Total Movement | 10 | Formula | `=J2-C2` |
| L | Movement Direction | 12 | Formula | `=IF(K2>0,"Positive",IF(K2<0,"Negative","No Change"))` |
| M | Engagement Activities Count | 8 | Formula | `=COUNTIF(Engagement!$A:$A,A2)` |
| N | Effectiveness Ratio | 10 | Formula | `=IF(M2>0,K2/M2,"N/A")` |
| O | Trend | 10 | Formula | `=IF(J2>LOOKUP(2,1/(C2:H2<>""),C2:H2),"Improving",IF(J2<LOOKUP(2,1/(C2:H2<>""),C2:H2),"Declining","Stable"))` |

### Conditional Formatting Rules

| Range | Rule | Format |
|-------|------|--------|
| K2:K100 | >0 | Background `#DCFCE7`, Font `#059669` |
| K2:K100 | =0 | Background `#FEF3C7`, Font `#D97706` |
| K2:K100 | <0 | Background `#FEE2E2`, Font `#DC2626` |
| O2:O100 | ="Improving" | Font `#059669`, Bold |
| O2:O100 | ="Declining" | Font `#DC2626`, Bold |
| O2:O100 | ="Stable" | Font `#D97706` |

---

## Sheet 10: Coalition Building

### Purpose
Identify and leverage champions to build influence networks that drive IBP adoption.

### Column Layout

| Column | Header | Width | Data Type | Description |
|--------|--------|-------|-----------|-------------|
| A | Champion ID | 8 | Text | Reference |
| B | Champion Name | 22 | Formula | `=VLOOKUP(A2,Register!$A:$B,2,FALSE)` |
| C | Attitude | 14 | Formula | `=VLOOKUP(A2,Register!$A:$I,9,FALSE)` |
| D | Influence Score | 10 | Formula | `=VLOOKUP(A2,Register!$A:$H,8,FALSE)` |
| E | Department | 16 | Formula | `=VLOOKUP(A2,Register!$A:$D,4,FALSE)` |
| F | Region | 12 | Formula | `=VLOOKUP(A2,Register!$A:$E,5,FALSE)` |
| G | Champion Role | 16 | Dropdown | Executive Sponsor, Change Agent, Super User, Peer Advocate, Subject Matter Expert |
| H | Assigned Influencees | 25 | Text | Stakeholders they influence |
| I | Influence Network Size | 8 | Formula | `=LEN(H2)-LEN(SUBSTITUTE(H2,",",""))+1` |
| J | Activity Status | 12 | Dropdown | Active, Developing, Inactive |
| K | Last Champion Activity | 14 | Date | Last advocacy activity |
| L | Champion Effectiveness | 10 | Number | 1-5 rating |
| M | Support Needed | 25 | Text | What support the champion needs |
| N | Notes | 30 | Text | Additional notes |

### Coalition Summary (Row 50+)

| Cell | Content | Formula |
|------|---------|---------|
| A52 | Total Champions | `=COUNTIF(Register!$I:$I,"Champion")` |
| A53 | Active Champions | `=COUNTIF($J:$J,"Active")` |
| A54 | Avg Influence | `=AVERAGEIF($C:$C,"Champion",$D:$D)` |
| A55 | Network Strength | `=COUNTIF($J:$J,"Active")*AVERAGEIF($J:$J,"Active",$D:$D)` |
| A56 | Coverage (Departments) | `=SUMPRODUCT(1/COUNTIF($E$2:$E$100,$E$2:$E$100))` |

---

## Named Ranges (Workbook-Level)

| Range Name | Reference | Description |
|------------|-----------|-------------|
| Stakeholder_Total_Count | Dashboard!B5 | Total number of stakeholders |
| Stakeholder_AtRisk_Count | Dashboard!F5 | Stakeholders with High/Very High gaps |
| Engagement_Health_Rate | Dashboard!N5 | Percentage of engagements on track |
| Champion_Count | Dashboard!J5 | Number of stakeholders at Champion attitude |
| Resistance_Critical_Count | Resistance!A53 | Critical resistance risk count |
| Coalition_Network_Strength | Coalition!A55 | Champion network strength score |
| Avg_Attitude_Gap | Register derived | Average attitude gap across all stakeholders |

---

## Integration Points

### With Communication Plan Workbook
- Stakeholder list feeds audience segmentation
- Attitude data informs messaging tone and approach
- Contact preferences drive channel selection

### With Change Readiness Assessment
- Stakeholder resistance data feeds readiness scoring
- Champion count feeds sponsorship dimension
- Engagement health feeds communication dimension

### With Adoption Tracker
- Champion activity correlates with adoption rates
- Attitude trends validate adoption patterns
- Engagement effectiveness measures change effectiveness

### With IBP Master Integration Workbook
- Named ranges (Stakeholder_AtRisk_Count, Engagement_Health_Rate, Champion_Count) feed master dashboard
- Cross-reference with IBP governance stakeholder roles

---

## VBA / Automation

### Auto-Update Contact Urgency

```vba
Sub UpdateContactUrgency()
    ' Refreshes contact urgency flags based on current date
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Stakeholder Register")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    Dim i As Long
    For i = 2 To lastRow
        If IsDate(ws.Cells(i, 14).Value) Then
            Dim daysSince As Long
            daysSince = Date - ws.Cells(i, 14).Value
            ws.Cells(i, 15).Value = daysSince

            If daysSince > 30 Then
                ws.Cells(i, 16).Value = "OVERDUE"
            ElseIf daysSince > 14 Then
                ws.Cells(i, 16).Value = "DUE SOON"
            Else
                ws.Cells(i, 16).Value = "OK"
            End If
        End If
    Next i

    MsgBox "Contact urgency updated for " & lastRow - 1 & " stakeholders.", vbInformation
End Sub
```

### Generate Stakeholder Report

```vba
Sub GenerateStakeholderReport()
    ' Creates a summary report of stakeholder engagement status
    Dim wsReg As Worksheet, wsReport As Worksheet
    Set wsReg = ThisWorkbook.Sheets("Stakeholder Register")

    ' Create or clear report sheet
    On Error Resume Next
    Set wsReport = ThisWorkbook.Sheets("Report Output")
    If wsReport Is Nothing Then
        Set wsReport = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
        wsReport.Name = "Report Output"
    End If
    On Error GoTo 0
    wsReport.Cells.Clear

    ' Header
    wsReport.Range("A1").Value = "STAKEHOLDER ENGAGEMENT REPORT"
    wsReport.Range("A2").Value = "Generated: " & Format(Date, "dd-mmm-yyyy")

    ' Summary statistics
    wsReport.Range("A4").Value = "Total Stakeholders:"
    wsReport.Range("B4").Value = Application.WorksheetFunction.CountA(wsReg.Range("B:B")) - 1

    wsReport.Range("A5").Value = "Champions:"
    wsReport.Range("B5").Value = Application.WorksheetFunction.CountIf(wsReg.Range("I:I"), "Champion")

    wsReport.Range("A6").Value = "At Risk (High/Very High Gap):"
    wsReport.Range("B6").Value = Application.WorksheetFunction.CountIf(wsReg.Range("L:L"), "High") + _
                                  Application.WorksheetFunction.CountIf(wsReg.Range("L:L"), "Very High")

    wsReport.Range("A7").Value = "Overdue Contacts:"
    wsReport.Range("B7").Value = Application.WorksheetFunction.CountIf(wsReg.Range("P:P"), "OVERDUE")

    MsgBox "Report generated successfully.", vbInformation
End Sub
```

### Refresh Dashboard

```vba
Sub RefreshDashboard()
    ' Recalculates all dashboard formulas
    Application.CalculateFull

    ' Update timestamp
    Dim wsDash As Worksheet
    Set wsDash = ThisWorkbook.Sheets("Stakeholder Dashboard")
    wsDash.Range("N2").Value = "Last Updated: " & Format(Now, "dd-mmm-yyyy hh:mm")

    MsgBox "Dashboard refreshed.", vbInformation
End Sub
```

---

## Print Settings

| Sheet | Orientation | Paper Size | Fit To | Header | Footer |
|-------|-------------|------------|--------|--------|--------|
| Dashboard | Landscape | A4 | 1 page wide | "Stakeholder Analysis Dashboard" | Page &P of &N |
| Register | Landscape | A3 | 1 page wide | "Stakeholder Register" | Page &P of &N |
| Matrix | Landscape | A4 | 1 page | "Power/Interest Matrix" | Page &P of &N |
| All others | Landscape | A4 | 1 page wide | Sheet name | Page &P of &N |

---

## Protection Settings

| Sheet | Protection | Unlocked Cells | Password |
|-------|-----------|----------------|----------|
| Settings | Protected | None (admin only) | ibp_admin |
| Dashboard | Protected | None (view only) | ibp_view |
| Register | Protected | B, C, D, E, F, G, I, J, N, Q, R, S columns | ibp_edit |
| Engagement Plans | Protected | All input columns | ibp_edit |
| All others | Protected | Input columns only | ibp_edit |
