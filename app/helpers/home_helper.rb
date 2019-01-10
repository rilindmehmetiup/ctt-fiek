module HomeHelper
  VALIDATIONS = %w(PR1 PR2)
  def get_validation_options
    VALIDATIONS.map {|validation| [validation, validation]}
  end

  def current_timestamp
    Time.now.to_i
  end

end
