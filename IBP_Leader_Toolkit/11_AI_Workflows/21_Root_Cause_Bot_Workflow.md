# Root Cause Bot Workflow
## AI-Powered Instant Root Cause Analysis

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ROOT CAUSE BOT WORKFLOW                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. RECEIVE│───▶│ 2. ANALYZE│──▶│ 3. DRILL │───▶│ 4. IDENTIFY│           │
│  │ QUESTION │    │ VARIANCE │    │ DOWN     │    │ ROOT CAUSE│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Natural          Multi-Level      Pareto          AI-Powered            │
│   Language         Decomposition    Analysis        Diagnosis             │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. EXPLAIN│───▶│ 6. RECOMMEND│─▶│ 7. LEARN │───▶│ 8. PREVENT│           │
│  │ IN CONTEXT│   │ ACTIONS  │    │ PATTERN  │    │ RECURRENCE│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Business-Ready   Corrective      Pattern         Systemic              │
│   Narrative        Actions         Recognition     Improvements          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Receive Question

### Natural Language Interface
```python
def process_root_cause_query(user_query):
    """Process natural language root cause question"""
    
    # Parse the query
    parsed = parse_query(user_query)
    
    query_types = {
        'forecast_miss': ['why did forecast miss', 'forecast variance', 'demand miss'],
        'revenue_gap': ['revenue gap', 'sales shortfall', 'revenue miss'],
        'margin_decline': ['margin decline', 'margin erosion', 'profitability'],
        'service_issue': ['service level', 'otif miss', 'delivery performance'],
        'inventory_issue': ['inventory variance', 'stockout', 'overstock'],
        'supply_disruption': ['supply issue', 'supplier problem', 'capacity constraint']
    }
    
    # Identify query type
    query_type = identify_query_type(parsed['text'], query_types)
    
    # Extract context
    context = {
        'query_type': query_type,
        'entity': parsed.get('entity'),  # Product, customer, region, etc.
        'time_period': parsed.get('time_period', 'last_month'),
        'metric': parsed.get('metric'),
        'original_query': user_query
    }
    
    return context

def parse_query(query):
    """NLP parsing of query"""
    
    # Use LLM for entity extraction
    prompt = f"""
    Parse this business question and extract:
    1. Main metric being questioned (revenue, margin, forecast, service, etc.)
    2. Entity mentioned (product name, customer, region, etc.)
    3. Time period (specific dates, last month, Q3, etc.)
    4. Comparison baseline if any (vs plan, vs last year, etc.)
    
    Question: "{query}"
    
    Return as JSON with keys: metric, entity, time_period, baseline
    """
    
    response = call_llm(prompt)
    parsed = parse_json(response)
    parsed['text'] = query.lower()
    
    return parsed

# Example queries the bot handles:
# "Why did we miss forecast in APAC last month?"
# "What's driving the margin decline in Q3?"
# "Why is service level down for Customer X?"
# "Explain the revenue gap vs plan"
```

---

## Step 2: Analyze Variance

