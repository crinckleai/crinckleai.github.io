# Capacity Optimizer Workflow
## AI-Powered Production Planning & Resource Optimization

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CAPACITY OPTIMIZER WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 1. LOAD  │───▶│ 2. MODEL │───▶│ 3. OPTIMIZE│──▶│ 4. BALANCE│            │
│  │ DEMAND   │    │ CAPACITY │    │ SOLVER   │    │ TRADE-OFFS│             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   Consensus       Resource        Mathematical     Cost vs               │
│   Forecast        Constraints     Optimization     Service               │
│                                                                              │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐             │
│  │ 5. SCENARIO│─▶│ 6. RECOMMEND│─▶│ 7. EXECUTE│──▶│ 8. LEARN │            │
│  │ ANALYSIS │    │ PLAN     │    │ & MONITOR│    │ IMPROVE  │             │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘             │
│       │               │               │               │                    │
│       ▼               ▼               ▼               ▼                    │
│   What-If          AI-Selected     Real-time       Continuous            │
│   Simulation       Optimal Plan    Tracking        Model Update          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Load Demand

### Demand Input Processing
```python
def load_capacity_demand(planning_horizon):
    """Load and prepare demand for capacity planning"""
    
    # Get consensus forecast
    consensus = get_consensus_forecast(planning_horizon)
    
    # Convert to capacity units
    capacity_demand = {}
    
    for product_id, forecast in consensus.items():
        product = get_product(product_id)
        
        # Get resource requirements
        bom = get_bill_of_materials(product_id)
        routing = get_routing(product_id)
        
        capacity_demand[product_id] = {
            'volume_forecast': forecast,
            'resource_requirements': calculate_resource_requirements(routing, forecast),
            'material_requirements': calculate_material_requirements(bom, forecast),
            'priority': get_product_priority(product_id),
            'min_lot_size': product.get('min_lot_size', 1),
            'max_lot_size': product.get('max_lot_size', float('inf')),
            'setup_time': routing.get('setup_time', 0)
        }
    
    # Aggregate by resource
    resource_demand = aggregate_by_resource(capacity_demand)
    
    return {
        'product_demand': capacity_demand,
        'resource_demand': resource_demand,
        'planning_horizon': planning_horizon
    }

def calculate_resource_requirements(routing, forecast):
    """Calculate resource hours needed per period"""
    
    requirements = {}
    
    for operation in routing['operations']:
        resource_id = operation['resource_id']
        time_per_unit = operation['cycle_time']
        
        if resource_id not in requirements:
            requirements[resource_id] = []
        
        for period_demand in forecast:
            hours_needed = period_demand * time_per_unit / 60  # Convert to hours
            requirements[resource_id].append(hours_needed)
    
    return requirements
```

---

## Step 2: Model Capacity

### Resource Constraint Modeling
```python
def model_capacity_constraints():
    """Build capacity constraint model"""
    
    resources = get_all_resources()
    constraints = {}
    
    for resource in resources:
        constraints[resource['id']] = {
            'name': resource['name'],
            'type': resource['type'],  # Machine, Labor, Space
            
            # Base capacity
            'base_capacity': {
                'hours_per_day': resource['hours_per_day'],
                'days_per_week': resource['days_per_week'],
                'efficiency': resource['oee'],  # Overall Equipment Effectiveness
                'available_hours_weekly': calculate_available_hours(resource)
            },
            
            # Flexibility
            'flexibility': {
                'overtime_max_pct': resource.get('overtime_max', 0.20),
                'overtime_cost_multiplier': resource.get('overtime_cost', 1.5),
                'additional_shift_possible': resource.get('add_shift', False),
                'outsource_possible': resource.get('outsource', False),
                'outsource_cost': resource.get('outsource_cost', 0),
                'outsource_capacity': resource.get('outsource_capacity', 0)
            },
            
            # Constraints
            'hard_constraints': {
                'max_capacity': calculate_max_capacity(resource),
                'min_utilization': resource.get('min_util', 0),
                'maintenance_windows': get_maintenance_schedule(resource['id'])
            }
        }
    
    # Add inter-resource constraints
    constraints['cross_resource'] = model_cross_constraints(resources)
    
    return constraints

def calculate_available_hours(resource):
    """Calculate available hours accounting for efficiency"""
    
    gross_hours = (
        resource['hours_per_day'] *
        resource['days_per_week'] *
        52 / 12  # Monthly
    )
    
    # Apply OEE
    available = gross_hours * resource['oee']
    
    # Subtract planned maintenance
    maintenance = get_planned_maintenance_hours(resource['id'])
    available -= maintenance
    
    return available

def model_cross_constraints(resources):
    """Model constraints between resources"""
    
    cross_constraints = []
    
    # Shared labor pools
    labor_pools = group_by_labor_pool(resources)
    for pool_name, pool_resources in labor_pools.items():
        cross_constraints.append({
            'type': 'shared_labor',
            'resources': [r['id'] for r in pool_resources],
            'total_available': sum(r['labor_hours'] for r in pool_resources),
            'constraint': 'sum_of_labor <= total_available'
        })
    
    # Sequential dependencies
    for resource in resources:
        if resource.get('requires'):
            cross_constraints.append({
                'type': 'sequence',
                'resource': resource['id'],
                'requires': resource['requires'],
                'constraint': 'output_rate <= min(input_rate)'
            })
    
    return cross_constraints
```

