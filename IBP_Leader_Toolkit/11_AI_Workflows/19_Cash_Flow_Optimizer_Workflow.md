# Cash Flow Optimizer Workflow
## AI-Powered Working Capital & Cash Optimization

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CASH FLOW OPTIMIZER WORKFLOW                              │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. FORECAST│──▶│ 2. MODEL │───▶│ 3. OPTIMIZE│──▶│ 4. SIMULATE│          │
│  │ CASH FLOW│    │ WORKING  │    │ INVENTORY │    │ SCENARIOS │            │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   ML-Based         Receivables      Inventory-      Cash Impact           │
│   Cash Forecast    Payables Model   Service Trade   Analysis              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. RECOMMEND│─▶│ 6. EXECUTE│──▶│ 7. MONITOR│──▶│ 8. LEARN │            │
│  │ ACTIONS  │    │ DECISIONS│    │ POSITION │    │ IMPROVE  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   AI-Driven        System          Real-time       Continuous             │
│   Priorities       Integration     Tracking        Optimization           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Forecast Cash Flow

### ML-Based Cash Forecasting
```python
def forecast_cash_flow(horizon_weeks=13):
    """Generate ML-based cash flow forecast"""
    
    forecast = {
        'generated_at': datetime.now(),
        'horizon': horizon_weeks,
        'weekly_forecast': [],
        'summary': {}
    }
    
    for week in range(horizon_weeks):
        week_date = get_week_start(week)
        
        # Forecast inflows
        inflows = {
            'customer_receipts': predict_customer_receipts(week),
            'other_income': predict_other_income(week)
        }
        
        # Forecast outflows
        outflows = {
            'supplier_payments': predict_supplier_payments(week),
            'payroll': predict_payroll(week),
            'operating_expenses': predict_operating_expenses(week),
            'capital_expenditures': get_planned_capex(week),
            'debt_service': get_debt_service(week),
            'other': predict_other_outflows(week)
        }
        
        # Calculate net
        total_inflows = sum(inflows.values())
        total_outflows = sum(outflows.values())
        net_cash = total_inflows - total_outflows
        
        forecast['weekly_forecast'].append({
            'week': week + 1,
            'date': week_date,
            'inflows': inflows,
            'outflows': outflows,
            'total_inflows': total_inflows,
            'total_outflows': total_outflows,
            'net_cash_flow': net_cash,
            'confidence': calculate_forecast_confidence(week)
        })
    
    # Calculate summary
    forecast['summary'] = calculate_cash_summary(forecast['weekly_forecast'])
    
    return forecast

def predict_customer_receipts(week):
    """ML prediction of customer receipts"""
    
    # Get AR aging
    ar_aging = get_ar_aging()
    
    # Get historical payment patterns
    payment_patterns = get_payment_patterns()
    
    # Features for prediction
    features = {
        'week_number': week,
        'ar_current': ar_aging['current'],
        'ar_30_days': ar_aging['30_days'],
        'ar_60_days': ar_aging['60_days'],
        'ar_90_plus': ar_aging['90_plus'],
        'avg_dso': payment_patterns['avg_dso'],
        'collection_rate': payment_patterns['collection_rate'],
        'seasonality': get_collection_seasonality(week)
    }
    
    # Load model and predict
    model = load_model('cash_receipt_predictor')
    predicted = model.predict([list(features.values())])[0]
    
    return predicted

def predict_supplier_payments(week):
    """Predict supplier payment outflows"""
    
    # Get AP aging
    ap_aging = get_ap_aging()
    
    # Get scheduled payments
    scheduled = get_scheduled_payments(week)
    
    # Get expected invoices
    expected_invoices = predict_new_invoices(week)
    
    # Features
    features = {
        'scheduled_payments': scheduled,
        'ap_due_current': ap_aging['current'],
        'ap_due_30_days': ap_aging['30_days'],
        'expected_new_ap': expected_invoices,
        'payment_run_week': is_payment_run_week(week)
    }
    
    model = load_model('cash_payment_predictor')
    predicted = model.predict([list(features.values())])[0]
    
    return max(scheduled, predicted)  # At minimum scheduled

def calculate_forecast_confidence(week):
    """Calculate confidence level for forecast"""
    
    # Confidence decreases with horizon
    base_confidence = 0.95
    decay_rate = 0.02
    
    confidence = base_confidence - (week * decay_rate)
    
    return max(confidence, 0.5)
```

