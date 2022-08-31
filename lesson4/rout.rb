class Rout
  attr_reader :stations, :start, :finish

  def initialize(start, finish)

    @start = start
    @finish = finish
    @stations = [start, finish]
    #@name = "#{start.name}, #{finish.name}"
  end

  def add_station(station)
    @stations << station
  end

  def del_station(name)
    @stations.delete(name)
  end

  def list_station
    self.all_rout
    @stations.each {|station| puts station}
  end
end
