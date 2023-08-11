class Instructor < ApplicationRecord
  has_and_belongs_to_many :meetings, join_table: :meeting_instructor
end