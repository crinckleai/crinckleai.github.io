# Network Digital Twin Workflow
## AI-Powered Supply Chain Simulation & Optimization

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    NETWORK DIGITAL TWIN WORKFLOW                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. MODEL │───▶│ 2. SYNC  │───▶│ 3. SIMULATE│──▶│ 4. OPTIMIZE│           │
│  │ NETWORK  │    │ REAL-TIME│    │ SCENARIOS │    │ DESIGN   │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Node & Flow       Live Data      What-If          Strategic            │
│   Definition        Integration    Analysis         Recommendations       │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. RISK  │───▶│ 6. COST  │───▶│ 7. IMPLEMENT│─▶│ 8. MONITOR│           │
│  │ ASSESS   │    │ ANALYZE  │    │ CHANGES  │    │ VALIDATE │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Disruption        Total Cost      Phased          Continuous            │
│   Simulation        Optimization    Rollout         Twin Update           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Model Network

### Network Definition
```python
def create_network_digital_twin():
    """Create comprehensive digital twin of supply network"""
    
    network = {
        'nodes': {},
        'edges': {},
        'products': {},
        'parameters': {}
    }
    
    # Define nodes (facilities)
    facilities = get_all_facilities()
    for facility in facilities:
        network['nodes'][facility['id']] = {
            'id': facility['id'],
            'name': facility['name'],
            'type': facility['type'],  # Supplier, Plant, DC, Customer
            'location': {
                'lat': facility['latitude'],
                'lon': facility['longitude'],
                'country': facility['country'],
                'region': facility['region']
            },
            'capacity': get_facility_capacity(facility['id']),
            'costs': get_facility_costs(facility['id']),
            'capabilities': get_facility_capabilities(facility['id']),
            'inventory': {
                'current': get_current_inventory(facility['id']),
                'targets': get_inventory_targets(facility['id'])
            }
        }
    
    # Define edges (transportation lanes)
    lanes = get_all_transportation_lanes()
    for lane in lanes:
        network['edges'][lane['id']] = {
            'id': lane['id'],
            'from_node': lane['origin'],
            'to_node': lane['destination'],
            'mode': lane['transport_mode'],  # Truck, Rail, Ocean, Air
            'lead_time': {
                'mean': lane['lead_time_days'],
                'std': lane['lead_time_std']
            },
            'cost': {
                'per_unit': lane['cost_per_unit'],
                'per_shipment': lane['fixed_cost']
            },
            'capacity': {
                'max_volume': lane['max_volume'],
                'min_shipment': lane['min_order']
            },
            'reliability': lane.get('on_time_rate', 0.95)
        }
    
    # Define products and their flow requirements
    products = get_all_products()
    for product in products:
        network['products'][product['id']] = {
            'id': product['id'],
            'name': product['name'],
            'bom': get_bill_of_materials(product['id']),
            'sources': get_product_sources(product['id']),
            'demand_nodes': get_demand_nodes(product['id']),
            'storage_requirements': product.get('storage_type', 'standard')
        }
    
    return network

def validate_network_model(network):
    """Validate network model completeness and consistency"""
    
    validation = {
        'issues': [],
        'warnings': [],
        'stats': {}
    }
    
    # Check connectivity
    orphan_nodes = find_orphan_nodes(network)
    if orphan_nodes:
        validation['warnings'].append({
            'type': 'ORPHAN_NODES',
            'message': f"{len(orphan_nodes)} nodes have no connections",
            'nodes': orphan_nodes
        })
    
    # Check product flows
    for product_id, product in network['products'].items():
        paths = find_all_paths(network, product['sources'], product['demand_nodes'])
        if not paths:
            validation['issues'].append({
                'type': 'NO_PATH',
                'product': product_id,
                'message': 'No valid path from source to demand'
            })
    
    # Statistics
    validation['stats'] = {
        'total_nodes': len(network['nodes']),
        'total_edges': len(network['edges']),
        'products': len(network['products']),
        'avg_path_length': calculate_avg_path_length(network)
    }
    
    return validation
```

---

## Step 2: Sync Real-Time

