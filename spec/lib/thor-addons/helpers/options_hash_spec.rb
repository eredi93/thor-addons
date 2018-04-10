
# frozen_string_literal: true

require "spec_helper"

describe ThorAddons::Helpers::OptionsHash do
  let(:hash_1) { { a: 1, b: nil, c: [], d: [1] } }
  let(:hash_2) { { a: nil, b: "b", d: [] } }
  let(:res) { { a: 1, b: "b", c: [], d: [1] } }

  describe ".merge" do
    it "should merge the 2 options hash" do
      expect(described_class.new(hash_1).merge(hash_2)).to eq(res)
    end
  end

  describe ".merge!" do
    it "should merge the 2 options hash and mutate the first hash" do
      hash_options = described_class.new(hash_1)

      hash_options.merge!(hash_2)

      expect(hash_options).to eq(res)
    end
  end
end
