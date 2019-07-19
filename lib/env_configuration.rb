require "env_configuration/version"
require "env_configuration/configurator"
require "env_configuration/configuration"

module EnvConfiguration
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end


  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(self.configuration)
    self.configuration
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

end

