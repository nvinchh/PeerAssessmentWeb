class Criterion < ActiveRecord::Base
  self.table_name = 'criteria'
  self.inheritance_column = :_type_disabled
  has_many :answers
end