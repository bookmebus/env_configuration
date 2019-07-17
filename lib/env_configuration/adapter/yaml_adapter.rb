require 'yaml'

module EnvConfiguration
  module Adapter
    class YamlAdapter < Base
 
      def initialize(options = {})
        super(options)
      end

      def section
        raise ":section in the options{} is required, for example :staging, :test, :production" if @options[:section].nil?
        @options[:section]
      end
      
      def yaml_file
        raise ":yaml_file in the options{} is required, for example config/application.yml" if @options[:yaml_file].nil?
        @options[:yaml_file]
      end

      def load
        configs = fetch_configs
        ENV.update(configs)
        configs
      end

      def fetch_configs
        ::YAML.load_file(yaml_file)[section]
      end
    end
  end
end
