import sublime
import sublime_plugin
import re
import subprocess as sp
import os
import platform
from pprint import pformat

if platform.system() == 'Windows':
    DEFAULT_VALIDATOR_PATH = os.path.join("C:/VulkanSDK/1.1.77.0/Bin/glslangValidator.exe")
else:
    DEFAULT_VALIDATOR_PATH = "glslangValidator"

def always_fullmatch(pattern_string):
    return re.compile("(?:" + pattern_string + r")\Z")

# these are the default settings. They are overridden and documented in the GLSlValidator.sublime-settings file
DEFAULT_SETTINGS = {
    "glslvalidator_enabled": 1,
    "all_caps_are_macros": True,
    "path_to_validator": DEFAULT_VALIDATOR_PATH
}

ALL_CAPS_ARE_MACROS = DEFAULT_SETTINGS['all_caps_are_macros']
VALIDATOR_PATH = DEFAULT_SETTINGS["path_to_validator"]

INVALID_BUILTIN_TYPE = 'GLSLValidator_Invalid_Builtin_'

MACRO_REGEX = re.compile('[_A-Z0-9]{3,}')

MACRO_SPEC_HEADER = always_fullmatch(r'^\s*/\*\s*__macro__\s*')

def _line_ending_size(line_ending):
    if line_ending == 'Windows':
        return 2
    elif line_ending == 'Unix':
        return 1
    else:
        raise ValueError('Line ending needs to be either Windows or Unix')

# Allowed typenames for the macro specification. '_' denotes just a define without any value
DEFAULT_VALUE_OF_TYPE = {
    'float':    '1.0',
    'vec2':     'vec2(1.0)',
    'vec3':     'vec3(1.0)',
    'vec4':     'vec4(1.0)',
    '_':        '1.0',
    'uint':     'uint(1)',
    'int':      '1',
}

class MacroCommentParser:
    def __init__(self, source, line_endings):
        self.s = source
        self.pos = 0
        self.line_endings = line_endings
        self.type_of_name = {}

    def may_skip(self, chars_to_skip):
        while self.pos < len(self.s) and self.s[self.pos] in chars_to_skip:
            self.pos += 1

    def skip_lines_and_ws(self):
        skipped_some = True
        while skipped_some:
            skipped_some = False
            if self.pos <= len(self.s) - 2 and self.s[self.pos : self.pos + 2] == '\r\n':
                self.pos += 2
                skipped_some = True
            elif self.pos < len(self.s) and self.s[self.pos] in '\n\t ':
                self.pos += 1
                skipped_some = True



    def skip(self, chars_to_skip):
        num_seen = 0
        while self.pos < len(self.s) and self.s[self.pos] in chars_to_skip:
            self.pos += 1
            num_seen += 1
        if num_seen == 0:
            raise ValueError('Expected one of "{}"'.format(chars_to_skip))


    def still_inside(self):
        if self.pos >= len(self.s):
            raise ValueError('Failed to parse macro spec')

    def _parse_spec(self):
        success = False
        while self.pos < len(self.s):
            if (self.pos < len(self.s) - len('*/')) and self.s[self.pos] == '*' and self.s[self.pos + 1] == '/':
                self.pos += 2
                success = True
                break

            self.may_skip(' \t')
            self.still_inside()

            name = self._parse_name()
            print('parsed name = ', name)
            self.may_skip(' \t')

            self.skip('=')
            self.may_skip(' \t')

            self.still_inside()
            typename = self._parse_type()

            # Insert into the store
            self.type_of_name[name] = typename
            self.skip_lines_and_ws()

        if not success:
            raise ValueError('Expectec closing "*/" in macro defines')

        print("Macro defines = {}".format(pformat(self.type_of_name, indent=4)))

    def _parse_name(self):
        name = bytearray()
        while self.pos < len(self.s):
            c = self.s[self.pos]
            # print('c = ', c)
            if ('a' <= c <= 'z') or ('A' <= c <= 'Z') or c == '_':
                name += c.encode('utf-8')
                self.pos += 1
            elif c in ' \t=':
                return name.decode('utf-8')
            else:
                raise ValueError('Unexpected character in macro name - "{}", incomplete name = {}'.format(c, name.decode('utf-8')))
        return name

    def _parse_type(self):
        typename = bytearray()
        # print('Parsing macro type from ---{}---'.format(self.s[self.pos:]))
        while self.pos < len(self.s):
            c = self.s[self.pos]
            if ('a' <= c <= 'z') or ('A' <= c <= 'Z') or c == '_' or c in '0123456789':
                typename += c.encode('utf-8')
                self.pos += 1
            elif c in ' \t\r\n':
                break
            else:
                raise ValueError('Unexpected character in macro type - "{}"'.format(c))

        typename = typename.decode('utf-8')
        if typename not in DEFAULT_VALUE_OF_TYPE:
            # Not a valid builtin type. Return a bogus typename.
            print('ERROR - Typename "{}" is not one of {}'.format(typename, str(DEFAULT_VALUE_OF_TYPE.keys())))
        return typename


    def _parse_comment(self):
        # Find the line that starts the specification comment
        num_chars_seen = 0
        found_spec = False
        for line in self.s.splitlines():
            num_chars_seen += len(line) + _line_ending_size(self.line_endings)
            if re.match(MACRO_SPEC_HEADER, line):
                found_spec = True
                break

        if found_spec:
            self.pos = num_chars_seen
            self.skip_lines_and_ws()
            # Parse from the next line
            self._parse_spec()

    def __call__(self):
        self.type_of_name = {}
        self._parse_comment()
        return self.type_of_name

