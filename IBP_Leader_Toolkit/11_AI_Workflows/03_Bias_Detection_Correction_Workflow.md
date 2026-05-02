# Bias Detection & Correction Workflow
## Automated Forecast Bias Monitoring and Auto-Adjustment

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    BIAS DETECTION & CORRECTION WORKFLOW                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. CALC  │───▶│ 2. DETECT│───▶│ 3. ROOT  │───▶│ 4. CALC  │             │
│  │ BIAS     │    │ PATTERN  │    │ CAUSE    │    │ CORRECT  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Daily Calc      Statistical     AI Analysis     Auto-Factor             │
│   By SKU          Tests           LLM Insight     Generation              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. ALERT │───▶│ 6. REVIEW│───▶│ 7. APPLY │───▶│ 8. MONITOR│            │
│  │ NOTIFY   │    │ APPROVE  │    │ CORRECT  │    │ FEEDBACK │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Real-time       Human-in-       Auto-Apply      Continuous              │
│   Alerts          Loop            to Forecast     Learning                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Bias Calculation (Automated Daily)

### Bias Metrics
| Metric | Formula | Interpretation |
|--------|---------|----------------|
| Mean Bias | Σ(Actual - Forecast) / n | Systematic error |
| Bias % | Σ(A-F) / Σ(A) × 100 | Percentage over/under |
| Tracking Signal | Σ(A-F) / MAD | Cumulative drift |
| MPE | Σ((A-F)/A) / n × 100 | Avg % error |

### Calculation Engine
```python
def calculate_bias_metrics(sku, periods=12):
    forecast = get_forecast_history(sku, periods)
    actual = get_actual_history(sku, periods)
    
    errors = actual - forecast
    
    metrics = {
        'mean_bias': errors.mean(),
        'bias_pct': errors.sum() / actual.sum() * 100,
        'tracking_signal': errors.sum() / errors.abs().mean(),
        'mpe': ((actual - forecast) / actual).mean() * 100,
        'bias_direction': 'OVER' if errors.mean() > 0 else 'UNDER',
        'periods_analyzed': len(errors),
        'latest_error': errors.iloc[-1],
        'trend': calculate_bias_trend(errors)
    }
    
    # Statistical significance test
    t_stat, p_value = stats.ttest_1samp(errors, 0)
    metrics['statistically_significant'] = p_value < 0.05
    metrics['p_value'] = p_value
    
    return metrics
```

---

## Step 2: Pattern Detection (Statistical)

### Detection Rules
| Pattern | Detection Logic | Threshold |
|---------|----------------|-----------|
| Consistent Over-forecast | 8+ consecutive positive errors | 8 periods |
| Consistent Under-forecast | 8+ consecutive negative errors | 8 periods |
| Tracking Signal Breach | \|TS\| > 4 | ±4 |
| Increasing Bias | Positive slope in errors | >5% per period |
| Seasonal Bias | Bias correlates with season | R² > 0.5 |

### Pattern Detection Engine
```python
def detect_bias_patterns(errors, actual):
    patterns = []
    
    # Consecutive same-sign errors
    signs = np.sign(errors)
    consecutive = count_consecutive(signs)
    if consecutive >= 8:
        patterns.append({
            'type': 'CONSISTENT_BIAS',
            'direction': 'OVER' if signs.iloc[-1] > 0 else 'UNDER',
            'consecutive_periods': consecutive,
            'severity': 'HIGH'
        })
    
    # Tracking signal breach
    tracking_signal = errors.sum() / errors.abs().mean()
    if abs(tracking_signal) > 4:
        patterns.append({
            'type': 'TRACKING_SIGNAL_BREACH',
            'value': tracking_signal,
            'threshold': 4,
            'severity': 'CRITICAL'
        })
    
    # Trend detection
    slope, intercept, r, p, se = stats.linregress(range(len(errors)), errors)
    if abs(slope) > 0.05 * actual.mean() and p < 0.05:
        patterns.append({
            'type': 'TRENDING_BIAS',
            'slope': slope,
            'direction': 'INCREASING' if slope > 0 else 'DECREASING',
            'severity': 'MEDIUM'
        })
    
    # Seasonal pattern
    if len(errors) >= 24:
        seasonal_corr = detect_seasonal_bias(errors)
        if seasonal_corr > 0.5:
            patterns.append({
                'type': 'SEASONAL_BIAS',
                'correlation': seasonal_corr,
                'peak_months': find_peak_bias_months(errors),
                'severity': 'MEDIUM'
            })
    
    return patterns
```

