Script for sql native coding query data from database
=========================================
[![Documentation Status](https://readthedocs.org/projects/lightgbm/badge/?version=latest)](https://lightgbm.readthedocs.io/)

Some application need to use SQL script query data. This library use python on top SQL native code.

Example
-----------------------------
Read data from database to pandas dataframe
```python
from pruksa_datascience.sql.sql_excecute import ds_etl

sql =   """   
            select * 
            from public.vw_sale_fact 
            limit 100
        """

df = ds_etl('test').query(sql)
print(df.iloc[:5,:4])
```

```sh
unitid projectid projectmasterid                projectname
0  CON090-0002    CON090          CON090  The Connect 9 นวมินทร์ 70
1  CON090-0006    CON090          CON090  The Connect 9 นวมินทร์ 70
2  CON090-0010    CON090          CON090  The Connect 9 นวมินทร์ 70
3  CON090-0014    CON090          CON090  The Connect 9 นวมินทร์ 70
4  CON090-0018    CON090          CON090  The Connect 9 นวมินทร์ 70
```

ETL script excecute 

```python
from pruksa_datascience.sql.sql_excecute import ds_etl

sql =   """ 
            create table sale_fact as
            select * 
            from public.vw_sale_fact 
            limit 100;
        """

ds_etl('test').excute(sql)

```