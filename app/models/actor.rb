class Actor < ActiveRecord::Base
  scope :students, -> { where(role: 'student') }
  scope :instructors, -> { where(role: 'instructor') }
end