module SimpleHelpers
  class Config

    VALID_OPTIONS = [:log]

    def self.whitelist
      @whitelist ||= []
    end

    def self.whitelist=(*allowed)
      @whitelist = SimpleHelpers::Support.certified_array!(allowed)
    end

    def self.blacklist
      @blacklist ||= []
    end

    def self.blacklist=(*not_allowed)
      @blacklist = SimpleHelpers::Support.certified_array!(not_allowed)
    end

    def self.helpers
      @helpers ||= []
    end

    def self.helpers=(*helper_methods)
      @helpers = SimpleHelpers::Support.certified_array!(helper_methods)
    end

    def self.allowed_controller?(controller)
      ( @whitelist.empty? and @blacklist.empty? ) or
      ( not @whitelist.empty? and @whitelist.include?(controller) ) or
      ( not @blacklist.empty? and not @blacklist.include?(controller) )
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
