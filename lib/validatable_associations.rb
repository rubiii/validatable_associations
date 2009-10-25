# == ValidatableAssociations
#
# ValidatableAssociations is a Rails plugin and add-on to Jay Fields Validatable
# library. This add-on lets you specify associations to other validatable Classes
# and allows you to set up a decent validatable structure.
module ValidatableAssociations
  include MassAssignment
  include Association
  include Confirmation

  # ValidatableAssociations::ClassMethods
  #
  # Includes Class methods from associations.
  module ClassMethods
    include ValidatableAssociations::HasOne::ClassMethods
  end

  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end

  # Catches calls to undefined methods. Checks if the +method+ called matches
  # a reader/writer method of an association and handles the read/write process.
  # Delegates to super otherwise.
  def method_missing(method, *args)
    method = clean_method_name(method)

    if association? method
      handle_association(method, args[0])
    elsif confirmation? method
      handle_confirmation(method, args[0])
    else
      super
    end
  rescue NameError
    super
  end

private

  # Expects the name of a reader/writer +method+ and turns it into a valid
  # name for an association.
  def clean_method_name(method)
    name = method.to_s
    name.slice! -1 if name[-1, 1] == "="
    name
  end

end
