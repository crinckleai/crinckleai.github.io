# Auto P&L Generation Workflow
## AI-Powered Financial Translation from Volume Plans

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    AUTO P&L GENERATION WORKFLOW                              │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. LOAD  │───▶│ 2. APPLY │───▶│ 3. CALC  │───▶│ 4. BUILD │            │
│  │ VOLUMES  │    │ PRICING  │    │ COSTS    │    │ P&L      │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Consensus        Price &         Variable &      Full Income           │
│   Forecast         Mix Calcs       Fixed Costs     Statement             │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. COMPARE│───▶│ 6. BRIDGE│───▶│ 7. VALIDATE│─▶│ 8. PUBLISH│           │
│  │ TO PLAN  │    │ VARIANCE │    │ & APPROVE │    │ DISTRIBUTE│            │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Plan vs         Waterfall        AI Sanity       System                │
│   Forecast        Analysis         Checks          Integration           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Load Volumes

### Volume Plan Integration
```python
def load_volume_plan(forecast_period, version='consensus'):
    """Load approved volume plan for P&L generation"""
    
    volumes = {
        'period': forecast_period,
        'version': version,
        'loaded_at': datetime.now(),
        'products': {},
        'aggregations': {}
    }
    
    # Load product-level volumes
    forecast = get_consensus_forecast(forecast_period, version)
    
    for product_id, product_forecast in forecast.items():
        product = get_product(product_id)
        
        volumes['products'][product_id] = {
            'product_name': product['name'],
            'category': product['category'],
            'brand': product['brand'],
            'region': product.get('primary_region'),
            'monthly_volumes': product_forecast['periods'],
            'total_volume': sum(product_forecast['periods']),
            'units': product.get('uom', 'units')
        }
    
    # Pre-calculate aggregations
    volumes['aggregations'] = {
        'by_category': aggregate_by_dimension(volumes['products'], 'category'),
        'by_brand': aggregate_by_dimension(volumes['products'], 'brand'),
        'by_region': aggregate_by_dimension(volumes['products'], 'region'),
        'total': sum(p['total_volume'] for p in volumes['products'].values())
    }
    
    return volumes

def validate_volume_plan(volumes):
    """Validate volume plan before P&L generation"""
    
    validation = {
        'passed': True,
        'checks': [],
        'warnings': []
    }
    
    # Check completeness
    products_with_volumes = len([p for p in volumes['products'].values() if p['total_volume'] > 0])
    total_products = len(volumes['products'])
    
    if products_with_volumes < total_products * 0.9:
        validation['warnings'].append({
            'type': 'INCOMPLETE_VOLUMES',
            'message': f"Only {products_with_volumes}/{total_products} products have volumes"
        })
    
    # Check for zeros in active products
    for product_id, product in volumes['products'].items():
        if is_active_product(product_id) and product['total_volume'] == 0:
            validation['warnings'].append({
                'type': 'ZERO_VOLUME_ACTIVE',
                'product': product_id,
                'message': f"Active product {product['product_name']} has zero volume"
            })
    
    # Check reasonableness vs history
    for product_id, product in volumes['products'].items():
        historical_avg = get_historical_monthly_avg(product_id)
        if historical_avg > 0:
            forecast_monthly_avg = product['total_volume'] / len(product['monthly_volumes'])
            change_pct = (forecast_monthly_avg - historical_avg) / historical_avg * 100
            
            if abs(change_pct) > 50:
                validation['warnings'].append({
                    'type': 'LARGE_VARIANCE',
                    'product': product_id,
                    'change': change_pct,
                    'message': f"Volume {change_pct:+.0f}% vs historical"
                })
    
    return validation
```

---

## Step 2: Apply Pricing

