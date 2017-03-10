class Criterion < ActiveRecord::Base
  self.table_name = 'criterion'
  self.inheritance_column = :_type_disabled
  has_many :answers
end