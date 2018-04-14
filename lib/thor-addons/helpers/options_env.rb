# frozen_string_literal: true

module ThorAddons
  module Helpers
    class OptionsENV
      private_class_method def self.get_from_env_or_alias(env, envs_aliases)
        return ENV[env] unless ENV[env].nil? && envs_aliases.keys.include?(env)

        ENV[envs_aliases[env]]
      end

      def self.parse(defaults, envs_aliases)
        opts = defaults.keys.each_with_object({}) do |option, hsh|
          value = get_from_env_or_alias(option.to_s.upcase, envs_aliases)

          next if value.nil?

          hsh[option] = OptionType.new(value, defaults[option][:type])
            .convert_string
        end

        OptionsHash.new(opts)
      end
    end
  end
end
