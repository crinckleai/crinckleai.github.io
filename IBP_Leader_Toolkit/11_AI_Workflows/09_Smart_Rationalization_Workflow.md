# Smart Rationalization Workflow
## AI-Powered SKU Rationalization & Sunset Planning

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SMART RATIONALIZATION WORKFLOW                            │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. SCAN  │───▶│ 2. SCORE │───▶│ 3. CLUST │───▶│ 4. IMPACT│             │
│  │ PORTFOLIO│    │ SKUs     │    │ ANALYSIS │    │ ASSESS   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Continuous      Multi-Factor    Identify        Revenue/Cost            │
│   Monitoring      Health Score    Tail SKUs       Analysis                │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. RECOM │───▶│ 6. PLAN  │───▶│ 7. EXECUTE│───▶│ 8. MEASURE│           │
│  │ MEND     │    │ SUNSET   │    │ PHASE-OUT│    │ RESULTS  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   AI Sunset       Timeline &      Auto-Track      Complexity              │
│   Candidates      Dependencies    Execution       Reduction               │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Continuous Portfolio Scan

### Automated Scanning
```python
def scan_portfolio_health():
    """Run daily to identify rationalization candidates"""
    
    all_skus = get_active_skus()
    candidates = []
    
    for sku in all_skus:
        # Gather metrics
        metrics = {
            'revenue_12m': get_revenue(sku, months=12),
            'volume_12m': get_volume(sku, months=12),
            'margin': get_gross_margin(sku),
            'trend': calculate_trend(sku, months=12),
            'customer_count': get_unique_customers(sku),
            'order_frequency': get_order_frequency(sku),
            'inventory_turns': get_inventory_turns(sku),
            'days_since_last_order': get_days_since_last_order(sku),
            'complexity_score': calculate_complexity(sku)
        }
        
        # Flag potential candidates
        if is_rationalization_candidate(metrics):
            candidates.append({
                'sku': sku,
                'metrics': metrics,
                'flag_reason': get_flag_reason(metrics)
            })
    
    return candidates

def is_rationalization_candidate(metrics):
    """Multi-criteria screening"""
    
    flags = []
    
    # Low revenue
    if metrics['revenue_12m'] < get_threshold('min_revenue'):
        flags.append('LOW_REVENUE')
    
    # Declining trend
    if metrics['trend'] < -0.2:  # >20% decline
        flags.append('DECLINING')
    
    # Low margin
    if metrics['margin'] < get_threshold('min_margin'):
        flags.append('LOW_MARGIN')
    
    # Low velocity
    if metrics['days_since_last_order'] > 180:
        flags.append('NO_RECENT_DEMAND')
    
    # Few customers
    if metrics['customer_count'] < get_threshold('min_customers'):
        flags.append('CUSTOMER_CONCENTRATION')
    
    # High complexity, low value
    if metrics['complexity_score'] > 0.7 and metrics['revenue_12m'] < get_threshold('complexity_threshold'):
        flags.append('COMPLEXITY_VALUE_MISMATCH')
    
    return len(flags) >= 2  # Multiple flags required
```

---

## Step 2: Score SKUs

### Health Score Calculation
```python
def calculate_sku_health_score(sku, metrics):
    """Composite health score 0-100"""
    
    scores = {}
    
    # Revenue score (0-25)
    revenue_percentile = get_percentile(metrics['revenue_12m'], 'revenue')
    scores['revenue'] = revenue_percentile * 0.25
    
    # Margin score (0-20)
    margin_norm = normalize(metrics['margin'], min=0, max=0.5)
    scores['margin'] = margin_norm * 20
    
    # Growth score (0-20)
    growth_norm = normalize(metrics['trend'], min=-0.3, max=0.3)
    scores['growth'] = growth_norm * 20
    
    # Customer score (0-15)
    customer_norm = normalize(metrics['customer_count'], min=1, max=50)
    scores['customer'] = customer_norm * 15
    
    # Velocity score (0-10)
    velocity_norm = normalize(metrics['order_frequency'], min=0, max=12)
    scores['velocity'] = velocity_norm * 10
    
    # Complexity penalty (0 to -10)
    complexity_penalty = -metrics['complexity_score'] * 10
    scores['complexity'] = complexity_penalty
    
    # Total score
    total = sum(scores.values())
    
    return {
        'total_score': max(0, min(100, total)),
        'component_scores': scores,
        'health_tier': classify_health_tier(total)
    }

def classify_health_tier(score):
    if score >= 70:
        return 'HEALTHY'
    elif score >= 50:
        return 'MONITOR'
    elif score >= 30:
        return 'AT_RISK'
    else:
        return 'CANDIDATE'
```

