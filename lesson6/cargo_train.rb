class CargoTrain < Train
  attr_reader :type, :number

  @quantiti = 0

  def initialize(number, type)
    super
    @number = number
    @type = type
  end

  def add_wagon(wagon)
    if wagon.type == 'cargo' && parking
      @wagons << wagon
    end
  end
end
