# frozen_string_literal: true
#
module ThorAddons
  module Options
    attr_reader :defaults, :invocations, :current_command_name

    def initialize(args = [], local_options = {}, config = {})
      @defaults = Helpers::Defaults.load(self.class, config.dup)
      @invocations = config[:invocations]
      @current_command_name = if config[:current_command].respond_to?(:name)
        config[:current_command].name
      else
        nil
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
      config_file = original[:config_file]

      return original unless with_env? || with_config_file?

      new_options = Helpers::Defaults.remove(original, defaults)

      if with_config_file? && !config_file.nil?
        new_options.merge!(
          Helpers::OptionsConfigFile.parse(
            config_file,
            invocations,
            current_command_name,
            defaults
          )
        )
      end

      if with_env?
        new_options.merge!(
          Helpers::OptionsENV.parse(defaults, envs_aliases)
        )
      end

      opts = Helpers::OptionsHash.new(
        Helpers::Defaults.add(new_options, defaults)
      )

      opts.each do |key, value|
        type = defaults[key][:type]
        is_valid = Helpers::OptionType.new(value, type).valid?

        raise TypeError, "'#{key}' should be a #{type.to_s}" unless is_valid
      end
    end
  end
end
