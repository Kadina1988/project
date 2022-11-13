# frozen_string_literal: true

module Format
  FORMAT = /^\w{3}.\w{2}$/i.freeze

  def valid?
    validate!
  rescue StandardError
    false
  end

  private

  def validate!
    raise 'number is not validate' if number !~ FORMAT

    true
  end
end
