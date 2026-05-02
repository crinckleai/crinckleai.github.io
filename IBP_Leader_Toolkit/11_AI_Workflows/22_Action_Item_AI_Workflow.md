# Action Item AI Workflow
## Intelligent Action Tracking & Accountability

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ACTION ITEM AI WORKFLOW                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. CAPTURE│───▶│ 2. ASSIGN │──▶│ 3. TRACK │───▶│ 4. REMIND│             │
│  │ ACTIONS  │    │ & PRIORIT │   │ PROGRESS │    │ & NUDGE  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Auto-Extract     Smart Owner      Real-time       Intelligent           │
│   from Meetings    Assignment       Monitoring      Follow-ups            │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. ESCALATE│─▶│ 6. MEASURE│──▶│ 7. REPORT │──▶│ 8. LEARN │            │
│  │ OVERDUE  │    │ IMPACT   │    │ STATUS   │    │ PATTERNS │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Auto-Escalate    Track           Executive       Improve               │
│   Chain           Outcomes         Dashboard       Completion            │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Capture Actions

### Auto-Extract from Meetings
```python
def capture_action_items(source_type, source_data):
    """Capture action items from various sources"""
    
    actions = []
    
    if source_type == 'meeting_transcript':
        actions = extract_from_transcript(source_data)
    elif source_type == 'meeting_notes':
        actions = extract_from_notes(source_data)
    elif source_type == 'email':
        actions = extract_from_email(source_data)
    elif source_type == 'document':
        actions = extract_from_document(source_data)
    elif source_type == 'manual':
        actions = [create_manual_action(source_data)]
    
    # Enhance each action
    enhanced_actions = []
    for action in actions:
        enhanced = enhance_action_item(action)
        enhanced_actions.append(enhanced)
    
    return enhanced_actions

def extract_from_transcript(transcript):
    """Extract action items from meeting transcript using LLM"""
    
    prompt = f"""
    Extract all action items from this meeting transcript:
    
    TRANSCRIPT:
    {transcript}
    
    For each action item, identify:
    1. Action description (clear, specific, actionable)
    2. Owner (person assigned, if mentioned)
    3. Due date (if mentioned)
    4. Priority (based on urgency language)
    5. Related topic/discussion
    6. Dependencies (other actions it depends on)
    
    Return as JSON array with keys:
    - description
    - owner_mentioned
    - due_date_mentioned
    - urgency_indicators
    - context
    - dependencies
    
    Only include clear commitments or assignments, not discussion items.
    """
    
    response = call_llm(prompt)
    actions = parse_json(response)
    
    return actions

def extract_from_notes(notes):
    """Extract action items from meeting notes"""
    
    # Look for common action item patterns
    patterns = [
        r'ACTION:\s*(.+)',
        r'\[ACTION\]\s*(.+)',
        r'TODO:\s*(.+)',
        r'Follow up:\s*(.+)',
        r'(?:will|should|must|needs to)\s+(.+)',
        r'@(\w+)\s+(.+)'  # @person assignment
    ]
    
    actions = []
    
    for pattern in patterns:
        matches = re.findall(pattern, notes, re.IGNORECASE)
        for match in matches:
            actions.append({
                'description': match if isinstance(match, str) else match[-1],
                'owner_mentioned': match[0] if isinstance(match, tuple) and len(match) > 1 else None,
                'source': 'meeting_notes',
                'raw_text': match
            })
    
    # Also use LLM for context
    llm_actions = call_llm(f"Extract any additional action items from these notes:\n{notes}")
    
    return deduplicate_actions(actions + parse_json(llm_actions))

def enhance_action_item(action):
    """Enhance action item with additional context"""
    
    enhanced = {
        'id': generate_action_id(),
        'description': action['description'],
        'created_at': datetime.now(),
        'source': action.get('source', 'unknown'),
        'status': 'OPEN'
    }
    
    # Parse due date if mentioned
    if action.get('due_date_mentioned'):
        enhanced['due_date'] = parse_due_date(action['due_date_mentioned'])
    else:
        # Default due date based on urgency
        enhanced['due_date'] = calculate_default_due_date(action)
    
    # Categorize action
    enhanced['category'] = categorize_action_item(action['description'])
    
    # Extract metrics if mentioned
    enhanced['success_criteria'] = extract_success_criteria(action['description'])
    
    return enhanced
```

