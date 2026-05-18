# Smart Allocation Workflow
## AI-Powered Constrained Supply Allocation

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SMART ALLOCATION WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. DETECT│───▶│ 2. ASSESS│───▶│ 3. PRIORITY│──▶│ 4. OPTIMIZE│           │
│  │ SHORTAGE │    │ GAP     │    │ RANK     │    │ ALLOCATION│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Supply vs        Quantify        Multi-Criteria   Mathematical          │
│   Demand Gap       Impact          Scoring          Solver                │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. SIMULATE│─▶│ 6. RECOMMEND│─▶│ 7. EXECUTE│──▶│ 8. TRACK │            │
│  │ SCENARIOS│    │ ALLOCATION│   │ & COMMIT │    │ OUTCOMES │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   What-If          AI Decision     System          Monitor &              │
│   Analysis         Support         Integration     Learn                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Detect Shortage

### Supply-Demand Gap Detection
```python
def detect_supply_shortages():
    """Detect current and projected supply shortages"""
    
    products = get_all_products()
    shortages = []
    
    for product in products:
        # Get supply position
        supply = {
            'on_hand': get_inventory_on_hand(product['id']),
            'on_order': get_open_orders(product['id']),
            'committed_receipts': get_committed_receipts(product['id']),
            'available_to_promise': calculate_atp(product['id'])
        }
        
        # Get demand
        demand = {
            'backlog': get_backlog(product['id']),
            'forecast': get_forecast(product['id']),
            'committed_orders': get_committed_orders(product['id'])
        }
        
        # Project forward
        for week in range(1, 13):  # 12 week horizon
            week_supply = project_supply(supply, week)
            week_demand = project_demand(demand, week)
            
            gap = week_supply - week_demand
            
            if gap < 0:
                shortages.append({
                    'product_id': product['id'],
                    'product_name': product['name'],
                    'week': week,
                    'supply': week_supply,
                    'demand': week_demand,
                    'gap': gap,
                    'gap_pct': gap / week_demand * 100 if week_demand > 0 else 0,
                    'severity': classify_severity(gap, product)
                })
    
    # Aggregate by product
    product_shortages = aggregate_shortages(shortages)
    
    return {
        'shortages': shortages,
        'by_product': product_shortages,
        'total_gap_value': sum(s['gap'] * get_price(s['product_id']) for s in shortages),
        'products_affected': len(product_shortages)
    }

def classify_severity(gap, product):
    """Classify shortage severity"""
    
    avg_weekly = product.get('avg_weekly_demand', 100)
    
    if abs(gap) > avg_weekly * 2:
        return 'CRITICAL'
    elif abs(gap) > avg_weekly:
        return 'HIGH'
    elif abs(gap) > avg_weekly * 0.5:
        return 'MEDIUM'
    else:
        return 'LOW'
```

---

## Step 2: Assess Gap

