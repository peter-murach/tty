<div align="center">
  <a href="http://piotrmurach.github.io/tty"><img width="130" src="https://cdn.rawgit.com/piotrmurach/tty/master/images/tty.png" alt="tty logo" /></a>
</div>
<br/>

[![Gem Version](https://badge.fury.io/rb/tty.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/tty.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/0a85w6yr40lmuo3o?svg=true)][appveyor]
[![Code Climate](https://codeclimate.com/github/piotrmurach/tty/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/piotrmurach/tty/badge.svg?branch=master)][coveralls]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty.svg?branch=master)][inchpages]
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[gem]: http://badge.fury.io/rb/tty
[travis]: http://travis-ci.org/piotrmurach/tty
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty
[coveralls]: https://coveralls.io/r/piotrmurach/tty
[inchpages]: http://inch-ci.org/github/piotrmurach/tty
[gitter]: https://gitter.im/piotrmurach/tty

> TTY is a toolbox for developing beautiful command line clients in Ruby with a fluid interface for gathering input, querying terminal properties and displaying information.

## Motivation

All too often libraries that interact with terminals create their own interface logic that gathers input from users and displays information back. Many times utility files are created that contain methods for reading system or terminal properties. Shouldn't we focus our energy on building the actual client?

Building terminal tools takes time. I believe that modular components put together in a single package with project scaffolding will help people build things faster and produce higher quality results. It is easy to jump start a new project with available scaffolding and mix and match components to create new tooling.

## Features

* Jump-start development of your command line app the Unix way with scaffold provided by [teletype](#2-bootstrapping).
* Fully modular, choose out of many [components](#3-components) to suit your needs or use any 3rd party ones.
* All tty components are small packages that do one thing well.
* Fully tested with major ruby interpreters.

## Installation

Add this line to your application's Gemfile to install all components:

    gem 'tty'

or install a particular component:

    gem 'tty-*'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty

## Contents

* [1. Overview](#1-overview)
* [2. Bootstrapping](#2-bootstrapping)
  * [2.1 new command](#21-new-command)
    * [2.1.1 --license, -l flag](#211---license--l-flag)
  * [2.2 add command](#22-add-command)
  * [2.3 working with commands](#23-working-with-commands)
  * [2.4 working with flags](#24-working-with-flags)
* [3. Components](#3-components)

## 1. Overview

**TTY** provides you with many tasks and components to get you onto the path of bulding awesome terminal applications.

To simply jump start a new command line application use `teletype` executable:

```bash
$ teletype new cliapp
```

and then to add more commands:

```bash
$ teletype add config
```

## 2. Bootstrapping

### 2.1 `new` command

The `teletype new [app-name]` command will create a brand new application. This tasks will bootstrap an entire project file structure.
The project structure is based on the bundler `gem` command with additional files and folders.

To create a new command line application use the `new` task with the application's name as a first argument:

```ruby
$ teletype new [app-name]
```

The output will contain all the files that have been created similar to `bundler` output:

```
Creating gem 'app'
    create app/Gemfile
    create app/.gitignore
    create app/lib/app.rb
    create app/lib/app/version.rb
    ...
```

This will generate the following structure familiar to anyone who has created a gem beforehand:

```
▾ app/
├── ▾ exe/
│   └── app
├── ▾ lib/
│   ├── ▾ app/
│   │   ├── cli.rb
│   │   └── version.rb
│   └── app.rb
├── CODE_OF_CONDUCT.md
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
└── app.gemspec
```

Run the new command with `--help` flag to see all available options:

```ruby
$ teletype new --help
```

Execute `teletype` to see all available tasks.

#### 2.1.1 `--license`, `-l` flag

The `teletype` generator comes prepackaged with most popular open source licenses:
`agplv3`, `apache`, `bsd2`, `bsd3`, `gplv2`, `gplv3`, `lgplv3`, `mit`, `mplv2`, `custom`. By default the `mit` license is used. To change that do:

```ruby
$ teletype new app --license bsd3
```

### 2.2 `add` command

Once application has been initialized, you can create additional command by using `teletype add [command-name]` task:

```ruby
$ teletype add config
$ teletype add create
```

This will add `create.rb` and `config.rb` commands to the CLI client:

```ruby
▾ app/
├── ▾ commands/
│   ├── config.rb
│   └── create.rb
├── cli.rb
└── version.rb
```

Then you will be able to call the new commands like so:

```ruby
$ app config
$ app create
```

The commands require you to specify the actual logic in their `execute` methods.

Please note that command names should be provided as `camelCase` or `snake_case`. For example:

```
$ teletype add addConfigCommand   # => correct
$ teletype add add_config_command # => correct
$ teletype add add-config-command # => incorrect
```

### 2.3 working with commands

After using the `teletype add config` command the following strcuture will be created.

```ruby
▾ app/
├── ▾ commands/
│   └── config.rb
├── cli.rb
└── version.rb
```

The `lib/app/cli.rb` file will contain generated command entry:

```ruby
desc 'config', 'Command description...'
def config(*)
  if options[:help]
    invoke :help, ['config']
  else
    require_relative 'commands/config'
    App::Commands::Config.new(options).execute
  end
end
```

And the `commands/config.rb` will allow you to specify all the command logic in `execute` call:

```ruby
module App
  module Commands
    class Config < App::Cmd
      def initialize(options)
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
```
### 2.4 Working with flags

Flags and options let you customize how a particular command is invoked and provide additional configuration.
See https://github.com/piotrmurach/tty/blob/master/lib/tty/cli.rb for an example of how to use them.

## 3. Components

The **TTY** allows you to mix & match any components you need to get your job done. The command line applications generated with `teletype` executable references all of the below components.

|  Component   | Description | API docs |
| ------------ | ----------- | -------- |
| [pastel](https://github.com/piotrmurach/pastel) | Terminal strings styling with intuitive and clean API. | [docs](http://www.rubydoc.info/gems/pastel) |
| [tty-color](https://github.com/piotrmurach/tty-color) | Terminal color capabilities detection. | [docs](http://www.rubydoc.info/gems/tty-color) |
| [tty-command](https://github.com/piotrmurach/tty-command) | Execute shell commands with pretty logging and capture stdout, stderr and exit status. | [docs](http://www.rubydoc.info/gems/tty-command) |
| [tty-cursor](https://github.com/piotrmurach/tty-cursor) | Move terminal cursor around. | [docs](http://www.rubydoc.info/gems/tty-cursor) |
| [tty-editor](https://github.com/piotrmurach/tty-editor) | Open a file or text in the user preferred editor. | [docs](http://www.rubydoc.info/gems/tty-editor) |
| [tty-file](https://github.com/piotrmurach/tty-file) | File manipulation utility methods. | [docs](http://www.rubydoc.info/gems/tty-file) |
| [tty-pager](https://github.com/piotrmurach/tty-pager) | Terminal output paging in a cross-platform way. | [docs](http://www.rubydoc.info/gems/tty-pager) |
| [tty-platform](https://github.com/piotrmurach/tty-platform) | Detecting different operating systems. | [docs](http://www.rubydoc.info/gems/tty-platform) |
| [tty-progressbar](https://github.com/piotrmurach/tty-progressbar) | A flexible progress bars drawing in terminal emulators. | [docs](http://www.rubydoc.info/gems/tty-progressbar) |
| [tty-prompt](https://github.com/piotrmurach/tty-prompt) | A beautiful and powerful interactive command line prompt. | [docs](http://www.rubydoc.info/gems/tty-prompt) |
| [tty-reader](https://github.com/piotrmurach/tty-reader) | A set of methods for processing keyboard input in character, line and multiline modes. | [docs](http://www.rubydoc.info/gems/tty-reader) |
| [tty-screen](https://github.com/piotrmurach/tty-screen) | Terminal screen properties detection. | [docs](http://www.rubydoc.info/gems/tty-screen)
| [tty-spinner](https://github.com/piotrmurach/tty-spinner) | A terminal spinner for tasks with non-deterministic time.| [docs](http://www.rubydoc.info/gems/tty-spinner) |
| [tty-table](https://github.com/piotrmurach/tty-table) | A flexible and intuitive table output generator. | [docs](http://www.rubydoc.info/gems/tty-table) |
| [tty-tree](https://github.com/piotrmurach/tty-tree) | Print directory or structured data in a tree like format. | [docs](http://www.rubydoc.info/gems/tty-tree) |
| [tty-which](https://github.com/piotrmurach/tty-which) | Platform independent implementation of Unix which command. | [docs](http://www.rubydoc.info/gems/tty-which) |

## Contributing

You can contribute by posting `feature requests`, evaluating the APIs or simply by hacking on TTY components:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2012-2017 Piotr Murach. See LICENSE.txt for further details.
