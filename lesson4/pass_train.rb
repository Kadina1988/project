class PassTrain < Train
  attr_reader :type
  def initialize(type)
    super
    @type = 'passenger'
  end

  def add_wagon(wagon)
    if wagon.type == 'passenger' && parking
      @wagons << wagon
    end
  end
end