def get_default_value_of_type(type):
    v = DEFAULT_VALUE_OF_TYPE.get(type)
    if v is None:
        return '{}{}'.format(INVALID_BUILTIN_TYPE, type)
    return v

def make_defs(type_of_name):
    return list('-D{}="{}"'.format(name, get_default_value_of_type(type)) for name, type in type_of_name.items())

class GLShaderError:
    """ Represents an error """
    region = None
    message = ''

    def __init__(self, region, message, token):
        self.region = region
        self.message = message
        self.token = token


ERROR_PATTERN = always_fullmatch(r"ERROR: .+:([0-9]+): '(.*)' : (.+)")
ERROR_LINE_GROUP = 1
ERROR_TOKEN_GROUP = 2
ERROR_REASON = 3


class glslangValidatorCommandLine:
    """ Wrapper for glslangValidator CLI """

    packagePath = "GLSL Validator"
    platform = sublime.platform()
    permissionChecked = False

    def ensure_script_permissions(self):
        """ Ensures that we have permission to execute the command """

        if not self.permissionChecked:
            os.chmod(VALIDATOR_PATH, 0o755)

        self.permissionChecked = True
        return self.permissionChecked

    def validate_contents(self, view):
        """ Validates the file contents using glslangValidator """
        errors = []
        file_lines = view.lines(sublime.Region(0, view.size()))

        macro_comment_parser = MacroCommentParser(view.substr(sublime.Region(0, view.size())), view.line_endings())
        type_of_name = macro_comment_parser()
        defs = make_defs(type_of_name)

        print('defs = {}'.format(defs))

        filepath = '"{}"'.format(view.file_name()).replace('\\', '/')

        command_line = [VALIDATOR_PATH, '-l', '-C'] + defs + [filepath]
        command_line_str = ' '.join(command_line)
        print("glslangvalidator command line = ", command_line_str)

        # proc = sp.Popen(command_line, stdout=sp.PIPE, stderr=sp.STDOUT, shell=True)
        proc = sp.Popen(command_line_str, stderr=sp.PIPE, stdout=sp.PIPE, shell=True)
        # out, err = proc.communicate()
        err, _ = proc.communicate() # Looks like sublime connects stderr to stdout.

        # print('Out = {},\nErr = {}'.format(out, err))

        if err is not None:
            err = err.decode('utf-8').replace('\r\n', '\n')
            err_lines = err.split('\n')
            print('err = ', pformat(err_lines))

            # Go through each error, ignoring any comments
            for e in err_lines:
                # Check if there was a permission denied error running the essl_to_glsl cmd
                if re.search("permission denied", str(e), flags=re.IGNORECASE):
                    sublime.error_message("GLSLValidator: permission denied to use glslangValidator command")
                    return []

                # ignore glslangValidator's comments
                if not re.search("^####", e):

                    # Break down the error using the regexp
                    error_line_match = ERROR_PATTERN.match(e)

                    # For each match construct an error object to pass back
                    if not error_line_match:
                        print('Did not match line - ', e)
                        continue

                    err_line = int(error_line_match.group(ERROR_LINE_GROUP)) - 1
                    err_token = error_line_match.group(ERROR_TOKEN_GROUP)
                    err_desc = error_line_match.group(ERROR_REASON)
                    err_loc = file_lines[err_line]

                    # Edit - Don't locate it, since it might be an invalid type identifier
                    
                    # If there is a token try and locate it