---

## Step 3: Optimization Solver

### Mathematical Optimization
```python
from scipy.optimize import linprog, minimize
import numpy as np

def optimize_capacity_plan(demand, constraints, objective='minimize_cost'):
    """Run optimization solver for capacity planning"""
    
    # Build optimization model
    n_products = len(demand['product_demand'])
    n_periods = len(demand['planning_horizon'])
    n_resources = len(constraints) - 1  # Exclude cross_resource
    
    # Decision variables
    # x[p,t] = production quantity for product p in period t
    # o[r,t] = overtime hours for resource r in period t
    # s[r,t] = outsourced hours for resource r in period t
    
    decision_vars = {
        'production': np.zeros((n_products, n_periods)),
        'overtime': np.zeros((n_resources, n_periods)),
        'outsource': np.zeros((n_resources, n_periods)),
        'inventory': np.zeros((n_products, n_periods))
    }
    
    # Objective function coefficients
    if objective == 'minimize_cost':
        c = build_cost_objective(demand, constraints)
    elif objective == 'maximize_service':
        c = build_service_objective(demand, constraints)
    elif objective == 'balanced':
        c = build_balanced_objective(demand, constraints)
    
    # Constraint matrices
    A_eq, b_eq = build_equality_constraints(demand, constraints)  # Demand balance
    A_ub, b_ub = build_inequality_constraints(demand, constraints)  # Capacity limits
    
    # Variable bounds
    bounds = build_variable_bounds(demand, constraints)
    
    # Solve
    result = linprog(c, A_ub=A_ub, b_ub=b_ub, A_eq=A_eq, b_eq=b_eq, bounds=bounds)
    
    if result.success:
        solution = parse_solution(result.x, decision_vars)
        return {
            'status': 'optimal',
            'solution': solution,
            'objective_value': result.fun,
            'utilization': calculate_utilization(solution, constraints),
            'service_level': calculate_service_level(solution, demand)
        }
    else:
        return {
            'status': 'infeasible',
            'message': result.message,
            'relaxation_options': identify_relaxation_options(demand, constraints)
        }

def build_cost_objective(demand, constraints):
    """Build cost minimization objective"""
    
    costs = []
    
    # Production costs
    for product_id, product_demand in demand['product_demand'].items():
        unit_cost = get_production_cost(product_id)
        costs.extend([unit_cost] * len(product_demand['volume_forecast']))
    
    # Overtime costs
    for resource_id, resource_constraints in constraints.items():
        if resource_id == 'cross_resource':
            continue
        overtime_cost = resource_constraints['flexibility']['overtime_cost_multiplier']
        costs.extend([overtime_cost] * len(demand['planning_horizon']))
    
    # Outsourcing costs
    for resource_id, resource_constraints in constraints.items():
        if resource_id == 'cross_resource':
            continue
        outsource_cost = resource_constraints['flexibility'].get('outsource_cost', 999)
        costs.extend([outsource_cost] * len(demand['planning_horizon']))
    
    # Inventory holding costs
    for product_id in demand['product_demand']:
        holding_cost = get_holding_cost(product_id)
        costs.extend([holding_cost] * len(demand['planning_horizon']))
    
    return np.array(costs)
```

---

## Step 4: Balance Trade-offs

