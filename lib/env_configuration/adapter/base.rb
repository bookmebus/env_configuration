module EnvConfiguration
  module Adapter
    attr_accessor :options

    class Base
      def initialize(options={})
        @options = options.clone
      end
    end
  end
end