---

## Step 2: Model Working Capital

### Receivables & Payables Model
```python
def model_working_capital():
    """Build working capital model"""
    
    working_capital = {
        'receivables': model_receivables(),
        'inventory': model_inventory(),
        'payables': model_payables(),
        'summary': {}
    }
    
    # Calculate metrics
    working_capital['summary'] = {
        'total_ar': working_capital['receivables']['total'],
        'dso': working_capital['receivables']['dso'],
        'total_inventory': working_capital['inventory']['total'],
        'dio': working_capital['inventory']['dio'],
        'total_ap': working_capital['payables']['total'],
        'dpo': working_capital['payables']['dpo'],
        'cash_conversion_cycle': (
            working_capital['receivables']['dso'] +
            working_capital['inventory']['dio'] -
            working_capital['payables']['dpo']
        ),
        'net_working_capital': (
            working_capital['receivables']['total'] +
            working_capital['inventory']['total'] -
            working_capital['payables']['total']
        )
    }
    
    return working_capital

def model_receivables():
    """Model accounts receivable"""
    
    ar = {
        'aging': get_ar_aging(),
        'by_customer': {},
        'total': 0,
        'dso': 0
    }
    
    # Get customer-level AR
    customers = get_customers_with_ar()
    
    for customer in customers:
        customer_ar = get_customer_ar(customer['id'])
        
        ar['by_customer'][customer['id']] = {
            'customer_name': customer['name'],
            'balance': customer_ar['balance'],
            'aging': customer_ar['aging'],
            'avg_payment_days': customer_ar['avg_payment_days'],
            'risk_score': calculate_ar_risk(customer_ar),
            'predicted_collection_date': predict_collection_date(customer_ar)
        }
    
    ar['total'] = sum(c['balance'] for c in ar['by_customer'].values())
    ar['dso'] = calculate_dso(ar['total'])
    
    return ar

def model_inventory():
    """Model inventory investment"""
    
    inventory = {
        'by_category': {},
        'by_location': {},
        'total': 0,
        'dio': 0
    }
    
    # Get inventory by category
    categories = get_inventory_categories()
    
    for category in categories:
        cat_inv = get_category_inventory(category['id'])
        
        inventory['by_category'][category['id']] = {
            'category_name': category['name'],
            'value': cat_inv['value'],
            'units': cat_inv['units'],
            'turns': cat_inv['turns'],
            'excess_obsolete': cat_inv['excess_obsolete'],
            'opportunity': calculate_inventory_opportunity(cat_inv)
        }
    
    inventory['total'] = sum(c['value'] for c in inventory['by_category'].values())
    inventory['dio'] = calculate_dio(inventory['total'])
    
    return inventory

def model_payables():
    """Model accounts payable"""
    
    payables = {
        'aging': get_ap_aging(),
        'by_supplier': {},
        'total': 0,
        'dpo': 0,
        'early_pay_opportunities': []
    }
    
    # Get supplier-level AP
    suppliers = get_suppliers_with_ap()
    
    for supplier in suppliers:
        supplier_ap = get_supplier_ap(supplier['id'])
        
        payables['by_supplier'][supplier['id']] = {
            'supplier_name': supplier['name'],
            'balance': supplier_ap['balance'],
            'terms': supplier_ap['payment_terms'],
            'early_pay_discount': supplier_ap.get('early_pay_discount'),
            'relationship_score': supplier_ap.get('relationship_score')
        }
        
        # Check early pay opportunity
        if supplier_ap.get('early_pay_discount'):
            payables['early_pay_opportunities'].append({
                'supplier': supplier['name'],
                'balance': supplier_ap['balance'],
                'discount': supplier_ap['early_pay_discount'],
                'apr_equivalent': calculate_early_pay_apr(supplier_ap),
                'savings': supplier_ap['balance'] * supplier_ap['early_pay_discount']
            })
    
    payables['total'] = sum(s['balance'] for s in payables['by_supplier'].values())
    payables['dpo'] = calculate_dpo(payables['total'])
    
    return payables
```

