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
    self.all_rout
    @stations.each {|station| puts station}
  end
end
