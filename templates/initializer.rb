# Use this file to setup SimpleHelpers.
require "simple_helpers"

SimpleHelpers.configure do |config|
  # Helper methods that will be automatically
  # created in the controllers
  # config.helpers   = [:page_title]

  # config.helpers will NOT be created automatically in these controllers
  # *** keep it empty if you would allow all controlers
  # example: [SessionsController]
  # config.except = []

  # config.helpers will be created automatically in these controllers
  # *** keep it empty if you would allow all controlers
  # example: [PostsController]
  # config.only = []

  # Options:
  # :pluralize => I18n pluralized helper names
  # [ :log, :pluralize ]
  # config.options = [ :log ]
end
