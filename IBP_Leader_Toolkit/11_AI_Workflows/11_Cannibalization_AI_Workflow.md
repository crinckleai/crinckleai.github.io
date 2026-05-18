# Cannibalization AI Workflow
## ML-Powered Cross-Product Impact Analysis

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CANNIBALIZATION AI WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. IDENT │───▶│ 2. CALC  │───▶│ 3. MODEL │───▶│ 4. PREDICT│            │
│  │ PRODUCTS │    │ SIMILAR  │    │ ELASTICITY│   │ IMPACT   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Product          Attribute &      Cross-Price     Volume                │
│   Pairs            Customer         Elasticity      Shift                 │
│                    Overlap          Matrix          Forecast              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. NET   │───▶│ 6. OPTIM │───▶│ 7. MONITOR│───▶│ 8. LEARN │            │
│  │ IMPACT   │    │ PORTFOLIO│    │ ACTUAL   │    │ REFINE   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   True New         Pricing &        Track Real      Improve               │
│   Demand           Position         Substitution    Models                │
│   Calculation      Decisions        Patterns        Continuously          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Identify Products

### Product Pair Detection
```python
def identify_cannibalization_candidates(product_id=None, scope='all'):
    """Identify products that may cannibalize each other"""
    
    if product_id:
        # For specific product (e.g., NPI)
        products = get_product_details(product_id)
        candidates = find_similar_products(product_id)
    else:
        # Full portfolio scan
        products = get_all_active_products()
        candidates = generate_all_pairs(products)
    
    # Filter by basic criteria
    candidate_pairs = []
    for pair in candidates:
        if meets_cannibalization_criteria(pair):
            candidate_pairs.append({
                'product_a': pair[0],
                'product_b': pair[1],
                'category_match': same_category(pair),
                'price_proximity': price_within_range(pair, threshold=0.3),
                'customer_overlap': calculate_customer_overlap(pair),
                'use_case_similarity': calculate_use_case_similarity(pair)
            })
    
    return sorted(candidate_pairs, key=lambda x: x['customer_overlap'], reverse=True)

def meets_cannibalization_criteria(pair):
    """Basic filters for potential cannibalization"""
    return (
        same_category(pair) or same_subcategory(pair) and
        price_within_range(pair, threshold=0.5) and
        not complementary_products(pair)
    )
```

---

## Step 2: Calculate Similarity

### Product Similarity Scoring
```python
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

def calculate_product_similarity(product_a, product_b):
    """Multi-dimensional similarity calculation"""
    
    similarities = {}
    
    # Attribute similarity
    attrs_a = get_product_attributes_vector(product_a)
    attrs_b = get_product_attributes_vector(product_b)
    similarities['attribute'] = cosine_similarity([attrs_a], [attrs_b])[0][0]
    
    # Price similarity (inverse of distance)
    price_a = get_price(product_a)
    price_b = get_price(product_b)
    similarities['price'] = 1 - abs(price_a - price_b) / max(price_a, price_b)
    
    # Customer overlap
    customers_a = set(get_customers_purchased(product_a))
    customers_b = set(get_customers_purchased(product_b))
    if customers_a or customers_b:
        similarities['customer'] = len(customers_a & customers_b) / len(customers_a | customers_b)
    else:
        similarities['customer'] = 0
    
    # Channel overlap
    channels_a = set(get_sales_channels(product_a))
    channels_b = set(get_sales_channels(product_b))
    similarities['channel'] = len(channels_a & channels_b) / len(channels_a | channels_b)
    
    # Use case similarity (NLP-based)
    desc_a = get_product_description(product_a)
    desc_b = get_product_description(product_b)
    similarities['use_case'] = calculate_text_similarity(desc_a, desc_b)
    
    # Weighted composite
    weights = {
        'attribute': 0.25,
        'price': 0.20,
        'customer': 0.30,
        'channel': 0.10,
        'use_case': 0.15
    }
    
    composite = sum(similarities[k] * weights[k] for k in weights)
    
    return {
        'composite_similarity': composite,
        'component_scores': similarities,
        'cannibalization_risk': classify_risk(composite)
    }

def classify_risk(similarity_score):
    if similarity_score >= 0.8:
        return 'HIGH'
    elif similarity_score >= 0.5:
        return 'MEDIUM'
    elif similarity_score >= 0.3:
        return 'LOW'
    else:
        return 'MINIMAL'
```

---

## Step 3: Model Elasticity

