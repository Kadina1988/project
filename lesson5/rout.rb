class Rout
  include InstanceCounter
  attr_reader :stations, :start, :finish

  @quantiti = 0

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    register_instance
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
