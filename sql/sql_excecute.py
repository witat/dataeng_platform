import psycopg2
import pandas as pd
import os
import time
import datetime
import subprocess
from datetime import date
from pathlib import Path
import yaml

class ds_etl(object):
    """Data science ETL process use config YAML iin library"""
    def __init__(self, db_name):    
        """ This class will use connection database and sql path file
        in library. You can modify config.yml.
        
        Arguments:
            object {[type]} -- [description]
        """        
        super(ds_etl, self).__init__()
        cur_path = str(os.path.dirname(os.path.abspath(__file__)))
        config_path = os.path.join(cur_path, 'config.yml')
        with open(config_path , 'r') as ymlfile:
            cfg = yaml.load(ymlfile, Loader = yaml.FullLoader)

        self.conn = psycopg2.connect(dbname = db_name,
                                    host = cfg['redshift']['host'],
                                    port = cfg['redshift']['port'],
                                    user = cfg['redshift']['user'],
                                    password = cfg['redshift']['password'])

        self.sql_path = cfg['sql']['sql_path']

    def excecute(self, script_name):
        """Excecute sql and save log file to local
        
        Arguments:
            script_name {[text]} -- [SQL Script name]
        """        
        try:
            os.makedirs(os.path.join(str(Path.home()), 'DS_SQL_log'))
        except:
            pass
        log_path = os.path.join(str(Path.home()), 'DS_SQL_log')
        con = self.conn

        logfile_name = str(datetime.datetime.now())[:19].replace(':','-') + '_' + script_name + '_log_ETL.txt'
        file_log = open(os.path.join(log_path, logfile_name) ,"a", encoding="utf8")
        cur = con.cursor()
        script_sql = open(os.path.join(self.sql_path, script_name + '.sql') , "r", encoding="utf8").read().split(';')
        script_sql.remove(script_sql[-1])
        start_process = time.time()
        for query in script_sql:
            try:
                start_time = time.time()
                file_log.write(query + '\n')
                print(query)
                cur.execute(query)
                con.commit()
                file_log.write('Success at ' + str(datetime.datetime.now()) + '\n')
                print('Success at ', datetime.datetime.now())
                file_log.writelines('Take time : '+ str(time.time() - start_time) + ' seconds \n')
                print('Take time : ',time.time() - start_time, ' s')
            except Exception as e:
                print(e)
                error_message = '******************Error******************\n'
                file_log.write(error_message + str(e) + error_message)
                break

        file_log.write('\nOverall take time : ' + str(time.time() - start_process) + 'seconds')
        file_log.close()
        con.close()

if __name__ == "__main__": 
    # Extract data from orginal data source
    ds_etl('test').excecute('getdataunitbyleadoppsdashboard_crm')
    ds_etl('test').excecute('getdataleadoppsdashboard_crm')
    ds_etl('test').excecute('vw_sale_fact')
    ds_etl('test').excecute('rpt_datacustomerprofile_crm')
    ds_etl('test').excecute('target_label_beforebook')
    ds_etl('test').excecute('tmp_crm_lead_before_book')
    ds_etl('test').excecute('data_model_winback_beforebook')
    ds_etl('dev_edw').excecute('tmp')

    # Data mart for use


    