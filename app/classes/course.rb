class Course
  attr_accessor :name, :teacher, :lectures,
                :students, :min_working_days,
                :double_lectures, :course_time_slots, :apply_breaks

  def initialize(element, course_time_slots = 1, apply_breaks = false)
    @name = element.attribute('id').value.strip
    @teacher = element.attribute('teacher').value.strip
    @lectures = element.attribute('lectures').value.to_i
    @min_working_days = element.attribute('min_days').value.to_i
    @students = element.attribute('students').value.to_i
    @double_lectures = ['yes', 'True'].include?(element.attribute('double_lectures').value) ? true : false
    @course_time_slots = course_time_slots > 0 ? course_time_slots : 1
    @apply_breaks = apply_breaks.nil? ? false : apply_breaks
  end

  def get_covered_time_slots
    return covered_slots_with_breaks if apply_breaks
    covered_slots
  end

  def covered_slots
    lectures * course_time_slots
  end

  def covered_slots_with_breaks
    case lectures.to_i
    when 0,1,2
      time_breaks = 0
    when 3, 4
      time_breaks = 1
    else
      time_breaks = 2
    end
    covered_slots + time_breaks
  end

end