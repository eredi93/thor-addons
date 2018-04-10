# frozen_string_literal: true

module ThorAddons
  module Helpers
    class OptionType
      attr_reader :option, :type

      def initialize(option, type)
        @option = option
        @type = type

        raise TypeError, "Invalid type: '#{type}'" unless
          TYPE_CLASS_MAP.keys.include?(type)
      end

      TYPE_CLASS_MAP = {
        array: [Array],
        boolean: [TrueClass, FalseClass],
        hash: [Hash],
        numeric: [Integer, Float],
        string: [String]
      }.freeze

      def valid?
        TYPE_CLASS_MAP[type].any? { |klass| option.is_a?(klass) }
      end

      def convert_string
        case type
        when :boolean then option.to_b
        when :array then option.to_a
        when :hash then option.to_h
        when :numeric then option.to_n
        else option
        end
      end
    end
  end
end
