$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require "thor-addons"

load File.join(File.dirname(__FILE__), "fixtures", "cli.rb")

def fixture_path(path)
  File.join(File.dirname(__FILE__), "fixtures", path)
end

def fixture_file(path)
  File.read(fixture_path(path))
end

def config_fixture
  YAML.load_file(fixture_path("config.yml"))
end
