require 'aws-sdk-ssm'
require 'aws-sdk-core'

module EnvConfiguration

  class AwsSsmClient
    # Aws.config[:credentials]
    # ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']
    # Aws::Credentials(access_key_id, secret_access_key )
   
    def self.create_instance(options = {})

      return ::Aws::SSM::Client.new if options.empty?
     
      custom_options = {}
      custom_options[:credentials] = options[:credentials] if !options[:credentials].nil?
      custom_options[:region]      = options[:region] if !options[:region]


      if(custom_options[:credentials].class == Hash )
        credentials = Aws::Credentials.new(credentials[:access_key_id], credentials[:secret_access_key])
        custom_options[:credentials] = credentials
      end

      ::Aws::SSM::Client.new(custom_options)
    end

    def self.instance(options = {})
      @@client ||= create_instance(options)
      @@client
    end
  end
end