### Impact Quantification
```python
def assess_shortage_impact(shortages):
    """Quantify impact of shortages by customer and channel"""
    
    impact_analysis = {
        'by_customer': {},
        'by_channel': {},
        'by_region': {},
        'total_impact': {}
    }
    
    for shortage in shortages:
        product_id = shortage['product_id']
        gap = shortage['gap']
        
        # Get affected orders/demand
        affected_demand = get_affected_demand(product_id, shortage['week'])
        
        for demand_item in affected_demand:
            customer_id = demand_item['customer_id']
            customer = get_customer(customer_id)
            
            # Calculate impact
            shortfall = min(abs(gap), demand_item['quantity'])
            revenue_impact = shortfall * get_price(product_id)
            margin_impact = shortfall * get_unit_margin(product_id)
            
            # Aggregate by customer
            if customer_id not in impact_analysis['by_customer']:
                impact_analysis['by_customer'][customer_id] = {
                    'customer_name': customer['name'],
                    'tier': customer['tier'],
                    'products': [],
                    'total_shortfall': 0,
                    'revenue_impact': 0,
                    'margin_impact': 0
                }
            
            impact_analysis['by_customer'][customer_id]['products'].append(product_id)
            impact_analysis['by_customer'][customer_id]['total_shortfall'] += shortfall
            impact_analysis['by_customer'][customer_id]['revenue_impact'] += revenue_impact
            impact_analysis['by_customer'][customer_id]['margin_impact'] += margin_impact
            
            # Aggregate by channel
            channel = customer.get('channel', 'Unknown')
            if channel not in impact_analysis['by_channel']:
                impact_analysis['by_channel'][channel] = {
                    'shortfall': 0,
                    'revenue_impact': 0,
                    'customers_affected': set()
                }
            impact_analysis['by_channel'][channel]['shortfall'] += shortfall
            impact_analysis['by_channel'][channel]['revenue_impact'] += revenue_impact
            impact_analysis['by_channel'][channel]['customers_affected'].add(customer_id)
    
    # Calculate totals
    impact_analysis['total_impact'] = {
        'total_shortfall': sum(c['total_shortfall'] for c in impact_analysis['by_customer'].values()),
        'total_revenue_impact': sum(c['revenue_impact'] for c in impact_analysis['by_customer'].values()),
        'total_margin_impact': sum(c['margin_impact'] for c in impact_analysis['by_customer'].values()),
        'customers_affected': len(impact_analysis['by_customer'])
    }
    
    return impact_analysis
```

---

## Step 3: Priority Ranking

### Multi-Criteria Scoring
```python
def calculate_allocation_priorities(impact_analysis, shortages):
    """Calculate priority scores for allocation decisions"""
    
    priorities = []
    
    for customer_id, impact in impact_analysis['by_customer'].items():
        customer = get_customer(customer_id)
        
        # Build priority score from multiple criteria
        scores = {}
        
        # Customer tier (strategic importance)
        tier_weights = {'A': 1.0, 'B': 0.7, 'C': 0.4}
        scores['tier'] = tier_weights.get(customer['tier'], 0.5)
        
        # Customer lifetime value
        clv = customer.get('lifetime_value', 0)
        max_clv = get_max_customer_clv()
        scores['clv'] = clv / max_clv if max_clv > 0 else 0.5
        
        # Margin contribution
        margin = impact['margin_impact']
        max_margin = max(c['margin_impact'] for c in impact_analysis['by_customer'].values())
        scores['margin'] = margin / max_margin if max_margin > 0 else 0.5
        
        # Order commitment (firm orders vs forecast)
        firm_orders = get_firm_orders_pct(customer_id)
        scores['commitment'] = firm_orders
        
        # Payment reliability
        payment_score = customer.get('payment_score', 0.8)
        scores['payment'] = payment_score
        
        # Relationship risk (potential churn if not served)
        churn_risk = assess_churn_risk(customer_id)
        scores['relationship'] = churn_risk
        
        # Contractual obligations
        has_contract = customer.get('has_allocation_contract', False)
        scores['contract'] = 1.0 if has_contract else 0.5
        
        # Calculate weighted priority
        weights = {
            'tier': 0.20,
            'clv': 0.15,
            'margin': 0.15,
            'commitment': 0.15,
            'payment': 0.10,
            'relationship': 0.15,
            'contract': 0.10
        }
        
        priority_score = sum(scores[k] * weights[k] for k in weights)
        
        priorities.append({
            'customer_id': customer_id,
            'customer_name': customer['name'],
            'tier': customer['tier'],
            'priority_score': priority_score,
            'component_scores': scores,
            'demand': impact['total_shortfall'],
            'revenue_at_risk': impact['revenue_impact'],
            'products': impact['products']
        })
    
    # Sort by priority
    priorities = sorted(priorities, key=lambda x: x['priority_score'], reverse=True)
    
    return priorities

def assess_churn_risk(customer_id):
    """Assess risk of customer churn if not served"""
    
    # Factors
    recent_complaints = get_recent_complaints(customer_id)
    service_history = get_service_history(customer_id)
    competitor_activity = get_competitor_activity(customer_id)
    
    # Score (higher = more risk of churn, should prioritize)
    base_risk = 0.3
    
    if recent_complaints > 2:
        base_risk += 0.2
    
    if service_history.get('recent_misses', 0) > 1:
        base_risk += 0.2
    
    if competitor_activity.get('active_pursuit', False):
        base_risk += 0.3
    
    return min(base_risk, 1.0)
```

