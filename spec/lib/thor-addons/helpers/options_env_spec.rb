require "spec_helper"

module ThorAddons
  module Helpers
    describe OptionsENV do
      describe "#parse" do
        let(:defaults) do
          {
            biz: { value: ["biz"], type: :array },
            bar: { value: nil, type: :hash },
            boo: { value: 1.0, type: :numeric },
          }
        end
        let(:envs_aliases) do
          {
            "BOO" => "CUSTOM_BOO"
          }
        end

        it "should return the options from ENV" do
          opts = { biz: %w[a b c], boo: 44.5 }

          ClimateControl.modify BIZ: "a b c", CUSTOM_BOO: "44.5" do
            expect(described_class.parse(defaults, envs_aliases)).to eq(opts)
          end
        end

        context "with no alias" do
          let(:envs_aliases) { {} }

          it "should return the options from ENV" do
            opts = { biz: %w[a b c], bar: { foo: "bar" } }

            ClimateControl.modify BIZ: "a b c", BAR: "foo:bar" do
              expect(described_class.parse(defaults, envs_aliases)).to eq(opts)
            end
          end
        end

      end
    end
  end
end
