class ValidatableAssociation
  include Validatable
  include ValidatableAssociations::MassAssignment

  attr_accessor :id, :status

end
