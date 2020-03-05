Pruksa data science project
=========================================
[![Documentation Status](https://readthedocs.org/projects/lightgbm/badge/?version=latest)](https://lightgbm.readthedocs.io/)
[![Join Gitter at https://gitter.im/Microsoft/LightGBM](https://badges.gitter.im/Microsoft/LightGBM.svg)](https://gitter.im/Microsoft/LightGBM?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Slack](https://lightgbm-slack-autojoin.herokuapp.com/badge.svg)](https://lightgbm-slack-autojoin.herokuapp.com)

LightGBM is a gradient boosting framework that uses tree based learning algorithms. It is designed to be distributed and efficient with the following advantages:

- Faster training speed and higher efficiency.
- Lower memory usage.
- Better accuracy.
- Support of parallel and GPU learning.
- Capable of handling large-scale data.

For further details, please refer to [Features](https://github.com/microsoft/LightGBM/blob/master/docs/Features.rst).

Benefitting from these advantages, LightGBM is being widely-used in many [winning solutions](https://github.com/microsoft/LightGBM/blob/master/examples/README.md#machine-learning-challenge-winning-solutions) of machine learning competitions.

[Comparison experiments](https://github.com/microsoft/LightGBM/blob/master/docs/Experiments.rst#comparison-experiment) on public datasets show that LightGBM can outperform existing boosting frameworks on both efficiency and accuracy, with significantly lower memory consumption. What's more, [parallel experiments](https://github.com/microsoft/LightGBM/blob/master/docs/Experiments.rst#parallel-experiment) show that LightGBM can achieve a linear speed-up by using multiple machines for training in specific settings.

Get Started and Documentation
-----------------------------

Our primary documentation is at https://lightgbm.readthedocs.io/ and is generated from this repository. If you are new to LightGBM, follow [the installation instructions](https://lightgbm.readthedocs.io/en/latest/Installation-Guide.html) on that site.

Next you may want to read:

- [**Examples**](https://github.com/microsoft/LightGBM/tree/master/examples) showing command line usage of common tasks.
- [**Features**](https://github.com/microsoft/LightGBM/blob/master/docs/Features.rst) and algorithms supported by LightGBM.
- [**Parameters**](https://github.com/microsoft/LightGBM/blob/master/docs/Parameters.rst) is an exhaustive list of customization you can make.
- [**Parallel Learning**](https://github.com/microsoft/LightGBM/blob/master/docs/Parallel-Learning-Guide.rst) and [**GPU Learning**](https://github.com/microsoft/LightGBM/blob/master/docs/GPU-Tutorial.rst) can speed up computation.
- [**Laurae++ interactive documentation**](https://sites.google.com/view/lauraepp/parameters) is a detailed guide for hyperparameters.

Documentation for contributors:

- [**How we update readthedocs.io**](https://github.com/microsoft/LightGBM/blob/master/docs/README.rst).
- Check out the [**Development Guide**](https://github.com/microsoft/LightGBM/blob/master/docs/Development-Guide.rst).

External (Unofficial) Repositories
----------------------------------

SHAP (model output explainer): https://github.com/slundberg/shap

LightGBM.NET (.NET/C#-package): https://github.com/rca22/LightGBM.Net

Dask-LightGBM (distributed and parallel Python-package): https://github.com/dask/dask-lightgbm


Reference Papers
----------------

Guolin Ke, Qi Meng, Thomas Finley, Taifeng Wang, Wei Chen, Weidong Ma, Qiwei Ye, Tie-Yan Liu. "[LightGBM: A Highly Efficient Gradient Boosting Decision Tree](https://papers.nips.cc/paper/6907-lightgbm-a-highly-efficient-gradient-boosting-decision-tree)". Advances in Neural Information Processing Systems 30 (NIPS 2017), pp. 3149-3157.

Qi Meng, Guolin Ke, Taifeng Wang, Wei Chen, Qiwei Ye, Zhi-Ming Ma, Tie-Yan Liu. "[A Communication-Efficient Parallel Algorithm for Decision Tree](http://papers.nips.cc/paper/6380-a-communication-efficient-parallel-algorithm-for-decision-tree)". Advances in Neural Information Processing Systems 29 (NIPS 2016), pp. 1279-1287.

Huan Zhang, Si Si and Cho-Jui Hsieh. "[GPU Acceleration for Large-scale Tree Boosting](https://arxiv.org/abs/1706.08359)". SysML Conference, 2018.

**Note**: If you use LightGBM in your GitHub projects, please add `lightgbm` in the `requirements.txt`.

License
-------

This project is licensed under the terms of the Pruksa license. 