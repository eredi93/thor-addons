module ThorAddons
  module Options
    attr_reader :current_command_name, :defaults, :invoked_via_subcommand, :invocations

    def initialize(args = [], local_options = {}, config = {})
      @current_command_name = config[:current_command] ? config[:current_command].name : nil
      @defaults = load_defaults(config.dup)
      @invoked_via_subcommand = config[:invoked_via_subcommand]
      @invocations = config[:invocations]

      super(args, local_options, config)
    end

    def with_env?
      true
    end

    def with_config_file?
      true
    end

    def options
      original = hash_with_indifferent_access(super)
      config_file = original[:config_file]

      return original unless with_env? || with_config_file?

      new_options = remove_defaults(original)

      if with_config_file? && !config_file.nil?
        merge(new_options, options_from_config(config_file))
      end

      if with_env?
        merge(new_options, options_from_env)
      end

      hash_with_indifferent_access(add_defaults(new_options))
    end

    private

    def merge(options_a, options_b)
      options_b.each do |key, value|
        next if value.to_s.empty? || !options_a[key].to_s.empty?

        options_a[key] = value
      end

      options_a
    end

    def envs_aliases
      {}
    end

    def options_from_env
      opts = {}
      defaults.keys.inject({}) do |memo, option|
        env = option.to_s.upcase
        opts[option] = ENV[env] unless ENV[env].nil?

        next unless envs_aliases.keys.include?(env) && opts[option].nil? && ENV[envs_aliases[env]]

        opts[option] = ENV[envs_aliases[env]]
      end

      hash_with_indifferent_access(opts)
    end

    def options_from_config(config_file)
      unless File.file?(config_file)
        STDERR.puts("[WARNING] Unable to read 'config_file' '#{config_file}' not found.")
        return {}
      end

      data = YAML.load_file(config_file)
      command_options = {}
      global = data["global"] || {}

      return hash_with_indifferent_access(global) if current_command_name.nil?

      if invoked_via_subcommand
        invocations.map { |k,v| v }.flatten.each do |subcommand|
          next if data[subcommand].nil? || data[subcommand][current_command_name].nil?

          command_options.merge!(data[subcommand][current_command_name])
        end
      else
        command_options.merge!(data[current_command_name]) unless data[current_command_name].nil?
      end

      hash_with_indifferent_access(global.merge(command_options))
    end

    def add_defaults(hash)
      hash.inject({}) do |memo, (k, v)|
        memo[k] = v.nil? ? defaults[k] : v

        memo
      end
    end

    def remove_defaults(hash)
      hash.inject({}) do |memo, (k, v)|
        if defaults[k] == v
          memo[k] = nil
        else
          memo[k] = v
        end

        memo
      end
    end

    def load_defaults(config)
      parse_options = self.class.class_options.dup
      parse_options.merge!(config[:class_options]) if config[:class_options]
      parse_options.merge!(config[:command_options]) if config[:command_options]

      options_hash = parse_options.inject({}) do |memo, (key, value)|
        begin
          memo[key] = value.default
        rescue NoMethodError
          memo[key] = nil 
        end

        memo
      end

      hash_with_indifferent_access(options_hash)
    end

    def hash_with_indifferent_access(hash)
      ::SymbolizedHash.new(hash)
    end
  end
end
