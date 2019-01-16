class Validator
  attr_accessor :faculty, :timetable, :formulation, :violations, :final_result
  attr_accessor :min_working_days_cost,
                :isolated_lectures_cost,
                :room_stability_cost, :compactness_cost,
                :room_constraint_cost, :student_load_cost,
                :double_lectures_cost, :travel_cost


  UNI_PR_VALIDATORS = %w(PR1 PR2)

  def initialize(faculty, timetable, formulation)
    @faculty = faculty
    @timetable = timetable
    @formulation = formulation
    @violations = []
    @final_result = {}
    if formulation == 'UD1'
      @min_working_days_cost = 5
      @isolated_lectures_cost = 1
    elsif formulation == 'UD2'
      @min_working_days_cost = 5
      @isolated_lectures_cost = 2
      @room_stability_cost = 1
    elsif formulation == 'UD3'
      @compactness_cost = 4
      @room_constraint_cost = 3
      @student_load_cost = 2
    elsif formulation == 'UD4'
      @min_working_days_cost = 1
      @compactness_cost = 1
      @double_lectures_cost = 1
      @student_load_cost = 1
      @room_constraint_cost = 1
    elsif formulation == 'UD5'
      @min_working_days_cost = 5
      @isolated_lectures_cost = 1
      @compactness_cost = 2
      @travel_cost = 2
      @student_load_cost = 2
    elsif formulation == 'PR1'
      @compactness_cost = 2
      @student_load_cost = 2
      @isolated_lectures_cost = 1
      @room_constraint_cost = 1
    elsif formulation == 'PR2'
      @compactness_cost = 1
      @room_constraint_cost = 1
    end
  end

  def print_costs
    if formulation == 'UD1'
      set_final_result_key :lecture_violations, "Violations on Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflict_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :min_working_days_violations, "Cost of MinWorkingDays (soft): #{costs_on_min_working_days * min_working_days_cost}"
      set_final_result_key :isolated_lectures_violations, "Cost of IsolatedLectures (soft): #{costs_on_isolated_lectures * isolated_lectures_cost}"
    end

    if formulation == 'UD2'
      set_final_result_key :lecture_violations, "Violations of Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflict_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :min_working_days_violations, "Cost of MinWorkingDays (soft): #{costs_on_min_working_days * min_working_days_cost}"
      set_final_result_key :isolated_lectures_violations, "Cost of IsolatedLectures (soft): #{costs_on_isolated_lectures * isolated_lectures_cost}"
      set_final_result_key :room_stability_violations, "Cost of RoomStability (soft): #{costs_on_room_stability * room_stability_cost}"
    end

    if formulation == 'UD3'
      set_final_result_key :lecture_violations, "Violations of Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflict_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :curriculum_compactness_violations, "Cost of CurriculumCompactness (soft): #{costs_on_curriculum_compactness * @compactness_cost}"
      set_final_result_key :room_constraints_violations, "Cost of RoomConstraints (soft): #{costs_on_room_constraints * @room_constraint_cost}"
      set_final_result_key :student_load_violations, "Cost of StudentLoad (soft): #{costs_on_student_load * student_load_cost}"
    end

    if formulation == 'UD4'
      set_final_result_key :lecture_violations, "Violations of Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflict_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_constraints_violations, "Violations of RoomConstraints (hard): #{costs_on_room_constraints}"
      set_final_result_key :room_capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :min_working_days_violations, "Cost of MinWorkingDays (soft): #{costs_on_min_working_days * min_working_days_cost}"
      set_final_result_key :curriculum_compactness_violations, "Cost of CurriculumCompactness (soft): #{costs_on_curriculum_compactness * compactness_cost}"
      set_final_result_key :double_lectures_violations, "Cost of DoubleLectures (soft): #{costs_on_double_lectures * double_lectures_cost}"
      set_final_result_key :student_load_violations, "Cost of StudentLoad (soft): #{costs_on_student_load * student_load_cost}"
    end

    if formulation == 'UD5'
      set_final_result_key :lecture_violations, "Violations of Lectures (hard) : #{costs_on_lectures}"
      set_final_result_key :conflict_violations, "Violations of Conflicts (hard) : #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :min_working_days_violations, "Cost of MinWorkingDays (soft): #{costs_on_min_working_days * min_working_days_cost}"
      set_final_result_key :curriculum_compactness_violations, "Cost of CurriculumCompactness (soft): #{costs_on_curriculum_compactness * compactness_cost}"
      set_final_result_key :student_load_violations, "Cost of StudentLoad (soft): #{costs_on_student_load * student_load_cost}"
      set_final_result_key :travel_distance_violations, "Cost of TravelDistance (soft): #{costs_on_travel_distance * travel_cost}"
      set_final_result_key :isolated_lectures_violations, "Cost of IsolatedLectures (soft): #{costs_on_isolated_lectures * isolated_lectures_cost}"
    end

    if formulation == 'PR1'
      set_final_result_key :lectures_violations, "Violations of Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflicts_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_constraints_violations, "Violations of RoomConstraints (hard): #{costs_on_room_constraints}"
      set_final_result_key :capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :curriculum_compactness_violations, "Cost of CurriculumCompactness (soft): #{costs_on_curriculum_compactness * compactness_cost}"
      set_final_result_key :student_load_violations, "Cost of StudentLoad (soft): #{costs_on_student_load * student_load_cost}"
      set_final_result_key :isolated_lectures_violations, "Cost of IsolatedLectures (soft): #{costs_on_isolated_lectures * isolated_lectures_cost}"
    end

    if formulation == 'PR2'
      set_final_result_key :lectures_violations, "Violations of Lectures (hard): #{costs_on_lectures}"
      set_final_result_key :conflicts_violations, "Violations of Conflicts (hard): #{costs_on_conflicts}"
      set_final_result_key :availability_violations, "Violations of Availability (hard): #{costs_on_availability}"
      set_final_result_key :room_occupation_violations, "Violations of RoomOccupation (hard): #{costs_on_room_occupation}"
      set_final_result_key :room_constraints_violations, "Violations of RoomConstraints (hard): #{costs_on_room_constraints}"
      set_final_result_key :capacity_violations, "Cost of RoomCapacity (soft): #{costs_on_room_capacity}"
      set_final_result_key :curriculum_compactness_violations, "Cost of CurriculumCompactness (soft): #{costs_on_curriculum_compactness * compactness_cost}"
    end

  end

  def print_total_cost
    message = ""
    violations = 0
    total_cost = 0

    violations = costs_on_lectures + costs_on_conflicts + costs_on_availability + costs_on_room_occupation
    if formulation == 'UD4' || formulation == 'PR1' || formulation == 'PR2'
      violations = violations + costs_on_room_constraints
    end
    message += "Violations #{violations}," if violations > 0
    if formulation == 'UD1'
      total_cost = costs_on_room_capacity + costs_on_min_working_days * min_working_days_cost + costs_on_isolated_lectures * isolated_lectures_cost
    elsif formulation == 'UD2'
      total_cost = costs_on_room_capacity + costs_on_min_working_days * min_working_days_cost + costs_on_isolated_lectures * isolated_lectures_cost + costs_on_room_stability * room_stability_cost
    elsif formulation == 'UD3'
      total_cost = costs_on_room_capacity + costs_on_curriculum_compactness * compactness_cost + costs_on_room_constraints * room_constraint_cost + costs_on_student_load * student_load_cost
    elsif formulation == 'UD4'
      total_cost = costs_on_room_capacity + costs_on_min_working_days * min_working_days_cost + costs_on_curriculum_compactness * compactness_cost + costs_on_double_lectures * double_lectures_cost + costs_on_student_load * student_load_cost
    elsif formulation == 'UD5'
      total_cost = costs_on_room_capacity + costs_on_min_working_days * min_working_days_cost + costs_on_curriculum_compactness * compactness_cost + costs_on_isolated_lectures * isolated_lectures_cost + costs_on_travel_distance * travel_cost + costs_on_student_load * student_load_cost
    elsif formulation == 'PR1'
      total_cost = costs_on_room_capacity + costs_on_curriculum_compactness * compactness_cost + costs_on_student_load * student_load_cost + costs_on_isolated_lectures * isolated_lectures_cost
    elsif formulation == 'PR2'
      total_cost = costs_on_room_capacity + costs_on_curriculum_compactness * compactness_cost
    end
    message += "Total Cost = #{total_cost}"
    set_final_result_key :total_cost, "Total Cost: #{total_cost}"
    puts message
  end

  def print_violations
    if formulation == 'UD1'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_capacity
      print_violations_on_min_working_days
      print_violations_on_isolated_lectures
    elsif formulation == 'UD2'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_capacity
      print_violations_on_min_working_days
      print_violations_on_room_stability
    elsif formulation == 'UD3'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_capacity
      print_violations_on_curriculum_compactness
      print_violations_on_student_load
      print_violations_on_room_constrains
    elsif formulation == 'UD4'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_constrains
      print_violations_on_room_capacity
      print_violations_on_min_working_days
      print_violations_on_curriculum_compactness
      print_violations_on_double_lectures
    elsif formulation == 'UD5'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_capacity
      print_violations_on_min_working_days
      print_violations_on_curriculum_compactness
      print_violations_on_student_load
      print_violations_on_travel_distance
    elsif formulation == 'PR1'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_constrains
      print_violations_on_room_capacity
      print_violations_on_curriculum_compactness
      print_violations_on_double_lectures
      print_violations_on_separated_lectures
    elsif formulation == 'PR2'
      print_violations_on_lectures
      print_violations_on_conflicts
      print_violations_on_availability
      print_violations_on_room_occupation
      print_violations_on_room_constrains
      print_violations_on_room_capacity
      print_violations_on_curriculum_compactness
      print_violations_on_double_lectures
      print_violations_on_separated_lectures
    end
  end

  def costs_on_lectures
    cost = 0
    faculty.courses.times do |c|
      lectures = 0
      faculty.periods.times do |p|
        if timetable.tt[c][p] != 0
          lectures = lectures + 1
        end
      end
      checked_lectures = UNI_PR_VALIDATORS.include?(formulation) ? faculty.course_vect[c].get_covered_time_slots : faculty.course_vect[c].lectures
      if lectures < checked_lectures
        cost = cost + (checked_lectures - lectures)
      elsif lectures > checked_lectures
        cost = cost + (lectures - checked_lectures)
      end
    end
    cost
  end

  def costs_on_conflicts
    cost = 0
    for c1 in 0..(faculty.courses - 1) do
      for c2 in (c1 + 1)..(faculty.courses - 1) do
        if faculty.conflict?(c1, c2)
          faculty.periods.times do |p|
            if timetable.tt[c1][p] != 0 && timetable.tt[c2][p] != 0
              cost = cost + 1
            end
          end
        end
      end
    end
    cost
  end

  def costs_on_availability
    cost = 0
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        if timetable.tt[c][p] != 0 && !faculty.available?(c, p)
          cost = cost + 1
        end
      end
    end
    cost
  end

  def costs_on_room_occupation
    cost = 0
    faculty.periods.times do |p|
      (1..faculty.rooms).each do |r|
        if timetable.room_lecture(r, p) > 1
          cost = cost + (timetable.room_lecture(r, p) - 1)
        end
      end
    end
    cost
  end

  def costs_on_room_capacity
    cost = 0
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = timetable.tt[c][p]
        if r != 0 && faculty.room_vect[r].capacity < faculty.course_vect[c].students
          cost = cost + (faculty.course_vect[c].students - faculty.room_vect[r].capacity)
          break
        end
      end
    end
    cost
  end

  def costs_on_min_working_days
    cost = 0
    faculty.courses.times do |c|
      if timetable.working_days[c] < faculty.course_vect[c].min_working_days
        cost = cost + faculty.course_vect[c].min_working_days - timetable.working_days[c]
      end
    end
    cost
  end

  def costs_on_isolated_lectures
    cost = 0
    ppd = faculty.periods_per_day
    faculty.curricula.times do |g|
      faculty.periods.times do |p|
        if timetable.curriculum_period_lectures[g][p] > 0
          if p % ppd == 0
            if timetable.curriculum_period_lectures[g][p + 1] == 0
              cost = cost + timetable.curriculum_period_lectures[g][p]
            elsif p % ppd == ppd - 1
              if timetable.curriculum_period_lectures[g][p - 1] == 0
                cost = cost + timetable.curriculum_period_lectures[g][p]
              elsif timetable.curriculum_period_lectures[g][p + 1] == 0 && timetable.curriculum_period_lectures[g][p - 1] == 0
                cost = cost + timetable.curriculum_period_lectures[g][p]
              end
            end
          end
        end
      end
    end
    cost
  end

  def costs_on_curriculum_compactness
    cost = 0
    faculty.curricula.times do |g|
      faculty.days.times do |d|
        cost = cost + timetable.curriculum_daily_windows(g, d)
      end
    end
    cost
  end

  def costs_on_room_stability
    cost = 0
    faculty.courses.times do |c|
      if timetable.used_room_no(c) > 1
        cost = cost + timetable.used_room_no(c) - 1
      end
    end
    cost
  end

  def costs_on_double_lectures
    cost = 0
    faculty.courses.times do |c|
      faculty.days.times do |d|
        cost = cost + timetable.daily_double_lectures_cost(c, d)
      end
    end
    cost
  end

  def costs_on_room_constraints
    cost = 0
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = timetable.tt[c][p]
        if r != 0 && faculty.room_constraint?(c, r)
          cost = cost + 1
        end
      end
    end
    cost
  end

  def costs_on_student_load
    cost = 0
    faculty.curricula.times do |g|
      faculty.days.times do |d|
        if timetable.curriculum_daily_lectures[g][d] > 0
          if timetable.curriculum_daily_lectures[g][d] < faculty.min_lectures
            cost = cost + (faculty.min_lectures - timetable.curriculum_daily_lectures[g][d])
          elsif timetable.curriculum_daily_lectures[g][d] > faculty.max_lectures
            cost = cost + timetable.curriculum_daily_lectures[g][d] - faculty.max_lectures
          end
        end
      end
    end
    cost
  end

  def costs_on_travel_distance
    cost = 0
    faculty.curricula.times do |g|
      faculty.periods.times do |p|
        if timetable.curriculum_period_lectures[g][p] > 0
          cost = cost + timetable.curriculum_period_lectures[g][p]
        end
      end
    end
    cost
  end

  def print_violations_on_lectures
    faculty.courses.times do |c|
      lectures = 0
      faculty.periods.times do |p|
        if timetable.tt[c][p] != 0
          lectures = lectures + 1
        end
      end

      checked_lectures = UNI_PR_VALIDATORS.include?(formulation) ? faculty.course_vect[c].get_covered_time_slots : faculty.course_vect[c].lectures

      if lectures < checked_lectures
        print_and_save_message "[H] Too few lectures for course #{faculty.course_vect[c].name}"
      elsif lectures > checked_lectures
        print_and_save_message "[H] Too many lectures for course #{faculty.course_vect[c].name}"
      end
    end
  end

  def print_violations_on_conflicts
    (0..(faculty.courses - 1)).each do |c1|
      ((c1 + 1)..(faculty.courses - 1)).each do |c2|
        if faculty.conflict?(c1, c2)
          faculty.periods.times do |p|
            if timetable.tt[c1][p] != 0 && timetable.tt[c2][p] != 0
              print_and_save_message "[H] Courses #{faculty.course_vect[c1].name} and #{faculty.course_vect[c2].name} have both a lecture at period #{p} (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
            end
          end
        end
      end
    end
  end

  def print_violations_on_availability
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        if timetable.tt[c][p] != 0 && !faculty.available?(c, p)
          print_and_save_message "[H] Course #{faculty.course_vect[c].name} has a lecture at unavailable period #{p} (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
        end
      end
    end
  end

  def print_violations_on_room_occupation
    faculty.periods.times do |p|
      (1..faculty.rooms).each do |r|
        if timetable.room_lectures[r][p] > 1
          message = "[H] #{timetable.room_lectures[r][p]} lectures in room #{faculty.room_vect[r].name} the period (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
          message += " [#{timetable.room_lectures[r][p]} violations]"
          print_and_save_message message
        end
      end
    end
  end

  def print_violations_on_room_capacity
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = timetable.tt[c][p]
        if r != 0 && faculty.room_vect[r].capacity < faculty.course_vect[c].students
          print_and_save_message "[S(#{faculty.course_vect[c].students - faculty.room_vect[r].capacity})] Room #{faculty.room_vect[r].name} to small for course #{faculty.course_vect[c].name} the period #{p} (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
        end
      end
    end
  end

  def print_violations_on_min_working_days
    faculty.courses.times do |c|
      if timetable.working_days[c] < faculty.course_vect[c].min_working_days
        print_and_save_message "[S(#{min_working_days_cost})] The course #{faculty.course_vect[c].name} has only #{timetable.working_days[c]} days of lecture"
      end
    end
  end

  def print_violations_on_isolated_lectures
    ppd = faculty.periods_per_day
    faculty.curricula.times do |g|
      faculty.periods.times do |p|
        if timetable.curriculum_period_lectures[g][p] > 0
          if ((p % ppd == 0) && timetable.curriculum_period_lectures[g][p + 1] == 0) || (p % ppd == ppd - 1 && timetable.curriculum_period_lectures[g][p - 1] == 0) || (((p % ppd != 0) && (p % ppd != ppd - 1) && timetable.curriculum_period_lectures[g][p + 1] == 0 && timetable.curriculum_period_lectures[g][p - 1] == 0))
            print_and_save_message "[S(#{isolated_lectures_cost})] Curriculum #{faculty.curricula_vect[g].name} has an isolated lecture at period #{p} (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
          end
        end
      end
    end
  end

  def print_violations_on_curriculum_compactness

    faculty.curricula.times do |g|
      faculty.days.times do |d|
        if (w = timetable.curriculum_daily_windows(g, d)) > 0
          print_and_save_message "[S(#{compactness_cost * w})] Curriculum #{faculty.curricula_vect[g].name} : [#{g}] has #{w} time windows in day #{d}"
        end
      end
    end

  end

  def print_violations_on_room_stability
    faculty.courses.times do |c|
      if timetable.used_room_no(c) > 1
        print_and_save_message "[S(#{timetable.used_room_no(c) * room_stability_cost})] Course #{faculty.course_vect[c].name} uses #{timetable.used_room_no(c)} different rooms"
      end
    end
  end

  def print_violations_on_double_lectures
    faculty.courses.times do |c|
      faculty.days.times do |d|
        unless timetable.daily_double_lectures_cost(c, d).zero?
          print_and_save_message "[S(#{double_lectures_cost})] The course #{faculty.course_vect[c].name} has non-double lecture in day #{d}"
        end
      end
    end
  end

  def print_violations_on_room_constrains
    violation_string = ''
    if formulation == 'UD4' || formulation == 'PR1' || formulation == 'PR2'
      violation_string += '[H]'
    else
      violation_string += "[S(#{room_constraint_cost})]"
    end
    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = timetable.tt[c][p]
        if r != 0 && faculty.room_constraint?(c, r)
          print_and_save_message "#{violation_string} Course #{faculty.course_vect[c].name} has a lecture in room #{faculty.room_vect[r].name}"
        end
      end
    end
  end

  def print_violations_on_student_load
    faculty.curricula.times do |g|
      faculty.days.times do |d|
        if timetable.curriculum_daily_lectures[g][d] > 0
          diff = faculty.min_lectures - timetable.curriculum_daily_lectures[g][d]
          if diff > 0
            print_and_save_message "[S(#{student_load_cost * diff})] Curriculum #{faculty.curricula_vect[g].name} has #{timetable.curriculum_daily_lectures[g][d]} lectures (too few) in day #{d}"
          end
          diff = timetable.curriculum_daily_lectures[g][d] - faculty.max_lectures
          if diff > 0
            print_and_save_message "[S(#{student_load_cost * diff})] Curriculum #{faculty.curricula_vect[g].name} has #{timetable.curriculum_daily_lectures[g][d]} lectures (too many) in day #{d}"
          end
        end
      end
    end
  end

  def print_violations_on_travel_distance
    faculty.curricula.times do |g|
      faculty.periods.times do |p|
        if (t = timetable.curriculum_travel_cost(g, p)) > 0
          print_and_save_message "[S(#{travel_cost * t})] Curriculum #{faculty.curricula_vect[g].name} has #{t} travelling in period #{p} (day #{p / faculty.periods_per_day}, timeslot #{p % faculty.periods_per_day})"
        end
      end
    end
  end

  def print_violations_on_separated_lectures
    faculty.courses.times do |c|
      indexes = []
      violated = false
      faculty.periods.times do |p|
        if timetable.tt[c][p] != 0
          indexes << p
        end
      end
      if indexes.length > 1
        (indexes.length - 1).times do |i|
          violated = true and break if (indexes[i + 1] - indexes[i]) != 1
        end
      end
      print_and_save_message "[H] Course #{faculty.course_vect[c].name} has gaps!" if violated
    end
  end

  def print_and_save_message(message)
    puts message
    violations << message
  end

  def set_final_result_key(key, value)
    final_result[key] = value
  end

end