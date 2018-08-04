# GLSL Validator for Sublime Text 2 & 3

Modifications to the original [GLSLValidator plugin](https://github.com/Mischa-Alff/ST-GLSL-Validator).

This is a [Sublime Text](http://www.sublimetext.com/) plugin that uses Khronos' reference glslangValidator to validate OpenGL GLSL shaders.

## Installation

Clone into the Packages folder and then restart Sublime Text.

## Usage

Everything should work fine as long as you have a GLSL syntax highlighter installed. You can disable the validation in the settings:

The main change is that you can define the type of macros in a multiline comment in the GLSL file, like this -

```
/*  __macro__
	PARAMS_UBO_BINDING = int
	PER_CAMERA_UBO_BINDING = int
*/

```

and glslangValidator will be called with `-DPARAMS_UBO_BINDING=1 -DPER_CAMERA_UBO_BINDING=1`, the exact value of the macro is not usually important so I just send `1`. Might allow specifying a value too in future.

The settings are in

```
Preferences > Package Settings > GLSL Validator > Settings - User
```

## Permissions

This plugin makes use of `glslangValidator`, a tool provided by the Khronos group. Point to the executable's path in the settings file (regardless of whether you have it in PATH or not).

```
"path_to_validator": "C:/Bin/glslangValidator.exe"
```

## Credits

* [Paul Lewis](http://aerotwist.com)
* [Brendan Kenny](http://extremelysatisfactorytotalitarianism.com/)
* [Mischa Alff](http://destrock.com)
