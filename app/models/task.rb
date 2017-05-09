class Task < ActiveRecord::Base
  scope :submissions, -> { where(task_type: 'submission') }
  scope :reviews, -> { where(task_type: 'review') }
  has_many :answers, :foreign_key => 'create_in_task_id', :primary_key => 'id', :class_name => 'Answer'

  def self.coursewise_review_pairs_distribution(task_ids)
    answers = Answer.where(create_in_task_id: task_ids).order(:score).where('score != ?', 'null').pluck(:assessor_actor_id, :assessee_actor_id, :score)
    answers_grouped_by_score = answers.group_by{|answer| answer[2]}
    course_review_pairs_distribution = {}
    course_review_pairs_distribution[:scores] = []
    course_review_pairs_distribution[:num_review_reviewee_pairs] = []
    answers_grouped_by_score.each do |key,value|
      course_review_pairs_distribution[:scores] << key
      course_review_pairs_distribution[:num_review_reviewee_pairs] << value.group_by{|answer| [answer[0],answer[1]]}.keys.size
    end
    return course_review_pairs_distribution
  end

  def self.score_frequency_by_criterion(task_id, criterion_id, assignment_name = nil)
    task = Task.find(task_id)
    answers = task.answers.order(:score).where('score != ? and criterion_id = ?', 'null',criterion_id).pluck(:assessor_actor_id, :assessee_actor_id, :score)
    answers_grouped_by_score = answers.group_by{|answer| answer[2]}
    criterion_score_frequency = []
    answers_grouped_by_score.each do |key,value|
      criterion_score_frequency << {name: 'Score = ' + key.to_s, value: value.size}
    end
    return criterion_score_frequency
  end
end