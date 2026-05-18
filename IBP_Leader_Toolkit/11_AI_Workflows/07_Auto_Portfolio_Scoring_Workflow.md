# Auto-Portfolio Scoring Workflow
## AI-Powered Product Portfolio Analysis & Scoring

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AUTO-PORTFOLIO SCORING WORKFLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. GATHER│───▶│ 2. CALC  │───▶│ 3. ML    │───▶│ 4. SCORE │             │
│  │ DATA     │    │ METRICS  │    │ CLUSTER  │    │ PRODUCTS │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Multi-source    Auto-Calc       K-means/        Weighted               │
│   Integration     KPIs            Hierarchical    Composite               │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. CLASS │───▶│ 6. RECOM │───▶│ 7. ALERT │───▶│ 8. TRACK │            │
│  │ IFY      │    │ MEND     │    │ REVIEW   │    │ ACTIONS  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Star/Cash Cow   AI Strategy     Exception       Monitor                 │
│   Dog/Question    Generation      Flagging        Implementation          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Data Gathering (Automated)

### Data Sources
| Source | Data | Refresh |
|--------|------|---------|
| ERP | Revenue, COGS, volume | Daily |
| Finance | Margin, profitability | Monthly |
| CRM | Customer feedback, wins/losses | Weekly |
| Marketing | Market share, brand metrics | Monthly |
| Supply Chain | Inventory, lead time, complexity | Daily |
| Product DB | Lifecycle stage, attributes | Real-time |

### Data Collection
```python
def gather_portfolio_data():
    data = {}
    
    # Financial performance
    data['financial'] = {
        'revenue_12m': get_trailing_revenue(months=12),
        'revenue_growth': calculate_growth_rate(periods=4),
        'gross_margin': get_gross_margin(),
        'contribution_margin': get_contribution_margin(),
        'revenue_trend': calculate_trend('revenue', periods=12)
    }
    
    # Market performance
    data['market'] = {
        'market_share': get_market_share(),
        'market_growth': get_market_growth_rate(),
        'competitive_position': get_competitive_ranking(),
        'customer_satisfaction': get_nps_score(),
        'win_rate': calculate_win_rate()
    }
    
    # Operational metrics
    data['operational'] = {
        'inventory_turns': get_inventory_turns(),
        'supply_complexity': calculate_supply_complexity(),
        'lead_time': get_avg_lead_time(),
        'quality_score': get_quality_metrics(),
        'service_level': get_fill_rate()
    }
    
    # Strategic alignment
    data['strategic'] = {
        'lifecycle_stage': get_lifecycle_stage(),
        'strategic_fit': get_strategic_alignment_score(),
        'innovation_index': calculate_innovation_score(),
        'sustainability_score': get_esg_metrics()
    }
    
    return data
```

---

## Step 2: Calculate Metrics (Automated)

### Scoring Dimensions
```python
def calculate_portfolio_metrics(product_id, data):
    metrics = {}
    
    # Financial Score (0-100)
    metrics['financial_score'] = (
        0.35 * normalize(data['financial']['gross_margin'], min=0, max=0.6) +
        0.30 * normalize(data['financial']['revenue_growth'], min=-0.2, max=0.3) +
        0.20 * normalize(data['financial']['contribution_margin'], min=0, max=0.4) +
        0.15 * normalize(data['financial']['revenue_12m'], percentile=True)
    ) * 100
    
    # Market Score (0-100)
    metrics['market_score'] = (
        0.30 * normalize(data['market']['market_share']) +
        0.25 * normalize(data['market']['market_growth'], min=-0.1, max=0.2) +
        0.25 * normalize(data['market']['win_rate'], min=0, max=1) +
        0.20 * normalize(data['market']['customer_satisfaction'], min=0, max=100)
    ) * 100
    
    # Operational Score (0-100)
    metrics['operational_score'] = (
        0.30 * normalize(data['operational']['inventory_turns'], min=2, max=12) +
        0.25 * (1 - normalize(data['operational']['supply_complexity'])) +
        0.25 * normalize(data['operational']['service_level'], min=0.8, max=1) +
        0.20 * normalize(data['operational']['quality_score'], min=0.9, max=1)
    ) * 100
    
    # Strategic Score (0-100)
    metrics['strategic_score'] = (
        0.40 * normalize(data['strategic']['strategic_fit'], min=1, max=5) +
        0.30 * normalize(data['strategic']['innovation_index']) +
        0.30 * normalize(data['strategic']['sustainability_score'])
    ) * 100
    
    # Composite Score
    metrics['composite_score'] = (
        0.35 * metrics['financial_score'] +
        0.25 * metrics['market_score'] +
        0.20 * metrics['operational_score'] +
        0.20 * metrics['strategic_score']
    )
    
    return metrics
```

