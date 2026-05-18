# AI Scenario Generation Workflow
## Automated Multi-Scenario Planning and Analysis

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AI SCENARIO GENERATION WORKFLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. DEFINE│───▶│ 2. GEN   │───▶│ 3. CALC  │───▶│ 4. PROB  │             │
│  │ DRIVERS  │    │ SCENARIOS│    │ IMPACT   │    │ WEIGHT   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Key Variables   Monte Carlo     Financial       AI Probability          │
│   Identified      Simulation      Translation     Assessment              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. RANK  │───▶│ 6. VISUAL│───▶│ 7. RECOM-│───▶│ 8. TRACK │            │
│  │ SCENARIOS│    │ IZE      │    │ MEND     │    │ ACTUAL   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Priority List   Charts &        AI Strategy     Scenario vs             │
│   For Review      Dashboards      Suggestion      Reality                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Define Scenario Drivers (Automated + Manual)

### Key Driver Categories
| Category | Variables | Typical Range |
|----------|-----------|---------------|
| Demand | Volume, mix, timing | ±10-30% |
| Supply | Capacity, yield, availability | ±5-20% |
| Pricing | Sell price, discounts | ±5-15% |
| Costs | Materials, labor, freight | ±5-25% |
| External | FX, tariffs, regulations | ±5-50% |
| Market | Competition, economy | Qualitative |

### Driver Configuration
```python
def configure_scenario_drivers():
    drivers = [
        {
            'name': 'demand_volume',
            'category': 'Demand',
            'base_value': 1.00,
            'min_value': 0.70,
            'max_value': 1.30,
            'distribution': 'normal',
            'std_dev': 0.10,
            'correlations': {'price': -0.3, 'economy': 0.5}
        },
        {
            'name': 'raw_material_cost',
            'category': 'Cost',
            'base_value': 1.00,
            'min_value': 0.90,
            'max_value': 1.30,
            'distribution': 'lognormal',
            'std_dev': 0.08,
            'correlations': {'oil_price': 0.7, 'fx_rate': 0.4}
        },
        {
            'name': 'capacity_utilization',
            'category': 'Supply',
            'base_value': 0.85,
            'min_value': 0.70,
            'max_value': 0.95,
            'distribution': 'triangular',
            'mode': 0.85
        },
        # Add more drivers...
    ]
    
    return drivers
```

---

## Step 2: Generate Scenarios (Monte Carlo)

### Scenario Generation Engine
```python
def generate_scenarios(drivers, n_scenarios=1000):
    scenarios = []
    
    # Generate correlated random variables
    correlation_matrix = build_correlation_matrix(drivers)
    random_samples = generate_correlated_samples(n_scenarios, correlation_matrix)
    
    for i in range(n_scenarios):
        scenario = {'id': f'S{i+1:04d}', 'drivers': {}}
        
        for j, driver in enumerate(drivers):
            # Apply distribution
            if driver['distribution'] == 'normal':
                value = norm.ppf(random_samples[i, j],
                               loc=driver['base_value'],
                               scale=driver['std_dev'])
            elif driver['distribution'] == 'lognormal':
                value = lognorm.ppf(random_samples[i, j],
                                  s=driver['std_dev'],
                                  scale=driver['base_value'])
            elif driver['distribution'] == 'triangular':
                value = triang.ppf(random_samples[i, j],
                                 c=(driver['mode'] - driver['min_value']) / 
                                   (driver['max_value'] - driver['min_value']),
                                 loc=driver['min_value'],
                                 scale=driver['max_value'] - driver['min_value'])
            
            # Apply bounds
            value = np.clip(value, driver['min_value'], driver['max_value'])
            scenario['drivers'][driver['name']] = value
        
        scenarios.append(scenario)
    
    return scenarios

def build_correlation_matrix(drivers):
    n = len(drivers)
    corr_matrix = np.eye(n)
    
    for i, driver_i in enumerate(drivers):
        for j, driver_j in enumerate(drivers):
            if driver_j['name'] in driver_i.get('correlations', {}):
                corr_matrix[i, j] = driver_i['correlations'][driver_j['name']]
                corr_matrix[j, i] = driver_i['correlations'][driver_j['name']]
    
    return corr_matrix
```

