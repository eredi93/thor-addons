# frozen_string_literal: true

class CliPlain < Thor
  include ThorAddons::Options

  class_option :biz, type: :string, desc: "Biz"

  method_option :bar, type: :string, desc: "Bar"
  method_option :zip, type: :string, default: "zip", desc: "Zip"
  desc "foo", "Foo"
  def foo
    options
  end

  private

  def with_env?
    false
  end

  def with_config_file?
    false
  end
end

class CliNoEnv < Thor
  include ThorAddons::Options

  class_option :biz, type: :string, desc: "Biz"
  class_option :config_file, type: :string, default: "config.yml", desc: "Biz"

  method_option :bar, type: :string, desc: "Bar"
  method_option :zip, type: :string, default: "zip", desc: "Zip"
  desc "foo", "Foo"
  def foo
    options
  end

  private

  def with_env?
    false
  end
end

class CliNoConfig < Thor
  include ThorAddons::Options

  class_option :biz, type: :string, desc: "Biz"

  method_option :bar, type: :string, desc: "Bar"
  method_option :zip, type: :string, default: "zip", desc: "Zip"
  desc "foo", "Foo"
  def foo
    options
  end

  private

  def with_config_file?
    false
  end
end

class Cli < Thor
  include ThorAddons::Options

  class_option :biz, type: :string, desc: "Biz"
  class_option :config_file, type: :string, default: "config.yml", desc: "Biz"

  method_option :bar, type: :string, desc: "Bar"
  method_option :zip, type: :string, default: "zip", desc: "Zip"
  desc "foo", "Foo"
  def foo
    options
  end
end

class CliSubCommand < Thor
  desc "sub COMMANDS", "Subcommand cli"
  subcommand "sub", Cli
end

class CliWithEnvAlias < Thor
  include ThorAddons::Options

  class_option :biz, type: :string, desc: "Biz"
  class_option :config_file, type: :string, default: "config.yml", desc: "Biz"

  method_option :bar, type: :string, desc: "Bar"
  method_option :zip, type: :string, default: "zip", desc: "Zip"
  desc "foo", "Foo"
  def foo
    options
  end

  private

  def envs_aliases
    {
      "BAR" => "ALIAS_BAR"
    }
  end
end
