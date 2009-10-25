module ValidatableAssociations
  module MassAssignment

    # The initialize method handles mass-assignment of a given Hash of
    # +attributes+ to their corresponding instance variables.
    def initialize(attributes = {})
      return if !attributes || attributes.empty?
      attributes.each { |ivar, value| assign_to(ivar, value) }
    end

  private

    # Assigns a given +value+ to a given +ivar+. Tries to use the writer method
    # for the given instance variable and falls back on setting it directly in
    # case no writer method was found.
    def assign_to(ivar, value)
      if assign_via_writer? ivar
        self.send("#{ivar}=", value)
      else
        self.instance_variable_set("@#{ivar}", value)
      end
    end

    # Checks whether a given +ivar+ should be assigned via an existing writer
    # method or directly.
    def assign_via_writer?(ivar)
      self.methods.include?("#{ivar}=") || association?(ivar)
    end

  end
end
