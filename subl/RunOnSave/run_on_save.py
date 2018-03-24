import sublime
import sublime_plugin
import subprocess as sp
import os
import re
from pprint import pformat

class GlobalConfig:
    ENABLED = True

class ExternalCommand:
    def __init__(self, prev_command):
        self.prev_command = prev_command

    def before_push(self):
        pass

    def execute(self, args=[]):
        pass

    def after_pop(self):
        pass


class ChdirCommand(ExternalCommand):
    def __init__(self):
        self.saved_dir = None

    def before_push(self):
        self.saved_dir = os.getcwd()

    def execute(self, args):
        os.chdir(args[0])

    def after_pop(self):
        if self.saved_dir is None:
            sublime.error_message('ChdirCommand failed, should not happen')
        os.chdir(self.saved_dir)


EXTERNAL_COMMANDS = {
    '@chdir': ChdirCommand
}


REJECTED_COMMANDS = {'cd', 'rm'}


class TurnOnRunOnSaveCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        GlobalConfig.ENABLED = True
        print('Enabling RunOnSave')


class TurnOffRunOnSaveCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        print('Disabling RunOnSave')
        GlobalConfig.ENABLED = False


class RunOnSaveCommand(sublime_plugin.EventListener):
    def on_post_save_async(self, view):
        if GlobalConfig.ENABLED:
            print("RunOnSave is enabled")

        else:
            print("RunOnSave is disabled")
            return

        # Get current file name
        file_name = os.path.basename(view.file_name())

        # Get the command sequence associated with this file name
        settings = sublime.load_settings('run_on_save.sublime-settings')
        print('Settings = {}'.format(settings))

        # Get the file being saved command

        file_list = settings.get("watched_files")
        if file_list is None:
            return
        command_list = file_list.get(file_name)
        if command_list is None:
            print("RunOnSave: No command list for file -'{}'".format(file_name))
            return

        # Check if there are any external commands in the list. Maybe we should spawn a new process and then
        # run the commands. Not doing that yet since even doing this works.
        exec_command_list(file_name, command_list)


def exec_command_list(file_name, command_list):
    external_cmd_stack = []

    # Scan the command list to see if we have any

    last_command_succeeded = False

    pipe_output = False

    for i, command in enumerate(command_list):
        assert len(command) != 0
        print('Running command: ', command)

        if command[0] in REJECTED_COMMANDS:
            sublime.error_message("RunOnSave: Rejected command '{}' used in command list for file {}".format(command[0], file_name))
            break

        if command[0].startswith('@'):
            if command[0] == '@and':
                if last_command_succeeded:
                    continue
                else:
                    break

            if command[0] == '@;':
                continue

            if command[0] == '@pipe':
                pipe_output = True
                continue

            # This is an external command
            cmd_class = EXTERNAL_COMMANDS.get(command[0])
            if cmd_class is None:
                sublime.error_message("RunOnSave: Unsupported external command '{}' used in command list for file {}".format(command[0], file_name))
                break

            ext_command = cmd_class()
            ext_command.before_push()
            ext_command.execute(command[1:])

        else:
            proc = None
            if pipe_output:
                proc = sp.Popen(command, stdout=sp.PIPE, stderr=sp.PIPE)
            else:
                proc = sp.Popen(command)

            stdoutdata, stderrdata = proc.communicate()
            print('Command {} output =\n{}'.format(' '.join(command), stdoutdata.decode('utf-8')))

            if proc.returncode != 0:
                print("RunOnSave: command {} for file {} exited with retcode {}".format(' '.join(command), file_name, proc.returncode))
                # sublime.error_message('Command {} errors =\n{}'.format(' '.join(command), stderrdata.decode('utf-8')))
                print('Command {} errors =\n{}'.format(' '.join(command), stderrdata.decode('utf-8')))
                break

    while len(external_cmd_stack) != 0:
        ext_command = external_cmd_stack[-1]
        external_cmd_stack.pop()
        ext_command.after_pop()
