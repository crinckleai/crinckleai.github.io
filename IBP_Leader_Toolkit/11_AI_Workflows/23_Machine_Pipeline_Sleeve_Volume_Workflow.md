# Machine Pipeline & Sleeve Volume Workflow
## AI-Powered Equipment-to-Consumables Demand Planning

---

## Business Model Context

Our business operates on an **Equipment + Consumables** model where:
- **Filling Machines** are contracted/placed with new or existing customers
- **Sleeves** (consumables) generate recurring revenue once machines are deployed
- Machine pipeline is the **leading indicator** for future sleeve demand

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    EQUIPMENT-TO-CONSUMABLES VALUE CHAIN                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  PIPELINE ──▶ CONTRACT ──▶ INSTALLATION ──▶ RAMP-UP ──▶ STEADY-STATE       │
│     │            │              │              │              │             │
│     ▼            ▼              ▼              ▼              ▼             │
│  Qualify      Close          Deploy         Initial        Recurring       │
│  Score        Win            Machine        Sleeve         Sleeve          │
│  Forecast     Revenue        Track          Orders         Volume          │
│                                                                              │
│  [─────── Machine Revenue ───────] [────── Sleeve Revenue Stream ──────]   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MACHINE PIPELINE & SLEEVE VOLUME WORKFLOW                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. PIPELINE│──▶│ 2. SCORE │───▶│ 3. PREDICT│──▶│ 4. TRACK │            │
│  │ CAPTURE  │    │ QUALIFY  │    │ TIMING   │    │ DEPLOYMENT│            │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   CRM/Sales        AI Scoring      ML Close         Installation          │
│   Integration      & Staging       Prediction       Monitoring            │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. FORECAST│─▶│ 6. OPTIMIZE│─▶│ 7. MONITOR│──▶│ 8. LEARN │            │
│  │ SLEEVE VOL│   │ INVENTORY│    │ CONSUMPTION│  │ IMPROVE  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   ML Volume         Sleeve         Customer         Model                 │
│   by Machine        Safety Stock   Usage Patterns   Refinement           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Pipeline Capture

### CRM/Sales Integration
```python
def capture_machine_pipeline():
    """Capture and sync machine opportunity pipeline"""
    
    pipeline = {
        'sync_timestamp': datetime.now(),
        'opportunities': [],
        'summary': {}
    }
    
    # Sync from CRM (Salesforce, Dynamics, etc.)
    crm_opps = sync_crm_opportunities(
        object_type='Machine_Opportunity',
        filters={'stage': 'not_closed_lost'}
    )
    
    for opp in crm_opps:
        # Enrich with additional data
        customer = get_customer_details(opp['customer_id'])
        machine_type = get_machine_specs(opp['machine_type_id'])
        
        opportunity = {
            'id': opp['id'],
            'name': opp['name'],
            'customer': {
                'id': customer['id'],
                'name': customer['name'],
                'industry': customer['industry'],
                'tier': customer['tier'],
                'existing_machines': get_installed_base(customer['id']),
                'current_sleeve_volume': get_current_sleeve_volume(customer['id'])
            },
            'machine': {
                'type': machine_type['name'],
                'model': machine_type['model'],
                'category': machine_type['category'],
                'capacity': machine_type['throughput_per_hour'],
                'sleeve_types': machine_type['compatible_sleeves'],
                'avg_sleeve_consumption': machine_type['avg_annual_sleeve_usage']
            },
            'deal': {
                'stage': opp['stage'],
                'stage_age_days': calculate_stage_age(opp),
                'amount': opp['amount'],
                'close_date': opp['expected_close_date'],
                'probability': opp['probability'],
                'owner': opp['owner'],
                'competitors': opp.get('competitors', []),
                'decision_makers': opp.get('decision_makers', [])
            },
            'deployment': {
                'expected_install_date': opp.get('install_date'),
                'site_location': opp.get('site_location'),
                'site_readiness': opp.get('site_readiness_status')
            }
        }
        
        pipeline['opportunities'].append(opportunity)
    
    # Calculate summary
    pipeline['summary'] = summarize_pipeline(pipeline['opportunities'])
    
    return pipeline

def summarize_pipeline(opportunities):
    """Summarize pipeline metrics"""
    
    summary = {
        'total_opportunities': len(opportunities),
        'total_value': sum(o['deal']['amount'] for o in opportunities),
        'weighted_value': sum(
            o['deal']['amount'] * o['deal']['probability'] / 100
            for o in opportunities
        ),
        'by_stage': {},
        'by_machine_type': {},
        'by_quarter': {},
        'potential_annual_sleeve_volume': 0
    }
    
    # By stage
    for opp in opportunities:
        stage = opp['deal']['stage']
        if stage not in summary['by_stage']:
            summary['by_stage'][stage] = {'count': 0, 'value': 0}
        summary['by_stage'][stage]['count'] += 1
        summary['by_stage'][stage]['value'] += opp['deal']['amount']
    
    # By machine type
    for opp in opportunities:
        mtype = opp['machine']['type']
        if mtype not in summary['by_machine_type']:
            summary['by_machine_type'][mtype] = {'count': 0, 'value': 0}
        summary['by_machine_type'][mtype]['count'] += 1
        summary['by_machine_type'][mtype]['value'] += opp['deal']['amount']
    
    # Potential sleeve volume
    for opp in opportunities:
        annual_sleeves = opp['machine']['avg_sleeve_consumption']
        probability = opp['deal']['probability'] / 100
        summary['potential_annual_sleeve_volume'] += annual_sleeves * probability
    
    return summary
```

