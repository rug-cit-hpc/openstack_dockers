#!/bin/env puthon3

"""
Builds the containers from .drone.yml locally.
Pushes them to the repo as well.
(you need to be logged in)
Only builds containers from the branch that is currently checked out.
Depends on the sh module. (python3-sh package on debian/ubuntu)
"""


import sh
from yaml import load, CLoader as Loader

branch = sh.git('rev-parse', '--abbrev-ref', 'HEAD').strip()

with open('.drone.yml') as f:
    data = load(f.read(), Loader=Loader)

for image in data['pipeline'].keys():
    if (data['pipeline'][image]['image'] == 'plugins/docker'
            and branch == data['pipeline'][image]['when']['branch']):
        sh.docker(
            'build', data['pipeline'][image]['context'], '-t', '{}:{}'.format(
                data['pipeline'][image]['repo'],
                data['pipeline'][image]['tag']))
        print('Build {}'.format(data['pipeline'][image]['repo']))
        sh.docker('push', data['pipeline'][image]['repo'])
        print('Pushed {}'.format(data['pipeline'][image]['repo']))
