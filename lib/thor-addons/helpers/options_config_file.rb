# frozen_string_literal: true
#
module ThorAddons
  module Helpers
    class OptionsConfigFile
      def self.parse_config_file(config_file)
        YAML.load_file(config_file) || {}
      rescue Errno::ENOENT, Psych::SyntaxError
        STDERR.puts("[WARN] Unable to parse 'config_file' '#{config_file}'.")
        return {}
      end

      def self.extract_command_data(data, command)
        data_hash = data["global"] || {}

        return data_hash if command.nil? || data[command].nil?

        data_hash.merge(data[command])
      end

      def self.parse_command_config_data(data, invocations, current_command_name)
        if !invocations.nil?
          commands = (invocations.values.flatten << current_command_name)
          first_cmd, *remaining_cmd = commands
          command_options = extract_command_data(data, first_cmd)

          remaining_cmd.each do |cmd|
            should_break = command_options[cmd].nil?

            command_data = extract_command_data(command_options, cmd)
            command_options.merge!(command_data)
            command_options.delete(cmd)
            command_options.delete("global")

            break if should_break
          end
        else
          command_options = extract_command_data(data, current_command_name)
        end

        command_options
      end

      def self.parse(config_file, invocations, current_command_name, defaults)
        data = parse_config_file(config_file)

        opts = parse_command_config_data(data, invocations, current_command_name)

        config_opts = opts.each_with_object({}) do |(key, value), hsh|
          if defaults.keys.map(&:to_s).include?(key.to_s)
            hsh[key] = value
          else
            STDERR.puts("[WARN] rejecting invalid config file option: '#{key}'")
          end
        end

        OptionsHash.new(config_opts)
      end
    end
  end
end