### Price & Mix Calculations
```python
def apply_pricing(volumes, pricing_version='current'):
    """Apply pricing to volume plan"""
    
    revenue_plan = {
        'period': volumes['period'],
        'products': {},
        'summary': {}
    }
    
    for product_id, product in volumes['products'].items():
        # Get pricing
        pricing = get_product_pricing(product_id, pricing_version)
        
        # Calculate revenue by period
        monthly_revenue = []
        monthly_asp = []
        
        for month_idx, volume in enumerate(product['monthly_volumes']):
            period_price = get_period_price(product_id, volumes['period'], month_idx)
            
            # Apply customer mix
            customer_mix = get_customer_mix(product_id)
            weighted_price = calculate_weighted_price(period_price, customer_mix)
            
            # Apply channel mix
            channel_mix = get_channel_mix(product_id)
            weighted_price = apply_channel_mix(weighted_price, channel_mix)
            
            # Apply promotional impact
            promo_discount = get_promotional_discount(product_id, volumes['period'], month_idx)
            net_price = weighted_price * (1 - promo_discount)
            
            period_revenue = volume * net_price
            monthly_revenue.append(period_revenue)
            monthly_asp.append(net_price)
        
        revenue_plan['products'][product_id] = {
            **product,
            'list_price': pricing['list_price'],
            'monthly_asp': monthly_asp,
            'avg_asp': np.mean(monthly_asp),
            'monthly_revenue': monthly_revenue,
            'total_revenue': sum(monthly_revenue)
        }
    
    # Calculate summary
    revenue_plan['summary'] = {
        'total_revenue': sum(p['total_revenue'] for p in revenue_plan['products'].values()),
        'total_volume': sum(p['total_volume'] for p in revenue_plan['products'].values()),
        'blended_asp': sum(p['total_revenue'] for p in revenue_plan['products'].values()) / 
                       sum(p['total_volume'] for p in revenue_plan['products'].values()),
        'by_category': aggregate_revenue_by_dimension(revenue_plan['products'], 'category'),
        'by_brand': aggregate_revenue_by_dimension(revenue_plan['products'], 'brand')
    }
    
    return revenue_plan

def calculate_price_mix_impact(revenue_plan, baseline_revenue):
    """Calculate price vs mix impact"""
    
    impact = {
        'price_impact': 0,
        'mix_impact': 0,
        'volume_impact': 0,
        'total_change': 0
    }
    
    for product_id in revenue_plan['products']:
        current = revenue_plan['products'][product_id]
        baseline = baseline_revenue['products'].get(product_id, {})
        
        if baseline:
            # Price impact: change in ASP at baseline volume
            price_change = (current['avg_asp'] - baseline['avg_asp']) * baseline['total_volume']
            impact['price_impact'] += price_change
            
            # Volume impact: change in volume at baseline price
            volume_change = (current['total_volume'] - baseline['total_volume']) * baseline['avg_asp']
            impact['volume_impact'] += volume_change
    
    # Mix impact is the residual
    impact['total_change'] = revenue_plan['summary']['total_revenue'] - baseline_revenue['summary']['total_revenue']
    impact['mix_impact'] = impact['total_change'] - impact['price_impact'] - impact['volume_impact']
    
    return impact
```

---

## Step 3: Calculate Costs

