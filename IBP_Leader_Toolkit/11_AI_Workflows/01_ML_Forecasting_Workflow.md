# ML Forecasting Workflow
## Automated Demand Forecasting Pipeline

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ML FORECASTING WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. DATA  │───▶│ 2. PREP  │───▶│ 3. TRAIN │───▶│ 4. SELECT│             │
│  │ EXTRACT  │    │ & CLEAN  │    │ MODELS   │    │ BEST     │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Automated       Automated       10+ Models      Auto-Select             │
│   Daily Pull      Cleansing       Per SKU         Winner                  │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. FCST  │───▶│ 6. SENSE │───▶│ 7. REVIEW│───▶│ 8. PUBLISH│            │
│  │ GENERATE │    │ ADJUST   │    │ EXCEPTION│    │ CONSENSUS │            │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Auto-Generate   Real-time       Human-in-       Auto-Push               │
│   All SKUs        Signals         Loop            to Systems              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Data Extraction (Automated)

### Trigger
- **Schedule**: Daily at 2:00 AM
- **Event**: Month-end close completion

### Data Sources
| Source | Data Type | Refresh |
|--------|-----------|---------|
| ERP | Sales history, orders | Daily |
| CRM | Pipeline, opportunities | Daily |
| POS | Retail sell-through | Daily |
| Weather API | Forecasts, actuals | Hourly |
| Events DB | Promotions, holidays | Weekly |
| External | Economic indicators | Monthly |

### Automation Script
```python
# Data extraction automation
def extract_demand_data():
    # Connect to sources
    erp_data = extract_from_erp(date_range="36_months")
    crm_data = extract_from_crm(pipeline_stage="all")
    pos_data = extract_from_pos(granularity="daily")
    
    # Combine and validate
    combined = merge_data_sources([erp_data, crm_data, pos_data])
    validated = validate_completeness(combined, threshold=0.95)
    
    # Store in feature store
    save_to_feature_store(validated, version=today())
    
    return validated
```

---

## Step 2: Data Preparation (Automated)

### Cleansing Rules
| Issue | Detection | Auto-Fix |
|-------|-----------|----------|
| Missing values | >5% gaps | Interpolation |
| Outliers | >3 std dev | Cap at 3σ or flag |
| Duplicates | Exact match | Remove |
| Negative values | <0 | Flag for review |
| Seasonality breaks | Pattern change | Segment history |

### Feature Engineering
```python
def engineer_features(data):
    features = {}
    
    # Time-based features
    features['day_of_week'] = data['date'].dt.dayofweek
    features['month'] = data['date'].dt.month
    features['quarter'] = data['date'].dt.quarter
    features['is_month_end'] = data['date'].dt.is_month_end
    
    # Lag features
    for lag in [1, 7, 14, 28, 365]:
        features[f'lag_{lag}'] = data['demand'].shift(lag)
    
    # Rolling statistics
    for window in [7, 14, 28, 90]:
        features[f'rolling_mean_{window}'] = data['demand'].rolling(window).mean()
        features[f'rolling_std_{window}'] = data['demand'].rolling(window).std()
    
    # External features
    features['weather_temp'] = get_weather_forecast()
    features['promo_flag'] = get_promotion_calendar()
    features['holiday_flag'] = get_holiday_calendar()
    
    return pd.DataFrame(features)
```

---

## Step 3: Model Training (Automated)

### Model Suite
| Model | Type | Best For |
|-------|------|----------|
| XGBoost | Gradient boosting | Stable demand |
| LightGBM | Gradient boosting | Large datasets |
| Prophet | Additive | Strong seasonality |
| LSTM | Deep learning | Complex patterns |
| ARIMA | Statistical | Trending data |
| Holt-Winters | Exponential | Seasonal items |
| Croston | Intermittent | Spare parts |
| Theta | Statistical | Short series |

### Training Pipeline
```python
def train_all_models(sku_data):
    models = {
        'xgboost': XGBRegressor(n_estimators=100),
        'lightgbm': LGBMRegressor(n_estimators=100),
        'prophet': Prophet(yearly_seasonality=True),
        'lstm': build_lstm_model(units=50),
        'arima': auto_arima(sku_data),
        'holt_winters': ExponentialSmoothing(seasonal='mul'),
        'croston': CrostonMethod(),
        'theta': ThetaModel()
    }
    
    results = {}
    for name, model in models.items():
        # Train with cross-validation
        cv_scores = cross_validate(model, sku_data, cv=5)
        results[name] = {
            'model': model.fit(sku_data),
            'mape': cv_scores['mape'].mean(),
            'bias': cv_scores['bias'].mean()
        }
    
    return results
```

---

## Step 4: Model Selection (Automated)

### Selection Criteria
| Metric | Weight | Threshold |
|--------|--------|-----------|
| MAPE | 40% | <25% |
| Bias | 30% | ±5% |
| Stability | 20% | <10% variance |
| Compute time | 10% | <5 sec/SKU |

### Auto-Selection Logic
```python
def select_best_model(model_results, demand_pattern):
    # Classify demand pattern
    cv = calculate_cv(history)
    adi = calculate_adi(history)
    pattern = classify_pattern(cv, adi)  # Smooth/Erratic/Intermittent/Lumpy
    
    # Filter models by pattern suitability
    suitable = filter_by_pattern(model_results, pattern)
    
    # Score remaining models
    scores = {}
    for name, result in suitable.items():
        scores[name] = (
            0.4 * (1 - result['mape']) +
            0.3 * (1 - abs(result['bias'])) +
            0.2 * result['stability'] +
            0.1 * result['speed_score']
        )
    
    # Select winner
    best_model = max(scores, key=scores.get)
    
    # Log selection
    log_model_selection(sku, best_model, scores)
    
    return model_results[best_model]['model']
```

