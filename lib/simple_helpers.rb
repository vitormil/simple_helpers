require "simple_helpers/config"
require "simple_helpers/support"
require "simple_helpers/helpers"
require "simple_helpers/action_controller"
require "simple_helpers/railtie"

module SimpleHelpers
  def self.configure(&block)
    yield Config
  end
end

SimpleHelpers.configure do |config|
  config.helpers = {}
  config.options = []
end
