require "rails/generators/base"

module SimpleHelpers
  module Generators
    class InstallGenerator < Rails::Generators::Base

      namespace "simple_helpers"
      source_root File.dirname(__FILE__) + "/../../templates"

      desc "Creates a Simple Helper initializer and copy to config/initializers/simple_helpers.rb"
      def copy_initializer_file
        copy_file "initializer.rb", "config/initializers/simple_helpers.rb"
      end
    end
  end
end