### Multi-Level Decomposition
```python
def analyze_variance(context):
    """Multi-level variance decomposition"""
    
    analysis = {
        'query_context': context,
        'total_variance': {},
        'decomposition': {},
        'levels': []
    }
    
    if context['query_type'] == 'forecast_miss':
        analysis = analyze_forecast_variance(context)
    elif context['query_type'] == 'revenue_gap':
        analysis = analyze_revenue_variance(context)
    elif context['query_type'] == 'margin_decline':
        analysis = analyze_margin_variance(context)
    elif context['query_type'] == 'service_issue':
        analysis = analyze_service_variance(context)
    elif context['query_type'] == 'inventory_issue':
        analysis = analyze_inventory_variance(context)
    
    return analysis

def analyze_forecast_variance(context):
    """Analyze forecast variance with decomposition"""
    
    # Get forecast vs actual
    entity = context.get('entity')
    period = context.get('time_period')
    
    data = get_forecast_actual_data(entity, period)
    
    analysis = {
        'total_variance': {
            'forecast': data['forecast'],
            'actual': data['actual'],
            'variance': data['actual'] - data['forecast'],
            'variance_pct': (data['actual'] - data['forecast']) / data['forecast'] * 100
        },
        'levels': []
    }
    
    # Level 1: By product family
    by_family = decompose_by_dimension(data, 'product_family')
    analysis['levels'].append({
        'level': 1,
        'dimension': 'Product Family',
        'breakdown': by_family,
        'top_contributors': get_top_contributors(by_family, 5)
    })
    
    # Level 2: By product (within top families)
    top_families = [c['name'] for c in analysis['levels'][0]['top_contributors']]
    by_product = decompose_by_dimension(data, 'product', filter_to=top_families)
    analysis['levels'].append({
        'level': 2,
        'dimension': 'Product',
        'breakdown': by_product,
        'top_contributors': get_top_contributors(by_product, 10)
    })
    
    # Level 3: By customer (within top products)
    top_products = [c['name'] for c in analysis['levels'][1]['top_contributors']]
    by_customer = decompose_by_dimension(data, 'customer', filter_to=top_products)
    analysis['levels'].append({
        'level': 3,
        'dimension': 'Customer',
        'breakdown': by_customer,
        'top_contributors': get_top_contributors(by_customer, 10)
    })
    
    # Level 4: By region
    by_region = decompose_by_dimension(data, 'region')
    analysis['levels'].append({
        'level': 4,
        'dimension': 'Region',
        'breakdown': by_region,
        'top_contributors': get_top_contributors(by_region, 5)
    })
    
    return analysis

def analyze_revenue_variance(context):
    """Analyze revenue variance: price vs volume vs mix"""
    
    period = context.get('time_period')
    
    data = get_revenue_data(period)
    baseline = get_revenue_baseline(period)  # Plan or prior year
    
    analysis = {
        'total_variance': {
            'actual': data['total'],
            'baseline': baseline['total'],
            'variance': data['total'] - baseline['total'],
            'variance_pct': (data['total'] - baseline['total']) / baseline['total'] * 100
        },
        'decomposition': {}
    }
    
    # Price/Volume/Mix decomposition
    pvm = calculate_price_volume_mix(data, baseline)
    
    analysis['decomposition'] = {
        'volume_impact': {
            'value': pvm['volume'],
            'pct_of_variance': pvm['volume'] / analysis['total_variance']['variance'] * 100,
            'description': 'Change in units sold at baseline price'
        },
        'price_impact': {
            'value': pvm['price'],
            'pct_of_variance': pvm['price'] / analysis['total_variance']['variance'] * 100,
            'description': 'Change in price at baseline volume'
        },
        'mix_impact': {
            'value': pvm['mix'],
            'pct_of_variance': pvm['mix'] / analysis['total_variance']['variance'] * 100,
            'description': 'Effect of product/customer mix shift'
        }
    }
    
    # Add dimensional breakdown
    analysis['levels'] = generate_dimensional_breakdown(data, baseline)
    
    return analysis
```

---

## Step 3: Drill Down

### Pareto Analysis
```python
def drill_down_analysis(analysis):
    """Pareto-based drill down to find key drivers"""
    
    drill_down = {
        'pareto_analysis': [],
        'key_drivers': [],
        'contributing_factors': []
    }
    
    # Pareto analysis at each level
    for level in analysis['levels']:
        contributors = level['top_contributors']
        
        # Calculate cumulative contribution
        total_variance = abs(analysis['total_variance']['variance'])
        cumulative = 0
        pareto_items = []
        
        for item in contributors:
            contribution = abs(item['variance'])
            cumulative += contribution
            
            pareto_items.append({
                'name': item['name'],
                'variance': item['variance'],
                'contribution_pct': contribution / total_variance * 100,
                'cumulative_pct': cumulative / total_variance * 100
            })
        
        drill_down['pareto_analysis'].append({
            'dimension': level['dimension'],
            'items': pareto_items,
            'items_for_80_pct': count_items_for_threshold(pareto_items, 80)
        })
    
    # Identify key drivers (items that explain >80% of variance)
    for pareto in drill_down['pareto_analysis']:
        key_items = [i for i in pareto['items'] if i['cumulative_pct'] <= 85]
        
        for item in key_items:
            drill_down['key_drivers'].append({
                'dimension': pareto['dimension'],
                'name': item['name'],
                'variance': item['variance'],
                'contribution': item['contribution_pct']
            })
    
    # Find contributing factors for top drivers
    for driver in drill_down['key_drivers'][:5]:
        factors = find_contributing_factors(driver)
        drill_down['contributing_factors'].extend(factors)
    
    return drill_down

def find_contributing_factors(driver):
    """Find underlying factors for a variance driver"""
    
    factors = []
    
    entity_type = driver['dimension']
    entity_name = driver['name']
    
    if entity_type == 'Product':
        # Check for product-specific factors
        factors.extend(check_product_factors(entity_name))
    
    elif entity_type == 'Customer':
        # Check for customer-specific factors
        factors.extend(check_customer_factors(entity_name))
    
    elif entity_type == 'Region':
        # Check for regional factors
        factors.extend(check_regional_factors(entity_name))
    
    return factors

def check_product_factors(product_name):
    """Check product-specific contributing factors"""
    
    factors = []
    product = get_product(product_name)
    
    # Check for supply issues
    supply_issues = get_supply_issues(product['id'])
    if supply_issues:
        factors.append({
            'type': 'Supply',
            'factor': 'Supply constraint',
            'details': supply_issues,
            'impact': 'Limited availability'
        })
    
    # Check for quality issues
    quality_issues = get_quality_issues(product['id'])
    if quality_issues:
        factors.append({
            'type': 'Quality',
            'factor': 'Quality problems',
            'details': quality_issues,
            'impact': 'Customer returns/rejections'
        })
    
    # Check for pricing changes
    pricing_changes = get_pricing_changes(product['id'])
    if pricing_changes:
        factors.append({
            'type': 'Pricing',
            'factor': 'Price change',
            'details': pricing_changes,
            'impact': 'Demand elasticity effect'
        })
    
    # Check for competitor activity
    competitor_activity = get_competitor_activity(product['id'])
    if competitor_activity:
        factors.append({
            'type': 'Competition',
            'factor': 'Competitive pressure',
            'details': competitor_activity,
            'impact': 'Market share impact'
        })
    
    return factors
```