---

## Step 3: Cluster Analysis

### Identify Tail SKUs
```python
def analyze_tail(scored_skus):
    """Pareto analysis and clustering"""
    
    # Sort by revenue
    sorted_skus = sorted(scored_skus, key=lambda x: x['revenue_12m'], reverse=True)
    
    # Calculate cumulative
    total_revenue = sum(s['revenue_12m'] for s in sorted_skus)
    cumulative = 0
    
    for i, sku in enumerate(sorted_skus):
        cumulative += sku['revenue_12m']
        sku['cumulative_pct'] = cumulative / total_revenue
        sku['sku_pct'] = (i + 1) / len(sorted_skus)
        
        # Classify
        if sku['cumulative_pct'] <= 0.80:
            sku['pareto_class'] = 'HEAD'  # Top 80% revenue
        elif sku['cumulative_pct'] <= 0.95:
            sku['pareto_class'] = 'MIDDLE'  # 80-95% revenue
        else:
            sku['pareto_class'] = 'TAIL'  # Bottom 5% revenue
    
    # Tail analysis
    tail_skus = [s for s in sorted_skus if s['pareto_class'] == 'TAIL']
    
    tail_analysis = {
        'tail_count': len(tail_skus),
        'tail_pct': len(tail_skus) / len(sorted_skus),
        'tail_revenue': sum(s['revenue_12m'] for s in tail_skus),
        'tail_revenue_pct': sum(s['revenue_12m'] for s in tail_skus) / total_revenue,
        'tail_skus': tail_skus,
        'rationalization_potential': estimate_complexity_savings(tail_skus)
    }
    
    return tail_analysis
```

---

## Step 4: Impact Assessment

### Revenue & Cost Analysis
```python
def assess_rationalization_impact(sku):
    """Full impact assessment for sunset candidate"""
    
    impact = {}
    
    # Revenue impact
    impact['revenue_loss'] = get_revenue(sku, months=12)
    impact['revenue_at_risk'] = calculate_substitution_risk(sku)
    
    # Customer impact
    customers = get_sku_customers(sku)
    impact['affected_customers'] = len(customers)
    impact['strategic_customers'] = len([c for c in customers if c['tier'] == 'Strategic'])
    impact['customer_revenue_at_risk'] = sum(c['total_revenue'] for c in customers if is_sole_product(sku, c))
    
    # Cost savings
    impact['inventory_reduction'] = get_inventory_value(sku)
    impact['complexity_savings'] = estimate_complexity_cost(sku)
    impact['warehouse_savings'] = estimate_warehouse_savings(sku)
    impact['procurement_savings'] = estimate_procurement_savings(sku)
    impact['total_savings'] = sum([
        impact['inventory_reduction'] * 0.25,  # Carrying cost
        impact['complexity_savings'],
        impact['warehouse_savings'],
        impact['procurement_savings']
    ])
    
    # Substitution analysis
    substitutes = find_substitute_products(sku)
    impact['substitutes'] = substitutes
    impact['substitution_rate'] = estimate_substitution_rate(sku, substitutes)
    impact['retained_revenue'] = impact['revenue_loss'] * impact['substitution_rate']
    
    # Net impact
    impact['net_revenue_impact'] = -impact['revenue_loss'] * (1 - impact['substitution_rate'])
    impact['net_benefit'] = impact['total_savings'] + impact['net_revenue_impact']
    
    return impact
```

---

## Step 5: AI Recommendations

