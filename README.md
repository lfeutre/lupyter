# lupyter

[travis]: https://travis-ci.org/oubiwann/lupyter
[travis-badge]: https://travis-ci.org/oubiwann/lupyter.png?branch=master

[![][lupyter-tiny]][lupyter-large]

[lupyter-tiny]: resources/images/lupyter-sq-x250.png
[lupyter-large]: resources/images/lupyter-sq.png

*LFE kernel for Jupyter (IPython)*

##### Table of Contents

* [Introduction](#introduction-)
* [Installation](#installation-)
* [Usage](#usage-)

## Introduction

Add content to me here!

## Dependencies

You will need to have the following installed:

* Erlang
* Python
* ``pip``
* ZeroMQ

## Installation

```
$ git clone https://github.com/oubiwann/lupyter.git
$ cd lupyter
$ make
```


## Usage

First, you'll need up update your ``PATH`` to use the local copy of ``lfe``:

```
$ export PATH=./deps/lfe/bin:$PATH
```

For terminal use:

```
$ make console
```

For use in a notebook:

```
$ make notebook
```