### Multi-Objective Optimization
```python
def balance_capacity_tradeoffs(demand, constraints):
    """Generate Pareto-optimal capacity plans"""
    
    # Run optimization for different objectives
    solutions = []
    
    # Pure cost minimization
    cost_optimal = optimize_capacity_plan(demand, constraints, 'minimize_cost')
    solutions.append({'type': 'min_cost', 'result': cost_optimal})
    
    # Pure service maximization
    service_optimal = optimize_capacity_plan(demand, constraints, 'maximize_service')
    solutions.append({'type': 'max_service', 'result': service_optimal})
    
    # Balanced solutions at different weights
    for cost_weight in [0.3, 0.5, 0.7]:
        balanced = optimize_capacity_plan(
            demand, constraints, 'balanced',
            weights={'cost': cost_weight, 'service': 1 - cost_weight}
        )
        solutions.append({'type': f'balanced_{cost_weight}', 'result': balanced})
    
    # Build Pareto frontier
    pareto = build_pareto_frontier(solutions)
    
    # AI recommendation
    recommended = ai_recommend_solution(pareto, demand, constraints)
    
    return {
        'pareto_frontier': pareto,
        'recommended': recommended,
        'trade_off_analysis': analyze_tradeoffs(pareto)
    }

def analyze_tradeoffs(pareto_solutions):
    """Analyze trade-offs between solutions"""
    
    analysis = {
        'cost_range': {
            'min': min(s['cost'] for s in pareto_solutions),
            'max': max(s['cost'] for s in pareto_solutions)
        },
        'service_range': {
            'min': min(s['service_level'] for s in pareto_solutions),
            'max': max(s['service_level'] for s in pareto_solutions)
        },
        'marginal_analysis': []
    }
    
    # Calculate marginal cost of service improvement
    sorted_solutions = sorted(pareto_solutions, key=lambda x: x['service_level'])
    for i in range(1, len(sorted_solutions)):
        prev = sorted_solutions[i-1]
        curr = sorted_solutions[i]
        
        service_gain = curr['service_level'] - prev['service_level']
        cost_increase = curr['cost'] - prev['cost']
        
        if service_gain > 0:
            analysis['marginal_analysis'].append({
                'from_service': prev['service_level'],
                'to_service': curr['service_level'],
                'marginal_cost': cost_increase / service_gain
            })
    
    return analysis

def ai_recommend_solution(pareto, demand, constraints):
    """AI recommends optimal solution from Pareto frontier"""
    
    prompt = f"""
    Recommend the best capacity plan from these options:
    
    PARETO OPTIONS:
    {format_pareto_options(pareto)}
    
    CONTEXT:
    - Current service target: {get_service_target()}%
    - Budget constraint: ${get_budget_constraint():,.0f}
    - Peak demand period: {identify_peak_period(demand)}
    - Critical products: {get_critical_products()}
    
    TRADE-OFF ANALYSIS:
    - Cost range: ${pareto['cost_range']['min']:,.0f} - ${pareto['cost_range']['max']:,.0f}
    - Service range: {pareto['service_range']['min']:.1%} - {pareto['service_range']['max']:.1%}
    
    Recommend which solution to implement and why.
    Consider: service level requirements, budget constraints, risk tolerance.
    """
    
    recommendation = call_llm(prompt)
    return recommendation
```

---

## Step 5: Scenario Analysis

### What-If Simulation
```python
def run_capacity_scenarios(demand, constraints, base_solution):
    """Run what-if scenarios on capacity plan"""
    
    scenarios = []
    
    # Demand increase scenario
    demand_up = scale_demand(demand, 1.15)
    scenario_demand_up = optimize_capacity_plan(demand_up, constraints)
    scenarios.append({
        'name': 'Demand +15%',
        'type': 'demand_increase',
        'result': scenario_demand_up,
        'impact': compare_solutions(base_solution, scenario_demand_up)
    })
    
    # Demand decrease scenario
    demand_down = scale_demand(demand, 0.85)
    scenario_demand_down = optimize_capacity_plan(demand_down, constraints)
    scenarios.append({
        'name': 'Demand -15%',
        'type': 'demand_decrease',
        'result': scenario_demand_down,
        'impact': compare_solutions(base_solution, scenario_demand_down)
    })
    
    # Resource constraint scenario
    constrained = reduce_resource_capacity(constraints, 'critical_machine', 0.80)
    scenario_constrained = optimize_capacity_plan(demand, constrained)
    scenarios.append({
        'name': 'Critical Machine -20%',
        'type': 'resource_constraint',
        'result': scenario_constrained,
        'impact': compare_solutions(base_solution, scenario_constrained)
    })
    
    # New product launch scenario
    demand_npi = add_npi_demand(demand, get_planned_npis())
    scenario_npi = optimize_capacity_plan(demand_npi, constraints)
    scenarios.append({
        'name': 'With NPI Launches',
        'type': 'npi_impact',
        'result': scenario_npi,
        'impact': compare_solutions(base_solution, scenario_npi)
    })
    
    return {
        'base_solution': base_solution,
        'scenarios': scenarios,
        'sensitivity_analysis': analyze_sensitivity(scenarios)
    }

def analyze_sensitivity(scenarios):
    """Analyze sensitivity of capacity plan to changes"""
    
    sensitivity = {}
    
    for scenario in scenarios:
        impact = scenario['impact']
        
        sensitivity[scenario['name']] = {
            'cost_sensitivity': impact['cost_change_pct'],
            'service_sensitivity': impact['service_change_pct'],
            'feasibility_impact': impact['feasibility_change'],
            'risk_level': classify_risk(impact)
        }
    
    return sensitivity
```