### Cost Structure Application
```python
def calculate_costs(revenue_plan, cost_version='standard'):
    """Calculate all cost elements"""
    
    cost_plan = {
        'period': revenue_plan['period'],
        'products': {},
        'summary': {}
    }
    
    for product_id, product in revenue_plan['products'].items():
        # Get cost structure
        costs = get_product_costs(product_id, cost_version)
        
        # Variable costs
        variable_costs = {
            'raw_materials': [],
            'direct_labor': [],
            'variable_overhead': [],
            'freight': [],
            'commissions': []
        }
        
        for month_idx, volume in enumerate(product['monthly_volumes']):
            # Raw materials (may vary by period due to commodity prices)
            rm_cost = get_material_cost(product_id, revenue_plan['period'], month_idx)
            variable_costs['raw_materials'].append(volume * rm_cost)
            
            # Direct labor
            labor_cost = costs['direct_labor_per_unit']
            variable_costs['direct_labor'].append(volume * labor_cost)
            
            # Variable overhead
            var_oh = costs['variable_overhead_per_unit']
            variable_costs['variable_overhead'].append(volume * var_oh)
            
            # Freight (based on revenue for percentage)
            freight_pct = costs.get('freight_pct', 0.03)
            variable_costs['freight'].append(product['monthly_revenue'][month_idx] * freight_pct)
            
            # Sales commissions
            commission_pct = costs.get('commission_pct', 0.05)
            variable_costs['commissions'].append(product['monthly_revenue'][month_idx] * commission_pct)
        
        # Fixed costs (allocated)
        allocated_fixed = allocate_fixed_costs(product_id, product['total_volume'])
        
        # Total costs
        total_variable = {k: sum(v) for k, v in variable_costs.items()}
        cogs = total_variable['raw_materials'] + total_variable['direct_labor'] + total_variable['variable_overhead']
        
        cost_plan['products'][product_id] = {
            **product,
            'variable_costs': variable_costs,
            'total_variable': sum(total_variable.values()),
            'cogs': cogs,
            'cogs_per_unit': cogs / product['total_volume'] if product['total_volume'] > 0 else 0,
            'gross_margin': product['total_revenue'] - cogs,
            'gross_margin_pct': (product['total_revenue'] - cogs) / product['total_revenue'] if product['total_revenue'] > 0 else 0,
            'allocated_fixed': allocated_fixed
        }
    
    # Calculate summary
    total_revenue = sum(p['total_revenue'] for p in cost_plan['products'].values())
    total_cogs = sum(p['cogs'] for p in cost_plan['products'].values())
    
    cost_plan['summary'] = {
        'total_revenue': total_revenue,
        'total_cogs': total_cogs,
        'gross_margin': total_revenue - total_cogs,
        'gross_margin_pct': (total_revenue - total_cogs) / total_revenue if total_revenue > 0 else 0,
        'operating_expenses': calculate_opex(revenue_plan['period']),
        'by_cost_type': aggregate_costs_by_type(cost_plan['products'])
    }
    
    return cost_plan

def allocate_fixed_costs(product_id, volume):
    """Allocate fixed costs to product"""
    
    allocation_bases = get_allocation_bases()
    allocated = {}
    
    for cost_pool, config in allocation_bases.items():
        pool_total = get_cost_pool_amount(cost_pool)
        
        if config['basis'] == 'volume':
            total_volume = get_total_volume()
            allocated[cost_pool] = pool_total * (volume / total_volume)
        
        elif config['basis'] == 'revenue':
            product_revenue = get_product_revenue(product_id)
            total_revenue = get_total_revenue()
            allocated[cost_pool] = pool_total * (product_revenue / total_revenue)
        
        elif config['basis'] == 'direct_labor':
            product_labor = get_product_labor_hours(product_id)
            total_labor = get_total_labor_hours()
            allocated[cost_pool] = pool_total * (product_labor / total_labor)
    
    return allocated
```

---

## Step 4: Build P&L

