class PassTrain < Train
  attr_reader :type, :number
  def initialize(number, type)
    super
    @number = number
    @type = type
    #@type = 'passenger'
  end

  def add_wagon(wagon)
    if wagon.type == 'passenger' && parking
      @wagons << wagon
    end
  end
end
