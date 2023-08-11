class Meeting < ApplicationRecord
  belongs_to :offering
  has_and_belongs_to_many :instructors, join_table: :meeting_instructor
end