---

## Step 4: Optimize Allocation

### Mathematical Optimization
```python
from scipy.optimize import linprog
import numpy as np

def optimize_allocation(shortages, priorities, available_supply):
    """Run optimization to find best allocation"""
    
    # Build optimization model
    n_customers = len(priorities)
    n_products = len(set(s['product_id'] for s in shortages))
    
    # Decision variables: allocation[customer, product]
    
    # Objective: maximize weighted satisfaction
    # weighted_satisfaction = sum(priority_score * fill_rate * demand)
    
    c = []  # Objective coefficients (negative for maximization)
    for priority in priorities:
        for product_id in priority['products']:
            coefficient = priority['priority_score'] * get_unit_margin(product_id)
            c.append(-coefficient)  # Negative for maximization
    
    # Constraints
    A_ub = []  # Inequality constraint matrix
    b_ub = []  # Inequality constraint bounds
    
    # Supply constraints: sum of allocations <= available supply
    for product_id, supply in available_supply.items():
        constraint = [1 if get_product_idx(i) == product_id else 0 for i in range(len(c))]
        A_ub.append(constraint)
        b_ub.append(supply)
    
    # Customer demand constraints: allocation <= demand
    for i, priority in enumerate(priorities):
        for product_id in priority['products']:
            demand = get_customer_product_demand(priority['customer_id'], product_id)
            constraint = [1 if idx == get_idx(i, product_id) else 0 for idx in range(len(c))]
            A_ub.append(constraint)
            b_ub.append(demand)
    
    # Fair share constraints (optional): no customer gets >X% more than fair share
    # This prevents over-allocation to high-priority at expense of others
    fair_share_constraints = build_fair_share_constraints(priorities, available_supply)
    A_ub.extend(fair_share_constraints['A'])
    b_ub.extend(fair_share_constraints['b'])
    
    # Variable bounds (non-negative)
    bounds = [(0, None) for _ in range(len(c))]
    
    # Solve
    result = linprog(c, A_ub=A_ub, b_ub=b_ub, bounds=bounds, method='highs')
    
    if result.success:
        allocation = parse_allocation_result(result.x, priorities)
        return {
            'status': 'optimal',
            'allocation': allocation,
            'total_allocated': sum(result.x),
            'fill_rate': calculate_fill_rates(allocation, priorities),
            'objective_value': -result.fun
        }
    else:
        return {
            'status': 'infeasible',
            'message': result.message
        }

def build_fair_share_constraints(priorities, available_supply):
    """Build constraints to ensure minimum fairness"""
    
    A = []
    b = []
    
    # Each customer gets at least their "fair share" of available supply
    # Fair share = (customer demand / total demand) * available supply
    
    total_demand = sum(p['demand'] for p in priorities)
    
    for i, priority in enumerate(priorities):
        customer_demand = priority['demand']
        
        for product_id in priority['products']:
            product_supply = available_supply.get(product_id, 0)
            product_total_demand = sum(
                get_customer_product_demand(p['customer_id'], product_id)
                for p in priorities
            )
            
            if product_total_demand > 0:
                fair_share = (get_customer_product_demand(priority['customer_id'], product_id) / 
                             product_total_demand * product_supply * 0.5)  # 50% of fair share minimum
                
                # Constraint: allocation >= fair_share (reformulated as -allocation <= -fair_share)
                constraint = [-1 if idx == get_idx(i, product_id) else 0 for idx in range(len(priorities))]
                A.append(constraint)
                b.append(-fair_share)
    
    return {'A': A, 'b': b}
```

---

## Step 5: Simulate Scenarios

