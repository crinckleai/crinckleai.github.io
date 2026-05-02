# Customer Forecast Bot Workflow
## AI-Powered Customer Forecast Collection & Validation

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CUSTOMER FORECAST BOT WORKFLOW                            │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. ENGAGE│───▶│ 2. COLLECT│───▶│ 3. VALIDATE│──▶│ 4. CLARIFY│           │
│  │ CUSTOMER │    │ FORECAST │    │ INPUTS   │    │ ANOMALIES│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Multi-Channel    Structured      AI Quality      Bot-Driven             │
│   Outreach         Templates       Checks          Follow-up              │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. AGGREGATE│─▶│ 6. COMPARE│───▶│ 7. ADJUST│───▶│ 8. SHARE │            │
│  │ RESPONSES│    │ HISTORY  │    │ RELIABIL │    │ BACK     │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Consolidate      Accuracy        Weight by       Customer              │
│   by Product       Analysis        Track Record    Visibility            │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Engage Customer

### Multi-Channel Outreach
```python
def initiate_forecast_collection(customer_list, forecast_period):
    """Initiate forecast collection campaign"""
    
    engagements = []
    
    for customer in customer_list:
        # Determine best channel
        channel = determine_best_channel(customer)
        
        # Personalize message
        message = generate_forecast_request(customer, forecast_period, channel)
        
        # Send request
        if channel == 'email':
            response = send_email_request(customer, message)
        elif channel == 'portal':
            response = create_portal_task(customer, message)
        elif channel == 'chatbot':
            response = initiate_chatbot_session(customer, message)
        elif channel == 'edi':
            response = request_edi_forecast(customer)
        
        engagements.append({
            'customer_id': customer['id'],
            'customer_name': customer['name'],
            'channel': channel,
            'sent_at': datetime.now(),
            'due_date': calculate_due_date(forecast_period),
            'status': 'SENT',
            'response_id': response.get('id')
        })
    
    # Schedule follow-ups
    schedule_follow_ups(engagements)
    
    return engagements

def generate_forecast_request(customer, forecast_period, channel):
    """Generate personalized forecast request"""
    
    # Get customer context
    recent_orders = get_recent_orders(customer['id'], months=3)
    products = get_customer_products(customer['id'])
    last_forecast = get_last_customer_forecast(customer['id'])
    
    prompt = f"""
    Generate a forecast request message for:
    
    CUSTOMER: {customer['name']}
    CONTACT: {customer['forecast_contact']}
    CHANNEL: {channel}
    
    CONTEXT:
    - Recent 3-month average: {recent_orders['monthly_avg']:,.0f} units
    - Products ordered: {len(products)} SKUs
    - Last forecast submitted: {last_forecast.get('date', 'Never')}
    - Last forecast accuracy: {last_forecast.get('accuracy', 'N/A')}
    
    FORECAST PERIOD: {forecast_period}
    DUE DATE: {calculate_due_date(forecast_period)}
    
    Generate a {'brief' if channel == 'chatbot' else 'professional'} message that:
    1. Requests their demand forecast for the period
    2. References their recent ordering patterns
    3. Asks about any planned changes or events
    4. Provides clear submission instructions
    5. Offers assistance if needed
    
    Tone: Professional, helpful, appreciative
    """
    
    return call_llm(prompt)

def determine_best_channel(customer):
    """Determine optimal communication channel"""
    
    preferences = customer.get('preferences', {})
    
    # Check explicit preference
    if preferences.get('forecast_channel'):
        return preferences['forecast_channel']
    
    # Check past behavior
    past_submissions = get_past_submissions(customer['id'])
    if past_submissions:
        most_used = max(set(s['channel'] for s in past_submissions), 
                       key=lambda x: sum(1 for s in past_submissions if s['channel'] == x))
        return most_used
    
    # Default based on customer size
    if customer.get('tier') == 'A':
        return 'portal'  # Larger customers use portal
    else:
        return 'email'
```

---

## Step 2: Collect Forecast

