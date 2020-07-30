import psycopg2
import csv
import numpy
import pandas as pd
import os
import time
import datetime
import subprocess
from datetime import date
from pathlib import Path
import pymssql
import yaml
import boto3
from datetime import date, timedelta
from boto3.session import Session
import os
import psycopg2
import smtplib 
from email.mime.multipart import MIMEMultipart 
from email.mime.text import MIMEText 
from email.mime.base import MIMEBase 
from email import encoders
from datetime import datetime

os.chdir('D:/')
today = date.today() - timedelta(days=7)
d1 = today.strftime("%Y-%m-%d")

class ds_etl(object):
    """ Data science ETL process use config YAML iin library
        This class will use connection database and sql path file
        in library. You can modify config.yml.
        
        Arguments:
            object {[db_name]} -- [Database name from cloud database platform]
            """
    def __init__(self, system, db_name):    
        """ This class will use connection database and sql path file
        in library. You can modify config.yml.
        
        Arguments:
            object {[system]} -- [Database name from cloud database platform]
            object {[db_name]} -- [Database name from cloud database platform]

        """        
        super(ds_etl, self).__init__()
        cur_path = str(os.path.dirname(os.path.abspath(__file__)))
        config_path = os.path.join(cur_path, 'config.yml')
        with open(config_path , 'r') as ymlfile:
            cfg = yaml.load(ymlfile, Loader = yaml.FullLoader)

        session = Session(
                        aws_access_key_id=cfg['aws']['ACCESS_KEY_ID'],
                        aws_secret_access_key=cfg['aws']['SECRET_ACCESS_KEY']
                    )

        self.BUCKET_NAME = cfg['aws']['BUCKET_NAME']
        self.s3 = session.client("s3")

        if system == 'redshift':
            self.conn = psycopg2.connect(dbname = db_name,
                                        host = cfg['redshift']['host'],
                                        port = cfg['redshift']['port'],
                                        user = cfg['redshift']['user'],
                                        password = cfg['redshift']['password'])
        elif system == 'pspro':
            self.conn = pymssql.connect(server = cfg['pspro']['host'],
                                        port = cfg['pspro']['port'],
                                        user = cfg['pspro']['user'],
                                        password = cfg['pspro']['password'])
                                    

        self.sql_path = cfg['sql']['sql_path']
        self.email_sender = cfg['email']['sender_email']
        self.email_sender_pass = cfg['email']['sender_password']

    
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
    
    def single_script(self, script_name):
        sql = open(os.path.join(self.sql_path, script_name + '.sql') , "r", encoding="utf8").read().split(';')
        sql.remove(sql[-1])
        print(sql[0])
        return pd.read_sql(sql[0], con = self.conn)

    def query(self, sql):
        return pd.read_sql(sql, con = self.conn)
    
    def upload_s3(self, file_name):
        s3.upload_file(file_name, self.BUCKET_NAME, 'Test/'+ file_name+'.csv')
    
    def load_dwh(self, script_name, table_name):
        sql = open(os.path.join(self.sql_path, script_name + '.sql') , "r", encoding="utf8").read().split(';')
        sql.remove(sql[-1])

        filename = table_name + '.csv'
        df = ds_etl('pspro', 'test').query(sql[0])
        df.to_csv(filename, index=False, 
                            sep = '|',
                            encoding = 'utf8',
                            quoting=csv.QUOTE_ALL)

        schema = 'dwh_load'

        sql_droptable = 'DROP TABLE IF EXISTS {}.'.format(schema) + table_name + ';'

        create_table = 'create table if not exists {}.'.format(schema) + table_name + ' ('

        for i in range(len(df.columns)):
            if df.dtypes[i] == 'object':
                create_table = (create_table + '\n{} VARCHAR(256),').format(df.columns[i])
            elif df.dtypes[i] == 'int64':
                create_table = (create_table + '\n{} INT,').format(df.columns[i])
            elif df.dtypes[i] == 'float64':
                create_table = (create_table + '\n{} FLOAT,').format(df.columns[i])
            elif df.dtypes[i] == 'datetime64[ns]':
                create_table = (create_table + '\n{} TIMESTAMP,').format(df.columns[i])
        create_table = create_table[:-1] + ');'
        print(create_table)
        redshift = psycopg2.connect(
        host='redshift-pruksa-datasource.c63llnrhdm9w.ap-southeast-1.redshift.amazonaws.com',
        user='witit_r',
        port=5439,
        password='P@ssw0rd',
        dbname='test')

        cur = redshift.cursor()
        cur.execute(sql_droptable)
        redshift.commit()

        cur.execute(create_table)
        redshift.commit()
        

        self.s3.upload_file(filename, self.BUCKET_NAME, 'Test/' + filename)

        sql = """copy {}.{} from 's3://aws-emr-resources-852689515467-ap-southeast-1/Test/{}.csv'
        access_key_id ####
        secret_access_key #####
        region 'ap-southeast-1'
        ignoreheader 1
        null as 'NA'
        removequotes
        delimiter '|';""".format(schema, table_name, table_name)

        cur.execute(sql)
        redshift.commit()

    def send_email(self, file_path, filename):
        now = datetime.now() # current date and time
        date_time = now.strftime("%d_%m_%Y")

        file_path = "D:/Users/witat_r/Documents/project_status_segment.xlsx"
        filename = filename + '_' + date_time + '.xlsx'

        sender_address = r'witat_r@pruksa.com'
        sender_pass = r'1901Wpwj#'
        receiver_address = 'peera_b@pruksa.com'
        receiver_cc_address = 'peera_b@pruksa.com,sastrawut_p@pruksa.com'

        msg = MIMEMultipart()  
        msg['From'] = sender_address 
        msg['To'] = receiver_address 
        msg['Cc'] = receiver_cc_address 
        msg['Subject'] = "Project status by segment " + date_time
        body = "ไฟล์ Project status by segment"
        
        # attach the body with the msg instance 
        msg.attach(MIMEText(body, 'plain')) 
        attachment = open(file_path, "rb") 
        p = MIMEBase('application', 'octet-stream') 
        p.set_payload((attachment).read()) 
        encoders.encode_base64(p) 
        p.add_header('Content-Disposition', "attachment; filename= %s" % filename) 
        msg.attach(p) 

        # creates SMTP session 
        s = smtplib.SMTP('smtp.gmail.com', 587) 
        s.starttls() 
        s.login(sender_address, sender_pass) 
        text = msg.as_string() 
        s.sendmail(sender_address, receiver_address, text) 
        s.quit() 

if __name__ == "__main__": 
    # Extract data from orginal data source

    df = ds_etl('redshift', 'test').query('select * from ds.defect limit 10')

    # Data mart for use


    
