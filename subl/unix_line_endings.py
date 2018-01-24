from __future__ import print_function
import sublime
import sublime_plugin
import subprocess


class UnixLineEndingCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        # buf = self.view.substr(sublime.Region(0, self.view.size()))

        line_endings = self.view.line_endings()
        sublime.status_message('Line endings = {}'.format(line_endings))



        if line_endings == 'Windows':
            self.view.set_line_endings('Unix')
            sublime.status_message('Will use unix line endings on next save')
        else:
            sublime.status_message('Using unix line endings already')
