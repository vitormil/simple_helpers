module SimpleHelpers
  module ActionController
    def simple_helper(*name_or_array_of_names)
      main_options   = name_or_array_of_names.extract_options!
      array_of_names = SimpleHelpers::Support.certified_array!(name_or_array_of_names)

      SimpleHelpers::Support.log "Defining methods #{array_of_names.inspect} to #{self.class.inspect}"

      array_of_names.each do |name_symbol|
        name = name_symbol.underscore

        # define_methods
        SimpleHelpers::Support.create_method(self, name)

        # method helper
        ::ActionController::Base.helper_method name.to_s

        # initialize
        instance_variable_set "@#{name}_options", Hash[main_options] unless main_options.empty?
      end
    end
  end
end
