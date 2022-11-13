# frozen_string_literal: true

module NameCompany
  def name_company=(name)
    @name_company = name.capitalize
  end

  def name_company
    @name_company
  end
end
