# Thor Add-ons

[![Build Status](https://travis-ci.org/eredi93/thor-addons.svg?branch=master)](https://travis-ci.org/eredi93/thor-addons)
[![Gem Version](https://badge.fury.io/rb/thor-addons.svg)](http://badge.fury.io/rb/thor-addons)

Extend [Thor](https://github.com/erikhuda/thor) with useful Add-ons

### Installation

```shell
gem install thor-addons
```

### Usage

#### Options

The `Options` module allows you to read the CLI options from a configuration file or/and environment variables.


include the Options module to your Thor class.

```ruby
require 'thor'
require 'thor_addons'

class CLI < Thor
  include ThorAddons::Options

  class_option :config_file, type: :string, default: "config.yml", desc: "Configuration file for the CLI"

  method_option :bar, type: :string, default: "biz", desc: "some option"
  desc "foo", "install one of the available apps"
  def foo
    # code
  end
end
```

In the example above the `--bar` option will be read from the configuration file `--config-file`

```ruby
foo:
  bar: "zip"
```

and via the environment variable `BAR`

if you want to disable the configuration file you need to set in your class

```ruby
def with_config_file?
  false
end
```

and for disabling the environment variables

```ruby
def with_env?
  false
end
```

you can also have environment variables aliases, by setting

```ruby
def envs_aliases
  # source => alias
  { "BAR" => "MY_BAR" }
end
```

The cli will set bar with the value of `BAR` or `MY_BAR` if `BAR` is not set.

This module will set the options in this order: cli options, config file, environment variables

### Contributing

If you would like to help, please read the [CONTRIBUTING][] file for suggestions.

[contributing]: CONTRIBUTING.md

### License

Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE.md