---

## Step 2: Score & Qualify

### AI Opportunity Scoring
```python
from sklearn.ensemble import GradientBoostingClassifier
import numpy as np

def score_machine_opportunities(pipeline):
    """AI scoring of machine opportunities"""
    
    scored = []
    
    for opp in pipeline['opportunities']:
        # Extract features
        features = extract_opportunity_features(opp)
        
        # Get AI scores
        scores = {
            'win_probability': predict_win_probability(features),
            'timing_score': predict_timing_accuracy(opp),
            'volume_potential': score_sleeve_volume_potential(opp),
            'strategic_fit': score_strategic_fit(opp),
            'risk_score': assess_opportunity_risk(opp)
        }
        
        # Composite score
        scores['composite'] = (
            scores['win_probability'] * 0.35 +
            scores['volume_potential'] * 0.30 +
            scores['strategic_fit'] * 0.20 +
            (1 - scores['risk_score']) * 0.15
        )
        
        # Staging recommendation
        scores['recommended_stage'] = recommend_stage(opp, scores)
        
        scored.append({
            **opp,
            'ai_scores': scores,
            'score_date': datetime.now()
        })
    
    return sorted(scored, key=lambda x: x['ai_scores']['composite'], reverse=True)

def extract_opportunity_features(opp):
    """Extract ML features from opportunity"""
    
    features = {
        # Customer features
        'customer_tier': encode_tier(opp['customer']['tier']),
        'existing_machines': opp['customer']['existing_machines'],
        'current_sleeve_volume': opp['customer']['current_sleeve_volume'],
        'customer_tenure': get_customer_tenure(opp['customer']['id']),
        'payment_history': get_payment_score(opp['customer']['id']),
        
        # Machine features
        'machine_capacity': opp['machine']['capacity'],
        'machine_price': opp['deal']['amount'],
        'compatible_sleeve_types': len(opp['machine']['sleeve_types']),
        
        # Deal features
        'stage_numeric': encode_stage(opp['deal']['stage']),
        'stage_age_days': opp['deal']['stage_age_days'],
        'days_to_close': (opp['deal']['close_date'] - datetime.now()).days,
        'sales_rep_win_rate': get_rep_win_rate(opp['deal']['owner']),
        'competitor_count': len(opp['deal']['competitors']),
        'decision_maker_engaged': len(opp['deal']['decision_makers']) > 0,
        
        # Historical patterns
        'similar_deal_win_rate': get_similar_deal_win_rate(opp),
        'industry_win_rate': get_industry_win_rate(opp['customer']['industry'])
    }
    
    return list(features.values())

def predict_win_probability(features):
    """ML prediction of win probability"""
    
    model = load_model('machine_opportunity_win_predictor')
    probability = model.predict_proba([features])[0, 1]
    
    return probability

def score_sleeve_volume_potential(opp):
    """Score potential sleeve volume from opportunity"""
    
    base_volume = opp['machine']['avg_sleeve_consumption']
    
    # Adjust based on customer profile
    adjustments = 1.0
    
    # High-volume customers tend to use more
    if opp['customer']['tier'] == 'A':
        adjustments *= 1.2
    
    # Multiple machines = efficiency learning curve
    if opp['customer']['existing_machines'] > 3:
        adjustments *= 1.1
    
    # Industry factors
    industry_factor = get_industry_consumption_factor(opp['customer']['industry'])
    adjustments *= industry_factor
    
    potential_volume = base_volume * adjustments
    
    # Normalize to 0-1 score
    max_volume = get_max_annual_sleeve_volume()
    score = min(potential_volume / max_volume, 1.0)
    
    return score

def recommend_stage(opp, scores):
    """AI recommendation for pipeline stage"""
    
    current_stage = opp['deal']['stage']
    win_prob = scores['win_probability']
    
    stage_thresholds = {
        'Qualification': 0.10,
        'Needs Analysis': 0.25,
        'Proposal': 0.45,
        'Negotiation': 0.65,
        'Commit': 0.85
    }
    
    recommended = 'Qualification'
    for stage, threshold in stage_thresholds.items():
        if win_prob >= threshold:
            recommended = stage
    
    return {
        'current': current_stage,
        'recommended': recommended,
        'aligned': current_stage == recommended,
        'confidence': abs(win_prob - get_stage_threshold(current_stage))
    }
```