### Sunset Recommendations
```python
def generate_rationalization_recommendations(candidates, impacts):
    recommendations = []
    
    for candidate in candidates:
        impact = impacts[candidate['sku']]
        
        prompt = f"""
        Recommend rationalization action for SKU:
        
        SKU: {candidate['sku']}
        PRODUCT: {candidate['product_name']}
        CATEGORY: {candidate['category']}
        
        METRICS:
        - Revenue (12M): ${candidate['metrics']['revenue_12m']:,.0f}
        - Margin: {candidate['metrics']['margin']:.1%}
        - Trend: {candidate['metrics']['trend']:.1%}
        - Health Score: {candidate['health_score']}/100
        - Pareto Class: {candidate['pareto_class']}
        
        IMPACT ASSESSMENT:
        - Revenue Loss: ${impact['revenue_loss']:,.0f}
        - Substitution Rate: {impact['substitution_rate']:.0%}
        - Total Savings: ${impact['total_savings']:,.0f}
        - Net Benefit: ${impact['net_benefit']:,.0f}
        - Affected Customers: {impact['affected_customers']}
        - Strategic Customers: {impact['strategic_customers']}
        
        SUBSTITUTES: {[s['name'] for s in impact['substitutes'][:3]]}
        
        Recommend:
        1. Action: SUNSET / CONSOLIDATE / REPRICE / MAINTAIN
        2. Timeline: Immediate / 3 months / 6 months / 12 months
        3. Conditions or dependencies
        4. Customer communication approach
        5. Risk mitigation steps
        """
        
        recommendation = call_llm(prompt)
        recommendations.append({
            'sku': candidate['sku'],
            'recommendation': parse_recommendation(recommendation),
            'impact': impact,
            'priority': calculate_priority(candidate, impact)
        })
    
    return sorted(recommendations, key=lambda x: x['priority'], reverse=True)
```

---

## Step 6: Plan Sunset

### Sunset Planning
```python
def create_sunset_plan(sku, recommendation):
    plan = {
        'sku': sku,
        'decision': recommendation['action'],
        'start_date': today(),
        'end_date': calculate_end_date(recommendation['timeline']),
        'phases': [],
        'dependencies': [],
        'communications': [],
        'checkpoints': []
    }
    
    # Phase 1: Preparation (Month 1)
    plan['phases'].append({
        'phase': 'Preparation',
        'duration': 30,
        'tasks': [
            'Notify sales team',
            'Identify affected customers',
            'Prepare substitute recommendations',
            'Plan inventory rundown',
            'Update systems'
        ]
    })
    
    # Phase 2: Customer Communication (Month 2)
    plan['phases'].append({
        'phase': 'Communication',
        'duration': 30,
        'tasks': [
            'Notify strategic customers personally',
            'Send general customer notification',
            'Provide substitute options',
            'Handle objections and exceptions'
        ]
    })
    
    # Phase 3: Inventory Rundown (Months 3-6)
    plan['phases'].append({
        'phase': 'Rundown',
        'duration': 90,
        'tasks': [
            'Stop new production/procurement',
            'Clear existing inventory',
            'Process last-time-buy orders',
            'Monitor substitute adoption'
        ]
    })
    
    # Phase 4: Completion
    plan['phases'].append({
        'phase': 'Completion',
        'duration': 30,
        'tasks': [
            'Final inventory disposition',
            'System deactivation',
            'Documentation',
            'Lessons learned'
        ]
    })
    
    # Dependencies
    plan['dependencies'] = identify_dependencies(sku)
    
    # Checkpoints
    plan['checkpoints'] = [
        {'date': plan['start_date'] + timedelta(days=30), 'milestone': 'Customer notification complete'},
        {'date': plan['start_date'] + timedelta(days=60), 'milestone': 'Last-time-buy deadline'},
        {'date': plan['start_date'] + timedelta(days=120), 'milestone': '90% inventory cleared'},
        {'date': plan['end_date'], 'milestone': 'SKU deactivated'}
    ]
    
    return plan
```

---

## Step 7: Execute Phase-Out

