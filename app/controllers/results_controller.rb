require 'csv'
class ResultsController < ApplicationController
  before_action :authorize_admin_or_prof, unless: -> { Rails.env.development? || Rails.env.test? }
  def evaluate_scores(scores_values)
    total_score = 0
    split_scores = []
    scores_values.each do |value|
      score_attribute = ScoresAttribute.find(value.attribute_id)
      split = {}
      split['feature_name'] = score_attribute.feature
      split['feature_score'] = score_attribute.feature_weight * value.feature_score
      total_score += split['feature_score']
      split_scores.append(split)
    end
    [total_score, split_scores]
  end

  def check_restrictions (project , student)
    restrictions = project.sponsor_restrictions
    restriction_list = []
    restrictions.each do |item|
      type = item.restriction_type
      if student[type] == item.restriction_val
        restriction_list.append(item.restriction_type + ' ' + item.restriction_val)
      end
    end
    restriction_list
  end

  def check_preference(project, student)
    preferences = project.sponsor_preferences
    preference_list = []
    preference_total = 0
    preferences.each do |item|
      type = item.preference_type
      if student[type] == item.preference_val
        preference_total += item.bonus_amount
        preference_list.append(item)
      end
    end
    [preference_total, preference_list]
  end

  def index
    @semesters = Project.pluck(:semester).uniq
    @projects = Project.pluck(:name)
    @courses = Course.all

    @projects_by_semester = {}

    @semesters.each do |semester|
      projects_for_semester = Project.where(semester: semester).pluck(:name)
      @projects_by_semester[semester] = projects_for_semester
    end

     
    @selected_semester = params[:semester]

    @selected_project = params[:project]

    if Rails.env.test? && defined?(Cucumber)
      @projects = ['Project 1', 'Project 2']
      @projects_by_semester['Fall 2023'] = ['Project 1', 'Project 2']
      @selected_project = 'Project 1'
    end

    @selected_course = params[:course]

    scores = []
    project = nil
    if @selected_semester.present? and @selected_project.present?
      project = Project.where(:name => @selected_project, :semester => @selected_semester).first
      if project.present?
        scores = ScoresEntity.where(:project_id => project.project_id)
      else
        flash[:error] = "Project and Semester Doesn't Match"
      end
    end

    @results = get_results(scores, project, @selected_course)
    
    @results.sort_by!{|item| -item['total_score']}
  end

  def export
    semester = params[:semester]
    project_name = params[:project]
    course_id = params[:course]


    scores = []
    project = nil

    if semester.present? and project_name.present?
      project = Project.where(:name => project_name, :semester => semester).first
      if project.present?
        scores = ScoresEntity.where(:project_id => project.project_id)
      else
        flash[:error] = "Project and Semester Doesn't Match"
        return
      end
    end

    results = get_results(scores, project, course_id)

    results.sort_by!{|item| -item['total_score']}
    projectid = project.project_id

    respond_to do |format|
      format.html
      format.csv { send_data to_csv(projectid,results), filename: "#{semester+'_'+project_name}-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"}
    end
  end

  private

  def get_results(scores, project, course_id)

    results = []
    scores.each do |scoreEntity|
      
      student = scoreEntity.student
      if course_id.present?
        if student.course.course_id != course_id.to_i
          next
        end
      end
      result = {}
      result['student'] = student.user
      scores_values = ScoresValue.where(:scores_id => scoreEntity.scores_id)
      total_score, split_scores = evaluate_scores(scores_values)
      result['split_scores'] = split_scores

      preference_score, preference_list = check_preference(project, student)
      total_score += preference_score
      result['preference_list'] = preference_list
      if preference_list.any?
        result['preference_list'] = preference_list
      end

      restriction_list = check_restrictions(project , student)
      result['restriction_list'] = restriction_list
      if restriction_list.any?
        total_score = 0
      end

      result['total_score'] = total_score.round(2)

      results.append(result)
    end
    results
  end

  def to_csv (project_id, list)
    restrictions = SponsorRestriction.where(project_id: project_id)
    preferences = SponsorPreference.where(project_id: project_id)

    restriction_cols = restrictions.map { |restriction| "Restriction:#{restriction.restriction_type}-#{restriction.restriction_val}" }
    preference_cols = preferences.map { |preference| "Preference:#{preference.preference_type}-#{preference.preference_val}" }

    score_names = ScoresAttribute.pluck(:feature).uniq
    score_names.sort!
    CSV.generate do |csv|
      csv << ['Student_name' , 'Professor', 'Course', *preference_cols, *restriction_cols, *score_names , 'Total_Scores']
      list.each do |result|
        if result
          row = []
          row.append result['student'].first_name + ' ' + result['student'].last_name

          #professor col
          student = result['student'].student
          course = student.course
          if course.professor
            row.append student.course.professor.user.first_name + ' ' + student.course.professor.user.last_name
          else
            row.append 'No Professor Assigned for Course'
          end

          #course col
          row.append 'CSCE ' + course.course_number.to_s + '-' + course.section.to_s + '-' + course.semester
          
          #preference_col
          preferences.each do |preference|
            type = preference.preference_type
            if student[type] == preference.preference_val
              row.append(preference.bonus_amount)
            else
              row.append(nil)
            end
          end

          #restriction col
          restrictions.each do |restriction|
            type = restriction.restriction_type
            if student[type] == restriction.restriction_val
              row.append(restriction.restriction_val)
            else
              row.append(nil)
            end
          end

          split_scores = result['split_scores']
          split_scores.sort_by {|item| item['feature_name']}.each do |score|
            row.append score['feature_score']
          end

          row.append result['total_score']
          csv << row
        end
      end
    end
  end
end
