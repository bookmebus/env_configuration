require 'spec_helper'

RSpec.describe EnvConfiguration do
  it "has a version number" do
    expect(EnvConfiguration::VERSION).not_to be nil
  end

  it "define configurator" do
    expect(defined?(EnvConfiguration::Configurator)).to be_truthy
  end

end