---

## Step 2: Assign & Prioritize

### Smart Owner Assignment
```python
def assign_action_items(actions, meeting_context=None):
    """Intelligently assign owners to action items"""
    
    assignments = []
    
    for action in actions:
        assignment = {
            'action_id': action['id'],
            'owner': None,
            'backup_owner': None,
            'assignment_method': None,
            'confidence': 0
        }
        
        # Method 1: Owner mentioned in action
        if action.get('owner_mentioned'):
            owner = resolve_owner_mention(action['owner_mentioned'])
            if owner:
                assignment['owner'] = owner
                assignment['assignment_method'] = 'mentioned'
                assignment['confidence'] = 0.95
        
        # Method 2: Infer from action category
        if not assignment['owner']:
            category_owner = get_category_default_owner(action['category'])
            if category_owner:
                assignment['owner'] = category_owner
                assignment['assignment_method'] = 'category_default'
                assignment['confidence'] = 0.7
        
        # Method 3: AI recommendation based on content
        if not assignment['owner']:
            ai_owner = recommend_owner_ai(action)
            assignment['owner'] = ai_owner['owner']
            assignment['backup_owner'] = ai_owner['backup']
            assignment['assignment_method'] = 'ai_recommended'
            assignment['confidence'] = ai_owner['confidence']
        
        # Set priority
        assignment['priority'] = calculate_priority(action, meeting_context)
        
        assignments.append(assignment)
    
    return assignments

def recommend_owner_ai(action):
    """AI-based owner recommendation"""
    
    # Get relevant stakeholders
    stakeholders = get_relevant_stakeholders(action['category'])
    
    # Analyze workload
    workloads = {s['id']: get_current_workload(s['id']) for s in stakeholders}
    
    # Analyze expertise match
    expertise_scores = {}
    for stakeholder in stakeholders:
        score = calculate_expertise_match(stakeholder, action['description'])
        expertise_scores[stakeholder['id']] = score
    
    # Combine factors
    recommendations = []
    for stakeholder in stakeholders:
        combined_score = (
            expertise_scores[stakeholder['id']] * 0.5 +
            (1 - workloads[stakeholder['id']]) * 0.3 +
            stakeholder.get('seniority_score', 0.5) * 0.2
        )
        recommendations.append({
            'owner': stakeholder,
            'score': combined_score
        })
    
    # Sort by score
    recommendations = sorted(recommendations, key=lambda x: x['score'], reverse=True)
    
    return {
        'owner': recommendations[0]['owner'] if recommendations else None,
        'backup': recommendations[1]['owner'] if len(recommendations) > 1 else None,
        'confidence': recommendations[0]['score'] if recommendations else 0
    }

def calculate_priority(action, context=None):
    """Calculate action priority"""
    
    priority_score = 0.5  # Default medium
    
    # Urgency keywords
    urgent_keywords = ['urgent', 'asap', 'immediately', 'critical', 'blocker']
    high_keywords = ['important', 'priority', 'key', 'essential']
    
    description_lower = action['description'].lower()
    
    if any(kw in description_lower for kw in urgent_keywords):
        priority_score = 1.0
    elif any(kw in description_lower for kw in high_keywords):
        priority_score = 0.8
    
    # Due date proximity
    if action.get('due_date'):
        days_until = (action['due_date'] - datetime.now()).days
        if days_until <= 2:
            priority_score = max(priority_score, 0.9)
        elif days_until <= 7:
            priority_score = max(priority_score, 0.7)
    
    # Business impact
    if action.get('category') in ['revenue', 'customer', 'compliance']:
        priority_score = max(priority_score, 0.75)
    
    # Convert to tier
    if priority_score >= 0.9:
        return 'CRITICAL'
    elif priority_score >= 0.7:
        return 'HIGH'
    elif priority_score >= 0.4:
        return 'MEDIUM'
    else:
        return 'LOW'
```

---

## Step 3: Track Progress