### Live Data Integration
```python
def sync_digital_twin(network):
    """Synchronize digital twin with real-time data"""
    
    sync_status = {
        'timestamp': datetime.now(),
        'nodes_updated': 0,
        'edges_updated': 0,
        'data_freshness': {}
    }
    
    # Sync inventory levels
    for node_id, node in network['nodes'].items():
        if node['type'] in ['DC', 'Plant']:
            current_inv = get_real_time_inventory(node_id)
            node['inventory']['current'] = current_inv
            node['inventory']['last_updated'] = datetime.now()
            sync_status['nodes_updated'] += 1
    
    # Sync in-transit inventory
    for edge_id, edge in network['edges'].items():
        in_transit = get_in_transit_inventory(edge_id)
        edge['in_transit'] = in_transit
        sync_status['edges_updated'] += 1
    
    # Sync lead times (actual vs planned)
    recent_shipments = get_recent_shipments(days=30)
    for edge_id in network['edges']:
        actual_lead_times = [s['lead_time'] for s in recent_shipments 
                           if s['lane_id'] == edge_id]
        if actual_lead_times:
            network['edges'][edge_id]['lead_time']['actual_mean'] = np.mean(actual_lead_times)
            network['edges'][edge_id]['lead_time']['actual_std'] = np.std(actual_lead_times)
    
    # Sync capacity utilization
    for node_id, node in network['nodes'].items():
        if node['type'] == 'Plant':
            utilization = get_current_utilization(node_id)
            node['capacity']['current_utilization'] = utilization
    
    # Sync external data
    network['external'] = {
        'weather_alerts': get_weather_alerts(),
        'port_congestion': get_port_congestion_data(),
        'fuel_prices': get_fuel_price_index(),
        'currency_rates': get_currency_rates()
    }
    
    sync_status['data_freshness'] = calculate_data_freshness(network)
    
    return sync_status

def calculate_data_freshness(network):
    """Calculate how fresh each data element is"""
    
    freshness = {}
    now = datetime.now()
    
    for node_id, node in network['nodes'].items():
        last_update = node['inventory'].get('last_updated', now - timedelta(days=999))
        age_hours = (now - last_update).total_seconds() / 3600
        freshness[node_id] = {
            'age_hours': age_hours,
            'status': 'FRESH' if age_hours < 1 else 'STALE' if age_hours < 24 else 'OUTDATED'
        }
    
    return freshness
```

---

## Step 3: Simulate Scenarios

