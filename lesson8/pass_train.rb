# frozen_string_literal: true

class PassTrain < Train
  attr_reader :type, :number

  @quantiti = 0

  def initialize(number)
    super
    @type = 'passenger'
  end

  def add_wagon(wagon)
    @wagons << wagon if wagon.type == 'passenger' && parking
  end
end