---

## Step 3: Optimize Inventory

### Inventory-Service Trade-off
```python
def optimize_inventory_investment(working_capital, service_constraints):
    """Optimize inventory investment vs service level"""
    
    current_inventory = working_capital['inventory']['total']
    current_turns = calculate_inventory_turns(current_inventory)
    
    optimization = {
        'current_state': {
            'inventory_value': current_inventory,
            'turns': current_turns,
            'service_level': get_current_service_level(),
            'cash_tied_up': current_inventory
        },
        'scenarios': [],
        'pareto_frontier': [],
        'recommendations': []
    }
    
    # Generate optimization scenarios
    for service_target in [0.90, 0.93, 0.95, 0.97, 0.99]:
        scenario = optimize_for_service_level(service_target)
        
        optimization['scenarios'].append({
            'service_target': service_target,
            'required_inventory': scenario['total_inventory'],
            'inventory_change': scenario['total_inventory'] - current_inventory,
            'cash_impact': current_inventory - scenario['total_inventory'],
            'turns_achieved': scenario['turns'],
            'achievable': scenario['feasible']
        })
    
    # Find Pareto optimal points
    optimization['pareto_frontier'] = calculate_pareto_frontier(optimization['scenarios'])
    
    # Generate recommendations
    optimization['recommendations'] = generate_inventory_recommendations(
        optimization,
        service_constraints
    )
    
    return optimization

def optimize_for_service_level(target_service):
    """Calculate optimal inventory for service level"""
    
    products = get_all_products()
    total_inventory = 0
    
    product_optimization = []
    
    for product in products:
        # Get demand and variability
        demand = get_product_demand_forecast(product['id'])
        variability = get_demand_variability(product['id'])
        lead_time = get_lead_time(product['id'])
        
        # Calculate optimal safety stock for service level
        z_score = get_z_score_for_service(target_service)
        safety_stock = calculate_safety_stock(z_score, variability, lead_time)
        
        # Cycle stock
        cycle_stock = demand['monthly_avg'] * get_order_frequency(product['id'])
        
        # Total required
        required_inventory = safety_stock + cycle_stock
        unit_cost = get_product_cost(product['id'])
        inventory_value = required_inventory * unit_cost
        
        product_optimization.append({
            'product_id': product['id'],
            'safety_stock': safety_stock,
            'cycle_stock': cycle_stock,
            'total_units': required_inventory,
            'inventory_value': inventory_value
        })
        
        total_inventory += inventory_value
    
    return {
        'total_inventory': total_inventory,
        'turns': calculate_turns_at_level(total_inventory),
        'product_details': product_optimization,
        'feasible': check_feasibility(product_optimization)
    }

def generate_inventory_recommendations(optimization, constraints):
    """Generate AI-powered inventory recommendations"""
    
    prompt = f"""
    Generate inventory optimization recommendations:
    
    CURRENT STATE:
    - Inventory: ${optimization['current_state']['inventory_value']:,.0f}
    - Turns: {optimization['current_state']['turns']:.1f}
    - Service Level: {optimization['current_state']['service_level']:.1%}
    
    OPTIMIZATION SCENARIOS:
    {format_scenarios(optimization['scenarios'])}
    
    CONSTRAINTS:
    - Minimum service level: {constraints.get('min_service', 0.95):.0%}
    - Maximum inventory: ${constraints.get('max_inventory', float('inf')):,.0f}
    - Cash release target: ${constraints.get('cash_target', 0):,.0f}
    
    Provide:
    1. Recommended service/inventory balance
    2. Priority products for optimization
    3. Expected cash release
    4. Implementation approach
    5. Risks and mitigations
    """
    
    return call_llm(prompt)
```

