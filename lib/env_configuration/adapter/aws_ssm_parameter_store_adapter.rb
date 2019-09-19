module EnvConfiguration
  module Adapter
    class AwsSsmParameterStoreAdapter < Base

      # if you set ENV['AWS_ACCESS_KEY_ID'],ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_REGION']
      # you don't need to pass the options
      # { access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], region: ENV['AWS_REGION']
      def initialize(options={})
        super(options)

      end

      def client
        aws_options = {
          access_key_id: access_key_id,
          secret_access_key: secret_access_key,
          region: region,
        }
        @client ||= Aws::SSM::Client.new(@options)
      end

      def access_key_id
        @options[:access_key_id] || EnvConfiguration.configuration.aws_access_key_id
      end

      def secret_access_key
        @options[:secret_access_key] || EnvConfiguration.configuration.aws_secret_access_key
      end

      def region
        @options[:region] || EnvConfiguration.configuration.aws_region
      end

      def path
        path_value = @options[:path] || EnvConfiguration.configuration.aws_path
        raise ":path options is required for example /staging" if path_value.nil?
        path_value
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
