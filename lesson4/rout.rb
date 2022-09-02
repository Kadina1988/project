class Rout
  attr_reader :stations, :start, :finish
  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
  end

  def add_station(station)
    @stations << station
  end

  def del_station(name)
    @stations.delete(name)
  end

  def list_station
    @stations.each {|station| puts station}
  end
end
