require 'dotenv'

module EnvConfiguration
  module Adapter
    class DotEnvAdapter < Base

      def initialize(options={})
        super(options)
      end

      def file
        @options[:dot_env_file] || EnvConfiguration.configuration.dot_env_file
      end

      def load
        p file
        if file.nil?
          Dotenv.load
        else
          Dotenv.load(file)
        end
      end
    end
  end
end