---

## Step 4: Simulate Scenarios

### Cash Impact Analysis
```python
def simulate_cash_scenarios(cash_forecast, working_capital, optimization):
    """Simulate cash flow scenarios"""
    
    scenarios = []
    
    # Base case
    base = {
        'name': 'Base Case',
        'cash_flow': cash_forecast['weekly_forecast'],
        'ending_cash': calculate_ending_cash(cash_forecast),
        'min_cash': find_minimum_cash(cash_forecast),
        'parameters': 'Current assumptions'
    }
    scenarios.append(base)
    
    # Inventory optimization scenario
    inv_opt = simulate_inventory_optimization_impact(cash_forecast, optimization)
    scenarios.append({
        'name': 'Inventory Optimization',
        'cash_flow': inv_opt['weekly_forecast'],
        'ending_cash': calculate_ending_cash(inv_opt),
        'cash_released': inv_opt['cash_released'],
        'parameters': f"Service at {optimization['recommended_service']:.0%}"
    })
    
    # Accelerate collections scenario
    acc_collections = simulate_accelerated_collections(cash_forecast, working_capital)
    scenarios.append({
        'name': 'Accelerate Collections',
        'cash_flow': acc_collections['weekly_forecast'],
        'ending_cash': calculate_ending_cash(acc_collections),
        'cash_released': acc_collections['cash_released'],
        'parameters': f"DSO from {working_capital['receivables']['dso']:.0f} to {acc_collections['target_dso']:.0f}"
    })
    
    # Extend payables scenario
    ext_payables = simulate_extended_payables(cash_forecast, working_capital)
    scenarios.append({
        'name': 'Extend Payables',
        'cash_flow': ext_payables['weekly_forecast'],
        'ending_cash': calculate_ending_cash(ext_payables),
        'cash_released': ext_payables['cash_released'],
        'parameters': f"DPO from {working_capital['payables']['dpo']:.0f} to {ext_payables['target_dpo']:.0f}"
    })
    
    # Combined optimization
    combined = simulate_combined_optimization(cash_forecast, working_capital, optimization)
    scenarios.append({
        'name': 'Combined Optimization',
        'cash_flow': combined['weekly_forecast'],
        'ending_cash': calculate_ending_cash(combined),
        'cash_released': combined['total_cash_released'],
        'parameters': 'All levers combined'
    })
    
    # Stress test
    stress = simulate_stress_scenario(cash_forecast)
    scenarios.append({
        'name': 'Stress Test',
        'cash_flow': stress['weekly_forecast'],
        'ending_cash': calculate_ending_cash(stress),
        'min_cash': find_minimum_cash(stress),
        'parameters': '-20% revenue, +10 DSO'
    })
    
    return {
        'scenarios': scenarios,
        'comparison': compare_scenarios(scenarios),
        'recommendation': select_best_scenario(scenarios)
    }

def simulate_inventory_optimization_impact(base_forecast, optimization):
    """Simulate impact of inventory optimization on cash"""
    
    # Get recommended inventory level
    recommended = optimization['pareto_frontier'][0]  # Best balance
    current = optimization['current_state']['inventory_value']
    
    cash_release = current - recommended['required_inventory']
    release_per_week = cash_release / 13  # Spread over quarter
    
    optimized_forecast = []
    cumulative_release = 0
    
    for week in base_forecast['weekly_forecast']:
        week_forecast = week.copy()
        
        # Add inventory reduction as inflow
        cumulative_release += release_per_week
        week_forecast['inflows']['inventory_reduction'] = release_per_week
        week_forecast['total_inflows'] += release_per_week
        week_forecast['net_cash_flow'] += release_per_week
        
        optimized_forecast.append(week_forecast)
    
    return {
        'weekly_forecast': optimized_forecast,
        'cash_released': cash_release,
        'cumulative_release': cumulative_release
    }
```

