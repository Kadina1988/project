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
      create_station2
    end
  end

  def create_rout
    if @stations.length < 2
      puts 'Минимум 2 станции'
      create_station
    end
    list_station
    puts 'выбрать старт'
    stat = gets.to_i
    puts 'Выбрать финиш'
    fin = gets.to_i
    if stat.nil? || fin.nil? || fin == stat
      puts 'Выбрать заново'
      create_rout
    else
      start = @stations[stat - 1]
      puts "Start- #{start.name} "
      finish = @stations[fin - 1]
      puts "Finish-#{finish.name}"
      @routes = Rout.new(start, finish)
    end
  end

  def add_station
    if @stations.empty? || @stations.length < 3
      menu
    else
      puts 'Выберите Номер станции'
      list_station
      choice = gets.to_i
      unless choice.nil?
        station = @stations[choice - 1]
        puts 'Порядковый номер станции в маршруте'
        point = gets.to_i - 1
        if point.nil?
          add_station
        else
          @routes.stations.insert(point, station)
        end
      else
        add_station
      end
    end
  end

  def del_station
    puts 'Выбрать номер станции для удаления'
    @routes.stations.each.with_index do |station, index|
      puts "#{station.name}- #{index + 1}"
    end
    choice = gets.to_i - 1
    if choice.nil?
      del_station
    else
      @routes.stations.delete_at(choice)
    end
    show_list_stations
  end

  def create_train
    puts 'Введите номер поезда'
    number = gets.chomp.to_i
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
      else create_train
      end
    else
      create_train
    end
  end

  def create_wagon
    puts 'Номер'
    numb = gets.to_i
    if numb != 0
      puts 'passenger or cargo'
      type = gets.chomp
      if type == 'passenger'
        number = "#{numb }Pass"
      @wagons << PassWagon.new(number, type)
      elsif type == 'cargo'
        number  = "#{numb }  Cargo"
        @wagons << CargoWagon.new(number, type)
      else create_wagon
      end
    elsif create_wagon
    end
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
    if train_number.nil?
      puts 'Заново'
      add_wagon_train
    else
      choice_train = @trains[train_number - 1]
      puts 'Свободные вагоны'
      list_wagons
      wagon_number = gets.to_i
      unless  wagon_number.nil?
        choice_wagon = @wagons[wagon_number - 1]
        if (choice_train.type == 'passenger' && choice_wagon.type == 'passenger') || (choice_train.type == 'cargo' && choice_wagon.type == 'cargo')
          choice_train.wagons << choice_wagon
          @wagons.delete(choice_wagon)
        else
          puts 'Неподходящий вагон'
        end
      else
        add_wagon_train
      end
    end
  end

  def unhuk_wagon
    if @trains.empty?
      menu
    else
      puts 'Показать поезда из списка'
      list_trains
      puts 'Ввести номер поезда'
      train_number = gets.to_i
      if train_number.nil?
        puts 'Заново'
        unhuk_wagon
      else
        choice_train = @trains[train_number - 1]
        if choice_train.wagons.empty?
          puts 'Вагонов нет'
        else
          @wagons << choice_train.wagons.last
          choice_train.wagons.pop
        end
      end
    end
  end

  def add_rout_train
    if @trains.any? && @routes.stations.any?
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i
      choice_train = @trains[train_number - 1]
      if train_number.nil?
        puts 'Заново'
        add_rout_train
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
  end

  def go
    if @trains.empty?
      menu
    else
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i - 1
      if  train_number.nil?
        puts "Заново"
        go
      else
        choice_train = @trains[train_number]
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
  end

  def back
    if @trains.empty?
      menu
    else
      list_trains
      puts 'Выбрать номер поезда'
      train_number = gets.to_i - 1
      if  train_number.nil?
        puts "Заново"
        back
      else
        @rout_inx -= 1
        choice_train = @trains[train_number]
        puts "Поезд #{choice_train} прибыл на станцию #{choice_train.rout[@rout_inx]}"
        @routes.stations[@rout_inx].all_trains <<  @routes.stations[@rout_inx + 1].all_trains[train_number]
        @routes.stations[@rout_inx + 1].all_trains.delete_at(train_number)
      end
    end
  end

  def info_stations
    if @stations.empty?
      puts 'Нету созданных станции. Создайте станцию'
      create_station
    end
    puts 'Выберите станцию'
    list_station
    n_station = gets.to_i - 1
    if n_station < 0 || n_station > @stations.length
      puts "Попробуйте заново "
      info_stations
    else
      puts "#{@stations[n_station].name}:"
      if @stations[n_station].all_trains.any?
        @stations[n_station].all_trains.each do |train|
          puts "#{train.number}-#{train.type}"
        end
      else
        puts "На станции #{@stations[n_station].name} поезда отсутствуют"
      end
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