---

## Step 3: ML Clustering (Automated)

### Product Clustering
```python
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

def cluster_products(product_metrics):
    # Prepare features
    features = ['financial_score', 'market_score', 'operational_score', 'strategic_score']
    X = product_metrics[features].values
    
    # Standardize
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # Optimal clusters (elbow method)
    optimal_k = find_optimal_clusters(X_scaled, max_k=8)
    
    # Fit K-means
    kmeans = KMeans(n_clusters=optimal_k, random_state=42)
    product_metrics['cluster'] = kmeans.fit_predict(X_scaled)
    
    # Label clusters based on characteristics
    cluster_labels = label_clusters(product_metrics, kmeans.cluster_centers_)
    product_metrics['cluster_name'] = product_metrics['cluster'].map(cluster_labels)
    
    return product_metrics

def label_clusters(data, centers):
    labels = {}
    for i, center in enumerate(centers):
        if center[0] > 0.5 and center[1] > 0.5:  # High financial, high market
            labels[i] = 'Star'
        elif center[0] > 0.5 and center[1] <= 0.5:  # High financial, low market
            labels[i] = 'Cash Cow'
        elif center[0] <= 0.5 and center[1] > 0.5:  # Low financial, high market
            labels[i] = 'Question Mark'
        else:  # Low both
            labels[i] = 'Dog'
    return labels
```

---

## Step 4: Score Products (Automated)

### Final Scoring
```python
def score_all_products():
    products = get_all_active_products()
    scored_products = []
    
    for product in products:
        # Gather data
        data = gather_portfolio_data(product['id'])
        
        # Calculate metrics
        metrics = calculate_portfolio_metrics(product['id'], data)
        
        # Add product info
        metrics['product_id'] = product['id']
        metrics['product_name'] = product['name']
        metrics['category'] = product['category']
        metrics['lifecycle_stage'] = data['strategic']['lifecycle_stage']
        
        scored_products.append(metrics)
    
    # Convert to DataFrame
    df = pd.DataFrame(scored_products)
    
    # Add ranking
    df['rank'] = df['composite_score'].rank(ascending=False)
    df['percentile'] = df['composite_score'].rank(pct=True) * 100
    
    # Cluster
    df = cluster_products(df)
    
    return df
```

---

## Step 5: Classify Products (BCG Matrix + Enhanced)

### Classification Logic
```python
def classify_product(product):
    # BCG Matrix Classification
    market_growth = product['market_growth']
    relative_share = product['relative_market_share']
    
    if market_growth > 0.1 and relative_share > 1.0:
        bcg_class = 'Star'
    elif market_growth <= 0.1 and relative_share > 1.0:
        bcg_class = 'Cash Cow'
    elif market_growth > 0.1 and relative_share <= 1.0:
        bcg_class = 'Question Mark'
    else:
        bcg_class = 'Dog'
    
    # Enhanced Classification
    if product['composite_score'] >= 80:
        action = 'Invest'
    elif product['composite_score'] >= 60:
        action = 'Maintain'
    elif product['composite_score'] >= 40:
        action = 'Harvest'
    else:
        action = 'Divest'
    
    # Lifecycle overlay
    if product['lifecycle_stage'] == 'Decline' and action != 'Divest':
        action = 'Review for Sunset'
    
    return {
        'bcg_class': bcg_class,
        'recommended_action': action,
        'priority': calculate_action_priority(product)
    }
```

---

## Step 6: AI Recommendations (LLM-Powered)