---

## Step 3: Root Cause Analysis (AI-Powered)

### AI Root Cause Engine
```python
def analyze_root_cause(sku, bias_metrics, patterns):
    # Gather context data
    context = {
        'bias_metrics': bias_metrics,
        'patterns': patterns,
        'sku_attributes': get_sku_attributes(sku),
        'recent_changes': get_recent_changes(sku),
        'market_events': get_market_events(sku),
        'forecast_method': get_forecast_method(sku),
        'planner_overrides': get_override_history(sku)
    }
    
    # LLM analysis
    prompt = f"""
    Analyze the forecast bias for SKU {sku}:
    
    Bias Metrics: {context['bias_metrics']}
    Detected Patterns: {context['patterns']}
    Product Attributes: {context['sku_attributes']}
    Recent Changes: {context['recent_changes']}
    Market Events: {context['market_events']}
    Forecast Method: {context['forecast_method']}
    Planner Overrides: {context['planner_overrides']}
    
    Identify the most likely root causes for the bias and recommend corrections.
    """
    
    llm_analysis = call_llm(prompt)
    
    # Structure the response
    root_causes = extract_root_causes(llm_analysis)
    recommendations = extract_recommendations(llm_analysis)
    
    return {
        'root_causes': root_causes,
        'recommendations': recommendations,
        'confidence': calculate_confidence(root_causes),
        'llm_reasoning': llm_analysis
    }
```

### Common Root Causes
| Category | Root Cause | Auto-Detectable |
|----------|------------|-----------------|
| Model | Wrong algorithm selected | Yes |
| Model | Outdated seasonality indices | Yes |
| Data | Missing promotional data | Yes |
| Data | Incorrect baseline | Partial |
| Human | Consistent over-optimism | Yes |
| Human | Sandbagging | Yes |
| Market | Demand pattern shift | Yes |
| External | Competitor action | Partial |

---

## Step 4: Correction Factor Calculation (Automated)

### Correction Methods
```python
def calculate_correction_factor(bias_metrics, pattern):
    # Method selection based on pattern
    if pattern['type'] == 'CONSISTENT_BIAS':
        # Simple bias adjustment
        factor = 1 - (bias_metrics['bias_pct'] / 100)
        method = 'SIMPLE_ADJUSTMENT'
        
    elif pattern['type'] == 'TRENDING_BIAS':
        # Trend-adjusted correction
        factor = calculate_trend_correction(bias_metrics)
        method = 'TREND_ADJUSTED'
        
    elif pattern['type'] == 'SEASONAL_BIAS':
        # Seasonal correction factors
        factor = calculate_seasonal_corrections(bias_metrics)
        method = 'SEASONAL_ADJUSTED'
        
    else:
        # Default: exponential smoothing of errors
        factor = calculate_smoothed_correction(bias_metrics, alpha=0.3)
        method = 'SMOOTHED'
    
    # Apply guardrails
    factor = apply_correction_guardrails(factor)
    
    return {
        'correction_factor': factor,
        'method': method,
        'expected_bias_reduction': estimate_bias_reduction(factor, bias_metrics)
    }

def apply_correction_guardrails(factor):
    # Limit correction to ±30%
    MIN_FACTOR = 0.70
    MAX_FACTOR = 1.30
    
    if isinstance(factor, (int, float)):
        return np.clip(factor, MIN_FACTOR, MAX_FACTOR)
    else:
        # Array of seasonal factors
        return np.clip(factor, MIN_FACTOR, MAX_FACTOR)
```