---

## Step 3: Predict Timing

### ML Close & Deployment Prediction
```python
def predict_deal_timing(scored_opportunities):
    """Predict close date and deployment timing"""
    
    predictions = []
    
    for opp in scored_opportunities:
        # Close date prediction
        close_prediction = predict_close_date(opp)
        
        # Deployment timing prediction
        deploy_prediction = predict_deployment_date(opp, close_prediction)
        
        # Sleeve ramp-up prediction
        ramp_prediction = predict_sleeve_rampup(opp, deploy_prediction)
        
        predictions.append({
            'opportunity_id': opp['id'],
            'close_date': {
                'current_expected': opp['deal']['close_date'],
                'ai_predicted': close_prediction['date'],
                'confidence_interval': close_prediction['ci'],
                'probability_on_time': close_prediction['prob_on_time']
            },
            'deployment_date': {
                'current_expected': opp['deployment']['expected_install_date'],
                'ai_predicted': deploy_prediction['date'],
                'confidence_interval': deploy_prediction['ci'],
                'days_after_close': deploy_prediction['lead_time']
            },
            'sleeve_ramp': {
                'month_1_pct': ramp_prediction['month_1'],
                'month_3_pct': ramp_prediction['month_3'],
                'time_to_steady_state': ramp_prediction['months_to_steady'],
                'steady_state_volume': ramp_prediction['steady_monthly']
            }
        })
    
    return predictions

def predict_close_date(opp):
    """ML prediction of deal close date"""
    
    features = {
        'current_stage': encode_stage(opp['deal']['stage']),
        'stage_age': opp['deal']['stage_age_days'],
        'expected_days_to_close': (opp['deal']['close_date'] - datetime.now()).days,
        'win_probability': opp['ai_scores']['win_probability'],
        'customer_decision_speed': get_customer_decision_speed(opp['customer']['id']),
        'deal_complexity': calculate_deal_complexity(opp),
        'quarter_end_proximity': get_quarter_end_proximity()
    }
    
    model = load_model('close_date_predictor')
    predicted_days = model.predict([list(features.values())])[0]
    
    # Calculate confidence interval
    ci = calculate_date_confidence_interval(model, features, predicted_days)
    
    predicted_date = datetime.now() + timedelta(days=int(predicted_days))
    
    return {
        'date': predicted_date,
        'ci': ci,
        'prob_on_time': calculate_on_time_probability(predicted_date, opp['deal']['close_date'])
    }

def predict_deployment_date(opp, close_prediction):
    """Predict machine deployment/installation date"""
    
    # Base lead time by machine type
    base_lead_time = get_machine_lead_time(opp['machine']['type'])
    
    # Adjust for customer readiness
    readiness = opp['deployment'].get('site_readiness', 'Unknown')
    readiness_adjustments = {
        'Ready': 0.8,
        'In Progress': 1.0,
        'Not Started': 1.3,
        'Unknown': 1.2
    }
    adjusted_lead_time = base_lead_time * readiness_adjustments.get(readiness, 1.2)
    
    # Adjust for historical patterns with this customer
    customer_install_history = get_customer_installation_history(opp['customer']['id'])
    if customer_install_history:
        historical_avg = np.mean([h['actual_lead_time'] for h in customer_install_history])
        adjusted_lead_time = 0.6 * adjusted_lead_time + 0.4 * historical_avg
    
    predicted_date = close_prediction['date'] + timedelta(days=int(adjusted_lead_time))
    
    return {
        'date': predicted_date,
        'lead_time': int(adjusted_lead_time),
        'ci': (int(adjusted_lead_time * 0.8), int(adjusted_lead_time * 1.3))
    }

def predict_sleeve_rampup(opp, deploy_prediction):
    """Predict sleeve consumption ramp-up pattern"""
    
    machine_type = opp['machine']['type']
    customer_profile = opp['customer']
    
    # Get typical ramp-up curve for this machine type
    base_curve = get_machine_rampup_curve(machine_type)
    
    # Adjust for customer experience
    if customer_profile['existing_machines'] > 0:
        # Experienced customer - faster ramp
        ramp_factor = 1.2
    else:
        # New customer - slower ramp
        ramp_factor = 0.8
    
    # Calculate monthly volumes
    steady_state = opp['machine']['avg_sleeve_consumption'] / 12  # Monthly
    
    return {
        'month_1': base_curve['month_1'] * ramp_factor,
        'month_3': base_curve['month_3'] * ramp_factor,
        'months_to_steady': int(base_curve['months_to_steady'] / ramp_factor),
        'steady_monthly': steady_state,
        'curve': [min(steady_state * base_curve[f'month_{m}'] * ramp_factor, steady_state) 
                  for m in range(1, 13)]
    }
```

---

## Step 4: Track Deployment

