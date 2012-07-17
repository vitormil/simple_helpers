ENV["RAILS_ENV"] = "test"

require "rails"
require "simple_helpers"
require File.dirname(__FILE__) + "/support/config/boot"
require 'sqlite3'
require "rspec/rails"

# Load support files
# Dir[File.dirname(__FILE__) + "/support/rspec/**/*.rb"].each {|file| require file}

# Load database schema
load File.dirname(__FILE__) + "/schema.rb"

# Restore default configuration
RSpec.configure do |config|
  config.expect_with :rspec do |config|
    config.syntax = :expect
  end
  config.mock_with :rspec
  config.around do
    Dir[Rails.root.join("public/javascripts/*.js")].each {|file| File.unlink(file)}
    Dir[Rails.root.join("public/stylesheets/*.css")].each {|file| File.unlink(file)}
  end
end
