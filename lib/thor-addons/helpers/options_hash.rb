# frozen_string_literal: true

module ThorAddons
  module Helpers
    class OptionsHash < ::SymbolizedHash
      private def value_empty?(value)
        value.is_a?(NilClass) || (value.respond_to?(:empty?) && value.empty?)
      end

      def merge(new_hash)
        new_hash.each_with_object(dup) do |(key, value), self_dup|
          next if value_empty?(value) || !value_empty?(self_dup[key])

          self_dup[key] = value
        end
      end

      def merge!(options)
        replace(merge(options))
      end
    end
  end
end
