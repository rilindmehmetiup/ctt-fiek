class Timetable
  attr_accessor :warnings, :tt,
                :room_lectures, :curriculum_period_lectures,
                :curriculum_daily_lectures, :course_daily_lectures,
                :working_days, :used_rooms, :faculty

  def initialize(faculty, file_name)
    @faculty = faculty
    @tt = Array.new(faculty.courses) {Array.new(faculty.periods, 0)}
    @room_lectures = Array.new(faculty.rooms + 1) {Array.new(faculty.periods)}
    @curriculum_period_lectures = Array.new(faculty.curricula) {Array.new(faculty.periods)}
    @curriculum_daily_lectures = Array.new(faculty.curricula) {Array.new(faculty.days)}
    @course_daily_lectures = Array.new(faculty.courses) {Array.new(faculty.days)}
    @working_days = Array.new(faculty.courses)
    @used_rooms = Array.new(faculty.courses) {Array.new()}
    @warnings = 0
    file_path = File.join(Rails.root, 'storage', file_name)
    raise "File does not exist" unless File.exists?(file_path)
    File.open(file_path).each do |line|
      elements = line.split(' ')
      break if elements.first == 'Speed' || elements.length < 4
      course_name = elements[0]
      room_name = elements[1]
      day = elements[2].to_i
      period = elements[3].to_i
      c = faculty.course_index(course_name)
      course = faculty.course(c)
      if c == -1
        puts "WARNING: Course doesn't exist #{course_name} (entry skipped)"
        @warnings = warnings + 1
        next
      end
      r = faculty.room_index(room_name)
      if r == -1
        puts "WARNING: Room doesn't exist #{room_name} (entry skipped)"
        @warnings = warnings + 1
        next
      end

      if day >= faculty.days
        puts "WARNING: Day doesn't exist #{day} (entry skipped)"
        @warnings = warnings + 1
        next
      end

      if period >= faculty.periods_per_day
        puts "WARNING: Period doesn't exist #{period} (entry skipped)"
        @warnings = warnings + 1
        next
      end

      p = day * faculty.periods_per_day + period
      if tt[c][p] != 0
        puts "WARNING: Repeated entry #{course_name} #{room_name} #{day} #{period} (entry skipped)"
        @warnings = warnings + 1
        next
      end
      course.get_covered_time_slots.times do |i|
        tt[c][p + i] = r
      end
    end
    update_redundant_data
  end

  def room_lecture(i, j)
    room_lectures[i][j]
  end

  def curriculum_period_lecture(i, j)
    curriculum_period_lectures[i][j]
  end

  def curriculum_daily_lecture(i, j)
    curriculum_daily_lectures[i][j]
  end

  def course_daily_lecture(i, j)
    course_daily_lectures[i][j]
  end

  def working_day(i)
    working_days[i]
  end

  def used_room_no(i)
    used_rooms[i].length
  end

  def used_room(i, j)
    used_rooms[i][j]
  end

  def insert_used_room(i, j)
    used_rooms[i].add(j)
  end

  def update_redundant_data
    (1..faculty.rooms).each do |r|
      faculty.periods.times do |p|
        room_lectures[r][p] = 0
      end
    end

    gn = faculty.curricula
    faculty.curricula.times do |g|
      faculty.periods.times do |p|
        curriculum_period_lectures[g][p] = 0
      end

      faculty.days.times do |d|
        curriculum_daily_lectures[g][d] = 0
      end
    end

    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = tt[c][p]
        if r != 0
          room_lectures[r][p] = room_lectures[r][p] + 1
        end
      end
    end

    faculty.courses.times do |c|
      faculty.curricula.times do |g|
        if faculty.curriculum_member?(c, g)
          faculty.periods.times do |p|
            if tt[c][p] != 0
              curriculum_period_lectures[g][p] = curriculum_period_lectures[g][p] + 1
              d = p / faculty.periods_per_day
              curriculum_daily_lectures[g][d] = curriculum_daily_lectures[g][d] + 1
            end
          end
        end
      end
    end

    faculty.courses.times do |c|
      working_days[c] = 0
      faculty.days.times do |d|
        course_daily_lectures[c][d] = 0
        ((d * faculty.periods_per_day)..(((d + 1) * faculty.periods_per_day) - 1)).each do |p|
          if tt[c][p] != 0
            course_daily_lectures[c][d] = course_daily_lectures[c][d] + 1
          end
        end
        if course_daily_lectures[c][d] >= 1
          working_days[c] = working_days[c] + 1
        end
      end
    end

    faculty.courses.times do |c|
      faculty.periods.times do |p|
        r = tt[c][p]
        if r != 0
          i = 0
          while i < used_rooms[c].length
            break if r == used_rooms[c][i]
            i = i + 1
          end
          if i == used_rooms[c].length
            used_rooms[c] << r
          end
        end
      end
    end

  end

  def curriculum_daily_windows(curriculum, day)
    windows = 0
    ppd = faculty.periods_per_day
    first_day_p = day * ppd
    last_day_p = (day + 1) * ppd - 1
    first_p = first_day_p.dup
    last_p = last_day_p.dup

    return 0 if curriculum_daily_lectures[curriculum][day] < (faculty.min_slots_per_lecture + 1)

    while curriculum_period_lectures[curriculum][first_p] == 0
      first_p = first_p + 1
    end
    while curriculum_period_lectures[curriculum][last_p] == 0
      last_p = last_p - 1
    end
    #puts "First period: #{first_p}, Last period: #{last_p}"
    ((first_p + 1)..(last_p - 1)).each do |p|
      if curriculum_period_lectures[curriculum][p] == 0
        windows = windows + 1
      end
    end
=begin
    if curriculum == 5
      puts "Curriculum Day: #{day}"
      puts "Curriculum daily lectures: #{curriculum_daily_lectures[curriculum].inspect}"
      puts "Curriculum periods per day: #{curriculum_period_lectures[curriculum]}"
      puts "Windows: #{windows}"
      abort('Here')
    end
=end
    windows
  end

  def daily_double_lectures_cost(course, day)
    cost = 0
    ppd = faculty.periods_per_day
    first_day_p = day * ppd
    last_day_p = ((day + 1) * ppd) - 1
    if course_daily_lectures[course][day] < 2 || !faculty.course_vect[course].double_lectures
      return cost
    end
    (first_day_p..last_day_p).each do |period|
      if !(tt[course][period]).zero? && ((period == last_day_p || tt[course][period + 1] != tt[course][period]) && (period == first_day_p || tt[course][period - 1] != tt[course][period]))
        cost = cost + 1
      end
    end
    cost
  end

  def curriculum_travel_cost(curricula, period)
    cost = 0
    return 0 if period % faculty.periods_per_day == faculty.periods_per_day - 1
    faculty.curricula_vect[curricula].members.length.times do |a1|
      c1 = faculty.curricula_vect[curricula].members[a1]
      r1 = tt[c1][period]
      if r1 != 0
        faculty.curricula_vect[curricula].members.length.times do |a2|
          c2 = faculty.curricula_vect[curricula].members[a2]
          r2 = tt[c2][period + 1]
          if r2 != 0 && faculty.room_vect[r1].location != faculty.room_vect[r2].location
            cost = cost + 1
          end
        end
      end
    end
  end

end