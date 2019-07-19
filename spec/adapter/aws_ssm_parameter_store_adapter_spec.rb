require 'spec_helper'
# lazy loaded in the gems, need to manually require
require 'aws-sdk-ssm'
require "env_configuration/adapter/base"
require "env_configuration/adapter/aws_ssm_parameter_store_adapter"
require "env_configuration/aws_ssm_parameter_store_writer"

RSpec.describe EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter do

  let!(:configuration) do
    EnvConfiguration.configure do |config|
      options = { access_key_id: 'default-key-id', secret_access_key: 'default-secret-key',
                  region: 'default-region', path: 'default-path' }
      config.aws_ssm_parameter_store = options
    end
  end

  describe '#path' do
    context 'path is set' do

      it 'return path from option if it exist' do
        adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new(path: '/staging')
        expect(adapter.path).to eq '/staging'
      end

      it 'return path from config if path does not exist in the options' do
        adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new
        expect(adapter.path).to eq 'default-path'
      end

    end

    context 'path is not set' do
      it 'raise error' do
        configuration.aws_ssm_parameter_store = nil
        adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new

        error_message = ":path options is required for example /staging"
        expect{adapter.path}.to raise_error(error_message)
      end
    end
  end

  describe '#access_key_id' do
    it 'return access_key_id option if it exists' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new(access_key_id: 'my-access-key-id')
      expect(adapter.access_key_id).to eq 'my-access-key-id'
    end

    it 'return access_key_id from config if it does not exist in the options' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new
      expect(adapter.access_key_id).to eq 'default-key-id'
    end

  end

  describe '#secret_access_key' do
    it 'return secret_access_key option if it exists' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new(secret_access_key: 'my-secret-key-id')
      expect(adapter.secret_access_key).to eq 'my-secret-key-id'
    end

    it 'return secret_access_key from config if it does not exist in the options' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new
      expect(adapter.secret_access_key).to eq 'default-secret-key'
    end

  end

  describe '#region' do
    it 'return region option if it exists' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new(region: 'ap-southeast-1')
      expect(adapter.region).to eq 'ap-southeast-1'
    end

    it 'return region from config if it does not exist in the options' do
      adapter = EnvConfiguration::Adapter::AwsSsmParameterStoreAdapter.new
      expect(adapter.region).to eq 'default-region'
    end

  end



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
