# frozen_string_literal: true

module ThorAddons
  module Helpers
    class OptionsConfigFile
      def self.parse_config_file(config_file)
        YAML.load_file(config_file) || {}
      rescue Errno::ENOENT, Psych::SyntaxError
        STDERR.puts("[WARN] Unable to parse 'config_file' '#{config_file}'.")
        {}
      end

      def self.extract_command_data(data, command)
        data_hash = data["global"] || {}

        return data_hash if command.nil? || data[command].nil?

        data_hash.merge(data[command])
      end

      def self.get_command_config_data(data, invocations, current_command_name)
        invocations ||= {}
        commands = (invocations.values.flatten << current_command_name)

        command_options = extract_command_data(data, commands.shift)

        commands.each do |cmd|
          should_break = command_options[cmd].nil?
          command_options.merge!(extract_command_data(command_options, cmd))

          %W[#{cmd} global].each { |k| command_options.delete(k) }

          break if should_break
        end

        command_options
      end

      def self.parse(config_file, invocations, current_command_name, defaults)
        data = parse_config_file(config_file)
        opts = get_command_config_data(data, invocations, current_command_name)

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
