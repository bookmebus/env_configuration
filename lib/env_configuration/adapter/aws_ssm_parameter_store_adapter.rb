module EnvConfiguration
  module Adapter
    class AwsSsmParameterStoreAdapter < Base

      def initialize(options={})
        super(options)
        raise ":path options is required for example /staging" if options[:path].nil?
        @path = @options.delete(:path)
      end

      def client
        @client ||= Aws::SSM::Client.new(@options)
      end

      def path
        @path
      end

      def load
        # fetch_configs do |item|
        #   ENV["#{item[:name]}"] = item[:value]
        # end

        configs = fetch_configs
        ENV.update(configs)
        configs
      end

      def fetch_configs(&block)
        next_token = nil
        result = {}

        while(true)

          fetch_options = {
            path: path,
            with_decryption: false,
            recursive: true,
            max_results: 10
          }

          fetch_options[:next_token] = next_token if next_token

          response = client.get_parameters_by_path(fetch_options)

          items = sanitize_configs(response.parameters, &block)
          result.merge!(items)

          next_token = response.next_token
          break if next_token.nil?
        end

        result
      end

      def sanitize_configs(parameters, &block)
        items = {}
        parameters.each do |param|
          name  = param.name.gsub("#{path}/", '')
          value = param.value
          item = {name: name, value: value}
          items[name] = value
          yield(item) if block_given?
        end
        items
      end
    end

  end
end
