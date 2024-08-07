# Jsonviewer

Browse through contents of JSON effortlessly.

This plugin is not a JSON prettifier. It is a JSON browser optimized for speed
and comfort, featuring json-like structure, automatic code folding with
datatype and number of offspring, syntax coloring and content lazyloading for
responsiveness even on very large files.

### Description

Jsonviewer lets you view JSON objects in your favorite editor. The plugin is
lightweight, fully autoloaded and does not interfere with \*.json file syntax.
Instead, it introduces its own filetype called `jsonviewer`, which is designed to
keep a human-readable representation of those objects.

Once you have a buffer open with a single JSON, issue a `:call
jsonviewer#init()` command to open the browser buffer. With your object deep
enough you will see some lines folded, use `o` or `Enter` mapping to open a
single fold and load it if needed.

This lugin uses a special optimization which causes it to only load data two
levels down. By default, this is done for every buffer exceeding half a
megabyte in size. Using any other method of fold opening than those mentioned
above (like `zA`) will open unloaded folds in optimized buffers, forcing you to
close and open them again to load the data. Press `OO` to close all folds above
level 1, which fixes this issue.

## Usage

### Key maps

Jsonviewer introduces few keymaps, all of them only available in jsonviewer buffers:

* `o` - open a fold, lazyload contents
* `Enter` - same as above
* `OO` - reload folds in buffer (fix opened lazyloading folds)

### Configuration

* `g:jsonviewer_optimize` - holds optimization threshold - a number of bytes
  which will trigger optimizations when exceeded. While optimized, elements
  will only be loaded two levels down. This helps a lot with Vim responsiveness
  but makes some tasks impossible, like recursive fold opening and searching.
  Defaults to 500000 (500 kB). Set to 0 to always optimize.

### Functions

* `jsonviewer#init()` - call this function while inside a buffer containing a
  json (and nothing else) to launch a jsonviewer browser buffer with its
  contents.

### File sizes and optimization

The main feature of this plugin is its ability to load json content lazily,
which greatly reduces the amount of lag in large files. In my tests on an Intel
i5 laptop, the plugin was able to load a file with 100 MB of JSON in 6 seconds,
consuming roughly 1.7 GB of RAM. While there's no theoretical limit to the size
of a file loaded (other than Vim limits), the amount of memory consumed is
increasing rapidly with very large files.

### TODO

There are some features planned, like folding based on syntax (currently no
working solution was achieved), further optimizations, searching and exporting
parts of the json.

### Requirements

TBD. Requires vim8 compiled with +folding and +conceal features.

## Author and license

Author: Bartosz Jarzyna "bbrtj" <bbrtj.pro@gmail.com>

License: MIT
