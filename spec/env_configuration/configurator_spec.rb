require 'spec_helper'

# lazy load so need to require again
require "env_configuration/adapter/base"
require "env_configuration/adapter/dot_env_adapter"

RSpec.describe EnvConfiguration::Configurator do
  describe '.load' do
    it 'build and load config from adapter_name if adapter_name is an atom' do
      result = EnvConfiguration::Configurator.load(:dot_env)
    
      expected_result = { "APP_NAME"=>"BookMeBus DotRoot", "COMPANY_NAME"=>"Camtasia Technology DotRoot",
                        "APP_VERSION"=>"1.0.0-DotRoot", "ENABLE_HTTPS"=>"no-DotRoot", 
                        "ASSET_HOST_URL"=>"http://DotRoot.local", "HOST"=>"http://DotRoot.local"}

      expect(result).to match expected_result
    end

    it 'load config from adapter if it adapter_name is a loader object' do
      dot_env = EnvConfiguration::Adapter::DotEnvAdapter.new
      result  = EnvConfiguration::Configurator.load(dot_env)

      expected_result = { "APP_NAME"=>"BookMeBus DotRoot", "COMPANY_NAME"=>"Camtasia Technology DotRoot",
        "APP_VERSION"=>"1.0.0-DotRoot", "ENABLE_HTTPS"=>"no-DotRoot", 
        "ASSET_HOST_URL"=>"http://DotRoot.local", "HOST"=>"http://DotRoot.local"}

      expect(result).to match expected_result
      
    end
  end

  describe '.adapter' do
    it "raise error if adapter name not listed in [:dot_env, :yaml, :aws_ssm_parameter_store]" do
      error_message = 'adapter :invalid_adapter must be one of the following [:dot_env, :yaml, :aws_ssm_parameter_store]'
      expect{ EnvConfiguration::Configurator.adapter(:invalid_adapter) }.to raise_error(error_message)
    end

    it 'return EnvConfiguration::Adapter::DotEnvAdapter object if adapter name is :dot_env' do
      adapter = EnvConfiguration::Configurator.adapter(:dot_env)
      expect(adapter.class).to eq EnvConfiguration::Adapter::DotEnvAdapter
    end

    it 'return EnvConfiguration::Adapter::YamlAdapter objecct if name is :yaml' do
      adapter = EnvConfiguration::Configurator.adapter(:yaml)
      expect(adapter.class).to eq EnvConfiguration::Adapter::YamlAdapter
    end

    it 'return EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter objecct if name is :aws_ssm_parameter_store' do
      adapter = EnvConfiguration::Configurator.adapter(:aws_ssm_parameter_store)
      expect(adapter.class).to eq EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter
    end

  end

  
  
end
