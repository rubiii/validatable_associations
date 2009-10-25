module ValidatableAssociations
  module Association

      # Returns whether the validations of this model and all associated models
      # passed successfully.
      def valid?
        validate_associations
        super && associations_valid?
      end

    private

      # Validates all models associated with this model and stores the results.
      def validate_associations
        @association_validity = self.class.has_one.map do |association|
          self.send(association).valid?
        end
      end

      # Returns whether the validations of all models associated with this model
      # passed successfully.
      def associations_valid?
        !@association_validity.include? false
      end

      # Returns whether a given +method_name+ matches an association.
      def association?(method_name)
        self.class.has_one.include? method_name
      end

      # Handles a call to an association.
      def handle_association(association_name, argument)
        association_to_set = find_or_create_association(association_name, argument)
        self.instance_variable_set("@#{association_name}", association_to_set)
        association_to_set
      end

      # Takes an +association_name+ and returns an existing association matching
      # the given name. Instantiates a new association in case it hasn't been
      # initialized already or in case of given +arguments+.
      def find_or_create_association(association_name, arguments = nil)
        if arguments
          constant_from(association_name).new arguments
        else
          association = self.instance_variable_get("@#{association_name}")
          association = constant_from(association_name).new unless association
          association
        end
      end

      # Converts a given +symbol+ from snake_case into an existing Constant.
      # Note that the constanize method might raise a NameError in case the given
      # symbol could not be mapped to a Constant.
      def constant_from(symbol)
        symbol.to_s.camelize.constantize
      end

  end
end
