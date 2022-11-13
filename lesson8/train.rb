# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'name_company'
require_relative 'format'

class Train
  include NameCompany
  include InstanceCounter
  include Format

  attr_reader :speed, :rout, :parking_brake, :wagons, :number

  @@all = []

  def self.find(number)
    @@all.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    @speed = 0
    @parking_brake = 'OFF'
    @wagons = []
    @rout = []
    @@all.push(self)
    validate!
    register_instance
  end

  def accelerate=(speed)
    @parking_brake = 'OFF'
    @speed = speed
  end

  def slow_down=(speed)
    raise 'no correct' if @speed.negative?

    @speed = speed
  rescue StandardError => e
    puts e
    retry
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

  # вызов : Объект класса Rout.stations
  def add_rout(rout)
    @rout = rout
    @station_idx = 0
    puts " Поезд № #{@number} находится на станции #{@rout[@station_idx]}"
  end

  def previous_station
    @rout[@station_idx - 1] if @station_idx != 0
  end

  def current_station
    @rout[@station_idx]
  end

  def next_station
    @rout[@station_idx + 1]
  end

  def show_wagons(&block)
    if block_given?
      @wagons.each(&block)
    else
      puts 'need block'
    end
  end

  private                                  # Данные методы внесены в Privat для облегчения восприятия кода

  def parking!
    @parking_brake = 'ON'
    @speed = 0
  end

  def go
    @station_idx += 1
    puts "Конечная #{@rout[@station_idx]}" if @station_idx + 1 == @rout.size
  end

  def back
    @station_idx -= 1
    puts "Поезд прибыл на станцию #{@rout[@station_idx]}" unless @station_idx.negative?
  end

  def info!
    puts type
    puts "Количество вагонов: #{@wagons.size}"
    puts " Маршрут : #{@rout}"
  end
end
