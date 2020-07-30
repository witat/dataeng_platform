Data science and Data engineer platform
=========================================
[![Documentation Status](https://readthedocs.org/projects/lightgbm/badge/?version=latest)](https://lightgbm.readthedocs.io/)
[![Join Gitter at https://gitter.im/Microsoft/LightGBM](https://badges.gitter.im/Microsoft/LightGBM.svg)](https://gitter.im/Microsoft/LightGBM?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Pruksa data science library is framework that uses version control. It is designed to be distributed and efficient with the following advantages:

- Faster tracking.
- Faster transfer knownlegde.
- Easy to collaboration.
- Easy debug.
- Control coding pattern.

Get Started and installation
-----------------------------
Install library 
```sh
# git bash windows version
cd C:/ProgramData/Anaconda3/Lib/site-packages # Default library Anaconda3
git clone https://*{username}*:*{password}*@gitlab.com/pruksa_data_science/pruksa_data_science.git # * ใส่ของตัวเองครับ
```
Install requirement package
```sh
pip install -r requirements.txt
```

Main code
-----------------------------
- Data engineer platform (https://github.com/witat/dataeng_platform/blob/master/sql/sql_excecute.py)
- Model link : model/lightgbm.py

Reference Papers
----------------

Guolin Ke, Qi Meng, Thomas Finley, Taifeng Wang, Wei Chen, Weidong Ma, Qiwei Ye, Tie-Yan Liu. "[LightGBM: A Highly Efficient Gradient Boosting Decision Tree](https://papers.nips.cc/paper/6907-lightgbm-a-highly-efficient-gradient-boosting-decision-tree)". Advances in Neural Information Processing Systems 30 (NIPS 2017), pp. 3149-3157.

Qi Meng, Guolin Ke, Taifeng Wang, Wei Chen, Qiwei Ye, Zhi-Ming Ma, Tie-Yan Liu. "[A Communication-Efficient Parallel Algorithm for Decision Tree](http://papers.nips.cc/paper/6380-a-communication-efficient-parallel-algorithm-for-decision-tree)". Advances in Neural Information Processing Systems 29 (NIPS 2016), pp. 1279-1287.

Huan Zhang, Si Si and Cho-Jui Hsieh. "[GPU Acceleration for Large-scale Tree Boosting](https://arxiv.org/abs/1706.08359)". SysML Conference, 2018.


License
-------

This project is licensed under the terms of the Pruksa license. 
