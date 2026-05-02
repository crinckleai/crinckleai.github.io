# Gap Prediction Workflow
## ML-Powered Early Warning for Financial Gaps

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    GAP PREDICTION WORKFLOW                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. COLLECT│───▶│ 2. FEATURE│──▶│ 3. PREDICT│──▶│ 4. QUANTIFY│           │
│  │ SIGNALS  │    │ ENGINEER │    │ GAPS     │    │ IMPACT   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Leading          ML Feature       Probability     Financial            │
│   Indicators       Extraction       Models          Translation          │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. ALERT │───▶│ 6. ROOT  │───▶│ 7. RECOMMEND│─▶│ 8. TRACK │            │
│  │ STAKEHOLDERS│ │ CAUSE    │    │ ACTIONS  │    │ OUTCOMES │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Tiered           AI-Driven        Gap Closure     Learn &              │
│   Notifications    Analysis         Options         Improve              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Collect Signals

### Leading Indicator Collection
```python
def collect_gap_signals():
    """Collect leading indicators that predict financial gaps"""
    
    signals = {
        'demand_signals': {},
        'supply_signals': {},
        'market_signals': {},
        'operational_signals': {},
        'external_signals': {}
    }
    
    # Demand-side signals
    signals['demand_signals'] = {
        'forecast_trend': calculate_forecast_trend(periods=3),
        'forecast_volatility': calculate_forecast_volatility(),
        'booking_pace': get_booking_pace_vs_plan(),
        'pipeline_health': get_pipeline_coverage_ratio(),
        'win_rate_trend': get_win_rate_trend(),
        'customer_sentiment': get_customer_sentiment_score(),
        'lead_generation': get_lead_generation_vs_plan(),
        'quote_activity': get_quote_activity_trend()
    }
    
    # Supply-side signals
    signals['supply_signals'] = {
        'inventory_health': calculate_inventory_health_score(),
        'supplier_risk': get_aggregate_supplier_risk(),
        'capacity_utilization': get_capacity_utilization_trend(),
        'lead_time_performance': get_lead_time_performance(),
        'quality_metrics': get_quality_trend(),
        'backlog_age': get_backlog_aging_trend()
    }
    
    # Market signals
    signals['market_signals'] = {
        'market_growth': get_market_growth_indicator(),
        'competitor_activity': get_competitor_intensity_score(),
        'price_pressure': detect_price_pressure(),
        'market_share_trend': get_market_share_trend(),
        'industry_sentiment': get_industry_sentiment_index()
    }
    
    # Operational signals
    signals['operational_signals'] = {
        'production_efficiency': get_oee_trend(),
        'cost_trends': get_cost_trend_indicators(),
        'service_level': get_service_level_trend(),
        'returns_rate': get_returns_trend(),
        'days_sales_outstanding': get_dso_trend()
    }
    
    # External signals
    signals['external_signals'] = {
        'economic_indicators': get_economic_indicators(),
        'fx_trends': get_fx_movement_indicators(),
        'commodity_prices': get_commodity_price_trends(),
        'regulatory_changes': detect_regulatory_impacts(),
        'weather_impacts': assess_weather_impacts()
    }
    
    return signals

def calculate_forecast_trend(periods=3):
    """Calculate trend in forecast revisions"""
    
    revisions = get_forecast_revisions(periods)
    
    if len(revisions) < 2:
        return {'trend': 'stable', 'magnitude': 0}
    
    # Calculate direction and magnitude
    changes = [revisions[i+1] - revisions[i] for i in range(len(revisions)-1)]
    avg_change = np.mean(changes)
    
    return {
        'trend': 'declining' if avg_change < -0.02 else 'improving' if avg_change > 0.02 else 'stable',
        'magnitude': avg_change,
        'consistency': np.std(changes),
        'signal_strength': abs(avg_change) / (np.std(changes) + 0.01)
    }
```

---

## Step 2: Feature Engineering