---

## Step 6: Recommend Plan

### AI-Selected Optimal Plan
```python
def generate_capacity_recommendation(optimization_result, scenarios, trade_offs):
    """Generate final capacity plan recommendation"""
    
    prompt = f"""
    Generate a capacity plan recommendation:
    
    OPTIMAL SOLUTION:
    - Total Cost: ${optimization_result['objective_value']:,.0f}
    - Service Level: {optimization_result['service_level']:.1%}
    - Average Utilization: {optimization_result['utilization']['average']:.1%}
    
    UTILIZATION BY RESOURCE:
    {format_utilization(optimization_result['utilization'])}
    
    SCENARIO ANALYSIS:
    {format_scenarios(scenarios)}
    
    TRADE-OFF ANALYSIS:
    {format_tradeoffs(trade_offs)}
    
    Provide:
    1. Executive summary of recommended plan
    2. Key capacity decisions by resource
    3. Overtime/outsourcing recommendations
    4. Risks and mitigation strategies
    5. Investment recommendations (if any)
    6. KPIs to monitor
    """
    
    recommendation = call_llm(prompt)
    
    # Structure the recommendation
    structured = {
        'executive_summary': extract_section(recommendation, 'summary'),
        'resource_plan': build_resource_plan(optimization_result),
        'overtime_plan': build_overtime_plan(optimization_result),
        'outsourcing_plan': build_outsourcing_plan(optimization_result),
        'risks': extract_section(recommendation, 'risks'),
        'investments': extract_section(recommendation, 'investments'),
        'kpis': define_capacity_kpis(optimization_result)
    }
    
    return structured

def build_resource_plan(optimization_result):
    """Build detailed resource-by-resource plan"""
    
    plan = []
    
    for resource_id, utilization in optimization_result['utilization']['by_resource'].items():
        resource = get_resource(resource_id)
        
        plan.append({
            'resource_id': resource_id,
            'resource_name': resource['name'],
            'planned_utilization': utilization,
            'capacity_status': 'Tight' if utilization > 0.85 else 'OK' if utilization > 0.6 else 'Excess',
            'actions': determine_resource_actions(resource, utilization)
        })
    
    return sorted(plan, key=lambda x: x['planned_utilization'], reverse=True)
```

---

## Step 7: Execute & Monitor

### Real-time Tracking
```python
def monitor_capacity_execution(plan_id):
    """Monitor capacity plan execution in real-time"""
    
    plan = get_capacity_plan(plan_id)
    
    monitoring = {
        'plan_id': plan_id,
        'timestamp': datetime.now(),
        'by_resource': {},
        'alerts': []
    }
    
    for resource in plan['resource_plan']:
        resource_id = resource['resource_id']
        
        # Get actual utilization
        actual = get_actual_utilization(resource_id)
        planned = resource['planned_utilization']
        
        variance = actual - planned
        
        monitoring['by_resource'][resource_id] = {
            'planned': planned,
            'actual': actual,
            'variance': variance,
            'status': 'ON_TRACK' if abs(variance) < 0.05 else 'VARIANCE'
        }
        
        # Generate alerts
        if actual > 0.95:
            monitoring['alerts'].append({
                'resource': resource_id,
                'type': 'OVER_CAPACITY',
                'severity': 'HIGH',
                'message': f"Resource at {actual:.0%} utilization",
                'recommendation': 'Consider overtime or demand deferral'
            })
        
        if actual < planned - 0.15:
            monitoring['alerts'].append({
                'resource': resource_id,
                'type': 'UNDER_UTILIZATION',
                'severity': 'MEDIUM',
                'message': f"Resource at {actual:.0%} vs {planned:.0%} planned",
                'recommendation': 'Review demand and consider rebalancing'
            })
    
    # Store monitoring data
    store_capacity_monitoring(monitoring)
    
    return monitoring

def reoptimize_if_needed(monitoring, plan):
    """Trigger reoptimization if significant variances detected"""
    
    significant_variances = [
        r for r in monitoring['by_resource'].values()
        if abs(r['variance']) > 0.10
    ]
    
    if len(significant_variances) > len(monitoring['by_resource']) * 0.2:
        # More than 20% of resources have significant variance
        new_demand = get_updated_demand()
        new_constraints = get_updated_constraints()
        
        new_plan = optimize_capacity_plan(new_demand, new_constraints)
        
        return {
            'reoptimization_triggered': True,
            'reason': f"{len(significant_variances)} resources with >10% variance",
            'new_plan': new_plan,
            'changes': compare_plans(plan, new_plan)
        }
    
    return {'reoptimization_triggered': False}
```

