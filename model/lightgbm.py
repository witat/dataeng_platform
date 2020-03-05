import numpy as np
import pandas as pd
import lightgbm as lgb

from sklearn.metrics import roc_auc_score
from sklearn.model_selection import GridSearchCV
from sklearn.datasets import load_breast_cancer

class light_gbm(object):
    """Train model with lightgbm library
    
    Arguments:
            x_train {[DataFrame]} -- [Table for train model]
            y_train {[DataFrame]} -- [Target label train]
            x_test {[DataFrame]} -- [Table for test model]
            y_test {[DataFrame]} -- [Target label test]
    """
    def __init__(self, x_train, y_train, x_test, y_test):              
        self.x_train = x_train
        self.y_train = y_train
        self.x_test = x_test
        self.y_test = y_test

    def grid_search(self):
        model = lgb.LGBMClassifier()
        param_grid = {
            'num_leaves':[6,8,16,20],
            'min_data_in_leaf': [100, 150, 200],
            'metric':['auc']
        }

        gbm = GridSearchCV(model, param_grid, cv = 3)
        gbm.fit(self.x_train, self.y_train)

        print(gbm.best_params_)
        return gbm.best_params_

    def predict(self, best_params):
        gbm = lgb.LGBMClassifier().set_params(**best_params)
        gbm.fit(self.x_train, self.y_train,
                eval_set=[(self.x_test, self.y_test)],
                eval_metric='auc',
                early_stopping_rounds=10)

        print('\nStarting predicting...\n')
        y_pred = gbm.predict(self.x_test, num_iteration=gbm.best_iteration_)
        
        return y_pred

    def main(self):
        model = light_gbm(self.x_train, 
                          self.y_train, 
                          self.x_test, 
                          self.y_test)
        params = model.grid_search()
        predict = model.predict(params)

        print(predict)
        


if __name__ == "__main__":
    
    data = load_breast_cancer()
    df_x = pd.DataFrame(data.data, columns = data.feature_names)
    df_y = data.target

    model = light_gbm(df_x, df_y, df_x, df_y)
    model.main()
    
    # predict = model.train(params)
        

