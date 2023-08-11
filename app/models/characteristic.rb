class Characteristic < ApplicationRecord
  has_and_belongs_to_many :courses, join_table: :course_characteristic
end