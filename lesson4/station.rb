class Station
  attr_reader :all_trains, :pass_trains, :cargo_trains, :name
  def initialize(name)
    @name = name
    @all_trains = []
    @pass_trains = []
    @cargo_trains = []
  end

  def add_trains(train)
    @all_trains << train
    if train.type == 'passenger'
      @pass_trains << train
    elsif train.type == 'cargo'
      @cargo_trains << train
    end
  end

  def departure(train)
    unless @all_trains.include?(train)
      raise 'Такой поезд отсутствует'
    end
    @all_trains.delete(train)
    if @pass_trains.include?(train)
      @pass_trains.delete(train)
    else
      @cargo_trains.delete(train)
    end
  end
end
