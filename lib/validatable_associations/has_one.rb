module ValidatableAssociations
  module HasOne

	  module ClassMethods

		  # Reader/writer method for has_one associations. Sets 1-n +associations+
		  # or defaults to return all previously specified associations if no
		  # parameters were given.
		  def has_one(*associations)
		    @has_one = [] unless @has_one
		    return @has_one if associations.empty?
		    @has_one += associations.map { |association| association.to_s }
		  end

		end

  end
end
