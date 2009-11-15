class ValidatableClass
  include Validatable
  include ValidatableAssociations

  attr_accessor :id, :name
  attr_reader :desc

  def desc=(desc)
    @desc = desc.upcase
  end

end
