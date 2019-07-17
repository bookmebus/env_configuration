require 'spec_helper'
# lazy loaded in the gems, need to manually require
require "env_configuration/adapter/base"
require "env_configuration/adapter/dot_env_adapter"

RSpec.describe EnvConfiguration::Adapter::DotEnvAdapter do
  describe "#load" do
    it "load from .env to environment if not file specified" do
      result = EnvConfiguration::Configurator.load(:dot_env)
      
      expect_result = { "APP_NAME"=>"BookMeBus DotRoot", "COMPANY_NAME"=>"Camtasia Technology DotRoot", 
                        "APP_VERSION"=>"1.0.0-DotRoot", "ENABLE_HTTPS"=>"no-DotRoot",
                        "ASSET_HOST_URL"=>"http://DotRoot.local", "HOST"=>"http://DotRoot.local"}

      # testing ENV is not thread-safe.
      # expect(configs['APP_NAME']).to eq "BookMeBus DotRoot"
      expect(result).to match expect_result
    end

    it "load from env_file to environment if no file specifed" do
      options = {
        env_file: File.expand_path('../../config/.env', __FILE__)
      }
      result = EnvConfiguration::Configurator.load(:dot_env, options)
      
      expected_result = { "APP_NAME"=>"BookMeBus DotFile", "COMPANY_NAME"=>"Camtasia Technology DotFile",
                          "APP_VERSION"=>"1.0.0-DotFile", "ENABLE_HTTPS"=>"no-DotFile", 
                          "ASSET_HOST_URL"=>"http://DotFile.local", "HOST"=>"http://DotFile.local"}
      expect(result).to match expected_result
    end
  end
end
