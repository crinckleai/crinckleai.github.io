# Smart Consensus Workflow
## LLM-Powered Demand Forecast Reconciliation

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SMART CONSENSUS WORKFLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. GATHER│───▶│ 2. ANALYZE│───▶│ 3. WEIGHT│───▶│ 4. DRAFT │            │
│  │ INPUTS   │    │ VARIANCE │    │ SOURCES  │    │ CONSENSUS│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Statistical      Compare &       Historical       LLM-Generated         │
│   Sales/Mktg       Explain         Accuracy         Draft Forecast        │
│   Customer         Differences     Weighting                              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. EXPLAIN│───▶│ 6. REVIEW│───▶│ 7. FINALIZE│──▶│ 8. TRACK │           │
│  │ RATIONALE│    │ EXCEPTIONS│   │ PUBLISH  │    │ ACCURACY │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   AI-Written       Human          Lock &          Learn &                 │
│   Justification    Override       Distribute      Improve                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Gather Inputs

### Multi-Source Collection
```python
def gather_forecast_inputs(product_family, forecast_period):
    """Collect all forecast inputs from various sources"""
    
    inputs = {}
    
    # Statistical baseline (ML ensemble)
    inputs['statistical'] = {
        'source': 'ML Ensemble',
        'forecast': get_statistical_forecast(product_family, forecast_period),
        'confidence_interval': get_forecast_ci(product_family, forecast_period),
        'model_used': get_best_model(product_family),
        'features_used': get_model_features(product_family),
        'last_accuracy': get_historical_accuracy('statistical', product_family)
    }
    
    # Sales input
    inputs['sales'] = {
        'source': 'Sales Team',
        'forecast': get_sales_forecast(product_family, forecast_period),
        'assumptions': get_sales_assumptions(product_family),
        'opportunities': get_pipeline_data(product_family),
        'last_accuracy': get_historical_accuracy('sales', product_family)
    }
    
    # Marketing input
    inputs['marketing'] = {
        'source': 'Marketing Team',
        'forecast': get_marketing_forecast(product_family, forecast_period),
        'campaigns': get_planned_campaigns(product_family, forecast_period),
        'market_factors': get_market_assumptions(product_family),
        'last_accuracy': get_historical_accuracy('marketing', product_family)
    }
    
    # Customer input (where available)
    inputs['customer'] = {
        'source': 'Customer Forecasts',
        'forecast': aggregate_customer_forecasts(product_family, forecast_period),
        'coverage': get_customer_forecast_coverage(product_family),
        'customer_count': get_forecasting_customer_count(product_family),
        'last_accuracy': get_historical_accuracy('customer', product_family)
    }
    
    # Finance guidance
    inputs['finance'] = {
        'source': 'Finance',
        'target': get_financial_target(product_family, forecast_period),
        'budget_assumption': get_budget_growth_rate(product_family),
        'constraints': get_financial_constraints(product_family)
    }
    
    # External signals
    inputs['external'] = {
        'source': 'External Data',
        'market_growth': get_market_growth_forecast(product_family),
        'economic_indicators': get_economic_indicators(),
        'competitor_intel': get_competitor_signals(product_family)
    }
    
    return inputs

def aggregate_customer_forecasts(product_family, forecast_period):
    """Aggregate forecasts from individual customers"""
    customer_forecasts = get_customer_level_forecasts(product_family)
    
    aggregated = np.zeros(len(forecast_period))
    for customer, forecast in customer_forecasts.items():
        # Apply customer reliability factor
        reliability = get_customer_forecast_reliability(customer)
        aggregated += np.array(forecast) * reliability
    
    return aggregated.tolist()
```

---

## Step 2: Analyze Variance