---

## Step 5: Forecast Generation (Automated)

### Forecast Output
```python
def generate_forecast(model, horizon=18):
    # Generate point forecast
    forecast = model.predict(horizon_months=horizon)
    
    # Generate prediction intervals
    lower_80 = model.predict_interval(0.80, 'lower')
    upper_80 = model.predict_interval(0.80, 'upper')
    lower_95 = model.predict_interval(0.95, 'lower')
    upper_95 = model.predict_interval(0.95, 'upper')
    
    # Calculate confidence score
    confidence = calculate_confidence(model, history)
    
    return {
        'point_forecast': forecast,
        'lower_80': lower_80,
        'upper_80': upper_80,
        'lower_95': lower_95,
        'upper_95': upper_95,
        'confidence': confidence,
        'model_used': model.name
    }
```

---

## Step 6: Demand Sensing Adjustment (Automated)

### Real-Time Signals
| Signal | Source | Adjustment Logic |
|--------|--------|------------------|
| POS data | Retail partners | Scale by sell-through rate |
| Orders | ERP | Blend with forecast |
| Weather | API | Apply weather factor |
| Events | Calendar | Apply promo lift |
| Social | Sentiment API | Adjust for trends |

### Sensing Algorithm
```python
def apply_demand_sensing(base_forecast, signals):
    adjusted = base_forecast.copy()
    
    # Short-term horizon (0-4 weeks)
    for week in range(4):
        # POS signal
        if signals['pos_available']:
            pos_trend = calculate_pos_trend(signals['pos_data'])
            adjusted[week] *= (1 + pos_trend * 0.5)
        
        # Order signal
        if signals['orders_available']:
            order_ratio = signals['orders'] / base_forecast[week]
            adjusted[week] = base_forecast[week] * 0.3 + signals['orders'] * 0.7
        
        # Weather adjustment
        weather_factor = get_weather_factor(signals['weather'], week)
        adjusted[week] *= weather_factor
        
        # Event adjustment
        if signals['promo_active'][week]:
            lift = get_promo_lift(signals['promo_type'])
            adjusted[week] *= (1 + lift)
    
    return adjusted
```

---

## Step 7: Exception Review (Human-in-Loop)

### Auto-Flagged Exceptions
| Exception Type | Trigger | Action |
|----------------|---------|--------|
| High variance | >30% change | Review required |
| Low confidence | <70% score | Manual override option |
| New product | <6 months history | Expert input |
| Anomaly detected | >3σ deviation | Investigate |
| Model switch | Different model selected | Notify planner |

### Review Dashboard
```
┌─────────────────────────────────────────────────────────────────┐
│  FORECAST EXCEPTIONS - REVIEW REQUIRED                          │
├─────────────────────────────────────────────────────────────────┤
│  SKU: ABC123 - Widget Pro                                       │
│  ─────────────────────────────────────────────────────────────  │
│  ML Forecast: 1,250 units | Confidence: 65%                     │
│  Previous Forecast: 950 units | Change: +32%                    │
│  ─────────────────────────────────────────────────────────────  │
│  AI Insight: "Demand spike detected due to competitor           │
│  stockout. POS data shows 40% increase in last 2 weeks.         │
│  Weather forecast indicates continued favorable conditions."     │
│  ─────────────────────────────────────────────────────────────  │
│  [Accept ML Forecast] [Override: ____] [Request Analysis]       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 8: Publish Consensus (Automated)

### Publication Workflow
```python
def publish_consensus_forecast(reviewed_forecast):
    # Validate all reviews complete
    if not all_exceptions_resolved():
        send_reminder_to_planners()
        return "PENDING"
    
    # Apply final adjustments
    final = apply_management_overrides(reviewed_forecast)
    
    # Version and timestamp
    version = create_version(final, timestamp=now())
    
    # Push to downstream systems
    push_to_erp(final, system='SAP')
    push_to_supply_planning(final)
    push_to_financial_planning(final)
    
    # Notify stakeholders
    send_publication_notification(version)
    
    # Archive for audit
    archive_forecast(version)
    
    return "PUBLISHED"
```

---

## Monitoring & Alerts

### Automated Monitoring
| Metric | Frequency | Alert Threshold |
|--------|-----------|-----------------|
| Forecast accuracy | Daily | MAPE >25% |
| Bias trend | Weekly | >±5% for 3 weeks |
| Model performance | Monthly | Degradation >10% |
| Data quality | Daily | Completeness <95% |

### Alert Workflow
```python
def monitor_forecast_performance():
    # Calculate accuracy
    accuracy = calculate_wmape(forecast, actuals)
    
    # Check thresholds
    if accuracy > 0.25:
        alert = create_alert(
            type="ACCURACY",
            severity="HIGH",
            message=f"Forecast accuracy degraded to {accuracy:.1%}",
            recommended_action="Review model selection and data inputs"
        )
        send_alert(alert, recipients=['demand_planning_team'])
        trigger_model_retrain()
    
    # Check bias
    bias = calculate_bias(forecast, actuals)
    if abs(bias) > 0.05:
        trigger_bias_correction(bias)
```

---

## Integration Points

| System | Integration | Data Flow |
|--------|-------------|-----------|
| ERP (SAP) | API | Forecast → MRP |
| Supply Planning | File/API | Forecast → Capacity |
| Financial Planning | API | Forecast → Revenue |
| BI Dashboard | Database | Metrics → Reports |
| Customer Portal | API | Forecast → Collaboration |

---

*Automated ML forecasting workflow for continuous demand planning optimization.*