---

## Step 5: Recommend Actions

### AI-Driven Priorities
```python
def generate_cash_recommendations(cash_forecast, working_capital, scenarios):
    """Generate prioritized cash optimization actions"""
    
    recommendations = {
        'immediate_actions': [],
        'short_term_actions': [],
        'strategic_actions': [],
        'monitoring_items': []
    }
    
    # Immediate actions (this week)
    if find_minimum_cash(cash_forecast) < get_minimum_cash_threshold():
        recommendations['immediate_actions'].append({
            'priority': 1,
            'action': 'Activate credit facility',
            'impact': f"${get_credit_facility_available():,.0f} available",
            'owner': 'Treasury',
            'deadline': 'Today'
        })
    
    # AR collection priority
    overdue_ar = get_overdue_ar()
    if overdue_ar['total'] > 100000:
        recommendations['immediate_actions'].append({
            'priority': 2,
            'action': 'Intensify collection on past due AR',
            'target_amount': overdue_ar['total'],
            'top_accounts': overdue_ar['top_5_accounts'],
            'owner': 'AR Team',
            'deadline': 'This week'
        })
    
    # Early pay discounts
    profitable_early_pay = [
        ep for ep in working_capital['payables']['early_pay_opportunities']
        if ep['apr_equivalent'] > get_cost_of_capital()
    ]
    if profitable_early_pay:
        recommendations['short_term_actions'].append({
            'priority': 1,
            'action': 'Take early payment discounts',
            'opportunities': profitable_early_pay[:5],
            'total_savings': sum(ep['savings'] for ep in profitable_early_pay),
            'owner': 'AP Team'
        })
    
    # Inventory reduction
    excess_inventory = identify_excess_inventory()
    if excess_inventory['total_value'] > 500000:
        recommendations['short_term_actions'].append({
            'priority': 2,
            'action': 'Reduce excess inventory',
            'target_reduction': excess_inventory['total_value'] * 0.5,
            'categories': excess_inventory['categories'],
            'timeline': '30-60 days',
            'owner': 'Supply Chain'
        })
    
    # AI summary recommendation
    prompt = f"""
    Summarize cash optimization recommendations:
    
    CASH POSITION:
    - Current cash: ${get_current_cash():,.0f}
    - Minimum forecast: ${find_minimum_cash(cash_forecast):,.0f}
    - 13-week ending: ${calculate_ending_cash(cash_forecast):,.0f}
    
    WORKING CAPITAL METRICS:
    - DSO: {working_capital['receivables']['dso']:.0f} days
    - DIO: {working_capital['inventory']['dio']:.0f} days
    - DPO: {working_capital['payables']['dpo']:.0f} days
    - CCC: {working_capital['summary']['cash_conversion_cycle']:.0f} days
    
    SCENARIO ANALYSIS:
    {format_scenario_comparison(scenarios['comparison'])}
    
    Provide:
    1. Overall cash position assessment
    2. Top 3 priorities this week
    3. Expected cash release from recommended actions
    4. Key risks to monitor
    """
    
    recommendations['ai_summary'] = call_llm(prompt)
    
    return recommendations

def prioritize_collection_efforts():
    """AI-prioritized collection efforts"""
    
    ar_accounts = get_all_ar_accounts()
    
    prioritized = []
    
    for account in ar_accounts:
        # Calculate collection probability
        probability = predict_collection_probability(account)
        
        # Calculate expected value
        expected_value = account['balance'] * probability
        
        # Priority score
        priority_score = (
            expected_value * 0.4 +
            account['days_overdue'] * 10 * 0.3 +
            account['relationship_value'] * 0.3
        )
        
        prioritized.append({
            'customer': account['customer_name'],
            'balance': account['balance'],
            'days_overdue': account['days_overdue'],
            'collection_probability': probability,
            'priority_score': priority_score,
            'recommended_action': determine_collection_action(account)
        })
    
    return sorted(prioritized, key=lambda x: x['priority_score'], reverse=True)
```

