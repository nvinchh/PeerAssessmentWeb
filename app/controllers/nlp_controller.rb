class NlpController < ApplicationController
  def index
    task_ids = Answer.all.pluck(:create_in_task_id).uniq
    tasks = Task.where(id:task_ids).pluck('course_title', 'assignment_title','id')
    @grouped_tasks = tasks.group_by{|task| task[0]}

    @str = Nlp.generate_tile_chart(['CV-00000015'])
  end

  def change_tile_chart
    if params[:assignment_title].present?
      task_ids = Task.where(id: params[:assignment_title], course_title: params[:course_title]).pluck(:id)
    else
      task_ids = Task.where(course_title: params[:course_title])
    end
    tile_chart_link = Nlp.generate_tile_chart(task_ids)
    render :json => tile_chart_link

  end

end