### Full Income Statement Generation
```python
def build_pl_statement(cost_plan, period):
    """Build complete P&L statement"""
    
    pl = {
        'period': period,
        'generated_at': datetime.now(),
        'version': 'auto_generated',
        'line_items': {}
    }
    
    # Revenue section
    pl['line_items']['gross_revenue'] = cost_plan['summary']['total_revenue']
    pl['line_items']['returns_allowances'] = calculate_returns_allowance(cost_plan)
    pl['line_items']['net_revenue'] = (
        pl['line_items']['gross_revenue'] - 
        pl['line_items']['returns_allowances']
    )
    
    # Cost of Goods Sold
    pl['line_items']['cogs'] = {
        'materials': sum(p['variable_costs']['raw_materials'][-1] for p in cost_plan['products'].values()),
        'labor': sum(p['variable_costs']['direct_labor'][-1] for p in cost_plan['products'].values()),
        'overhead': sum(p['variable_costs']['variable_overhead'][-1] for p in cost_plan['products'].values()),
        'total': cost_plan['summary']['total_cogs']
    }
    
    # Gross Profit
    pl['line_items']['gross_profit'] = (
        pl['line_items']['net_revenue'] - 
        pl['line_items']['cogs']['total']
    )
    pl['line_items']['gross_margin_pct'] = (
        pl['line_items']['gross_profit'] / 
        pl['line_items']['net_revenue']
    )
    
    # Operating Expenses
    opex = cost_plan['summary']['operating_expenses']
    pl['line_items']['operating_expenses'] = {
        'sales_marketing': opex['sales_marketing'],
        'research_development': opex['r_and_d'],
        'general_admin': opex['g_and_a'],
        'depreciation': opex['depreciation'],
        'total': sum(opex.values())
    }
    
    # Operating Income
    pl['line_items']['operating_income'] = (
        pl['line_items']['gross_profit'] - 
        pl['line_items']['operating_expenses']['total']
    )
    pl['line_items']['operating_margin_pct'] = (
        pl['line_items']['operating_income'] / 
        pl['line_items']['net_revenue']
    )
    
    # Other Income/Expenses
    pl['line_items']['other'] = {
        'interest_expense': get_interest_expense(period),
        'interest_income': get_interest_income(period),
        'other_income': get_other_income(period),
        'total': get_interest_expense(period) - get_interest_income(period) - get_other_income(period)
    }
    
    # Net Income Before Tax
    pl['line_items']['income_before_tax'] = (
        pl['line_items']['operating_income'] - 
        pl['line_items']['other']['total']
    )
    
    # Taxes
    tax_rate = get_effective_tax_rate()
    pl['line_items']['income_tax'] = pl['line_items']['income_before_tax'] * tax_rate
    
    # Net Income
    pl['line_items']['net_income'] = (
        pl['line_items']['income_before_tax'] - 
        pl['line_items']['income_tax']
    )
    pl['line_items']['net_margin_pct'] = (
        pl['line_items']['net_income'] / 
        pl['line_items']['net_revenue']
    )
    
    # Monthly breakdown
    pl['monthly'] = build_monthly_pl(cost_plan)
    
    return pl

def build_monthly_pl(cost_plan):
    """Build monthly P&L breakdown"""
    
    months = len(list(cost_plan['products'].values())[0]['monthly_volumes'])
    monthly_pl = []
    
    for month in range(months):
        month_pl = {
            'month': month + 1,
            'revenue': sum(p['monthly_revenue'][month] for p in cost_plan['products'].values()),
            'cogs': sum(
                p['variable_costs']['raw_materials'][month] +
                p['variable_costs']['direct_labor'][month] +
                p['variable_costs']['variable_overhead'][month]
                for p in cost_plan['products'].values()
            )
        }
        month_pl['gross_profit'] = month_pl['revenue'] - month_pl['cogs']
        month_pl['gross_margin_pct'] = month_pl['gross_profit'] / month_pl['revenue'] if month_pl['revenue'] > 0 else 0
        
        monthly_pl.append(month_pl)
    
    return monthly_pl
```

---

## Step 5: Compare to Plan

