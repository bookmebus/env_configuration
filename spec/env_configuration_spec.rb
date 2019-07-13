

RSpec.describe EnvConfiguration do
  it "has a version number" do
    expect(EnvConfiguration::VERSION).not_to be nil
  end

  it "load dot_env" do
    EnvConfiguration::Configurator.load(:dot_env)
    expect( ENV['VAR_NAME']).to eq 'Var Value'
  end

  it "load ssm parameter store" do
    # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SSM/Client.html
    # AWS_ACCESS_KEY_ID=''
    # AWS_SECRET_ACCESS_KEY=''
    # AWS_REGION=''
    access_key_id     = ''
    secret_access_key = '+45P/9Ev0'
    region            = 'ap-southeast-1'

    ENV['AWS_ACCESS_KEY_ID']     = ''
    ENV['AWS_SECRET_ACCESS_KEY'] = ''
    ENV['AWS_REGION']            = ''

    options = {}
    # options[:credentials] = {access_key_id: access_key_id, secret_access_key: secret_access_key }
    # options[:region] = region,

    options[:path]   = "/staging"

    configs = EnvConfiguration::Configurator.load(:aws_ssm_parameter_store, options)
    configs
  end

  it "raise error if adapter not found" do
    error_message = "adapter not_found must be one of the following [:dot_env, :aws_ssm_parameter_store]"
    expect{EnvConfiguration::Configurator.load(:not_found)}.to raise_error(error_message)
  end
  
end
