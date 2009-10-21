# == ValidatableAssociations
# 
# ValidatableAssociations is an add-on to the Validatable gem by Jay Fields.
# It adds the most common association methods provided by Rails to your
# validatable Class and allows to set up a decent validatable structure.
module ValidatableAssociations

  # ValidatableAssociations::ClassMethods
  #
  # Includes class methods for setting up the associations.
  module ClassMethods

    # Reader/writer method for has_one associations. Sets 1-n +associations+
    # or defaults to return all previously specified associations if no
    # parameters were given.
    def has_one(*associations)
      @has_one = [] unless @has_one
      return @has_one if associations.empty?
      @has_one = associations.map { |association| association.to_s }
    end

  end

  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end

  # The initialize method handles mass-assignment of a given Hash of
  # +attributes+ to their instance variables.
  def initialize(attributes = {})
    return if !attributes || attributes.empty?
    attributes.each { |ivar, value| assign_to(ivar, value) }
  end

  # Catches calls to undefined methods. Checks if the +method+ called matches
  # a reader/writer method of an association and handles the read/write process.
  # Delegates to super otherwise.
  def method_missing(method, *args)
    association_name = to_association_name(method)
    super unless self.class.has_one.include? association_name

    association_to_set = find_or_create_association(association_name, args[0])
    self.instance_variable_set("@#{association_name}", association_to_set)
    association_to_set
  rescue NameError
    super
  end

  # Returns whether the validations of this model and all associated models
  # passed successfully.
  def valid?
    validate_associations
    super && associations_valid?
  end

private

  # Assigns a given +value+ to a given +ivar+. Tries to use the writer method
  # for the given instance variable and defaults to setting it directly in case
  # no writer method was found.
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
    self.methods.include?("#{ivar}=") || self.class.has_one.include?(ivar)
  end

  # Takes an +association_name+ and returns an existing association matching
  # the given name. Instantiates a new association in case it hasn't been
  # initialized already or in case of given +arguments+.
  def find_or_create_association(association_name, arguments = nil)
    if arguments
      to_constant(association_name).new arguments
    else
      association = self.instance_variable_get("@#{association_name}")
      association = to_constant(association_name).new unless association
      association
    end
  end

  # Validates all models associated with this model and stores the results.
  def validate_associations
    @association_validity = self.class.has_one.map do |association|
      self.send(association).valid?
    end
  end

  # Returns whether the validations of all models associated with this model
  # passed successfully.
  def associations_valid?
    !@association_validity.include?(false)
  end

  # Expects the name of a reader/writer +method+ and turns it into a valid
  # name for an association.
  def to_association_name(method)
    association_name = method.to_s
    association_name.slice!(-1) if association_name[-1, 1] == "="
    association_name
  end

  # Converts a given +symbol+ from snake_case into an existing Constant.
  # Note that the constanize method might raise a NameError in case the given
  # symbol could not be mapped to a Constant.
  def to_constant(symbol)
    symbol.to_s.camelize.constantize
  end

end

