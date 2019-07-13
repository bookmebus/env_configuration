module EnvConfiguration
  module Adapter
    class AwsSsmParameterStore
      attr_accessor :path #allow to reset env but not region

      def initialize(client)
        @client   = client
      end

      def load(path)
        fetch_configs(path) do |item|
          ENV["#{item[:name]}"] = item[:value]
        end
      end

      def fetch_configs(path, &block)
        next_token = nil
        result = []

        while(true)

          fetch_options = {
            path: path,
            with_decryption: false,
            recursive: true,
            max_results: 10
          }

          fetch_options[:next_token] = next_token if next_token

          response = @client.get_parameters_by_path(fetch_options)

          item = sanitize_configs(path, response.parameters, &block)
          result += item

          next_token = response.next_token
          break if next_token.nil?
        end

        result
      end

      def sanitize_configs(path, parameters, &block)
        items = []
        parameters.each do |param|
          name  = param.name.gsub("#{path}/", '')
          value = param.value
          item = {name: name, value: value}
          items << item
          yield(item) if block_given?
        end
        items
      end
    end

  end
end