### Named Scenarios
```python
def create_named_scenarios(scenarios):
    # Define key scenarios from Monte Carlo results
    named = {
        'Base': select_scenario_near_percentile(scenarios, 50),
        'Upside_High': select_scenario_near_percentile(scenarios, 90),
        'Upside_Moderate': select_scenario_near_percentile(scenarios, 75),
        'Downside_Moderate': select_scenario_near_percentile(scenarios, 25),
        'Downside_Severe': select_scenario_near_percentile(scenarios, 10),
        'Worst_Case': select_scenario_near_percentile(scenarios, 5),
        'Best_Case': select_scenario_near_percentile(scenarios, 95)
    }
    
    # Add stress scenarios
    named['Supply_Disruption'] = create_stress_scenario(
        base=named['Base'],
        stress={'capacity_utilization': -0.30, 'supplier_reliability': -0.20}
    )
    
    named['Demand_Shock'] = create_stress_scenario(
        base=named['Base'],
        stress={'demand_volume': -0.25, 'price_realization': -0.10}
    )
    
    named['Cost_Surge'] = create_stress_scenario(
        base=named['Base'],
        stress={'raw_material_cost': +0.25, 'freight_cost': +0.30}
    )
    
    return named
```

---

## Step 3: Calculate Financial Impact (Automated)

### Financial Model
```python
def calculate_scenario_financials(scenario, base_plan):
    # Volume calculation
    volume = base_plan['volume'] * scenario['drivers']['demand_volume']
    volume *= scenario['drivers']['capacity_utilization'] / base_plan['capacity_utilization']
    
    # Revenue calculation
    price = base_plan['price'] * scenario['drivers'].get('price_realization', 1.0)
    revenue = volume * price
    
    # Cost calculation
    material_cost = (base_plan['material_cost_per_unit'] * 
                    scenario['drivers']['raw_material_cost'] * volume)
    labor_cost = (base_plan['labor_cost_per_unit'] * 
                 scenario['drivers'].get('labor_cost', 1.0) * volume)
    overhead = base_plan['fixed_overhead'] * scenario['drivers'].get('overhead_factor', 1.0)
    
    total_cost = material_cost + labor_cost + overhead
    
    # Margin calculation
    gross_profit = revenue - total_cost
    gross_margin_pct = gross_profit / revenue if revenue > 0 else 0
    
    # Working capital
    inventory_value = (volume / 12) * base_plan['dos_target'] * base_plan['cogs_per_unit']
    ar_value = revenue * (base_plan['dso'] / 365)
    ap_value = material_cost * (base_plan['dpo'] / 365)
    working_capital = inventory_value + ar_value - ap_value
    
    return {
        'volume': volume,
        'revenue': revenue,
        'total_cost': total_cost,
        'gross_profit': gross_profit,
        'gross_margin_pct': gross_margin_pct,
        'working_capital': working_capital,
        'revenue_vs_base': revenue - base_plan['revenue'],
        'profit_vs_base': gross_profit - base_plan['gross_profit']
    }
```

---

## Step 4: Probability Weighting (AI-Enhanced)

### AI Probability Assessment
```python
def assess_scenario_probability(scenario, context):
    # Statistical probability from Monte Carlo
    statistical_prob = calculate_statistical_probability(scenario)
    
    # AI adjustment based on current conditions
    prompt = f"""
    Assess the probability of this business scenario occurring:
    
    SCENARIO PARAMETERS:
    {format_scenario(scenario)}
    
    CURRENT MARKET CONDITIONS:
    {format_market_conditions(context['market'])}
    
    RECENT TRENDS:
    {format_trends(context['trends'])}
    
    KNOWN RISKS:
    {format_risks(context['risks'])}
    
    Provide:
    1. Probability estimate (0-100%)
    2. Key factors supporting this probability
    3. Conditions that would increase/decrease probability
    4. Confidence in the estimate (High/Medium/Low)
    """
    
    ai_assessment = call_llm(prompt)
    ai_prob = extract_probability(ai_assessment)
    
    # Blend statistical and AI probabilities
    blended_prob = 0.6 * statistical_prob + 0.4 * ai_prob
    
    return {
        'statistical_probability': statistical_prob,
        'ai_probability': ai_prob,
        'blended_probability': blended_prob,
        'ai_reasoning': ai_assessment,
        'confidence': extract_confidence(ai_assessment)
    }
```