### What-If Analysis Engine
```python
import simpy
import numpy as np

def run_network_simulation(network, scenario, duration_days=365):
    """Run discrete event simulation of supply network"""
    
    env = simpy.Environment()
    
    # Create simulation entities
    facilities = {}
    for node_id, node in network['nodes'].items():
        facilities[node_id] = FacilitySimulation(env, node)
    
    transportation = {}
    for edge_id, edge in network['edges'].items():
        transportation[edge_id] = TransportSimulation(env, edge)
    
    # Apply scenario modifications
    apply_scenario(network, scenario)
    
    # Generate demand processes
    for product_id in network['products']:
        env.process(demand_generator(env, product_id, network, facilities))
    
    # Generate supply processes
    for node_id, node in network['nodes'].items():
        if node['type'] == 'Supplier':
            env.process(supply_generator(env, node_id, network, facilities))
    
    # Run simulation
    results = {
        'events': [],
        'metrics': {},
        'snapshots': []
    }
    
    env.process(collect_metrics(env, facilities, transportation, results))
    env.run(until=duration_days * 24)  # Hours
    
    # Calculate summary statistics
    results['summary'] = calculate_simulation_summary(results)
    
    return results

class FacilitySimulation:
    def __init__(self, env, node_config):
        self.env = env
        self.config = node_config
        self.inventory = {p: node_config['inventory']['current'].get(p, 0) 
                         for p in get_node_products(node_config['id'])}
        self.capacity = simpy.Resource(env, capacity=node_config['capacity']['max'])
        self.backlog = []
        self.metrics = {
            'stockouts': 0,
            'inventory_days': [],
            'throughput': 0
        }
    
    def receive(self, product_id, quantity):
        self.inventory[product_id] = self.inventory.get(product_id, 0) + quantity
    
    def ship(self, product_id, quantity):
        available = self.inventory.get(product_id, 0)
        if available >= quantity:
            self.inventory[product_id] -= quantity
            self.metrics['throughput'] += quantity
            return quantity
        else:
            self.metrics['stockouts'] += 1
            shipped = available
            self.inventory[product_id] = 0
            self.backlog.append({'product': product_id, 'quantity': quantity - shipped})
            return shipped

def simulate_disruption(network, disruption_type, affected_nodes, duration_days):
    """Simulate network disruption scenario"""
    
    scenario = {
        'type': 'disruption',
        'disruption_type': disruption_type,
        'affected_nodes': affected_nodes,
        'duration': duration_days,
        'modifications': []
    }
    
    if disruption_type == 'facility_shutdown':
        for node_id in affected_nodes:
            scenario['modifications'].append({
                'type': 'set_capacity',
                'node': node_id,
                'new_capacity': 0,
                'start_day': 0,
                'end_day': duration_days
            })
    
    elif disruption_type == 'port_congestion':
        for edge_id in get_edges_through_nodes(network, affected_nodes):
            scenario['modifications'].append({
                'type': 'increase_lead_time',
                'edge': edge_id,
                'multiplier': 2.5,
                'start_day': 0,
                'end_day': duration_days
            })
    
    elif disruption_type == 'demand_surge':
        scenario['modifications'].append({
            'type': 'increase_demand',
            'multiplier': 1.5,
            'nodes': affected_nodes,
            'start_day': 0,
            'end_day': duration_days
        })
    
    # Run simulation
    results = run_network_simulation(network, scenario)
    
    # Calculate impact
    baseline = get_baseline_simulation(network)
    impact = calculate_disruption_impact(baseline, results)
    
    return {
        'scenario': scenario,
        'results': results,
        'impact': impact
    }
```

---

## Step 4: Optimize Design

### Strategic Network Optimization
```python
def optimize_network_design(network, objectives, constraints):
    """Optimize network design using AI/OR techniques"""
    
    # Define optimization problem
    problem = {
        'decision_variables': {
            'facility_open': {},  # Binary: open/close facilities
            'flow': {},  # Continuous: product flow volumes
            'capacity': {},  # Capacity levels
            'inventory': {}  # Inventory positioning
        },
        'objectives': objectives,  # e.g., minimize_cost, maximize_service
        'constraints': constraints
    }
    
    # Build mathematical model
    model = build_network_optimization_model(network, problem)
    
    # Solve using appropriate solver
    if problem_is_linear(model):
        solution = solve_linear_program(model)
    else:
        solution = solve_mixed_integer_program(model)
    
    # Generate recommendations
    recommendations = generate_network_recommendations(network, solution)
    
    return {
        'optimal_solution': solution,
        'recommendations': recommendations,
        'expected_savings': calculate_expected_savings(network, solution),
        'implementation_plan': create_implementation_plan(recommendations)
    }

def generate_network_recommendations(network, solution):
    """Generate actionable recommendations from optimization"""
    
    recommendations = []
    
    # Facility changes
    for node_id, open_decision in solution['facility_open'].items():
        current_status = network['nodes'][node_id].get('status', 'open')
        
        if open_decision == 0 and current_status == 'open':
            recommendations.append({
                'type': 'CLOSE_FACILITY',
                'node': node_id,
                'reason': 'Optimization recommends closure',
                'savings': calculate_closure_savings(network, node_id),
                'risks': identify_closure_risks(network, node_id)
            })
        
        elif open_decision == 1 and current_status == 'closed':
            recommendations.append({
                'type': 'OPEN_FACILITY',
                'node': node_id,
                'reason': 'Optimization recommends opening',
                'investment': calculate_opening_investment(node_id),
                'expected_benefit': calculate_opening_benefit(network, node_id)
            })
    
    # Flow realignment
    significant_flow_changes = identify_flow_changes(network, solution['flow'])
    for change in significant_flow_changes:
        recommendations.append({
            'type': 'REALIGN_FLOW',
            'from_edge': change['from'],
            'to_edge': change['to'],
            'volume': change['volume'],
            'reason': change['reason'],
            'savings': change['savings']
        })
    
    # Inventory repositioning
    inventory_changes = identify_inventory_changes(network, solution['inventory'])
    for change in inventory_changes:
        recommendations.append({
            'type': 'REPOSITION_INVENTORY',
            'product': change['product'],
            'from_node': change['from'],
            'to_node': change['to'],
            'quantity': change['quantity'],
            'benefit': change['benefit']
        })
    
    return recommendations

def ai_evaluate_network_options(network, options):
    """Use AI to evaluate and rank network design options"""
    
    prompt = f"""
    Evaluate these supply network design options:
    
    CURRENT NETWORK:
    - Nodes: {len(network['nodes'])} facilities
    - Annual cost: ${calculate_network_cost(network):,.0f}
    - Average lead time: {calculate_avg_lead_time(network):.1f} days
    - Service level: {calculate_service_level(network):.1%}
    
    OPTIONS:
    {format_network_options(options)}
    
    For each option, provide:
    1. Strategic fit assessment
    2. Risk evaluation
    3. Implementation complexity
    4. Recommendation (1-10 score)
    5. Key considerations
    
    Consider: cost, service, risk, flexibility, sustainability
    """
    
    evaluation = call_llm(prompt)
    return parse_evaluation(evaluation)
```

