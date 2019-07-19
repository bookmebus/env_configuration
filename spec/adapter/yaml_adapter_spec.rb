require 'spec_helper'
# lazy loaded in the gems, need to manually require
require "env_configuration/adapter/base"
require "env_configuration/adapter/yaml_adapter"

RSpec.describe EnvConfiguration::Adapter::YamlAdapter do
  let!(:configuration) do
    EnvConfiguration.configure do |config|
      config.yaml = { section: 'default-dev', yaml_file: 'config/default-app.yml'}
    end
  end

  describe '#section' do

    context 'section is set' do
      it 'return section from the option if it defines' do
        adapter = EnvConfiguration::Adapter::YamlAdapter.new(section: 'development')
        expect(adapter.section).to eq 'development'
      end

      it 'return section from config' do
        adapter = EnvConfiguration::Adapter::YamlAdapter.new
        expect(adapter.section).to eq 'default-dev'
      end
    end

    context 'section is not set' do
      it 'raise error' do
        configuration.yaml = nil
        adapter = EnvConfiguration::Adapter::YamlAdapter.new

        error_message = ':section in the options{} is required, for example :staging, :test, :production'
        expect{adapter.section}.to raise_error(error_message)
      end
    end
  end

  describe '#yaml_file' do

    context 'yaml_file is set' do
      it 'return yaml_file from the option if it defines' do
        adapter = EnvConfiguration::Adapter::YamlAdapter.new(yaml_file: 'config/app.yml')
        expect(adapter.yaml_file).to eq 'config/app.yml'
      end

      it 'return yaml_file from config' do
        adapter = EnvConfiguration::Adapter::YamlAdapter.new
        expect(adapter.yaml_file).to eq 'config/default-app.yml'
      end
    end

    context 'yaml_file is not set' do
      it 'raise error' do
        configuration.yaml = nil
        adapter = EnvConfiguration::Adapter::YamlAdapter.new

        error_message = ':yaml_file in the options{} is required, for example config/application.yml'
        expect{adapter.yaml_file}.to raise_error(error_message)
      end
    end
  end




  describe '#load' do
    it "load configs to env and return its values" do
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
end