### Installation Monitoring
```python
def track_machine_deployments():
    """Track machine installation and deployment status"""
    
    # Get machines in deployment pipeline
    deploying = get_machines_in_deployment()
    
    deployment_status = []
    
    for machine in deploying:
        status = {
            'machine_id': machine['id'],
            'customer': machine['customer'],
            'machine_type': machine['machine_type'],
            'status': {
                'current_stage': machine['deployment_stage'],
                'expected_live_date': machine['expected_live_date'],
                'days_to_live': (machine['expected_live_date'] - datetime.now()).days,
                'completion_pct': calculate_deployment_completion(machine)
            },
            'milestones': track_deployment_milestones(machine),
            'risks': identify_deployment_risks(machine),
            'sleeve_readiness': check_sleeve_readiness(machine)
        }
        
        deployment_status.append(status)
    
    # Generate alerts
    alerts = generate_deployment_alerts(deployment_status)
    
    return {
        'deployments': deployment_status,
        'summary': summarize_deployments(deployment_status),
        'alerts': alerts
    }

def track_deployment_milestones(machine):
    """Track key deployment milestones"""
    
    milestones = [
        {'name': 'Contract Signed', 'target': machine['contract_date'], 'actual': machine['contract_date'], 'status': 'COMPLETE'},
        {'name': 'Site Survey', 'target': machine['site_survey_target'], 'actual': machine.get('site_survey_actual'), 'status': None},
        {'name': 'Equipment Shipped', 'target': machine['ship_target'], 'actual': machine.get('ship_actual'), 'status': None},
        {'name': 'Installation Start', 'target': machine['install_start_target'], 'actual': machine.get('install_start_actual'), 'status': None},
        {'name': 'Installation Complete', 'target': machine['install_complete_target'], 'actual': machine.get('install_complete_actual'), 'status': None},
        {'name': 'Training Complete', 'target': machine['training_target'], 'actual': machine.get('training_actual'), 'status': None},
        {'name': 'Go Live', 'target': machine['go_live_target'], 'actual': machine.get('go_live_actual'), 'status': None}
    ]
    
    # Update status
    for milestone in milestones:
        if milestone['actual']:
            if milestone['actual'] <= milestone['target']:
                milestone['status'] = 'ON_TIME'
            else:
                milestone['status'] = 'LATE'
        elif milestone['target'] < datetime.now():
            milestone['status'] = 'OVERDUE'
        elif milestone['target'] < datetime.now() + timedelta(days=7):
            milestone['status'] = 'DUE_SOON'
        else:
            milestone['status'] = 'UPCOMING'
    
    return milestones

def check_sleeve_readiness(machine):
    """Check sleeve inventory readiness for machine deployment"""
    
    compatible_sleeves = machine['compatible_sleeves']
    customer_id = machine['customer_id']
    expected_live = machine['expected_live_date']
    
    readiness = {
        'overall': 'GREEN',
        'by_sleeve': []
    }
    
    for sleeve_id in compatible_sleeves:
        # Estimate initial requirement
        initial_requirement = estimate_initial_sleeve_order(machine, sleeve_id)
        
        # Check inventory
        available = get_available_inventory(sleeve_id)
        incoming = get_incoming_supply(sleeve_id, expected_live)
        
        sleeve_status = {
            'sleeve_id': sleeve_id,
            'sleeve_name': get_product_name(sleeve_id),
            'initial_requirement': initial_requirement,
            'available_now': available,
            'incoming_by_live': incoming,
            'total_available': available + incoming,
            'gap': initial_requirement - (available + incoming),
            'status': 'GREEN' if available + incoming >= initial_requirement else 'RED'
        }
        
        readiness['by_sleeve'].append(sleeve_status)
        
        if sleeve_status['status'] == 'RED':
            readiness['overall'] = 'RED'
    
    return readiness

def generate_deployment_alerts(deployment_status):
    """Generate alerts for deployment issues"""
    
    alerts = []
    
    for deployment in deployment_status:
        # Overdue milestones
        overdue = [m for m in deployment['milestones'] if m['status'] == 'OVERDUE']
        if overdue:
            alerts.append({
                'type': 'MILESTONE_OVERDUE',
                'severity': 'HIGH',
                'machine': deployment['machine_id'],
                'customer': deployment['customer'],
                'message': f"{len(overdue)} milestones overdue: {[m['name'] for m in overdue]}"
            })
        
        # Sleeve readiness
        if deployment['sleeve_readiness']['overall'] == 'RED':
            alerts.append({
                'type': 'SLEEVE_SHORTAGE',
                'severity': 'HIGH',
                'machine': deployment['machine_id'],
                'customer': deployment['customer'],
                'message': 'Sleeve inventory not ready for go-live'
            })
        
        # High risk deployments
        high_risks = [r for r in deployment['risks'] if r['severity'] == 'HIGH']
        if high_risks:
            alerts.append({
                'type': 'DEPLOYMENT_RISK',
                'severity': 'MEDIUM',
                'machine': deployment['machine_id'],
                'risks': high_risks
            })
    
    return alerts
```