---

## Step 5: Risk Assessment

### Disruption Simulation
```python
def assess_network_risks(network):
    """Comprehensive network risk assessment"""
    
    risks = {
        'single_source': [],
        'geographic_concentration': [],
        'capacity_constraints': [],
        'transportation': [],
        'geopolitical': []
    }
    
    # Single source risks
    for product_id in network['products']:
        sources = get_product_sources(product_id)
        if len(sources) == 1:
            risks['single_source'].append({
                'product': product_id,
                'source': sources[0],
                'volume_at_risk': get_product_volume(product_id),
                'revenue_at_risk': get_product_revenue(product_id),
                'mitigation': 'Qualify alternate source'
            })
    
    # Geographic concentration
    regions = {}
    for node_id, node in network['nodes'].items():
        region = node['location']['region']
        regions[region] = regions.get(region, 0) + node['capacity'].get('value', 0)
    
    for region, capacity in regions.items():
        total_capacity = sum(regions.values())
        concentration = capacity / total_capacity
        if concentration > 0.4:
            risks['geographic_concentration'].append({
                'region': region,
                'concentration': concentration,
                'capacity_value': capacity,
                'risk_factors': get_region_risks(region)
            })
    
    # Run Monte Carlo risk simulation
    risk_simulation = run_risk_monte_carlo(network, n_simulations=1000)
    
    # Calculate VaR (Value at Risk)
    var_95 = calculate_value_at_risk(risk_simulation, percentile=95)
    var_99 = calculate_value_at_risk(risk_simulation, percentile=99)
    
    return {
        'identified_risks': risks,
        'monte_carlo_results': risk_simulation,
        'value_at_risk': {
            '95_percentile': var_95,
            '99_percentile': var_99
        },
        'recommendations': generate_risk_mitigations(risks)
    }

def run_risk_monte_carlo(network, n_simulations=1000):
    """Run Monte Carlo simulation for risk quantification"""
    
    results = []
    
    for i in range(n_simulations):
        # Generate random disruption scenario
        scenario = generate_random_disruption()
        
        # Apply to network
        disrupted_network = apply_disruption(network.copy(), scenario)
        
        # Calculate impact
        impact = {
            'scenario': scenario['type'],
            'cost_impact': calculate_cost_impact(network, disrupted_network),
            'service_impact': calculate_service_impact(network, disrupted_network),
            'recovery_time': estimate_recovery_time(scenario)
        }
        
        results.append(impact)
    
    return results

def generate_random_disruption():
    """Generate random disruption for Monte Carlo"""
    
    disruption_types = [
        ('supplier_failure', 0.3),
        ('transportation_delay', 0.25),
        ('natural_disaster', 0.15),
        ('demand_surge', 0.15),
        ('quality_issue', 0.1),
        ('geopolitical', 0.05)
    ]
    
    # Select disruption type based on probability
    disruption_type = np.random.choice(
        [d[0] for d in disruption_types],
        p=[d[1] for d in disruption_types]
    )
    
    # Generate parameters
    severity = np.random.beta(2, 5)  # Skewed towards lower severity
    duration = np.random.exponential(7)  # Days, exponential distribution
    
    return {
        'type': disruption_type,
        'severity': severity,
        'duration': duration,
        'affected_nodes': select_random_nodes(severity)
    }
```

