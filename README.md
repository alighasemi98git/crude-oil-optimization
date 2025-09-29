# Crude Oil Optimization

This project addresses a **nonlinear optimization problem** faced by the petrochemical company *Oljeblandarna* in planning the production and refining of crude oil over a three-week period. The objective is to **maximize expected profit** by optimizing crude oil purchases, conversions, storage, and sales under uncertainty and nonlinear effects.

## Project Overview

* **Problem Type:** Applied nonlinear programming (NLP)
* **Context:** Production planning in the petrochemical industry
* **Planning Horizon:** 3 weeks
* **Key Features:**

  * Stochastic crude oil supply modeled via a normal distribution
  * Nonlinear storage losses for intermediate products
  * Deterministic and advanced nonlinear formulations
  * Implementation and solution using **GAMS**

## Models

1. **Basic NLP Model**

   * Incorporates uncertainty in crude oil supply
   * Results in globally optimal solutions due to concavity of the objective function

2. **Advanced NLP Model**

   * Extends the basic model with nonlinear storage decay
   * Introduces nonconvexities, requiring global solvers or relaxation techniques for guaranteed optimality

## Results

* **Basic Model Profit:** ~294,835 kr
* **Advanced Model Profit:** ~292,266 kr
* Product A is consistently sold at its maximum weekly cap due to profitability
* Product B requires dynamic handling through storage, reconversion, and sales

## Key Insights

* Increasing the sales cap for Product A, particularly in Week 1, significantly boosts profit
* The advanced model provides a more realistic but slightly less profitable strategy due to storage decay
* Sensitivity analysis of constraints highlights potential operational improvements

## Repository Structure

```
.
├── models/
│   ├── basic_model.gms        # GAMS implementation of basic NLP model
│   ├── advanced_model.gms     # GAMS implementation with nonlinear storage losses
│
├── results/
│   ├── basic_results.txt      # Output summary for basic model
│   ├── advanced_results.txt   # Output summary for advanced model
│
├── report/
│   └── Project_Report.pdf     # Full academic report
│
└── README.md
```

## Usage Instructions

### Requirements

* [GAMS](https://www.gams.com/download/) (General Algebraic Modeling System)

### Running the Models

1. Clone this repository:

   ```bash
   git clone https://github.com/<your-username>/crude-oil-optimization.git
   cd crude-oil-optimization/models
   ```

2. Run the **basic model**:

   ```bash
   gams basic_model.gms
   ```

3. Run the **advanced model**:

   ```bash
   gams advanced_model.gms
   ```

4. Results will be written to `.lst` and `.txt` files in the `results/` directory.

## Potential Improvements

* Use of **truncated distributions** for more realistic crude oil supply modeling
* Adoption of **robust optimization** to handle worst-case scenarios
* Incorporation of **nonlinear or time-varying demand functions**

## Technologies

* **GAMS**: for mathematical modeling and solving NLP problems
* **Mathematical Optimization**: stochastic programming, nonlinear constraints, convexity analysis

## Authors

* Ali Ghasemi ([aghasemi@kth.se](mailto:aghasemi@kth.se))
* Ludwig Horvath ([ludhor@kth.se](mailto:ludhor@kth.se))
* Sofia Simões ([ssimoes@kth.se](mailto:ssimoes@kth.se))

*KTH Royal Institute of Technology – SF2822 Applied Nonlinear Optimization (2024/2025)*

---

📄 This repository contains the mathematical formulations, GAMS code, and report analyzing the efficiency of the proposed production strategy.