### Plan vs Forecast Analysis
```python
def compare_to_plan(generated_pl, plan_version='annual_budget'):
    """Compare generated P&L to budget/plan"""
    
    plan = get_financial_plan(plan_version, generated_pl['period'])
    
    comparison = {
        'generated': generated_pl,
        'plan': plan,
        'variances': {},
        'variance_summary': {}
    }
    
    # Line item variances
    for line_item, value in generated_pl['line_items'].items():
        if isinstance(value, dict):
            for sub_item, sub_value in value.items():
                plan_value = plan['line_items'].get(line_item, {}).get(sub_item, 0)
                comparison['variances'][f"{line_item}_{sub_item}"] = {
                    'forecast': sub_value,
                    'plan': plan_value,
                    'variance': sub_value - plan_value,
                    'variance_pct': (sub_value - plan_value) / plan_value * 100 if plan_value != 0 else 0
                }
        else:
            plan_value = plan['line_items'].get(line_item, 0)
            comparison['variances'][line_item] = {
                'forecast': value,
                'plan': plan_value,
                'variance': value - plan_value,
                'variance_pct': (value - plan_value) / plan_value * 100 if plan_value != 0 else 0
            }
    
    # Summary
    comparison['variance_summary'] = {
        'revenue_gap': comparison['variances']['net_revenue']['variance'],
        'revenue_gap_pct': comparison['variances']['net_revenue']['variance_pct'],
        'gross_profit_gap': comparison['variances']['gross_profit']['variance'],
        'operating_income_gap': comparison['variances']['operating_income']['variance'],
        'net_income_gap': comparison['variances']['net_income']['variance'],
        'on_track': abs(comparison['variances']['net_revenue']['variance_pct']) < 5
    }
    
    return comparison

def identify_key_gaps(comparison):
    """Identify key gaps requiring attention"""
    
    gaps = []
    
    # Revenue gap
    rev_gap = comparison['variance_summary']['revenue_gap']
    if abs(rev_gap) > 100000:  # Significant threshold
        gaps.append({
            'type': 'REVENUE_GAP',
            'value': rev_gap,
            'pct': comparison['variance_summary']['revenue_gap_pct'],
            'severity': 'HIGH' if abs(comparison['variance_summary']['revenue_gap_pct']) > 5 else 'MEDIUM',
            'drivers': identify_revenue_gap_drivers(comparison)
        })
    
    # Margin gap
    margin_forecast = comparison['generated']['line_items']['gross_margin_pct']
    margin_plan = comparison['plan']['line_items'].get('gross_margin_pct', 0)
    margin_gap = margin_forecast - margin_plan
    
    if abs(margin_gap) > 0.01:  # 1% threshold
        gaps.append({
            'type': 'MARGIN_GAP',
            'value': margin_gap,
            'severity': 'HIGH' if abs(margin_gap) > 0.02 else 'MEDIUM',
            'drivers': identify_margin_gap_drivers(comparison)
        })
    
    return gaps
```

---

## Step 6: Bridge Variance

### Waterfall Analysis
```python
def build_variance_bridge(comparison, baseline='plan'):
    """Build variance bridge (waterfall) analysis"""
    
    bridge = {
        'start': comparison['plan']['line_items']['net_revenue'],
        'end': comparison['generated']['line_items']['net_revenue'],
        'components': []
    }
    
    # Volume impact
    volume_impact = calculate_volume_impact(comparison)
    bridge['components'].append({
        'name': 'Volume',
        'value': volume_impact,
        'direction': 'positive' if volume_impact > 0 else 'negative',
        'drivers': get_volume_drivers(comparison)
    })
    
    # Price impact
    price_impact = calculate_price_impact(comparison)
    bridge['components'].append({
        'name': 'Price',
        'value': price_impact,
        'direction': 'positive' if price_impact > 0 else 'negative',
        'drivers': get_price_drivers(comparison)
    })
    
    # Mix impact
    mix_impact = calculate_mix_impact(comparison)
    bridge['components'].append({
        'name': 'Mix',
        'value': mix_impact,
        'direction': 'positive' if mix_impact > 0 else 'negative',
        'drivers': get_mix_drivers(comparison)
    })
    
    # Cost impact
    cost_impact = calculate_cost_impact(comparison)
    bridge['components'].append({
        'name': 'Cost',
        'value': -cost_impact,  # Negative because costs reduce profit
        'direction': 'positive' if cost_impact < 0 else 'negative',
        'drivers': get_cost_drivers(comparison)
    })
    
    # FX impact
    fx_impact = calculate_fx_impact(comparison)
    if abs(fx_impact) > 0:
        bridge['components'].append({
            'name': 'FX',
            'value': fx_impact,
            'direction': 'positive' if fx_impact > 0 else 'negative'
        })
    
    # Validate bridge
    calculated_end = bridge['start'] + sum(c['value'] for c in bridge['components'])
    bridge['reconciles'] = abs(calculated_end - bridge['end']) < 1  # Within $1
    
    return bridge

def generate_bridge_narrative(bridge, comparison):
    """Generate AI narrative for variance bridge"""
    
    prompt = f"""
    Generate an executive summary of this financial variance:
    
    STARTING POINT (Plan): ${bridge['start']:,.0f}
    ENDING POINT (Forecast): ${bridge['end']:,.0f}
    TOTAL VARIANCE: ${bridge['end'] - bridge['start']:,.0f}
    
    BRIDGE COMPONENTS:
    {format_bridge_components(bridge['components'])}
    
    KEY GAPS IDENTIFIED:
    {format_key_gaps(comparison)}
    
    Write a 2-3 paragraph executive summary that:
    1. Explains the key drivers of variance in business terms
    2. Highlights the most significant factors
    3. Identifies any concerning trends
    4. Suggests areas for management attention
    
    Be concise and focus on actionable insights.
    """
    
    narrative = call_llm(prompt)
    return narrative
```

