class CargoWagon
  include InstanceCounter
  include NameCompany
  include Format
  attr_reader :type, :number, :free_volume, :busy_volume

  @quantiti = 0

  def initialize(number, cargo_volume)
    @number = number
    @type = 'cargo'
    @cargo_volume = cargo_volume
    @free_volume = cargo_volume
    @busy_volume = 0
    register_instance
    validate!
  end

  def download_wagon(volume)
    if  volume > @free_volume
      raise 'Столько места нет'
    else
      @busy_volume += volume
      @free_volume = @cargo_volume - @busy_volume
    end
    rescue => e
      puts e
  end
end
