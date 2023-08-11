class Course < ApplicationRecord
  belongs_to :department
  has_many :offerings
  has_and_belongs_to_many :characteristics, join_table: :course_characteristic
end