import subprocess
import os
from os import listdir
import json
import sys

LID = os.getenv('LID')
OUTPUT_DIR = '/var/cesm/output'

subprocess.run('wget http://169.254.169.254/latest/meta-data/instance-id -q -O instance-id', shell=True)
instance_id = open('instance-id').read()
s3prefix = 's3://cesm-output-data/{}-{}/'.format(instance_id, LID)

# ---------------------------------------------
# Process data into time series and send to S3
# ---------------------------------------------

model_data = {
    'ocn': {'prefix': 'case1.pop.h'},
    'atm': {'prefix': 'case1.cam.h0'},
    'lnd': {'prefix': 'case1.clm2.h0'},
    'ice': {'prefix': 'case1.cice.h'},
    'rof': {'prefix': 'case1.rtm.h0'}
}

for model in model_data.keys():
    dirname = '{}/{}/hist'.format(OUTPUT_DIR, model)
    prefix = model_data[model]['prefix']

    files = [x for x in listdir(dirname) if x.startswith(prefix)]
    if len(files) == 0:
        print('no data files found for {}'.format(model))
        continue
    example_file = files[0] # assume all data files have the same vars

    subprocess.run('ncks -m {} > var_info'.format(example_file), cwd=dirname, shell=True)
    varnames = []
    with open('{}/var_info'.format(dirname)) as fd:
        lines = fd.readlines()
        # example line: 
        for x in lines:
            if 'sizeof' in x:
                varnames.append(x.split(' ')[0])
    for varname in varnames:
        subprocess.run('ncrcat -v {} {}*.nc ts_{}.nc'.format(varname, prefix, varname),
            cwd=dirname, shell=True)
    subprocess.run('aws s3 cp {} {}output/{}/ --recursive --include "ts_*.nc" --exclude "*"'.format(
        dirname, s3prefix, model), cwd=dirname, shell=True)
    try:
        subprocess.run('rm ts_*', cwd=dirname, shell=True)
    except:
        print('no time series to delete')

# ---------------------------------------------
# Timing & Logs
# ---------------------------------------------

try:
    subprocess.run('aws s3 cp ccsm_timing.case1.{} {}timing/'.format(LID, s3prefix), cwd='/var/cesm/case1/timing', shell=True)
except:
    print('timing file not found')

# ---------------------------------------------
# Update dynamo
# ---------------------------------------------

dynamo_cmd = """
aws dynamodb put-item \
  --table-name CESM_Run_Updates \
  --region us-west-2 \
  --item file://run_item.json
"""
item = {
    "InstanceId": { "S": instance_id },
    "CreatedTime": { "S": LID },
    "S3Prefix": { "S": "s3://cesm-output-data/{}-{}".format(instance_id, LID) }
}
with open('run_item.json', 'w') as fd:
    fd.write(json.dumps(item))

subprocess.run(dynamo_cmd, shell=True)

