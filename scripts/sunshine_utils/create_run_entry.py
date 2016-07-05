import xml.etree.ElementTree as ET
import subprocess
import os
import json

LID = os.getenv('LID')

subprocess.run('wget http://169.254.169.254/latest/meta-data/instance-id -q -O instance-id', shell=True)
instance_id = open('instance-id').read()

files = ['env_run.xml', 'env_build.xml', 'env_mach_pes.xml', 'env_case.xml']

dynamo_cmd = """
aws dynamodb put-item \
  --table-name CESM_Runs \
  --region us-west-2 \
  --item file://run_item.json
"""

item = {
    "InstanceId": { "S": instance_id },
    "CreatedTime": { "S": LID },
    "S3Prefix": { "S": "s3://cesm-output-data/{}-{}".format(instance_id, LID) }
}
for f in files:
    tree = ET.parse(f)
    root = tree.getroot()
    for child in root:
        if child.tag != 'entry':
            continue
        if child.attrib['value'] == '':
            continue
        item[child.attrib['id']] = { "S": child.attrib['value'] }

with open('run_item.json', 'w') as fd:
    fd.write(json.dumps(item))

subprocess.run(dynamo_cmd, shell=True)