### What-If Analysis
```python
def simulate_allocation_scenarios(base_allocation, priorities, available_supply):
    """Simulate alternative allocation scenarios"""
    
    scenarios = []
    
    # Scenario 1: Pure priority-based (no fairness constraints)
    pure_priority = optimize_allocation(
        shortages=None,
        priorities=priorities,
        available_supply=available_supply,
        fairness_weight=0
    )
    scenarios.append({
        'name': 'Pure Priority',
        'description': 'Allocate strictly by priority score',
        'result': pure_priority,
        'trade_offs': calculate_trade_offs(pure_priority, base_allocation)
    })
    
    # Scenario 2: Equal distribution
    equal_dist = distribute_equally(priorities, available_supply)
    scenarios.append({
        'name': 'Equal Distribution',
        'description': 'All customers get same fill rate',
        'result': equal_dist,
        'trade_offs': calculate_trade_offs(equal_dist, base_allocation)
    })
    
    # Scenario 3: Margin maximization
    margin_max = optimize_allocation(
        shortages=None,
        priorities=recalculate_priorities(priorities, objective='margin'),
        available_supply=available_supply
    )
    scenarios.append({
        'name': 'Margin Maximization',
        'description': 'Maximize total margin contribution',
        'result': margin_max,
        'trade_offs': calculate_trade_offs(margin_max, base_allocation)
    })
    
    # Scenario 4: Protect strategic accounts
    protected = optimize_allocation(
        shortages=None,
        priorities=recalculate_priorities(priorities, objective='strategic'),
        available_supply=available_supply,
        protected_customers=get_strategic_accounts()
    )
    scenarios.append({
        'name': 'Protect Strategic',
        'description': 'Guarantee 100% fill for strategic accounts',
        'result': protected,
        'trade_offs': calculate_trade_offs(protected, base_allocation)
    })
    
    return {
        'base': base_allocation,
        'scenarios': scenarios,
        'comparison': compare_scenarios(scenarios)
    }

def calculate_trade_offs(scenario, base):
    """Calculate trade-offs vs base allocation"""
    
    return {
        'fill_rate_change': scenario['fill_rate'] - base['fill_rate'],
        'margin_change': scenario.get('total_margin', 0) - base.get('total_margin', 0),
        'customers_worse_off': count_worse_off(scenario, base),
        'customers_better_off': count_better_off(scenario, base),
        'strategic_impact': calculate_strategic_impact(scenario, base)
    }
```

---

## Step 6: Recommend Allocation

### AI Decision Support
```python
def generate_allocation_recommendation(base_allocation, scenarios, impact_analysis):
    """Generate AI-powered allocation recommendation"""
    
    prompt = f"""
    Recommend the best allocation strategy for this supply shortage:
    
    SHORTAGE SITUATION:
    - Total shortfall: {impact_analysis['total_impact']['total_shortfall']:,.0f} units
    - Revenue at risk: ${impact_analysis['total_impact']['total_revenue_impact']:,.0f}
    - Customers affected: {impact_analysis['total_impact']['customers_affected']}
    
    BASE ALLOCATION RESULT:
    - Average fill rate: {base_allocation['fill_rate']['average']:.1%}
    - Strategic accounts fill: {base_allocation['fill_rate']['strategic']:.1%}
    - Margin captured: ${base_allocation.get('total_margin', 0):,.0f}
    
    SCENARIO COMPARISON:
    {format_scenario_comparison(scenarios)}
    
    IMPACT BY CUSTOMER TIER:
    - Tier A: {summarize_tier_impact(impact_analysis, 'A')}
    - Tier B: {summarize_tier_impact(impact_analysis, 'B')}
    - Tier C: {summarize_tier_impact(impact_analysis, 'C')}
    
    Provide:
    1. Recommended allocation strategy with rationale
    2. Which customers should receive priority
    3. Communication strategy for affected customers
    4. Risk mitigation actions
    5. Any escalations required
    """
    
    recommendation = call_llm(prompt)
    
    return {
        'ai_recommendation': recommendation,
        'recommended_scenario': identify_best_scenario(scenarios),
        'customer_communications': generate_customer_comms(base_allocation),
        'escalations': identify_escalations(base_allocation, impact_analysis)
    }

def generate_customer_comms(allocation):
    """Generate customer-specific communication templates"""
    
    comms = []
    
    for customer_id, alloc in allocation['allocation'].items():
        customer = get_customer(customer_id)
        fill_rate = alloc['fill_rate']
        
        if fill_rate < 1.0:
            # Generate customized message
            prompt = f"""
            Generate a professional customer communication about supply allocation:
            
            CUSTOMER: {customer['name']}
            TIER: {customer['tier']}
            FILL RATE: {fill_rate:.0%}
            PRODUCTS AFFECTED: {alloc['products']}
            EXPECTED RESOLUTION: {alloc.get('resolution_date', 'TBD')}
            
            Write a brief, professional message that:
            1. Acknowledges the situation
            2. Explains what they will receive
            3. Provides expected resolution timeline
            4. Offers next steps or alternatives
            
            Tone: Apologetic but confident, solution-focused
            """
            
            message = call_llm(prompt)
            
            comms.append({
                'customer_id': customer_id,
                'customer_name': customer['name'],
                'fill_rate': fill_rate,
                'message': message,
                'channel': 'email' if customer['tier'] == 'C' else 'phone'
            })
    
    return comms
```

