class Faculty
  require 'nokogiri'

  attr_accessor :name, :rooms,
                :courses, :periods,
                :periods_per_day, :curricula, :min_lectures,
                :max_lectures, :days, :slots_per_lecture, :apply_breaks

  attr_accessor :course_vect, :room_vect, :curricula_vect

  attr_accessor :availability, :conflict, :room_constraints

  def initialize(file_name)
    @course_vect = []
    @room_vect = [Room.new('')]
    @curricula_vect = []
    file_path = File.join(Rails.root, 'storage', file_name)
    raise "File does not exist" unless File.exists?(file_path)
    doc = File.open(file_path) {|f| Nokogiri::XML(f)}
    instance = doc.xpath('//instance').first
    raise "Instance missing!" if instance.nil?
    @name = instance.attribute('name').value.strip
    @courses = instance.xpath('//courses').first.elements.length
    @rooms = instance.xpath('//rooms').first.elements.length
    description = instance.xpath('//descriptor').first
    days = description.xpath('//days').first.attribute('value').value.to_i
    @periods_per_day = description.xpath('//periods_per_day').first.attribute('value').value.to_i
    @slots_per_lecture = description.xpath('//slots_per_lecture').first.attribute('value').value.to_i
    @apply_breaks = ['yes', 'True'].include?(description.xpath('//apply_breaks').first.attribute('value').value) ? true : false
    @curricula = instance.xpath('//curricula').first.elements.length
    @min_lectures = description.xpath('//daily_lectures').first.attribute('min').value.to_i
    @max_lectures = description.xpath('//daily_lectures').first.attribute('max').value.to_i
    @periods = days * periods_per_day
    num_unavail_constrains = 0
    num_room_constrains = 0
    instance.xpath('//constraints').first.elements.each do |element|
      if element.attribute('type').value == 'period'
        num_unavail_constrains = num_unavail_constrains + element.elements.length
      elsif element.attribute('type').value == 'room'
        num_room_constrains = num_room_constrains + element.elements.length
      end
    end

    @availability = Array.new(courses) {Array.new(periods, true)}
    @conflict = Array.new(courses) {Array.new(courses, false)}
    @room_constraints = Array.new(courses) {Array.new(rooms+1,false)}

    instance.xpath('//courses').first.elements.each {|element| course_vect << Course.new(element, slots_per_lecture, apply_breaks)}
    instance.xpath('//rooms').first.elements.each {|element| room_vect << Room.new(element)}
    instance.xpath('//curricula').first.elements.each do |element|
      curriculum = Curriculum.new(element)
      element.elements.each_with_index do |child_element, index|
        child = course_index(child_element.attribute('ref').value)
        curriculum.add_member(child)
        index.times do |i|
          c2 = curriculum.members[i]
          conflict[child][c2] = true
          conflict[c2][child] = true
        end
      end
      curricula_vect << curriculum
    end

    instance.xpath('//constraints').first.elements.each do |element|
      if element.attribute('type').value == 'period'
        _course_name = element.attribute('course').value.strip
        element.elements.each do |child|
          day_index = child.attribute('day').value.to_i
          period_index = child.attribute('period').value.to_i
          p = day_index * periods_per_day + period_index
          c = course_index(_course_name)
          availability[c][p] = false
        end
      elsif element.attribute('type').value == 'room'
        _course_name = element.attribute('course').value.strip
        element.elements.each do |child|
          _room_name = child.attribute('ref').value.strip
          c = course_index(_course_name)
          r = room_index(_room_name)
          room_constraints[c][r] = true
        end
      end
    end
    for i in 0..(course_vect.length-2) do
      for j in (i+1)..(course_vect.length-1) do
        if (course_vect[i].teacher == course_vect[j].teacher)
          conflict[i][j] = true
          conflict[j][i] = true
        end
      end
    end
  end

  def days
    periods / periods_per_day
  end

  def available?(course, person)
    availability[course][person]
  end

  def conflict?(course1, course2)
    conflict[course1][course2]
  end

  def room_constraint?(course, room)
    room_constraints[course][room]
  end

  def course(index)
    course_vect[index]
  end

  def room(index)
    room_vect[index]
  end

  def curriculum(index)
    curricula_vect[index]
  end

  def curriculum_member?(course, curricula)
    curricula_vect[curricula].members.each do |member|
      return true if member == course
    end
    return false
  end

  def room_index(room_name)
    room_vect.each_with_index do |room, index|
      return index if room.name == room_name
    end
  end

  def course_index(course_name)
    course_vect.each_with_index do |course, index|
      return index if course.name == course_name
    end
    return -1
  end

  def curriculum_index(curriculum_name)
    curricula_vect.each_with_index do |curricula, index|
      return index if curricula.name == curriculum_name
    end
    return -1
  end

  def min_slots_per_lecture
    return 1 if slots_per_lecture.zero?
    1 * slots_per_lecture
  end

end