---

## Step 4: Identify Root Cause

### AI-Powered Diagnosis
```python
def identify_root_cause(analysis, drill_down):
    """AI-powered root cause identification"""
    
    # Prepare context for LLM
    prompt = f"""
    Analyze this business variance and identify the root cause:
    
    VARIANCE SUMMARY:
    - Total Variance: {analysis['total_variance']['variance']:,.0f} ({analysis['total_variance']['variance_pct']:.1f}%)
    - Period: {analysis['query_context']['time_period']}
    
    DECOMPOSITION:
    {format_decomposition(analysis.get('decomposition', {}))}
    
    KEY DRIVERS (Pareto Analysis):
    {format_key_drivers(drill_down['key_drivers'])}
    
    CONTRIBUTING FACTORS:
    {format_contributing_factors(drill_down['contributing_factors'])}
    
    Using the 5-Whys methodology:
    1. What is the immediate cause of the variance?
    2. Why did that happen?
    3. What underlying factor caused that?
    4. What systematic issue is at play?
    5. What is the fundamental root cause?
    
    Provide:
    1. Primary root cause (most significant)
    2. Secondary root causes (contributing)
    3. Confidence level (High/Medium/Low)
    4. Evidence supporting the diagnosis
    """
    
    llm_analysis = call_llm(prompt)
    
    root_cause = {
        'primary': extract_primary_cause(llm_analysis),
        'secondary': extract_secondary_causes(llm_analysis),
        'five_whys_chain': extract_five_whys(llm_analysis),
        'confidence': extract_confidence(llm_analysis),
        'evidence': extract_evidence(llm_analysis),
        'category': categorize_root_cause(llm_analysis)
    }
    
    return root_cause

def categorize_root_cause(analysis):
    """Categorize root cause for tracking"""
    
    categories = {
        'DEMAND': ['forecast', 'customer', 'market', 'competition', 'pricing'],
        'SUPPLY': ['supplier', 'capacity', 'quality', 'lead time', 'material'],
        'EXECUTION': ['process', 'system', 'data', 'timing', 'coordination'],
        'EXTERNAL': ['economy', 'weather', 'regulation', 'geopolitical'],
        'PLANNING': ['assumption', 'model', 'methodology', 'parameter']
    }
    
    analysis_lower = analysis.lower()
    
    for category, keywords in categories.items():
        if any(keyword in analysis_lower for keyword in keywords):
            return category
    
    return 'OTHER'

def apply_five_whys(initial_observation, context):
    """Structured 5-Whys analysis"""
    
    chain = [{'level': 0, 'statement': initial_observation}]
    
    for level in range(1, 6):
        prompt = f"""
        Continue the 5-Whys analysis:
        
        Previous answer: "{chain[-1]['statement']}"
        
        Context: {context}
        
        Ask "Why?" and provide the next level answer.
        Be specific and data-driven.
        """
        
        response = call_llm(prompt)
        chain.append({
            'level': level,
            'question': f"Why? ({level})",
            'statement': response
        })
    
    return chain
```