### Strategy Generation
```python
def generate_product_recommendations(product, classification):
    prompt = f"""
    Generate strategic recommendations for this product:
    
    PRODUCT: {product['product_name']}
    CATEGORY: {product['category']}
    
    SCORES:
    - Financial: {product['financial_score']:.0f}/100
    - Market: {product['market_score']:.0f}/100
    - Operational: {product['operational_score']:.0f}/100
    - Strategic: {product['strategic_score']:.0f}/100
    - Composite: {product['composite_score']:.0f}/100
    
    CLASSIFICATION:
    - BCG: {classification['bcg_class']}
    - Lifecycle: {product['lifecycle_stage']}
    - Recommended Action: {classification['recommended_action']}
    
    KEY METRICS:
    - Revenue: ${product['revenue_12m']:,.0f}
    - Margin: {product['gross_margin']:.1%}
    - Market Share: {product['market_share']:.1%}
    - Growth: {product['revenue_growth']:.1%}
    
    Provide:
    1. Strategic recommendation (1-2 sentences)
    2. Key actions (3-5 bullets)
    3. Investment level (Increase/Maintain/Reduce/Eliminate)
    4. Timeline for action
    5. Risk if no action taken
    """
    
    recommendation = call_llm(prompt)
    return parse_recommendation(recommendation)
```

---

## Step 7: Alert & Review (Automated)

### Exception Alerts
```python
def generate_portfolio_alerts(scored_products):
    alerts = []
    
    for _, product in scored_products.iterrows():
        # Declining star
        if product['cluster_name'] == 'Star' and product['revenue_trend'] < -0.05:
            alerts.append({
                'product': product['product_name'],
                'type': 'DECLINING_STAR',
                'severity': 'HIGH',
                'message': f"Star product declining: {product['revenue_trend']:.1%} trend",
                'action': 'Investigate and intervene'
            })
        
        # High-margin dog
        if product['cluster_name'] == 'Dog' and product['gross_margin'] > 0.4:
            alerts.append({
                'product': product['product_name'],
                'type': 'HIDDEN_VALUE',
                'severity': 'MEDIUM',
                'message': f"Dog with high margin ({product['gross_margin']:.1%}) - review pricing power",
                'action': 'Evaluate repositioning'
            })
        
        # Score drop
        if product.get('score_change_30d', 0) < -10:
            alerts.append({
                'product': product['product_name'],
                'type': 'SCORE_DROP',
                'severity': 'HIGH',
                'message': f"Composite score dropped {product['score_change_30d']:.0f} points",
                'action': 'Root cause analysis'
            })
    
    return alerts
```

---

## Step 8: Track Actions (Automated)

### Action Tracking
```python
def track_portfolio_actions():
    # Get recommended actions
    actions = get_portfolio_actions(status='OPEN')
    
    for action in actions:
        # Check progress
        progress = calculate_action_progress(action)
        
        # Update status
        if progress >= 100:
            action['status'] = 'COMPLETE'
            measure_impact(action)
        elif action['due_date'] < today():
            action['status'] = 'OVERDUE'
            escalate_action(action)
        
        # Send reminders
        if action['due_date'] - today() <= 7:
            send_reminder(action)
    
    return actions
```

---

## Portfolio Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  PRODUCT PORTFOLIO DASHBOARD                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PORTFOLIO HEALTH                                                │
│  ├── Total Products: 450                                        │
│  ├── Stars: 45 (10%)              $125M revenue                 │
│  ├── Cash Cows: 120 (27%)         $280M revenue                 │
│  ├── Question Marks: 85 (19%)     $65M revenue                  │
│  └── Dogs: 200 (44%)              $45M revenue                  │
│                                                                  │
│  SCORE DISTRIBUTION                                              │
│  ├── Excellent (80+): 52 products                               │
│  ├── Good (60-79): 145 products                                 │
│  ├── Fair (40-59): 158 products                                 │
│  └── Poor (<40): 95 products                                    │
│                                                                  │
│  ACTIONS REQUIRED                                                │
│  ├── Invest: 35 products                                        │
│  ├── Review for Sunset: 85 products                             │
│  └── Immediate Rationalization: 42 products                     │
│                                                                  │
│  ALERTS TODAY: 12                                                │
│  ├── Declining Stars: 3                                         │
│  ├── Score Drops: 5                                             │
│  └── Hidden Value: 4                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered product portfolio scoring for continuous portfolio optimization.*
