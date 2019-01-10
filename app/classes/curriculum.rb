class Curriculum
  attr_accessor :name, :members

  def initialize(element)
    @members = []
    @name = element.attribute('id').value
  end

  def size
    members.length
  end

  def add_member(member)
    members.push(member)
  end

  def get_member(index)
    members[index]
  end

end