---

## Step 5: Forecast Sleeve Volume

### ML Volume by Machine
```python
def forecast_sleeve_volume(pipeline, deployments, installed_base):
    """ML-based sleeve volume forecasting"""
    
    forecast = {
        'period': get_forecast_period(),
        'generated_at': datetime.now(),
        'components': {},
        'total': {}
    }
    
    # Component 1: Existing installed base
    base_forecast = forecast_installed_base_volume(installed_base)
    forecast['components']['installed_base'] = base_forecast
    
    # Component 2: Machines in deployment (committed)
    deployment_forecast = forecast_deploying_machines(deployments)
    forecast['components']['deploying'] = deployment_forecast
    
    # Component 3: Pipeline opportunities (probability-weighted)
    pipeline_forecast = forecast_pipeline_volume(pipeline)
    forecast['components']['pipeline'] = pipeline_forecast
    
    # Aggregate total forecast
    forecast['total'] = aggregate_sleeve_forecast(forecast['components'])
    
    # By sleeve type
    forecast['by_sleeve_type'] = aggregate_by_sleeve_type(forecast['components'])
    
    # By customer
    forecast['by_customer'] = aggregate_by_customer(forecast['components'])
    
    return forecast

def forecast_installed_base_volume(installed_base):
    """Forecast sleeve volume from installed machine base"""
    
    forecasts = []
    
    for machine in installed_base:
        # Get historical consumption
        history = get_machine_sleeve_history(machine['id'])
        
        if len(history) >= 6:
            # Enough history - use ML
            features = extract_consumption_features(machine, history)
            model = load_model('sleeve_consumption_predictor')
            predicted = model.predict([features])[0]
            
            # Add trend adjustment
            trend = calculate_consumption_trend(history)
            adjusted = predicted * (1 + trend)
        else:
            # Use machine type average
            avg = get_machine_type_avg_consumption(machine['machine_type'])
            adjusted = avg * get_customer_factor(machine['customer_id'])
        
        forecasts.append({
            'machine_id': machine['id'],
            'customer_id': machine['customer_id'],
            'machine_type': machine['machine_type'],
            'monthly_forecast': [adjusted] * 12,  # Monthly
            'annual_forecast': adjusted * 12,
            'confidence': 'HIGH' if len(history) >= 12 else 'MEDIUM',
            'sleeve_mix': get_sleeve_mix(machine['id'])
        })
    
    return {
        'machines': forecasts,
        'total_annual': sum(f['annual_forecast'] for f in forecasts),
        'total_monthly': [
            sum(f['monthly_forecast'][m] for f in forecasts)
            for m in range(12)
        ]
    }

def forecast_deploying_machines(deployments):
    """Forecast sleeve volume from machines in deployment"""
    
    forecasts = []
    
    for deployment in deployments:
        # Get expected go-live date
        go_live = deployment['status']['expected_live_date']
        
        # Get ramp-up curve
        ramp = predict_sleeve_rampup_for_machine(deployment)
        
        # Build monthly forecast
        monthly = []
        for month in range(12):
            month_date = datetime.now() + timedelta(days=30*month)
            
            if month_date < go_live:
                monthly.append(0)
            else:
                months_since_live = (month_date - go_live).days // 30
                if months_since_live < len(ramp['curve']):
                    monthly.append(ramp['curve'][months_since_live])
                else:
                    monthly.append(ramp['steady_monthly'])
        
        forecasts.append({
            'machine_id': deployment['machine_id'],
            'customer_id': deployment['customer']['id'],
            'go_live_date': go_live,
            'monthly_forecast': monthly,
            'annual_forecast': sum(monthly),
            'confidence': 'MEDIUM',  # Not yet producing
            'ramp_up_months': ramp['months_to_steady']
        })
    
    return {
        'machines': forecasts,
        'total_annual': sum(f['annual_forecast'] for f in forecasts),
        'total_monthly': [
            sum(f['monthly_forecast'][m] for f in forecasts)
            for m in range(12)
        ]
    }

def forecast_pipeline_volume(pipeline):
    """Forecast sleeve volume from pipeline opportunities"""
    
    forecasts = []
    
    for opp in pipeline['opportunities']:
        # Win probability
        win_prob = opp['ai_scores']['win_probability']
        
        # Expected timing
        timing = opp.get('timing_prediction', {})
        expected_close = timing.get('close_date', {}).get('ai_predicted', opp['deal']['close_date'])
        expected_deploy = timing.get('deployment_date', {}).get('ai_predicted')
        
        if not expected_deploy:
            # Estimate deployment
            lead_time = get_machine_lead_time(opp['machine']['type'])
            expected_deploy = expected_close + timedelta(days=lead_time)
        
        # Ramp-up curve
        ramp = timing.get('sleeve_ramp', predict_sleeve_rampup(opp, {'date': expected_deploy}))
        
        # Build probability-weighted monthly forecast
        monthly = []
        for month in range(12):
            month_date = datetime.now() + timedelta(days=30*month)
            
            if month_date < expected_deploy:
                monthly.append(0)
            else:
                months_since_live = (month_date - expected_deploy).days // 30
                if months_since_live < len(ramp['curve']):
                    base_vol = ramp['curve'][months_since_live]
                else:
                    base_vol = ramp['steady_monthly']
                
                # Apply win probability
                monthly.append(base_vol * win_prob)
        
        forecasts.append({
            'opportunity_id': opp['id'],
            'customer_id': opp['customer']['id'],
            'win_probability': win_prob,
            'expected_close': expected_close,
            'expected_deploy': expected_deploy,
            'monthly_forecast': monthly,
            'annual_forecast': sum(monthly),
            'confidence': 'LOW'  # Pipeline, not committed
        })
    
    return {
        'opportunities': forecasts,
        'total_annual': sum(f['annual_forecast'] for f in forecasts),
        'total_monthly': [
            sum(f['monthly_forecast'][m] for f in forecasts)
            for m in range(12)
        ],
        'probability_note': 'Volumes are probability-weighted by win likelihood'
    }
```

