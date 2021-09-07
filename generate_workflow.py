#!/usr/bin/env python3
import os
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader

with open("config.yml", 'r') as stream:
    config = yaml.safe_load(stream)

d = {k: Path(os.path.expandvars(v)) for k, v in config['dir'].items()}
config['dir'].update(d)

workflow = dict()
idx = 1
for prog in config['workflow']:
    env = Environment(loader=FileSystemLoader(
        os.path.join(config['dir']['working_dir'], 'param', prog)))
    template = env.get_template(f'{prog}.yml.j2')
    template = template.render(**config['dir'], **config['param'])
    for prog_conf in yaml.safe_load_all(template):
        workflow[f'{idx}_{prog_conf["program"]}'] = prog_conf
        idx += 1

with open('workflow.yml', 'w') as fh:
    yaml.safe_dump(workflow, fh, default_flow_style=False, sort_keys=False)
