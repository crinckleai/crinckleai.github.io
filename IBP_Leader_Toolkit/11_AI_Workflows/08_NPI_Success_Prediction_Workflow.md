# NPI Success Prediction Workflow
## ML-Powered New Product Introduction Forecasting

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    NPI SUCCESS PREDICTION WORKFLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. GATHER│───▶│ 2. FEAT  │───▶│ 3. PREDICT│───▶│ 4. LAUNCH│            │
│  │ NPI DATA │    │ ENGINEER │    │ SUCCESS  │    │ CURVE    │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Historical      ML Features     Success         Ramp-up                 │
│   NPI Data        Generation      Probability     Forecasting             │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. CANNIB│───▶│ 6. RISK  │───▶│ 7. RECOM │───▶│ 8. TRACK │            │
│  │ ALIZATION│    │ ASSESS   │    │ MEND     │    │ ACTUAL   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Cross-Product   Launch Risk     AI Go/No-Go     Post-Launch             │
│   Impact          Scoring         Insights        Learning                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Gather NPI Data

### Data Sources
| Source | Data | Purpose |
|--------|------|---------|
| PLM System | Product specs, features | Product attributes |
| Historical NPIs | Past launches, outcomes | Training data |
| Market Research | Customer feedback, demand | Market sizing |
| Competitive Intel | Competitor products | Positioning |
| Finance | Investment, targets | Business case |

### Data Collection
```python
def gather_npi_data(npi_id):
    npi = {}
    
    # Product attributes
    npi['product'] = {
        'category': get_product_category(npi_id),
        'subcategory': get_subcategory(npi_id),
        'price_point': get_target_price(npi_id),
        'features': get_feature_list(npi_id),
        'innovation_level': classify_innovation(npi_id),  # Incremental/Major/Breakthrough
        'complexity_score': calculate_complexity(npi_id)
    }
    
    # Market data
    npi['market'] = {
        'market_size': get_tam(npi_id),
        'market_growth': get_market_cagr(npi_id),
        'competition_intensity': get_hhi_index(npi_id),
        'customer_demand_score': get_voc_score(npi_id),
        'channel_readiness': assess_channel_readiness(npi_id)
    }
    
    # Internal readiness
    npi['readiness'] = {
        'development_status': get_dev_status(npi_id),
        'manufacturing_readiness': get_mrl(npi_id),
        'supply_chain_readiness': assess_supply_readiness(npi_id),
        'sales_training_complete': check_sales_training(npi_id),
        'marketing_investment': get_marketing_budget(npi_id)
    }
    
    # Historical analogues
    npi['analogues'] = find_similar_launches(npi_id, n=10)
    
    return npi
```

---

## Step 2: Feature Engineering

### ML Features
```python
def engineer_npi_features(npi_data):
    features = {}
    
    # Product features
    features['is_line_extension'] = npi_data['product']['innovation_level'] == 'Incremental'
    features['is_breakthrough'] = npi_data['product']['innovation_level'] == 'Breakthrough'
    features['feature_count'] = len(npi_data['product']['features'])
    features['price_index'] = npi_data['product']['price_point'] / get_category_avg_price()
    features['complexity_score'] = npi_data['product']['complexity_score']
    
    # Market features
    features['market_size_log'] = np.log(npi_data['market']['market_size'])
    features['market_growth'] = npi_data['market']['market_growth']
    features['competition_score'] = 1 - npi_data['market']['competition_intensity']
    features['demand_score'] = npi_data['market']['customer_demand_score']
    features['channel_ready'] = npi_data['market']['channel_readiness']
    
    # Readiness features
    features['mrl_score'] = npi_data['readiness']['manufacturing_readiness']
    features['supply_ready'] = npi_data['readiness']['supply_chain_readiness']
    features['sales_trained'] = 1 if npi_data['readiness']['sales_training_complete'] else 0
    features['marketing_intensity'] = npi_data['readiness']['marketing_investment'] / get_category_avg_marketing()
    
    # Analogue features
    analogue_success = [a['success_score'] for a in npi_data['analogues']]
    features['analogue_avg_success'] = np.mean(analogue_success)
    features['analogue_success_rate'] = sum(1 for s in analogue_success if s > 0.7) / len(analogue_success)
    
    # Timing features
    features['launch_quarter'] = get_launch_quarter(npi_data)
    features['months_to_launch'] = calculate_months_to_launch(npi_data)
    
    return features
```

---

## Step 3: Predict Success (ML Model)

### Success Prediction Model
```python
from sklearn.ensemble import GradientBoostingClassifier, RandomForestRegressor
from sklearn.calibration import CalibratedClassifierCV

def predict_npi_success(features):
    # Load trained model
    success_model = load_model('npi_success_classifier')
    
    # Predict success probability
    X = prepare_features(features)
    success_prob = success_model.predict_proba(X)[0, 1]
    
    # Confidence interval
    ci_lower, ci_upper = calculate_confidence_interval(success_model, X)
    
    # Feature importance for this prediction
    important_features = get_shap_values(success_model, X)
    
    return {
        'success_probability': success_prob,
        'confidence_interval': (ci_lower, ci_upper),
        'success_tier': classify_success_tier(success_prob),
        'key_drivers': important_features[:5],
        'key_risks': important_features[-5:]
    }

def classify_success_tier(prob):
    if prob >= 0.8:
        return 'HIGH'
    elif prob >= 0.6:
        return 'MEDIUM'
    elif prob >= 0.4:
        return 'LOW'
    else:
        return 'AT_RISK'
```