---

## Step 6: Cost Analysis

### Total Cost Optimization
```python
def analyze_network_costs(network):
    """Comprehensive network cost analysis"""
    
    costs = {
        'facility': {},
        'transportation': {},
        'inventory': {},
        'operational': {},
        'total': 0
    }
    
    # Facility costs
    for node_id, node in network['nodes'].items():
        costs['facility'][node_id] = {
            'fixed': node['costs'].get('fixed_annual', 0),
            'variable': calculate_variable_facility_cost(node),
            'labor': node['costs'].get('labor_annual', 0),
            'overhead': node['costs'].get('overhead', 0),
            'total': sum([
                node['costs'].get('fixed_annual', 0),
                calculate_variable_facility_cost(node),
                node['costs'].get('labor_annual', 0),
                node['costs'].get('overhead', 0)
            ])
        }
    
    # Transportation costs
    for edge_id, edge in network['edges'].items():
        annual_volume = get_annual_flow(edge_id)
        costs['transportation'][edge_id] = {
            'variable': annual_volume * edge['cost']['per_unit'],
            'fixed': edge['cost'].get('per_shipment', 0) * get_shipment_count(edge_id),
            'total': annual_volume * edge['cost']['per_unit'] + 
                    edge['cost'].get('per_shipment', 0) * get_shipment_count(edge_id)
        }
    
    # Inventory costs
    for node_id, node in network['nodes'].items():
        inv_value = calculate_inventory_value(node['inventory']['current'])
        costs['inventory'][node_id] = {
            'holding': inv_value * get_holding_cost_rate(),
            'obsolescence': estimate_obsolescence_cost(node_id),
            'total': inv_value * get_holding_cost_rate() + estimate_obsolescence_cost(node_id)
        }
    
    # Calculate totals
    costs['total'] = (
        sum(c['total'] for c in costs['facility'].values()) +
        sum(c['total'] for c in costs['transportation'].values()) +
        sum(c['total'] for c in costs['inventory'].values())
    )
    
    # Cost benchmarking
    costs['benchmarks'] = {
        'cost_per_unit': costs['total'] / get_total_units(),
        'logistics_pct_revenue': (
            sum(c['total'] for c in costs['transportation'].values()) /
            get_total_revenue()
        ),
        'inventory_turns': get_total_revenue() / calculate_avg_inventory_value()
    }
    
    return costs

def identify_cost_reduction_opportunities(network, costs):
    """Identify opportunities to reduce network costs"""
    
    opportunities = []
    
    # Transportation consolidation
    consolidation = analyze_consolidation_opportunities(network)
    for opp in consolidation:
        opportunities.append({
            'type': 'TRANSPORTATION_CONSOLIDATION',
            'description': opp['description'],
            'current_cost': opp['current_cost'],
            'potential_cost': opp['potential_cost'],
            'savings': opp['savings'],
            'implementation': opp['steps']
        })
    
    # Mode shift opportunities
    mode_shifts = analyze_mode_shift_opportunities(network)
    for shift in mode_shifts:
        opportunities.append({
            'type': 'MODE_SHIFT',
            'from_mode': shift['current_mode'],
            'to_mode': shift['proposed_mode'],
            'lanes': shift['lanes'],
            'savings': shift['savings'],
            'service_impact': shift['lead_time_change']
        })
    
    # Inventory optimization
    inventory_opps = analyze_inventory_opportunities(network, costs)
    opportunities.extend(inventory_opps)
    
    return sorted(opportunities, key=lambda x: x['savings'], reverse=True)
```