### Automated Tracking
```python
def track_sunset_execution(plan):
    status = {
        'sku': plan['sku'],
        'current_phase': get_current_phase(plan),
        'overall_progress': calculate_progress(plan),
        'tasks_complete': 0,
        'tasks_total': 0,
        'on_track': True,
        'blockers': [],
        'inventory_status': {}
    }
    
    # Task tracking
    for phase in plan['phases']:
        for task in phase['tasks']:
            status['tasks_total'] += 1
            if is_task_complete(task):
                status['tasks_complete'] += 1
    
    # Inventory tracking
    status['inventory_status'] = {
        'starting_inventory': get_starting_inventory(plan['sku']),
        'current_inventory': get_current_inventory(plan['sku']),
        'sold_through': calculate_sell_through(plan['sku']),
        'remaining_days': estimate_remaining_days(plan['sku']),
        'on_target': is_inventory_on_target(plan)
    }
    
    # Checkpoint tracking
    for checkpoint in plan['checkpoints']:
        if checkpoint['date'] <= today():
            if not is_milestone_achieved(checkpoint):
                status['on_track'] = False
                status['blockers'].append(checkpoint['milestone'])
    
    # Generate alerts
    if not status['on_track']:
        generate_sunset_alert(status)
    
    return status
```

---

## Step 8: Measure Results

### Results Measurement
```python
def measure_rationalization_results(completed_sunsets):
    results = {
        'skus_rationalized': len(completed_sunsets),
        'financial_impact': {},
        'operational_impact': {},
        'customer_impact': {}
    }
    
    # Financial impact
    results['financial_impact'] = {
        'revenue_loss': sum(s['actual_revenue_loss'] for s in completed_sunsets),
        'revenue_retained': sum(s['substitution_revenue'] for s in completed_sunsets),
        'inventory_freed': sum(s['inventory_reduction'] for s in completed_sunsets),
        'complexity_savings': sum(s['complexity_savings_actual'] for s in completed_sunsets),
        'net_benefit': sum(s['net_benefit_actual'] for s in completed_sunsets)
    }
    
    # Operational impact
    results['operational_impact'] = {
        'sku_count_reduction': len(completed_sunsets),
        'sku_count_reduction_pct': len(completed_sunsets) / get_starting_sku_count(),
        'inventory_turns_improvement': calculate_turns_improvement(),
        'complexity_score_reduction': calculate_complexity_reduction()
    }
    
    # Customer impact
    results['customer_impact'] = {
        'customers_affected': sum(s['customers_affected'] for s in completed_sunsets),
        'customers_retained': sum(s['customers_retained'] for s in completed_sunsets),
        'retention_rate': calculate_customer_retention(completed_sunsets),
        'complaints': sum(s['complaints'] for s in completed_sunsets)
    }
    
    # Accuracy vs prediction
    results['accuracy'] = {
        'revenue_loss_accuracy': calculate_accuracy('revenue_loss', completed_sunsets),
        'substitution_rate_accuracy': calculate_accuracy('substitution_rate', completed_sunsets),
        'savings_accuracy': calculate_accuracy('savings', completed_sunsets)
    }
    
    return results
```

---

## Rationalization Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  SMART RATIONALIZATION DASHBOARD                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PORTFOLIO OVERVIEW                                              │
│  ├── Total Active SKUs: 4,500                                   │
│  ├── Tail SKUs (bottom 5% revenue): 1,800 (40%)                │
│  ├── Rationalization Candidates: 450                            │
│  └── Potential Savings: $2.5M annually                          │
│                                                                  │
│  ACTIVE SUNSET PROGRAMS                                          │
│  ─────────────────────────────────────────────────────────────  │
│  │ SKU      │ Phase       │ Progress │ End Date  │ Status     │ │
│  │ ABC123   │ Rundown     │ 75%      │ Jun 30    │ On Track   │ │
│  │ DEF456   │ Communicate │ 40%      │ Aug 15    │ On Track   │ │
│  │ GHI789   │ Preparation │ 20%      │ Sep 30    │ Delayed    │ │
│                                                                  │
│  RESULTS YTD                                                     │
│  ├── SKUs Rationalized: 125                                     │
│  ├── Revenue Impact: -$1.2M (85% substituted)                   │
│  ├── Inventory Freed: $3.5M                                     │
│  ├── Net Benefit: $1.8M                                         │
│  └── Customer Retention: 94%                                    │
│                                                                  │
│  RECOMMENDATIONS PENDING APPROVAL: 28                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered SKU rationalization for continuous portfolio optimization.*