---

## Step 6: Execute Decisions

### System Integration
```python
def execute_cash_decisions(recommendations, approvals):
    """Execute approved cash optimization decisions"""
    
    execution_log = {
        'executed_at': datetime.now(),
        'actions': []
    }
    
    for action in recommendations['immediate_actions']:
        if action['priority'] in approvals:
            # Execute action
            if action['action'] == 'Activate credit facility':
                result = activate_credit_facility(action)
            elif 'collection' in action['action'].lower():
                result = initiate_collection_campaign(action)
            else:
                result = execute_generic_action(action)
            
            execution_log['actions'].append({
                'action': action['action'],
                'status': result['status'],
                'timestamp': datetime.now(),
                'details': result
            })
    
    # Short-term actions
    for action in recommendations['short_term_actions']:
        if action['priority'] in approvals:
            # Schedule action
            schedule_action(action)
            
            execution_log['actions'].append({
                'action': action['action'],
                'status': 'SCHEDULED',
                'scheduled_date': action.get('deadline', 'This week')
            })
    
    # Notify stakeholders
    notify_cash_actions(execution_log)
    
    return execution_log

def initiate_collection_campaign(action):
    """Initiate automated collection campaign"""
    
    accounts = action['top_accounts']
    
    for account in accounts:
        # Determine contact approach
        approach = determine_collection_approach(account)
        
        if approach == 'phone':
            queue_call(account, priority='HIGH')
        elif approach == 'email':
            send_collection_email(account, template='friendly_reminder')
        elif approach == 'escalation':
            escalate_to_management(account)
    
    return {
        'status': 'INITIATED',
        'accounts_contacted': len(accounts),
        'total_amount': sum(a['balance'] for a in accounts)
    }

def update_payment_schedules(recommendations):
    """Update AP payment schedules based on recommendations"""
    
    # Identify suppliers for extended terms
    suppliers_extend = recommendations.get('extend_terms', [])
    
    for supplier in suppliers_extend:
        # Update payment terms
        update_supplier_terms(
            supplier['id'],
            new_terms=supplier['proposed_terms']
        )
        
        # Reschedule payments
        reschedule_payments(supplier['id'])
    
    # Process early pay
    early_pay = recommendations.get('early_pay', [])
    
    for payment in early_pay:
        # Schedule early payment
        schedule_early_payment(
            payment['supplier_id'],
            payment['amount'],
            payment['due_date']
        )
```

---

## Step 7: Monitor Position

