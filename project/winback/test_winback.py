from pruksa_datascience.model import lightgbm as lgb
from sklearn.datasets import load_breast_cancer
from sklearn.ensemble import RandomForestClassifier


data = load_breast_cancer()
df_x = pd.DataFrame(data.data, columns = data.feature_names)
df_y = data.target

model = lgb.light_gbm(df_x, df_y, df_x, df_y)
model.main()



        