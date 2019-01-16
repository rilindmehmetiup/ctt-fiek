class Course
  attr_accessor :name, :teacher, :lectures,
                :students, :min_working_days,
                :double_lectures, :course_time_slots, :apply_breaks, :validator

  def initialize(element, course_time_slots = 1, apply_breaks = false, validator = nil)
    @name = element.attribute('id').value.strip
    @teacher = element.attribute('teacher').value.strip
    @lectures = element.attribute('lectures').value.to_i
    @min_working_days = element.attribute('min_days').value.to_i
    @students = element.attribute('students').value.to_i
    @double_lectures = ['yes', 'True'].include?(element.attribute('double_lectures').value) ? true : false
    @course_time_slots = course_time_slots > 0 ? course_time_slots : 1
    @apply_breaks = apply_breaks.nil? ? false : apply_breaks
    @validator = validator
  end

  def get_covered_time_slots
    return 1 unless Validator::UNI_PR_VALIDATORS.include?(validator)
    return covered_slots_with_breaks if apply_breaks
    covered_slots
  end

  def covered_slots
    lectures * course_time_slots
  end

  def covered_slots_with_breaks
    time_breaks = 0
    if validator == 'PR1' && lectures.to_i > 1
      if lectures.to_i == 2
        time_breaks = 1
      elsif lectures.to_i % 2 != 0
        time_breaks = (lectures.to_i - (lectures.to_i / 2))
      else
        time_breaks = (lectures.to_i + 2 / 2)
      end
    end
    if validator == 'PR2' && lectures.to_i > 1
      if lectures.to_i % 2 != 0
        time_breaks = (lectures.to_i - 1) / 2
      else
        time_breaks = (lectures.to_i - 2) / 2
      end
    end
    total = covered_slots + time_breaks.to_i
    return total
  end

end