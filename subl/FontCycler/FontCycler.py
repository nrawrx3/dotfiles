# -*- coding: utf-8 -*-
from collections import namedtuple

import sublime
import sublime_plugin

Field = namedtuple('Field', ['name', 'default'])

ANY_FONT_SIZE = -1


def toggle_bold():
    settings = sublime.load_settings('Preferences.sublime-settings')
    font_options = set(settings.get('font_options', []))

    bold = False
    if 'bold' in font_options:
        font_options.remove('bold')
    else:
        font_options.add('bold')
        bold = True

    font_options = list(font_options)
    settings.set('font_options', font_options)
    sublime.status_message('Bold: %s' % (bold))

    sublime.save_settings('Preferences.sublime-settings')


def next_line_padding():
    settings = sublime.load_settings('Preferences.sublime-settings')
    line_padding_bottom = settings.get('line_padding_bottom', 0)
    line_padding_top = settings.get('line_padding_top', 0)
    max_line_padding = settings.get('fontcycler.max_line_padding', 2) + 1
    settings.set('line_padding_bottom',
                 (line_padding_bottom + 1) % max_line_padding)
    settings.set('line_padding_top', (line_padding_top + 1) % max_line_padding)

    sublime.save_settings('Preferences.sublime-settings')

def next_font_configuration(forward):
    settings = sublime.load_settings('Preferences.sublime-settings')
    confs = settings.get('fontcycler.font_confs', None)
    common_conf = settings.get('fontcycler.common_conf', None)
    if confs is None:
        sublime.status_message('Font confs not found')
        return

    cur_font_face = settings.get('font_face')
    cur_font_size = settings.get('font_size')
    cur_font_options = set(settings.get('font_options')) - set(common_conf)

    i = 0
    while i != len(confs):
        conf = confs[i]
        conf2 = set(conf[2]) - set(common_conf)
        print(type(conf[0]), type(conf[1]), type(conf[2]))
        if conf[0] == cur_font_face and conf[1] == cur_font_size and conf2 == cur_font_options:
            break
        i += 1

    add_to_i = 1 if forward else -1

    if i == len(confs):
        i = 0
    else:
        i = (i + add_to_i) % len(confs)

    conf = confs[i]

    settings.set('font_face', conf[0])
    settings.set('font_size', conf[1])

    if common_conf is not None:
        conf[2].extend(common_conf)

    settings.set('font_options', conf[2])
    sublime.status_message('%s %s %s' %(conf[0], conf[1], conf[2]))

    sublime.save_settings('Preferences.sublime-settings')
    

def cycle_font(backward=False):
    settings = sublime.load_settings('Preferences.sublime-settings')
    settings_fonts_list = settings.get('fontcycler.fonts_list', [])

    if not settings_fonts_list:
        return

    fonts_list = []
    position_by_key = {}
    for pos, item in enumerate(settings_fonts_list):
        try:
            if isinstance(item, basestring):
                item = {
                    'font_face': item,
                }
        except:
            if isinstance(item, str):
                item = {
                    'font_face': item,
                }

        if 'font_face' in item:
            fonts_list.append(item)
            key = (item['font_face'], item.get('font_size', ANY_FONT_SIZE))
            key_any = (item['font_face'], ANY_FONT_SIZE)
            position_by_key[key_any] = position_by_key[key] = pos

    delta = -1 if backward else 1
    current_font_face = settings.get('font_face')
    current_font_size = settings.get('font_size')
    cur_pos = position_by_key.get(
        (current_font_face, current_font_size)) or position_by_key.get(
            (current_font_face, ANY_FONT_SIZE))
    new_pos = (cur_pos + delta) % len(fonts_list) if cur_pos is not None else 0

    font_settings = fonts_list[new_pos]
    fields = [
        Field('font_face', ''),
        Field('font_size', settings.get('font_size')),
        Field('line_padding_bottom', settings.get('line_padding_bottom')),
        Field('line_padding_top', settings.get('line_padding_top'))
    ]
    for field in fields:
        settings.set(field.name, font_settings.get(field.name, field.default))
    sublime.save_settings('Preferences.sublime-settings')

    sublime.status_message('Font Face: %s' % (font_settings['font_face'], ))


class NextFontCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        cycle_font()


class PreviousFontCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        cycle_font(backward=True)


class ToggleBoldCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        toggle_bold()


class LinePaddingCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        next_line_padding()

class FontConfNextCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        next_font_configuration(True)

class FontConfPrevCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        next_font_configuration(False)