### Structured Collection
```python
def collect_customer_forecast(customer_id, submission):
    """Process customer forecast submission"""
    
    forecast_data = {
        'customer_id': customer_id,
        'submitted_at': datetime.now(),
        'channel': submission['channel'],
        'raw_data': submission['data'],
        'products': []
    }
    
    # Parse submission based on format
    if submission['format'] == 'structured':
        # Portal or EDI submission
        products = parse_structured_forecast(submission['data'])
    elif submission['format'] == 'free_text':
        # Email or chat submission
        products = parse_free_text_forecast(submission['data'])
    elif submission['format'] == 'attachment':
        # Excel/CSV attachment
        products = parse_attachment_forecast(submission['file'])
    
    for product in products:
        forecast_data['products'].append({
            'product_id': product['id'],
            'product_name': product['name'],
            'periods': product['forecast'],
            'total': sum(product['forecast']),
            'assumptions': product.get('assumptions'),
            'confidence': product.get('confidence', 'Medium')
        })
    
    # Store raw submission
    store_customer_submission(forecast_data)
    
    return forecast_data

def parse_free_text_forecast(text):
    """Use NLP to parse free-text forecast submission"""
    
    prompt = f"""
    Extract forecast data from this customer message:
    
    MESSAGE:
    {text}
    
    Extract:
    1. Product names/SKUs mentioned
    2. Quantities for each period
    3. Any assumptions or conditions mentioned
    4. Confidence level if stated
    
    Return as structured JSON:
    {{
        "products": [
            {{
                "name": "product name",
                "sku": "if mentioned",
                "forecast": [month1, month2, ...],
                "assumptions": "any conditions",
                "confidence": "High/Medium/Low"
            }}
        ],
        "general_notes": "any overall comments"
    }}
    """
    
    response = call_llm(prompt)
    return parse_llm_json(response)['products']

def parse_attachment_forecast(file):
    """Parse Excel/CSV forecast attachment"""
    import pandas as pd
    
    if file['type'] == 'excel':
        df = pd.read_excel(file['content'])
    else:
        df = pd.read_csv(file['content'])
    
    # Detect column mapping
    column_map = detect_forecast_columns(df)
    
    products = []
    for _, row in df.iterrows():
        product = {
            'id': row.get(column_map['product_id']),
            'name': row.get(column_map['product_name']),
            'forecast': [row.get(col) for col in column_map['period_columns']]
        }
        products.append(product)
    
    return products
```

---

## Step 3: Validate Inputs

### AI Quality Checks
```python
def validate_customer_forecast(forecast_data, customer_id):
    """Run AI validation checks on forecast submission"""
    
    validation_results = {
        'passed': True,
        'checks': [],
        'warnings': [],
        'errors': []
    }
    
    # Get historical context
    history = get_customer_order_history(customer_id, months=24)
    prev_forecast = get_previous_forecast(customer_id)
    
    for product in forecast_data['products']:
        product_history = get_product_customer_history(customer_id, product['product_id'])
        
        # Check 1: Reasonableness vs history
        if product_history:
            avg_historical = np.mean(product_history['monthly_volume'])
            for i, period_forecast in enumerate(product['periods']):
                if period_forecast > avg_historical * 3:
                    validation_results['warnings'].append({
                        'check': 'VOLUME_SPIKE',
                        'product': product['product_name'],
                        'period': i + 1,
                        'message': f"Forecast {period_forecast:,.0f} is 3x+ historical average {avg_historical:,.0f}"
                    })
                elif period_forecast < avg_historical * 0.3 and period_forecast > 0:
                    validation_results['warnings'].append({
                        'check': 'VOLUME_DROP',
                        'product': product['product_name'],
                        'period': i + 1,
                        'message': f"Forecast {period_forecast:,.0f} is <30% of historical {avg_historical:,.0f}"
                    })
        
        # Check 2: Consistency with previous forecast
        if prev_forecast:
            prev_product = find_product_in_forecast(prev_forecast, product['product_id'])
            if prev_product:
                change_pct = (sum(product['periods']) - sum(prev_product['periods'])) / sum(prev_product['periods']) * 100
                if abs(change_pct) > 30:
                    validation_results['warnings'].append({
                        'check': 'FORECAST_CHANGE',
                        'product': product['product_name'],
                        'message': f"Forecast changed {change_pct:+.1f}% from previous submission"
                    })
        
        # Check 3: Seasonality alignment
        if len(product['periods']) >= 12:
            seasonality_check = check_seasonality_alignment(product['periods'], product_history)
            if not seasonality_check['aligned']:
                validation_results['warnings'].append({
                    'check': 'SEASONALITY',
                    'product': product['product_name'],
                    'message': seasonality_check['message']
                })
        
        # Check 4: Missing products
        typical_products = get_typical_customer_products(customer_id)
        submitted_products = [p['product_id'] for p in forecast_data['products']]
        missing = set(typical_products) - set(submitted_products)
        if missing:
            validation_results['warnings'].append({
                'check': 'MISSING_PRODUCTS',
                'message': f"Customer typically orders {len(missing)} products not in forecast"
            })
    
    # Check 5: Completeness
    if not forecast_data['products']:
        validation_results['errors'].append({
            'check': 'EMPTY_FORECAST',
            'message': 'No products in forecast submission'
        })
        validation_results['passed'] = False
    
    return validation_results
```

