require 'yaml'

module EnvConfiguration
  module Adapter
    class YamlAdapter < Base
 
      def initialize(options = {})
        super(options)
      end

      def section
        section_value = @options[:section] || EnvConfiguration.configuration.yaml_section
        raise ":section in the options{} is required, for example :staging, :test, :production" if section_value.nil?
        section_value
      end
      
      def yaml_file
        yaml_file_value = @options[:yaml_file] || EnvConfiguration.configuration.yaml_file
        raise ":yaml_file in the options{} is required, for example config/application.yml" if yaml_file_value.nil?
        yaml_file_value
      end

      def load
        configs = fetch_configs
        update_env_variable_with(configs)
        configs
      end

      def fetch_configs
        ::YAML.load_file(yaml_file)[section]
      end
    end
  end
end
