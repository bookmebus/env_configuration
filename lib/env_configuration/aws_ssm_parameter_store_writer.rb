module EnvConfiguration
  class AwsSsmParameterStoreWriter
    attr_accessor :env_name #allow to reset env but not region

    def initialize(env_name: 'staging', region: 'ap-southeast-1')
      @env_name = env_name
      @region   = region
    end

    def client
      AwsSsmClient.instance
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

    def put_configs_from_yaml_file(config_yml)
      configs = YAML.load_file(config_yml)[@env_name]

      configs.each do |key, value|
        put_config(key, value)
      end
    end
  end
end
