# frozen_string_literal: true

require "spec_helper"

describe String do
  describe ".to_b" do
    let(:truthy_values) do
      [
        "1", "1 ", " 1", " 1 ",
        "t", "t ", " t", " t ",
        "T", "T ", " T", " T ",
        "true", "true ", " true", " true ",
        "TRUE", "TRUE ", " TRUE", " TRUE ",
        "on", "on ", " on", " on ",
        "ON", "ON ", " ON ", " ON ",
        "y", "y ", " y", " y ",
        "Y", "Y ", " Y", " Y ",
        "yes", "yes ", " yes", " yes ",
        "YES", "YES ", " YES", " YES "
      ].freeze
    end
    let(:falsey_values) do
      [
        "0", "0 ", " 0", " 0 ",
        "f", "f ", " f", " f ",
        "F", "F ", " F", " F ",
        "false", "false ", " false", " false ",
        "FALSE", "FALSE ", " FALSE", " FALSE ",
        "off", "off ", " off", " off ",
        "OFF", "OFF ", " OFF ", " OFF ",
        "n", "n ", " n", " n ",
        "N", "N ", " N", " N ",
        "no", "no ", " no", " no ",
        "NO", "NO ", " NO", " NO "
      ].freeze
    end
    let(:invalid_values) do
      [
        "", "nil",
        "2", "-1", "-2",
        "not", "NOT"
      ].freeze
    end

    it "should convert the string to true" do
      truthy_values.each do |value|
        expect(described_class.new(value).to_b).to eq(true)
      end
    end

    it "should convert the string to false" do
      falsey_values.each do |value|
        expect(described_class.new(value).to_b).to eq(false)
      end
    end

    it "should fail to convert the string to bool" do
      invalid_values.each do |value|
        expect(described_class.new(value).to_b).to eq(nil)
      end
    end

    it "should fail to convert the string to bool and raise error" do
      invalid_values.each do |value|
        expect do
          described_class.new(value).to_b(
            invalid_value_behaviour: proc { raise ArgumentError }
          )
        end.to raise_error(ArgumentError)
      end
    end

    describe ".to_a" do
      it "should convert the string to an array" do
        expect(described_class.new("foo bar").to_a).to eq(%w[foo bar])
      end

      it "should convert the string to an array w/ custom delimiter" do
        expect(
          described_class.new("foo-bar").to_a(delimiter: "-")
        ).to eq(%w[foo bar])
      end
    end

    describe ".to_h" do
      it "should convert the string to a hash" do
        expect(
          described_class.new("foo:bar").to_h
        ).to eq("foo" => "bar")

        expect(
          described_class.new("a:b c:d").to_h
        ).to eq("a" => "b", "c" => "d")
      end

      it "should convert the string to an array w/ custom delimiter" do
        expect(
          described_class.new("foo bar").to_h(arr_sep: ";", key_sep: " ")
        ).to eq("foo" => "bar")
        expect(
          described_class.new("a b;c d").to_h(arr_sep: ";", key_sep: " ")
        ).to eq("a" => "b", "c" => "d")
      end
    end

    describe ".to_n" do
      it "should convert the string to a number" do
        expect(described_class.new("1").to_n).to eq(1)
        expect(described_class.new("1.11").to_n).to eq(1.11)
      end
    end
  end
end
