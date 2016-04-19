from fabric.api import run
from fabric.api import env
from fabric.api import sudo

idef node_run_cmd(cmd):
    run(cmd)

def node_run_sudo_cmd(cmd, sudo_pw):
    env.password = sudo_pw
    sudo(cmd)