---

## Step 7: Implement Changes

### Phased Rollout
```python
def create_implementation_plan(recommendations, timeline='12_months'):
    """Create phased implementation plan for network changes"""
    
    plan = {
        'phases': [],
        'milestones': [],
        'dependencies': [],
        'resources': {},
        'risks': []
    }
    
    # Sort recommendations by impact and complexity
    prioritized = prioritize_recommendations(recommendations)
    
    # Phase 1: Quick wins (0-3 months)
    phase1 = {
        'name': 'Quick Wins',
        'duration': '0-3 months',
        'items': [],
        'expected_savings': 0
    }
    
    for rec in prioritized:
        if rec['complexity'] == 'LOW' and rec['savings'] > 0:
            phase1['items'].append(rec)
            phase1['expected_savings'] += rec['savings']
    
    plan['phases'].append(phase1)
    
    # Phase 2: Medium-term changes (3-6 months)
    phase2 = {
        'name': 'Process Optimization',
        'duration': '3-6 months',
        'items': [],
        'expected_savings': 0
    }
    
    for rec in prioritized:
        if rec['complexity'] == 'MEDIUM':
            phase2['items'].append(rec)
            phase2['expected_savings'] += rec['savings']
    
    plan['phases'].append(phase2)
    
    # Phase 3: Strategic changes (6-12 months)
    phase3 = {
        'name': 'Strategic Network Changes',
        'duration': '6-12 months',
        'items': [],
        'expected_savings': 0
    }
    
    for rec in prioritized:
        if rec['complexity'] == 'HIGH':
            phase3['items'].append(rec)
            phase3['expected_savings'] += rec['savings']
    
    plan['phases'].append(phase3)
    
    # Define milestones
    plan['milestones'] = define_milestones(plan['phases'])
    
    # Identify dependencies
    plan['dependencies'] = identify_dependencies(plan['phases'])
    
    # Resource requirements
    plan['resources'] = estimate_resources(plan['phases'])
    
    return plan

def track_implementation_progress(plan_id):
    """Track progress of network changes implementation"""
    
    plan = get_implementation_plan(plan_id)
    
    progress = {
        'overall': 0,
        'by_phase': {},
        'completed_items': [],
        'in_progress': [],
        'blocked': [],
        'upcoming': []
    }
    
    for phase in plan['phases']:
        phase_progress = {
            'total_items': len(phase['items']),
            'completed': 0,
            'in_progress': 0,
            'blocked': 0
        }
        
        for item in phase['items']:
            status = get_item_status(item['id'])
            
            if status == 'COMPLETED':
                phase_progress['completed'] += 1
                progress['completed_items'].append(item)
            elif status == 'IN_PROGRESS':
                phase_progress['in_progress'] += 1
                progress['in_progress'].append(item)
            elif status == 'BLOCKED':
                phase_progress['blocked'] += 1
                progress['blocked'].append(item)
            else:
                progress['upcoming'].append(item)
        
        phase_progress['pct_complete'] = (
            phase_progress['completed'] / phase_progress['total_items'] * 100
            if phase_progress['total_items'] > 0 else 0
        )
        
        progress['by_phase'][phase['name']] = phase_progress
    
    # Calculate overall progress
    total_items = sum(p['total_items'] for p in progress['by_phase'].values())
    completed_items = sum(p['completed'] for p in progress['by_phase'].values())
    progress['overall'] = completed_items / total_items * 100 if total_items > 0 else 0
    
    return progress
```

---

## Step 8: Monitor & Validate

