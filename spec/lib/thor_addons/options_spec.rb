require "spec_helper"

module ThorAddons
  describe Options do
    describe "#options" do
      let(:options) { ::Thor::CoreExt::HashWithIndifferentAccess.new(hash) }

      context "plain" do
        let(:hash) { { zip: "zip", biz: "option_biz" } }

        it "should generate the correct options" do
          args = %W(foo --biz #{hash[:biz]})
          expect(CliPlain.start(args)).to eq(options)
        end
      end

      context "with env" do
        let(:hash) { { zip: "zip", biz: "biz", bar: "ENV_BAR" } }

        it "should generate the correct options" do
          args = %W(foo --biz #{hash[:biz]})

          hash.keys.each do |option|
            allow(ENV).to receive(:[]).with(option.to_s.upcase).and_return(hash[option])
          end

          expect(CliNoConfig.start(args)).to eq(options)
        end
      end

      context "with config" do
        let(:hash) { { zip: "zip", biz: "config_biz", config_file: "config.yml" } }
        let(:config_file) { "config.yml" }

        it "should generate the correct options" do
          args = %W(foo)
          
          allow(File).to receive(:file?).with(config_file).and_return(true)
          allow(YAML).to receive(:load_file).with(config_file).and_return(config_fixture)

          expect(CliNoEnv.start(args)).to eq(options)
        end
      end
    end
  end
end
