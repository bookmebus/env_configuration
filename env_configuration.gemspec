
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "env_configuration/version"

Gem::Specification.new do |spec|
  spec.name          = "env_configuration"
  spec.version       = EnvConfiguration::VERSION
  spec.authors       = ["Channa Ly"]
  spec.email         = ["channa.info@gmail.com"]

  spec.summary       = %q{
    This gem aims to load your configuration into environment variable that can be accessed via ENV variable in ruby.
    Currently configuration can be done via 3 different adapters}
  spec.description   = %q{
This gem aims to load your configuration into environment variable that can be accessed via ENV variable in ruby.
Currently configuration can be done via 3 different adapters
    1 - Using .env powered by dotenv gem. This is very popular in development environment.
    2 - Using Yaml file config. As Yaml can be nested it is a bit more convenient than dotenv to separate setting between environment.
    3 - Using AWS System Manager Parameter Store this is recommended for production. This gem does not support encrypted parameters. But it is simple to do it PR is welcome too.

How about container service like Heroku and ElasticBeanstalk? Heroku has application setting page with configurations for your ENV with a limitation of 32kb max in size. ElasticBeanstalk has a similar approach by allowing you to set configuration variable in the ElasticBeanstalk setting page, however it allows only 4096 bytes max for key & value combined. This might cause issues for some application. If your application configurations have key & value combined exceed 4096 bytes., Aws system parameter store can be one of the solution to overcome the limitation in ElasticBeanstalk.
  }
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"

  spec.add_dependency "aws-sdk-core"
  spec.add_dependency "aws-sdk-ssm"
  spec.add_dependency "dotenv-rails", "2.7.4"
end