### Continuous Twin Update
```python
def monitor_digital_twin_accuracy(network):
    """Monitor accuracy of digital twin vs reality"""
    
    accuracy = {
        'inventory': {},
        'lead_times': {},
        'costs': {},
        'overall': 0
    }
    
    # Inventory accuracy
    for node_id, node in network['nodes'].items():
        if node['type'] in ['DC', 'Plant']:
            twin_inv = node['inventory']['current']
            actual_inv = get_actual_inventory(node_id)
            
            accuracy['inventory'][node_id] = calculate_inventory_accuracy(twin_inv, actual_inv)
    
    # Lead time accuracy
    for edge_id, edge in network['edges'].items():
        twin_lt = edge['lead_time']['mean']
        actual_lt = get_actual_avg_lead_time(edge_id, days=30)
        
        accuracy['lead_times'][edge_id] = {
            'twin': twin_lt,
            'actual': actual_lt,
            'variance': abs(twin_lt - actual_lt) / actual_lt if actual_lt > 0 else 0,
            'accuracy': 1 - abs(twin_lt - actual_lt) / actual_lt if actual_lt > 0 else 1
        }
    
    # Calculate overall accuracy
    inv_accuracy = np.mean([a['accuracy'] for a in accuracy['inventory'].values()])
    lt_accuracy = np.mean([a['accuracy'] for a in accuracy['lead_times'].values()])
    accuracy['overall'] = (inv_accuracy + lt_accuracy) / 2
    
    # Trigger recalibration if needed
    if accuracy['overall'] < 0.9:
        recalibrate_digital_twin(network, accuracy)
    
    return accuracy

def validate_simulation_results(network, simulation_results, actual_results):
    """Validate simulation predictions against actual outcomes"""
    
    validation = {
        'predictions': [],
        'accuracy_metrics': {}
    }
    
    for prediction in simulation_results['summary']:
        actual = find_matching_actual(actual_results, prediction)
        
        if actual:
            error = abs(prediction['value'] - actual['value'])
            pct_error = error / actual['value'] if actual['value'] > 0 else 0
            
            validation['predictions'].append({
                'metric': prediction['metric'],
                'predicted': prediction['value'],
                'actual': actual['value'],
                'error': error,
                'pct_error': pct_error,
                'accurate': pct_error < 0.1
            })
    
    # Calculate aggregate metrics
    accurate_predictions = sum(1 for p in validation['predictions'] if p['accurate'])
    validation['accuracy_metrics'] = {
        'accuracy_rate': accurate_predictions / len(validation['predictions']),
        'avg_error': np.mean([p['pct_error'] for p in validation['predictions']]),
        'max_error': max([p['pct_error'] for p in validation['predictions']])
    }
    
    return validation
```

---

## Digital Twin Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  NETWORK DIGITAL TWIN DASHBOARD                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  NETWORK STATUS: Synced 2 min ago                               │
│  ─────────────────────────────────────────────────────────────  │
│  Nodes: 45 │ Edges: 128 │ Products: 250 │ Accuracy: 94%         │
│                                                                  │
│  CURRENT NETWORK PERFORMANCE:                                    │
│  ─────────────────────────────────────────────────────────────  │
│  Total Annual Cost:      $45.2M                                 │
│  Avg Lead Time:          8.5 days                               │
│  Service Level:          96.2%                                  │
│  Inventory Turns:        6.4x                                   │
│                                                                  │
│  ACTIVE SIMULATIONS:                                             │
│  ─────────────────────────────────────────────────────────────  │
│  1. Port congestion impact (Shanghai)    │ Running... 65%       │
│  2. New DC in Texas evaluation          │ Completed ✓           │
│  3. Supplier diversification analysis   │ Queued                │
│                                                                  │
│  OPTIMIZATION RECOMMENDATIONS:                                   │
│  ─────────────────────────────────────────────────────────────  │
│  1. Consolidate East Coast DCs          │ Save $1.2M/yr        │
│  2. Shift 30% volume to rail            │ Save $800K/yr        │
│  3. Add supplier in Vietnam             │ Reduce risk 35%      │
│                                                                  │
│  RISK ALERTS:                                                    │
│  ─────────────────────────────────────────────────────────────  │
│  ⚠ Single source risk: Product X (China) │ $5M exposure        │
│  ⚠ Capacity constraint: Plant B next Q  │ 95% utilization      │
│                                                                  │
│  [Run Simulation] [Optimize] [Export Report]                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered network digital twin for strategic supply chain optimization.*
