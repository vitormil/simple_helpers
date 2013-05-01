require "rails/railtie"

module SimpleHelpers
  class Railtie < Rails::Railtie

    generators do
      require "simple_helpers/generators"
    end

    initializer "simple_helpers.initialize" do
      ::ActionController::Base.instance_eval do
        include SimpleHelpers::ActionController

        initialize_method = instance_method(:initialize)

        define_method :initialize do |*args|
          simple_helper(SimpleHelpers::Config.helpers.keys)

          initialize_method.bind(self).call(*args)
        end
      end
      ::I18n.load_path += Dir[File.dirname(__FILE__) + "/../../locales/*.yml"]
    end
  end
end
