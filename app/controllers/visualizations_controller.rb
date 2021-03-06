class VisualizationsController < ApplicationController
  def index
    @datawarehouse_entity_topology = Visualization.generate_topology('CV-00000015')
    task_ids = Answer.all.pluck(:create_in_task_id).uniq
    tasks = Task.where(id:task_ids).pluck('course_title', 'assignment_title','id')
    @grouped_tasks = tasks.group_by{|task| task[0]}
  end

  def topology
    if params[:assignment_title].present?
      task_ids = Task.where(id: params[:assignment_title], course_title: params[:course_title]).pluck(:id)
    else
      task_ids = Task.where(course_title: params[:course_title])
    end

    datawarehouse_entity_topology = Visualization.generate_topology(task_ids)
    render :json => datawarehouse_entity_topology
  end
end