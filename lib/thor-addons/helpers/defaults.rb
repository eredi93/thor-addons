# frozen_string_literal: true
#
module ThorAddons
  module Helpers
    class Defaults
      def self.load(klass, config)
        parse_options = klass.class_options.dup
        parse_options.merge!(config[:class_options]) if config[:class_options]
        parse_options.merge!(config[:command_options]) if config[:command_options]

        parse_options.each_with_object({}) do |(name, obj), hsh|
          value = obj.respond_to?(:default) ? obj.default : nil
          type = obj.respond_to?(:type) ? obj.type : :string

          hsh[name] = { value: value, type: type }
        end
      end

      def self.add(hash, defaults)
        hash.each_with_object({}) do |(k, v), hsh|
          hsh[k] = v.nil? ? defaults[k][:value] : v
        end
      end

      def self.remove(hash, defaults)
        hash.each_with_object({}) do |(k, v), hsh|
          defaults[k][:value] == v ? hsh[k] = nil : hsh[k] = v
        end
      end
    end
  end
end