---

## Step 4: Clarify Anomalies

### Bot-Driven Follow-up
```python
def clarify_forecast_anomalies(customer_id, validation_results):
    """Use bot to clarify anomalies with customer"""
    
    if not validation_results['warnings'] and not validation_results['errors']:
        return {'status': 'no_clarification_needed'}
    
    # Generate clarification questions
    questions = generate_clarification_questions(validation_results)
    
    # Send via appropriate channel
    customer = get_customer(customer_id)
    channel = customer.get('preferences', {}).get('forecast_channel', 'email')
    
    if channel in ['chatbot', 'portal']:
        # Interactive clarification
        session = initiate_clarification_session(customer_id, questions)
        return {'status': 'session_started', 'session_id': session['id']}
    else:
        # Email clarification request
        message = compose_clarification_email(customer, questions)
        send_email(customer['email'], message)
        return {'status': 'email_sent'}

def generate_clarification_questions(validation_results):
    """Generate specific clarification questions"""
    
    questions = []
    
    for warning in validation_results['warnings']:
        if warning['check'] == 'VOLUME_SPIKE':
            questions.append({
                'type': 'volume_change',
                'product': warning['product'],
                'question': f"Your forecast for {warning['product']} is significantly higher than historical. "
                           f"Can you confirm this increase and share what's driving it? "
                           f"(e.g., new project, promotion, market expansion)"
            })
        
        elif warning['check'] == 'VOLUME_DROP':
            questions.append({
                'type': 'volume_change',
                'product': warning['product'],
                'question': f"Your forecast for {warning['product']} shows a significant decrease. "
                           f"Is this intentional? Are there any concerns we should be aware of?"
            })
        
        elif warning['check'] == 'FORECAST_CHANGE':
            questions.append({
                'type': 'change_from_previous',
                'product': warning['product'],
                'question': f"Your forecast for {warning['product']} has changed significantly from last month. "
                           f"What factors are driving this revision?"
            })
        
        elif warning['check'] == 'MISSING_PRODUCTS':
            questions.append({
                'type': 'missing_products',
                'question': "We noticed some products you typically order aren't in this forecast. "
                           "Should we assume no demand, or was this an oversight?"
            })
    
    return questions

def process_clarification_response(customer_id, session_id, response):
    """Process customer's clarification response"""
    
    # Parse response
    parsed = parse_clarification_response(response)
    
    # Update forecast if needed
    original_forecast = get_pending_forecast(customer_id)
    
    for update in parsed.get('updates', []):
        if update['type'] == 'confirm':
            # Customer confirmed the value - add assumption note
            add_forecast_note(original_forecast, update['product'], update['reason'])
        
        elif update['type'] == 'revise':
            # Customer wants to revise
            update_forecast_value(original_forecast, update['product'], update['new_value'])
        
        elif update['type'] == 'add':
            # Add missing product
            add_product_to_forecast(original_forecast, update['product'], update['values'])
    
    # Re-validate
    new_validation = validate_customer_forecast(original_forecast, customer_id)
    
    return {
        'status': 'clarified',
        'updates_applied': len(parsed.get('updates', [])),
        'new_validation': new_validation
    }
```

