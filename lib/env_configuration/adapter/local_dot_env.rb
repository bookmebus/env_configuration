module EnvConfiguration
  module Adapter
    class LocalDotEnv
      def load
        Dotenv.load
      end
    end
  end
end