### Model Training
```python
def train_npi_model():
    # Get historical NPI data
    historical = get_historical_npis(min_age_months=24)
    
    # Calculate actual success
    for npi in historical:
        npi['actual_success'] = calculate_success_score(npi)
        npi['success_binary'] = npi['actual_success'] >= 0.7
    
    # Prepare training data
    X = pd.DataFrame([engineer_npi_features(npi) for npi in historical])
    y = pd.Series([npi['success_binary'] for npi in historical])
    
    # Train classifier
    model = GradientBoostingClassifier(
        n_estimators=200,
        max_depth=5,
        learning_rate=0.1
    )
    
    # Calibrate probabilities
    calibrated = CalibratedClassifierCV(model, cv=5)
    calibrated.fit(X, y)
    
    # Save model
    save_model(calibrated, 'npi_success_classifier')
    
    return calibrated
```

---

## Step 4: Generate Launch Curve

### Demand Ramp-up Forecast
```python
def predict_launch_curve(npi_data, success_prediction, horizon_months=24):
    # Get analogue curves
    analogue_curves = get_analogue_curves(npi_data['analogues'])
    
    # Weight by similarity
    similarity_weights = calculate_similarity_weights(npi_data, npi_data['analogues'])
    
    # Weighted average curve
    base_curve = np.average(analogue_curves, weights=similarity_weights, axis=0)
    
    # Adjust for success probability
    adjusted_curve = base_curve * success_prediction['success_probability']
    
    # Adjust for market size
    market_factor = npi_data['market']['market_size'] / get_analogue_avg_market()
    scaled_curve = adjusted_curve * market_factor
    
    # Generate scenarios
    scenarios = {
        'optimistic': scaled_curve * 1.3,
        'base': scaled_curve,
        'pessimistic': scaled_curve * 0.7,
        'failure': scaled_curve * 0.3
    }
    
    # Probability weight scenarios
    scenario_probs = calculate_scenario_probabilities(success_prediction)
    
    return {
        'monthly_forecast': scaled_curve,
        'scenarios': scenarios,
        'scenario_probabilities': scenario_probs,
        'time_to_peak': find_peak_month(scaled_curve),
        'peak_volume': max(scaled_curve),
        'year1_total': sum(scaled_curve[:12]),
        'year2_total': sum(scaled_curve[12:24])
    }
```

---

## Step 5: Cannibalization Analysis

### Cross-Product Impact
```python
def analyze_cannibalization(npi_data, launch_curve):
    # Identify at-risk products
    at_risk = identify_cannibalization_candidates(npi_data)
    
    cannibalization = {}
    
    for product in at_risk:
        # Calculate similarity
        similarity = calculate_product_similarity(npi_data, product)
        
        # Estimate impact
        if similarity > 0.8:
            impact_pct = 0.3  # High cannibalization
        elif similarity > 0.5:
            impact_pct = 0.15  # Medium
        else:
            impact_pct = 0.05  # Low
        
        # Calculate volume impact
        product_baseline = get_product_forecast(product['id'])
        impact_volume = product_baseline * impact_pct * (launch_curve['monthly_forecast'] / launch_curve['peak_volume'])
        
        cannibalization[product['id']] = {
            'product_name': product['name'],
            'similarity_score': similarity,
            'impact_percentage': impact_pct,
            'monthly_impact': impact_volume,
            'annual_impact': sum(impact_volume[:12]),
            'revenue_impact': sum(impact_volume[:12]) * product['price']
        }
    
    # Net new demand
    total_cannibalization = sum(c['annual_impact'] for c in cannibalization.values())
    net_new = launch_curve['year1_total'] - total_cannibalization
    
    return {
        'cannibalized_products': cannibalization,
        'total_cannibalization': total_cannibalization,
        'cannibalization_rate': total_cannibalization / launch_curve['year1_total'],
        'net_new_demand': net_new
    }
```

---

## Step 6: Risk Assessment