### Probability Distribution
```python
def calculate_probability_distribution(scenarios, named_scenarios):
    distribution = {}
    
    for name, scenario in named_scenarios.items():
        prob = assess_scenario_probability(scenario, get_current_context())
        
        distribution[name] = {
            'scenario': scenario,
            'probability': prob['blended_probability'],
            'financials': calculate_scenario_financials(scenario, get_base_plan()),
            'confidence': prob['confidence']
        }
    
    # Normalize probabilities
    total_prob = sum(d['probability'] for d in distribution.values())
    for name in distribution:
        distribution[name]['normalized_probability'] = (
            distribution[name]['probability'] / total_prob
        )
    
    return distribution
```

---

## Step 5: Rank Scenarios (Automated)

### Ranking Algorithm
```python
def rank_scenarios(scenario_distribution):
    ranked = []
    
    for name, data in scenario_distribution.items():
        # Calculate expected value contribution
        expected_revenue = data['financials']['revenue'] * data['normalized_probability']
        expected_profit = data['financials']['gross_profit'] * data['normalized_probability']
        
        # Calculate risk-adjusted score
        risk_score = calculate_risk_score(data)
        opportunity_score = calculate_opportunity_score(data)
        
        ranked.append({
            'name': name,
            'probability': data['normalized_probability'],
            'revenue_impact': data['financials']['revenue_vs_base'],
            'profit_impact': data['financials']['profit_vs_base'],
            'expected_revenue': expected_revenue,
            'expected_profit': expected_profit,
            'risk_score': risk_score,
            'opportunity_score': opportunity_score,
            'priority': calculate_priority(risk_score, opportunity_score, data['normalized_probability'])
        })
    
    # Sort by priority
    ranked.sort(key=lambda x: x['priority'], reverse=True)
    
    return ranked
```

---

## Step 6: Visualize Scenarios (Automated)

### Visualization Components
```python
def generate_scenario_visualizations(distribution, ranked):
    visualizations = {}
    
    # 1. Tornado chart (sensitivity)
    visualizations['tornado'] = create_tornado_chart(
        base_case=distribution['Base'],
        scenarios=distribution,
        metric='gross_profit'
    )
    
    # 2. Fan chart (uncertainty over time)
    visualizations['fan_chart'] = create_fan_chart(
        scenarios=distribution,
        time_horizon=18,
        metric='revenue'
    )
    
    # 3. Probability-Impact matrix
    visualizations['probability_impact'] = create_scatter_plot(
        x=[s['probability'] for s in ranked],
        y=[s['profit_impact'] for s in ranked],
        labels=[s['name'] for s in ranked],
        title='Scenario Probability vs. Impact'
    )
    
    # 4. Waterfall chart (base to scenarios)
    visualizations['waterfall'] = create_waterfall_chart(
        base=distribution['Base']['financials'],
        scenarios={k: v['financials'] for k, v in distribution.items()},
        metric='gross_profit'
    )
    
    # 5. Expected value distribution
    visualizations['distribution'] = create_histogram(
        values=[calc_ev(s) for s in distribution.values()],
        title='Expected Value Distribution'
    )
    
    return visualizations
```

### Dashboard View
```
┌─────────────────────────────────────────────────────────────────┐
│  SCENARIO ANALYSIS DASHBOARD                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SCENARIO SUMMARY                                                │
│  ─────────────────────────────────────────────────────────────  │
│  Scenarios Generated: 1,000 (Monte Carlo)                        │
│  Named Scenarios: 10                                             │
│  Expected Value: $125.3M (Base: $120.0M)                        │
│  Value at Risk (5%): -$8.2M                                     │
│  Upside Potential (95%): +$15.5M                                │
│                                                                  │
│  TOP SCENARIOS BY PROBABILITY                                    │
│  ─────────────────────────────────────────────────────────────  │
│  1. Base Case (45%)           Revenue: $120.0M  Profit: $24.0M  │
│  2. Upside Moderate (25%)     Revenue: $132.0M  Profit: $29.0M  │
│  3. Downside Moderate (20%)   Revenue: $108.0M  Profit: $19.0M  │
│  4. Upside High (7%)          Revenue: $145.0M  Profit: $35.0M  │
│  5. Downside Severe (3%)      Revenue: $95.0M   Profit: $12.0M  │
│                                                                  │
│  RISK SCENARIOS (Require Mitigation)                             │
│  ─────────────────────────────────────────────────────────────  │
│  • Supply Disruption (8%): -$15M profit risk                    │
│  • Demand Shock (5%): -$12M profit risk                         │
│  • Cost Surge (10%): -$8M profit risk                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 7: Generate Recommendations (AI)

### AI Strategy Recommendations
```python
def generate_scenario_recommendations(distribution, ranked, context):
    prompt = f"""
    Based on the scenario analysis, provide strategic recommendations:
    
    SCENARIO SUMMARY:
    {format_scenario_summary(distribution)}
    
    RANKED SCENARIOS:
    {format_ranked_scenarios(ranked[:5])}
    
    KEY RISKS:
    {format_risk_scenarios(distribution)}
    
    CURRENT STRATEGY:
    {format_current_strategy(context)}
    
    Provide:
    1. Recommended planning scenario (which to use as operating plan)
    2. Key hedging strategies for downside scenarios
    3. Triggers/conditions to activate contingency plans
    4. Opportunities to capture from upside scenarios
    5. Resource allocation recommendations
    
    Format as actionable executive recommendations.
    """
    
    recommendations = call_llm(prompt)
    
    return parse_strategy_recommendations(recommendations)