---

## Step 5: Explain in Context

### Business-Ready Narrative
```python
def generate_explanation(analysis, drill_down, root_cause, context):
    """Generate business-ready explanation"""
    
    prompt = f"""
    Generate a clear, executive-friendly explanation of this variance:
    
    ORIGINAL QUESTION: "{context['original_query']}"
    
    ANALYSIS SUMMARY:
    - Total Variance: {analysis['total_variance']['variance']:,.0f}
    - Main Impact: {analysis['decomposition'] if 'decomposition' in analysis else 'N/A'}
    
    ROOT CAUSE:
    - Primary: {root_cause['primary']}
    - Category: {root_cause['category']}
    - Confidence: {root_cause['confidence']}
    
    TOP DRIVERS:
    {format_drivers_brief(drill_down['key_drivers'][:3])}
    
    Generate a response that:
    1. Directly answers the question in 1-2 sentences
    2. Explains the key drivers with numbers
    3. States the root cause clearly
    4. Is appropriate for an executive audience
    5. Uses business language, not technical jargon
    
    Format: Start with the answer, then provide supporting detail.
    Keep to 150 words or less.
    """
    
    explanation = call_llm(prompt)
    
    # Structure the response
    response = {
        'answer': explanation,
        'summary_stats': {
            'total_variance': analysis['total_variance'],
            'top_3_drivers': drill_down['key_drivers'][:3],
            'root_cause': root_cause['primary']
        },
        'supporting_data': format_supporting_data(analysis, drill_down),
        'visualizations': generate_visualization_specs(analysis, drill_down)
    }
    
    return response

def format_supporting_data(analysis, drill_down):
    """Format supporting data for the explanation"""
    
    data = {
        'pareto_chart': {
            'type': 'pareto',
            'data': drill_down['pareto_analysis'][0]['items'][:10],
            'title': 'Top Contributors to Variance'
        },
        'waterfall': {
            'type': 'waterfall',
            'data': analysis.get('decomposition', {}),
            'title': 'Variance Bridge'
        },
        'trend': {
            'type': 'line',
            'data': get_historical_trend(analysis['query_context']),
            'title': 'Historical Trend'
        }
    }
    
    return data

def generate_visualization_specs(analysis, drill_down):
    """Generate specifications for visualizations"""
    
    specs = []
    
    # Pareto chart
    specs.append({
        'type': 'combo_chart',
        'chart_type': 'pareto',
        'data': {
            'categories': [d['name'] for d in drill_down['pareto_analysis'][0]['items'][:10]],
            'values': [d['variance'] for d in drill_down['pareto_analysis'][0]['items'][:10]],
            'cumulative': [d['cumulative_pct'] for d in drill_down['pareto_analysis'][0]['items'][:10]]
        },
        'title': 'Variance Pareto Analysis'
    })
    
    # Decomposition waterfall
    if 'decomposition' in analysis:
        specs.append({
            'type': 'waterfall',
            'data': analysis['decomposition'],
            'title': 'Variance Decomposition'
        })
    
    return specs
```

---

## Step 6: Recommend Actions

### Corrective Actions
```python
def recommend_corrective_actions(root_cause, analysis, context):
    """Recommend corrective actions based on root cause"""
    
    prompt = f"""
    Recommend corrective actions for this root cause:
    
    ROOT CAUSE: {root_cause['primary']}
    CATEGORY: {root_cause['category']}
    VARIANCE: {analysis['total_variance']['variance']:,.0f}
    
    SECONDARY CAUSES:
    {format_secondary_causes(root_cause['secondary'])}
    
    CONTEXT:
    - Period: {context['time_period']}
    - Entity: {context['entity']}
    
    Recommend:
    1. Immediate actions (this week)
    2. Short-term actions (this month)
    3. Preventive measures (ongoing)
    
    For each action include:
    - Specific action to take
    - Owner (by role)
    - Expected impact
    - Timeline
    """
    
    recommendations = call_llm(prompt)
    
    # Structure recommendations
    actions = {
        'immediate': parse_immediate_actions(recommendations),
        'short_term': parse_short_term_actions(recommendations),
        'preventive': parse_preventive_actions(recommendations)
    }
    
    # Estimate impact
    for action_type, action_list in actions.items():
        for action in action_list:
            action['estimated_impact'] = estimate_action_impact(action, analysis)
    
    return actions

def estimate_action_impact(action, analysis):
    """Estimate potential impact of corrective action"""
    
    total_variance = abs(analysis['total_variance']['variance'])
    
    # Heuristic impact estimation based on action type
    impact_factors = {
        'process_fix': 0.3,
        'data_correction': 0.5,
        'supplier_action': 0.4,
        'pricing_action': 0.6,
        'demand_action': 0.5
    }
    
    action_type = categorize_action(action['action'])
    factor = impact_factors.get(action_type, 0.3)
    
    return {
        'potential_recovery': total_variance * factor,
        'confidence': 'Medium',
        'timeline': action.get('timeline', '2-4 weeks')
    }

def create_action_items(actions, context):
    """Create formal action items from recommendations"""
    
    action_items = []
    
    for action_type, action_list in actions.items():
        priority = 1 if action_type == 'immediate' else 2 if action_type == 'short_term' else 3
        
        for action in action_list:
            action_items.append({
                'id': generate_action_id(),
                'description': action['action'],
                'owner': action['owner'],
                'priority': priority,
                'due_date': calculate_due_date(action_type, action.get('timeline')),
                'status': 'OPEN',
                'source': f"Root Cause Analysis: {context['original_query']}",
                'expected_impact': action['estimated_impact'],
                'created_at': datetime.now()
            })
    
    # Store action items
    for item in action_items:
        store_action_item(item)
    
    return action_items
```