---

## Step 5: Alert & Notification (Real-Time)

### Alert Rules
| Condition | Severity | Notification |
|-----------|----------|--------------|
| Tracking Signal > ±6 | Critical | Immediate + Manager |
| Tracking Signal > ±4 | High | Same day |
| Bias > ±10% for 3 periods | Medium | Weekly digest |
| New bias pattern detected | Low | Monthly report |

### Alert Generation
```python
def generate_bias_alerts(sku_bias_results):
    alerts = []
    
    for sku, result in sku_bias_results.items():
        metrics = result['metrics']
        patterns = result['patterns']
        
        # Critical: Tracking signal breach
        if abs(metrics['tracking_signal']) > 6:
            alerts.append({
                'sku': sku,
                'type': 'TRACKING_SIGNAL_CRITICAL',
                'severity': 'CRITICAL',
                'message': f"Tracking signal at {metrics['tracking_signal']:.1f} (threshold: ±6)",
                'requires_immediate_action': True,
                'suggested_action': 'Halt forecast and investigate'
            })
        
        # High: Significant consistent bias
        elif abs(metrics['tracking_signal']) > 4:
            alerts.append({
                'sku': sku,
                'type': 'TRACKING_SIGNAL_HIGH',
                'severity': 'HIGH',
                'message': f"Tracking signal at {metrics['tracking_signal']:.1f} (threshold: ±4)",
                'correction_available': True,
                'auto_correction': result['correction']
            })
        
        # Medium: Persistent bias
        elif abs(metrics['bias_pct']) > 10:
            alerts.append({
                'sku': sku,
                'type': 'PERSISTENT_BIAS',
                'severity': 'MEDIUM',
                'message': f"Bias at {metrics['bias_pct']:.1f}% for {metrics['periods_analyzed']} periods",
                'correction_available': True
            })
    
    # Send notifications
    send_alerts(alerts)
    
    return alerts
```

---

## Step 6: Review & Approval (Human-in-Loop)

### Approval Workflow
```
┌─────────────────────────────────────────────────────────────────┐
│  BIAS CORRECTION - APPROVAL REQUIRED                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SKU: GHI789 - Premium Widget                                   │
│  ─────────────────────────────────────────────────────────────  │
│  BIAS ANALYSIS                                                   │
│  ├── Current Bias: +12.5% (consistent over-forecast)            │
│  ├── Tracking Signal: 5.2 (BREACH)                              │
│  ├── Pattern: 10 consecutive over-forecasts                     │
│  └── Statistically Significant: Yes (p=0.003)                   │
│  ─────────────────────────────────────────────────────────────  │
│  AI ROOT CAUSE ANALYSIS                                          │
│  "Bias appears driven by:                                        │
│   1. Promotional lift assumption too high (actual: 15%,         │
│      assumed: 25%)                                               │
│   2. Seasonal index not updated after COVID pattern shift       │
│   Confidence: 85%"                                               │
│  ─────────────────────────────────────────────────────────────  │
│  RECOMMENDED CORRECTION                                          │
│  ├── Correction Factor: 0.89 (reduce forecast by 11%)           │
│  ├── Method: Simple Adjustment                                   │
│  └── Expected Bias Reduction: 9-10 percentage points            │
│  ─────────────────────────────────────────────────────────────  │
│  [Approve Correction] [Modify Factor: ____] [Investigate]       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 7: Apply Correction (Automated)

### Correction Application
```python
def apply_bias_correction(sku, correction, approval):
    if approval['status'] != 'APPROVED':
        return None
    
    # Get current forecast
    forecast = get_current_forecast(sku)
    
    # Apply correction factor
    if correction['method'] == 'SIMPLE_ADJUSTMENT':
        corrected = forecast * correction['correction_factor']
        
    elif correction['method'] == 'SEASONAL_ADJUSTED':
        # Apply month-specific factors
        for month, factor in correction['correction_factor'].items():
            corrected[corrected.index.month == month] *= factor
            
    elif correction['method'] == 'TREND_ADJUSTED':
        # Apply decaying correction
        for i, period in enumerate(forecast.index):
            decay = correction['decay_rate'] ** i
            corrected.iloc[i] = forecast.iloc[i] * (1 + (correction['initial_adj'] * decay))
    
    # Update forecast in system
    update_forecast(sku, corrected, reason='BIAS_CORRECTION', correction_details=correction)
    
    # Log for audit
    log_correction(sku, forecast, corrected, correction, approval)
    
    # Notify stakeholders
    notify_correction_applied(sku, correction)
    
    return corrected
