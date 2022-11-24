# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @quantiti
    end

    def new_obj
      @quantiti += 1
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.new_obj
    end
  end
end