### Cross-Source Comparison
```python
def analyze_forecast_variance(inputs):
    """Analyze differences between forecast sources"""
    
    # Extract forecasts
    forecasts = {
        source: data['forecast']
        for source, data in inputs.items()
        if 'forecast' in data and data['forecast'] is not None
    }
    
    # Calculate variance metrics
    variance_analysis = {
        'by_period': [],
        'by_source_pair': [],
        'overall_spread': {}
    }
    
    # Period-by-period variance
    for period_idx in range(len(list(forecasts.values())[0])):
        period_values = {source: fc[period_idx] for source, fc in forecasts.items()}
        
        variance_analysis['by_period'].append({
            'period': period_idx + 1,
            'values': period_values,
            'mean': np.mean(list(period_values.values())),
            'std': np.std(list(period_values.values())),
            'range': max(period_values.values()) - min(period_values.values()),
            'cv': np.std(list(period_values.values())) / np.mean(list(period_values.values()))
        })
    
    # Source-pair variance
    sources = list(forecasts.keys())
    for i, source_a in enumerate(sources):
        for source_b in sources[i+1:]:
            mape = calculate_mape(forecasts[source_a], forecasts[source_b])
            variance_analysis['by_source_pair'].append({
                'source_a': source_a,
                'source_b': source_b,
                'mape': mape,
                'total_diff': sum(forecasts[source_a]) - sum(forecasts[source_b]),
                'total_diff_pct': (sum(forecasts[source_a]) - sum(forecasts[source_b])) / sum(forecasts[source_b]) * 100
            })
    
    # Overall spread
    all_totals = [sum(fc) for fc in forecasts.values()]
    variance_analysis['overall_spread'] = {
        'min_total': min(all_totals),
        'max_total': max(all_totals),
        'spread': max(all_totals) - min(all_totals),
        'spread_pct': (max(all_totals) - min(all_totals)) / np.mean(all_totals) * 100
    }
    
    # Identify key differences via LLM
    variance_analysis['key_differences'] = explain_key_differences(inputs, variance_analysis)
    
    return variance_analysis

def explain_key_differences(inputs, variance_analysis):
    """Use LLM to explain key differences between forecasts"""
    
    prompt = f"""
    Analyze the differences between these forecast inputs:
    
    STATISTICAL (ML): {sum(inputs['statistical']['forecast']):,.0f} total
    - Model: {inputs['statistical']['model_used']}
    - Historical accuracy: {inputs['statistical']['last_accuracy']:.1%}
    
    SALES: {sum(inputs['sales']['forecast']):,.0f} total
    - Assumptions: {inputs['sales']['assumptions']}
    - Historical accuracy: {inputs['sales']['last_accuracy']:.1%}
    
    MARKETING: {sum(inputs['marketing']['forecast']):,.0f} total
    - Campaigns: {inputs['marketing']['campaigns']}
    - Historical accuracy: {inputs['marketing']['last_accuracy']:.1%}
    
    CUSTOMER: {sum(inputs['customer']['forecast']):,.0f} total
    - Coverage: {inputs['customer']['coverage']:.1%}
    - Historical accuracy: {inputs['customer']['last_accuracy']:.1%}
    
    VARIANCE METRICS:
    - Overall spread: {variance_analysis['overall_spread']['spread_pct']:.1f}%
    - Highest variance periods: {get_high_variance_periods(variance_analysis)}
    
    Explain:
    1. Top 3 reasons for the differences
    2. Which source is likely most reliable and why
    3. Key risks in each forecast
    4. Recommended areas for discussion
    """
    
    return call_llm(prompt)
```

---

## Step 3: Weight Sources

### Dynamic Accuracy Weighting
```python
def calculate_source_weights(inputs, product_family):
    """Calculate weights for each source based on historical accuracy"""
    
    weights = {}
    
    # Get accuracy history
    accuracy_history = get_accuracy_history(product_family, periods=12)
    
    # Calculate base weights from accuracy
    for source in ['statistical', 'sales', 'marketing', 'customer']:
        if source in inputs and inputs[source].get('forecast'):
            # Inverse of WMAPE as weight
            wmape = accuracy_history.get(source, {}).get('wmape', 0.30)
            base_weight = 1 / (wmape + 0.01)  # Avoid division by zero
            weights[source] = {
                'base_weight': base_weight,
                'accuracy': 1 - wmape
            }
    
    # Normalize weights
    total_weight = sum(w['base_weight'] for w in weights.values())
    for source in weights:
        weights[source]['normalized'] = weights[source]['base_weight'] / total_weight
    
    # Adjust for context
    weights = adjust_weights_for_context(weights, inputs, product_family)
    
    return weights

def adjust_weights_for_context(weights, inputs, product_family):
    """Adjust weights based on current context"""
    
    adjustments = {}
    
    # If new product, reduce statistical weight
    if is_new_product(product_family):
        adjustments['statistical'] = 0.5  # Reduce by 50%
        adjustments['sales'] = 1.3  # Increase by 30%
        adjustments['marketing'] = 1.2
    
    # If major promotion planned, increase marketing weight
    if has_major_promotion(inputs.get('marketing', {}).get('campaigns')):
        adjustments['marketing'] = adjustments.get('marketing', 1.0) * 1.3
    
    # If high customer coverage, increase customer weight
    if inputs.get('customer', {}).get('coverage', 0) > 0.7:
        adjustments['customer'] = 1.5
    
    # If market disruption, reduce all historical-based weights
    if detect_market_disruption(inputs.get('external', {})):
        for source in weights:
            if source != 'sales':  # Keep sales weight for human insight
                adjustments[source] = adjustments.get(source, 1.0) * 0.7
    
    # Apply adjustments
    for source, adj in adjustments.items():
        if source in weights:
            weights[source]['adjusted'] = weights[source]['normalized'] * adj
    
    # Re-normalize
    total_adjusted = sum(w.get('adjusted', w['normalized']) for w in weights.values())
    for source in weights:
        final = weights[source].get('adjusted', weights[source]['normalized'])
        weights[source]['final'] = final / total_adjusted
    
    return weights
```

