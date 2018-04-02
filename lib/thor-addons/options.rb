# frozen_string_literal: true

module ThorAddons
  module Options
    attr_reader :defaults, :invocations, :current_command_name

    def initialize(args = [], local_options = {}, config = {})
      @defaults = Helpers::Defaults.load(self.class, config.dup)
      @invocations = config[:invocations]

      if config[:current_command].respond_to?(:name)
        @current_command_name = config[:current_command].name
      end

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
      original = Helpers::OptionsHash.new(super)

      return original unless with_env? || with_config_file?

      new_options = Helpers::Defaults.remove(original, defaults)
      update_options!(new_options, original[:config_file])

      opts = Helpers::OptionsHash.new(
        Helpers::Defaults.add(new_options, defaults)
      )

      validate_options(opts)
    end

    private def update_options!(opts, cfg_file)
      update_config_options!(opts, cfg_file) if with_config_file? && cfg_file
      update_env_options!(opts) if with_env?
    end

    private def update_config_options!(opts, cfg_file)
      opts.merge!(
        Helpers::OptionsConfigFile.parse(
          cfg_file,
          invocations,
          current_command_name,
          defaults
        )
      )
    end

    private def update_env_options!(opts)
      opts.merge!(Helpers::OptionsENV.parse(defaults, envs_aliases))
    end

    private def validate_options(opts)
      opts.each do |key, value|
        type = defaults[key][:type]
        is_valid = Helpers::OptionType.new(value, type).valid?

        raise TypeError, "'#{key}' should be a #{type}" unless is_valid
      end
    end
  end
end