---

## Step 5: Aggregate Responses

### Consolidate by Product
```python
def aggregate_customer_forecasts(forecast_period):
    """Aggregate all customer forecasts into product-level view"""
    
    # Get all validated forecasts
    customer_forecasts = get_validated_forecasts(forecast_period)
    
    # Aggregate by product
    product_aggregates = {}
    
    for cf in customer_forecasts:
        customer_reliability = get_customer_reliability(cf['customer_id'])
        
        for product in cf['products']:
            product_id = product['product_id']
            
            if product_id not in product_aggregates:
                product_aggregates[product_id] = {
                    'product_id': product_id,
                    'product_name': product['product_name'],
                    'customer_forecasts': [],
                    'total_raw': np.zeros(len(product['periods'])),
                    'total_weighted': np.zeros(len(product['periods'])),
                    'customer_count': 0
                }
            
            product_aggregates[product_id]['customer_forecasts'].append({
                'customer_id': cf['customer_id'],
                'customer_name': cf['customer_name'],
                'forecast': product['periods'],
                'total': sum(product['periods']),
                'reliability': customer_reliability,
                'assumptions': product.get('assumptions')
            })
            
            product_aggregates[product_id]['total_raw'] += np.array(product['periods'])
            product_aggregates[product_id]['total_weighted'] += np.array(product['periods']) * customer_reliability
            product_aggregates[product_id]['customer_count'] += 1
    
    # Calculate coverage and statistics
    for product_id, agg in product_aggregates.items():
        total_customers = get_total_customers_for_product(product_id)
        agg['coverage'] = agg['customer_count'] / total_customers if total_customers > 0 else 0
        agg['coverage_by_volume'] = calculate_volume_coverage(product_id, agg['customer_forecasts'])
        
        # Normalize weighted forecast
        total_weight = sum(cf['reliability'] for cf in agg['customer_forecasts'])
        if total_weight > 0:
            agg['weighted_average'] = (agg['total_weighted'] / total_weight).tolist()
        else:
            agg['weighted_average'] = agg['total_raw'].tolist()
    
    return product_aggregates

def calculate_volume_coverage(product_id, customer_forecasts):
    """Calculate what % of historical volume is covered by forecasts"""
    
    historical_by_customer = get_historical_volume_by_customer(product_id)
    total_historical = sum(historical_by_customer.values())
    
    covered_volume = sum(
        historical_by_customer.get(cf['customer_id'], 0)
        for cf in customer_forecasts
    )
    
    return covered_volume / total_historical if total_historical > 0 else 0
```

---

## Step 6: Compare History

