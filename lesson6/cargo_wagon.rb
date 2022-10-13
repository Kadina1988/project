class CargoWagon
  include InstanceCounter
  include NameCompany
  include Format
  attr_reader :type, :number

  @quantiti = 0

  def initialize(number, type)
    @number = number
    @type = type
    register_instance
    validate!
  end
end
