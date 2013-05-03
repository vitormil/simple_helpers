module SimpleHelpers
  class Support
    def self.certified_array!(splat_arg)
      array = splat_arg.first.is_a?(Array) ? splat_arg.first : Array(splat_arg)
      array.collect{|item| item.to_s}
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
          "%{prefix}%{prefix_separator}%{content}%{suffix_separator}%{suffix}" %
            SimpleHelpers::Support.simple_helper_parts(controller, name)
        end
      end
    end

  private

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

    def self.replace_tags(controller, context)
      tags(context).each do |tag|
        begin
          value = simple_helper_value(controller, tag)
        ensure
          context.sub!(tag, value)
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

    def self.get_text_from_locale(controller, key, options)
      scopes  = SimpleHelpers::Support.scopes(controller, key)

      result = SimpleHelpers::Support.translate(scopes[:first], options)
      if result.empty?
        result = SimpleHelpers::Support.translate(scopes[:second], options)
      end
      result
    end

    def self.tags(context)
      context.scan(/{{.*?}}/i)
    end

    def self.simple_helper_value(controller, key)
      tag = key.delete("{}")
      if tag.start_with? "@"
        get_from_instance_variable(controller, tag)
      else
        get_from_controller(controller, tag)
      end || ""
    end

    def self.get_from_instance_variable(controller, key)
      parts             = key.split(".")
      first_argument    = parts.shift
      instance_variable = controller.instance_variable_get(first_argument)

      if parts.empty?
        instance_variable
      else
        thing = parts.shift.to_sym
        instance_variable[thing] if instance_variable.respond_to?(thing)
      end
    end

    def self.get_from_controller(controller, key)
      controller.send key
    end

    def self.simple_helper_parts(controller, name)
      name_options   = controller.instance_variable_get("@#{name}_options") || {}
      text_raw       = SimpleHelpers::Support.get_text_from_locale(controller, name, name_options)
      content        = SimpleHelpers::Support.replace_tags(controller, text_raw)

      helper_options = SimpleHelpers::Config.helpers[name.to_sym].merge(name_options)
      prefix         = helper_options.fetch(:prefix, "")
      suffix         = helper_options.fetch(:suffix, "")
      separator      = helper_options.fetch(:separator, SimpleHelpers::Config::DEFAULT_SEPARATOR)

      {
        prefix: prefix,
        suffix: suffix,
        separator: separator,
        content: content,
        prefix_separator: prefix.empty? || content.empty? ? "" : separator,
        suffix_separator: suffix.empty? || content.empty? ? "" : separator
      }
    end

  end

end