---

## Step 6: Optimize Inventory

### Sleeve Safety Stock
```python
def optimize_sleeve_inventory(sleeve_forecast):
    """Optimize sleeve inventory based on machine pipeline"""
    
    optimization = {
        'by_sleeve': {},
        'recommendations': []
    }
    
    # Get all sleeve types
    sleeve_types = get_all_sleeve_types()
    
    for sleeve in sleeve_types:
        sleeve_id = sleeve['id']
        
        # Get demand forecast
        demand = extract_sleeve_demand(sleeve_forecast, sleeve_id)
        
        # Calculate variability
        variability = calculate_demand_variability(sleeve_id, demand)
        
        # Get lead time
        lead_time = get_sleeve_lead_time(sleeve_id)
        lead_time_var = get_lead_time_variability(sleeve_id)
        
        # Target service level (based on machine criticality)
        service_level = get_sleeve_service_target(sleeve_id)
        z_score = get_z_score(service_level)
        
        # Calculate safety stock
        safety_stock = z_score * np.sqrt(
            lead_time * variability['demand_std']**2 +
            demand['avg_monthly']**2 * lead_time_var**2
        )
        
        # Reorder point
        rop = (demand['avg_monthly'] * lead_time / 30) + safety_stock
        
        # Current position
        current = get_current_inventory(sleeve_id)
        
        optimization['by_sleeve'][sleeve_id] = {
            'sleeve_name': sleeve['name'],
            'avg_monthly_demand': demand['avg_monthly'],
            'demand_variability_cv': variability['cv'],
            'service_level': service_level,
            'safety_stock_units': safety_stock,
            'safety_stock_days': safety_stock / demand['avg_daily'] if demand['avg_daily'] > 0 else 0,
            'reorder_point': rop,
            'current_inventory': current,
            'status': 'OK' if current > rop else 'REORDER' if current > safety_stock else 'CRITICAL'
        }
        
        # Recommendations
        if current < safety_stock:
            optimization['recommendations'].append({
                'sleeve_id': sleeve_id,
                'type': 'EXPEDITE',
                'urgency': 'HIGH',
                'message': f"Inventory below safety stock - expedite {safety_stock - current:.0f} units"
            })
        elif current < rop:
            optimization['recommendations'].append({
                'sleeve_id': sleeve_id,
                'type': 'REORDER',
                'urgency': 'MEDIUM',
                'message': f"Below reorder point - place order for standard quantity"
            })
    
    # Coordinate with machine deployments
    deployment_requirements = calculate_deployment_requirements(sleeve_forecast)
    optimization['deployment_requirements'] = deployment_requirements
    
    return optimization

def calculate_deployment_requirements(sleeve_forecast):
    """Calculate sleeve requirements for upcoming deployments"""
    
    requirements = []
    
    deploying = sleeve_forecast['components']['deploying']['machines']
    
    for machine in deploying:
        # Initial stocking requirement (first 3 months)
        initial_months = machine['monthly_forecast'][:3]
        initial_requirement = sum(initial_months) * 1.2  # 20% buffer
        
        requirements.append({
            'machine_id': machine['machine_id'],
            'customer_id': machine['customer_id'],
            'go_live_date': machine['go_live_date'],
            'initial_requirement': initial_requirement,
            'by_sleeve_type': calculate_sleeve_mix_requirement(machine, initial_requirement)
        })
    
    return requirements
```

---

## Step 7: Monitor Consumption

