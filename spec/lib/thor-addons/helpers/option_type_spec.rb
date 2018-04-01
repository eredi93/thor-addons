require "spec_helper"

module ThorAddons
  module Helpers
    describe OptionType do
      describe ".valid?" do
        it "should return true if the option type is correct" do
          expect(described_class.new("false", :boolean).valid?).to eq(false)
          expect(described_class.new(false, :boolean).valid?).to eq(true)

          expect(described_class.new("[foo]", :array).valid?).to eq(false)
          expect(described_class.new(["foo"], :array).valid?).to eq(true)

          expect(described_class.new("{ \"foo\" => 1 }", :hash).valid?).to eq(false)
          expect(described_class.new({ "foo" => 1 }, :hash).valid?).to eq(true)

          expect(described_class.new("0", :numeric).valid?).to eq(false)
          expect(described_class.new(0, :numeric).valid?).to eq(true)

          expect(described_class.new("foo", :string).valid?).to eq(true)
        end
      end

      describe ".convert_string" do
        it "should return the option with the correct type" do
          expect(described_class.new("0", :boolean).convert_string).to eq(false)
          expect(described_class.new("1", :boolean).convert_string).to eq(true)

          expect(described_class.new("a b", :array).convert_string).to eq(%w[a b])

          expect(described_class.new("a:b", :hash).convert_string).to eq({ "a" => "b" })

          expect(described_class.new("1", :numeric).convert_string).to eq(1)
          expect(described_class.new("22.5", :numeric).convert_string).to eq(22.5)
        end
      end
    end
  end
end
