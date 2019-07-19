require 'spec_helper'
# lazy loaded in the gems, need to manually require
require "env_configuration/adapter/base"
require "env_configuration/adapter/dot_env_adapter"

RSpec.describe EnvConfiguration::Adapter::DotEnvAdapter do

  let!(:dot_env_file) { File.expand_path('../../config/default-app.env', __FILE__)}
  let!(:configuration) do
    EnvConfiguration.configure do |config|
      config.dot_env = { dot_env_file:  dot_env_file}
    end
  end

  describe '#file' do
    context 'dot_env_file set' do
      it 'return from option if it set' do
        adapter = EnvConfiguration::Adapter::DotEnvAdapter.new(dot_env_file: 'config/app.env')
        expect(adapter.file).to eq 'config/app.env'
      end

      it 'return from config if options not set' do
        adapter = EnvConfiguration::Adapter::DotEnvAdapter.new
        expect(adapter.file).to eq dot_env_file
      end
    end

    context 'not set' do
      it 'return nil' do
        configuration.dot_env = nil
        adapter = EnvConfiguration::Adapter::DotEnvAdapter.new
        expect(adapter.file).to eq nil

      end
    end

  end


  describe "#load" do
    it "load from .env to environment if not file specified" do

      configuration.dot_env = nil
      result = EnvConfiguration::Configurator.load(:dot_env)
      
      expect_result = { "APP_NAME"=>"BookMeBus DotRoot", "COMPANY_NAME"=>"Camtasia Technology DotRoot", 
                        "APP_VERSION"=>"1.0.0-DotRoot", "ENABLE_HTTPS"=>"no-DotRoot",
                        "ASSET_HOST_URL"=>"http://DotRoot.local", "HOST"=>"http://DotRoot.local"}

      # testing ENV is not thread-safe.
      # expect(configs['APP_NAME']).to eq "BookMeBus DotRoot"
      expect(result).to match expect_result
    end

    it "load from dot_env_file to environment if no file specifed" do
      options = {
        dot_env_file: File.expand_path('../../config/default-app.env', __FILE__)
      }
      result = EnvConfiguration::Configurator.load(:dot_env, options)
      
      expected_result = { "APP_NAME"=>"BookMeBus DotFile", "COMPANY_NAME"=>"Camtasia Technology DotFile",
                          "APP_VERSION"=>"1.0.0-DotFile", "ENABLE_HTTPS"=>"no-DotFile", 
                          "ASSET_HOST_URL"=>"http://DotFile.local", "HOST"=>"http://DotFile.local"}
      expect(result).to match expected_result
    end
  end
end
