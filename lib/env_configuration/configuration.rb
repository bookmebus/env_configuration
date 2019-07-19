module EnvConfiguration

  class Configuration
    attr_accessor :dot_env, :aws_ssm_parameter_store, :yaml

    # ------ :dot_env ---------
    # :dot_env_file

    def dot_env_file
      dot_env && dot_env[:dot_env_file]
    end

    # ------ :yaml ---------
    # :yaml_file, :section
    def yaml_file
      yaml && yaml[:yaml_file]
    end

    def yaml_section
      yaml && yaml[:section]
    end

    # ------ :aws_ssm_paramer_store ---------
    # :access_key_id, :secret_access_key, :region, :path
    def aws_access_key_id
      aws_ssm_parameter_store && aws_ssm_parameter_store[:access_key_id]
    end

    def aws_secret_access_key
      aws_ssm_parameter_store && aws_ssm_parameter_store[:secret_access_key]
    end

    def aws_region
      aws_ssm_parameter_store && aws_ssm_parameter_store[:region]
    end

    def aws_path
      aws_ssm_parameter_store && aws_ssm_parameter_store[:path]
    end
  end

end