```

### Recommendation Output
```
┌─────────────────────────────────────────────────────────────────┐
│  AI SCENARIO RECOMMENDATIONS                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  RECOMMENDED OPERATING PLAN: "Base Case with Buffer"            │
│  • Plan to Base Case volumes                                    │
│  • Build 10% safety stock buffer (cost: $1.2M)                  │
│  • Reserve capacity option for upside (+15%)                    │
│  Rationale: 70% probability of Base or better. Buffer provides  │
│  protection without significant cost.                           │
│                                                                  │
│  DOWNSIDE HEDGING:                                               │
│  1. Supplier Diversification: Qualify 2nd source for critical   │
│     materials (reduces Supply Disruption impact by 40%)         │
│  2. Demand Flexibility: Negotiate postponement clause with top  │
│     3 customers (reduces demand shock exposure by $3M)          │
│  3. Cost Hedging: Lock in material prices for Q3-Q4             │
│     (cost: $200K, saves $2M if Cost Surge scenario)             │
│                                                                  │
│  CONTINGENCY TRIGGERS:                                           │
│  • Activate Supply Disruption plan if supplier OTD < 85%        │
│  • Activate Demand Shock plan if orders -15% vs. forecast       │
│  • Activate Cost Surge plan if materials +10% in 30 days        │
│                                                                  │
│  UPSIDE CAPTURE:                                                 │
│  • Pre-negotiate capacity with contract manufacturers           │
│  • Prepare expedite capability (cost: $500K standby)            │
│  • Expected upside capture: $8M if Upside High realized         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 8: Track Actuals vs. Scenarios (Continuous)

### Scenario Tracking
```python
def track_scenario_vs_actual():
    # Get actual results
    actuals = get_actual_results(period='MTD')
    
    # Compare to all scenarios
    scenario_fit = {}
    for name, scenario in named_scenarios.items():
        projected = calculate_scenario_financials(scenario, get_base_plan())
        
        # Calculate fit score
        fit_score = calculate_fit_score(actuals, projected)
        
        scenario_fit[name] = {
            'fit_score': fit_score,
            'revenue_variance': actuals['revenue'] - projected['revenue'],
            'profit_variance': actuals['profit'] - projected['profit'],
            'drivers_matching': identify_matching_drivers(actuals, scenario)
        }
    
    # Identify best-fit scenario
    best_fit = max(scenario_fit.items(), key=lambda x: x[1]['fit_score'])
    
    # Alert if tracking to adverse scenario
    if best_fit[0] in ['Downside_Severe', 'Worst_Case', 'Supply_Disruption']:
        alert_adverse_scenario_tracking(best_fit)
    
    return scenario_fit, best_fit

def alert_adverse_scenario_tracking(scenario):
    alert = {
        'type': 'SCENARIO_TRACKING',
        'severity': 'HIGH',
        'message': f"Actuals tracking to {scenario[0]} scenario",
        'fit_score': scenario[1]['fit_score'],
        'recommendation': 'Review contingency activation'
    }
    send_alert(alert, recipients=['executive_team', 'ibp_leader'])
```

---

## Integration Points

| System | Integration | Purpose |
|--------|-------------|---------|
| Financial Planning | Scenario financials | P&L integration |
| Demand Planning | Volume scenarios | Demand plan ranges |
| Supply Planning | Capacity scenarios | Constraint modeling |
| Risk Management | Risk scenarios | Mitigation planning |
| Executive Dashboard | Visualizations | Decision support |

---

*AI-powered scenario generation for robust planning under uncertainty.*
