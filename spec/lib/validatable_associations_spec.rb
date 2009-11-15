require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ValidatableAssociations do
  before { clear_associations! }

  describe 'has_one' do
    it 'should hold an Array of has_one associations' do
      ValidatableClass.has_one.should be_an Array
    end

    it 'should initialy be empty' do
      ValidatableClass.has_one.should be_empty
    end

    it 'should serve as an atribute accessor to an Array' do
      ValidatableClass.has_one :gorilla
      ValidatableClass.has_one.should include 'gorilla'

      ValidatableClass.has_one :apricot, :unicorn
      ValidatableClass.has_one.should include 'gorilla', 'apricot', 'unicorn'
    end

    it 'should convert Symbols to Strings' do
      ValidatableClass.has_one :gorilla
      ValidatableClass.has_one.should include 'gorilla'
    end
  end

  describe 'initialize' do
    it 'handles mass-assignment to attributes' do
      validatableClass = ValidatableClass.new :id => 13, :name => 'bart'
      validatableClass.id.should == 13
      validatableClass.name.should == 'bart'
    end

    it 'uses any available attribute accesor methods' do
      validatableClass = ValidatableClass.new :id => 27, :desc => 'a yellow guy'
      validatableClass.id.should == 27
      validatableClass.desc.should == 'A YELLOW GUY'
    end
  end

  describe 'magic handled via method missing' do
    before do
      ValidatableClass.has_one :validatable_association
      @validatableClass = ValidatableClass.new
    end

    it 'still raises a NoMethodError in case of an invalid call' do
      lambda { @validatableClass.whatever }.should raise_error NoMethodError
    end
    
    it 'returns an instance of an associated Class' do
      p ValidatableClass.has_one
      p @validatableClass.validatable_association
    end
  end

  # Clears all associations on the +ValidatableClass+.
  def clear_associations!
    ValidatableClass.class_eval "@has_one = []"
  end

end
