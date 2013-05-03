module SimpleHelpers
  class Config
    DEFAULT_SEPARATOR = " · "

    def self.helpers
      @helpers ||= {}
    end

    def self.helpers=(helper_methods)
      @helpers = helper_methods
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
