module Accessors

  def attr_accessor_with_history(*args)
    args.each do |arg|
      name = "@#{arg}".to_sym
      define_method(arg) { instance_variable_get(name) }
      define_method("#{arg}=".to_sym) do |value|
        instance_variable_set("#{name}", value)
        @history ||= {}
        @history[name] ||= []
        @history[name] << value
      end
      define_method("#{arg}_history") { @history[name] }
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise "Не совпадает #{value.class} c #{type}" unless type == value.class.to_s
      instance_variable_set(var_name, value)
    end
  end
end

