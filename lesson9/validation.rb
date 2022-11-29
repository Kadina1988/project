module Validation
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, type, arg = "")
      @validations ||= []
      rule = { name: name,type: type, arg: arg }
      @validations << rule
    end
  end

  module InstanceMethods

    def validate!
      self.class.validations.each do |rule|
        rule.each do |type, params|
          value = get_instance_var_by_name(params[:name])
          send(type, value, params[:arg])
        end
      end
    end

    def valid?
      validate!
      true
    rescue => e
      puts e
      false
    end

    protected

    def presence(value)
      raise "Значение #{value} не должно быть пустым" if value.nil? || value.empty?
    end

    def format(value, format)
      raise "Значение #{value} не соответствует формату #{format}" if value !~ format
    end

    def type(value, attribute_class)
      raise "Значение #{value} не соответствует классу #{attribute_class}" unless value.is_a? (attribute_class)
    end

    def get_instance_var_by_name(name)
      var_name = "@#{name}".to_s
      instance_variable_get(var_name)
    end
  end
end
