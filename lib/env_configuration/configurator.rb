module EnvConfiguration

  class Configurator
    def self.load(adapter, options={})
      existings = [:dot_env, :aws_ssm_parameter_store]
      case adapter
      when :dot_env
        require 'dotenv'
        require "env_configuration/adapter/local_dot_env"
        local_dot_env = Adapter::LocalDotEnv.new
        local_dot_env.load()

      when :aws_ssm_parameter_store
        require 'aws-sdk-ssm'
        require "env_configuration/aws_ssm_client"
        require "env_configuration/aws_ssm_parameter_store_writer"
        require "env_configuration/adapter/aws_ssm_parameter_store"

        path = options.delete(:path)
        ssm_client = ::Aws::SSM::Client.new(options)
 
        aws_adapter = Adapter::AwsSsmParameterStore.new(ssm_client)
        aws_adapter.load(path)
      else
        raise "adapter #{adapter} must be one of the following #{existings}"
      end
    end
  end
end