### ML Feature Extraction
```python
def engineer_gap_features(signals):
    """Engineer features for gap prediction model"""
    
    features = {}
    
    # Demand features
    features['forecast_trend_strength'] = signals['demand_signals']['forecast_trend']['signal_strength']
    features['forecast_declining'] = 1 if signals['demand_signals']['forecast_trend']['trend'] == 'declining' else 0
    features['booking_pace_ratio'] = signals['demand_signals']['booking_pace']
    features['pipeline_coverage'] = signals['demand_signals']['pipeline_health']
    features['win_rate_change'] = signals['demand_signals']['win_rate_trend'].get('change', 0)
    
    # Supply features
    features['inventory_risk'] = 1 - signals['supply_signals']['inventory_health']
    features['supplier_risk_score'] = signals['supply_signals']['supplier_risk']
    features['capacity_constraint'] = 1 if signals['supply_signals']['capacity_utilization'] > 0.9 else 0
    features['lead_time_pressure'] = signals['supply_signals']['lead_time_performance'].get('pressure', 0)
    
    # Market features
    features['market_headwind'] = -min(signals['market_signals']['market_growth'], 0)
    features['competitive_pressure'] = signals['market_signals']['competitor_activity']
    features['price_erosion'] = signals['market_signals']['price_pressure']
    features['share_decline'] = -min(signals['market_signals']['market_share_trend'].get('change', 0), 0)
    
    # Operational features
    features['efficiency_decline'] = -min(signals['operational_signals']['production_efficiency'].get('trend', 0), 0)
    features['cost_inflation'] = max(signals['operational_signals']['cost_trends'].get('change', 0), 0)
    features['service_issues'] = 1 - signals['operational_signals']['service_level']
    
    # External features
    features['economic_headwind'] = signals['external_signals']['economic_indicators'].get('risk', 0)
    features['fx_headwind'] = signals['external_signals']['fx_trends'].get('negative_impact', 0)
    features['commodity_pressure'] = signals['external_signals']['commodity_prices'].get('increase_pct', 0)
    
    # Composite features
    features['demand_risk_composite'] = (
        features['forecast_declining'] * 0.3 +
        (1 - features['booking_pace_ratio']) * 0.3 +
        (1 - features['pipeline_coverage']) * 0.2 +
        features['win_rate_change'] * 0.2
    )
    
    features['supply_risk_composite'] = (
        features['inventory_risk'] * 0.3 +
        features['supplier_risk_score'] * 0.3 +
        features['capacity_constraint'] * 0.2 +
        features['lead_time_pressure'] * 0.2
    )
    
    features['margin_risk_composite'] = (
        features['price_erosion'] * 0.35 +
        features['cost_inflation'] * 0.35 +
        features['efficiency_decline'] * 0.15 +
        features['commodity_pressure'] * 0.15
    )
    
    return features

def prepare_training_data():
    """Prepare training data from historical gaps"""
    
    # Get historical periods
    historical = get_historical_plan_vs_actual(periods=36)
    
    training_data = []
    
    for period in historical:
        # Get signals as of that period
        historical_signals = get_historical_signals(period['date'])
        
        # Engineer features
        features = engineer_gap_features(historical_signals)
        
        # Calculate actual gaps
        revenue_gap = period['actual_revenue'] - period['planned_revenue']
        margin_gap = period['actual_margin'] - period['planned_margin']
        
        training_data.append({
            'features': features,
            'revenue_gap_pct': revenue_gap / period['planned_revenue'],
            'margin_gap_bps': margin_gap * 10000,  # Basis points
            'had_significant_gap': abs(revenue_gap / period['planned_revenue']) > 0.05
        })
    
    return training_data
```

---

## Step 3: Predict Gaps

