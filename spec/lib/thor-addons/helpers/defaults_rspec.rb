require "spec_helper"

module ThorAddons
  module Helpers
    describe Defaults do
      let(:klass) { class_double(Thor) }
      let(:klass_options) { { biz: OpenStruct.new(default: ["biz"], type: :array) } }
      let(:command_options) { { bar: OpenStruct.new(type: :hash) } }
      let(:class_options) { { boo: OpenStruct.new(default: 1.0, type: :numeric) } }
      let(:config) do
        {
          shell: instance_double(Thor::Shell::Color),
          current_command: instance_double(Thor::Command),
          command_options: command_options,
          class_options: class_options
        }
      end
      let(:defaults) do
        {
          biz: { value: ["biz"], type: :array },
          bar: { value: nil, type: :hash },
          boo: { value: 1.0, type: :numeric },
        }
      end

      describe "#load" do
        it "should return a hash with the options default values and types" do
          allow(klass).to receive(:class_options).and_return(klass_options)

          expect(described_class.load(klass, config)).to eq(defaults)
        end
      end

      describe "#add" do
        it "should add the default options" do
          hash = { boo: 44 }

          expect(
            described_class.add(hash, default)
          ).to eq({ biz: ["biz"], bar: nil, boo: 44 })
        end
      end

      describe "#remove" do
        hash = { biz: ["biz"], bar: nil, boo: 44 }

        expect(
          described_class.add(hash, default)
        ).to eq({ boo: 44 })
      end
    end
  end
end