### Real-time Tracking
```python
def monitor_cash_position():
    """Real-time cash position monitoring"""
    
    position = {
        'timestamp': datetime.now(),
        'current_position': {},
        'forecast_vs_actual': {},
        'alerts': []
    }
    
    # Current position
    position['current_position'] = {
        'cash_balance': get_real_time_cash_balance(),
        'available_credit': get_available_credit(),
        'total_liquidity': get_real_time_cash_balance() + get_available_credit(),
        'today_inflows': get_today_inflows(),
        'today_outflows': get_today_outflows()
    }
    
    # Compare to forecast
    today_forecast = get_forecast_for_today()
    
    position['forecast_vs_actual'] = {
        'forecast_balance': today_forecast['ending_balance'],
        'actual_balance': position['current_position']['cash_balance'],
        'variance': position['current_position']['cash_balance'] - today_forecast['ending_balance'],
        'variance_pct': (position['current_position']['cash_balance'] - today_forecast['ending_balance']) / today_forecast['ending_balance'] * 100
    }
    
    # Generate alerts
    if position['current_position']['cash_balance'] < get_minimum_cash_threshold():
        position['alerts'].append({
            'type': 'LOW_CASH',
            'severity': 'CRITICAL',
            'message': f"Cash below minimum threshold",
            'current': position['current_position']['cash_balance'],
            'threshold': get_minimum_cash_threshold()
        })
    
    if abs(position['forecast_vs_actual']['variance_pct']) > 10:
        position['alerts'].append({
            'type': 'FORECAST_VARIANCE',
            'severity': 'HIGH',
            'message': f"Cash {position['forecast_vs_actual']['variance_pct']:+.0f}% vs forecast",
            'variance': position['forecast_vs_actual']['variance']
        })
    
    # Check weekly trend
    weekly_trend = calculate_weekly_trend()
    if weekly_trend['declining'] and weekly_trend['weeks_declining'] >= 3:
        position['alerts'].append({
            'type': 'DECLINING_TREND',
            'severity': 'MEDIUM',
            'message': f"Cash declining for {weekly_trend['weeks_declining']} consecutive weeks",
            'rate': weekly_trend['avg_decline_per_week']
        })
    
    # Store position
    store_cash_position(position)
    
    return position

def track_working_capital_actions():
    """Track progress of working capital improvement actions"""
    
    tracking = {
        'dso_improvement': {},
        'dio_improvement': {},
        'dpo_improvement': {},
        'cash_released': {}
    }
    
    # Get baseline metrics
    baseline = get_baseline_working_capital()
    current = model_working_capital()
    
    # DSO tracking
    tracking['dso_improvement'] = {
        'baseline': baseline['receivables']['dso'],
        'current': current['receivables']['dso'],
        'change': baseline['receivables']['dso'] - current['receivables']['dso'],
        'target': get_target_dso(),
        'on_track': current['receivables']['dso'] <= get_target_dso()
    }
    
    # DIO tracking
    tracking['dio_improvement'] = {
        'baseline': baseline['inventory']['dio'],
        'current': current['inventory']['dio'],
        'change': baseline['inventory']['dio'] - current['inventory']['dio'],
        'target': get_target_dio(),
        'on_track': current['inventory']['dio'] <= get_target_dio()
    }
    
    # Calculate total cash released
    revenue = get_annual_revenue()
    cogs = get_annual_cogs()
    
    ar_release = (tracking['dso_improvement']['change'] / 365) * revenue
    inv_release = (tracking['dio_improvement']['change'] / 365) * cogs
    
    tracking['cash_released'] = {
        'from_ar': ar_release,
        'from_inventory': inv_release,
        'total': ar_release + inv_release
    }
    
    return tracking
```

---

## Step 8: Learn & Improve