### ML Gap Prediction
```python
from sklearn.ensemble import GradientBoostingRegressor, GradientBoostingClassifier
from sklearn.model_selection import cross_val_score
import numpy as np

def train_gap_prediction_models():
    """Train ML models for gap prediction"""
    
    training_data = prepare_training_data()
    
    # Prepare data
    X = pd.DataFrame([d['features'] for d in training_data])
    y_revenue = pd.Series([d['revenue_gap_pct'] for d in training_data])
    y_margin = pd.Series([d['margin_gap_bps'] for d in training_data])
    y_significant = pd.Series([d['had_significant_gap'] for d in training_data])
    
    models = {}
    
    # Revenue gap regression model
    models['revenue_gap'] = GradientBoostingRegressor(
        n_estimators=100,
        max_depth=4,
        learning_rate=0.1
    )
    models['revenue_gap'].fit(X, y_revenue)
    
    # Margin gap regression model
    models['margin_gap'] = GradientBoostingRegressor(
        n_estimators=100,
        max_depth=4,
        learning_rate=0.1
    )
    models['margin_gap'].fit(X, y_margin)
    
    # Significant gap classifier
    models['gap_probability'] = GradientBoostingClassifier(
        n_estimators=100,
        max_depth=4,
        learning_rate=0.1
    )
    models['gap_probability'].fit(X, y_significant)
    
    # Save models
    for name, model in models.items():
        save_model(model, f'gap_prediction_{name}')
    
    return models

def predict_gaps(features, horizon='current_quarter'):
    """Predict gaps using trained models"""
    
    # Load models
    revenue_model = load_model('gap_prediction_revenue_gap')
    margin_model = load_model('gap_prediction_margin_gap')
    prob_model = load_model('gap_prediction_gap_probability')
    
    # Prepare features
    X = pd.DataFrame([features])
    
    # Predictions
    predictions = {
        'horizon': horizon,
        'predicted_at': datetime.now(),
        'revenue_gap': {
            'predicted_gap_pct': revenue_model.predict(X)[0],
            'confidence_interval': calculate_prediction_interval(revenue_model, X, 'revenue')
        },
        'margin_gap': {
            'predicted_gap_bps': margin_model.predict(X)[0],
            'confidence_interval': calculate_prediction_interval(margin_model, X, 'margin')
        },
        'gap_probability': {
            'probability': prob_model.predict_proba(X)[0, 1],
            'risk_level': classify_risk_level(prob_model.predict_proba(X)[0, 1])
        },
        'feature_importance': get_prediction_drivers(revenue_model, X, features)
    }
    
    return predictions

def classify_risk_level(probability):
    """Classify gap risk level"""
    
    if probability >= 0.7:
        return 'HIGH'
    elif probability >= 0.4:
        return 'MEDIUM'
    elif probability >= 0.2:
        return 'LOW'
    else:
        return 'MINIMAL'

def get_prediction_drivers(model, X, features):
    """Get feature importance for this prediction"""
    
    importances = model.feature_importances_
    feature_names = list(features.keys())
    
    # Sort by importance
    sorted_idx = np.argsort(importances)[::-1]
    
    drivers = []
    for idx in sorted_idx[:5]:  # Top 5 drivers
        drivers.append({
            'feature': feature_names[idx],
            'importance': importances[idx],
            'current_value': features[feature_names[idx]],
            'direction': 'increasing_risk' if features[feature_names[idx]] > 0.5 else 'decreasing_risk'
        })
    
    return drivers
```

---

## Step 4: Quantify Impact

### Financial Translation
```python
def quantify_gap_impact(predictions, current_plan):
    """Translate predicted gaps to financial impact"""
    
    impact = {
        'revenue_impact': {},
        'margin_impact': {},
        'bottom_line_impact': {},
        'by_segment': {}
    }
    
    # Revenue impact
    planned_revenue = current_plan['revenue']
    predicted_gap_pct = predictions['revenue_gap']['predicted_gap_pct']
    
    impact['revenue_impact'] = {
        'planned': planned_revenue,
        'predicted_gap_pct': predicted_gap_pct,
        'predicted_gap_dollars': planned_revenue * predicted_gap_pct,
        'predicted_actual': planned_revenue * (1 + predicted_gap_pct),
        'confidence_range': {
            'low': planned_revenue * (1 + predictions['revenue_gap']['confidence_interval']['lower']),
            'high': planned_revenue * (1 + predictions['revenue_gap']['confidence_interval']['upper'])
        }
    }
    
    # Margin impact
    planned_margin = current_plan['gross_margin_pct']
    predicted_margin_gap = predictions['margin_gap']['predicted_gap_bps'] / 10000
    
    impact['margin_impact'] = {
        'planned_margin_pct': planned_margin,
        'predicted_margin_pct': planned_margin + predicted_margin_gap,
        'margin_gap_bps': predictions['margin_gap']['predicted_gap_bps'],
        'margin_dollar_impact': impact['revenue_impact']['predicted_actual'] * predicted_margin_gap
    }
    
    # Bottom line impact
    predicted_revenue = impact['revenue_impact']['predicted_actual']
    predicted_margin = impact['margin_impact']['predicted_margin_pct']
    predicted_gross_profit = predicted_revenue * predicted_margin
    
    planned_gross_profit = planned_revenue * planned_margin
    
    impact['bottom_line_impact'] = {
        'planned_gross_profit': planned_gross_profit,
        'predicted_gross_profit': predicted_gross_profit,
        'gross_profit_gap': predicted_gross_profit - planned_gross_profit,
        'estimated_net_income_impact': (predicted_gross_profit - planned_gross_profit) * 0.7  # Rough estimate
    }
    
    # Segment breakdown
    for segment in current_plan.get('by_segment', {}):
        segment_plan = current_plan['by_segment'][segment]
        segment_features = get_segment_features(segment)
        segment_predictions = predict_gaps(segment_features)
        
        impact['by_segment'][segment] = {
            'planned_revenue': segment_plan['revenue'],
            'predicted_gap': segment_plan['revenue'] * segment_predictions['revenue_gap']['predicted_gap_pct'],
            'risk_level': segment_predictions['gap_probability']['risk_level']
        }
    
    return impact

def identify_gap_concentration(impact):
    """Identify where gaps are concentrated"""
    
    concentration = {
        'by_segment': [],
        'by_product': [],
        'by_customer': []
    }
    
    # Segment concentration
    total_gap = impact['revenue_impact']['predicted_gap_dollars']
    
    for segment, data in impact['by_segment'].items():
        segment_contribution = data['predicted_gap'] / total_gap if total_gap != 0 else 0
        concentration['by_segment'].append({
            'segment': segment,
            'gap_contribution': segment_contribution,
            'gap_dollars': data['predicted_gap'],
            'risk_level': data['risk_level']
        })
    
    # Sort by contribution
    concentration['by_segment'] = sorted(
        concentration['by_segment'],
        key=lambda x: abs(x['gap_contribution']),
        reverse=True
    )
    
    return concentration
```

