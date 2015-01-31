# Yop

[![Build Status](https://img.shields.io/travis/bfontaine/yop.svg)](https://travis-ci.org/bfontaine/yop)
[![Gem Version](https://img.shields.io/gem/v/yop.svg)](http://badge.fury.io/rb/yop)
[![Coverage Status](https://img.shields.io/coveralls/bfontaine/yop.svg)](https://coveralls.io/r/bfontaine/yop)
[![Inline docs](http://inch-ci.org/github/bfontaine/yop.svg?branch=master)](http://inch-ci.org/github/bfontaine/yop)

Yop bootstraps your projects with custom templates.

Note: this is an early release.

## Install

    gem install yop

## Usage

    yop <template> <directory>

Where `<template>` is a local template and `<directory>` is your project’s
directory. It’ll create it if it doesn’t exist, then recursively apply the
template on it. Any existing file will be overriden.

## Templates

A template is just a directory located under `~/.yop/templates/`.
