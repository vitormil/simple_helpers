module SimpleHelpers
  class Config

    VALID_OPTIONS = [:log, :pluralize]

    def self.only
      @only ||= []
    end

    def self.only=(*allowed)
      @only = SimpleHelpers::Support.certified_array!(allowed)
    end

    def self.except
      @except ||= []
    end

    def self.except=(*not_allowed)
      @except = SimpleHelpers::Support.certified_array!(not_allowed)
    end

    def self.helpers
      @helpers ||= []
    end

    def self.helpers=(*helper_methods)
      @helpers = SimpleHelpers::Support.certified_array!(helper_methods)
    end

    def self.allowed_controller?(controller)
      ( @only.empty? and @except.empty? ) or
      ( not @only.empty? and @only.include?(controller) ) or
      ( not @except.empty? and not @except.include?(controller) )
    end

    def self.options
      @options ||= []
    end

    def self.options=(*args)
      options_list = SimpleHelpers::Support.certified_array!(args)
      @options = options_list.collect{|c| c.to_sym }
    end

    def self.has_option?(option)
      @options.include?(option.to_sym)
    end

  end
end