---

## Step 7: Learn Patterns

### Pattern Recognition
```python
def learn_from_root_cause(root_cause, analysis, context):
    """Learn patterns from root cause analysis"""
    
    learning = {
        'pattern_match': None,
        'new_pattern': False,
        'recommendations': []
    }
    
    # Check for existing patterns
    similar_cases = find_similar_root_causes(root_cause, limit=10)
    
    if similar_cases:
        # Pattern exists
        pattern = analyze_pattern(similar_cases)
        learning['pattern_match'] = {
            'pattern_id': pattern['id'],
            'description': pattern['description'],
            'frequency': pattern['frequency'],
            'typical_resolution': pattern['resolution'],
            'avg_recovery_time': pattern['avg_recovery_days']
        }
        
        # Check if pattern is recurring
        if pattern['frequency'] > 3:
            learning['recommendations'].append({
                'type': 'RECURRING_PATTERN',
                'message': f"This issue has occurred {pattern['frequency']} times. Consider systematic fix.",
                'suggested_action': pattern['recommended_systematic_fix']
            })
    else:
        # New pattern
        learning['new_pattern'] = True
        create_pattern_record(root_cause, analysis, context)
    
    # Store for learning
    store_root_cause_case({
        'timestamp': datetime.now(),
        'query': context['original_query'],
        'root_cause': root_cause,
        'variance': analysis['total_variance'],
        'category': root_cause['category']
    })
    
    # Update prediction models
    update_variance_prediction_model(root_cause, analysis)
    
    return learning

def analyze_pattern(similar_cases):
    """Analyze pattern from similar cases"""
    
    pattern = {
        'id': generate_pattern_id(),
        'cases': similar_cases,
        'frequency': len(similar_cases),
        'description': '',
        'resolution': '',
        'avg_recovery_days': 0
    }
    
    # Extract common elements
    common_factors = find_common_factors(similar_cases)
    pattern['description'] = summarize_pattern(common_factors)
    
    # Find most effective resolution
    resolutions = [c['resolution'] for c in similar_cases if c.get('resolution')]
    if resolutions:
        pattern['resolution'] = find_most_effective(resolutions)
    
    # Calculate average recovery
    recovery_times = [c['recovery_days'] for c in similar_cases if c.get('recovery_days')]
    if recovery_times:
        pattern['avg_recovery_days'] = np.mean(recovery_times)
    
    return pattern

def update_variance_prediction_model(root_cause, analysis):
    """Update models to predict future variances"""
    
    # Extract features
    features = extract_variance_features(analysis)
    
    # Add to training data
    add_to_training_data({
        'features': features,
        'root_cause_category': root_cause['category'],
        'variance_magnitude': analysis['total_variance']['variance_pct']
    })
    
    # Trigger model retrain if enough new data
    training_data_count = get_training_data_count()
    if training_data_count % 50 == 0:  # Retrain every 50 new cases
        retrain_variance_predictor()
```

---

## Step 8: Prevent Recurrence

