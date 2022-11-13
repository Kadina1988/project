# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'name_company'
require_relative 'format'

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
    @stations.each { |station| puts station }
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  private

  def validate!
    raise 'no validate' if @stations.size < 2

    true
  end
end
