# frozen_string_literal: true

require "spec_helper"

describe ThorAddons::Options do
  describe "#new" do
    it "should not failed when passed no parameters" do
      Cli.new
    end
  end

  describe "#options" do
    let(:options) { ::SymbolizedHash.new(hash) }

    context "plain" do
      let(:hash) { { zip: "zip", biz: "option_biz" } }

      it "should generate the correct options" do
        args = %W[foo --biz #{hash[:biz]}]
        expect(CliPlain.start(args)).to eq(options)
      end
    end

    context "with env" do
      let(:hash) { { zip: "zip", biz: "biz", bar: "ENV_BAR" } }

      it "should generate the correct options" do
        args = %W[foo --biz #{hash[:biz]}]

        ClimateControl.modify BAR: hash[:bar] do
          expect(CliNoConfig.start(args)).to eq(options)
        end
      end
    end

    context "with config" do
      let(:config_file) { "config.yml" }
      let(:hash) do
        { zip: "config_zip", biz: "config_biz", config_file: config_file }
      end

      it "should generate the correct options" do
        args = %w[foo]

        allow(File).to receive(:file?).with(config_file).and_return(true)
        allow(YAML).to receive(:load_file).with(config_file)
          .and_return(config_fixture)

        expect(CliNoEnv.start(args)).to eq(options)
      end

      context "global settings missing" do
        let(:hash) { { zip: "zip", config_file: "config.yml" } }

        it "should generate the correct options" do
          args = %w[foo]

          allow(File).to receive(:file?).with(config_file).and_return(true)
          allow(YAML).to receive(:load_file).with(config_file).and_return({})

          expect(CliNoEnv.start(args)).to eq(options)
        end
      end

      context "option with invalid type" do
        let(:hash) { { zip: "zip", config_file: "config.yml" } }

        it "should generate the correct options" do
          args = %w[foo]

          allow(File).to receive(:file?).with(config_file).and_return(true)
          allow(YAML).to receive(:load_file).with(config_file)
            .and_return("foo" => { "bar" => [] })

          expect { CliNoEnv.start(args) }.to raise_error(TypeError)
        end
      end
    end

    context "with config and env" do
      let(:hash) do
        {
          zip: "config_zip",
          biz: "config_biz",
          bar: "ENV_BAR",
          config_file: "config.yml"
        }
      end
      let(:config_file) { "config.yml" }

      it "should generate the correct options" do
        args = %w[foo]

        allow(File).to receive(:file?).with(config_file).and_return(true)
        allow(YAML).to receive(:load_file).with(config_file)
          .and_return(config_fixture)

        ClimateControl.modify BAR: hash[:bar] do
          expect(Cli.start(args)).to eq(options)
        end
      end
    end

    context "with config and env and subcommand" do
      let(:hash) do
        {
          zip: "config_zip",
          biz: "config_biz",
          bar: "ENV_BAR",
          config_file: "config.yml"
        }
      end
      let(:config_file) { "config.yml" }

      it "should generate the correct options" do
        args = %w[sub foo]

        allow(File).to receive(:file?).with(config_file).and_return(true)
        allow(YAML).to receive(:load_file).with(config_file)
          .and_return(sub_config_fixture)

        ClimateControl.modify BAR: hash[:bar] do
          expect(CliSubCommand.start(args)).to eq(options)
        end
      end
    end

    context "with env aliases" do
      let(:hash) do
        {
          zip: "config_zip",
          bar: "ENV_ALIAS_BAR",
          biz: "config_biz",
          config_file: "config.yml"
        }
      end
      let(:config_file) { "config.yml" }

      it "should generate the correct options" do
        args = %w[foo]

        allow(File).to receive(:file?).with(config_file).and_return(true)
        allow(YAML).to receive(:load_file).with(config_file)
          .and_return(config_fixture)

        ClimateControl.modify ALIAS_BAR: hash[:bar] do
          expect(CliWithEnvAlias.start(args)).to eq(options)
        end
      end
    end
  end
end
