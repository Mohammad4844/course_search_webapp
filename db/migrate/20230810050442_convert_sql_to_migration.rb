class ConvertSqlToMigration < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE days AS ENUM ('M', 'T', 'W', 'R', 'F', 'S', 'U', 'N/A');
      CREATE TYPE terms AS ENUM ('Fall', 'Winter', 'Summer');
      CREATE TABLE IF NOT EXISTS departments (
        id SERIAL PRIMARY KEY,
        code VARCHAR(255) 
      );
      CREATE TABLE IF NOT EXISTS courses (
          id SERIAL PRIMARY KEY,
          title VARCHAR(255),
          department_id INT,
          code VARCHAR(10),
          credits INT,
          FOREIGN KEY (department_id) REFERENCES departments (id)
      );
      CREATE TABLE IF NOT EXISTS attributes (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255)
      );
      CREATE TABLE IF NOT EXISTS offerings (
          id SERIAL PRIMARY KEY,
          course_id INT,
          year INT,
          term terms,
          crn VARCHAR(6),
          location_type VARCHAR(255),
          delivery_type VARCHAR(255),
          FOREIGN KEY (course_id) REFERENCES courses (id)
      );
      CREATE TABLE IF NOT EXISTS meetings (
          id SERIAL PRIMARY KEY,
          offering_id INT,
          start_time TIME,
          end_time TIME,
          day days,
          location VARCHAR(255),
          type VARCHAR(255),
          FOREIGN KEY (offering_id) REFERENCES offerings (id)
      );
      CREATE TABLE IF NOT EXISTS instructors (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255)
      );
      CREATE TABLE IF NOT EXISTS course_attribute (
          id SERIAL PRIMARY KEY,
          course_id INT,
          attribute_id INT,
          FOREIGN KEY (course_id) REFERENCES courses (id),
          FOREIGN KEY (attribute_id) REFERENCES attributes (id)
      );
      CREATE TABLE IF NOT EXISTS meeting_instructor (
          id SERIAL PRIMARY KEY,
          meeting_id INT,
          instructor_id INT,
          FOREIGN KEY (meeting_id) REFERENCES meetings (id),
          FOREIGN KEY (instructor_id) REFERENCES instructors (id)
      );
    SQL
  end

  def down
    execute <<-SQL
    DROP TABLE IF EXISTS courses, offerings, meetings, departments, attributes,
    instructors, course_attribute, meeting_instructor;
    SQL
  end
end