---

## Step 7: Execute & Commit

### System Integration
```python
def execute_allocation(allocation, approval):
    """Execute allocation in ERP/planning systems"""
    
    execution_log = {
        'allocation_id': generate_allocation_id(),
        'approved_by': approval['approver'],
        'approved_at': datetime.now(),
        'transactions': []
    }
    
    for customer_id, alloc in allocation['allocation'].items():
        for product_id, quantity in alloc['products'].items():
            # Create allocation transaction
            transaction = create_allocation_transaction(
                customer_id=customer_id,
                product_id=product_id,
                quantity=quantity,
                allocation_id=execution_log['allocation_id']
            )
            
            # Reserve inventory
            reserve_result = reserve_inventory(
                product_id=product_id,
                quantity=quantity,
                reservation_type='CUSTOMER_ALLOCATION',
                reference=transaction['id']
            )
            
            # Update ATP
            update_atp(product_id)
            
            execution_log['transactions'].append({
                'customer_id': customer_id,
                'product_id': product_id,
                'quantity': quantity,
                'transaction_id': transaction['id'],
                'inventory_reserved': reserve_result['success']
            })
    
    # Send notifications
    notify_stakeholders(execution_log)
    
    # Send customer communications
    send_customer_communications(allocation['communications'])
    
    # Update dashboards
    refresh_allocation_dashboards()
    
    return execution_log

def create_allocation_alerts(allocation):
    """Create alerts for allocation monitoring"""
    
    alerts = []
    
    for customer_id, alloc in allocation['allocation'].items():
        if alloc['fill_rate'] < 0.5:
            # Critical under-allocation
            alerts.append({
                'type': 'CRITICAL_UNDERALLOCATION',
                'customer_id': customer_id,
                'fill_rate': alloc['fill_rate'],
                'message': f"Critical: {get_customer_name(customer_id)} allocated only {alloc['fill_rate']:.0%}",
                'action_required': 'Executive review recommended'
            })
        
        if alloc.get('is_strategic') and alloc['fill_rate'] < 0.9:
            # Strategic account at risk
            alerts.append({
                'type': 'STRATEGIC_AT_RISK',
                'customer_id': customer_id,
                'fill_rate': alloc['fill_rate'],
                'message': f"Strategic account {get_customer_name(customer_id)} below 90% fill",
                'action_required': 'Sales notification required'
            })
    
    return alerts
```

---

## Step 8: Track Outcomes

