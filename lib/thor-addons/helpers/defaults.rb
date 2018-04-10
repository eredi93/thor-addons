# frozen_string_literal: true

module ThorAddons
  module Helpers
    class Defaults
      def self.load(klass, config)
        options = klass.class_options.dup
        options.merge!(config[:class_options]) if config[:class_options]
        options.merge!(config[:command_options]) if config[:command_options]

        options.each_with_object({}) do |(name, obj), hsh|
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
          hsh[k] = nil

          hsh[k] = v unless defaults[k][:value] == v
        end
      end
    end
  end
end
