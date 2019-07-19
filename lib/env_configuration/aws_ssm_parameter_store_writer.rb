module EnvConfiguration
  class AwsSsmParameterStoreWriter
    attr_accessor :env_name #allow to reset env but not region

    def initialize(env_name, options = {})
      @env_name = env_name
      @options  = options
    end

    def client
      @client ||= Aws::SSM::Client.new(@options)
    end

    def put_configs_from_yaml_file(config_yml)
      configs = YAML.load_file(config_yml)[@env_name]
      put_configs(configs)
    end

    def put_configs(configs)
      configs.each do |key, value|
        put_config(key, value)
      end
    end

    def put_config(name, value, type='String')
      Rails.logger.info { "preparing: #{name}=#{value}" }

      param_name = "/#{@env_name}/#{name}"

      options = {
        name: param_name, # required
        value: value, # required
        type: type, # required, accepts String, StringList, SecureString
        overwrite: true,
        tier: "Standard", # accepts Standard, Advanced
      }
      response = client.put_parameter(options)

      Rails.logger.info { "setting: #{options}" }
      response
    end
  end
end
