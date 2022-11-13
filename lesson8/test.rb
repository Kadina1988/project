# frozen_string_literal: true

require_relative 'station'
class Test
  attr_reader :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def seed
    mah = Station.new('mah')
    mos = Station.new('mos')
    spb = Station.new('spb')
    # ast = Station.new('ast')
    # kiz = Station.new('kiz')
    @stations << mah << mos << spb

    @routes << Rout.new(mah, mos)
    @routes << Rout.new(mos, spb)
    # @routes << Rout.new(ast, spb)

    cargo_train = CargoTrain.new('122-33', 'cargo')
    # cargo_train1 = CargoTrain.new('333-44', 'cargo')
    pass_train = PassTrain.new('124-55', 'passenger')
    # pass_train1 = PassTrain.new('887-22', 'passenger')
    @trains << cargo_train << pass_train

    cargo_wagon = CargoWagon.new('r34-23', 50)
    # cargo_wagon1 = CargoWagon.new('421-55', 50)
    pass_wagon = PassWagon.new('984-00', 45)
    pass_wagon1 = PassWagon.new('345-aa', 59)
    @wagons << cargo_wagon << pass_wagon1 << pass_wagon

    @trains[0].rout << @routes[0]
    @trains[1].rout << @routes[1]

    @routes[0].stations[0].all_trains << @trains[0]
    @routes[1].stations[0].all_trains << @trains[1]

    @trains[0].wagons << @wagons[0]
    @trains[1].wagons << @wagons[1] << @wagons[2]
  end

  def trains_on_stations
    @stations.each do |station|
      station.show_trains do |train|
        puts "#{station.name}: Train №- #{train.number}; Train type- #{train.type}; number of wagons- #{train.wagons.size}"
      end
    end
  end

  def list_of_train_cars
    @trains.each do |train|
      train.show_wagons do |wagon|
        if wagon.type == 'passenger'
          puts "Train № #{train.number} : Wagon №- #{wagon.number};Wagon type- #{wagon.type}; Free seats- #{wagon.free_seats}; Busy seats- #{wagon.busy_seats}"
        end
        if wagon.type == 'cargo'
          puts "Train № #{train.number}: Wagon №- #{wagon.number};Wagon type- #{wagon.type}; Free volume- #{wagon.free_volume}; Busy volume- #{wagon.busy_volume}"
        end
      end
    end
  end
end