#                    if len(err_token) > 0:
#                        better_loc = view.find(err_token, err_loc.begin(), sublime.LITERAL)
#                        # Ensure we have a match before we replace the error region
#                        if better_loc is not None and not better_loc.empty():
#                            err_loc = better_loc

                    errors.append(GLShaderError(err_loc, err_desc, err_token))

        print('Errors - ', pformat(errors))
        return errors


class GLSlValidatorCommand(sublime_plugin.EventListener):
    """ Main Validator Class """
    glslangValidatorCLI = glslangValidatorCommandLine()
    errors = None
    loadedSettings = False
    pluginSettings = None

    def __init__(self):
        """ Startup """

    def clear_settings(self):
        """ Resets the settings value so we will overwrite on the next run """
        for window in sublime.windows():
            for view in window.views():
                if view.settings().get('glslvalidator_configured') is not None:
                    view.settings().set('glslvalidator_configured', None)

    def apply_settings(self, view):
        """ Applies the settings from the settings file """

        # load in the settings file
        if self.pluginSettings is None:
            self.pluginSettings = sublime.load_settings(__name__ + ".sublime-settings")
            self.pluginSettings.clear_on_change('glslvalidator_validator')
            self.pluginSettings.add_on_change('glslvalidator_validator', self.clear_settings)

        if view.settings().get('glslvalidator_configured') is None:
            view.settings().set('glslvalidator_configured', True)
            # Go through the default settings
            for setting in DEFAULT_SETTINGS:
                # set the value
                settingValue = DEFAULT_SETTINGS[setting]

                # check if the user has overwritten the value and switch to that instead
                if self.pluginSettings.get(setting) is not None:
                    settingValue = self.pluginSettings.get(setting)

                view.settings().set(setting, settingValue)

            ALL_CAPS_ARE_MACROS = view.settings().get('all_caps_are_macros')
            VALIDATOR_PATH = view.settings().get('path_to_validator')
            print('VALIDATOR_PATH = {}'.format(VALIDATOR_PATH))

    def clear_errors(self, view):
        """ Removes any errors """
        view.erase_regions('glshadervalidate_errors')

    def is_glsl(self, view):
        """ Checks that the file is GLSL """
        syntax = view.settings().get('syntax')
        isShader = False
        if syntax is not None:
            isShader = re.search('GLSL', syntax, flags=re.IGNORECASE) is not None
        return isShader

    def is_valid_file_ending(self, view):
        """ Checks that the file ending will work for glslangValidator """
        isValidFileEnding = re.search('(frag|vert|geom|tesc|tese|comp)$', view.file_name()) is not None
        return isValidFileEnding

    def show_errors(self, view):
        """ Passes over the array of errors and adds outlines """

        # Go through the errors that came back
        errorRegions = []
        for error in self.errors:
            errorRegions.append(error.region)

        # Put an outline around each one and a dot on the line
        view.add_regions('glshadervalidate_errors', errorRegions, 'glshader_error', 'dot', sublime.DRAW_OUTLINED)

    def on_selection_modified(self, view):
        """ Shows a status message for an error region """

        view.erase_status('glslvalidator')

        # If we have errors just locate
        # the first one and go with that for the status
        if self.is_glsl(view) and self.errors is not None:
            for sel in view.sel():
                for error in self.errors:
                    if error.region.contains(sel):
                        view.set_status('glslvalidator', '- Token - {}, Message - {}'.format(error.token, error.message))
                        return

    def on_load(self, view):
        """ File loaded """
        self.run_validator(view)

    def on_activated(self, view):
        """ File activated """
        self.run_validator(view)

    def on_post_save(self, view):
        """ File saved """
        self.run_validator(view)

    def run_validator(self, view):
        """ Runs a validation pass """

        # clear the last run
        view.erase_status('glslvalidator')

        # set up the settings if necessary
        self.apply_settings(view)

        # early return if they have disabled the linter
        if view.settings().get('glslvalidator_enabled') == 0:
            self.clear_errors(view)
            return

        # early return for anything not syntax highlighted as GLSL / ESSL
        if not self.is_glsl(view):
            return

        # glslangValidator expects files to be suffixed as .frag or .vert so we need to do that check here
        if self.is_valid_file_ending(view):

            # Clear the last set of errors
            self.clear_errors(view)

            # ensure that the script has permissions to run
            # this only runs once and is short circuited on subsequent calls

            # self.glslangValidatorCLI.ensure_script_permissions()

            # Get the file and send to glslangValidator
            self.errors = self.glslangValidatorCLI.validate_contents(view)
            self.show_errors(view)
        else:
            view.set_status('glslvalidator plugin', "File name must end in .frag or .vert")
