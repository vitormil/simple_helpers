module SimpleHelpers
  class Support

    def self.log(message)
      Rails.logger.debug "SimpleHelpers => #{message}" if SimpleHelpers::Config.has_option? :log
    end

    def self.certified_array!(splat_arg)
      array = splat_arg.first.is_a?(Array) ? splat_arg.first : Array(splat_arg)
      array.collect{|item| item.to_s}
    end

    def self.scopes(controller, method_name)
      options = controller.send "#{method_name}_options"
      return {:first => options[:scope]} if options.has_key? :scope

      controller_name = controller.class.name.underscore
      controller_name.gsub!(/\//, "_")
      controller_name.gsub!(/_controller$/, "")

      action_name = controller.action_name
      action_name = SimpleHelpers::Helpers::ACTION_ALIASES.fetch(action_name, action_name)
      if controller.class.constants.include? :SIMPLE_HELPER_ALIASES
        simple_helper_aliases = controller.class.const_get :SIMPLE_HELPER_ALIASES
        action_name = simple_helper_aliases.fetch(action_name, action_name) if simple_helper_aliases.is_a? Hash
      end
      group = method_name
      group = group.pluralize if options.has_key? :pluralize

      {
        :first => "#{group}.#{controller_name}.#{action_name.to_s}",
        :second => "#{group}.simple_helper_default"
      }
    end

  end
end