### Accuracy Analysis
```python
def analyze_customer_forecast_accuracy(customer_id, periods=12):
    """Analyze historical accuracy of customer forecasts"""
    
    # Get historical forecasts and actuals
    history = get_customer_forecast_history(customer_id, periods)
    
    accuracy_metrics = {
        'customer_id': customer_id,
        'periods_analyzed': len(history),
        'by_period': [],
        'overall': {}
    }
    
    all_forecasts = []
    all_actuals = []
    
    for period in history:
        forecast = period['forecast_total']
        actual = period['actual_total']
        
        all_forecasts.append(forecast)
        all_actuals.append(actual)
        
        accuracy_metrics['by_period'].append({
            'period': period['period'],
            'forecast': forecast,
            'actual': actual,
            'variance': actual - forecast,
            'variance_pct': (actual - forecast) / forecast * 100 if forecast > 0 else 0,
            'accuracy': 1 - abs(actual - forecast) / actual if actual > 0 else 0
        })
    
    # Calculate overall metrics
    accuracy_metrics['overall'] = {
        'wmape': calculate_wmape(all_actuals, all_forecasts),
        'bias': calculate_bias(all_actuals, all_forecasts),
        'accuracy_rate': np.mean([p['accuracy'] for p in accuracy_metrics['by_period']]),
        'trend': detect_accuracy_trend(accuracy_metrics['by_period']),
        'reliability_score': calculate_reliability_score(accuracy_metrics)
    }
    
    return accuracy_metrics

def calculate_reliability_score(accuracy_metrics):
    """Calculate overall reliability score (0-1)"""
    
    # Components of reliability
    accuracy_component = accuracy_metrics['overall'].get('accuracy_rate', 0.5)
    
    # Consistency (low variance in accuracy)
    accuracies = [p['accuracy'] for p in accuracy_metrics['by_period']]
    consistency = 1 - np.std(accuracies) if accuracies else 0.5
    
    # Bias penalty (penalize systematic over/under forecasting)
    bias = abs(accuracy_metrics['overall'].get('bias', 0))
    bias_penalty = max(0, 1 - bias * 2)  # Penalty kicks in above 50% bias
    
    # Weighted score
    reliability = (
        0.50 * accuracy_component +
        0.30 * consistency +
        0.20 * bias_penalty
    )
    
    return min(max(reliability, 0), 1)  # Bound between 0 and 1
```

---

## Step 7: Adjust Reliability

### Weight by Track Record
```python
def calculate_adjusted_forecast(product_aggregates):
    """Calculate reliability-adjusted forecasts"""
    
    adjusted_forecasts = {}
    
    for product_id, agg in product_aggregates.items():
        # If no customer forecasts, return zero
        if not agg['customer_forecasts']:
            adjusted_forecasts[product_id] = {
                'adjusted_forecast': [0] * 12,
                'confidence': 'Low',
                'method': 'no_data'
            }
            continue
        
        # Calculate reliability-weighted forecast
        weighted_sum = np.zeros(len(agg['weighted_average']))
        weight_total = 0
        
        for cf in agg['customer_forecasts']:
            reliability = cf['reliability']
            forecast = np.array(cf['forecast'])
            
            weighted_sum += forecast * reliability
            weight_total += reliability
        
        if weight_total > 0:
            adjusted = weighted_sum / weight_total
        else:
            adjusted = np.array(agg['weighted_average'])
        
        # Apply coverage adjustment
        coverage = agg['coverage_by_volume']
        if coverage < 1.0:
            # Scale up for missing customers
            scale_factor = 1 / coverage if coverage > 0.3 else 1 / 0.3
            adjusted = adjusted * scale_factor
        
        # Determine confidence
        confidence = determine_forecast_confidence(agg, coverage)
        
        adjusted_forecasts[product_id] = {
            'adjusted_forecast': adjusted.tolist(),
            'raw_forecast': agg['total_raw'].tolist(),
            'weighted_forecast': agg['weighted_average'],
            'coverage': coverage,
            'customer_count': agg['customer_count'],
            'confidence': confidence,
            'scale_factor': scale_factor if coverage < 1.0 else 1.0
        }
    
    return adjusted_forecasts

def determine_forecast_confidence(aggregate, coverage):
    """Determine confidence level based on coverage and reliability"""
    
    avg_reliability = np.mean([cf['reliability'] for cf in aggregate['customer_forecasts']])
    
    if coverage >= 0.8 and avg_reliability >= 0.8:
        return 'High'
    elif coverage >= 0.5 and avg_reliability >= 0.6:
        return 'Medium'
    else:
        return 'Low'
```

---

## Step 8: Share Back

