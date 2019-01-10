class HomeController < ApplicationController
  include HomeHelper

  def index
  end

  def upload
    begin
      instance_name = "#{current_timestamp}-instance.xml"
      solution_name = "#{current_timestamp}-solution.txt"
      raise "Instance is missing!" if params[:instance].nil?
      raise "Solution is missing!" if params[:solution].nil?
      raise "Validation not allowed!" unless VALIDATIONS.include?(params[:validation])
      @instance_path = Rails.root.join('storage', instance_name)
      @solution_path = Rails.root.join('storage', solution_name)
      File.open(@instance_path, 'wb') {|file| file.write(params[:instance].read)}
      File.open(@solution_path, 'wb') {|file| file.write(params[:solution].read)}
      validate_solution(instance_name, solution_name, params[:validation])
      File.delete(@instance_path)
      File.delete(@solution_path)
    rescue Exception => e
      @error_message = e.message
      File.delete(@instance_path) if File.exists?(@instance_path)
      File.delete(@solution_path) if File.exists?(@solution_path)
    end
  end

  private

  def validate_solution(instance_name, solution_name, validator)
    faculty = Faculty.new(instance_name)
    timetable = Timetable.new(faculty, solution_name)
    validator = Validator.new(faculty, timetable, validator)
    validator.print_violations
    validator.print_costs
    if timetable.warnings > 0
      puts "There are #{timetable.warnings} warnings!"
    end
    validator.print_total_cost
    @violations = validator.violations
    @final_result = validator.final_result
  end

end
