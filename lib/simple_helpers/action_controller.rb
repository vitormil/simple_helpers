module SimpleHelpers
  module ActionController
    def simple_helper(*name_or_array_of_names)
      main_options   = name_or_array_of_names.extract_options!
      array_of_names = SimpleHelpers::Support.certified_array!(name_or_array_of_names)

      SimpleHelpers::Support.log "Defining methods #{array_of_names.inspect} to #{self.class.inspect}"

      array_of_names.each do |name_symbol|
        name = name_symbol.underscore

        self.class_eval do
          define_method(name) do |*args|
            if args.empty?
              send "#{name}_get"
            else
              options = args.extract_options!
              send "#{name}_set", args.first, options
            end
          end

          define_method("#{name}_options") do
            options = instance_variable_get "@#{name}_options"
            options ||= {}
          end

          define_method("#{name}_set") do |*args|
            instance_variable_set "@#{name}", args.first
            instance_variable_set "@#{name}_options", args.last
          end

          define_method("#{name}_get") do |*args|
            scopes      = SimpleHelpers::Support.scopes(self, name)

            value       = instance_variable_get("@#{name}")
            options     = send("#{name}_options")

            result      = value % options unless value.nil?

            # TODO: refactor
            new_options = options.delete_if{|k,v| k.to_sym == :scope}

            result ||= t(scopes[:first], new_options)
            if result.include? "translation missing" and scopes.has_key? :second
              new_options.merge! :default => result
              result = t(scopes[:second], new_options)
            end

            result
          end
        end

        # method helper
        ::ActionController::Base.helper_method name.to_s

        # initialize
        instance_variable_set "@#{name}_options", Hash[main_options] unless main_options.empty?
      end
    end
  end
end