### Real-time Monitoring
```python
def track_action_progress(action_id):
    """Track progress of action item"""
    
    action = get_action(action_id)
    
    tracking = {
        'action_id': action_id,
        'current_status': action['status'],
        'progress_indicators': {},
        'health': None,
        'risk_flags': []
    }
    
    # Check for progress updates
    updates = get_action_updates(action_id)
    tracking['progress_indicators'] = {
        'update_count': len(updates),
        'last_update': updates[-1]['timestamp'] if updates else None,
        'days_since_update': calculate_days_since_update(updates)
    }
    
    # Check related metrics
    if action.get('success_criteria'):
        tracking['metrics'] = check_success_metrics(action['success_criteria'])
    
    # Calculate health score
    tracking['health'] = calculate_action_health(action, tracking)
    
    # Identify risks
    if tracking['progress_indicators']['days_since_update'] > 7:
        tracking['risk_flags'].append({
            'type': 'STALE',
            'message': 'No updates in 7+ days'
        })
    
    days_to_due = (action['due_date'] - datetime.now()).days if action.get('due_date') else 999
    if days_to_due < 3 and action['status'] != 'COMPLETE':
        tracking['risk_flags'].append({
            'type': 'AT_RISK',
            'message': f'Due in {days_to_due} days, not complete'
        })
    
    if days_to_due < 0:
        tracking['risk_flags'].append({
            'type': 'OVERDUE',
            'message': f'Overdue by {abs(days_to_due)} days'
        })
    
    return tracking

def calculate_action_health(action, tracking):
    """Calculate overall health of action"""
    
    health_score = 100
    
    # Deduct for staleness
    days_since_update = tracking['progress_indicators'].get('days_since_update', 0)
    if days_since_update:
        health_score -= min(days_since_update * 3, 30)
    
    # Deduct for approaching deadline without progress
    if action.get('due_date'):
        days_to_due = (action['due_date'] - datetime.now()).days
        if days_to_due < 7 and action['status'] not in ['COMPLETE', 'IN_PROGRESS']:
            health_score -= 20
        if days_to_due < 0:
            health_score -= 40
    
    # Deduct for blocked status
    if action['status'] == 'BLOCKED':
        health_score -= 25
    
    # Classify
    if health_score >= 80:
        return 'HEALTHY'
    elif health_score >= 60:
        return 'AT_RISK'
    elif health_score >= 40:
        return 'UNHEALTHY'
    else:
        return 'CRITICAL'

def update_action_status(action_id, update):
    """Process action status update"""
    
    action = get_action(action_id)
    
    # Record update
    update_record = {
        'action_id': action_id,
        'timestamp': datetime.now(),
        'updater': update['user'],
        'old_status': action['status'],
        'new_status': update.get('status', action['status']),
        'comment': update.get('comment'),
        'progress_pct': update.get('progress_pct'),
        'blockers': update.get('blockers')
    }
    
    store_action_update(update_record)
    
    # Update action
    if update.get('status'):
        action['status'] = update['status']
    
    if update.get('progress_pct'):
        action['progress_pct'] = update['progress_pct']
    
    save_action(action)
    
    # Trigger notifications if needed
    if update['status'] == 'COMPLETE':
        notify_completion(action)
    elif update['status'] == 'BLOCKED':
        notify_blocked(action, update.get('blockers'))
    
    return update_record
```

---

## Step 4: Remind & Nudge

