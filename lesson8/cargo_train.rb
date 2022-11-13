# frozen_string_literal: true

class CargoTrain < Train
  attr_reader :type, :number

  @quantiti = 0

  def initialize(number)
    super
    @type = 'cargo'
  end

  def add_wagon(wagon)
    @wagons << wagon if wagon.type == 'cargo' && parking
  end
end