### Systemic Improvements
```python
def identify_prevention_measures(root_cause, learning):
    """Identify measures to prevent recurrence"""
    
    prevention = {
        'process_improvements': [],
        'system_changes': [],
        'monitoring_additions': [],
        'training_needs': []
    }
    
    # Based on root cause category
    if root_cause['category'] == 'PLANNING':
        prevention['process_improvements'].append({
            'area': 'Forecasting Process',
            'improvement': 'Add new variable to forecast model',
            'details': root_cause['primary'],
            'priority': 'HIGH'
        })
        prevention['monitoring_additions'].append({
            'metric': f"Early indicator for {root_cause['primary']}",
            'threshold': 'TBD based on analysis',
            'frequency': 'Weekly'
        })
    
    elif root_cause['category'] == 'EXECUTION':
        prevention['process_improvements'].append({
            'area': 'Operations',
            'improvement': 'Add process check/control',
            'details': f"Prevent {root_cause['primary']}",
            'priority': 'HIGH'
        })
        prevention['training_needs'].append({
            'audience': 'Operations team',
            'topic': f"Avoiding {root_cause['primary']}",
            'format': 'Workshop'
        })
    
    elif root_cause['category'] == 'SUPPLY':
        prevention['system_changes'].append({
            'system': 'Supply Planning',
            'change': 'Add supplier risk monitoring',
            'trigger': root_cause['primary'],
            'priority': 'MEDIUM'
        })
    
    # Check for recurring patterns
    if learning.get('pattern_match') and learning['pattern_match']['frequency'] > 3:
        prevention['systemic_recommendation'] = {
            'issue': f"Recurring: {learning['pattern_match']['description']}",
            'recommendation': learning['pattern_match'].get('recommended_systematic_fix'),
            'priority': 'CRITICAL',
            'escalate_to': 'Process Excellence Team'
        }
    
    return prevention

def implement_early_warning(root_cause, analysis):
    """Set up early warning for this type of issue"""
    
    warning = {
        'trigger_type': root_cause['category'],
        'indicators': [],
        'thresholds': [],
        'alert_recipients': []
    }
    
    # Define indicators based on root cause
    if 'demand' in root_cause['primary'].lower():
        warning['indicators'].append({
            'name': 'Booking pace vs forecast',
            'calculation': 'Weekly bookings / Weekly forecast',
            'threshold': 0.85,
            'direction': 'below'
        })
    
    if 'supply' in root_cause['primary'].lower():
        warning['indicators'].append({
            'name': 'Supplier on-time rate',
            'calculation': 'On-time receipts / Total receipts',
            'threshold': 0.90,
            'direction': 'below'
        })
    
    if 'customer' in root_cause['primary'].lower():
        warning['indicators'].append({
            'name': 'Customer engagement score',
            'calculation': 'Order frequency trend',
            'threshold': -0.10,
            'direction': 'below'
        })
    
    # Create alert rule
    create_alert_rule(warning)
    
    return warning
```

---

## Root Cause Bot Interface

```
┌─────────────────────────────────────────────────────────────────┐
│  ROOT CAUSE BOT                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  👤 User: Why did we miss forecast in APAC last month?          │
│                                                                  │
│  🤖 Bot:                                                        │
│  ─────────────────────────────────────────────────────────────  │
│  APAC forecast missed by -$1.2M (-8.5%) in March. The primary   │
│  driver was the delayed Singapore project (Acme Corp) which     │
│  accounted for 65% of the miss. Secondary factors include       │
│  competitive displacement in Australia (-$180K) and a temporary │
│  port delay affecting Japan shipments (-$140K).                 │
│                                                                  │
│  ROOT CAUSE: Customer project timing - Acme Corp delayed their  │
│  facility opening from Q1 to Q2, shifting $780K of demand.      │
│                                                                  │
│  TOP 3 CONTRIBUTORS:                                             │
│  1. Acme Corp Singapore    -$780K  (65%)                        │
│  2. Australia competitive  -$180K  (15%)                        │
│  3. Japan port delays      -$140K  (12%)                        │
│                                                                  │
│  📊 [View Pareto Chart] [View Waterfall] [View Trend]           │
│                                                                  │
│  RECOMMENDED ACTIONS:                                            │
│  ─────────────────────────────────────────────────────────────  │
│  1. Confirm Acme Q2 timing with sales (This week)               │
│  2. Review Australia competitive response plan                  │
│  3. Add customer project milestones to forecast inputs          │
│                                                                  │
│  [Create Action Items] [Ask Follow-up] [Export Analysis]        │
│                                                                  │
│  ─────────────────────────────────────────────────────────────  │
│  💬 Ask another question...                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered instant root cause analysis for faster problem resolution.*
