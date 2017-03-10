class CriterionsController < ApplicationController
  def criterion_for_task
    if params[:assignment_id].present?
      task_ids = [params[:assignment_id]]
    else
      task_ids = Task.where(course_title: params[:course_title]).pluck(:id)
    end
    criterion_ids = Answer.where('create_in_task_id = ? and score != ?',task_ids, 'null').pluck('criterion_id')
    criterions = Criterion.where(id: criterion_ids).pluck('title','id')
    render :json => criterions
  end
end