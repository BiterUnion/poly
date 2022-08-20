import regex as regex
import sphinx_rtd_theme

# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'Poly'
copyright = '2022, BiterUnion'
author = 'BiterUnion'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx_rtd_theme'
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

master_doc = 'index'


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# -- make substitutions available in directives ------------------------------


def replace_in_directives(app, doc_name, source):
    if doc_name != 'substitutions':
        result = source[0]
        for key in app.config.substitutions:
            result = result.replace(key, app.config.substitutions[key])
        source[0] = result


substitutions = {}
with open('substitutions.rst', 'r') as substitutions_file:
    for line in substitutions_file:
        if m := regex.fullmatch(r'\.\. \|(.*)\| replace:: (.*)\n?', line):
            key = m.group(1)
            value = m.group(2)
            substitutions[f'|{key}|'] = value


def setup(app):
    app.add_config_value('substitutions', {}, True)
    app.connect('source-read', replace_in_directives)
