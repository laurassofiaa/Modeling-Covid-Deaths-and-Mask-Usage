# Modeling COVID-19 Deaths and Mask Usage

A Bayesian Data Analysis project investigating the relationship between average
face-mask usage and the number of COVID-19 deaths across different European
countries between 2020 and 2023.

## Overview

During the COVID-19 pandemic there was widespread debate about the efficacy of
face masks. This project takes a Bayesian approach to a question that has mostly
been studied with traditional statistical methods: **is there a correlation
between mask usage and the number of COVID-19 deaths?**

The analysis focuses on two variables measured across European countries:

- **Deaths per million** — COVID-19 deaths normalised by population, from
  Mathieu et al. (2020, Our World in Data).
- **Average mask usage** — the percentage of the population reporting they always
  wear a mask when leaving home, from Spira B. (2022).

To assess the relationship, three models are fit and compared:

1. Simple linear regression
2. Log-normal linear regression
3. Hierarchical log-normal linear regression

## Data

The two source datasets (death tolls and mask usage) were joined and cleaned
using Python, then reduced to keep Stan compilation times manageable.

Countries were split into three categories by average mask usage:

| Category | Mask usage range |
|----------|------------------|
| 1        | [0.00, 0.55)     |
| 2        | [0.55, 0.71)     |
| 3        | [0.71, 1.00]     |

The final dataset keeps 4 randomly chosen countries per category and samples the
death toll every 20th day. Dates are encoded as integers starting from 0.

- `preprocessed_covid_data.csv` — the preprocessed COVID + mask dataset
  (`location`, `date`, `total_deaths_per_million`, `mask_category`).

## Models

Stan model files:

- `first_simple_linear_model.stan` — a simple Bayesian linear regression
  (intercept, slope, and noise) with posterior predictive generation.
- `covid_masks_separate.stan` — a per-category model estimating a separate mean
  and standard deviation of deaths for each mask category.

The full modeling workflow (fitting, convergence/R-hat and effective-sample-size
diagnostics, model comparison via ELPD, and prior sensitivity analysis) is
carried out in the Quarto report using `brms` with the `cmdstanr` backend.

## Repository structure

```
.
├── project_report.qmd     # Final report: full analysis, models, diagnostics, appendix
├── project_report.pdf     # Rendered final report
├── data_cleaning.ipynb    # Python notebook for joining and cleaning the datasets
├── preprocessed_covid_data.csv
├── first_simple_linear_model.stan
├── covid_masks_separate.stan
└── plots/                 # Generated figures (convergence, posterior predictive checks, etc.)
```

## Requirements

**R** (report rendering and modeling):

- `ggplot2`, `dplyr`, `brms`, `cmdstanr`, `nlme`, `rstan`, `bayesplot`,
  `gridExtra`, `tidybayes`
- [CmdStan](https://mc-stan.org/cmdstanr/) installed via `cmdstanr`
- [Quarto](https://quarto.org/) to render the `.qmd` reports

**Python** (data cleaning): `pandas` (see `data_cleaning.ipynb`)

## Building the report

```bash
quarto render project_report.qmd
```

This runs the embedded R code, fits the Stan models, produces the figures in
`plots/`, and outputs `project_report.pdf` (and/or an HTML version).

## Authors

L. Toivanen, I. Tulenheimo

## References

- Mathieu, E. et al. (2020). *Coronavirus Pandemic (COVID-19)*. Our World in Data.
- Spira, B. (2022). *Correlation Between Mask Compliance and COVID-19 Outcomes in Europe*. Cureus.
- Welsch, D. (2022).
