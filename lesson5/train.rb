class Train
  include NameCompany
  include InstanceCounter

  attr_reader :speed, :rout, :parking_brake, :wagons, :number

  @@all = []

  def initialize(number, type)
    @number = number
    @speed = 0
    @parking_brake = 'OFF'
    @wagons =[]
    @rout = []
    @@all.push(self)
    register_instance
  end

  def self.find(number)
    @@all.detect {|train| train.number == number}
  end


  def accelerate=(speed)
    @parking_brake = 'OFF'
    @speed = speed
  end

  def slow_down=(speed)
    if @speed < 0
      raise
    end
    @speed = speed
  end

  def info
    info!
  end

  def parking
    parking!
  end

  def forward
    go
  end

  def backward
   back
  end

  def add_rout(rout) #вызов : Объект класса Rout.stations
    @rout = rout
    @station_idx = 0
    puts " Поезд № #{@number} находится на станции #{@rout[@station_idx]}"
 end

  def previous_station
    if @station_idx != 0
      @rout[@station_idx - 1]
    end
  end

  def current_station
    @rout[@station_idx]
  end

  def next_station
    @rout[@station_idx + 1]
  end

  private                                  # Данные методы внесены в Privat для облегчения восприятия кода

  def parking!
    @parking_brake = 'ON'
    @speed = 0
  end

  def go
    @station_idx += 1
    if @station_idx + 1 == @rout.length
      puts "Конечная #{@rout[@station_idx]}"
    elsif
      puts "Поезд прибыл на станцию #{@rout[@station_idx]}"
    end
  end

  def back
    @station_idx -= 1
    unless @station_idx < 0
    puts "Поезд прибыл на станцию #{@rout[@station_idx]}"
    end
  end

  def info!
    puts type
    puts "Количество вагонов: #{@wagons.length}"
    puts " Маршрут : #{@rout}"
  end
end
