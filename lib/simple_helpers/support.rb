module SimpleHelpers
  class Support
    def self.certified_array!(splat_arg)
      array = splat_arg.first.is_a?(Array) ? splat_arg.first : Array(splat_arg)
      array.collect{|item| item.to_s}
    end

    def self.scopes(controller, method_name)
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

      {
        :first => "#{group}.#{controller_name}.#{action_name.to_s}",
        :second => "#{group}.simple_helper_default"
      }
    end

    def self.template(controller, context)
      context.scan(/{{.*?}}/i).each do |key|
        parts  = key.delete("{}").split(".")

        begin
          first_argument = parts.shift
          if first_argument.start_with? "@"
            instance_variable = controller.instance_variable_get(first_argument)

            value = if parts.empty?
                      instance_variable
                    else
                      thing = parts.shift.to_sym
                      instance_variable[thing] if instance_variable.respond_to?(thing)
                    end
          else
            value = controller.send first_argument
          end
          value = "" unless value
        rescue
          value = ""
        ensure
          context.sub!(key, value)
        end
      end
      context
    end

    def self.translate(scope, options)
      begin
        _options = options || {}
        I18n.translate!(scope, _options.merge({raise: true}))
      rescue I18n::MissingTranslationData
        ""
      end
    end

    def self.get_content(scopes, options)
      result = SimpleHelpers::Support.translate(scopes[:first], options)
      if result.empty?
        result = SimpleHelpers::Support.translate(scopes[:second], options)
      end
      result
    end

    def self.create_method(controller, name)
      controller.class_eval do
        define_method(name) do |*args|
          if args.empty?
            send "#{name}_get"
          else
            send "#{name}_set", args.first
          end
        end

        define_method("#{name}_set") do |*args|
          instance_variable_set "@#{name}", args.first
        end

        define_method("#{name}_get") do |*args|
          scopes         = SimpleHelpers::Support.scopes(controller, name)
          options_hash   = instance_variable_get("@#{name}_options")
          result         = SimpleHelpers::Support.get_content(scopes, options_hash)
          helper_options = SimpleHelpers::Config.helpers[name.to_sym]

          prefix    = helper_options.fetch(:prefix, "")
          content   = SimpleHelpers::Support.template(controller, result)
          separator = if prefix.empty? || content.empty?
                        ""
                      else
                        helper_options.fetch(:separator, " - ")
                      end

          "#{prefix}#{separator}#{content}"
        end
      end
    end

  end
end
