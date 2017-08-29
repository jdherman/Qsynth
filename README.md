### Synthetic streamflow generator (Qsynth)

Matlab implementation of a weekly synthetic streamflow generator based on Cholesky decomposition. Extends the method developed by Kirsch et al. (2013) to allow for adjustable frequency and severity of droughts.

**Citations:**

* Herman, J.D, H.B. Zeff, J.R. Lamontagne, P.M. Reed, and G.W. Characklis, [Synthetic drought scenario generation to support bottom-up water supply vulnerability assessments](http://ascelibrary.org/doi/full/10.1061/%28ASCE%29WR.1943-5452.0000701), Journal of Water Resources Planning and Management, 142(11), 04016050, 2016.

* Kirsch, B. R., G. W. Characklis, and H. B. Zeff (2013), [Evaluating the impact of alternative hydro-climate scenarios on transfer agreements: Practical improvement for generating synthetic streamflows](http://ascelibrary.org/doi/10.1061/%28ASCE%29WR.1943-5452.0000287), Journal of Water Resources Planning and Management, 139(4), 396–406.


#### Quick start
Historical data are included in `inflow-data`. See `main.m` for an example of generating multiple realizations of synthetic flows. Make sure the output directory `inflow-synthetic/` exists.

A single realization can be generated like this:

```matlab
Qs = Qsynth(Qh, num_years, p, n);
```

where `Qh` is a cell array containing historical streamflow matrices, and `num_years` is the desired length of the synthetic record. 

`p` and `n` are optional parameters to adjust the frequency of droughts. In the synthetic record, the `p`th percentile historical flow will become `n` times more frequent. Recommended values of `p` are `(0.05, 0.30)` (lower, if the observed record is very long) and `n` in the range `(1.0, 5.0)`. To reproduce historical statistics, these parameters can be omitted:

```matlab
Qs = Qsynth(Qh, num_years);
```

The rest of the example in `main.m` is just reshaping matrices so that the output files contain one realization per row. This is not required.

After the files in `inflow-synthetic/` have been created, `test_autocorr.m` and `test_spatial_corr.m` can be used to compare the historical and synthetic autocorrelation and cross-correlation. These should approximately match.
