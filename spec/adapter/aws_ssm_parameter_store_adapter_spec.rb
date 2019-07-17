require 'spec_helper'
# lazy loaded in the gems, need to manually require
require 'aws-sdk-ssm'
require "env_configuration/adapter/base"
require "env_configuration/adapter/aws_ssm_parameter_store_adapter"
require "env_configuration/aws_ssm_parameter_store_writer"

RSpec.describe EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter do
  describe "#load" do
    it "load ssm parameter store" do
      access_key_id     = 'your_aws_key'
      secret_access_key = 'your_aws_acccess_key'
      region            = 'ap-southeast-1'
  
      options = {access_key_id: access_key_id, secret_access_key: secret_access_key, region: region , path: '/staging'}
  
      aws_configs = {
        "APP_NAME" => 'BookMeBus ssm',
        "COMPANY_NAME" => 'Camtasia Technology ssm',
        "APP_VERSION" => '1.0.0-ssm',
        "ENABLE_HTTPS" => 'no-ssm',
        "ASSET_HOST_URL" => 'http://ssm.local',
        "HOST" => 'http://ssm.local'
      }
  
      loader = EnvConfiguration::Configurator.adapter(:aws_ssm_parameter_store, options)
      allow_any_instance_of(EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter).to receive(:fetch_configs).and_return(aws_configs)
  
      result = EnvConfiguration::Configurator.load(loader)
      expected_result = { "APP_NAME"=>"BookMeBus ssm", "COMPANY_NAME"=>"Camtasia Technology ssm", 
                          "APP_VERSION"=>"1.0.0-ssm", "ENABLE_HTTPS"=>"no-ssm", 
                          "ASSET_HOST_URL"=>"http://ssm.local", "HOST"=>"http://ssm.local"}
  
      expect(result).to match expected_result
    end
  end
end
