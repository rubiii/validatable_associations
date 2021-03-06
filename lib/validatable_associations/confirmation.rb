module ValidatableAssociations
  module Confirmation

    private

      # Returns whether a given +method_name+ matches a confirmation.
      def confirmation?(method_name)
        if method_name[-13, 13] == "_confirmation"
          method = method_name.dup
          method.slice! -13, 13
        else
          method = method_name
        end

      	self.public_methods.include? method
      end

      # Handles a call to a confirmation.
      def handle_confirmation(confirmation, argument)
        return self.instance_variable_get "@#{confirmation}" unless argument
        
        if self.public_methods.include? "#{confirmation}="
          self.send "#{confirmation}=", argument
        else
          self.instance_variable_set "@#{confirmation}", argument
        end
        argument
      end

  end
end
