# Thor Add-ons

[![Build Status](https://travis-ci.org/eredi93/thor-addons.svg?branch=master)](https://travis-ci.org/eredi93/thor-addons)
[![Gem Version](https://badge.fury.io/rb/thor-addons.svg)](http://badge.fury.io/rb/thor-addons)

Extend [Thor](https://github.com/erikhuda/thor) with useful Add-ons

### Options

Upgrade your option manager by reading a configuration file and enviroment variables.
Just include the `ThorAddons::Options` module in your Thor class.
If you want to disable the enviroment variables reader create a method called `with_env?` that returns false, `with_config_file?` for disabling the config file reader.
