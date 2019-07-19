module EnvConfiguration

  class Configurator
    def self.load(adapter_name, options={})
      if adapter_name.class == Symbol
        loader = self.adapter(adapter_name, options)
        loader.load
      else
        adapter_name.load
      end
    end

    def self.adapter(adapter_name, options={})
      case adapter_name
      when :dot_env
        require "env_configuration/adapter/base"
        require "env_configuration/adapter/dot_env_adapter"
        Adapter::DotEnvAdapter.new(options)
      when :aws_ssm_parameter_store
        require 'aws-sdk-ssm'
        require "env_configuration/adapter/base"
        require "env_configuration/adapter/aws_ssm_parameter_store_adapter"
        require "env_configuration/aws_ssm_parameter_store_writer"
        Adapter::AwsSsmParameterStoreAdapter.new(options)
      when :yaml
        require "env_configuration/adapter/base"
        require "env_configuration/adapter/yaml_adapter"
        Adapter::YamlAdapter.new(options)
      else
        existings = [:dot_env, :yaml, :aws_ssm_parameter_store]
        raise "adapter :#{adapter_name} must be one of the following #{existings}"
      end
    end
  end
end

