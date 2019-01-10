class Room
  attr_accessor :name, :capacity, :location

  def initialize(element)
    return if element.blank?
    @name = element.attribute('id').value.strip
    @capacity = element.attribute('size').value.to_i
    @location = element.attribute('building').value.to_i
  end

end