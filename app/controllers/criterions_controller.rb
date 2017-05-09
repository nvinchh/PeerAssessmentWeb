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

  def comments_volume
    if params[:criterion_ids].present?
      criterion_ids = params[:criterion_ids]
      task_ids = [params[:assignment_title]]
      num_split = params[:number_split]
      criterions = Criterion.where(id: criterion_ids).pluck('title','id')
      answers = Answer.where( criterion_id: criterion_ids, create_in_task_id: task_ids ).order(:assessee_actor_id).pluck('assessee_actor_id','criterion_id','comment')

      criterion_volume_hash = {}
      criterion_volume_hash[:series] = []
      criterion_volume_hash[:num_split_series] = []
      criterion_volume_hash[:legends] = criterions.map{|c| c[0]}
      criterion_ids.each do |criterion_id|
        criterion_answers = answers.select{|ans| ans[1] == criterion_id}
        criterion_volume_hash[:xaxis] = (1..criterion_answers.length).map{|i| i.to_s}
        name = criterions.select{|c| c[1] == criterion_id}.first[0]
        temp_hash = { name: name, type: 'line', smooth: true, itemStyle: {normal: {areaStyle: {type: 'default'}}}}
        temp_hash[:data] = criterion_answers.map{|ans| ans[2].present? ? ans[2].length: 0}.sort()
        criterion_volume_hash[:series] << temp_hash
      end

    end
    render :json => criterion_volume_hash
  end
end