import os
import sys
from argparse import ArgumentParser
from json import load
from workflow import Workflow, MATCH_ALL, MATCH_ALLCHARS, ICON_WARNING
from workflow.background import run_in_background, is_running
from commons import run_alfred, actions, states, open_terminal

logger = None
VAGRANT_HOME = os.path.expanduser('~/.vagrant.d')
VAGRANT_INDEX = os.path.join('data', 'machine-index', 'index')
ICONS_STATES_PATH = os.path.join(Workflow().workflowdir, 'icons', 'states')
ICONS_ACTION_PATH = os.path.join(Workflow().workflowdir, 'icons', 'actions')
MATCH_RULE = MATCH_ALL ^ MATCH_ALLCHARS


def get_machine_data():
    vagrant_home = os.environ.get('VAGRANT_HOME', VAGRANT_HOME)
    index_path = os.path.join(vagrant_home, VAGRANT_INDEX)
    with open(index_path) as index:
        data = load(index)
    validate_version(data['version'])
    return data['machines']


def get_state_icon(state, provider):
    """
    Return appropriate icon path for state
    """
    norm_state = normalize_state(state)
    icon = os.path.join(ICONS_STATES_PATH,
                        '{0}.{1}.png'.format(provider, norm_state))
    default = os.path.join(ICONS_STATES_PATH,
                           'vagrant.{0}.png'.format(norm_state))

    if os.path.isfile(icon):
        return icon
    elif os.path.isfile(default):
        return default
    else:
        return None


def get_action_icon(action):
    """
    Return icon path for action
    """
    icon = os.path.join(ICONS_ACTION_PATH, '{0}.png'.format(action))
    if os.path.isfile(icon):
        return icon
    else:
        return None


def normalize_state(state):
    """
    Normalize environment state
    """
    for states_tup, output in states.iteritems():
        if state in states_tup:
            return output

    return 'unexpected'


def get_search_key(machine):
    """
    Return search key to be used by Workflow.filter
    """
    meta = machine[1]
    fields = [meta['name'],
              meta['vagrantfile_path'],
              meta['provider']]
    return ' '.join(fields)


def list_machines(machines, wf):
    subtitles_dict = {
        'cmd': 'Run commands on whole environment',
        'shift': 'Open directory in terminal',
    }

    for mid, meta in machines.iteritems():
        wf.add_item(title=meta['name'],
                    subtitle=meta['vagrantfile_path'],
                    modifier_subtitles=subtitles_dict,
                    arg='{0} {1}'.format(mid, meta['vagrantfile_path']),
                    uid=mid,
                    valid=True,
                    icon=get_state_icon(meta['state'], meta['provider']))


def list_actions(eid, filtered_actions, wf):
    if os.path.isdir(eid):
        def test(info):
            return not info['dir_action']
    else:
        machine_data = get_machine_data()
        state = normalize_state(machine_data[eid]['state'])
        norm_state = normalize_state(state)

        def test(info):
            return norm_state not in info['state']

    for action, prop in filtered_actions.iteritems():
        if test(prop):
            continue
        wf.add_item(title=action,
                    subtitle=prop['desc'],
                    uid=action,
                    arg='{0} {1!r}'.format(
                        eid, ' '.join([action, prop['flags'] or ''])),
                    icon=get_action_icon(action),
                    valid=True)


def validate_version(version):
    if version != 1:
        raise Exception('Unsupported index version')


def show_warning(title, subtitle, wf):
    wf.add_item(title=title,
                subtitle=subtitle,
                icon=ICON_WARNING,
                valid=False)


def do_list(args, wf):
    machine_data = get_machine_data()
    wf.cache_data('id', None)
    if args.list:
        machine_data = dict(wf.filter(query=args.list,
                                      items=machine_data.items(),
                                      key=get_search_key,
                                      match_on=MATCH_RULE))
    list_machines(machine_data, wf)


def do_set(args, wf):
    args.set.append(True)
    logger.debug('saving id: {0}'.format(args.set))
    wf.cache_data('id', args.set)
    run_alfred(':vagrant-id ')


def do_setenv(args, wf):
    args.setenv.append(False)
    logger.debug('saving id: {0}'.format(args.setenv))
    wf.cache_data('id', args.setenv)
    run_alfred(':vagrant-id ')


def do_get(args, wf):
    cached_data = wf.cached_data('id', max_age=0)
    if cached_data is None:
        raise RuntimeError('No environment id cached')
    mid, vagrantfile_dir, flag = cached_data
    logger.debug('retrieved mid: {0}\n'
                 'vagrantfile_dir: {1}\n'
                 'flag: {2}'.format(mid, vagrantfile_dir, flag))
    task_name = 'exec_{0}'.format(hash(vagrantfile_dir))
    if is_running(task_name):
        show_warning('Task in progress',
                     'Please wait for previous task '
                     'on this environment to finish', wf)
    else:
        filtered_actions = actions
        if args.get:
            filtered_actions = dict(wf.filter(query=args.get,
                                              items=actions.items(),
                                              key=lambda action: action[0],
                                              match_on=MATCH_RULE))
        eid = mid if flag else vagrantfile_dir
        list_actions(eid, filtered_actions, wf)


def do_execute(args, wf):
    machine_data = get_machine_data()
    wf.cache_data('id', None)
    vpath = args.execute[0]
    if not os.path.isdir(vpath):
        vpath = machine_data[args.execute[0]]['vagrantfile_path']
    task_name = 'exec_{0}'.format(hash(vpath))
    cmd = ['/usr/bin/python', 'execute.py'] + args.execute
    run_in_background(task_name, cmd)


def main(wf):
    parser = ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--list',
                       nargs='?',
                       const='',
                       metavar='FILTER',
                       help='List Vagrant environments. '
                            'If %(metavar)s is provided, will filter results '
                            'by fuzzy searching')
    group.add_argument('--set',
                       nargs=2,
                       metavar='MACHINE_ID',
                       help='Store %(metavar)s to be retrived later')
    group.add_argument('--setenv',
                       nargs=2,
                       metavar='ENV_PATH',
                       help='Store %(metavar)s '
                            'to be retrived later as env dir')
    group.add_argument('--openenv',
                       nargs=2,
                       metavar='ENV_PATH',
                       help='Open %(metavar) in terminal')
    group.add_argument('--get',
                       nargs='?',
                       const='',
                       metavar='FILTER',
                       help='Get actions for previously stored machine id or '
                            'environment path. If %(metavar) is provided, will'
                            'filter actions by fuzzy searching')
    group.add_argument('--execute',
                       nargs=2,
                       metavar=('ID', 'COMMAND'),
                       help='Execute command on specific VM or entire'
                            ' environment in the background')
    args = parser.parse_args(wf.args)

    if args.list is not None:
        do_list(args, wf)
    elif args.set:
        do_set(args, wf)
    elif args.setenv:
        do_setenv(args, wf)
    elif args.openenv:
        vagrantfile_dir = args.openenv[1]
        open_terminal(vagrantfile_dir)
    elif args.get is not None:
        do_get(args, wf)
    elif args.execute:
        do_execute(args, wf)

    wf.send_feedback()


if __name__ == '__main__':
    workflow = Workflow()
    logger = workflow.logger
    sys.exit(workflow.run(main))
