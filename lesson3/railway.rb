class Station
  attr_reader :all_trains, :pass_tains, :cargo_trains
  def initialize(name)
    @name = name
    @all_trains = []
    @pass_tains = []
    @cargo_trains = []
  end
  def add_trains(train, type)
    @all_trains << train
    if type == 'pass'
      @pass_tains << train
    elsif type == 'cargo'
      @cargo_trains << train
    end
  end
  def departure(train)
    unless @all_trains.include?(train)
      raise 'Такой поезд отсутствует'
    end
    @all_trains.delete(train)
    if @pass_tains.include?(train)
      @pass_tains.delete(train)
    else
      @cargo_trains.delete(train)
    end
  end
end

class Rout
  attr_reader :stations
  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = []
  end
  def add_station(station)
    @stations << station
  end
  def del_station(name)
    @stations.delete(name)
  end
  def all_rout
    @stations.unshift(@start)
    @stations << @finish
  end
  def list_station
    @stations.each {|station| puts station}
  end
end
class Train
  attr_reader :speed, :wagons, :rout
  def initialize(number, type, wagons = 0)
    @number = number.to_i
    @type = type
    @wagons = 0
  end
  def accelerate=(speed)
    @speed = speed
  end
  def break=(speed)
    if speed < 0
      raise
    end
    @speed = speed
  end
  def add_wagons
    if @speed == 0
      @wagons += 1
    else
      puts "Надо остановится"
    end
  end
  def del_wagons
    if @speed == 0
      @wagons -= 1
    else
      puts "Надо остановится"
    end
  end
  def add_rout(rout) #вызов : Объект класса Rout.stations
    @rout = rout
    @station_idx = 0
    puts " Поезд № #{@number} находится на станции #{@rout[@station_idx]}"
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
end