### Continuous Optimization
```python
def learn_from_cash_outcomes():
    """Learn from cash forecast accuracy"""
    
    # Get historical forecast vs actual
    history = get_forecast_actual_history(periods=13)
    
    learning = {
        'forecast_accuracy': {},
        'model_updates': [],
        'process_improvements': []
    }
    
    # Calculate accuracy metrics
    accuracies = []
    for period in history:
        accuracy = 1 - abs(period['actual'] - period['forecast']) / period['actual']
        accuracies.append(accuracy)
    
    learning['forecast_accuracy'] = {
        'avg_accuracy': np.mean(accuracies),
        'worst_week': min(accuracies),
        'best_week': max(accuracies),
        'trend': calculate_accuracy_trend(accuracies)
    }
    
    # Identify systematic errors
    errors = analyze_forecast_errors(history)
    
    if errors['systematic_bias']:
        learning['model_updates'].append({
            'type': 'bias_correction',
            'direction': errors['bias_direction'],
            'magnitude': errors['bias_magnitude'],
            'action': 'Apply bias adjustment to model'
        })
    
    if errors['volatility_underestimate']:
        learning['model_updates'].append({
            'type': 'volatility_adjustment',
            'action': 'Increase confidence interval width'
        })
    
    # Process improvements
    if learning['forecast_accuracy']['avg_accuracy'] < 0.85:
        learning['process_improvements'].append({
            'issue': 'Low forecast accuracy',
            'recommendation': 'Add more leading indicators',
            'priority': 'HIGH'
        })
    
    # Update models
    for update in learning['model_updates']:
        apply_model_update(update)
    
    return learning

def optimize_cash_conversion_cycle():
    """Continuous CCC optimization"""
    
    # Current CCC
    current_ccc = calculate_ccc()
    
    # Industry benchmark
    benchmark = get_industry_ccc_benchmark()
    
    # Gap analysis
    gap = current_ccc - benchmark
    
    if gap > 10:  # More than 10 days worse than benchmark
        # Identify largest opportunity
        components = {
            'dso': get_current_dso() - get_benchmark_dso(),
            'dio': get_current_dio() - get_benchmark_dio(),
            'dpo': get_benchmark_dpo() - get_current_dpo()
        }
        
        largest_gap = max(components, key=lambda k: components[k])
        
        return {
            'current_ccc': current_ccc,
            'benchmark': benchmark,
            'gap': gap,
            'primary_opportunity': largest_gap,
            'potential_improvement': components[largest_gap],
            'cash_release_potential': calculate_cash_release_from_ccc(gap)
        }
    
    return {
        'current_ccc': current_ccc,
        'benchmark': benchmark,
        'status': 'AT_OR_BETTER_THAN_BENCHMARK'
    }
```

---

## Cash Flow Optimizer Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  CASH FLOW OPTIMIZER DASHBOARD                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CURRENT CASH POSITION: $12.5M      As of: 10:30 AM             │
│  Available Credit: $8.0M │ Total Liquidity: $20.5M              │
│                                                                  │
│  13-WEEK CASH FORECAST:                                          │
│  ─────────────────────────────────────────────────────────────  │
│  Week 1-4:   ▅▆▆▅  $11.2M → $10.8M                              │
│  Week 5-8:   ▄▃▄▅  $10.8M → $9.5M  ⚠ Below target              │
│  Week 9-13:  ▅▆▇█  $9.5M → $14.2M                               │
│                                                                  │
│  WORKING CAPITAL METRICS:                                        │
│  ─────────────────────────────────────────────────────────────  │
│  DSO:  42 days  (Target: 35)   ████████████░░░  ⚠ 7 days over  │
│  DIO:  58 days  (Target: 50)   ██████████████░  ⚠ 8 days over  │
│  DPO:  38 days  (Target: 45)   ███████████░░░░  7 days under   │
│  CCC:  62 days  (Benchmark: 45)                 ⚠ Opportunity  │
│                                                                  │
│  OPTIMIZATION OPPORTUNITIES:                                     │
│  ─────────────────────────────────────────────────────────────  │
│  1. Reduce inventory        │ $2.1M cash release │ 60 days     │
│  2. Accelerate AR collection│ $1.5M cash release │ 30 days     │
│  3. Extend supplier terms   │ $0.8M cash release │ 45 days     │
│  4. Early pay discounts     │ $45K savings       │ This month  │
│                                                                  │
│  ALERTS:                                                         │
│  ─────────────────────────────────────────────────────────────  │
│  ⚠ Week 7 projected below $10M threshold                       │
│  ⚠ DSO increased 3 days this month                             │
│  ✓ Forecast accuracy 91% (last 4 weeks)                         │
│                                                                  │
│  [Run Optimization] [Update Forecast] [Export Report]           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered cash flow optimization for healthy working capital management.*