```

---

## Step 8: Monitor & Learn (Continuous)

### Feedback Loop
```python
def monitor_correction_effectiveness(sku, correction_date, lookback_periods=6):
    # Get pre and post correction data
    pre_data = get_bias_metrics(sku, end_date=correction_date, periods=lookback_periods)
    post_data = get_bias_metrics(sku, start_date=correction_date, periods=lookback_periods)
    
    # Calculate improvement
    bias_reduction = pre_data['bias_pct'] - post_data['bias_pct']
    ts_improvement = abs(pre_data['tracking_signal']) - abs(post_data['tracking_signal'])
    
    effectiveness = {
        'sku': sku,
        'correction_date': correction_date,
        'pre_bias': pre_data['bias_pct'],
        'post_bias': post_data['bias_pct'],
        'bias_reduction': bias_reduction,
        'target_reduction': correction['expected_bias_reduction'],
        'effectiveness_score': bias_reduction / correction['expected_bias_reduction'],
        'status': 'EFFECTIVE' if bias_reduction > correction['expected_bias_reduction'] * 0.7 else 'INEFFECTIVE'
    }
    
    # Learn from outcome
    update_correction_model(effectiveness)
    
    # Alert if ineffective
    if effectiveness['status'] == 'INEFFECTIVE':
        alert_ineffective_correction(effectiveness)
    
    return effectiveness

def update_correction_model(effectiveness):
    # Store outcome for ML training
    store_correction_outcome(effectiveness)
    
    # Retrain correction model periodically
    if should_retrain():
        retrain_correction_model()
```

---

## Monitoring Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  BIAS MONITORING DASHBOARD                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  OVERALL BIAS METRICS                                            │
│  ├── Portfolio Bias: -2.3% (Target: ±3%)         ✓ ON TARGET    │
│  ├── SKUs with Significant Bias: 45 (8%)                        │
│  ├── Tracking Signal Breaches: 12                                │
│  └── Auto-Corrections Applied: 28 this month                    │
│                                                                  │
│  BIAS BY DIMENSION                                               │
│  ├── By Region:    APAC -5%, EMEA +1%, AMER +2%                │
│  ├── By Category:  Cat A -3%, Cat B +1%, Cat C -2%             │
│  └── By Planner:   John -4%, Sarah +2%, Mike -1%               │
│                                                                  │
│  CORRECTION EFFECTIVENESS                                        │
│  ├── Corrections Applied (90 days): 85                          │
│  ├── Effective: 72 (85%)                                        │
│  ├── Partially Effective: 10 (12%)                              │
│  └── Ineffective: 3 (3%)                                        │
│                                                                  │
│  ALERTS                                                          │
│  ├── Critical: 2 (Tracking Signal > 6)                          │
│  ├── High: 8 (Tracking Signal > 4)                              │
│  └── Medium: 35 (Bias > 10%)                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*Automated bias detection and correction for continuous forecast accuracy improvement.*
