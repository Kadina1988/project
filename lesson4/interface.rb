class Main
  attr_reader :choice, :trains, :routes, :wagons, :station
  def initialize
    @station = []
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
    @station << Stationn.new(name)
    puts "Создана станция #{name}"

  end

  def create_rout
    if @station.length < 2
      puts 'Минимум 2 станции'
      create_station
    end
    puts 'выбать номер станции'
    list_station
    puts 'выбрать старт'
    stat = gets.to_i
    start = @station[stat - 1]
    puts "Start- #{start.name} "
    puts 'выбрать финиш'
    fin = gets.to_i
    finish = @station[fin - 1]
    puts "Finish-#{finish.name}"
    @routes = Rout.new(start, finish)
  end

  def add_station
    puts 'Выберите Номер станции'
    @station = @station - routes.stations
    list_station
    choice = gets.to_i - 1
    name = @station[choice]
    puts 'Порядковый номер станции в маршруте'
    point = gets.to_i - 1
    unless point == 0 && point == @routes.length
      @routes.stations.insert(point, name)
    end
    show_list_stations
    @station << @routes.start << @routes.finish
  end

  def del_station
    puts 'Выбрать номер станции для удаления'
    @routes.stations.each.with_index do |station, index|
      puts "#{station.name}- #{index + 1}"
    end
    choice = gets.to_i - 1
    unless choice == 0
      @routes.stations.delete_at(choice)
    end
    show_list_stations
  end

  def create_train
    puts 'Введите номер поезда'
    number = gets.chomp.to_i
    puts 'Ведите тип поезда'
    type = gets.chomp
    case type
    when 'passenger'
      @trains << PassTrain.new(number, type)
      puts "#{number} пассажирский"
    when 'cargo'
      @trains << CargoTrain.new(number, type)
      puts "#{number} грузовой"

    end
  end

  def create_wagon
    puts 'Номер'
    numb = gets.chomp
    puts 'passenger or cargo'
    type = gets.chomp
    if type == 'passenger'
      number = "#{numb }Pass"
    @wagons << PassWagon.new(number, type)
    elsif type == 'cargo'
      number  = "#{numb }  Cargo"
      @wagons << CargoWagon.new(number, type)
    end
  end

  def add_wagon_train
    if @wagons.empty?
      puts 'Создать вагон'
      create_wagon
    end
    puts 'Показать поезда из списка'
    list_trains
    puts 'Ввести номер поезда'
    train_number = gets.to_i - 1
    choice_train = @trains[train_number]
    puts 'Свободные вагоны'
    list_wagons
    wagon_number = gets.to_i - 1
    choice_wagon = @wagons[wagon_number]
    if (choice_train.type == 'passenger' && choice_wagon.type == 'passenger') || (choice_train.type == 'cargo' && choice_wagon.type == 'cargo')
      choice_train.wagons << choice_wagon
      @wagons.delete_at(wagon_number)
    else
      puts 'Неподходящий вагон'
    end
    p choice_train
  end

  def unhuk_wagon
    puts 'Показать поезда из списка'
    list_trains
    puts 'Ввести номер поезда'
    train_number = gets.to_i - 1
    choice_train = @trains[train_number]
    if choice_train.wagons.empty?
      puts 'Вагонов нет'
    else
      choice_train.wagons.pop
    end
  end

  def add_rout_train
    list_trains
    puts 'Выбрать номер поезда'
    train_number = gets.to_i - 1
    choice_train = @trains[train_number]
    stations = @routes.stations
    stations.each do |station|
      choice_train.rout << station.name
    end
    puts "Поезд на станции #{choice_train.rout[0]}"
    @routes.stations[0].all_trains << choice_train
    @rout_inx = 0
  end

  def go
    list_trains
    puts 'Выбрать номер поезда'
    train_number = gets.to_i - 1
    if  train_number < 0 || train_number == nil || train_number > @trains.length
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


  def back
    list_trains
    puts 'Выбрать номер поезда'
    train_number = gets.to_i - 1
    if  train_number < 0 || train_number == nil || train_number > @trains.length
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

  def info_stations
    if @station.empty?
      puts 'Нету созданных станции. Создайте станцию'
      create_station
    end
    puts 'Выберите станцию'
    list_station
    n_station = gets.to_i - 1
    if n_station < 0 || n_station > @station.length
      puts "Попробуйте заново "
      info_stations
    else
      puts "#{@station[n_station].name}:"
      if @station[n_station].all_trains.any?
        @station[n_station].all_trains.each do |train|
          puts "#{train.number}-#{train.type}"
        end
      else
        puts "На станции #{@station[n_station].name} поезда отсутствуют"
      end
    end
  end

  private

  def list_station
    if @station.any?
      @station.each.with_index do |station, index|
        puts "#{index + 1})  #{station.name} "
      end
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
