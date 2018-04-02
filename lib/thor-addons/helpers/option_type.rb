# frozen_string_literal: true
#
module ThorAddons
  module Helpers
    class OptionType
      attr_reader :option, :type

      def initialize(option, type)
        @option = option
        @type = type
      end

      def valid?
        case type
        when :boolean
          option.is_a?(TrueClass) || option.is_a?(FalseClass)
        when :array
          option.is_a?(Array)
        when :hash
          option.is_a?(Hash)
        when :numeric
          option.is_a?(Integer) || option.is_a?(Float)
        else
          option.is_a?(String)
        end
      end

      def convert_string
        case type
        when :boolean
          option.to_b
        when :array
          option.to_a
        when :hash
          option.to_h
        when :numeric
          option.to_n
        else
          option
        end
      end
    end
  end
end
