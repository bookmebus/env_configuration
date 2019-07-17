module EnvConfiguration
  module Adapter
    attr_accessor :options

    class Base
      def initialize(options={})
        @options = options.clone
      end

      def update_env_variable_with(configs)
        ENV.update(configs)
      end
    end
  end
end