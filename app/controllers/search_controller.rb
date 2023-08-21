class SearchController < ApplicationController
  def search
    search_params = filtered_params

    departments = filtered_params[:departments] || []
    course_codes = filtered_params[:course_codes] || []
    characteristics = filtered_params[:characteristics] || []
    availabilities = filtered_params[:availabilities] || []

    offerings = filtered_offerings(departments, course_codes, characteristics, availabilities)

    offerings = offerings.includes(course: [ :department, :characteristics ],  meetings: :instructors )
    
    render json: offerings, include: {
      course: { 
        include: {
          department: { only: :code },
          characteristics: { only: :name}
        },
        only: [ :code, :title, :credits ]
      },
      meetings: { 
        include: {
          instructors: { only: :name }
        },
        only: [ :day, :start_time, :end_time, :location ]
      }
    }, only: [ :crn ]
  end

  private

  def filtered_params
    params.permit(
      :departments => [],
      :course_codes => [],
      :availabilities => [
        :day,
        :start_time,
        :end_time
      ],
      :characteristics => []
    )
  end

  def filtered_offerings(departments, course_codes, characteristics, availabilities)
    # find courses first - filter the course_codes, departements, characteristics
    courses = Course.joins(:department)
                    .left_outer_joins(:characteristics)
    courses = courses.where(code: course_codes) if course_codes.any?
    courses = courses.where(departments: {code: departments}) if departments.any?
    courses = courses.where(characteristics: {name: characteristics}) if characteristics.any?
    courses = courses.distinct

    offerings = Offering.where(course: courses)
    
    # filter meetings that fall into availabilties 
    if availabilities.any?
      meeting_conditions = []
      availabilities.each do |a|
        meeting_conditions << Meeting.where(
          day: a[:day],
          start_time: a[:start_time]..a[:end_time],
          end_time: a[:start_time]..a[:end_time]
        )
      end
      meetings = meeting_conditions.reduce(:or)

      # offerings, & their meeting counts that satisfy the availibilties
      filtered_meetings = meetings.group(:offering_id)
                                    .select(:offering_id, 'COUNT(*) AS count')
                                    .to_a.index_by(&:offering_id)
      # offerings, & their all meetings counts (excluding 'N/A' / online async)
      all_meetings = Meeting.group(:offering_id)
                            .select(:offering_id, 'COUNT(*) AS count')
                            .where.not(start_time: nil)                   
                            .to_a.index_by(&:offering_id)
      # get the offerings that have:
      # COUNT(meetings that sastisfy availabilty) == COUNT(meetings, ignoring online ones)
      offering_ids = []
      filtered_meetings.each do |offering_id, offering_group|
        if all_meetings[offering_id].count == offering_group.count
          offering_ids << offering_id
        end
      end
      # filter the offerings that satisfy availabilties
      offerings = offerings.where(id: offering_ids)
    end
    offerings = offerings.distinct
    offerings
  end
end
