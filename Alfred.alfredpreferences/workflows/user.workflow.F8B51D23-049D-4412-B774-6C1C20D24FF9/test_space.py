#!/usr/bin/python
# encoding: utf-8
import sys
import os.path
import subprocess
from workflow import Workflow, bundler


#PWD = os.path.dirname(os.path.realpath(__file__))
#HTML_SPLICER = os.path.join(PWD, 'splicer.html')
VIEWER = bundler.utility('viewer')
#MOD_KEYS = os.path.join(PWD, 'check_modifier_keys')
# You can check for cmd, option, control, shift, and capslock


def main(wf):
    
    #print wf.settings['modes']
    print VIEWER

if __name__ == u"__main__":
    wf = Workflow()
    sys.exit(wf.run(main))
    
