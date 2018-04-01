# frozen_string_literal: true
#
module ThorAddons
  module Helpers
    class OptionsHash < ::SymbolizedHash
      def merge(options)
        self_dup = self.dup

        options.each do |key, value|
          self_value = self_dup[key]

          next if value.is_a?(NilClass) ||
            (value.respond_to?(:empty?) && value.empty?)

          next unless self_value.is_a?(NilClass) ||
            (self_value.respond_to?(:empty?) && self_value.empty?)

          self_dup[key] = value
        end

        self_dup
      end

      def merge!(options)
        self.replace(merge(options))
      end
    end
  end
end
