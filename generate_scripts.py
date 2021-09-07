#!/usr/bin/env python3
import csv
import os
import shutil
import sys
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader

with open("config.yml", 'r') as stream:
    config = yaml.safe_load(stream)

d = {k: Path(os.path.expandvars(v)) for k, v in config['dir'].items()}
config['dir'].update(d)

comt_count = 2 # Minimun start line of the data (w/o any comment)
data_count = -1 # Skip header line
with open(config['dir']['metadata'], 'r') as fh:
    for row in csv.reader(fh, delimiter=','):
        if row[0].startswith('#'):
            comt_count += 1
        else:
            data_count += 1

with open('workflow.yml', 'r') as stream:
    workflow = yaml.safe_load(stream)

scripts_dir = f'{config["dir"]["working_dir"]}/scripts'
try:
    Path(scripts_dir).mkdir(parents=True)
except:
    check = input('Overwrite the current scripts folder? (Y/N) ')
    if check == 'Y' or check == 'y':
        shutil.rmtree(scripts_dir)
        Path(scripts_dir).mkdir(parents=True)
    else:
        sys.exit()


for step, param in workflow.items():
    prog_dir = os.path.join('param', param['class'])

    env = Environment(loader=FileSystemLoader(prog_dir))
    template = env.get_template(f'{param["program"]}.bash.j2')
    template = template.render(**workflow[step], **config['dir'], **
                               config['param'], total_tasks=data_count, line_start=comt_count)

    with open(f'{scripts_dir}/{step}.bash', 'w') as fh:
        fh.write(template)