---

## Step 5: Alert Stakeholders

### Tiered Notifications
```python
def generate_gap_alerts(predictions, impact):
    """Generate tiered alerts based on gap predictions"""
    
    alerts = []
    
    # Revenue gap alerts
    if predictions['gap_probability']['risk_level'] == 'HIGH':
        alerts.append({
            'type': 'REVENUE_GAP_HIGH',
            'severity': 'CRITICAL',
            'title': 'High Probability Revenue Gap Detected',
            'message': f"Predicted revenue gap of {predictions['revenue_gap']['predicted_gap_pct']:.1%} "
                      f"(${impact['revenue_impact']['predicted_gap_dollars']:,.0f})",
            'probability': predictions['gap_probability']['probability'],
            'notify': ['cfo', 'ceo', 'sales_vp', 'ibp_leader'],
            'action_required': 'Immediate gap closure plan required'
        })
    
    elif predictions['gap_probability']['risk_level'] == 'MEDIUM':
        alerts.append({
            'type': 'REVENUE_GAP_MEDIUM',
            'severity': 'HIGH',
            'title': 'Potential Revenue Gap Identified',
            'message': f"Potential revenue gap of {predictions['revenue_gap']['predicted_gap_pct']:.1%} "
                      f"(${impact['revenue_impact']['predicted_gap_dollars']:,.0f})",
            'probability': predictions['gap_probability']['probability'],
            'notify': ['ibp_leader', 'finance_director', 'sales_director'],
            'action_required': 'Review and prepare mitigation options'
        })
    
    # Margin gap alerts
    if abs(predictions['margin_gap']['predicted_gap_bps']) > 50:
        alerts.append({
            'type': 'MARGIN_PRESSURE',
            'severity': 'HIGH',
            'title': 'Significant Margin Gap Predicted',
            'message': f"Predicted margin gap of {predictions['margin_gap']['predicted_gap_bps']:.0f} bps "
                      f"(${impact['margin_impact']['margin_dollar_impact']:,.0f})",
            'drivers': predictions['feature_importance'][:3],
            'notify': ['cfo', 'operations_vp', 'procurement_director'],
            'action_required': 'Margin protection actions needed'
        })
    
    # Segment-specific alerts
    for segment in impact['by_segment'].values():
        if segment['risk_level'] == 'HIGH':
            alerts.append({
                'type': 'SEGMENT_AT_RISK',
                'severity': 'MEDIUM',
                'segment': segment['segment'],
                'message': f"Segment {segment['segment']} showing high gap risk",
                'notify': [f"segment_{segment['segment']}_leader"],
                'action_required': 'Segment-specific review'
            })
    
    return alerts

def send_gap_alerts(alerts):
    """Send alerts through appropriate channels"""
    
    for alert in alerts:
        # Determine channel based on severity
        if alert['severity'] == 'CRITICAL':
            # Immediate notification + meeting invite
            send_urgent_notification(alert)
            schedule_emergency_review(alert)
        
        elif alert['severity'] == 'HIGH':
            # Email + dashboard highlight
            send_email_alert(alert)
            update_dashboard_alert(alert)
        
        else:
            # Dashboard only
            update_dashboard_alert(alert)
        
        # Log alert
        log_alert(alert)
```

