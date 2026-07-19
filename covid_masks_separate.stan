data {
  int<lower=0>N_observations;
  int<lower=0>N_categories;
  array[N_observations] int category_idx;
  vector[N_observations] deaths;
}
parameters {
  vector[N_categories] mean_category; //Average weight of chickswith a given diet
  vector<lower=0>[N_categories] sd_category; //Standard deviation for each diet
}
model {
  //Priors
  mean_category~normal(160,30); //Weakly informative prior
  sd_category~exponential(.02); //Prior for standard deviation
  //Likelihood
  for (obsin1:N_observations) {
    deaths[obs]~normal(mean_category[category_idx[obs]], sd_category[category_idx[obs]]);
  }
}
generated quantities {
  real deaths_pred;
  real mean_five;
  //Sample from the (posterior) predictive distribution of the fourth diet.
  weight_pred = normal_rng(mean_diet[4], sd_diet[4]);
  
  //Construct samples of the mean of the fifth diet.
  //We only have the prior...
  mean_five=normal_rng(160,30);
}