### Cross-Price Elasticity Estimation
```python
def estimate_cross_price_elasticity(product_a, product_b):
    """Estimate how demand for A changes when price of B changes"""
    
    # Get historical data
    history = get_price_volume_history(
        products=[product_a, product_b],
        periods=36  # 3 years monthly
    )
    
    # Identify price change events
    price_events = identify_price_changes(history, product_b, threshold=0.05)
    
    if len(price_events) < 3:
        # Insufficient data - use category average
        return get_category_cross_elasticity(
            get_category(product_a),
            get_category(product_b)
        )
    
    # Calculate elasticity from events
    elasticities = []
    for event in price_events:
        # % change in quantity A / % change in price B
        pct_qty_change_a = calculate_qty_change(history, product_a, event)
        pct_price_change_b = event['price_change_pct']
        
        if pct_price_change_b != 0:
            elasticity = pct_qty_change_a / pct_price_change_b
            elasticities.append(elasticity)
    
    return {
        'cross_elasticity': np.mean(elasticities),
        'elasticity_std': np.std(elasticities),
        'confidence': 'High' if len(price_events) >= 10 else 'Medium',
        'n_observations': len(price_events)
    }

def build_elasticity_matrix(products):
    """Build full cross-elasticity matrix for product set"""
    n = len(products)
    matrix = np.zeros((n, n))
    confidence = np.zeros((n, n))
    
    for i, prod_a in enumerate(products):
        for j, prod_b in enumerate(products):
            if i != j:
                result = estimate_cross_price_elasticity(prod_a, prod_b)
                matrix[i, j] = result['cross_elasticity']
                confidence[i, j] = 1 if result['confidence'] == 'High' else 0.5
    
    return {
        'elasticity_matrix': matrix,
        'confidence_matrix': confidence,
        'product_index': {p['id']: i for i, p in enumerate(products)}
    }
```

---

## Step 4: Predict Impact

### Cannibalization Forecast
```python
def predict_cannibalization_impact(new_product, existing_products, forecast_horizon=12):
    """Predict volume cannibalization from new product"""
    
    # Get new product forecast
    new_product_forecast = get_product_forecast(new_product['id'], horizon=forecast_horizon)
    
    # Calculate impact on each existing product
    impacts = []
    
    for existing in existing_products:
        # Get similarity
        similarity = calculate_product_similarity(new_product, existing)
        
        # Get elasticity (or estimate)
        elasticity = estimate_cross_price_elasticity(existing, new_product)
        
        # Calculate substitution rate based on similarity
        substitution_rate = estimate_substitution_rate(similarity, elasticity)
        
        # Get existing product baseline
        existing_baseline = get_product_forecast(existing['id'], horizon=forecast_horizon)
        
        # Calculate monthly impact
        monthly_impact = []
        for month in range(forecast_horizon):
            # Impact scales with new product ramp-up
            ramp_factor = new_product_forecast[month] / max(new_product_forecast) if max(new_product_forecast) > 0 else 0
            
            impact = existing_baseline[month] * substitution_rate * ramp_factor
            monthly_impact.append(impact)
        
        impacts.append({
            'product_id': existing['id'],
            'product_name': existing['name'],
            'similarity_score': similarity['composite_similarity'],
            'substitution_rate': substitution_rate,
            'monthly_impact': monthly_impact,
            'total_impact': sum(monthly_impact),
            'impact_percentage': sum(monthly_impact) / sum(existing_baseline) * 100
        })
    
    return sorted(impacts, key=lambda x: x['total_impact'], reverse=True)

def estimate_substitution_rate(similarity, elasticity):
    """Estimate % of new product sales that come from existing product"""
    
    base_rate = similarity['composite_similarity'] * 0.5  # Max 50% from any single product
    
    # Adjust for elasticity
    if elasticity['cross_elasticity'] > 0:
        # Positive cross-elasticity = substitutes
        base_rate *= (1 + min(elasticity['cross_elasticity'], 1))
    
    # Cap at reasonable maximum
    return min(base_rate, 0.40)
```

---

## Step 5: Calculate Net Impact

