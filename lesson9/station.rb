# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'accessors.rb'
require_relative 'validation.rb'

class Station
  extend Accessors
  include InstanceCounter
  include Validation

   FORMAT = /^\w{1,8}$/.freeze

   @@all = []

   @quantiti = 0

  validate :name, :presence
  validate :name, :format, FORMAT
  validate :attribute_class, :type, "Station"
  attr_accessor_with_history :f, :s, :w
  attr_reader :all_trains, :pass_trains, :cargo_trains, :name

  def initialize(name)
    @name = name.capitalize
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

  def show_trains(&block)
    if block_given?
      @all_trains.each(&block)
    else
      puts 'Нужен блок'
    end
  end
end
