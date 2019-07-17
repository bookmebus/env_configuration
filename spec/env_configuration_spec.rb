require 'spec_helper'

RSpec.describe EnvConfiguration do
  it "has a version number" do
    expect(EnvConfiguration::VERSION).not_to be nil
  end

  it "define configurator" do
    expect(defined?(EnvConfiguration::Configurator)).to be_truthy
  end


  describe '.configure' do
    it 'set value for config' do
      EnvConfiguration.configure do |config|
        config.dot_env = { dot_env_file: 'config/app.env' }
        config.yaml    = { yaml_file: 'config/app.yaml'}
        config.aws_ssm_parameter_store = { access_key_id: 'aws-key', secret_access_key: 'aws-secret',
                                           region: 'ap-southeast-1', path: '/staging'}
      end

      config = EnvConfiguration.configuration
      expect(config.dot_env).to match({:dot_env_file=>"config/app.env"})
      expect(config.yaml).to match({:yaml_file=>"config/app.yaml"})
      expect(config.aws_ssm_parameter_store).to match({:access_key_id=>"aws-key", :secret_access_key=>"aws-secret", :region=>"ap-southeast-1", :path=>"/staging"}) 
    end

  end

end