---

## Step 7: Validate & Approve

### AI Sanity Checks
```python
def validate_generated_pl(pl, comparison):
    """Run AI-powered validation checks"""
    
    validation = {
        'passed': True,
        'checks': [],
        'warnings': [],
        'requires_review': []
    }
    
    # Check 1: Margin reasonableness
    gm = pl['line_items']['gross_margin_pct']
    historical_gm = get_historical_gross_margin()
    if abs(gm - historical_gm) > 0.05:
        validation['warnings'].append({
            'check': 'MARGIN_DEVIATION',
            'message': f"Gross margin {gm:.1%} differs from historical {historical_gm:.1%}",
            'severity': 'MEDIUM'
        })
    
    # Check 2: Seasonality alignment
    monthly_pattern = [m['revenue'] for m in pl['monthly']]
    expected_pattern = get_seasonal_pattern()
    if not check_seasonality_match(monthly_pattern, expected_pattern):
        validation['warnings'].append({
            'check': 'SEASONALITY_MISMATCH',
            'message': 'Monthly pattern differs from historical seasonality',
            'severity': 'LOW'
        })
    
    # Check 3: Cost ratio consistency
    cost_ratios = calculate_cost_ratios(pl)
    historical_ratios = get_historical_cost_ratios()
    for ratio_name, ratio_value in cost_ratios.items():
        if abs(ratio_value - historical_ratios.get(ratio_name, ratio_value)) > 0.03:
            validation['warnings'].append({
                'check': f'COST_RATIO_{ratio_name.upper()}',
                'message': f"{ratio_name} ratio {ratio_value:.1%} differs from historical",
                'severity': 'LOW'
            })
    
    # Check 4: Revenue growth reasonableness
    prior_year = get_prior_year_revenue()
    growth = (pl['line_items']['net_revenue'] - prior_year) / prior_year
    if abs(growth) > 0.3:
        validation['requires_review'].append({
            'check': 'LARGE_GROWTH',
            'message': f"YoY growth of {growth:.1%} exceeds 30%",
            'action': 'Requires finance review'
        })
    
    # Check 5: Negative margins
    if pl['line_items']['gross_margin_pct'] < 0:
        validation['passed'] = False
        validation['checks'].append({
            'check': 'NEGATIVE_MARGIN',
            'message': 'Negative gross margin - check for errors',
            'severity': 'CRITICAL'
        })
    
    return validation

def approve_pl(pl, validation, approver):
    """Record P&L approval"""
    
    if not validation['passed']:
        raise ValueError("Cannot approve P&L with failed validation")
    
    approval = {
        'pl_id': pl.get('id', generate_pl_id()),
        'approved_by': approver['name'],
        'approved_at': datetime.now(),
        'validation_status': 'PASSED' if validation['passed'] else 'FAILED',
        'warnings_acknowledged': len(validation['warnings']),
        'comments': approver.get('comments')
    }
    
    # Store approval
    store_pl_approval(pl, approval)
    
    return approval
```

