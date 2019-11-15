

# A _post hoc_ test for the Sharpe ratio

[![Build Status](https://travis-ci.org/shabbychef/posthoc_sr.svg?branch=master)](https://travis-ci.org/shabbychef/posthoc_sr)

This repository contains the `knitr` source code to generate the
paper, ['A _post hoc_ test on the Sharpe ratio'](https://arxiv.org/abs/1911.04090).
The test is an analogue of Tukey's HSD procedure used in classical
testing of equality of means, but applied to the Sharpe ratio.
The test is applicable under a simple common correlation among
asset returns, and uses a normal approximation. A heuristic
modification appears to give near nominal type I rates in simulations.

## This document

The document itself is written in `knitr`. You should be able to run the code
and build the document via `make` as follows:


```bash
make help
# knit the code; could take a while
touch posthoc.Rnw
make posthoc.tex
# build the document
make posthoc.pdf
```

You can also generate all the R code as follows:

```bash
make posthoc.R
```

<!-- modelines -->
<!-- vim:ts=2:sw=2:tw=96:fdm=marker:syn=markdown:ft=markdown:ai:nocin:nu:fo=ncroqlt:cms=<!--%s-->