### Intelligent Follow-ups
```python
def generate_reminders():
    """Generate intelligent reminders for action items"""
    
    reminders = []
    
    # Get all open actions
    open_actions = get_open_actions()
    
    for action in open_actions:
        tracking = track_action_progress(action['id'])
        
        # Determine if reminder needed
        reminder = check_reminder_needed(action, tracking)
        
        if reminder:
            reminders.append(reminder)
    
    # Batch reminders by owner
    batched = batch_reminders_by_owner(reminders)
    
    # Send reminders
    for owner_id, owner_reminders in batched.items():
        send_reminder_batch(owner_id, owner_reminders)
    
    return reminders

def check_reminder_needed(action, tracking):
    """Check if reminder is needed and what type"""
    
    reminder = None
    
    # Calculate days to due
    days_to_due = (action['due_date'] - datetime.now()).days if action.get('due_date') else 999
    
    # Get reminder history
    last_reminder = get_last_reminder(action['id'])
    days_since_reminder = (datetime.now() - last_reminder['sent_at']).days if last_reminder else 999
    
    # Reminder rules
    if days_to_due < 0:
        # Overdue
        if days_since_reminder >= 1:  # Daily reminders when overdue
            reminder = {
                'action_id': action['id'],
                'type': 'OVERDUE',
                'urgency': 'HIGH',
                'days_overdue': abs(days_to_due),
                'message': f"Action is {abs(days_to_due)} days overdue"
            }
    
    elif days_to_due <= 2:
        # Due very soon
        if days_since_reminder >= 1:
            reminder = {
                'action_id': action['id'],
                'type': 'DUE_SOON',
                'urgency': 'HIGH',
                'days_remaining': days_to_due,
                'message': f"Action due in {days_to_due} days"
            }
    
    elif days_to_due <= 7:
        # Due this week
        if days_since_reminder >= 3:
            reminder = {
                'action_id': action['id'],
                'type': 'DUE_THIS_WEEK',
                'urgency': 'MEDIUM',
                'days_remaining': days_to_due,
                'message': f"Action due in {days_to_due} days"
            }
    
    elif tracking['health'] in ['UNHEALTHY', 'CRITICAL']:
        # Health issue
        if days_since_reminder >= 2:
            reminder = {
                'action_id': action['id'],
                'type': 'HEALTH_CHECK',
                'urgency': 'MEDIUM',
                'health': tracking['health'],
                'message': 'Please provide progress update'
            }
    
    return reminder

def send_reminder_batch(owner_id, reminders):
    """Send batched reminders to owner"""
    
    owner = get_user(owner_id)
    
    # Generate personalized message
    prompt = f"""
    Generate a friendly but professional reminder message for these action items:
    
    OWNER: {owner['name']}
    
    ACTIONS:
    {format_reminders_for_message(reminders)}
    
    Write a brief, helpful message that:
    1. Is respectful of their time
    2. Clearly lists what's needed
    3. Offers help if blocked
    4. Has appropriate urgency
    
    Keep under 100 words.
    """
    
    message = call_llm(prompt)
    
    # Send through preferred channel
    channel = owner.get('reminder_preference', 'email')
    
    if channel == 'email':
        send_email(owner['email'], 'Action Item Reminder', message)
    elif channel == 'slack':
        send_slack_dm(owner['slack_id'], message)
    elif channel == 'teams':
        send_teams_message(owner['teams_id'], message)
    
    # Log reminders
    for reminder in reminders:
        log_reminder_sent(reminder['action_id'], owner_id, channel)
```

---

## Step 5: Escalate Overdue

### Auto-Escalation Chain
```python
def process_escalations():
    """Process escalations for overdue items"""
    
    escalations = []
    
    # Get overdue actions
    overdue = get_overdue_actions()
    
    for action in overdue:
        # Check escalation level
        current_level = get_escalation_level(action['id'])
        days_overdue = (datetime.now() - action['due_date']).days
        
        # Escalation rules
        required_level = determine_escalation_level(days_overdue, action['priority'])
        
        if required_level > current_level:
            # Escalate
            escalation = escalate_action(action, required_level)
            escalations.append(escalation)
    
    return escalations

def determine_escalation_level(days_overdue, priority):
    """Determine required escalation level"""
    
    escalation_matrix = {
        'CRITICAL': {
            1: 1,   # 1 day overdue -> Level 1 (manager)
            3: 2,   # 3 days -> Level 2 (director)
            5: 3    # 5 days -> Level 3 (VP)
        },
        'HIGH': {
            3: 1,
            7: 2,
            14: 3
        },
        'MEDIUM': {
            7: 1,
            14: 2,
            21: 3
        },
        'LOW': {
            14: 1,
            21: 2,
            30: 3
        }
    }
    
    thresholds = escalation_matrix.get(priority, escalation_matrix['MEDIUM'])
    
    level = 0
    for days, lvl in sorted(thresholds.items()):
        if days_overdue >= days:
            level = lvl
    
    return level

def escalate_action(action, level):
    """Perform escalation"""
    
    escalation = {
        'action_id': action['id'],
        'level': level,
        'escalated_at': datetime.now(),
        'escalated_to': [],
        'reason': f"Overdue: {(datetime.now() - action['due_date']).days} days"
    }
    
    # Get escalation chain
    owner = get_user(action['owner_id'])
    chain = get_escalation_chain(owner['id'])
    
    # Notify up to current level
    for i in range(level):
        if i < len(chain):
            escalation['escalated_to'].append(chain[i])
            notify_escalation(chain[i], action, level)
    
    # Record escalation
    store_escalation(escalation)
    
    # Update action
    update_action_field(action['id'], 'escalation_level', level)
    
    return escalation

def notify_escalation(manager, action, level):
    """Notify manager of escalation"""
    
    level_names = {1: 'Manager', 2: 'Director', 3: 'VP'}
    
    message = f"""
    ESCALATION ALERT - Level {level} ({level_names.get(level, 'Executive')})
    
    Action: {action['description']}
    Owner: {get_user(action['owner_id'])['name']}
    Due Date: {action['due_date'].strftime('%Y-%m-%d')}
    Days Overdue: {(datetime.now() - action['due_date']).days}
    Priority: {action['priority']}
    
    This action has been automatically escalated due to being overdue.
    
    Please review and take appropriate action.
    """
    
    send_escalation_notification(manager, message, action)
```

