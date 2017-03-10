class UsersController < ApplicationController

  def index
    task_ids = Answer.where('score!=?','null').pluck(:create_in_task_id).uniq
    tasks = Task.where(id:task_ids).pluck('course_title', 'assignment_title','id')
    @grouped_tasks = tasks.group_by{|task| task[0]}


    @aggregate_metrics = generate_aggregate_metrics
    @course_review_pairs_distribution = Task.coursewise_review_pairs_distribution(['EZ-00004018'])
    @criterion_score_frequency = Task.score_frequency_by_criterion('EZ-00004018', 'EZ-00001929')

  end

  def course_review_pairs_distribution
    if params[:assignment_title].present?
      task_ids = Task.where(id: params[:assignment_title], course_title: params[:course_title]).pluck(:id)
    else
      task_ids = Task.where(course_title: params[:course_title])
    end

    course_review_pairs_distribution = Task.coursewise_review_pairs_distribution(task_ids)
    render :json => course_review_pairs_distribution

  end

  def criterion_wise_score_distribution
    assignment_id = nil
    if params[:assignment_title].present?
      assignment_id = params[:assignment_title]
    else
      task_ids = Task.where(course_title: params[:course_title])
    end

    if params[:criterion_id].present?
      criterion_id = params[:criterion_id]
    end

    criterion_score_frequency = Task.score_frequency_by_criterion(assignment_id, criterion_id)
    render :json => criterion_score_frequency
  end
  private
  def generate_aggregate_metrics
    aggregate_metrics = {}
    aggregate_metrics[:num_students] = Actor.students.count
    aggregate_metrics[:num_instructors] = Actor.instructors.count
    aggregate_metrics[:num_reviews] = Task.reviews.count
    aggregate_metrics[:num_submissions] =  Task.submissions.count

    return aggregate_metrics
  end
end