---

## Step 4: Draft Consensus

### AI-Generated Consensus Forecast
```python
def generate_consensus_draft(inputs, weights, variance_analysis):
    """Generate weighted consensus forecast with AI enhancement"""
    
    # Calculate weighted average
    n_periods = len(inputs['statistical']['forecast'])
    consensus = np.zeros(n_periods)
    
    for source, weight_data in weights.items():
        if source in inputs and inputs[source].get('forecast'):
            forecast = np.array(inputs[source]['forecast'])
            weight = weight_data['final']
            consensus += forecast * weight
    
    # Apply AI adjustments for known factors
    consensus = apply_ai_adjustments(consensus, inputs, variance_analysis)
    
    # Generate forecast by period
    consensus_forecast = {
        'periods': [],
        'total': sum(consensus),
        'methodology': 'Weighted average with AI adjustments'
    }
    
    for period_idx, value in enumerate(consensus):
        consensus_forecast['periods'].append({
            'period': period_idx + 1,
            'consensus_value': value,
            'confidence_range': calculate_confidence_range(value, variance_analysis, period_idx),
            'primary_driver': identify_primary_driver(inputs, weights, period_idx)
        })
    
    return consensus_forecast

def apply_ai_adjustments(consensus, inputs, variance_analysis):
    """Apply AI-driven adjustments for known factors"""
    
    adjustments = []
    
    # Promotion uplift adjustment
    campaigns = inputs.get('marketing', {}).get('campaigns', [])
    for campaign in campaigns:
        period = campaign.get('period')
        if period:
            expected_uplift = estimate_promotion_uplift(campaign)
            stat_uplift = inputs['statistical']['forecast'][period-1] / get_baseline(period-1) - 1
            
            if expected_uplift > stat_uplift:
                # Statistical may be underestimating promotion
                adjustment = (expected_uplift - stat_uplift) * consensus[period-1]
                consensus[period-1] += adjustment
                adjustments.append({
                    'period': period,
                    'type': 'promotion_uplift',
                    'adjustment': adjustment
                })
    
    # Seasonality sanity check
    consensus = adjust_for_seasonality(consensus, inputs)
    
    # Market trend adjustment
    market_growth = inputs.get('external', {}).get('market_growth', 0)
    if market_growth and abs(market_growth) > 0.05:
        # Significant market shift
        for i in range(len(consensus)):
            consensus[i] *= (1 + market_growth * (i / len(consensus)))
    
    return consensus
```

---

## Step 5: Explain Rationale

### AI-Written Justification
```python
def generate_consensus_rationale(inputs, weights, consensus_forecast, variance_analysis):
    """Generate AI explanation of consensus methodology and decisions"""
    
    prompt = f"""
    Generate a clear, executive-friendly explanation of this consensus forecast:
    
    CONSENSUS TOTAL: {consensus_forecast['total']:,.0f}
    
    INPUT FORECASTS:
    - Statistical (ML): {sum(inputs['statistical']['forecast']):,.0f} (weight: {weights['statistical']['final']:.1%})
    - Sales: {sum(inputs['sales']['forecast']):,.0f} (weight: {weights['sales']['final']:.1%})
    - Marketing: {sum(inputs['marketing']['forecast']):,.0f} (weight: {weights['marketing']['final']:.1%})
    - Customer: {sum(inputs['customer']['forecast']):,.0f} (weight: {weights['customer']['final']:.1%})
    
    KEY VARIANCE AREAS:
    {variance_analysis['key_differences']}
    
    WEIGHT RATIONALE:
    - Statistical accuracy (12mo): {inputs['statistical']['last_accuracy']:.1%}
    - Sales accuracy (12mo): {inputs['sales']['last_accuracy']:.1%}
    - Marketing accuracy (12mo): {inputs['marketing']['last_accuracy']:.1%}
    - Customer accuracy (12mo): {inputs['customer']['last_accuracy']:.1%}
    
    Write a 3-paragraph explanation covering:
    1. How the consensus was calculated and why weights were assigned
    2. Key assumptions embedded in this forecast
    3. Main risks and what could cause the forecast to be wrong
    
    Be specific and quantitative. This will be reviewed by planners and executives.
    """
    
    rationale = call_llm(prompt)
    
    # Generate structured assumptions
    assumptions = extract_key_assumptions(inputs, consensus_forecast)
    
    # Generate risk factors
    risks = identify_forecast_risks(inputs, variance_analysis, consensus_forecast)
    
    return {
        'narrative_rationale': rationale,
        'key_assumptions': assumptions,
        'risk_factors': risks,
        'weight_explanation': explain_weights(weights),
        'generated_at': datetime.now().isoformat()
    }
```