---

## Step 6: Measure Impact

### Track Outcomes
```python
def measure_action_impact(action_id):
    """Measure impact of completed action"""
    
    action = get_action(action_id)
    
    if action['status'] != 'COMPLETE':
        return None
    
    impact = {
        'action_id': action_id,
        'completion_date': action.get('completed_at'),
        'on_time': action.get('completed_at') <= action.get('due_date') if action.get('due_date') else True,
        'metrics': {},
        'qualitative_impact': None
    }
    
    # Check success criteria metrics
    if action.get('success_criteria'):
        for criterion in action['success_criteria']:
            before = criterion.get('baseline_value')
            after = get_current_metric_value(criterion['metric'])
            
            impact['metrics'][criterion['metric']] = {
                'before': before,
                'after': after,
                'change': after - before if before and after else None,
                'met_target': after >= criterion.get('target_value') if criterion.get('target_value') else None
            }
    
    # Get qualitative feedback
    if action.get('source') == 'gap_closure':
        # Check if gap was closed
        impact['qualitative_impact'] = assess_gap_closure_impact(action)
    
    elif action.get('source') == 'root_cause_fix':
        # Check if issue recurred
        impact['qualitative_impact'] = assess_recurrence(action)
    
    # Store impact assessment
    store_impact_assessment(action_id, impact)
    
    return impact

def calculate_action_effectiveness():
    """Calculate overall action effectiveness metrics"""
    
    completed_actions = get_completed_actions(days=90)
    
    effectiveness = {
        'total_completed': len(completed_actions),
        'on_time_rate': 0,
        'impact_rate': 0,
        'cycle_time': {},
        'by_category': {}
    }
    
    # On-time completion
    on_time = sum(1 for a in completed_actions if a.get('on_time', False))
    effectiveness['on_time_rate'] = on_time / len(completed_actions) if completed_actions else 0
    
    # Impact achievement
    with_impact = get_actions_with_impact(completed_actions)
    impact_achieved = sum(1 for a in with_impact if a.get('impact_met', False))
    effectiveness['impact_rate'] = impact_achieved / len(with_impact) if with_impact else 0
    
    # Cycle time (creation to completion)
    cycle_times = []
    for action in completed_actions:
        if action.get('completed_at') and action.get('created_at'):
            cycle = (action['completed_at'] - action['created_at']).days
            cycle_times.append(cycle)
    
    if cycle_times:
        effectiveness['cycle_time'] = {
            'mean': np.mean(cycle_times),
            'median': np.median(cycle_times),
            'p90': np.percentile(cycle_times, 90)
        }
    
    # By category
    categories = set(a.get('category') for a in completed_actions)
    for category in categories:
        cat_actions = [a for a in completed_actions if a.get('category') == category]
        cat_on_time = sum(1 for a in cat_actions if a.get('on_time', False))
        effectiveness['by_category'][category] = {
            'count': len(cat_actions),
            'on_time_rate': cat_on_time / len(cat_actions) if cat_actions else 0
        }
    
    return effectiveness
```

---

## Step 7: Report Status

