module_folder = File.join File.dirname(__FILE__), 'validatable_associations'
%w(mass_assignment association confirmation has_one).each do |module_file|
  require File.join module_folder, module_file
end

require 'rubygems'
require 'active_support'

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
    base.extend ClassMethods
  end

  # Catches calls to undefined methods. Checks if the +method+ called matches
  # an association or a method for validates_confirmation_of. Delegates to super
  # otherwise.
  def method_missing(method, *args)
    method_name = clean_method_name method

    if association? method_name
      handle_association method_name, args[0]
    elsif confirmation? method_name
      handle_confirmation method_name, args[0]
    else
      super
    end
  rescue NameError
    super
  end

private

  # Removes the writer attribute ("=") from a given +method+.
  def clean_method_name(method)
    name = method.to_s
    name.slice! -1 if name[-1, 1] == "="
    name
  end

end
