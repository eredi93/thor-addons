# frozen_string_literal: true
#
class String
  TRUES  = %W{t true on y yes 1}.freeze
  FALSES = %W{f false off n no 0}.freeze

  def to_b(invalid_value_behaviour: Proc.new { nil })
    value = self.strip.downcase
    return true  if TRUES.include?(value)
    return false if FALSES.include?(value)

    invalid_value_behaviour.call
  end

  def to_a(delimiter: " ")
    self.split(delimiter)
  end

  def to_h(arr_sep:" ", key_sep:":")
    self.split(arr_sep).each_with_object({}) do |e, hsh|
      key, value = e.split(key_sep)

      hsh[key] = value
    end
  end

  def to_n
    return self.to_f if self =~ /[0-9]+\.[0-9]+/

    self.to_i
  end
end
