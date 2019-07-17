require 'spec_helper'
# lazy loaded in the gems, need to manually require
require "env_configuration/adapter/base"
require "env_configuration/adapter/yaml_adapter"

RSpec.describe EnvConfiguration::Adapter::YamlAdapter do
  it "load yaml" do
    options = {
      yaml_file: File.expand_path('../../config/app.yaml', __FILE__),
      section: 'development'
    }
    result = EnvConfiguration::Configurator.load(:yaml, options)

    expected_result = { "APP_NAME"=>"BookMeBus Dev", "COMPANY_NAME"=>"Camtasia Technology Dev",
                        "APP_VERSION"=>"1.0.0-dev", "ENABLE_HTTPS"=>"no",
                        "ASSET_HOST_URL"=>"http://dev.local", "HOST"=>"http://dev.local"}

    expect(result).to match(expected_result)
  end
end