### Customer Usage Patterns
```python
def monitor_sleeve_consumption():
    """Monitor actual sleeve consumption patterns"""
    
    monitoring = {
        'timestamp': datetime.now(),
        'by_customer': {},
        'by_machine': {},
        'anomalies': [],
        'trends': {}
    }
    
    # Get all active machines
    active_machines = get_active_machine_base()
    
    for machine in active_machines:
        # Get recent consumption
        recent = get_recent_consumption(machine['id'], months=3)
        forecast = get_machine_forecast(machine['id'])
        
        # Calculate metrics
        actual_monthly = np.mean(recent) if recent else 0
        forecast_monthly = forecast['monthly_avg'] if forecast else machine['expected_consumption']
        
        variance = (actual_monthly - forecast_monthly) / forecast_monthly if forecast_monthly > 0 else 0
        
        monitoring['by_machine'][machine['id']] = {
            'customer_id': machine['customer_id'],
            'machine_type': machine['machine_type'],
            'actual_monthly': actual_monthly,
            'forecast_monthly': forecast_monthly,
            'variance_pct': variance * 100,
            'trend': calculate_consumption_trend(recent),
            'status': classify_consumption_status(variance)
        }
        
        # Detect anomalies
        if abs(variance) > 0.30:
            monitoring['anomalies'].append({
                'machine_id': machine['id'],
                'customer': get_customer_name(machine['customer_id']),
                'variance': variance * 100,
                'type': 'OVER_CONSUMING' if variance > 0 else 'UNDER_CONSUMING',
                'investigation': suggest_investigation(machine, variance)
            })
    
    # Aggregate by customer
    customers = set(m['customer_id'] for m in active_machines)
    for customer_id in customers:
        customer_machines = [m for m in active_machines if m['customer_id'] == customer_id]
        
        actual_total = sum(
            monitoring['by_machine'][m['id']]['actual_monthly']
            for m in customer_machines
        )
        forecast_total = sum(
            monitoring['by_machine'][m['id']]['forecast_monthly']
            for m in customer_machines
        )
        
        monitoring['by_customer'][customer_id] = {
            'customer_name': get_customer_name(customer_id),
            'machine_count': len(customer_machines),
            'actual_monthly': actual_total,
            'forecast_monthly': forecast_total,
            'variance_pct': (actual_total - forecast_total) / forecast_total * 100 if forecast_total > 0 else 0
        }
    
    # Overall trends
    monitoring['trends'] = calculate_overall_trends(monitoring['by_machine'])
    
    return monitoring

def suggest_investigation(machine, variance):
    """AI-suggested investigation for consumption anomaly"""
    
    if variance > 0.30:
        # Over-consuming
        return [
            "Check for production volume increase at customer",
            "Verify sleeve compatibility and waste rate",
            "Review recent orders for bulk/stocking behavior",
            "Consider upgrading forecast for this machine"
        ]
    else:
        # Under-consuming
        return [
            "Verify machine is operational",
            "Check for customer production issues",
            "Review competitive activity",
            "Contact customer to understand situation"
        ]

def classify_consumption_status(variance):
    """Classify consumption status"""
    
    if variance > 0.30:
        return 'HIGH'
    elif variance > 0.10:
        return 'ABOVE_PLAN'
    elif variance < -0.30:
        return 'CRITICAL_LOW'
    elif variance < -0.10:
        return 'BELOW_PLAN'
    else:
        return 'ON_PLAN'
```

---

## Step 8: Learn & Improve