### Launch Risk Scoring
```python
def assess_launch_risks(npi_data, success_prediction, cannibalization):
    risks = []
    
    # Success probability risk
    if success_prediction['success_probability'] < 0.5:
        risks.append({
            'category': 'Market',
            'risk': 'Low success probability',
            'probability': 1 - success_prediction['success_probability'],
            'impact': 'HIGH',
            'mitigation': 'Consider scope reduction or delay'
        })
    
    # Cannibalization risk
    if cannibalization['cannibalization_rate'] > 0.4:
        risks.append({
            'category': 'Portfolio',
            'risk': 'High cannibalization',
            'probability': 0.8,
            'impact': 'MEDIUM',
            'mitigation': 'Differentiate positioning or phase old product'
        })
    
    # Readiness risks
    if npi_data['readiness']['manufacturing_readiness'] < 0.7:
        risks.append({
            'category': 'Operations',
            'risk': 'Manufacturing not ready',
            'probability': 0.6,
            'impact': 'HIGH',
            'mitigation': 'Accelerate MRL or delay launch'
        })
    
    if npi_data['readiness']['supply_chain_readiness'] < 0.7:
        risks.append({
            'category': 'Supply',
            'risk': 'Supply chain gaps',
            'probability': 0.5,
            'impact': 'HIGH',
            'mitigation': 'Qualify backup suppliers'
        })
    
    # Calculate overall risk score
    risk_score = calculate_weighted_risk(risks)
    
    return {
        'risks': risks,
        'risk_score': risk_score,
        'risk_level': 'HIGH' if risk_score > 0.6 else 'MEDIUM' if risk_score > 0.3 else 'LOW',
        'top_risks': sorted(risks, key=lambda x: x['probability'] * (1 if x['impact'] == 'HIGH' else 0.5), reverse=True)[:3]
    }
```

---

## Step 7: AI Recommendations

### Go/No-Go Recommendation
```python
def generate_npi_recommendation(npi_data, success_pred, launch_curve, cannib, risks):
    prompt = f"""
    Provide NPI launch recommendation:
    
    PRODUCT: {npi_data['product']['name']}
    CATEGORY: {npi_data['product']['category']}
    INNOVATION: {npi_data['product']['innovation_level']}
    
    SUCCESS PREDICTION:
    - Probability: {success_pred['success_probability']:.1%}
    - Tier: {success_pred['success_tier']}
    - Key Drivers: {success_pred['key_drivers']}
    
    FORECAST:
    - Year 1 Volume: {launch_curve['year1_total']:,.0f}
    - Peak Month: {launch_curve['time_to_peak']}
    - Net New (after cannibalization): {cannib['net_new_demand']:,.0f}
    
    RISKS:
    - Overall Risk Score: {risks['risk_score']:.2f}
    - Top Risks: {[r['risk'] for r in risks['top_risks']]}
    
    READINESS:
    - Manufacturing: {npi_data['readiness']['manufacturing_readiness']:.0%}
    - Supply Chain: {npi_data['readiness']['supply_chain_readiness']:.0%}
    - Sales Training: {'Complete' if npi_data['readiness']['sales_training_complete'] else 'Incomplete'}
    
    Provide:
    1. GO / CONDITIONAL GO / NO-GO recommendation
    2. Confidence level
    3. Key conditions (if conditional)
    4. Suggested launch timing
    5. Critical success factors
    """
    
    recommendation = call_llm(prompt)
    return parse_npi_recommendation(recommendation)
```

---

## Step 8: Track Actuals

### Post-Launch Learning
```python
def track_npi_performance(npi_id):
    # Get actuals
    actuals = get_actual_sales(npi_id)
    forecast = get_launch_forecast(npi_id)
    
    # Calculate accuracy
    accuracy = {
        'month': [],
        'forecast': [],
        'actual': [],
        'variance': [],
        'cumulative_forecast': [],
        'cumulative_actual': []
    }
    
    for month in range(len(actuals)):
        accuracy['month'].append(month + 1)
        accuracy['forecast'].append(forecast[month])
        accuracy['actual'].append(actuals[month])
        accuracy['variance'].append((actuals[month] - forecast[month]) / forecast[month])
        accuracy['cumulative_forecast'].append(sum(forecast[:month+1]))
        accuracy['cumulative_actual'].append(sum(actuals[:month+1]))
    
    # Update model with outcome
    update_training_data(npi_id, actuals, forecast)
    
    # Trigger retrain if needed
    if should_retrain():
        train_npi_model()
    
    return accuracy
```

---

## NPI Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  NPI SUCCESS PREDICTION DASHBOARD                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ACTIVE NPIs: 12                                                 │
│  ─────────────────────────────────────────────────────────────  │
│  HIGH CONFIDENCE (>80%):     3 products                         │
│  MEDIUM CONFIDENCE (60-80%): 5 products                         │
│  LOW CONFIDENCE (<60%):      4 products                         │
│                                                                  │
│  NEXT 90 DAYS LAUNCHES:                                          │
│  ─────────────────────────────────────────────────────────────  │
│  1. Product Alpha   | Success: 85% | Y1: $12M | GO              │
│  2. Product Beta    | Success: 62% | Y1: $8M  | CONDITIONAL     │
│  3. Product Gamma   | Success: 45% | Y1: $5M  | REVIEW          │
│                                                                  │
│  MODEL PERFORMANCE (Last 12 Months):                             │
│  ─────────────────────────────────────────────────────────────  │
│  Prediction Accuracy: 78%                                        │
│  Forecast Accuracy (Y1): 72%                                     │
│  False Positive Rate: 12%                                        │
│  False Negative Rate: 8%                                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*ML-powered NPI success prediction for data-driven launch decisions.*
