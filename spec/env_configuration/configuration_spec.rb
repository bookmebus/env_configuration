require 'spec_helper'


RSpec.describe EnvConfiguration::Configuration do
  let!(:configuration) { EnvConfiguration::Configuration.new }

  describe '#dot_env_file' do

    it 'return nil if dot_env is blank' do
      expect(configuration.dot_env_file).to eq nil
    end

    it 'return value if dot_env field set his value' do
      configuration.dot_env = { dot_env_file: 'config/app.env'}
      expect(configuration.dot_env_file).to eq 'config/app.env'
    end
  end

  describe '#yaml_file' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.yaml_file).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.yaml = { yaml_file: 'config/app.yaml'}
      expect(configuration.yaml_file).to eq 'config/app.yaml'
    end
  end

  describe '#yaml_section' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.yaml_section).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.yaml = { section: 'config/app.yaml'}
      expect(configuration.yaml_section).to eq 'config/app.yaml'
    end
  end

  describe '#aws_access_key_id' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.aws_access_key_id).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.aws_ssm_parameter_store = { access_key_id: 'my aws key id'}
      expect(configuration.aws_access_key_id).to eq 'my aws key id'
    end
  end

  describe '#aws_secret_access_key' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.aws_secret_access_key).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.aws_ssm_parameter_store = { secret_access_key: 'my aws key id'}
      expect(configuration.aws_secret_access_key).to eq 'my aws key id'
    end
  end

  describe '#aws_region' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.aws_region).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.aws_ssm_parameter_store = { region: 'ap-south-1'}
      expect(configuration.aws_region).to eq 'ap-south-1'
    end
  end

  describe '#aws_path' do
    
    it 'return nil if yaml is blank' do
      expect(configuration.aws_path).to eq nil
    end

    it 'return value if yaml field set his value' do
      configuration.aws_ssm_parameter_store = { path: '/staging'}
      expect(configuration.aws_path).to eq '/staging'
    end
  end

end