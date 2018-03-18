module ThorAddons
  module Options
    attr_reader :current_command_name, :defaults, :invoked_via_subcommand,
      :invocations

    def initialize(args = [], local_options = {}, config = {})
      @current_command_name = get_current_command_name(config)
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

    def envs_aliases
      {}
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

    private def get_current_command_name(config)
      return unless config[:current_command]

      config[:current_command].name
    end

    private def merge(options_a, options_b)
      options_b.each do |key, value|
        value_a = options_a[key]

        next if value.nil? || value.empty?
        next unless (value_a.nil? || value_a.empty?)

        options_a[key] = value
      end

      options_a
    end

    private def options_from_env
      opts = defaults.keys.each_with_object({}) do |option, hsh|
        env = option.to_s.upcase
        hsh[option] = ENV[env] unless ENV[env].nil?

        next unless envs_aliases.keys.include?(env) &&
          hsh[option].nil? &&
          ENV[envs_aliases[env]]

        hsh[option] = ENV[envs_aliases[env]]
      end

      hash_with_indifferent_access(opts)
    end

    private def parse_config_file(config_file)
      YAML.load_file(config_file)
    rescue Errno::ENOENT, Psych::SyntaxError
      STDERR.puts("[WARN] Unable to parse 'config_file' '#{config_file}'.")
      return {}
    end

    private def options_from_config(config_file)
      data = parse_config_file(config_file)
      command_options = {}
      global = data["global"] || {}

      return hash_with_indifferent_access(global) if current_command_name.nil?

      if invoked_via_subcommand
        first_invoked, *remaining_invoked = invocations.values.flatten
        command_options = data[first_invoked] unless data[first_invoked].nil?

        remaining_invoked.each do |subcommand|
          break if command_options[subcommand].nil?

          subcommand_data = command_options[subcommand]

          command_options.delete(subcommand)
          command_options.merge!(subcommand_data)
        end
      elsif data[current_command_name]
        command_options = data[current_command_name]
      end

      hash_with_indifferent_access(global.merge(command_options))
    end

    private def add_defaults(hash)
      hash.each_with_object({}) do |(k, v), hsh|
        hsh[k] = v.nil? ? defaults[k] : v
      end
    end

    private def remove_defaults(hash)
      hash.each_with_object({}) do |(k, v), hsh|
        defaults[k] == v ? hsh[k] = nil : hsh[k] = v
      end
    end

    private def load_defaults(config)
      parse_options = self.class.class_options.dup
      parse_options.merge!(config[:class_options]) if config[:class_options]
      parse_options.merge!(config[:command_options]) if config[:command_options]

      options_hash = parse_options.each_with_object({}) do |(key, value), hsh|
        begin
          hsh[key] = value.default
        rescue NoMethodError
          hsh[key] = nil
        end
      end

      hash_with_indifferent_access(options_hash)
    end

    private def hash_with_indifferent_access(hash)
      ::SymbolizedHash.new(hash)
    end
  end
end