### Executive Dashboard
```python
def generate_action_status_report(scope='all', period='current'):
    """Generate action item status report"""
    
    actions = get_actions_by_scope(scope, period)
    
    report = {
        'generated_at': datetime.now(),
        'scope': scope,
        'period': period,
        'summary': {},
        'by_status': {},
        'by_owner': {},
        'by_priority': {},
        'attention_items': [],
        'completed_this_period': []
    }
    
    # Summary counts
    report['summary'] = {
        'total': len(actions),
        'open': sum(1 for a in actions if a['status'] in ['OPEN', 'IN_PROGRESS']),
        'complete': sum(1 for a in actions if a['status'] == 'COMPLETE'),
        'overdue': sum(1 for a in actions if is_overdue(a)),
        'at_risk': sum(1 for a in actions if is_at_risk(a))
    }
    
    # By status
    for status in ['OPEN', 'IN_PROGRESS', 'BLOCKED', 'COMPLETE', 'CANCELLED']:
        status_actions = [a for a in actions if a['status'] == status]
        report['by_status'][status] = {
            'count': len(status_actions),
            'actions': status_actions[:10]  # Top 10 for each
        }
    
    # By owner
    owners = set(a['owner_id'] for a in actions if a.get('owner_id'))
    for owner_id in owners:
        owner = get_user(owner_id)
        owner_actions = [a for a in actions if a.get('owner_id') == owner_id]
        report['by_owner'][owner['name']] = {
            'total': len(owner_actions),
            'open': sum(1 for a in owner_actions if a['status'] in ['OPEN', 'IN_PROGRESS']),
            'overdue': sum(1 for a in owner_actions if is_overdue(a)),
            'on_time_rate': calculate_owner_on_time_rate(owner_id)
        }
    
    # Attention items (overdue + at risk)
    attention = [a for a in actions if is_overdue(a) or is_at_risk(a)]
    report['attention_items'] = sorted(
        attention,
        key=lambda a: (0 if is_overdue(a) else 1, a.get('due_date', datetime.max))
    )[:20]
    
    # Recent completions
    report['completed_this_period'] = [
        a for a in actions
        if a['status'] == 'COMPLETE' and 
        a.get('completed_at', datetime.min) > datetime.now() - timedelta(days=7)
    ]
    
    return report

def generate_executive_summary(report):
    """Generate AI executive summary"""
    
    prompt = f"""
    Generate a brief executive summary of action item status:
    
    SUMMARY:
    - Total Actions: {report['summary']['total']}
    - Open: {report['summary']['open']}
    - Complete: {report['summary']['complete']}
    - Overdue: {report['summary']['overdue']}
    - At Risk: {report['summary']['at_risk']}
    
    ATTENTION ITEMS (Top 5):
    {format_attention_items(report['attention_items'][:5])}
    
    RECENT COMPLETIONS:
    {format_completions(report['completed_this_period'][:5])}
    
    Write a 2-3 sentence summary covering:
    1. Overall status (on track or concerns)
    2. Key items needing attention
    3. Any positive highlights
    
    Keep it brief and action-oriented.
    """
    
    return call_llm(prompt)
```

---

## Step 8: Learn Patterns

