module Format
  FORMAT = /^\w{3}.\w{2}$/i

  def valid?
    validate!
  rescue
    false
  end

  private

  def validate!
    raise 'number is not validate' if number !~ FORMAT
    true
  end
end