---

## Step 6: Root Cause Analysis

### AI-Driven Analysis
```python
def analyze_gap_root_causes(predictions, signals, impact):
    """AI-powered root cause analysis"""
    
    # Get feature drivers
    drivers = predictions['feature_importance']
    
    # Build root cause analysis
    root_causes = []
    
    for driver in drivers:
        cause = analyze_single_driver(driver, signals)
        root_causes.append(cause)
    
    # Generate AI narrative
    prompt = f"""
    Analyze the root causes of this predicted financial gap:
    
    PREDICTED GAP:
    - Revenue gap: {predictions['revenue_gap']['predicted_gap_pct']:.1%}
    - Margin gap: {predictions['margin_gap']['predicted_gap_bps']:.0f} bps
    - Gap probability: {predictions['gap_probability']['probability']:.0%}
    
    TOP DRIVERS:
    {format_drivers(drivers)}
    
    SIGNAL CONTEXT:
    Demand signals: {summarize_signals(signals['demand_signals'])}
    Supply signals: {summarize_signals(signals['supply_signals'])}
    Market signals: {summarize_signals(signals['market_signals'])}
    
    Provide:
    1. Top 3 root causes in order of impact
    2. Underlying factors for each root cause
    3. Whether each is controllable or external
    4. Early warning signs that were missed (if any)
    5. Recommended diagnostic actions
    """
    
    analysis = call_llm(prompt)
    
    return {
        'driver_analysis': root_causes,
        'narrative_analysis': analysis,
        'controllable_factors': identify_controllable_factors(root_causes),
        'external_factors': identify_external_factors(root_causes)
    }

def analyze_single_driver(driver, signals):
    """Analyze a single gap driver"""
    
    feature_name = driver['feature']
    
    # Map feature to business context
    feature_context = {
        'forecast_declining': {
            'business_area': 'Demand',
            'description': 'Declining demand forecast trend',
            'controllable': 'Partially',
            'actions': ['Review market positioning', 'Increase sales activity', 'Analyze lost deals']
        },
        'booking_pace_ratio': {
            'business_area': 'Sales',
            'description': 'Booking pace below plan',
            'controllable': 'Yes',
            'actions': ['Accelerate pipeline conversion', 'Launch sales incentives', 'Pull forward deals']
        },
        'price_erosion': {
            'business_area': 'Pricing',
            'description': 'Price pressure in market',
            'controllable': 'Partially',
            'actions': ['Defend value proposition', 'Review competitive positioning', 'Optimize promotions']
        },
        'cost_inflation': {
            'business_area': 'Operations',
            'description': 'Rising input costs',
            'controllable': 'Partially',
            'actions': ['Negotiate supplier contracts', 'Identify cost reduction', 'Consider price increases']
        }
    }
    
    context = feature_context.get(feature_name, {
        'business_area': 'Unknown',
        'description': feature_name,
        'controllable': 'Unknown',
        'actions': []
    })
    
    return {
        'driver': feature_name,
        'importance': driver['importance'],
        'current_value': driver['current_value'],
        **context
    }
```

---

## Step 7: Recommend Actions

