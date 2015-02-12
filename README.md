# Yop

[![Build Status](https://img.shields.io/travis/bfontaine/Yop.svg)](https://travis-ci.org/bfontaine/Yop)
[![Gem Version](https://img.shields.io/gem/v/yop.svg)](http://badge.fury.io/rb/yop)
[![Coverage Status](https://img.shields.io/coveralls/bfontaine/Yop.svg)](https://coveralls.io/r/bfontaine/Yop)
[![Inline docs](http://inch-ci.org/github/bfontaine/yop.svg?branch=master)](http://inch-ci.org/github/bfontaine/yop)

Yop bootstraps your projects with custom templates.

Note: this is an early release.

## Roadmap

1. Template directories: ✓ (0.0.1)
2. Placeholder variables: ✓ (0.0.2)
3. Dynamic variables ✓ (0.0.3)
4. Security checks (e.g. don't write files outside of directory, -i option, etc)
5. Filters (e.g. lowercase, default value, etc)
6. Per-template config files
7. Commands to remove or create an empty template
8. Download templates from external sources (zips, git repos, etc)

## Install

    gem install yop

## Usage

    yop <template> <directory>

Where `<template>` is a local template and `<directory>` is your project’s
directory. It’ll create it if it doesn’t exist, then recursively apply the
template on it. Any existing file will be overriden.

You can list existing existing templates with `--templates`:

    yop --templates


## Templates

A template is just a directory located under `~/.yop/templates/`. It can
contain any files and directories you want. It supports placeholder variables,
which will be replaced by a dynamic value later.

### Writing a Template

Let’s say you write a lot of Python libraries, and always use the same
directory tree. It’d be great to store this tree somewhere on your system and
be able to use it for each project. Yop is here for that.

Start by creating a new directory under `~/.yop/templates/`:

    cd ~/.yop/templates && mkdir python-lib && cd python-lib

Congratulations, you created your first template! It’s empty, but Yop can
already use it:

    $ yop --templates
    * python-lib

Let’s add a generic README to the template. You can add placeholder variables
with `{(NAME)}` :

    $ cat README.md
    # {(LIB_NAME)}

    ``{(LIB_NAME)}`` is a Python library written by {(AUTHOR_NAME)}.

You can also use placeholders in paths:

    $ mkdir '{(MODULE_NAME)}'
    $ touch '{(MODULE_NAME)}'/__init__.py

Once you’re satisfied with your template, you can try it:

    $ yop python-lib my-directory

Yop will create `my-directory` and start copy `~/.yop/template/python-lib`’s
content in it. It’ll ask you each time it encounters a placeholder it doesn’t
know:

    $ yop python-lib my-directory
    Applying template 'python-lib' on my-directory...
    MODULE_NAME = <enter your module name, e.g. "mylib">
    LIB_NAME = <enter your library name, e.g. "My Library">
    AUTHOR_NAME = <enter your name, e.g. "Mike">
    Done!


    $ tree my-directory/
    my-directory/
    ├── mylib
    │   └── __init__.py
    └── README.md

    1 directory, 2 files


    $ cat my-directory/README.md
    # My Library

    ``My Library`` is a Python library written by Mike.


You can pre-populate fixed variables like your name or your email in
`~/.yop/config.yml`, under `:vars`:

```yaml
:vars:
  :AUTHOR_NAME: Mike
  :AUTHOR_EMAIL: mike@example.com
```

Variables can be either strings or symbols. They must be upper-cased and start
with a letter. They can contain numbers and underscores.

Some dynamic variables can be provided by Yop. For now, it only includes the
current year. Dynamic variables start with a `!`.

* `{(!CURRENT_YEAR)}` gives `2015` (if the current year is 2015)
