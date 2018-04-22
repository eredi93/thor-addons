# frozen_string_literal: true

require "spec_helper"

describe ThorAddons::Helpers::OptionsConfigFile do
  let(:config_file) { "cli.yml" }
  let(:data) do
    {
      "global" => {
        "foo" => "bar"
      },
      "sub_1" => {
        "global" => {
          "fii" => "bii"
        },
        "sub_2" => {
          "cmd_2" => {
            "goo" => { "a" => "1" }
          }
        }
      },
      "cmd_1" => {
        "biz" => true
      }
    }
  end
  let(:invocations) { { Class => ["sub_1"], Object => ["sub_2"] } }

  before do
    allow(STDERR).to receive(:puts)
  end

  describe "#parse_config_file" do
    it "should return the parsed file" do
      allow(YAML).to receive(:load_file).with(config_file)
        .and_return(data)

      expect(described_class.parse_config_file(config_file)).to eq(data)
    end

    it "should return a empty hash when the file is empty" do
      allow(File).to receive(:read).with(config_file).and_return("")

      expect(described_class.parse_config_file(config_file)).to eq({})
    end

    it "should return a empty hash when the file does not exists" do
      allow(YAML).to receive(:load_file).with(config_file)
        .and_raise(Errno::ENOENT)

      expect(described_class.parse_config_file(config_file)).to eq({})
    end
  end

  describe "#extract_command_data" do
    it "should extract the data from th given hash" do
      expect(
        described_class.extract_command_data(data, "cmd_1")
      ).to eq([{ "foo" => "bar" }, { "biz" => true }])
    end

    it "should extract only the global if the command is not present" do
      expect(
        described_class.extract_command_data(data, "cmd_3")
      ).to eq([{ "foo" => "bar" }, {}])
    end

    it "should return a empty hash if the command and global not present" do
      expect(described_class.extract_command_data({}, "cmd_3")).to eq([{}, {}])
    end
  end

  describe "#get_command_config_data" do
    context "with invocations" do
      it "should parse the config file" do
        expect(
          described_class.get_command_config_data(
            data,
            invocations,
            "cmd_2"
          )
        ).to eq("foo" => "bar", "fii" => "bii", "goo" => { "a" => "1" })
      end
    end

    context "with no invocations" do
      it "should parse the config file" do
        expect(
          described_class.get_command_config_data(data, nil, "cmd_1")
        ).to eq("foo" => "bar", "biz" => true)
      end
    end
  end

  describe "#parse" do
    let(:defaults) do
      {
        foo: { value: nil, type: :string },
        fii: { value: "xxx", type: :string },
        goo: { value: {}, type: :hash }
      }
    end

    it "should parse the config file and select the valid options" do
      allow(described_class).to receive(:parse_config_file)
        .with(config_file).and_return(data)
      allow(described_class).to receive(:parse_command_config_data)
        .with(data, invocations, "cmd_2")
        .and_return("foo" => "bar", "fii" => "bii", "goo" => { "a" => "1" })

      expect(
        described_class.parse(config_file, invocations, "cmd_2", defaults)
      ).to eq(foo: "bar", fii: "bii", goo: { a: "1" })
    end

    context "with invalid options" do
      let(:defaults) do
        {
          fii: { value: "xxx", type: :string },
          goo: { value: {}, type: :hash }
        }
      end

      it "should parse the config file and select the valid options" do
        allow(described_class).to receive(:parse_config_file)
          .with(config_file).and_return(data)
        allow(described_class).to receive(:parse_command_config_data)
          .with(data, invocations, "cmd_2")
          .and_return("foo" => "bar", "fii" => "bii", "goo" => { "a" => "1" })

        expect(STDERR).to receive(:puts)
        expect(
          described_class.parse(config_file, invocations, "cmd_2", defaults)
        ).to eq(fii: "bii", goo: { a: "1" })
      end
    end
  end
end