### Gap Closure Options
```python
def generate_gap_closure_options(predictions, impact, root_causes):
    """Generate AI-recommended gap closure actions"""
    
    options = {
        'revenue_actions': [],
        'cost_actions': [],
        'mixed_actions': [],
        'scenarios': []
    }
    
    gap_to_close = abs(impact['revenue_impact']['predicted_gap_dollars'])
    
    # Revenue actions
    revenue_actions = [
        {
            'action': 'Accelerate pipeline conversion',
            'potential_impact': estimate_pipeline_pull_forward(),
            'difficulty': 'MEDIUM',
            'timeline': '30-60 days',
            'owner': 'Sales'
        },
        {
            'action': 'Launch promotional campaign',
            'potential_impact': estimate_promo_impact(),
            'difficulty': 'LOW',
            'timeline': '14-30 days',
            'owner': 'Marketing'
        },
        {
            'action': 'Expand to new segment',
            'potential_impact': estimate_segment_expansion(),
            'difficulty': 'HIGH',
            'timeline': '60-90 days',
            'owner': 'Sales/Marketing'
        }
    ]
    
    options['revenue_actions'] = prioritize_actions(revenue_actions, gap_to_close)
    
    # Cost actions
    cost_actions = [
        {
            'action': 'Defer discretionary spend',
            'potential_impact': estimate_discretionary_savings(),
            'difficulty': 'LOW',
            'timeline': 'Immediate',
            'owner': 'Finance'
        },
        {
            'action': 'Negotiate supplier rebates',
            'potential_impact': estimate_supplier_savings(),
            'difficulty': 'MEDIUM',
            'timeline': '30-45 days',
            'owner': 'Procurement'
        },
        {
            'action': 'Reduce temporary labor',
            'potential_impact': estimate_labor_savings(),
            'difficulty': 'LOW',
            'timeline': 'Immediate',
            'owner': 'Operations'
        }
    ]
    
    options['cost_actions'] = prioritize_actions(cost_actions, gap_to_close)
    
    # Generate scenarios combining actions
    options['scenarios'] = generate_closure_scenarios(
        options['revenue_actions'],
        options['cost_actions'],
        gap_to_close
    )
    
    # AI recommendation
    options['ai_recommendation'] = get_ai_recommendation(options, root_causes)
    
    return options

def generate_closure_scenarios(revenue_actions, cost_actions, target_gap):
    """Generate combined gap closure scenarios"""
    
    scenarios = []
    
    # Scenario 1: Revenue focus
    revenue_total = sum(a['potential_impact'] for a in revenue_actions[:3])
    scenarios.append({
        'name': 'Revenue Focus',
        'actions': revenue_actions[:3],
        'total_impact': revenue_total,
        'gap_closure': revenue_total / target_gap if target_gap > 0 else 0,
        'risk': 'MEDIUM',
        'description': 'Prioritize revenue recovery actions'
    })
    
    # Scenario 2: Cost focus
    cost_total = sum(a['potential_impact'] for a in cost_actions[:3])
    scenarios.append({
        'name': 'Cost Focus',
        'actions': cost_actions[:3],
        'total_impact': cost_total,
        'gap_closure': cost_total / target_gap if target_gap > 0 else 0,
        'risk': 'LOW',
        'description': 'Prioritize cost control actions'
    })
    
    # Scenario 3: Balanced
    balanced_actions = revenue_actions[:2] + cost_actions[:2]
    balanced_total = sum(a['potential_impact'] for a in balanced_actions)
    scenarios.append({
        'name': 'Balanced Approach',
        'actions': balanced_actions,
        'total_impact': balanced_total,
        'gap_closure': balanced_total / target_gap if target_gap > 0 else 0,
        'risk': 'LOW-MEDIUM',
        'description': 'Balanced revenue and cost actions'
    })
    
    return scenarios

def get_ai_recommendation(options, root_causes):
    """Generate AI recommendation"""
    
    prompt = f"""
    Recommend the best gap closure strategy:
    
    GAP TO CLOSE: ${options.get('target_gap', 0):,.0f}
    
    ROOT CAUSES:
    {format_root_causes(root_causes['controllable_factors'])}
    
    SCENARIOS:
    {format_scenarios(options['scenarios'])}
    
    Recommend:
    1. Best scenario to pursue and why
    2. Sequence of actions for first 30 days
    3. Key success metrics to track
    4. Risk mitigation for chosen approach
    5. Escalation triggers if actions don't work
    """
    
    return call_llm(prompt)
```

---

## Step 8: Track Outcomes

