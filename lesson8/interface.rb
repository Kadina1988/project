class Interface
  attr_reader :choice, :trains, :routes, :wagons, :stations

  def initialize
    @stations = []
    @trains   = []
    @routes   = Rout.new(nil, nil)
    @wagons   = []
  end

  def start
    loop do
      menu
      @choice = met_choice
      break if choice.zero?

      process_choices
    end
  end

  def menu
    puts 'Menu:'
    puts '1.Создать станцию'
    puts '2.Создать  маршрут'
    puts '3.Добавить станцию'
    puts '4.Удалить станцию'
    puts '5.Создать поезд'
    puts '6.Создать вагон'
    puts '7.Прицепить вагон к поезду'
    puts '8.Назначиь маршрут поезду'
    puts '9.Отправить поезд на след. станцию'
    puts '10.Отправить поезд назад'
    puts '11.Отцепить вагон'
    puts '12.Посмотреть станции'
    puts '13.Загрузить вагон'
    puts '14.Просмотреть поезда на станциях'
    puts '15.Информация о составах'
    puts '0.exit'
  end

  def met_choice
    choice = gets.chomp.to_i
  end

  def process_choices
    case choice
    when 1 then  create_station
    when 2 then  create_rout
    when 3 then  add_station
    when 4 then  del_station
    when 5 then  create_train
    when 6 then  create_wagon
    when 7 then  add_wagon_train
    when 8 then  add_rout_train
    when 9 then  go
    when 10 then back
    when 11 then unhuk_wagon
    when 12 then info_stations
    when 13 then download_wagon
    when 14 then trains_on_stations
    when 15 then info_cars
    when 0 then  exit
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    @stations << Station.new(name) unless name == ''
    puts "Создана станция #{name}"
  rescue StandardError => e
    puts e
  end

  def create_rout
    create_station until @stations.size > 1
    list_station
    puts 'выбрать старт'
    stat = gets.to_i - 1
    puts 'Выбрать финиш'
    fin = gets.to_i - 1
    start = @stations[stat]
    finish = @stations[fin]
    @routes = Rout.new(start, finish) unless start.nil? || finish.nil? || finish == start
  end

  def add_station
    create_station until @stations.size >= 3
    puts 'Выберите Номер станции'
    list_station
    choice = gets.to_i
    station = @stations[choice - 1]
    puts 'Порядковый номер станции в маршруте' unless station.nil?
    point = gets.to_i - 1
    @routes.stations.insert(point, station) unless point <= 0 || point >= @stations.length || point == ''
  end

  def del_station
    puts 'Выбрать номер станции для удаления'
    @routes.stations.each.with_index { |station, index| puts "#{station.name}- #{index + 1}" }
    choice = gets.to_i - 1
    @routes.stations.delete_at(choice) unless choice <= 0 || choice == '' || choice > @routes.stations.length
  end

  def create_train
    puts 'Введите номер поезда'
    number = gets.chomp
    puts 'Тип поезда:'
    puts '1-passenger'
    puts '2-cargo'
    type = gets.to_i
    @trains << PassTrain.new(number) if type == 1
    @trains << CargoTrain.new(number) if type == 2
  rescue StandardError => e
    puts e
  end

  def create_wagon
    puts 'Номер:'
    number = gets.chomp
    puts 'Тип вагона:'
    puts '1-passenger'
    puts '2-cargo'
    type = gets.to_i
    case type
    when 1
      print 'Количество мест: '
      seats = gets.to_i
      @wagons << PassWagon.new(number, seats)
    when 2
      print 'Грузовой объем: '
      cargo_volume = gets.to_i
      @wagons << CargoWagon.new(number, cargo_volume)
    end
  rescue StandardError => e
    puts e
  end

  def add_wagon_train
    puts 'поезда из списка'
    list_trains
    puts 'Ввести номер поезда'
    train_number = gets.to_i
    choice_train = @trains[train_number - 1]
    puts 'Свободные вагоны'
    list_wagons
    wagon_number = gets.to_i
    choice_wagon = @wagons[wagon_number - 1]
    return unless (!!choice_train && !!choice_wagon) && (choice_train.type == choice_wagon.type)
    choice_train.wagons << choice_wagon
    @wagons.delete(choice_wagon)
  end

  def unhuk_wagon
    puts 'Поезда: '
    list_trains
    print 'Выбрать поезд: '
    train_number = gets.to_i
    choice_train = @trains[train_number - 1]
    @wagons << choice_train.wagons.last unless choice_train.nil?
    choice_train.wagons.pop
  end

  def add_rout_train
    return unless @trains.any? && @routes.stations.any?
    list_trains
    print 'choise train: '
    train_number = gets.to_i - 1
    return if @trains[train_number].nil? || @trains[train_number].rout.any?
    choice_train = @trains[train_number]
    @routes.stations.each { |station| choice_train.rout << station.name }
    @routes.stations[0].all_trains << choice_train
    @rout_inx = 0
    @trains_with_rout = @trains.find_all { |train| train.rout.any? }
  end

  def go
    any_rout
    puts 'Выбрать номер поезда'
    train_number = gets.to_i - 1
    choice_train = @trains_with_rout[train_number]
    last_station_trains = @routes.finish.all_trains
    return if choice_train.nil? || last_station_trains.include?(choice_train)
    @rout_inx += 1
    @routes.stations[@rout_inx].all_trains << @routes.stations[@rout_inx - 1].all_trains[train_number]
    @routes.stations[@rout_inx - 1].all_trains.delete_at(train_number)
  end

  def back
    any_rout
    puts 'Выбрать номер поезда'
    train_number = gets.to_i - 1
    choice_train = @trains_with_rout[train_number]
    return if choice_train.nil?
    @rout_inx -= 1
    @routes.stations[@rout_inx].all_trains << @routes.stations[@rout_inx + 1].all_trains[train_number]
    @routes.stations[@rout_inx + 1].all_trains.delete_at(train_number)
  end

  def info_stations
    list_station
    puts 'Choice Station'
    n_station = gets.to_i - 1
    station = @stations[n_station]
    return if station.nil?
    puts "#{station.name}: "
    station.all_trains.each { |train| puts "#{train.number}-#{train.type}" } if station.all_trains.any?
    puts "#{station.name} don't have trains" if station.all_trains.empty?
  end

  def trains_on_stations
    @stations.each do |station|
      if station.all_trains.any?
        station.show_trains do |train|
          puts "Station #{station.name}: Train №- #{train.number}; Train type- #{train.type}; number of wagons- #{train.wagons.size} "
        end
      else
        puts "На станции #{station.name} нет поездов"
      end
    end
  end

  def info_cars
    @trains.each do |train|
      puts "Train № #{train.number} :"
      train.show_wagons do |wagon|
        if wagon.type == 'passenger'
          puts " Wagon №- #{wagon.number}; Wagon type- #{wagon.type}; Free seats- #{wagon.free_seats}; Busy seats- #{wagon.busy_seats}  "
        end
        if wagon.type == 'cargo'
          puts " Wagon №- #{wagon.number}; Wagon type- #{wagon.type}; Free volume- #{wagon.free_volume}; Busy volume- #{wagon.busy_volume} "
        end
      end
    end
  end

  def download_wagon
    puts 'Выбрать состав'
    list_trains
    n_train = gets.to_i - 1
    train = @trains[n_train]
    return if train.nil? || train.wagons.empty?
    puts 'Выбрать вагон'
    train.wagons.each.with_index { |wagon, index| puts "#{index + 1}) № #{wagon.number}-#{wagon.type}" }
    ch_wagon = gets.to_i - 1
    wagon = train.wagons[ch_wagon]
    return if wagon.nil?
    case wagon.type
    when 'cargo'
      puts "Free volume: #{wagon.free_volume}"
      puts "Busy volume: #{wagon.busy_volume}"
      print 'Volume Cargo:'
      volume = gets.to_i
      wagon.download_wagon(volume)
    when 'passenger'
      wagon.take_a_seat
      puts "Free seats: #{wagon.free_seats}"
      puts "Busy seats: #{wagon.busy_seats}"
    end
  end

  private

  def list_station
    @stations.each.with_index { |station, index| puts "#{index + 1})  #{station.name} " }
  end

  def show_list_stations
    @routes.stations.each.with_index { |station, _index| puts "#{station.name}" }
  end

  def list_trains
    @trains.each.with_index { |train, index| puts "#{index + 1}) #{train.number}-#{train.type}" }
  end

  def list_wagons
    @wagons.each.with_index { |wagon, index| puts "#{index + 1}) #{wagon.number}-#{wagon.type}" }
  end

  def any_rout
    @trains_with_rout.each.with_index { |train, index| puts "#{index + 1}) #{train.number}" }
  end
end