---

## Step 8: Publish & Distribute

### System Integration
```python
def publish_pl(pl, approval):
    """Publish approved P&L to downstream systems"""
    
    publication = {
        'pl_id': pl['id'],
        'published_at': datetime.now(),
        'destinations': []
    }
    
    # Publish to financial planning system
    result = publish_to_fp_system(pl)
    publication['destinations'].append({
        'system': 'Financial Planning',
        'status': result['status'],
        'timestamp': datetime.now()
    })
    
    # Publish to reporting/BI
    result = publish_to_bi(pl)
    publication['destinations'].append({
        'system': 'BI Platform',
        'status': result['status']
    })
    
    # Publish to consolidation system
    result = publish_to_consolidation(pl)
    publication['destinations'].append({
        'system': 'Consolidation',
        'status': result['status']
    })
    
    # Notify stakeholders
    notify_pl_publication(pl, approval)
    
    # Generate executive summary
    exec_summary = generate_pl_executive_summary(pl)
    
    return {
        'publication': publication,
        'executive_summary': exec_summary
    }

def generate_pl_executive_summary(pl):
    """Generate executive summary of P&L"""
    
    prompt = f"""
    Generate a brief executive summary for this P&L forecast:
    
    PERIOD: {pl['period']}
    
    KEY METRICS:
    - Revenue: ${pl['line_items']['net_revenue']:,.0f}
    - Gross Margin: {pl['line_items']['gross_margin_pct']:.1%}
    - Operating Income: ${pl['line_items']['operating_income']:,.0f}
    - Operating Margin: {pl['line_items']['operating_margin_pct']:.1%}
    - Net Income: ${pl['line_items']['net_income']:,.0f}
    
    MONTHLY TREND:
    {format_monthly_trend(pl['monthly'])}
    
    Write a 3-bullet executive summary covering:
    1. Top-line performance expectation
    2. Margin outlook
    3. Key watch items
    
    Keep it concise - this is for executive review.
    """
    
    return call_llm(prompt)
```

---

## Auto P&L Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  AUTO P&L GENERATION DASHBOARD                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STATUS: P&L Generated ✓  │  Last Run: 2 min ago               │
│                                                                  │
│  PERIOD: Q3 2026 FORECAST                                        │
│  ─────────────────────────────────────────────────────────────  │
│                            Forecast      Plan        Variance   │
│  Revenue                   $45.2M        $47.0M      -$1.8M     │
│  COGS                      $28.5M        $29.5M      +$1.0M     │
│  Gross Profit              $16.7M        $17.5M      -$0.8M     │
│  Gross Margin              37.0%         37.2%       -0.2 pts   │
│  Operating Expenses        $12.1M        $12.0M      -$0.1M     │
│  Operating Income          $4.6M         $5.5M       -$0.9M     │
│  Net Income                $3.4M         $4.1M       -$0.7M     │
│                                                                  │
│  VARIANCE BRIDGE (Revenue):                                      │
│  ─────────────────────────────────────────────────────────────  │
│  Plan Revenue         $47.0M  ████████████████████████████████  │
│  Volume Impact        -$1.2M  ████ ← Lower demand               │
│  Price Impact         +$0.5M      ██ ← Price increase           │
│  Mix Impact           -$0.8M  ███ ← Unfavorable mix             │
│  FX Impact            -$0.3M  █ ← Currency headwind             │
│  Forecast Revenue     $45.2M  ██████████████████████████████    │
│                                                                  │
│  VALIDATION: ✓ Passed │ 3 Warnings                              │
│  ─────────────────────────────────────────────────────────────  │
│  ⚠ Margin 0.5% below historical                                 │
│  ⚠ Q3 seasonality differs from pattern                         │
│  ⚠ Large variance requires finance review                       │
│                                                                  │
│  [Approve] [Revise Assumptions] [View Details]                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*Automated P&L generation from volume plans for instant financial translation.*
