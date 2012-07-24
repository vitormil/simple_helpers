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

    def self.create_method(controller, name)
      controller.class_eval do
        define_method(name) do |*args|
          if args.empty?
            send "#{name}_get"
          else
            options = args.extract_options!
            send "#{name}_set", args.first, options
          end
        end

        define_method("#{name}_options") do
          instance_variable_set("@#{name}_options", {}) unless instance_variable_get("@#{name}_options")
          instance_variable_get("@#{name}_options")
        end

        define_method("#{name}_set") do |*args|
          instance_variable_set "@#{name}", args.first
          instance_variable_set "@#{name}_options", args.last
        end

        define_method("#{name}_get") do |*args|
          scopes      = SimpleHelpers::Support.scopes(controller, name)

          value       = instance_variable_get("@#{name}")
          options     = send("#{name}_options")

          result      = value % options unless value.nil?

          # removing rails reserved word
          helper_options = options.delete_if{|k,v| k.to_sym == :scope}

          result ||= t(scopes[:first], helper_options)
          if result.include? "translation missing" and scopes.has_key? :second
            helper_options.merge! :default => result
            result = t(scopes[:second], helper_options)
          end

          result
        end
      end
    end
  end
end
