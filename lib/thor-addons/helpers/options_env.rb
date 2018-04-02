# frozen_string_literal: true

module ThorAddons
  module Helpers
    class OptionsENV
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def self.parse(defaults, envs_aliases)
        opts = defaults.keys.each_with_object({}) do |option, hsh|
          env = option.to_s.upcase
          type = defaults[option][:type]
          env_value = ENV[env]

          unless env_value.nil?
            hsh[option] = OptionType.new(env_value, type).convert_string

            next
          end

          next unless envs_aliases.keys.include?(env)

          env_value = ENV[envs_aliases[env]]

          unless env_value.nil?
            hsh[option] = OptionType.new(env_value, type).convert_string
          end
        end

        OptionsHash.new(opts)
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
