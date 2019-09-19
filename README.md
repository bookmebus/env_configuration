
# EnvConfiguration

[![Build Status](https://travis-ci.org/channainfo/env_configuration.svg?branch=develop)](https://travis-ci.org/channainfo/env_configuration)

This gem aims to load your configuration into environment variable that can be accessed via ENV variable in ruby. Currently configuration can be done via 3 different adapters

 1. Using .env powered by [dotenv](https://github.com/bkeepers/dotenv) gem. This is very popular in development environment.
 2. Using Yaml file config. As Yaml can be nested it is a bit more convenient than dotenv to separate setting between environment.
 3. Using [AWS System Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)  this is recommended for production. This gem does not support encrypted parameters. But it is simple to do it PR is welcome too.

How about container service like [Heroku](https://heroku.com/) and [ElasticBeanstalk](https://aws.amazon.com/elasticbeanstalk/)?

Heroku has application setting page with configurations for your ENV with a limitation of 32kb max in size. ElasticBeanstalk has a similar approach by allowing you to set configuration variable in the ElasticBeanstalk setting page, however [it allows only 4096 bytes max for key & value combined](https://stackoverflow.com/questions/54344236/environmentvariables-default-value-length-is-greater-than-4096). This might cause issues for some application. If your application configurations have key & value combined exceed 4096 bytes., Aws system parameter store can be one of the solution to overcome the limitation in ElasticBeanstalk.



## Why Store config in the environment?

An app’s  _config_  is everything that is likely to vary between  [deploys](https://12factor.net/codebase)  (staging, production, developer environments, etc). This includes:

-   Resource handles to the database, Memcached, and other  [backing services](https://12factor.net/backing-services)
-   Credentials to external services such as Amazon S3 or Twitter
-   Per-deploy values such as the canonical hostname for the deploy

Apps sometimes store config as constants in the code. This is a violation of twelve-factor, which requires  **strict separation of config from code**. Config varies substantially across deploys, code does not.

A litmus test for whether an app has all config correctly factored out of the code is whether the codebase could be made open source at any moment, without compromising any credentials.

## Installation
```ruby
gem 'env_configuration'

```

And then execute:

```bash  
$ bundle
```


Or install it yourself as:


```bash
$ gem install env_configuration
```


## Usage
There are 3 types of adapter :dot_env,  :yaml,  :aws_ssm_parameter_store.
```ruby
EnvConfiguration::Configurator.load(:adapter_name, options={})
```
Options value varies from adapter to adapter.

### Configure gem
You can configure the gem with the following:
```ruby
EnvConfiguration.configure do |config|
  config.dot_env = { dot_env_file:  'config/app.env' }
  config.yaml    = { yaml_file:  'config/app.yaml', section: 'development'}
  config.aws_ssm_parameter_store  = { access_key_id:  'aws-key', secret_access_key:  'aws-secret', region:  'ap-southeast-1', path:  '/staging'}
end
```

### DotEnv Adapter
Internally EnvConfiguration use [https://github.com/bkeepers/dotenv](https://github.com/bkeepers/dotenv) to handle this:

```ruby
# Configuration (optional)
# EnvConfiguration.configure do |config|
#   config.dot_env = { dot_env_file:  'config/app.env' }
# end

options = { dot_env_file: 'your-dotenv-app.env' }
EnvConfiguration::Configurator.load(:dot_env, options)
```
If options is not provided then the :dot_env adapter will try to get the from the gem configuration. It still does not exist then it will load the .env file located in the root of the project.

### Yaml adapter
Internally EnvConfiguration use 'yaml' library from ruby to handle this.
```ruby
# Configuration (optional)
#EnvConfiguration.configure do |config|
#  config.yaml  = { section:  'default-dev', yaml_file:  'config/default-app.yml'}
#end

# optional if you configure the gem above.
options  = { yaml_file: 'config/app.yaml', __FILE__), section: 'development' }
result  =  EnvConfiguration::Configurator.load(:yaml, options)
```
Both :yaml_file and :section must exist . If you options is being specified EnvConfiguration will take value from options. otherwise gem configuration must provide the values.

if you miss to provide :yaml_file and :section the gem will raise the following errors:

 - :yaml_file in the options{} is required, for example config/application.yml
 - :section in the options{} is required, for example :staging, :test, :production

As an example value of yaml_file: [config/app.yml.](https://github.com/channainfo/env_configuration/blob/develop/spec/config/app.yaml) Sections here are (test, development, staging, production)
```yml
default: &default
  APP_NAME: "BookMeBus"
  COMPANY_NAME: "Camtasia Technology"
  APP_VERSION: "Development"
  ENABLE_HTTPS: 'no'
  ASSET_HOST_URL: 'http://localhost:3000'
  HOST: 'http://localhost:3000'

test:
  <<: *default

development:
  <<: *default

staging:
  <<: *default

production:
  <<: *default
```
### AWS SSM Parameter Store

EnvConfiguration will fetch from the aws ssm parameter store service 10 key, value per request. If you have hundred it will ended up fetching as many requests until it finishes.

AWS Systems Manager Parameter Store provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, and license codes as parameter values. You can store values as plain text or encrypted data. You can then reference values by using the unique name that you specified when you created the parameter. Highly scalable, available, and durable, Parameter Store is backed by the AWS Cloud.

Internally EnvConfiguration use aws-sdk-ssm gem to handle this.

```ruby
# Configuration (optional)
#EnvConfiguration.configure do |config|
# options  = { access_key_id:  'default-key-id', secret_access_key:  'default-secret-key', region:  'default-region', path:  'default-path' }
# config.aws_ssm_parameter_store  = options
#end

options = {access_key_id: 'your-aws-key', secret_access_key: 'your-aws-secret', region: 'your-region' , path:  '/staging'}
EnvConfiguration::Configurator.load(:aws_ssm_parameter_store, options)
```
EnvConfiguration will use the options if options exists, otherwise it will use the options from the gem configuration above. The options will then be passed to aws-sdk-ssm.
EnvConfiguration gem will hand over the options to aws-sdk-ssm. Interesting aws-sdk-ssk will follows the rules as below:

### Access key id and secret_access_key
 :access_key_id, :secret_access_key are search for in the following locations:
 - :access_key_id, :secret_access_key
 - ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']
 - ~/.aws/credentials
 - ~/.aws/config

### The Region
The region is search for in the following locations:
  - :region
  - ENV['AWS_REGION']
   - ENV['AMAZON_REGION']
   - ENV['AWS_DEFAULT_REGION']
   - ~/.aws/credentials
   - ~/.aws/config
For more details on the configuration [https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SSM/Client.html](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SSM/Client.html)


### Aws policy for SSM Parameter Store
In order to be able to fetch the parameter store from aws ssm you need at least **ssm:GetParametersByPath**  policy to attach to your IAM account
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
```

## Integrate with rails

### Add Gem to application.rb
Add the following line
```ruby
EnvConfiguration::Configurator.load(:dot_env)
```
right below the
```ruby
Bundler.require(*Rails.groups)
```
in the config/application.rb as below:

```ruby
require File.expand_path('boot', __dir__)
require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# EnvConfiguration
EnvConfiguration::Configurator.load(:dot_env)
```
As this gem does not handle the Rails env, you might need to do this yourself in case you use different adapters for each Rails env:

```ruby
require File.expand_path('boot', __dir__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# EnvConfiguration
if(Rails.env.development?)
  EnvConfiguration::Configurator.load(:dot_env)
elsif Rails.env.test?
  EnvConfiguration::Configurator.load(:yaml, yaml_file: "#{Rails.root}/config/app-test.yml", section: Rails.env)
else
  #separete aws ssm parameter store from staging with production /Rails.env
  EnvConfiguration::Configurator.load(:aws_ssm_parameter_store, path: "/#{Rails.env}")
end
```


### Gem configuration in config/initializers/env_configuration.rb
```ruby
EnvConfiguration.configure do |config|
  # Dot Env
  config.dot_env = { dot_env_file: 'config/app.env' }
  # Yaml Config
  config.yaml = { yaml_file: File.join(Rails.root, "config/application_#{Rails.env}.yaml", section: Rails.env )}

  # Aws ssm parameter store
  config.aws_ssm_parameter_store = { access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                     region: ENV['AWS_REGION'],
                                     path: "/#{Rails.env}"}
end

```


## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/bookmebus/env_configuration](https://github.com/bookmebus/env_configuration). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