### Learn and Improve
```python
def track_gap_prediction_accuracy(prediction_id):
    """Track actual vs predicted gaps"""
    
    prediction = get_prediction(prediction_id)
    actual = get_actual_results(prediction['period'])
    
    accuracy = {
        'prediction_id': prediction_id,
        'period': prediction['period'],
        'predicted_at': prediction['predicted_at'],
        'metrics': {}
    }
    
    # Revenue gap accuracy
    predicted_rev_gap = prediction['revenue_gap']['predicted_gap_pct']
    actual_rev_gap = (actual['revenue'] - prediction['planned_revenue']) / prediction['planned_revenue']
    
    accuracy['metrics']['revenue_gap'] = {
        'predicted': predicted_rev_gap,
        'actual': actual_rev_gap,
        'error': abs(predicted_rev_gap - actual_rev_gap),
        'direction_correct': (predicted_rev_gap < 0) == (actual_rev_gap < 0)
    }
    
    # Margin gap accuracy
    predicted_margin_gap = prediction['margin_gap']['predicted_gap_bps']
    actual_margin_gap = (actual['margin'] - prediction['planned_margin']) * 10000
    
    accuracy['metrics']['margin_gap'] = {
        'predicted': predicted_margin_gap,
        'actual': actual_margin_gap,
        'error': abs(predicted_margin_gap - actual_margin_gap),
        'direction_correct': (predicted_margin_gap < 0) == (actual_margin_gap < 0)
    }
    
    # Probability accuracy (was prediction correct?)
    had_significant_gap = abs(actual_rev_gap) > 0.05
    predicted_significant = prediction['gap_probability']['probability'] > 0.5
    
    accuracy['metrics']['probability'] = {
        'predicted_probability': prediction['gap_probability']['probability'],
        'had_significant_gap': had_significant_gap,
        'correct_prediction': predicted_significant == had_significant_gap
    }
    
    # Store for model improvement
    store_accuracy_record(accuracy)
    
    # Trigger retraining if needed
    check_model_performance()
    
    return accuracy

def check_model_performance():
    """Check if model needs retraining"""
    
    recent_accuracy = get_recent_accuracy_records(n=20)
    
    # Calculate metrics
    direction_accuracy = np.mean([r['metrics']['revenue_gap']['direction_correct'] for r in recent_accuracy])
    avg_error = np.mean([r['metrics']['revenue_gap']['error'] for r in recent_accuracy])
    probability_accuracy = np.mean([r['metrics']['probability']['correct_prediction'] for r in recent_accuracy])
    
    if direction_accuracy < 0.7 or probability_accuracy < 0.7:
        # Model performance degrading - retrain
        train_gap_prediction_models()
        
        notify_model_retrained({
            'reason': 'Performance degradation',
            'direction_accuracy': direction_accuracy,
            'probability_accuracy': probability_accuracy
        })
```

---

## Gap Prediction Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  GAP PREDICTION DASHBOARD                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CURRENT QUARTER OUTLOOK                                         │
│  ─────────────────────────────────────────────────────────────  │
│  Gap Probability: 68% (HIGH)    ████████████░░░░░░░             │
│                                                                  │
│  PREDICTED GAPS:                                                 │
│  Revenue Gap:    -4.2% ($1.9M)  ████████░░░░░░░░░░░░             │
│  Margin Gap:     -35 bps        ███████░░░░░░░░░░░░░             │
│  Net Income:     -$1.2M                                          │
│                                                                  │
│  LEADING INDICATORS SIGNALING RISK:                              │
│  ─────────────────────────────────────────────────────────────  │
│  1. Booking pace 15% below plan     ████████████░░ ⚠ HIGH       │
│  2. Pipeline coverage 1.8x (need 3x) ████████░░░░░ ⚠ HIGH       │
│  3. Price pressure detected          ██████░░░░░░░ ⚠ MEDIUM    │
│  4. Supplier risk elevated           █████░░░░░░░░ ⚠ MEDIUM    │
│                                                                  │
│  ROOT CAUSES:                                                    │
│  ─────────────────────────────────────────────────────────────  │
│  • Large deal slippage (Acme Corp moved to Q4)                  │
│  • Competitive pressure in Enterprise segment                   │
│  • Raw material cost increase (+8%)                              │
│                                                                  │
│  RECOMMENDED GAP CLOSURE:                                        │
│  ─────────────────────────────────────────────────────────────  │
│  Balanced Approach: $1.5M potential (79% of gap)                │
│  1. Accelerate 3 pipeline deals    +$600K                       │
│  2. Launch flash promotion         +$400K                       │
│  3. Defer discretionary spend      +$300K                       │
│  4. Negotiate supplier rebate      +$200K                       │
│                                                                  │
│  MODEL ACCURACY (Last 12 months): 82%                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*ML-powered gap prediction for proactive financial management.*