### Customer Visibility
```python
def share_forecast_with_customers(adjusted_forecasts, product_aggregates):
    """Share consolidated forecast view back with customers"""
    
    for product_id, agg in product_aggregates.items():
        for cf in agg['customer_forecasts']:
            customer_id = cf['customer_id']
            
            # Generate customer-specific view
            customer_view = generate_customer_forecast_view(
                customer_id,
                product_id,
                cf,
                adjusted_forecasts[product_id]
            )
            
            # Share via customer preference
            share_method = get_customer_share_preference(customer_id)
            
            if share_method == 'portal':
                update_customer_portal(customer_id, customer_view)
            elif share_method == 'email':
                send_forecast_summary_email(customer_id, customer_view)
            elif share_method == 'api':
                push_to_customer_api(customer_id, customer_view)

def generate_customer_forecast_view(customer_id, product_id, customer_forecast, adjusted):
    """Generate customer-specific forecast view"""
    
    prompt = f"""
    Generate a brief forecast summary for customer sharing:
    
    CUSTOMER SUBMITTED: {sum(customer_forecast['forecast']):,.0f} units
    PLANNED FORECAST: {sum(adjusted['adjusted_forecast']):,.0f} units
    
    CONTEXT:
    - Customer reliability score: {customer_forecast['reliability']:.0%}
    - Total customers forecasting: {adjusted['customer_count']}
    - Overall coverage: {adjusted['coverage']:.0%}
    
    Write a 2-3 sentence summary that:
    1. Thanks them for the forecast submission
    2. Shares what we're planning (diplomatically if different)
    3. Invites questions or updates
    
    Be professional and collaborative.
    """
    
    summary = call_llm(prompt)
    
    return {
        'customer_id': customer_id,
        'product_id': product_id,
        'customer_submitted': customer_forecast['forecast'],
        'planned_forecast': adjusted['adjusted_forecast'],
        'variance': sum(adjusted['adjusted_forecast']) - sum(customer_forecast['forecast']),
        'summary': summary,
        'generated_at': datetime.now().isoformat()
    }

def track_forecast_submission_metrics():
    """Track customer forecast program metrics"""
    
    metrics = {
        'participation': {
            'invited': count_invited_customers(),
            'submitted': count_submitted_customers(),
            'rate': count_submitted_customers() / count_invited_customers()
        },
        'coverage': {
            'by_customer_count': calculate_customer_coverage(),
            'by_volume': calculate_volume_coverage_overall()
        },
        'quality': {
            'avg_reliability': calculate_avg_reliability(),
            'forecasts_with_assumptions': count_with_assumptions(),
            'clarifications_needed': count_clarifications()
        },
        'accuracy': {
            'last_cycle_wmape': get_last_cycle_accuracy(),
            'trend': get_accuracy_trend()
        }
    }
    
    return metrics
```

---

## Customer Forecast Bot Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  CUSTOMER FORECAST BOT DASHBOARD                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  COLLECTION STATUS: Aug-Oct 2026                                │
│  ─────────────────────────────────────────────────────────────  │
│  Invited:     150 customers                                      │
│  Submitted:   112 customers (75%)   █████████░░░                │
│  Validated:   108 customers                                      │
│  Pending:      38 customers                                      │
│                                                                  │
│  COVERAGE:                                                       │
│  ─────────────────────────────────────────────────────────────  │
│  By Customer Count: 75%                                          │
│  By Historical Volume: 82%          ████████████░░               │
│                                                                  │
│  VALIDATION STATUS:                                              │
│  ─────────────────────────────────────────────────────────────  │
│  ✓ Clean Submissions:    85                                      │
│  ⚠ Clarification Needed: 23                                      │
│  ✗ Errors to Fix:         4                                      │
│                                                                  │
│  TOP ANOMALIES FLAGGED:                                          │
│  1. Acme Corp: +250% volume spike on Widget Pro                 │
│  2. Beta Inc: Missing forecast for usual products               │
│  3. Gamma LLC: -60% drop vs last quarter                        │
│                                                                  │
│  BOT ACTIVITY (Last 24h):                                        │
│  ├── Outreach messages sent: 38                                 │
│  ├── Clarification sessions: 12                                 │
│  └── Responses processed: 45                                    │
│                                                                  │
│  RELIABILITY DISTRIBUTION:                                       │
│  High (>80%):   45 customers      ██████████                    │
│  Medium:        52 customers      ████████████                  │
│  Low (<60%):    15 customers      ████                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered customer forecast collection for improved demand accuracy.*