---

## Step 8: Learn & Improve

### Continuous Model Update
```python
def update_capacity_models(actuals, plan):
    """Update capacity models based on actual performance"""
    
    learnings = {
        'oee_updates': {},
        'setup_time_updates': {},
        'efficiency_factors': {}
    }
    
    for resource_id, resource_plan in plan['resource_plan'].items():
        actual_data = get_actual_production_data(resource_id)
        
        # Update OEE estimates
        actual_oee = calculate_actual_oee(actual_data)
        planned_oee = get_planned_oee(resource_id)
        
        if abs(actual_oee - planned_oee) > 0.03:
            learnings['oee_updates'][resource_id] = {
                'old_oee': planned_oee,
                'new_oee': (planned_oee + actual_oee) / 2,  # Smoothed update
                'direction': 'up' if actual_oee > planned_oee else 'down'
            }
            update_resource_oee(resource_id, learnings['oee_updates'][resource_id]['new_oee'])
        
        # Update setup times
        actual_setups = get_actual_setup_times(resource_id)
        if actual_setups:
            new_setup = np.mean(actual_setups)
            if abs(new_setup - resource_plan['setup_time']) > resource_plan['setup_time'] * 0.1:
                learnings['setup_time_updates'][resource_id] = {
                    'old': resource_plan['setup_time'],
                    'new': new_setup
                }
                update_setup_time(resource_id, new_setup)
    
    # Update cost models
    update_cost_models(actuals, plan)
    
    return learnings

def evaluate_planning_accuracy(plan_id):
    """Evaluate capacity planning accuracy for learning"""
    
    plan = get_capacity_plan(plan_id)
    actuals = get_actual_utilization_history(plan['period'])
    
    accuracy = {
        'overall_accuracy': [],
        'by_resource': {}
    }
    
    for resource_id, planned in plan['utilization']['by_resource'].items():
        actual = actuals.get(resource_id, {}).get('average', planned)
        error = abs(actual - planned)
        
        accuracy['by_resource'][resource_id] = {
            'planned': planned,
            'actual': actual,
            'error': error,
            'accuracy': 1 - error
        }
        accuracy['overall_accuracy'].append(1 - error)
    
    accuracy['mean_accuracy'] = np.mean(accuracy['overall_accuracy'])
    
    return accuracy
```

---

## Capacity Optimizer Dashboard

```
┌─────────────────────────────────────────────────────────────────┐
│  CAPACITY OPTIMIZER DASHBOARD                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PLANNING PERIOD: Q3 2026                                        │
│  OPTIMIZATION STATUS: ✓ Optimal Solution Found                  │
│                                                                  │
│  SOLUTION SUMMARY:                                               │
│  ─────────────────────────────────────────────────────────────  │
│  Total Cost:        $2,450,000                                   │
│  Service Level:     96.5%                                        │
│  Avg Utilization:   78%                                          │
│  Overtime Required: 12% of capacity                              │
│  Outsourcing:       $85,000 (3%)                                │
│                                                                  │
│  RESOURCE UTILIZATION:                                           │
│  ─────────────────────────────────────────────────────────────  │
│  Assembly Line A    ████████████████████░  92% ⚠ Near limit     │
│  Assembly Line B    ████████████████░░░░░  78%                   │
│  CNC Machine 1      ███████████████████░░  88%                   │
│  CNC Machine 2      ██████████████░░░░░░░  68%                   │
│  Paint Booth        █████████████████░░░░  82%                   │
│  Packaging          ██████████░░░░░░░░░░░  52%                   │
│                                                                  │
│  BOTTLENECK: Assembly Line A (Jul-Aug)                          │
│  ─────────────────────────────────────────────────────────────  │
│  Current capacity: 10,000 units/month                           │
│  Required: 10,800 units/month                                   │
│  Gap: 800 units → Recommend overtime + outsource                │
│                                                                  │
│  SCENARIO IMPACT:                                                │
│  Demand +15%: Feasible with $180K overtime                      │
│  Demand -15%: 65% utilization, excess capacity                  │
│  Machine down: Service drops to 89%                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*AI-powered capacity optimization for balanced cost, service, and utilization.*