---

## Step 6: Review Exceptions

### Human Override Interface
```python
def identify_review_items(consensus_forecast, inputs, variance_analysis):
    """Identify items requiring human review"""
    
    review_items = []
    
    # High variance periods
    for period in variance_analysis['by_period']:
        if period['cv'] > 0.20:  # CV > 20%
            review_items.append({
                'type': 'HIGH_VARIANCE',
                'period': period['period'],
                'details': f"Spread: {period['range']:,.0f} ({period['cv']:.1%} CV)",
                'consensus_value': consensus_forecast['periods'][period['period']-1]['consensus_value'],
                'all_inputs': period['values'],
                'priority': 'HIGH' if period['cv'] > 0.30 else 'MEDIUM'
            })
    
    # Large deviations from finance target
    finance_target = sum(inputs['finance']['target'])
    consensus_total = consensus_forecast['total']
    if abs(consensus_total - finance_target) / finance_target > 0.10:
        review_items.append({
            'type': 'FINANCE_GAP',
            'details': f"Consensus {consensus_total:,.0f} vs Target {finance_target:,.0f} ({(consensus_total/finance_target-1)*100:+.1f}%)",
            'priority': 'HIGH'
        })
    
    # New products with limited data
    if inputs['statistical'].get('last_accuracy', 0) < 0.5:
        review_items.append({
            'type': 'LOW_CONFIDENCE',
            'details': 'Limited historical data - statistical model less reliable',
            'priority': 'MEDIUM'
        })
    
    # Significant promotional periods
    campaigns = inputs.get('marketing', {}).get('campaigns', [])
    for campaign in campaigns:
        if campaign.get('investment', 0) > get_major_campaign_threshold():
            review_items.append({
                'type': 'MAJOR_CAMPAIGN',
                'period': campaign.get('period'),
                'details': f"Major campaign: {campaign.get('name')} - verify uplift assumptions",
                'priority': 'MEDIUM'
            })
    
    return sorted(review_items, key=lambda x: 0 if x['priority'] == 'HIGH' else 1)

def process_human_override(consensus_forecast, override):
    """Process human override of consensus"""
    
    updated_forecast = consensus_forecast.copy()
    
    if override['type'] == 'period_adjustment':
        period = override['period']
        updated_forecast['periods'][period-1]['consensus_value'] = override['new_value']
        updated_forecast['periods'][period-1]['override'] = {
            'by': override['user'],
            'reason': override['reason'],
            'original_value': consensus_forecast['periods'][period-1]['consensus_value'],
            'timestamp': datetime.now().isoformat()
        }
    
    elif override['type'] == 'total_adjustment':
        adjustment_factor = override['new_total'] / consensus_forecast['total']
        for period in updated_forecast['periods']:
            original = period['consensus_value']
            period['consensus_value'] *= adjustment_factor
            period['override'] = {
                'by': override['user'],
                'reason': override['reason'],
                'original_value': original
            }
    
    # Recalculate total
    updated_forecast['total'] = sum(p['consensus_value'] for p in updated_forecast['periods'])
    updated_forecast['has_overrides'] = True
    
    return updated_forecast
```

---

## Step 7: Finalize & Publish

