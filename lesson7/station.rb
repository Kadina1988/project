class Station
  include InstanceCounter
  attr_reader :all_trains, :pass_trains, :cargo_trains, :name
  FORMAT = /^\w{1,8}$/
  @@all = []
  @quantiti = 0

  def initialize(name)
    @name = name
    validate!
    @all_trains = []
    @pass_trains = []
    @cargo_trains = []
    @@all << self
    register_instance
  end

  def self.all
    @@all
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

  def valid?
    validate!
  rescue
    false
  end

  def show_trains
    if block_given?
      @all_trains.each {|train| yield (train)}
    else
      puts 'Нужен блок'
    end
  end

  private

  def validate!
    raise 'name is not validate' if name !~ FORMAT
    true
  end
end
