require 'dotenv'

module EnvConfiguration
  module Adapter
    class DotEnvAdapter < Base

      def initialize(options={})
        super(options)
      end

      def load
        file = @options[:env_file]
        if file.nil?
          Dotenv.load
        else
          Dotenv.load(file)
        end
      end
    end
  end
end