### Lock and Distribute
```python
def finalize_consensus(consensus_forecast, rationale, approval):
    """Finalize and lock consensus forecast"""
    
    final_forecast = {
        **consensus_forecast,
        'status': 'FINAL',
        'rationale': rationale,
        'approval': {
            'approved_by': approval['user'],
            'approved_at': datetime.now().isoformat(),
            'comments': approval.get('comments')
        },
        'version': get_next_version(),
        'locked': True
    }
    
    # Store in forecast database
    store_consensus_forecast(final_forecast)
    
    # Publish to downstream systems
    publish_to_erp(final_forecast)
    publish_to_supply_planning(final_forecast)
    publish_to_finance(final_forecast)
    
    # Notify stakeholders
    notify_stakeholders(final_forecast, [
        'demand_planning',
        'supply_planning',
        'sales',
        'finance'
    ])
    
    # Create audit trail
    log_forecast_finalization(final_forecast)
    
    return final_forecast

def publish_to_supply_planning(forecast):
    """Publish forecast to supply planning system"""
    
    supply_format = transform_to_supply_format(forecast)
    
    api_response = call_supply_planning_api(
        endpoint='forecast/update',
        data=supply_format
    )
    
    if api_response['status'] != 'success':
        alert_integration_failure('supply_planning', api_response)
    
    return api_response
```

---

## Step 8: Track Accuracy

### Learn and Improve
```python
def track_consensus_accuracy(forecast_id, actual_period):
    """Track accuracy and learn from results"""
    
    # Get stored consensus
    consensus = get_stored_consensus(forecast_id)
    
    # Get actual values
    actuals = get_actual_demand(consensus['product_family'], actual_period)
    
    # Calculate accuracy metrics
    accuracy = {
        'period': actual_period,
        'consensus_value': consensus['periods'][actual_period-1]['consensus_value'],
        'actual_value': actuals,
        'variance': actuals - consensus['periods'][actual_period-1]['consensus_value'],
        'variance_pct': (actuals - consensus['periods'][actual_period-1]['consensus_value']) / consensus['periods'][actual_period-1]['consensus_value'] * 100,
        'abs_error': abs(actuals - consensus['periods'][actual_period-1]['consensus_value'])
    }
    
    # Track by source
    for source in ['statistical', 'sales', 'marketing', 'customer']:
        if consensus.get('inputs', {}).get(source):
            source_value = consensus['inputs'][source]['forecast'][actual_period-1]
            accuracy[f'{source}_variance'] = actuals - source_value
            accuracy[f'{source}_accuracy'] = 1 - abs(actuals - source_value) / actuals
    
    # Store for learning
    store_accuracy_record(forecast_id, accuracy)
    
    # Update weight recommendations
    update_weight_learning(consensus['product_family'], accuracy)
    
    return accuracy

def update_weight_learning(product_family, accuracy):
    """Update recommended weights based on actual accuracy"""
    
    # Get recent accuracy by source
    recent_accuracy = get_recent_accuracy_by_source(product_family, periods=12)
    
    # Calculate new recommended weights
    new_weights = {}
    total_accuracy = sum(1 - a['wmape'] for a in recent_accuracy.values())
    
    for source, metrics in recent_accuracy.items():
        source_accuracy = 1 - metrics['wmape']
        new_weights[source] = source_accuracy / total_accuracy
    
    # Store updated weights
    store_recommended_weights(product_family, new_weights)
    
    return new_weights
```

---

## Consensus Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  SMART CONSENSUS DASHBOARD                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PRODUCT FAMILY: Industrial Widgets                              │
│  FORECAST PERIOD: Jul-Dec 2026                                   │
│                                                                  │
│  INPUT SUMMARY:                                                  │
│  ─────────────────────────────────────────────────────────────  │
│  Source        Forecast    Weight    12m Accuracy                │
│  Statistical   125,000     35%       87%          █████████░    │
│  Sales         142,000     25%       78%          ████████░░    │
│  Marketing     138,000     20%       75%          ███████░░░    │
│  Customer      131,000     20%       82%          ████████░░    │
│  ─────────────────────────────────────────────────────────────  │
│  CONSENSUS:    133,500                                           │
│                                                                  │
│  VARIANCE ANALYSIS:                                              │
│  Overall spread: 13.6% (within normal range)                    │
│  Highest variance: Aug (+22% spread) - review recommended       │
│                                                                  │
│  FINANCE TARGET: 140,000                                         │
│  GAP: -6,500 (-4.6%)                                            │
│                                                                  │
│  REVIEW ITEMS: 3                                                 │
│  ├── HIGH: August variance needs discussion                     │
│  ├── MED: Q4 campaign uplift validation                         │
│  └── MED: New customer ramp assumptions                         │
│                                                                  │
│  STATUS: Draft → [Review] → [Approve] → [Publish]               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*LLM-powered consensus forecasting for faster, more accurate demand plans.*
