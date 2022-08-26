class CargoTrain < Train
  attr_reader :type
  def initialize(type)
    super
    @type = 'cargo'
  end

  def add_wagon(wagon)
    if wagon.type == 'cargo' && parking
      @wagons << wagon
    end
  end
end