### Model Refinement
```python
def learn_from_outcomes():
    """Learn from actual outcomes to improve predictions"""
    
    learnings = {
        'win_prediction': evaluate_win_predictions(),
        'timing_prediction': evaluate_timing_predictions(),
        'volume_prediction': evaluate_volume_predictions(),
        'model_updates': []
    }
    
    return learnings

def evaluate_win_predictions():
    """Evaluate accuracy of win predictions"""
    
    # Get closed opportunities from last 12 months
    closed = get_closed_opportunities(months=12)
    
    accuracy = {
        'total': len(closed),
        'won': sum(1 for o in closed if o['outcome'] == 'WON'),
        'lost': sum(1 for o in closed if o['outcome'] == 'LOST'),
        'by_probability_bucket': {}
    }
    
    # Analyze by predicted probability bucket
    buckets = [(0, 0.2), (0.2, 0.4), (0.4, 0.6), (0.6, 0.8), (0.8, 1.0)]
    
    for low, high in buckets:
        bucket_opps = [o for o in closed if low <= o['predicted_win_prob'] < high]
        if bucket_opps:
            actual_win_rate = sum(1 for o in bucket_opps if o['outcome'] == 'WON') / len(bucket_opps)
            predicted_avg = np.mean([o['predicted_win_prob'] for o in bucket_opps])
            
            accuracy['by_probability_bucket'][f"{int(low*100)}-{int(high*100)}%"] = {
                'count': len(bucket_opps),
                'actual_win_rate': actual_win_rate,
                'predicted_avg': predicted_avg,
                'calibration_error': actual_win_rate - predicted_avg
            }
    
    # Overall metrics
    y_true = [1 if o['outcome'] == 'WON' else 0 for o in closed]
    y_pred = [o['predicted_win_prob'] for o in closed]
    
    accuracy['brier_score'] = calculate_brier_score(y_true, y_pred)
    accuracy['auc'] = calculate_auc(y_true, y_pred)
    
    return accuracy

def evaluate_volume_predictions():
    """Evaluate accuracy of sleeve volume predictions"""
    
    # Get machines that have been live for at least 6 months
    mature_machines = get_mature_machines(min_months=6)
    
    accuracy = {
        'total_machines': len(mature_machines),
        'by_machine_type': {},
        'overall': {}
    }
    
    predictions = []
    actuals = []
    
    for machine in mature_machines:
        # Get original volume prediction
        original_pred = get_original_volume_prediction(machine['id'])
        
        # Get actual consumption
        actual_monthly = get_actual_monthly_consumption(machine['id'])
        actual_avg = np.mean(actual_monthly)
        
        if original_pred:
            predictions.append(original_pred['predicted_monthly'])
            actuals.append(actual_avg)
    
    # Calculate accuracy metrics
    if predictions:
        accuracy['overall'] = {
            'mape': calculate_mape(actuals, predictions),
            'bias': calculate_bias(actuals, predictions),
            'correlation': np.corrcoef(actuals, predictions)[0, 1]
        }
    
    return accuracy

def update_prediction_models(learnings):
    """Update prediction models based on learnings"""
    
    updates = []
    
    # Check win prediction calibration
    win_accuracy = learnings['win_prediction']
    for bucket, metrics in win_accuracy.get('by_probability_bucket', {}).items():
        if abs(metrics['calibration_error']) > 0.15:
            updates.append({
                'model': 'win_predictor',
                'type': 'calibration',
                'bucket': bucket,
                'adjustment': -metrics['calibration_error']
            })
    
    # Check volume prediction bias
    vol_accuracy = learnings['volume_prediction']['overall']
    if abs(vol_accuracy.get('bias', 0)) > 0.10:
        updates.append({
            'model': 'volume_predictor',
            'type': 'bias_correction',
            'current_bias': vol_accuracy['bias'],
            'action': 'Retrain with recent data'
        })
    
    # Trigger retraining if needed
    for update in updates:
        if update['type'] == 'bias_correction':
            retrain_model(update['model'])
    
    return updates
```

---

## Machine Pipeline Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  MACHINE PIPELINE & SLEEVE VOLUME DASHBOARD                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  MACHINE PIPELINE SUMMARY                                        │
│  ─────────────────────────────────────────────────────────────  │
│  Total Opportunities: 45    │  Value: $8.2M                     │
│  Weighted Pipeline: $4.8M   │  Potential Sleeves: 2.1M units/yr │
│                                                                  │
│  BY STAGE:                                                       │
│  Qualification    ████████████     12 opps │ $1.8M              │
│  Needs Analysis   ██████████       10 opps │ $2.1M              │
│  Proposal         ████████          8 opps │ $1.9M              │
│  Negotiation      ██████            6 opps │ $1.5M              │
│  Commit           █████             5 opps │ $0.9M              │
│                                                                  │
│  TOP OPPORTUNITIES (by AI Score):                                │
│  ─────────────────────────────────────────────────────────────  │
│  1. Acme Foods (HF-3000)     │ 85% win │ $180K │ 45K sleeves/yr │
│  2. Beta Dairy (HF-2500)     │ 78% win │ $140K │ 35K sleeves/yr │
│  3. Gamma Beverage (HF-5000) │ 72% win │ $250K │ 80K sleeves/yr │
│                                                                  │
│  DEPLOYMENTS IN PROGRESS: 8 machines                             │
│  ─────────────────────────────────────────────────────────────  │
│  ✓ On Track: 5  │  ⚠ At Risk: 2  │  🔴 Delayed: 1              │
│                                                                  │
│  Next Go-Live: Acme Foods (Jun 15) - Sleeves Ready ✓            │
│                                                                  │
│  SLEEVE VOLUME FORECAST (12 months):                             │
│  ─────────────────────────────────────────────────────────────  │
│  Installed Base:    4.2M units  ████████████████████  (78%)     │
│  Deploying:         0.8M units  ████                  (15%)     │
│  Pipeline (wtd):    0.4M units  ██                    (7%)      │
│  ─────────────────────────────────────────────────────────────  │
│  TOTAL FORECAST:    5.4M units                                   │
│                                                                  │
│  CONSUMPTION MONITORING:                                         │
│  ─────────────────────────────────────────────────────────────  │
│  Machines On Plan:     85%  █████████████████░░░                │
│  Above Plan:           10%  (investigate capacity increase)     │
│  Below Plan:            5%  (investigate issues)                │
│                                                                  │
│  [View Pipeline] [Track Deployments] [Forecast Details]         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered machine pipeline management for accurate sleeve volume forecasting.*
