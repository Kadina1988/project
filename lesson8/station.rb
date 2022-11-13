# frozen_string_literal: true

require_relative 'instance_counter'

class Station
  include InstanceCounter
  attr_reader :all_trains, :pass_trains, :cargo_trains, :name

  FORMAT = /^\w{1,8}$/.freeze
  @@all = []
  @quantiti = 0

  def initialize(name)
    @name = name.capitalize
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
    case train.type
    when 'passenger'
      @pass_trains << train
    when 'cargo'
      @cargo_trains << train
    end
  end

  def departure(train)
    puts 'Такой поезд отсутствует' unless @all_trains.include?(train)
    @all_trains.delete(train)
    if @pass_trains.include?(train)
      @pass_trains.delete(train)
    else
      @cargo_trains.delete(train)
    end
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def show_trains(&block)
    if block_given?
      @all_trains.each(&block)
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