### Improve Completion
```python
def analyze_completion_patterns():
    """Analyze patterns in action completion"""
    
    # Get historical data
    actions = get_all_completed_actions(days=180)
    
    patterns = {
        'by_owner': {},
        'by_category': {},
        'by_source': {},
        'common_blockers': [],
        'success_factors': []
    }
    
    # Owner patterns
    owners = set(a['owner_id'] for a in actions)
    for owner_id in owners:
        owner_actions = [a for a in actions if a['owner_id'] == owner_id]
        
        on_time = [a for a in owner_actions if a.get('on_time', False)]
        avg_cycle = np.mean([
            (a['completed_at'] - a['created_at']).days
            for a in owner_actions
            if a.get('completed_at') and a.get('created_at')
        ])
        
        patterns['by_owner'][owner_id] = {
            'total': len(owner_actions),
            'on_time_rate': len(on_time) / len(owner_actions),
            'avg_cycle_days': avg_cycle
        }
    
    # Category patterns
    categories = set(a.get('category') for a in actions)
    for category in categories:
        cat_actions = [a for a in actions if a.get('category') == category]
        
        on_time = [a for a in cat_actions if a.get('on_time', False)]
        
        patterns['by_category'][category] = {
            'total': len(cat_actions),
            'on_time_rate': len(on_time) / len(cat_actions),
            'avg_complexity': np.mean([a.get('complexity', 0.5) for a in cat_actions])
        }
    
    # Blocker analysis
    blocked_actions = [a for a in actions if a.get('was_blocked', False)]
    blocker_reasons = [a.get('blocker_reason') for a in blocked_actions if a.get('blocker_reason')]
    patterns['common_blockers'] = analyze_common_blockers(blocker_reasons)
    
    # Success factors
    patterns['success_factors'] = identify_success_factors(actions)
    
    return patterns

def identify_success_factors(actions):
    """Identify factors that correlate with successful completion"""
    
    # Split into on-time and late
    on_time = [a for a in actions if a.get('on_time', False)]
    late = [a for a in actions if not a.get('on_time', False)]
    
    factors = []
    
    # Check update frequency
    on_time_updates = np.mean([a.get('update_count', 0) for a in on_time])
    late_updates = np.mean([a.get('update_count', 0) for a in late])
    
    if on_time_updates > late_updates * 1.3:
        factors.append({
            'factor': 'Regular progress updates',
            'on_time_avg': on_time_updates,
            'late_avg': late_updates,
            'recommendation': 'Request updates at least every 3 days'
        })
    
    # Check clear ownership
    on_time_clear_owner = sum(1 for a in on_time if a.get('owner_confirmed'))
    late_clear_owner = sum(1 for a in late if a.get('owner_confirmed'))
    
    if on_time_clear_owner / len(on_time) > late_clear_owner / len(late) * 1.2:
        factors.append({
            'factor': 'Confirmed ownership',
            'recommendation': 'Require owner confirmation within 24 hours'
        })
    
    # Check deadline setting
    on_time_had_deadline = sum(1 for a in on_time if a.get('due_date'))
    late_had_deadline = sum(1 for a in late if a.get('due_date'))
    
    # Generate insights
    return factors

def generate_improvement_recommendations(patterns):
    """Generate AI recommendations for improvement"""
    
    prompt = f"""
    Based on action item completion patterns, recommend improvements:
    
    CURRENT METRICS:
    - Overall on-time rate: {calculate_overall_on_time(patterns):.0%}
    - Average cycle time: {calculate_avg_cycle(patterns):.1f} days
    
    PATTERNS BY CATEGORY:
    {format_category_patterns(patterns['by_category'])}
    
    COMMON BLOCKERS:
    {format_blockers(patterns['common_blockers'])}
    
    SUCCESS FACTORS IDENTIFIED:
    {format_success_factors(patterns['success_factors'])}
    
    Recommend:
    1. Top 3 process improvements
    2. Training/coaching needs
    3. System/tool enhancements
    4. Expected impact of changes
    """
    
    return call_llm(prompt)
```

---

## Action Item Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  ACTION ITEM AI DASHBOARD                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SUMMARY: 47 Actions │ 12 Complete │ 5 Overdue │ 3 At Risk     │
│  ─────────────────────────────────────────────────────────────  │
│  On-Time Rate: 78%  ███████████████░░░░░  (Target: 85%)         │
│                                                                  │
│  STATUS BREAKDOWN:                                               │
│  ─────────────────────────────────────────────────────────────  │
│  OPEN         ████████████     15                               │
│  IN PROGRESS  ██████████████   18                               │
│  BLOCKED      ███              4                                 │
│  COMPLETE     █████████        12                               │
│  OVERDUE      ████             5  ⚠                             │
│                                                                  │
│  🔴 ATTENTION REQUIRED:                                          │
│  ─────────────────────────────────────────────────────────────  │
│  1. Review pricing proposal    │ John S. │ 3 days overdue      │
│  2. Submit compliance docs     │ Sarah M.│ 2 days overdue      │
│  3. Finalize supplier contract │ Mike R. │ Due tomorrow        │
│  4. Update forecast model      │ Lisa T. │ Due in 2 days       │
│                                                                  │
│  BY OWNER (Open Items):                                          │
│  ─────────────────────────────────────────────────────────────  │
│  John Smith     ████████   8  (2 overdue)                       │
│  Sarah Miller   ██████     6  (1 overdue)                       │
│  Mike Rogers    █████      5                                    │
│  Lisa Taylor    ████       4                                    │
│                                                                  │
│  ✓ RECENT COMPLETIONS:                                          │
│  ─────────────────────────────────────────────────────────────  │
│  • Demand review presentation (on time) - John S.               │
│  • Supplier risk assessment (1 day early) - Mike R.             │
│  • Q3 forecast lock (on time) - Lisa T.                         │
│                                                                  │
│  [New Action] [Send Reminders] [Export Report]                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered action tracking for improved accountability and execution.*