### True New Demand
```python
def calculate_net_new_demand(new_product, cannibalization_impacts):
    """Calculate truly incremental demand"""
    
    new_product_forecast = get_product_forecast(new_product['id'])
    
    # Total cannibalization
    total_cannibalization = np.zeros(len(new_product_forecast))
    for impact in cannibalization_impacts:
        total_cannibalization += np.array(impact['monthly_impact'])
    
    # Net new demand
    net_new = np.array(new_product_forecast) - total_cannibalization
    
    # Financial impact
    new_product_price = get_price(new_product['id'])
    cannibalized_revenue = sum(
        impact['total_impact'] * get_price(impact['product_id'])
        for impact in cannibalization_impacts
    )
    new_revenue = sum(new_product_forecast) * new_product_price
    net_revenue_impact = new_revenue - cannibalized_revenue
    
    # Margin impact
    new_margin = get_margin(new_product['id'])
    cannibalized_margin = sum(
        impact['total_impact'] * get_price(impact['product_id']) * get_margin(impact['product_id'])
        for impact in cannibalization_impacts
    )
    new_margin_dollars = sum(new_product_forecast) * new_product_price * new_margin
    net_margin_impact = new_margin_dollars - cannibalized_margin
    
    return {
        'gross_new_volume': sum(new_product_forecast),
        'total_cannibalization': sum(total_cannibalization),
        'net_new_volume': sum(net_new),
        'cannibalization_rate': sum(total_cannibalization) / sum(new_product_forecast) * 100,
        'net_new_percentage': sum(net_new) / sum(new_product_forecast) * 100,
        'monthly_net_new': net_new.tolist(),
        'financial_impact': {
            'gross_revenue': new_revenue,
            'cannibalized_revenue': cannibalized_revenue,
            'net_revenue': net_revenue_impact,
            'gross_margin': new_margin_dollars,
            'cannibalized_margin': cannibalized_margin,
            'net_margin': net_margin_impact
        }
    }
```

---

## Step 6: Optimize Portfolio

### AI Recommendations
```python
def generate_portfolio_recommendations(new_product, cannibalization_analysis, net_impact):
    """Generate AI recommendations for portfolio optimization"""
    
    prompt = f"""
    Analyze this product launch cannibalization scenario:
    
    NEW PRODUCT: {new_product['name']}
    Category: {new_product['category']}
    Price: ${new_product['price']}
    
    CANNIBALIZATION SUMMARY:
    - Gross new volume: {net_impact['gross_new_volume']:,.0f}
    - Total cannibalization: {net_impact['total_cannibalization']:,.0f}
    - Net new volume: {net_impact['net_new_volume']:,.0f}
    - Cannibalization rate: {net_impact['cannibalization_rate']:.1f}%
    
    TOP CANNIBALIZED PRODUCTS:
    {format_top_impacts(cannibalization_analysis[:5])}
    
    FINANCIAL IMPACT:
    - Gross revenue: ${net_impact['financial_impact']['gross_revenue']:,.0f}
    - Cannibalized revenue: ${net_impact['financial_impact']['cannibalized_revenue']:,.0f}
    - Net revenue: ${net_impact['financial_impact']['net_revenue']:,.0f}
    - Net margin: ${net_impact['financial_impact']['net_margin']:,.0f}
    
    Provide recommendations:
    1. GO/NO-GO recommendation with rationale
    2. Pricing strategy to minimize cannibalization
    3. Positioning strategy to differentiate
    4. Products to consider for sunset
    5. Launch timing recommendation
    """
    
    recommendations = call_llm(prompt)
    
    return {
        'llm_recommendations': recommendations,
        'sunset_candidates': identify_sunset_candidates(cannibalization_analysis),
        'pricing_suggestions': suggest_pricing_adjustments(new_product, cannibalization_analysis),
        'positioning_gaps': identify_positioning_opportunities(new_product, cannibalization_analysis)
    }

def identify_sunset_candidates(cannibalization_analysis):
    """Identify products that should be considered for sunset"""
    candidates = []
    
    for impact in cannibalization_analysis:
        product = get_product_details(impact['product_id'])
        
        if (impact['impact_percentage'] > 30 and
            product['lifecycle_stage'] in ['Mature', 'Decline'] and
            product['gross_margin'] < get_new_product_margin()):
            
            candidates.append({
                'product_id': impact['product_id'],
                'product_name': impact['product_name'],
                'cannibalization_impact': impact['impact_percentage'],
                'current_margin': product['gross_margin'],
                'lifecycle_stage': product['lifecycle_stage'],
                'recommendation': 'Consider sunset within 6-12 months'
            })
    
    return candidates
```

---

## Step 7: Monitor Actual

