module SimpleHelpers
  module ActionController
    def simple_helper(helpers_array)
      helpers_array.each do |name|
        name = name.to_s.underscore

        # method
        SimpleHelpers::Support.create_method(self, name)

        # helper
        ::ActionController::Base.helper_method name
      end
    end
  end
end
