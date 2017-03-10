class Actor < ActiveRecord::Base
  self.table_name = 'actor'
  scope :students, -> { where(role: 'student') }
  scope :instructors, -> { where(role: 'instructor') }
end