### Real Substitution Tracking
```python
def monitor_actual_cannibalization(new_product_id, predicted_impacts, months_since_launch):
    """Track actual vs predicted cannibalization"""
    
    tracking = {
        'new_product': {},
        'cannibalized_products': [],
        'accuracy_metrics': {}
    }
    
    # New product actuals
    new_actuals = get_actual_sales(new_product_id, months=months_since_launch)
    new_forecast = get_original_forecast(new_product_id, months=months_since_launch)
    
    tracking['new_product'] = {
        'actual': sum(new_actuals),
        'forecast': sum(new_forecast),
        'variance': (sum(new_actuals) - sum(new_forecast)) / sum(new_forecast) * 100
    }
    
    # Track each predicted cannibalized product
    for predicted in predicted_impacts:
        product_id = predicted['product_id']
        
        # Get pre-launch baseline
        pre_launch_baseline = get_pre_launch_trend(product_id)
        
        # Get actual post-launch
        post_launch_actual = get_actual_sales(product_id, months=months_since_launch)
        
        # Calculate actual cannibalization
        expected_without_launch = project_baseline(pre_launch_baseline, months_since_launch)
        actual_drop = sum(expected_without_launch) - sum(post_launch_actual)
        
        tracking['cannibalized_products'].append({
            'product_id': product_id,
            'product_name': predicted['product_name'],
            'predicted_impact': sum(predicted['monthly_impact'][:months_since_launch]),
            'actual_impact': actual_drop,
            'accuracy': 1 - abs(actual_drop - sum(predicted['monthly_impact'][:months_since_launch])) / sum(predicted['monthly_impact'][:months_since_launch]) if sum(predicted['monthly_impact'][:months_since_launch]) > 0 else 0
        })
    
    # Overall accuracy
    total_predicted = sum(p['predicted_impact'] for p in tracking['cannibalized_products'])
    total_actual = sum(p['actual_impact'] for p in tracking['cannibalized_products'])
    
    tracking['accuracy_metrics'] = {
        'total_predicted_cannibalization': total_predicted,
        'total_actual_cannibalization': total_actual,
        'overall_accuracy': 1 - abs(total_actual - total_predicted) / total_predicted if total_predicted > 0 else 0,
        'wmape': calculate_wmape(
            [p['actual_impact'] for p in tracking['cannibalized_products']],
            [p['predicted_impact'] for p in tracking['cannibalized_products']]
        )
    }
    
    return tracking
```

---

## Step 8: Learn & Refine

### Model Improvement
```python
def update_cannibalization_models(tracking_data, product_pair):
    """Use actual data to improve prediction models"""
    
    # Store actual outcome
    store_cannibalization_outcome({
        'product_a': product_pair[0],
        'product_b': product_pair[1],
        'predicted_rate': tracking_data['predicted_impact'],
        'actual_rate': tracking_data['actual_impact'],
        'similarity_score': get_stored_similarity(product_pair),
        'features': get_product_pair_features(product_pair)
    })
    
    # Check if model retraining is needed
    recent_accuracy = get_recent_prediction_accuracy(n=20)
    
    if recent_accuracy < 0.7:
        # Trigger model retraining
        retrain_cannibalization_model()
    
    # Update category-level benchmarks
    update_category_cannibalization_rates(product_pair, tracking_data)
    
    return {
        'model_updated': True,
        'new_accuracy': recent_accuracy,
        'training_samples': get_training_sample_count()
    }

def retrain_cannibalization_model():
    """Retrain ML model with latest data"""
    
    # Get all historical outcomes
    outcomes = get_all_cannibalization_outcomes()
    
    # Prepare features
    X = pd.DataFrame([o['features'] for o in outcomes])
    y = pd.Series([o['actual_rate'] for o in outcomes])
    
    # Train model
    from sklearn.ensemble import GradientBoostingRegressor
    
    model = GradientBoostingRegressor(
        n_estimators=100,
        max_depth=5,
        learning_rate=0.1
    )
    
    model.fit(X, y)
    
    # Save model
    save_model(model, 'cannibalization_predictor')
    
    return model
```

---

## Cannibalization Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  CANNIBALIZATION ANALYSIS DASHBOARD                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  NEW PRODUCT: Widget Pro 2.0                                     │
│  ─────────────────────────────────────────────────────────────  │
│  Gross Forecast:     50,000 units │ $2,500,000 revenue          │
│  Cannibalization:    18,500 units │ $850,000 revenue            │
│  Net New Demand:     31,500 units │ $1,650,000 revenue          │
│  Cannibalization %:  37%                                         │
│                                                                  │
│  TOP CANNIBALIZED PRODUCTS:                                      │
│  ─────────────────────────────────────────────────────────────  │
│  1. Widget Pro 1.0      │ 12,000 units │ 65% similarity │ HIGH  │
│  2. Widget Standard     │  4,500 units │ 48% similarity │ MED   │
│  3. Widget Basic        │  2,000 units │ 32% similarity │ LOW   │
│                                                                  │
│  FINANCIAL IMPACT SUMMARY:                                       │
│  ─────────────────────────────────────────────────────────────  │
│  Gross Margin Gain:    $625,000 (new product)                   │
│  Margin Loss:          $212,500 (cannibalized)                  │
│  Net Margin Impact:    $412,500 ✓ POSITIVE                      │
│                                                                  │
│  RECOMMENDATION: PROCEED with launch                             │
│  Consider sunsetting Widget Pro 1.0 within 12 months            │
│                                                                  │
│  MODEL ACCURACY: 82% (based on last 25 launches)                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*ML-powered cannibalization analysis for informed portfolio decisions.*