### Monitor and Learn
```python
def track_allocation_outcomes(allocation_id, weeks_since_allocation):
    """Track outcomes of allocation decisions"""
    
    allocation = get_allocation(allocation_id)
    
    outcomes = {
        'allocation_id': allocation_id,
        'weeks_tracked': weeks_since_allocation,
        'by_customer': {},
        'overall': {}
    }
    
    for customer_id, alloc in allocation['allocation'].items():
        # Actual fulfillment
        actual_shipped = get_actual_shipments(customer_id, allocation['period'])
        
        # Customer response
        customer_feedback = get_customer_feedback(customer_id, allocation['period'])
        order_changes = get_order_changes(customer_id, allocation['period'])
        
        outcomes['by_customer'][customer_id] = {
            'planned_allocation': alloc['quantity'],
            'actual_shipped': actual_shipped,
            'variance': actual_shipped - alloc['quantity'],
            'customer_response': customer_feedback,
            'order_changes': order_changes,
            'relationship_impact': assess_relationship_impact(customer_id)
        }
    
    # Overall outcomes
    outcomes['overall'] = {
        'total_planned': sum(a['quantity'] for a in allocation['allocation'].values()),
        'total_shipped': sum(o['actual_shipped'] for o in outcomes['by_customer'].values()),
        'fill_rate_achieved': calculate_actual_fill_rate(outcomes),
        'customer_complaints': count_complaints(allocation['period']),
        'churn_events': count_churn_events(allocation['period'])
    }
    
    # Learn from outcomes
    update_allocation_models(outcomes)
    
    return outcomes

def update_allocation_models(outcomes):
    """Update allocation models based on outcomes"""
    
    learnings = []
    
    for customer_id, outcome in outcomes['by_customer'].items():
        # Update customer priority weights
        if outcome['relationship_impact'] == 'negative':
            # Customer was more sensitive than expected
            update_relationship_weight(customer_id, increase=True)
            learnings.append({
                'customer_id': customer_id,
                'learning': 'Increase churn risk weight',
                'reason': 'Negative relationship impact from allocation'
            })
        
        if outcome['customer_response'] == 'positive' and outcome['variance'] < 0:
            # Customer was understanding despite under-allocation
            update_relationship_weight(customer_id, increase=False)
            learnings.append({
                'customer_id': customer_id,
                'learning': 'Decrease churn risk weight',
                'reason': 'Customer tolerant of under-allocation'
            })
    
    # Store learnings
    store_allocation_learnings(outcomes['allocation_id'], learnings)
    
    return learnings
```

---

## Smart Allocation Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  SMART ALLOCATION DASHBOARD                                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SHORTAGE STATUS: 3 Products in Allocation Mode                 │
│  ─────────────────────────────────────────────────────────────  │
│  Widget Pro:     Gap 2,500 units │ 15 customers affected        │
│  Sensor X:       Gap 1,200 units │ 8 customers affected         │
│  Controller Y:   Gap 800 units   │ 12 customers affected        │
│                                                                  │
│  TOTAL IMPACT:                                                   │
│  Revenue at Risk: $1.2M │ Customers: 28 │ Orders: 45            │
│                                                                  │
│  RECOMMENDED ALLOCATION:                                         │
│  ─────────────────────────────────────────────────────────────  │
│  Tier A (10 customers): 95% fill    ████████████████████░       │
│  Tier B (12 customers): 78% fill    ████████████████░░░░░       │
│  Tier C (6 customers):  45% fill    █████████░░░░░░░░░░░░       │
│                                                                  │
│  TOP PRIORITY CUSTOMERS:                                         │
│  1. Acme Corp (A)      │ 100% fill │ Contract obligation        │
│  2. Beta Industries (A)│ 95% fill  │ Strategic partnership      │
│  3. Gamma LLC (A)      │ 90% fill  │ High CLV                   │
│                                                                  │
│  SCENARIO COMPARISON:                                            │
│  ─────────────────────────────────────────────────────────────  │
│  Strategy          │ Avg Fill │ Margin │ At-Risk Customers       │
│  Priority-Based    │ 72%      │ $85K   │ 8                       │
│  Equal Share       │ 65%      │ $72K   │ 12                      │
│  Protect Strategic │ 78%      │ $79K   │ 10                      │ ← RECOMMENDED
│                                                                  │
│  [Approve] [Modify] [Run More Scenarios]                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered supply allocation for optimal customer service during constraints.*
