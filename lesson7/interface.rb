class Interface
  attr_reader :choice, :trains, :routes, :wagons, :stations
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def start
    loop do
      menu
      @choice = get_choice
      break if choice == 0
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

  def get_choice
    choice = gets.chomp.to_i
  end

  def process_choices
    case choice
    when 1
      create_station
    when 2
      create_rout
    when 3
      add_station
    when 4
      del_station
    when 5
      create_train
    when 6
      create_wagon
    when 7
      add_wagon_train
    when 8
      add_rout_train
    when 9
      go
    when 10
      back
    when 11
      unhuk_wagon
    when 12
      info_stations
    when 13
      download_wagon
    when 114
      trains_on_stations
    when 15
      info_cars

      when 0
        exit
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    if name != ""
      name = name.capitalize
      @stations << Station.new(name)
      puts "Создана станция #{name}"
    else
      raise 'Введите заново'
    end
    rescue StandardError => error
      puts error
    retry
  end

  def create_rout
    if @stations.length < 2
      puts 'Минимум 2 станции'
      create_station
    end
    list_station
    puts 'выбрать старт'
    stat = gets.to_i - 1
    puts 'Выбрать финиш'
    fin = gets.to_i - 1
    start = @stations[stat]
    finish = @stations[fin]
    if start.nil? || finish.nil? || finish == start
      raise 'Выбрать заново '
    else
      @routes = Rout.new(start, finish)
    end
    rescue StandardError => error
      puts error
    retry
  end

  def add_station
    if @stations.empty? || @stations.length < 3
      create_station
    else
      puts 'Выберите Номер станции'
      list_station
      choice = gets.to_i
      station = @stations[choice - 1]
      unless station.nil?
        puts 'Порядковый номер станции в маршруте'
        point = gets.to_i - 1
        if  point <= 0 || point >= @stations.length || point == ''
          raise 'Станция не может быть добавлена в данную точку'
        else
          @routes.stations.insert(point, station)
        end
      else
        raise 'Не существующая станция'
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def del_station
    puts 'Выбрать номер станции для удаления'
    @routes.stations.each.with_index do |station, index|
      puts "#{station.name}- #{index + 1}"
    end
    choice = gets.to_i - 1
    if choice <= 0 || choice == '' || choice > @routes.stations.length
      raise 'Заново'
    else
      @routes.stations.delete_at(choice)
    end
    rescue StandardError => error
      puts error
    retry
  end

  def create_train
    puts 'Введите номер поезда'
    number = gets.chomp
    if number != 0
      puts 'Ведите тип поезда: '
      puts '1-passenger '
      puts '2-cargo'
      type = gets.to_i
      unless type == 0 || type > 2
        case type
        when 1
          type = 'passenger'
          @trains << PassTrain.new(number, type)
          puts "#{number} пассажирский"
        when 2
          type = 'cargo'
          @trains << CargoTrain.new(number, type)
          puts "#{number} грузовой"
        end
      else
      raise 'С начала'
      end
    else
    raise 'Введите номер заново'
    end
    rescue StandardError => error
      puts error
    retry
  end

  def create_wagon
    puts 'Номер'
    numb = gets.chomp
    if numb != 0
      puts '1-passenger '
      puts '2-cargo'
      type = gets.chomp.to_i
      if type == 1
        number = numb
        puts 'Количество мест в вагоне'
        seats = gets.to_i
        if seats <= 0
          raise 'Не корректные данные'
        else
          @wagons << PassWagon.new(number, seats)
        end
      elsif type == 2
        number  = numb
        puts 'Введите обьем вагона'
        cargo_volume = gets.to_i
        if cargo_volume <= 0
          raise 'Не корректные данные'
        else
          @wagons << CargoWagon.new(number, cargo_volume)
        end
      else
        raise 'passenger or cargo. Создать вагон заново'
      end
    else
      raise 'Ввести заново'
    end
    rescue StandardError => error
      puts error
    retry
  end

  def add_wagon_train
    if @wagons.empty? || @trains.empty?
      puts 'Не имеется поездов или вагонов'
      start
    end
    puts 'Показать поезда из списка'
    list_trains
    puts 'Ввести номер поезда'
    train_number = gets.to_i
    choice_train = @trains[train_number - 1]
    if choice_train.nil?
      raise 'Такого поезда нет'
    else
      puts 'Свободные вагоны'
      list_wagons
      wagon_number = gets.to_i
      choice_wagon = @wagons[wagon_number - 1]
      unless  choice_wagon.nil?
        if (choice_train.type == 'passenger' && choice_wagon.type == 'passenger') || (choice_train.type == 'cargo' && choice_wagon.type == 'cargo')
          choice_train.wagons << choice_wagon
          @wagons.delete(choice_wagon)
        else
          puts 'Неподходящий вагон'
        end
      else
        raise 'Не существующий вагон'
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def unhuk_wagon
    if @trains.empty?
      menu
    else
      puts 'Показать поезда из списка'
      list_trains
      puts 'Ввести номер поезда'
      train_number = gets.to_i
      choice_train = @trains[train_number - 1]
      if choice_train.nil?
        raise 'Такого поезда нет'
      else
        if choice_train.wagons.empty?
          puts 'Вагонов нет'
        else
          @wagons << choice_train.wagons.last
          choice_train.wagons.pop
        end
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def add_rout_train
    if @trains.any? && @routes.stations.any?
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i
      choice_train = @trains[train_number - 1]
      if choice_train.nil?
        raise 'Заново'
      else
        stations = @routes.stations
        stations.each do |station|
          choice_train.rout << station.name
        end
        puts "Поезд на станции #{choice_train.rout[0]}"
        @routes.stations[0].all_trains << choice_train
        @rout_inx = 0
      end
    else
      menu
    end
    rescue StandardError => error
      puts error
    menu
  end

  def go
    if @trains.empty?
      menu
    else
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i - 1
      choice_train = @trains[train_number]
      if  choice_train.nil?
        raise "Заново"
      else
        if choice_train.rout.empty?
          puts 'Поезду не назначен маршрт'
          add_rout_train
        else
          @rout_inx += 1
          puts "Поезд #{choice_train} прибыл на станцию #{choice_train.rout[@rout_inx]}"
          @routes.stations[@rout_inx].all_trains <<  @routes.stations[@rout_inx - 1].all_trains[train_number]
        @routes.stations[@rout_inx - 1].all_trains.delete_at(train_number)
        end
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def back
    if @trains.empty?
      menu
    else
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i - 1
      choice_train = @trains[train_number]
      if  choice_train.nil?
        raise "Выбрать Заново"
      else
        @rout_inx -= 1
        puts "Поезд #{choice_train} прибыл на станцию #{choice_train.rout[@rout_inx]}"
        @routes.stations[@rout_inx].all_trains <<  @routes.stations[@rout_inx + 1].all_trains[train_number]
        @routes.stations[@rout_inx + 1].all_trains.delete_at(train_number)
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def info_stations
    if @stations.empty?
      puts 'Нету созданных станции. Создайте станцию'
      create_station
    end
    puts 'Выберите станцию'
    list_station
    n_station = gets.to_i - 1
    station = @stations[n_station]
    if station.nil?
      raise "Попробуйте заново "
    else
      puts "#{station.name}:"
      if station.all_trains.any?
        station.all_trains.each do |train|
          puts "#{train.number}-#{train.type}"
        end
      else
        puts "На станции #{station.name} поезда отсутствуют"
      end
    end
    rescue StandardError => error
      puts error
    retry
  end

  def trains_on_stations
    if @stations.any? && @trains.any?
      @stations.each do |station|
        if station.all_trains.any?
          station.show_trains do |train|
            puts "Station #{station.name}: Train №- #{train.number}; Train type- #{train.type}; number of wagons- #{train.wagons.size} "
          end
        else
          puts "На станции #{station.name} нет поездов"
        end
      end
    else
      puts 'Создать станцию или поезд'
    end
  end

  def info_cars
    if @trains.any?
      @trains.each do |train|
        puts "К поезду № #{train.number} не прикреплен состав" if train.wagons.empty?
        puts "Train № #{train.number} :"
        train.show_wagons do |wagon|
          puts " Wagon №- #{wagon.number}; Wagon type- #{wagon.type}; Free seats- #{wagon.free_seats}; Busy seats- #{wagon.busy_seats}  " if wagon.type == 'passenger'
          puts " Wagon №- #{wagon.number}; Wagon type- #{wagon.type}; Free volume- #{wagon.free_volume}; Busy volume- #{wagon.busy_volume} " if wagon.type == 'cargo'
        end
      end
    else
      puts 'Создать поезд'
    end
  end

  def download_wagon
    if @trains.any?
      puts 'Выбрать состав'
      list_trains
      n_train = gets.to_i - 1
      train = @trains[n_train]
      if train != nil && train.wagons.any?
        begin
          puts 'Выбрать вагон'
          train.wagons.each.with_index do |wagon, index|
            puts "#{index + 1}) № #{wagon.number}-#{wagon.type}"
          end
          ch_wagon = gets.to_i - 1
          wagon = train.wagons[ch_wagon]
          if wagon != nil
            if wagon.type == 'cargo'
              puts "Free volume: #{wagon.free_volume}"
              puts "Busy volume: #{wagon.busy_volume}"
              print 'Volume Cargo:'
              volume = gets.to_i
              wagon.download_wagon(volume)
            elsif wagon.type == 'passenger'
              wagon.take_a_seat
              puts "Free seats: #{wagon.free_seats}"
              puts "Busy seats: #{wagon.busy_seats}"
            end
          else
            raise 'Не существующий вагон.Заново'
          end
        rescue => e
          puts e
        retry
        end
      else
        puts 'У поезда нет вагонов или несуществующий поезд'
      end
    else
      puts 'Нет поездов'
    end
  end


  private

  def list_station
      @stations.each.with_index do |station, index|
        puts "#{index + 1})  #{station.name} "
      end
   end

  def show_list_stations
    @routes.stations.each.with_index do |station, index|
        puts "#{station.name}"
    end
  end

  def list_trains
      @trains.each.with_index do |train, index|
        puts "#{index + 1}) #{train.number}-#{train.type}"
      end
   end

  def list_wagons
      @wagons.each.with_index do |wagon, index|
        puts "#{index + 1}) #{wagon.number}-#{wagon.type}"
      end
  end
end
